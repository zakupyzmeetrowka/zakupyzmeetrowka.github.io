# Buduje zestawienie DĘBINY (bez haseł) i publikuje je na https://zakupyzmeetrowka.github.io/debina/
$ErrorActionPreference = 'Stop'
$env:PATH += ";C:\Program Files\Git\cmd"
$z = "D:\MEETRÓWKA\2026 DĘBINA\Zestawienie – strona (pliki źródłowe)"
$p = Split-Path -Parent $MyInvocation.MyCommand.Path
& "$z\build.ps1" | Out-Null
$h = [IO.File]::ReadAllText("$z\index.html", [Text.Encoding]::UTF8)
$h = [regex]::Replace($h, '\\u003cp\\u003e(?:(?!\\u003c/p\\u003e).)*HAS[ŁL]O(?:(?!\\u003c/p\\u003e).)*\\u003c/p\\u003e', '')
$h = [regex]::Replace($h, '<p>(?:(?!</p>).)*HAS[ŁL]O(?:(?!</p>).)*</p>', '')
if ($h -match 'MeetrowkaIKEA') { throw 'Hasło nadal w pliku – przerywam.' }
$h = $h.Replace('<title>MEETRÓWKA – zestawienie wyposażenia DĘBINA</title>', '<title>Zakupy z MEETRÓWKĄ · Dom w Dębinie</title><meta name="robots" content="noindex,nofollow">')
$doc = '<!doctype html><html lang="pl"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover"><style>:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0;font:14px/1.4 system-ui,-apple-system,sans-serif}img{max-width:100%}[hidden]{display:none!important}</style></head><body>' + $h + '</body></html>'
New-Item -ItemType Directory -Force "$p\debina" | Out-Null
[IO.File]::WriteAllText("$p\debina\index.html", $doc, (New-Object Text.UTF8Encoding $false))
Set-Location $p
$ErrorActionPreference = 'Continue'
git config core.autocrlf false
git add -A 2>$null
git -c user.name="jusorlow-gif" -c user.email="jusorlow-gif@users.noreply.github.com" commit -m ("Dom w Dębinie – aktualizacja " + (Get-Date -Format 'yyyy-MM-dd HH:mm')) -q 2>$null
git push -q 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { throw 'Nie udało się wysłać na GitHub.' }
"Opublikowano: https://zakupyzmeetrowka.github.io/debina/"
