#SECTION 05: COLLABORATION

#-----------------------------------------------------------------------------------
#S05L01 & S05L02 - INTRODUCTION

    #git is distributed but has a centralized workflow.

    #it means every contributor has their own version of the repo,
    #and there is one other version of it that is hosted on the cloud
    #and serves as the main version of it.

    #all versions of the repo can and should take changes made
    #by each other constantly, so that they are kept in sync.
#end

#-----------------------------------------------------------------------------------
#S05L03 - GITHUB

    #by creating a repo on github,
    #and adding a README to it,
    #we automatically create the master branch
    #and the first commit in it.
#end

#-----------------------------------------------------------------------------------
#S05L04 - ADDING COLLABORATORS

    #by default, even on a public repo,
    #only we (the repo owner) can write/push/commit to it.
    #others can only read the repo and its history.

    #to give write access to others, go to the repo's settings
    #then to "manage access" and then invite other people with a github account.
#end

#-----------------------------------------------------------------------------------
#S05L05 - CLONING A REPO

    #once all the collaborators are set,
    #each should clone the repo in their local environment.

    #clone means "copy and download" the repo.

    #the local copy of the repo they will have
    #is the one they'll work on.

    #to clone a repo, go to the repo's homepage in github
    #click the Code button, then pick the download protocol (HTTPS or SSH)
    #then copy the URL provided.

    #then in the local environment, do:
    git clone <url>

    #this will download the entire repository,
    #including all its branches and commits.

    #at this point we have a working local copy of the repo.

    #repos cloned from github also have the HEAD pointer,
    #plus a pointer for every branch.
#end

#-----------------------------------------------------------------------------------
#S05L05 - ORIGIN POINTERS

    #apart from the basic pointers like HEAD or master,
    #repos cloned from github also have "origin pointers".
    #these point to places on the REMOTE repo,
    #that is, on the version of the repo that's on github.

    #so rule of thumb, in most cases,
    #"remote", "origin" and "github" mean the same thing.

    #a new repo created on github has two pointers:
    #origin/HEAD and origin/master,
    #which initially point to the same commit.

    #this happens because, every copy of the repo must come
    #with its own set of pointers.

    #and every local copy should know where are the pointers
    #of the github version pointing to.

    #this allows the history on every version of the repo
    #to evolve independently.

    #however, from a local environment,
    #we cannot switch, checkout, commit, etc to an origin pointer.

    #which is why if we do:
    git branch
    #the origin branches aren't shown.

    #if we do this though:
    git remote -v
    #we'll see a list of remote versions of our repo.

    #this means that, the origin/master pointer in the local repo
    #is the exact same pointer as master in the github repo.
    #same happens with the HEAD pointer.
#end

#-----------------------------------------------------------------------------------
#S05L06 - FETCH

    #local repos are NOT constantly connected to github repos.
    #instead, they signal each other to sync-up from time to time.

    #so, the changes in one are invisible to the other,
    #until the sync-up happens.

    #let's say both the local and the github repos
    #are in sync, and both have one commit A.
    #but then, a new commit B appears in the github repo.

    #in github, master will point to B.
    #in local, both master and origin/master will point to A.

    #we want our local repo
    #to reflect github's up-to-date state, so
    #how do we query the github repo for it?
    #by FETCHING.

    #there are several ways to fetch,
    #all of them should be ran from
    #the local branch which will take the changes.
    #we'll call it the "current local branch"
    #which in this case is master.

    #the most specific option is
    #to choose the remote repo to fetch from
    #and also the branch which will be fetched:
    git fetch <remote_repo> <some_remote_branch>
    #in most cases the remote repo is "origin", so:
    git fetch origin master
    #this fetches github's master into local's origin/master.

    #if we don't specify a branch,
    #we'll fetch all commits from all branches from the remote repo:
    git fetch <remote_repo>
    #for example:
    git fetch origin
    #this fetches github's every <branchX> into local's origin/<branchX>.

    #however, the simplest option
    #which we'll probably want in most cases is just:
    git fetch
    #which assumes that we want all commits
    #from all branches from the origin (github).

    #by running "git fetch" on the previous example
    #the new commit B will be downloaded into local
    #and origin/master will move to point to it.

    #however, the local's master won't move to B.
    #also, the files in our filesystem won't be updated yet.

    #in this state, we say our local and remote branches are diverging.
    #we can see how much they have diverged from each other with:
    git branch -vv

    #in order to have both master (local)
    #and origin/master (github) truly in sync,
    #we need to merge the github into the local.

    #to do so, we just:
    git switch <current_local_branch>
    #in this case:
    git switch master

    #and then:
    git merge <current_remote_branch>
    #in this case:
    git merge origin/master

    #just like in any merge, we might hit conflicts.
    #we resolve them in the usual way.

    #we can verify there's no divergence anymore by running this again:
    git branch -vv
