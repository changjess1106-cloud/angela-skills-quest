$root="C:\workspace\angela-skills-quest"
$data="$root\docs\data"
$rankFile="$data\skill-rankings.json"
$pendingFile="$data\pending-skills.json"
$auditFile="$data\skill-audit.json"
$pocketFile="$data\skill-pocket.json"
$openclawDir="C:\Users\owner11\.openclaw\workspace\skills\imported-safe"

function ReadJson($p){
 if(!(Test-Path $p)){ return @() }
 $raw=Get-Content $p -Raw
 if([string]::IsNullOrWhiteSpace($raw)){ return @() }
 $obj=$raw|ConvertFrom-Json
 if($null -eq $obj){ return @() }
 if($obj -is [System.Collections.IEnumerable] -and $obj -isnot [string]){ return @($obj) }
 return @($obj)
}

function WriteJson($obj,$p){
 $obj|ConvertTo-Json -Depth 20|Out-File $p -Encoding utf8
}

$rankings=ReadJson $rankFile
$pending=ReadJson $pendingFile
$audit=@()
$pocket=ReadJson $pocketFile

foreach($r in $rankings){
 if($null -eq $r -or $null -eq $r.skill){ continue }
 $skill=$r.skill
 $score=[double]$r.score
 $nameSafe = $skill -match "^[a-zA-Z0-9\\-]+$"
 $existsPending = @($pending) | Where-Object { $_.skill -eq $skill } | Select-Object -First 1
 $allowed = $false
 if($score -ge 0.7 -and $existsPending -and $nameSafe){ $allowed = $true }
 $audit += @{ skill=$skill; score=$score; pending=[bool]$existsPending; name_safe=[bool]$nameSafe; allowed=$allowed; audited_at=(Get-Date).ToString("s") }
 if($allowed){
   $target=Join-Path $openclawDir ($skill + ".json")
   $meta=@{
     skill=$skill;
     source="Angela Skills Quest";
     score=$score;
     imported_at=(Get-Date).ToString("s");
     trust="metadata-only";
     execution="manual-review-required"
   }
   $meta|ConvertTo-Json -Depth 10|Out-File $target -Encoding utf8
   $existsPocket = @($pocket) | Where-Object { $_.skill -eq $skill } | Select-Object -First 1
   if(-not $existsPocket){
     $pocket += @{ skill=$skill; score=$score; synced_at=(Get-Date).ToString("s"); target=$target }
   }
 }
}

WriteJson $audit $auditFile
WriteJson $pocket $pocketFile
git -C $root add docs\data
$gs=git -C $root status --porcelain docs\data
if($gs){
 git -C $root commit -m "v27 skill sync audit cycle" | Out-Null
 git -C $root push origin main | Out-Null
}
Write-Host "Skill Sync Complete"
