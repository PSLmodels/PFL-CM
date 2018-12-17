**Setting up Git and PFL-CM**

1. Create a [GitHub](https://github.com) user account.
2. Install Git on your local machine by following steps 1-4 on [Git setup](https://help.github.com/articles/set-up-git/).
3. Tell Git to remember your GitHub password by following steps 1-4 on [password setup](https://help.github.com/articles/caching-your-github-password-in-git/).
4. Sign in to GitHub and create your own [remote repository](https://help.github.com/articles/github-glossary/#remote) (repo) of PFLCM by clicking [Fork](https://help.github.com/articles/github-glossary/#fork) in the upper right corner of the [PFLCM’s GitHub page](https://github.com/PSLmodels/PFL-CM). Select your username when asked “Where should we fork this repository?”
5. From your command line, navigate to the directory on your computer where you would like your local repo to live.
  * Personally, I prefer to use Git Shell (or Powershell) for this, as it’s easier to track branches and file status.
6. Create a local repo by entering at the command line the text after the $. This step creates a directory called PFLCM in the directory that you specified in the prior step:

`$ git clone https://github.com/[your-username-here]/PFLCM.git`

7. From your command line or terminal, navigate to your local PFLCM directory.
8. Make it easier to push your local work to others and pull others’ work to your local machine by entering at the command line:

`$ cd PFLCM`

`PFLCM$ git remote add upstream https://github.com/open-source-economics/PFLCM.git`

**Workflow**

Update to the latest version of the code

`PFLCM$ git checkout master`
`PFLCM$ git fetch upstream`
`PFLCM$ git merge upstream/master` 
`PFLCM$ git push origin master`

Make changes and open a pull request

* First create a new branch

`PFLCM$ git checkout –b [branch-name]`

* Make whatever changes you want. Use `git status` to check which files you have changed.
* Once you have made your changes, save and submit your changes using:
       
`PFLCM$ git add [filename]`
`PFLCM$ git commit –m “[description-of-your-commit]”`
`PFLCM$ git push origin [branch-name]`

* From the GitHub.com user interface, open a [pull request](https://help.github.com/articles/creating-a-pull-request/#creating-the-pull-request).