#end

#-----------------------------------------------------------------------------------
#S05L07 - PULL

    #previously we synced our local up-to-date with github
    #by running a fetch followed by a merge.

    #there is a better command, "git pull"
    #which does the fetch + merge
    #in a single step.

    #consider this scenario:
    #first, local and github are synced.
    #both have only one commit Ca:

    #LOCAL'S POV:
    # Ca ← master
    #   ↖ origin/master

    #GITHUB'S POV:
    # Ca ← master

    #then, independently,
    #in local, a new commit Cb is made.
    #and in github, a new commit Cc appears:

    #LOCAL'S POV:
    # Ca ← Cb ← master
    #   ↖ origin/master

    #GITHUB'S POV:
    # Ca ← Cc ← master

    #so we have changes in our github
    #which we want to pull into our local.
    #also, we have local changes ourselves.
    #then how do we pull the remote changes?

    #there are two ways:
    #---- pulling with 3-way merging.
    #---- pulling with rebasing.
#end

#-----------------------------------------------------------------------------------
#S05L07 - PULL WITH 3-WAY MERGE:

    #now if we run
    git pull
    #Cc, which only was in github,
    #will be brought into local.

    #also, the origin/master pointer
    #will move to it:

    #LOCAL'S POV:
    # Ca ← Cb ← master
    #   ↖ Cc ← origin/master

    #so, in local, now it is necessary
    #to merge origin/master into master.

    #so, next, "git pull" will create
    #a new commit Cm whose parents are Cb and Cc
    #(merge conflicts could happen at this point):

    #LOCAL'S POV:
    #              ↙ master
    # Ca ← Cb ← Cm
    #    ↖ Cc ↙
    #        ↖ origin/master

    #our pull with 3-way merge is done!

    #some people argue that pulling with 3-way merge
    #pollutes the history, so there's also the option
    #to rebase instead.
#end

#-----------------------------------------------------------------------------------
#S05L07 - FETCH-ONLY PULLING:

    #here's one cool trick:

    #if we perform a "git pull",
    #we know the first step is fetching commits from github,
    #and the last step is a 3-way merge.

    #this means, if right after "git pull" is done, we do:
    git reset --hard HEAD~1

    #we'll undo the 3-way merge...
    #but we'll keep the downloaded commits from github!

    #this trick can be used if all we want is
    #to undo a bad merge if we made a mistake, and
    #to make our local repo aware of github's up-to-day state,
    #but not actually sync them together.
#end

#-----------------------------------------------------------------------------------
#S05L07 - PULL WITH REBASE:

    #instead of making a new merge commit
    #with both master and origin/master as parents
    #we can rebase master to the tip of origin/master,
    #so it becomes a fast-forwardable scenario.

    #so, if we run:
    git pull -rebase
    #Cc, which only was in github,
    #will be brought into local.

    #also, the origin/master pointer
    #will move to it:

    #LOCAL'S POV:
    # Ca ← Cb ← master
    #   ↖ Cc ← origin/master

    #"git pull -rebase" will now proceed
    #to rebase Cb to come after Cc:

    #LOCAL'S POV:
    # Ca ← Cc ← Cb ← master
    #       ↖ origin/master

    #notice that the pointers actually didn't move.

    #our pull with rebasing is done!

    #pull with rebase gives us a cleaner, linear history,
    #but some people argue against it
    #arguing that it rewrites the history.

    #in the end the better method is a matter of preference.
#end

