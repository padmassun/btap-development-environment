# BTAP Development Workflow
This document contains the workflow on how to work with BTAP Measures and the BTAP Standards Projects. 

## Requirements
* [BTAP Development Environment](https://github.com/canmet-energy/btap-development-environment) version 2.6.0
* Github personal or organizational account. 
* CircleCI account (Optional)

# BTAP Measures Workflow
This section details how to use github and develop measure within the BTAP workflow. A prerequisite is reading and understanding the [Measure Writing Guide](http://nrel.github.io/OpenStudio-user-documentation/reference/measure_writing_guide/)
## 0. Create a Work Issue Ticket<a name="create_a_work_issue_ticket"></a>
Lots of people are working on BTAP. By creating a ticket, you are letting people know what you are working on and what progress you are making. If you do not create a ticket, you will work in isolation and you may be duplicating someone else's work that you do not have to do.  Go here and search the issues to see if work is already being done by someone and message them to see if you can help. Otherwise 

1. Create a new issue ticket by clicking 'create new issue'. 

2. Decribe the issue, and give samples of the error you wish to fix  or the feature that you are adding. Please upload neccesary information to reproduce the error including weather or osm files. 

3. Describe your approach and how you are going to test it. 

**Take note of the issue number that is generated from the website. You will need this later. **

 
## 1. Fork Repository
1. Make sure you are logged into GitHub with your account.
2. Go to the [BTAP Measures]( https://github.com/canmet-energy/btap) 
3. Click the Fork button on the upper right-hand side of the repositors page.

Thats it. You now have a copy of the original repository in your GitHub account 

## 2. Making a Local Clone 
Assuming that your username is john_doe you can now clone your repository to your computer by issuing this command in a BTAP-DE terminal terminator. 
```
git clone https://github.com/john_doe/btap.git
```
This will download your repository to your computer. If you were in the /home/osdev folder, you will notice that a new folder called 'btap was created. Go into that folder by typing:
```
cd btap
```
Then issue the command
```bash
bundle install
```


## 3. Adding a Remote
You will need to tell your github repository where it came from. This is called adding a remote and this will make getting updates from other developers who work off NRCan's repository easier.  To add a remote for the BTAP Measures project. You will first want to be in the btap cloned folder. if you are not already and type: 
```
git remote add upstream https://github.com/canmet-energy/btap.git
```

##4. Create a Feature Branch
You now need to create a feature branch that you will do your work in. You will want to name the branch using the issue number we created in [Create a Work Issue Ticket](#create_a_work_issue_ticket). For example if your issue number was '123' your branch name should be nrcan_123. To create this branch, you would issue the command while you are in hte btap folder. 
```
git checkout -b nrcan_123
git commit -m'added branch nrcan_123'
git push origin nrcan_123
``` 
If you go to your repository page on github
At this point you will want to go to your btap_task issue and add a comment that you have created a branch to work on 

##5. Commiting Files
As you develop you will modify, add and sometimes delete files. You will want to save your work in chunks often. This can save you time if you take snapshots of your code during development. To do this you must determine the STATUS of your local changes,  ADD your changes, and COMMIT your changes locally and then PUSH your changes to the server. I personally do this daily, but it could be more frequent than that. So at the end of everyt day I do a Status, add, commit and push. 
### Get STATUS
You will need to know what changes you have made to the files. You can use the command status to list all the files that you changed. 
```
git status
```

* **Untracked Files**: Files that are not currently under GIT management. 
* **Changes not staged for commit**: These are files that are under git management but changes have not been staged into a commit. 

### ADDing files to be commited
This command will add files to be staged for commiting. This tells git to group the files you wish to group into a commit. So to add the changes you made to an existing file, to add a new file, or a new folder into the next commit, you issue the command. 
```bash
git add path_to_your_file_or_folder
```
You can use issue the status command again to see what you have added. 

### COMMITing Files
Now you want to name your commit. This bundles all the changes you have made into something that is names and the you can revert to if you screw up your work and you are not sure how you broke things. You can do this by issueing the git commit command: 
```bash
git commit -m'tell a story of what you have just changed' 
```
The '-m' switch allows you to give a description of what you have accomplished. 

### RESET to your last commit
As I mentioned above.. sometime you just want to undo what you did up to your last commit. This happens when you have made so many changes that really did not make sense and you want to get back to your last version. An easy way to do that is using the reset command the following way. Warning: This will delete files and revert all the changes back to your last commit. 
```bash
git reset --hard HEAD
```

### PUSH your changes Online
If you want others to see your work, comment on your code, and generally save your hard work to a secure backed up resource, you need to PUSH your work to your server. This is very easily done by issuing the push command. 
```bash
git push origin nrcan_123
```
It will ask for your username and password. and it should push your changes to your personal repository.  If you go to your git clone https://github.com/john_doe/btap.git repository you should see your branch commit listed as the most recent commit. 

### Keeping Your Fork in Sync (Merging) 
By the way, your forked repository doesnt automatically stay in sync with the original repository; you need to take care of this yourself. After all, in a healthy open source project, multiple contributors are forking the repository, cloning it, creating feature branches, committing changes, and submitting pull requests. I do this daily. 

To keep your fork in sync with the original repository, use these commands:
```bash
git pull upstream master
git push origin master
git merge origin/master
```
You will then need to deal with any conflicts.  Conflicts are when you and someone else have modified the same file. It is your job to reconcile the differences. So you need to look at their changes and your changes and ensure the code is reconciled to satisfy both needs. You can list the conflicted files by issuing a 'git status' command. In these files you will notice a series of '========' to denote their code and your code changes. This may require you to talk to the other author to understand what she was doing. 

Once this is done, you need to ADD the files using the 'git add' command. and then commit and push as above. 

### Adding Tests to your Measure
The [Measure Writing Guide's test section]details how to write tests] You will need a test to include the measure in the BTAP reposity. This ensures that the measure will be tested by everyone and will not break your tests.  Your tests should not simply run the measure but test the output of the measure. For example. If your measure is meant to change the conductance value by x percent, you should run the measure on a model and then programatically scan the resultant model for the wall conductance and ensure that the conductance is x percent of the original. 

### Submitting a Pull request to NRCan