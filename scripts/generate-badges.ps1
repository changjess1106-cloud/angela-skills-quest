$path="C:\workspace\angela-skills-quest\docs\assets\badges"
New-Item -ItemType Directory -Force -Path $path

Set-Content "$path\badge-brave.svg" '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><circle cx="100" cy="100" r="90" fill="#1f6feb"/><text x="100" y="115" font-size="40" text-anchor="middle" fill="white">勇者</text></svg>'
Set-Content "$path\badge-hero.svg" '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><circle cx="100" cy="100" r="90" fill="#8957e5"/><text x="100" y="115" font-size="40" text-anchor="middle" fill="white">英雄</text></svg>'
Set-Content "$path\badge-king.svg" '<svg xmlns="http://www.w3.org/2000/svg" width="200" height="200"><circle cx="100" cy="100" r="90" fill="#d29922"/><text x="100" y="115" font-size="40" text-anchor="middle" fill="white">王者</text></svg>'