#-----------------------------------------------------------------------------------
#S05L08 - COMMIT DIFFERENTIAL

    #one quick concept:

    #whenever one branch B
    #is linearly ahead of another branch A,
    #there is a set of commits that are in B
    #and not in A.

    #we call those commits the "differential".

    #in this example, B is ahead of A
    #by a differential of 3 commits:
    #C2, C3 and C4.

    #       ↙ A
    #C0 ← C1 ← C2 ← C3 ← C4
    #                      ↖ B
#end

#-----------------------------------------------------------------------------------
#S05L08 - PUSH

    #consider a scenario where a local branch
    #is linearly ahead of its remote counterpart
    #(for example, if master is ahead of origin/master):

    #LOCAL'S POV:
    #       ↙ origin/master
    #Ca ← Cb ← Cc
    #            ↖ master

    #GITHUB'S POV:
    #Ca ← Cb
    #       ↖ master

    #(in this example, the differential is Cc).

    #we can upload the commit differential to github
    #in order to keep github in sync with our local.

    #also, the branch pointers will be moved accordingly:

    #LOCAL'S POV:
    #            ↙ origin/master
    #Ca ← Cb ← Cc
    #            ↖ master

    #GITHUB'S POV:
    #Ca ← Cb ← Cc
    #            ↖ master

    #that is called "pushing our changes".

    #there are several ways to do it:

    #we may specify the remote repo and the branch to push to:
    git push <remote_repo> <some_remote_branch>
    #for example:
    git push origin master

    #or we may omit the branch and the current one will be used:
    git push <remote_repo>
    #for example, if our current working local branch is master:
    git push origin

    #or we may omit both the repo and the branch,
    #git will assume the remote repo is origin
    #and the branch is the current working local branch:
    git push
#end

#-----------------------------------------------------------------------------------
#S05L08 - REJECTED PUSHES

    #if github's history has diverged from our local
    #because of changes pushed by somebody else,
    #our push could be rejected, since it could
    #overwrite their history.

    #in general, pushes are allowed when local is ahead of remote
    #and rejected when remote is ahead of local.

    #this means, pushes are allowed ONLY when
    #the differential between local and remote
    #contains ONLY local commits.

    #the -f flag exists, which forces a push
    #to be accepted, but it's a BAD PRACTICE
    #and should never be used.

    #the right thing to do in this case is:
    #---- first, pull those changes pushed by someone else into our local.
    #---- then, merge/rebase/squash those changes into our own
    #     (solving conflicts if any).
    #---- finally, retry pushing our latest changes.
#end

#-----------------------------------------------------------------------------------
#S05L09 - STORING CREDENTIALS

    #see S01L06...
#end

#-----------------------------------------------------------------------------------
#S05L10 - SHARING TAGS

    #if our commits have tags (like "v1.0")
    #they are not pushed by default on "git push".

    #we can push a tag explicitly with:
    git push <remote_repo> <tag_name>
    #for example if pushing the "v1.0" tag into origin:
    git push origin v1.0

    #on github, we can see a list of tags on:
    # github.com/<user>/<repo>/tags
    # github.com/<user>/<repo>/releases/tag/<tag_name>

    #to delete a tag from github, do:
    git push <remote_repo> --delete <tag_name>
    #for example if deleting the "v1.0" tag from origin:
    git push origin --delete v1.0

    #don't forget to delete unnecessary tags from local too:
    git tag -d <tag_name>
#end

#-----------------------------------------------------------------------------------
#S05L11 - RELEASES

    #a release is a downloadable package of our program
    #which may or may not include the code itself
    #but will probably include an installable binary of it
    #plus release notes and documentation.

    #if we go to:
    # github.com/<user>/<repo>/releases
    #we'll see the list of releases we've created.

    #to create a new release, we go to:
    # github.com/<user>/<repo>/releases/new

    #in there, we'll be asked to relate the release to a tag
    #(we can choose an existing tag, or create a new one for the latest commit).

    #also, we need to choose a branch to release (usually master)
    #and give the release a title (usually the same as the tag).

    #afterwards, we may write the release notes.

    #finally, we attach a compiled, runnable or installable binary
    #of our program, and mark it as pre-release if it is not
    #production-ready.

    #when we're done, we click on Publish.

    #we can now see (and also edit or delete) our releases
    #in our repo's github page,
    #with the latest release in the homepage.
