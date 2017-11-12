Clear-Host
$url = 'http://am-orders-prod.azurewebsites.net/api/os/products/ShowOnWeb/en-US'
$startPath = Get-Location
$outpath = Join-Path -Path (Get-Location) -ChildPath '\src\source\_data\marker-pricing.json'

(
    Invoke-WebRequest $url | 
    Select-Object -ExpandProperty Content | 
    ConvertFrom-Json
) | 
#Where-Object { $_.ProductTypeID -eq 1 } |
Select-Object `
    ID,
    Name,
    ProductTypeID,
    @{
        Name = "ProductType"; 
        Expression = { switch($_.ProductTypeID) { 
            1 { "Uprights" }
            2 { "Slants" }
            3 { "Bevels" }
            4 { "Flats" }
            9 { "Bronze" }
            10 { "Bronze Base" }
            default { $_.ProductTypeID } } } }, 
    @{
        Name = "Color"; 
        Expression = { switch($_.ColorID) { 
            1 { "Black" }
            2 { "Gray" }
            3 { "Red" }
            4 { "Bronze" }
            default { "$($_.ColorID)" } } } }, 
    @{
        Name = "Size"; 
        Expression = { switch($_.SizeID) { 
            1 { "2-16x8" }
            2 { "2-20x10" }
            3 { "2-24x12" }
            4 { "16x8" }
            5 { "16x8x3" }
            6 { "20x10" }
            7 { "20x10x3" }
            9 { "20x10x6x4" }
            10 { "20x12x4" }
            11 { "20x16" }
            12 { "24x12" }
            13 { "24x12x3" }
            14 { "24x12x4" }
            15 { "24x12x6x4" }
            16 { "24x14" }
            17 { "24x14x4" }
            18 { "24x16" }
            20 { "28x16x4" }
            21 { "28x18x4" }
            22 { "36x16" }
            25 { "36x12x4" }
            26 { "36x12x8x6" }
            27 { "38x12x4" }
            28 { "48x14x4" }
            29 { "54x16x4" }
            default { $_.SizeID } } } }, 
    BasePrice | 
ConvertTo-Json |
Out-File -FilePath $outpath -Encoding utf8

$projectDir = Join-Path (Get-Location) -ChildPath "src"
Set-Location $projectDir
npm install
.\node_modules\.bin\hexo deploy -g

Set-Location -Path $startPath

Clear-Host

Write-Host "Upload the contents of the '/src/public/' directory to FTP." -ForegroundColor Green
Read-Host -Prompt "Hit any key to continue..."