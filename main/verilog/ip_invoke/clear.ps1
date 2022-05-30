cd $PSScriptRoot

$choice = Read-Host "您现在位于"+$PSScriptRoot"文件夹下，继续将把本文件夹下除了xci文件和本脚本文件以外的其他文件，是否继续？（Y/N）"
if ( ($choice -eq "y") -or ($choice -eq "Y")){
    (Get-ChildItem  -Force -Recurse | Where-Object {($_.Name -notlike "*.xci")-and($_.Name -notlike "*.ps1")`
    -and($_.getType().Name -eq "FileInfo")}).Delete()
}