#end

#-----------------------------------------------------------------------------------
#S05L12 - SHARING BRANCHES

    #just like tags, branches are not pushed to github by default.

    #so if we attempt to "git push" changes
    #on a branch we haven't shared yet,
    #the push will fail.

    #only branches with an origin counterpart
    #(like master has origin/master)
    #can be pushed.

    #those "origin counterpart" branches
    #are called "upstream branches".
    #we can't push a local branch
    #with no "upstream branch".

    #by running this:
    git branch -vv
    #we can see which branches have an upstream and which don't.

    #to see a list of all upstream branches, do:
    git branch -r

    #if we want to share
    #one of our branches with our collaborators, we do:
    git push -u <remote_repo> <local_branch>
    #for example:
    git push -u origin branch2

    #now we can verify the branch has an upstream with:
    git branch -vv
    git branch -r

    #eventually, we won't want to work on the branch anymore.
    #so we can delete it from github with:
    git push -d <remote_repo> <local_branch>
    #for example:
    git push -d origin branch2

    #once again, verify the deletion:
    git branch -vv
    git branch -r

    #don't forget to delete the local branch as well.

    #to do that, first we need to
    #NOT be working on the branch we'll delete:
    git switch <any_other_local_branch>
    #and then
    git branch -d <local_branch_to_delete>
#end

#-----------------------------------------------------------------------------------
#S05L13 - COLLABORATION WORKFLOW

    #if collaborating on some new bugfix/feature
    #one of the collaborators (maybe the project leader?)
    #could create a new branch to work on and then push it.

    #but there's a different workflow which is not
    #centered around one collaborator, but instead
    #it's centered on the repo itself:

    #let's say we're just a regular collaborator,
    #we'll be working on some new code
    #and we might get help from other regular collaborator
    #in the future.
#end

#-----------------------------------------------------------------------------------
#S05L13 - COLLABORATION - CREATING A BRANCH FROM OUR POV

    #from our point of view:

    #we begin by creating the new branch directly on github.

    #in the github repo's homepage, at the code tab,
    #there's a branch selector in the top left.
    #it gives the option to create a new branch.
    #(for this example we'll create one called branch2)

    #once the branch is created in github,
    #we need to fetch it in our local repo, with:
    git fetch

    #but we didn't create a local branch branch2,
    #we just downloaded the upstream branch origin/branch2.

    #we can see that by listing the local branches:
    git branch
    #and listing the upstream branches:
    git branch -r

    #to fix that,
    #we create the local branch manually,
    #then map it to its upstream branch,
    #and then switch to it.

    #we can do all of that with one command:
    git switch -C <local_branch_name> <upstream_branch_name>
    #for example:
    git switch -C branch2 origin/branch2

    #we're done on our side.
#end

#-----------------------------------------------------------------------------------
#S05L13 - COLLABORATION - CREATING A BRANCH FROM THEIR POV

    #now, from our collaborator's point of view.
    #(we'll call them C):

    #they begin by cloning the repo.
    git clone <repo_url>

    #once again, that didn't create the branch branch2,
    #they just downloaded the upstream branch origin/branch2.

    #they can see that by listing the local branches:
    git branch
    #and listing the upstream branches:
    git branch -r

    #they fix that with the same command as before:
    git switch -C <local_branch_name> <upstream_branch_name>
    #for example:
    git switch -C branch2 origin/branch2

    #now we both can work on the bugfix/feature
    #in its dedicated branch.
#end

#-----------------------------------------------------------------------------------
#S05L13 - COLLABORATION - PUSHING A BRANCH FROM OUR POV

    #after some time, both of us will have made commits
    #and the work will be finished.

    #let's say we're the collaborator responsible for
    #consolidating the work and closing the branch.

    #first, we bring the changes made by C into our local:
    git pull
    #(solve conflicts if any)

    #look at the log:
    git log --oneline --all --graph
    #master is behind branch2, so we need to merge.

    #then, merge the branch we worked on (branch2), into master:
    git switch master
    git merge branch2
    #(solve conflicts if any)

    #look at the log:
    git log --oneline --all --graph
    #origin/master is behind master, so we need to push.

    #then push master into origin/master:
    git push

    #the work is done.
