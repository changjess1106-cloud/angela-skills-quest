Add-Type -AssemblyName System.Net.HttpListener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://127.0.0.1:8787/")
$listener.Start()

$agents="docs\data\agents.json"
$queue="docs\data\test-queue.json"

while($listener.IsListening){
$ctx=$listener.GetContext()
$req=$ctx.Request
$res=$ctx.Response

if($req.Url.AbsolutePath -eq "/register-agent"){
$reader=new-object System.IO.StreamReader($req.InputStream)
$body=$reader.ReadToEnd()
$agent=$body | ConvertFrom-Json

$data=Get-Content $agents -Raw | ConvertFrom-Json
$data+=$agent
$data | ConvertTo-Json | Out-File $agents
}

if($req.Url.AbsolutePath -eq "/submit-skill"){
$reader=new-object System.IO.StreamReader($req.InputStream)
$body=$reader.ReadToEnd()
$skill=$body | ConvertFrom-Json

$q=Get-Content $queue -Raw | ConvertFrom-Json
$q+=$skill
$q | ConvertTo-Json | Out-File $queue
}
}
