#### Modulo 9 - Git

### SLIDE 33 - Logging into a git repository
git init MyNewRepository


### SLIDE 41 - Cloning
git clone https://github.com/wilsonmse/PowerShellCoreWorkshopDemos.git c:\gitroot\powershellCoreWorkshopDemos


### SLIDE 57 - PUSH / PULL
c:
cd gitroot\powershellcoreworkshopdemos

git add .
git add .\file.txt

git status

-- commit
git commit -m "Added file.txt file"

-- change last commit
git commit -m "fixes file.txt file" --ammend

-- remove itens from staging
git rm .\file.txt

git pull 

git add Modulo9-Git.sh


git status

git commit -m "update on module 9"
git push


git fetch

git merge origin/next

git reset


### SLIDE 79 - BRANCHING / MERGING

