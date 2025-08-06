@echo off
echo XSLT Transformation Runner
echo ========================
echo.
echo This script will find all XSLT files in the current directory and process them.
echo.

REM Check if xsltproc is available
where xsltproc >nul 2>&1
if %errorlevel% neq 0 (
    echo xsltproc not found. Trying alternative methods...
    echo.
    
    REM Try to use PowerShell instead
    powershell -Command "Get-ChildItem -Filter '*.xslt' | ForEach-Object { Write-Host 'Processing:' $_.Name; try { $xml = [xml](Get-Content 'OrganizationalStructure.xml'); $xslt = [xml](Get-Content $_.FullName); $xsltDoc = New-Object System.Xml.Xsl.XslCompiledTransform; $xsltDoc.Load($xslt); $writer = New-Object System.IO.StringWriter; $xsltDoc.Transform($xml, $null, $writer); Write-Host 'Result:' $writer.ToString() } catch { Write-Host 'Error:' $_.Exception.Message } }"
) else (
    echo Found xsltproc. Processing XSLT files...
    echo.
    
    REM Process each XSLT file
    for %%f in (*.xslt) do (
        echo Processing: %%f
        xsltproc "%%f" OrganizationalStructure.xml
        echo.
    )
)

echo.
echo Processing complete!
pause 