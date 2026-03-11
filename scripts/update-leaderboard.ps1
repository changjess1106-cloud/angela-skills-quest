$leaderboard = @( @{name="Angela-1";score=50}, @{name="Angela-2";score=45} )
$leaderboard | ConvertTo-Json | Out-File "C:\workspace\angela-skills-quest\docs\data\skills-leaderboard.json"