#end

#-----------------------------------------------------------------------------------
#S05L13 - COLLABORATION - DELETING A BRANCH FROM OUR POV

    #so now let's delete the branches we don't need anymore:

    #first, from our point of view:

    #we make sure we're not on the branch we're about to delete:
    git switch master
    #we delete it from github:
    git push -d origin branch2
    #we delete it from our local:
    git branch -d branch2
#end

#-----------------------------------------------------------------------------------
#S05L13 - COLLABORATION - DELETING A BRANCH FROM THEIR POV

    #second, from C's point of view:

    #they make sure they're not on the branch they're about to delete:
    git switch master
    #they bring in the latest changes (the work we just merged)
    git pull
    #they delete the branch from their local:
    git branch -d branch2

    #they still keep a pointer to origin/branch2,
    #but that branch was deleted from github.

    #to remove an upstream branch
    #which references a deleted branch, they do:
    git remote prune origin
#end

#-----------------------------------------------------------------------------------
#S05L14 - PULL REQUESTS

    #a pull request (PR) basically means
    #"please pull my branch and try it".

    #it is a way to open a discussion among a dev team
    #and ask them for feedback on a work in progress.

    #if we just pushed some changes,
    #and then go to the repo's homepage in github
    #we can find a button for "Compare & pull request".

    #we may also click on the "Pull requests" tab
    #and hit the "New pull request" button on the right.

    #to create a pull request we must specify:
    #---- a "base" branch (often master).
    #     this is the branch we'll eventually merge our changes into.
    #---- a "compare" branch.
    #     this is the branch we just pushed our changes from.

    #for any new pull request we can verify all the changes we pushed
    #and also write a title and a description of them.

    #at the bottom, we hit the "Create pull request" button.

    #now, at the right side, we may add Reviewers
    #which are collaborators who may inquire about our changes,
    #approve them, reject them, make suggestions, etc.

    #if we are a reviewer, we'll see there are pending reviews for us
    #in the repo's homepage.

    #by clicking on a pending review,
    #and then going to the "Files changed" tab,
    #we'll be able to read all code changes pushed as part of the PR.

    #we can write a comment in any line of code.
    #if we click on "Finish your review",
    #we'll have to choose between requesting more changes,
    #approving the PR or just commenting.

    #if we now go to the "Conversation" tab
    #we can see a timeline of all that has happened
    #since the PR was created.

    #once all reviewers have approved, we can merge the PR.

    #some people believe the PR creator should be the one to merge it
    #because it means that collaborator owns the new feature and is responsible
    #for it.

    #some others believe the PR creator should NOT be able to merge it,
    #only somebody else, with higher rank, should.
    #that way, the need for approvals is enforced.

    #in the end, it's a matter of preference.

    #to merge, we can do:
    #---- regular merge (will fast-forward if possible, 3-way otherwise)
    #---- squash, then merge
    #---- rebase, then merge

    #after merging, we'll be given the option to delete the branch.
    #if we choose so, we'll be given the option to restore it.

    #at this point, in the local environments
    #every collaborator should delete the involved branches
    #if they still have them.
#end

#-----------------------------------------------------------------------------------
#S05L15 - RESOLVING CONFLICTS

    #when merging a PR on github,
    #we might see a message saying:

    #"This branch has conflicts that must be resolved"
    #plus a "Resolve conflicts" button
    #instead of the button for merging the PR.

    #so, we need to resolve the conflicts
    #and for that we can do the following on our local:

    #---- pull the latest code of the branch B we're merging into.
    #---- pull the latest code of the branch A we're working on
    #     (this step might introduce conflicts of its own).
    #---- start a merge of our local branch A into B.
    #---- use the same method (involving p4merge) we've used before
    #     to resolve the conflicts.
    #---- once resolved, complete the merge commit.
    #---- push the merge commit.

    #there's another option.
    #we can resolve the conflicts directly on github.
    #just click the "Resolve conflicts" button.

    #the GUI for resolving conflicts provided by github
    #is not the best. It's similar to vscode's.
    #so, this option is not recommended.

    #once we're done, hit "Mark as resolved" and then "Commit merge".
    #this will take us back to the PR page, with the merge option
    #now working properly.
