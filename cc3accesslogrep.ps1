# フォルダアクセスログ抽出スクリプト
# 特定フォルダ下にある .zip ファイルを解凍する

# 使い方
# 1. スクリプトをダウンロード
# 2. PowerShellを起動
# 3. スクリプトを実行
#    .\cc3accesslogrep.ps1  

# コマンドライン引数からディレクトリのパスを取得
param (
    [string]$inputdir = ".", # デフォルトはカレントディレクトリ
    [string]$outputdir = ".", # デフォルトはカレントディレクトリ
    [string]$tmpdir = ".",
    [string]$kwd = ""
)

# ディレクトリ内のすべての .zip ファイルを取得
$files = Get-ChildItem -Path $inputdir -Filter *.zip

# 各ファイルの名前とサイズを表示
foreach ($file in $files) {
    Write-Output "File: $($file.Name) - Size: $($file.Length) bytes"
    # ファイルを解凍
    Expand-Archive -Path $file.FullName -DestinationPath $tmpdir -Force
}

# $tmpdirにあるファイルをgrepして$kwdを含む行を"outputfile.txt"に出力
$outputFile = Join-Path -Path $outputdir -ChildPath "outputfile.txt"
Get-ChildItem -Path $tmpdir -Recurse | ForEach-Object {
    Select-String -Path $_.FullName -Pattern $kwd -SimpleMatch | ForEach-Object {
        $_.Line | Out-File -FilePath $outputFile -Append
    }
}