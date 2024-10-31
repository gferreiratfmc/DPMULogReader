# Check if ImportExcel module is installed
$module = Get-InstalledModule -Name ImportExcel -ErrorAction SilentlyContinue
 
# If module is not installed, install it
if (-not $module) {
    Install-Module -Name ImportExcel -Scope CurrentUser -Force
}

$DPMU_LOG_READER="C:\Users\gferreira\source\repos\DPMULogReader\x64\Release\DPMULogReader.exe"

#Import-Csv -Path "C:\DPMU_LOG\DPMU_CAN_LOG_DPMU_PROTO_FUNCTIONAL_SN000001_20241025_140842.hex.csv" | Export-Excel -Path "C:\DPMU_LOG\xls\DPMU_CAN_LOG_DPMU_PROTO_FUNCTIONAL_SN000001_20241025_140842.xlsx"
$DPMU_LOG_DIR="C:\DPMU_LOG"
$DPMU_LOG_CSV="$DPMU_LOG_DIR\csv"
$DPMU_LOG_XLS="$DPMU_LOG_DIR\xls"
$DPMU_LOG_PROCESSED="$DPMU_LOG_DIR\processed"

cd $DPMU_LOG_DIR
foreach( $LOG_FILE in Get-ChildItem -Path "$DPMU_LOG_DIR\*.hex" )
{
	
	Write-Host "Processing $LOG_FILE"
	
	& $DPMU_LOG_READER $LOG_FILE
	$FILE_NAME=( Get-Item $LOG_FILE).Basename
	
	#Write-Host "Change . to , in $LOG_FILE.csv > $DPMU_LOG_CSV\$FILE_NAME.csv"
	(Get-Content "$LOG_FILE.csv").Replace( '.', ',') | Set-Content "$DPMU_LOG_CSV\$FILE_NAME.csv"
	
	#Write-Host "Convert $DPMU_LOG_CSV\$FILE_NAME.csv to $DPMU_LOG_DIR\xls\$FILE_NAME.xlsx"
	$data = Import-Csv -Path "$DPMU_LOG_CSV\$FILE_NAME.csv" -Delimiter "`t"
	$data | Export-Excel "$DPMU_LOG_DIR\xls\$FILE_NAME.xlsx" -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow
	
	#Write-Host "Removing $DPMU_LOG_CSV\$FILE_NAME.csv"
	del "$DPMU_LOG_CSV\$FILE_NAME.csv"
	del "$LOG_FILE.csv"
	Compress-Archive "$LOG_FILE"  -DestinationPath "$LOG_FILE.zip --force"
	del "$LOG_FILE"
	
	Write-Host "\n\n*************** OPEN EXCEL FILE: start $DPMU_LOG_DIR\xls\$FILE_NAME.xlsx"	
	Write-Host -NoNewLine 'Press any key to continue...'
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
	start $DPMU_LOG_DIR\xls\$FILE_NAME.xlsx
	
}





#$data = Import-Csv -Path "C:\DPMU_LOG\DPMU_CAN_LOG_DPMU_PROTO_FUNCTIONAL_SN000001_20241030_150705_2.hex.csv" -Delimiter "`t"
#$data | Export-Excel "C:\DPMU_LOG\xls\DPMU_CAN_LOG_DPMU_PROTO_FUNCTIONAL_SN000001_20241030_150705_2.xlsx" -AutoSize -AutoFilter -FreezeTopRow -BoldTopRow