#end

#-----------------------------------------------------------------------------------
#S05L16 - ISSUES

    #in the github repo's homepage
    #we can click on the "Issues" tab.

    #it tracks all the to-do items that the team will work on eventually.
    #we can see who's working on what,
    #which issues are free to work on
    #and we can also filter and sort the issues by many criterias.

    #we can always create a new issue by clicking "New issue",
    #then give it a title and a description,
    #and then assign somebody to work on it
    #with the "Assignees" section on the right.

    #we can also label the issue by clicking on "Labels" on the right,
    #we can set labels like "bug", "enhancement" and so on.

    #we then hit "Submit new issue" on the bottom.

    #in the next view, there's a section where any collaborator can leave comments.
    #and we can also link the issue with a PR,
    #which is like saying "when this PR is merged, the issue is solved".
#end

#-----------------------------------------------------------------------------------
#S05L17 - CUSTOM LABELS

    #from the repo's homepage in github,
    #select the "Issues" tab and then the "Labels" button.

    #we'll see a list of all labels we can assign to issues.
    #we'll also see a section for creating a new label.

    #for each label, it shows us how many issues marked by it
    #and click on that to see those in detail.
#end

#-----------------------------------------------------------------------------------
#S05L18 - MILESTONES

    #milestones are markers for progress on various issues.
    #every milestone comprises several issues,
    #and the progress on a milestone is
    #how many of those issues are solved.

    #similar to the previous lesson, we go to
    #the repo's homepage, then the "Issues" tab,
    #and then the "Milestones" button, next to the "Labels" button.

    #in the milestones view, we can create a new milestone.
    #new milestones have a title, a due date and a description.

    #then, in the "Issues" tab,
    #we scroll down to the list of issues
    #which has a "Milestone" dropdown.

    #we can checkmark one or more issues
    #and then assign them to a milestone
    #using said dropdown.

    #now, back to the milestones view, we can see
    #the milestone we just assigned issues to
    #will show them as "open".

    #when all issues in a milestone are marked as closed
    #the milestone will show up as 100% complete.
#end

#-----------------------------------------------------------------------------------
#S05L19 - CONTRIBUTING TO OPEN-SOURCE

    #can we contribute to somebody else's repo?
    #first of all, we need to find it on github.
    #if we can't, it means the repo is closed-source
    #so we won't be able to contribute!

    #if we actually find it, however,
    #then we can freely browse and read the code files.
    #so, the repo's owner probably expects help by others.

    #to contribute, we go to the "Issues" tab.
    #then create a new issue which can be a bugfix or a feature
    #or pick one of the open issues.

    #then, at the repo's homepage, click on "fork" at the top-right.
    #this will copy the repo into our own github account.

    #the copy we created is independent of the original,
    #and only we have control of it.

    #once we've forked it, we grab the url from the "Code" button
    #and use it in our local environment to clone the repo:
    git clone <forked_url>

    #now, in our local, we may create a new branch,
    #then, make some code changes, then stage/commit/push them
    #(with its corresponding upstream).

    #afterwards, in our github, we make a PR
    #for the changes we just pushed.

    #from the original repo owner's POV,
    #every time somebody makes a new PR
    #they will see it in their repo's homepage
    #at the "Pull requests" tab.

    #back in our POV,
    #in the PR, we'll see that, by default,
    #github will compare our new branch
    #with the original branch in the original owner's repo.

    #if we go forward from there and create the PR,
    #the original owner will be a reviewer of the PR.

    #a conversation might happen in which the changes
    #are discussed, more changes are requested, etc.
    #until eventually, the owner will be satisfied and 
    #will merge our changes into their repo.
    #(only they can merge, because the repo is theirs!)
#end

