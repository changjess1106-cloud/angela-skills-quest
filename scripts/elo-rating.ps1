$K=32
function UpdateElo($ra,$rb,$sa){
$ea=1/(1+[math]::Pow(10,(($rb-$ra)/400)))
$ra + $K*($sa-$ea)
}
