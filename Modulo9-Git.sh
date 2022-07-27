#### Modulo 9 - Git

### SLIDE 33 - Logging into a git repository
git init MyNewRepository


### SLIDE 41 - Cloning
c:
cd gitroot
git clone https://github.com/wilsonmse/WorkshopDemo.git


### SLIDE 57 - PUSH / PULL
c:
cd gitroot\workshopdemo



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






################

Create New – git init <<RepositoryName>>
git init MyNewRepository

Clone from another location
git clone https://github.com/anwaterh/MyNewRepository.git

Add a file to staging area
git add .\script.txt

git status


Remove a file from staging (won’t be part of the commit)

git rm .\script.txt –cached


Commit all changes – git commit –m “<<commit message>>”
git commit –m “Altered commit” --amend


git log

git log --oneline


Git clone





git status

Add a new branch – git branch <<branch name>> 

git branch dev
git checkout dev

Create and switch to – git checkout –b <<branchname>>
git checkout –b dev

View all local branches – 
git branch

View local and remote branches
git branch --all

git merge