#-----------------------------------------------------------------------------------
#S05L20 - KEEPING A FORK UP-TO-DATE - ADDING A BASE REFERENCE

    #all forked repos fall out of sync
    #with their original repos constantly.

    #in fact, in the forked repo's homepage
    #we might see a message like:
    #"This branch is N commits behind <original-coder>:<branch>"

    #to keep them in sync, consider:

    #our local will keep a reference to origin.
    #in this case, origin is our fork, on github.

    #it is possible to add another reference to our local
    #this time, one pointing to the original repo on github.

    #however, this reference will allow us only to pull new code,
    #not to actually push our code to it.

    #to see all references to remote repos
    #known by our local, we do:
    git remote
    #or, to see the pull/fetch and push channels separately:
    git remote -v

    #to add a new reference to a remote repo, we need:
    #---- to choose a name for it
    #     ("base" is a good self-explanatory name).
    #---- the URL of that repo
    #     (same URL we use for "git clone").

    #then we do:
    git remote add <reference_name> <repo_url>
    #for example:
    git remote add base https://github.com/original-coder/original-repo.git

    #afterwards, we can check by running again:
    git remote
    #or:
    git remote -v

    #at this point we'll have a reference to our forked repo (origin)
    #and a reference to the original repo (base).
#end

#-----------------------------------------------------------------------------------
#S05L20 - KEEPING A FORK UP-TO-DATE - FETCHING CHANGES

    #to bring in the newest changes from the original repo, we do:
    git fetch <original_repo_reference>
    #in this case:
    git fetch base

    #now we can check on the status of all branches,
    #including the original repo's ones, with:
    git log --oneline --all --graph

    #our forked repo will probably be behind the original one,
    #for example, master and origin/master
    #could be behind base/master.

    #so at this point (like after other fetch operations)
    #we need to merge the newest changes into our repo
    #(in this case, to merge base/master into master).
    git switch master
    git merge base/master

    #and then, push the changes to our forked repo
    #(in this case, to push master into origin/master).
    git push

    #at this point, master, origin/master and base/master
    #are in sync.
#end

#-----------------------------------------------------------------------------------
#S05L20 - KEEPING A FORK UP-TO-DATE - PREVENTING CONFLICTS

    #master is now in sync.
    #however, since we forked the original repo,
    #we probably have some other branch (say, branch2)
    #where we're working on some changes.

    #we should make sure this branch is always ahead of
    #master, origin/master and base/master,
    #because that will reduce the chance of merge conflicts in the future.

    #we do so by merging master into our working branch
    #after syncing all the master branches:
    git switch <working branch>
    git merge master
    #for example:
    git switch branch2
    git merge master

    #(if our working branch is not shared with anyone,
    #we could also rebase instead of merging.)

    #at this point we might hit conflicts,
    #but it's better to resolve them at this point, locally,
    #instead of hitting them when the original owner
    #attempts to merge our code into theirs.
#end

#-----------------------------------------------------------------------------------
#S05L20 - MANAGING REMOTE REFERENCES

    #to rename a reference, we just do:
    git remote rename <old_name> <new_name>
    #for example to rename "base" to "original":
    git remote rename base original

    #to remove a reference, we do:
    git remote rm <reference_name>
    #for example:
    git remote rm base
#end

#-----------------------------------------------------------------------------------
#S05L21 - COLLABORATION IN VSCODE

    #in the gitlens panel, if we expand our repo's tree
    #we can see if a local branch is ahead of its upstream branch
    #and gives us a button for pushing the changes right there.

    #we can also add new remote references and view our existing ones
    #in the Remotes section a bit below.

    #vscode also auto-performs fetches constantly,
    #so that we can see if we're behind the upstream branches.
#end

#-----------------------------------------------------------------------------------
#S05L22 - COLLABORATION IN GITKRAKEN

    #if we right-click a branch pointer in the main view
    #we can push or pull changes (if any)
    #and also set a new upstream branch for it.

    #by right-clicking on a commit,
    #we can create a tag for it.
    #then we can push the tag to any of the upstreams.

    #in the left sidebar, by clicking on the cloud icon
    #we get a panel for our remote upstreams.
    #in there we can create a new remote and browse the existing ones.

    #there is also a merge icon
    #which takes us to a panel for our pull requests.

    #by right-clicking a branch pointer
    #we can start a PR for it.
    #we get several options like picking a repo, a branch
    #and also writing a title and a description for the PR.
#end

#-----------------------------------------------------------------------------------
#END OF SECTION 05
