Add-Type -AssemblyName System.Net.HttpListener
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://*:8787/")
$listener.Start()

Write-Host "AI Agent Gateway Running"

while($listener.IsListening){
$ctx=$listener.GetContext()
$req=$ctx.Request
$res=$ctx.Response

if($req.Url.AbsolutePath -eq "/register-agent"){
 $reader=New-Object IO.StreamReader($req.InputStream)
 $body=$reader.ReadToEnd()
 $agent=$body | ConvertFrom-Json

 $agents=Get-Content "docs/data/agents.json" -Raw | ConvertFrom-Json
 $agents+=$agent
 $agents | ConvertTo-Json -Depth 5 | Out-File "docs/data/agents.json"
}
}
