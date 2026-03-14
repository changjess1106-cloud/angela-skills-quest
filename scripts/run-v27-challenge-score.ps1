$root="C:\workspace\angela-skills-quest"
$data="$root\docs\data"
$rankFile="$data\skill-rankings.json"
$subFile="$data\challenge-submissions.json"
$resultFile="$data\challenge-results.json"

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

$subs=ReadJson $subFile
$rank=ReadJson $rankFile
$results=ReadJson $resultFile

foreach($s in $subs){
 if($null -eq $s){ continue }
 if($s.status -eq "scored"){ continue }
 $chosen=@($s.skills)
 $scores=@()
 foreach($sk in $chosen){
   $hit=@($rank)|Where-Object{ $_.skill -eq $sk }|Select-Object -First 1
   if($hit){ $scores += [double]$hit.score }
 }
 $avg=0
 if($scores.Count -gt 0){ $avg=[math]::Round((($scores|Measure-Object -Average).Average),2) }
 $badge="BRAVE"
if($avg -ge 0.8 -and $scores.Count -ge 3){ $badge="KING" }
elseif($avg -ge 0.65){ $badge="HERO" }
 $results += @{ participant=$s.participant; challenge=$s.challenge; skills=$chosen; average_score=$avg; badge=$badge; scored_at=(Get-Date).ToString("s") }
 $s.status="scored"
}

$results = @($results) | Sort-Object -Property average_score -Descending | Select-Object -First 300
WriteJson $subs $subFile
WriteJson $results $resultFile
git -C $root add docs\data
$gs=git -C $root status --porcelain docs\data
if($gs){
 git -C $root commit -m "v27 challenge scoring cycle" | Out-Null
 git -C $root push origin main | Out-Null
}
Write-Host "Challenge Score Complete"
