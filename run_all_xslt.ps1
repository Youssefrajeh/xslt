# XSLT Transformation Runner
# This script will find all XSLT files in the current directory and process them

Write-Host "XSLT Transformation Runner" -ForegroundColor Green
Write-Host "========================" -ForegroundColor Green
Write-Host ""

# Check if XML file exists
if (-not (Test-Path "OrganizationalStructure.xml")) {
    Write-Host "Error: OrganizationalStructure.xml not found!" -ForegroundColor Red
    exit 1
}

# Get all XSLT files in current directory
$xsltFiles = Get-ChildItem -Filter "*.xslt"
if ($xsltFiles.Count -eq 0) {
    Write-Host "No XSLT files found in current directory." -ForegroundColor Yellow
    exit 1
}

Write-Host "Found $($xsltFiles.Count) XSLT file(s):" -ForegroundColor Cyan
$xsltFiles | ForEach-Object { Write-Host "  - $($_.Name)" -ForegroundColor White }

Write-Host ""
Write-Host "Processing XSLT transformations..." -ForegroundColor Cyan
Write-Host ""

# Load the XML document
try {
    $xmlDoc = [xml](Get-Content "OrganizationalStructure.xml" -Encoding UTF8)
    Write-Host "✓ XML file loaded successfully" -ForegroundColor Green
} catch {
    Write-Host "✗ Error loading XML file: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Process each XSLT file
foreach ($xsltFile in $xsltFiles) {
    Write-Host "Processing: $($xsltFile.Name)" -ForegroundColor Yellow
    Write-Host "-" * 50
    
    try {
        # Load the XSLT document
        $xsltDoc = [xml](Get-Content $xsltFile.FullName -Encoding UTF8)
        
        # Create XSLT processor
        $xsltProcessor = New-Object System.Xml.Xsl.XslCompiledTransform
        $xsltProcessor.Load($xsltDoc)
        
        # Create output writer
        $outputWriter = New-Object System.IO.StringWriter
        
        # Transform
        $xsltProcessor.Transform($xmlDoc, $null, $outputWriter)
        
        # Get the result
        $result = $outputWriter.ToString()
        
        # Display result
        Write-Host "Result:" -ForegroundColor Green
        Write-Host $result -ForegroundColor White
        
        # Save to file
        $outputFile = "output_$($xsltFile.BaseName).xml"
        $result | Out-File -FilePath $outputFile -Encoding UTF8
        Write-Host "✓ Result saved to: $outputFile" -ForegroundColor Green
        
    } catch {
        Write-Host "✗ Error processing $($xsltFile.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
    Write-Host "=" * 50
    Write-Host ""
}

Write-Host "Processing complete!" -ForegroundColor Green
Write-Host "Check the output_*.xml files for the transformation results." -ForegroundColor Cyan 