#SECTION 03: BROWSING HISTORY

#-----------------------------------------------------------------------------------
#S03L01 to S03L02 - INTRODUCTION

    #just a summary of the section here...
    #this section uses the "Venus" repo, included in the course materials.
#end

#-----------------------------------------------------------------------------------
#S03L03 - VIEWING THE HISTORY

    #remember, the whole commit history of the repo
    #can be viewed with "git log"
    #or with "git log --oneline"

    #however, there's more.
    #we can see which files were changed in each commit
    #plus how many inserted/deleted lines we had in each file.
    #to do so, we run:
    git log --stat
    #or:
    git log --oneline --stat

    #the --stat flag counts how many
    #inserted/deleted lines we had per file
    #but it doesn't show the actual text on those lines.
    #to see that, plus a diff for each file, we run:
    git log --patch
    #or:
    git log --oneline --patch
#end

#-----------------------------------------------------------------------------------
#S03L04 - FILTERING THE HISTORY

    #if there are too many commits in the repo's history
    #we might want to show only some, not all of them.

    #(the next commands work with or without the --oneline, --stat or --patch flags)

    #to show only the latest N commits, do:
    git log -N #where N is a number.

    #to show only commits by some author, do:
    git log --author="<author_name>"

    #to show only commits from before or after a date:
    git log --before="YYYY-MM-DD"
    git log --after="YYYY-MM-DD" #"--since" also works.

    #the date string can also be some verbose relative date, like:
    git log --after="yesterday"
    git log --after="1 week ago"
    #among many other options.

    #to show only commits whose comment contains some string:
    git log --grep="<some_string>"

    #to show only commits which introduced some line into some file:
    git log -S"<line_of_text>"

    #to show only commits inbetween two commits:
    git log <older_commit_identifier>..<newer_commit_identifier>
    #where the identifiers are the first 7 digits of the commit's hex ID.

    #to show only commits that modified one file:
    git log <file_path>
    #for example:
    git log hello.txt

    #to add flags to the above command (like --oneline, --patch or --stat):
    git log <--flags> -- <file_path>
    #notice the double dashes between the flags and the file path. for example:
    git log --oneline --patch -- hello.txt
#end

#-----------------------------------------------------------------------------------
#S03L05 - FORMATTING THE LOG

    #the output of "git log" is totally customizable.
    #the command for that is as follows:
    git log --pretty=format:"<custom_string>"

    #where custom_string is any combination of the following tokens:
    #---- %an (author's name)
    #---- %cs (commit date)
    #---- %h (first 7 hex digits of commit ID hash)
    #---- %t (first 7 hex digits of tree ID hash)
    #among many others.
    #there's a full list on https://git-scm.com/docs/git-log#_pretty_formats

    #we can also add color to the output.
    #at any point in the custom_string, write the token:
    #---- %C<color> (for example: %Cgreen) to colorize everything after this token.
    #---- %Creset to stop colorizing after this token.
    #for example: %Cgreen%an%Creset %cs
    #would write the author's name in green
    #followed by the commit date in the default color.
#end

#-----------------------------------------------------------------------------------
#S03L06 - ALIASES

    #let's say in the previous lesson we made
    #a long and convoluted command for customizing the log.

    #that's not easy to memorize, so, we can store it
    #and call it with an alias.

    #to store aliases within git, we do:
    git config --<LEVEL> alias.<aliasname> "<custom_command>"
    #where LEVEL is "system", "global" or "local" as seen before,
    #and aliasname should be without spaces,
    #custom_command should NOT start with "git",
    #and it should use single quotes instead of double quotes.

    #from then on, we can call the alias by running:
    git <aliasname>

    #for example:

    #we can turn the command to unstage the whole staging area
    #into an alias, by doing:
    git config --global alias.unstage "restore --staged ."

    #we can check if our alias was stored by checking:
    git config --global -e

    #and we can run it by typing:
    git unstage
#end

#-----------------------------------------------------------------------------------
#S03L07 - VIEWING A COMMIT

    #we already know that, by running something like:
    git show HEAD~2
    #we'll get details on the commit made 2 commits before the most recent one.

    #those details include a diff for every file changed in the commit.

    #however, if we just want
    #the committed version of any of those files
    #printed on the console, we do:

    git show <commit_identifier>:<file_path>
    #for example:
    git show HEAD~2:somefile.txt

    #or, if we want only a list of the files changed in the commit:
    git show <commit_identifier> --name-only

    #or, same as before, but also showing if each file was added, deleted or modified:
    git show <commit_identifier> --name-status
#end

#-----------------------------------------------------------------------------------
#S03L08 - DIFF BETWEEN TWO COMMITS

    #to get a diff between two specific commits
    #which shows a diff for every file included in them, we do:
    git diff <older_commit_identifier> <newer_commit_identifier>

    #if we want to see only the diff for a single file:
    git diff <older_commit_identifier> <newer_commit_identifier> <file_path>

    #the --name-only and --name-status also work with "git diff"
    #to only show a list of files changed between the commits.
#end

#-----------------------------------------------------------------------------------
#S03L09 - COMMIT CHECKOUT

    #there's a way to completely change the repo in our filesystem
    #so that it becomes identical to how it was at the moment of some commit.

    #this is called "checking out a commit".
    #we do so by running:
    git checkout <commit_identifier>

    #we do this if we want to explore the filesystem at that point in time,
    #to make experiments, tests, etc.

    #after a checkout, the filesystem will be in a "detached-head" state.
    #which will be explained further below.

    #for the moment, it's most important to note that
    #in a detached-head state, WE SHOULD NOT DO ANY COMMITS.
    #this will be clarified below.
    #plus, in a future section, we'll learn of a better alternative called branching.

    #if we run "git log" while checked out,
    #we'd only see the checked out commit and those before it.
    #to see all commits, we'd need to do:
    git log -all

    #in the output of "git log -all"
    #we can see how the branch pointer (for example "master")
    #points to the latest commit,
    #while the head pointer ("HEAD")
    #points to the checked out commit.

    #the detached-head state means that
    #the HEAD pointer and the branch pointer
    #are not both pointing to the latest commit.
    #we say that the HEAD is detached from the branch.

    #to exit the detached-head state
    #and return the repo to normal,
    #we need to checkout the branch pointer:
    git checkout <branch_pointer>
    #for example, if we're on the master branch:
    git checkout master
#end

#-----------------------------------------------------------------------------------
#S03L09 - THE DETACHED-HEAD STATE

    #the purpose of every branch pointer
    #is to keep track of the latest commit in every branch
    #so that git always knows where to attach the next commit for any branch.

    #the purpose of the HEAD pointer
    #is to keep track of which branch or which commit we're working on.
    #the one we're working on, is reflected by the state of the filesystem.

    #if HEAD points to the latest commit in a branch,
    #then we're working on that branch. No problem there.
    #but if it works to any other commit,
    #we are in the detached-head state!

    #(for the next examples, we'll assume we're working
    #on the master branch. although they apply to any other branch too.)

    #in a normal, working repo,
    #the HEAD pointer and the branch pointer
    #both point to the latest commit.

    #the present-day state of the repo is
    #exactly equal to the latest commit.

    #also, the state of the filesystem is
    #equal to the latest commit
    #(plus any uncommitted changes made later).

    #the history of such a repo
    #would be in the shape of a straight line:
    #a sequence of commits.
    #that's a normal vanilla branch in git (in our case, the master branch).

    #in git's branches, every commit points to the previous one.
    #so a normal branch would look like:

    #                   ↙ master
    # C0 ← C1 ← ... ← Cn
    #                   ↖ HEAD

    #by checking out a commit C, we detach the HEAD
    #from the latest commit, and make it point to C.
    #and the state of the filesystem will become identical to C:

    #                  ↙ master
    # C ← C1 ← ... ← Cn
    #  ↖ HEAD

    #if we make a new commit Cb from that point,
    #the new commit would not become master's latest,
    #but instead, it would branch out into a new branch
    #(we'll just call it "newbranch"):

    #     ↙ newbranch
    #   Cb ← HEAD
    #  ↙               ↙ master
    # C ← C1 ← ... ← Cn

    #at some point in the future, HEAD will inevitably
    #go back to master's latest commit:

    #     ↙ newbranch
    #   Cb
    #  ↙               ↙ master
    # C ← C1 ← ... ← Cn
    #                  ↖ HEAD

    #in a future lesson, we'll learn more about branching
    #but for the moment, we'll assume that "newbranch"
    #is not consolidated into an official branch,
    #so, it doesn't have an actual branch pointer:

    #   Cb
    #  ↙               ↙ master
    # C ← C1 ← ... ← Cn
    #                  ↖ HEAD

    #see how there aren't any arrows pointing to Cb?
    #since no commit and no pointer actually point to Cb,
    #it is an unreachable commit, and therefore useless.
    #(git periodically auto-deletes such commits).

    #that is why we better not commit anything
    #while in the detached-head state!

    #one final thing.
    #if, at the moment of checkout
    #we have uncommitted changes,
    #git won't allow us to checkout
    #unless we commit those changes first.
    #(in the next section, we'll see
    #an alternative to this, called stashing).
#end

#-----------------------------------------------------------------------------------
#S03L10 - BISECT FOR FINDING BUGS

    #for this lesson, we'll assume we've made a bunch of commits
    #so our repo's history is big.

    #we'll also assume we have unit/integration/regression tests in place
    #and, in fact, when testing the latest version of our program
    #those tests failed somewhere.

    #so we know that, at some point, some commit introduced a bug.
    #but we don't know which commit it was,
    #and we also don't know which file causes the bug.

    #how do we find the bug?

    #we do know the bug affects some feature of our program,
    #so we can be sure the bug was introduced
    #after the commit that introduced the feature.

    #we'll call that commit: "the good bound",
    #which is a commit that we're sure doesn't have the bug.
    #(if unsure, we can always just use the first commit in the repo's history)

    #we'll also call the latest commit "the bad bound",
    #which is a commit that we're sure does have the bug.

    #bisect is a tool that, given two (good and bad) bounds,
    #lets us test the commit in the midpoint between them,
    #(using whatever testing procedures we have in place)
    #then determines if this midpoint is a commit where the bug is...
    #---- present (so the midpoint will become the new bad bound), or
    #---- absent (so the midpoint will become the new good bound)
    #and then repeat the cycle until the good and bad bounds
    #become two subsequent commits.

    #at that point, we know the bad bound is the commit
    #that introduced the bug.

    #then we can use "git show" and/or "git diff"
    #to find which file, and what line in it
    #need to be fixed.

    #the process goes as follows:

    #in this case we're in the master branch
    #but the following steps work in any branch
    #as long as we keep the whole bisect process within one same branch.

    #first, make sure we're not in the detached-head state
    #so that the current commit checked out is the latest commit.
    git checkout master

    #then, use "git log" to decide which commits
    #will be our good and bad bounds.
    #(keep their 7-digit-hex IDs handy)

    #then, start the bisect process:
    git bisect start

    #then, tell git that the latest commit is the bad bound:
    git bisect bad #auto-chooses the current commit
    #or, pick an arbitrary commit:
    git bisect bad <commit_identifier>

    #then, tell git that some arbitrary commit is the good bound:
    git bisect good <commit_identifier>

    #since now git knows the good and bad bounds,
    #it will auto-calculate the proper midpoint commit
    #and checkout to it.

    #at this point we may run:
    git log --oneline -all
    #to see that:
    #---- our bad bound is marked as "refs/bisect/bad",
    #---- our good bound is marked as "refs/bisect/good",
    #---- HEAD is detached from master and is in the middle of our two bounds.

    #the bisect loop starts here.

    #so now that we're checked out into the midpoint commit
    #we need to do our testing manually, in search for the bug.
    #after doing so, we should know if the midpoint commit
    #has the bug or not.

    #A)  if the midpoint commit has the bug,
    #    it means the bug was introduced somewhere inbetween
    #    the good bound commit and the midpoint commit.
    #    so we do:
    git bisect bad
    #    so the midpoint will become the new bad bound.

    #B)  if the midpoint commit doesn't have the bug,
    #    it means the bug was introduced somewhere inbetween
    #    the midpoint commit and the bad bound commit.
    #    so we do:
    git bisect good
    #    so the midpoint will become the new good bound.

    #(commits marked as good or bad with the previous commands
    #will stay marked during the whole bisect process.)

    #at this point:
    #a new midpoint will be auto-calculated,
    #and we'll be auto-checked out to it.
    #(run "git log --oneline -all" again to see)

    #at this point, the bisect loop restarts.

    #we should repeat the process as many times as needed
    #until we have
    #a good commit immediately followed by a bad commit.
    #at that point, the bisect loop stops.

    #the earliest commit marked as bad in the history
    #will be the one that introduced the bug.

    #as soon as git finds it, it will print
    #the details of it in the console.

    #knowing which commit is responsible
    #for introducing a bug, we can finally exit the bisect process:
    git bisect reset

    #and now we'll be checked out into the latest commit
    #so we're not in a detached-head state anymore
    #and can work on fixing the bug.
#end

#-----------------------------------------------------------------------------------
#S03L11 - SHORTLOG

    #we can get some very short and quick info
    #on the commits that
    #every programmer has made to the repo.

    #to see a list of commits per programmer:
    git shortlog

    #to sort the aforementioned list,
    #starting with the programmer with the most commits:
    git shortlog -n

    #to just count how many commits per programmer:
    git shortlog -s

    #also, to filter by a date range, we can use the
    # --before="" and --after="" flags from before.
#end

#-----------------------------------------------------------------------------------
#S03L12 - VIEWING A FILE'S HISTORY

    #viewing the history of a file, rather than the whole repo
    #is very easy. we just do:

    git log <file_path>

    #this is too verbose,
    #it shows the author, the date and the commit comment.

    #we can get a shorter output with:
    git log --oneline <file_path>

    #however, there is info that none of the two
    #previous commands give us:

    #to get the line insertion/deletion statistics
    #in every commit, we do:
    git log --stat <file_path>
    #or...
    git log --oneline --stat <file_path>

    #to get a diff with the actual text changes
    #introduced in every commit, we do:
    git log --patch <file_path>
    #or...
    git log --oneline --patch <file_path>
#end

#-----------------------------------------------------------------------------------
#S03L13 - RESTORING A DELETED FILE

    #let's say we've deleted a file accidentally
    #and then committed the deletion.

    #and then let's say
    #we found out about the deletion much later.

    #finally, let's assume we know the path
    #where the file used to be.

    #first of all, we need to find
    #which commit introduced the deletion.
    #to do so, run:
    git log --oneline -- <file_path>
    #(notice the spaces around the "--" before the file path)

    #in the output, we'll see a list of
    #committed changes to the file.
    #obviously, the latest one is the deletion.
    #(because how could there be any more changes to a file AFTER it's deleted?)

    #so, the next-to-last commit introduced
    #most up-to-date version of the file.
    #that's the version we deleted, and which we want to restore.
    #(take note of that commit's 7-digit-hex ID!)

    #in order to restore the file
    #and also auto-stage it, we do:
    git checkout <commit_identifier> <file_path>

    #finally, just commit the restoration of the file:
    git commit -m "restored <file>"
#end

#-----------------------------------------------------------------------------------
#S03L14 - FINDING AN AUTHOR WITH BLAME

    #the most granular history we can view
    #is a line-by-line history of a file.

    #we do so by running:
    git blame <file_path>

    #in the output, we see every line of code in the file
    #prepended with the 7-digit commit ID,
    #the author's name, and the timestamp
    #of the commit that last introduced/changed the line.

    #if the file is too big, maybe we just want to
    #view a chunk of it, we do so with:
    git blame -L <from_line>,<this_many_lines> <file_path>

    #for example, for viewing lines 10 to 15 of diary.txt:
    git blame -L 10,5 diary.txt
#end

#-----------------------------------------------------------------------------------
#S03L15 - TAGGING A COMMIT

    #whenever we release a version of our program
    #which is something like "v1.0" or "beta",
    #that version will include the repo's history
    #UP TO a certain commit.

    #so, it would make sense to give a name
    #like "v1.0" or "beta" to the commit.

    #we can do that using tags.

    #a tag doesn't actually rename a commit
    #nor overwrites its comment.
    #it just becomes an additional identifier for the commit.

    #we apply a tag to a commit with:
    git tag <tag_name> <commit_identifier>
    #or simply apply it to the current commit with:
    git tag <tag_name>

    #(a tag_name without spaces works best).

    #now, by doing "git log -oneline"
    #we can see the tag name right next to the commit's 7-digit ID.

    #from this point on, the tag works as a valid commit_identifier
    #for any command that needs it.

    #for example if we release commit 4d5e2a5 as v1.0
    #we might do:
    git tag v1.0 4d5e2a5

    #and in the future, we could do something like:
    #"git checkout v1.0"
#end

#-----------------------------------------------------------------------------------
#S03L15 - ANNOTATED TAGS

    #the tags we just saw are simple tags.
    #just a simple string for identifying a commit.

    #but there are better tags, which can hold a tag comment,
    #the name of the author of the tag, and the timestamp
    #at the moment the tag was created.

    #we create this by running:
    git tag -a <tag_name> -m "<comment>"

    #now, we can read all the tag metadata plus the commit details with:
    git show <tag_name>

    #now, to see the list of tags we've created, we do:
    git tag

    #to see the same list, plus their comments:
    git tag -n

    #finally, to delete a tag, we do:
    git tag -d <tag_name>
#end

#-----------------------------------------------------------------------------------
#S03L16 - VIEWING HISTORY IN VSCODE

    #before we start, make sure we have installed
    #the GitLens plugin for VSCode.

    #if we click on the gitlens icon on the left,
    #we'll open the gitlens panel.

    #if we expand the REPOSITORIES tree
    #we'll see the repos gitlens has found.
    #to the right of every repo,
    #we'll see the current working branch for it.

    #if we expand a repo from the tree,
    #we'll see there's subtrees for the master branch,
    #other branches, contributors, tags, etc.

    #if we expand master or any other branch
    #we'll see the list of commits
    #with details about each.
    #(we can right-click these to see more options, like tagging them)

    #it shows the author's avatar, the commit comment,
    #the amount of files created/edited/deleted,
    #and the timestamp for it.

    #if we expand a commit,
    #it'll show us the files that were modified.
    #if we click on any of those, we'll see its diff.

    #if we have a file from the repo
    #open in vscode's editor,
    #gitlens will show its history in the FILE HISTORY tree.

    #in the COMPARE COMMITS tree
    #we need to provide identifiers for two commits,
    #and vscode will display the list of files in them,
    #and if we click on any file, we'll see the diff between commits.

    #in the SEARCH COMMITS tree
    #we can search for a commit by several criteria,
    #but only by one criteria.
#end

#-----------------------------------------------------------------------------------
#S03L17 - VIEWING HISTORY IN GITKRAKEN

    #after opening a repo
    #we'll immediately see the history of it.

    #to the left of the commit list
    #are the pointers and tags which point to the commits.

    #at the top right corner, we can click the lens
    #to search for a commit by ID, author or message,
    #but only by one criteria at a time.

    #by clicking on a commit,
    #we'll see its details on the right panel,
    #including the files that were modified in it.

    #also in said panel we can toggle between showing
    #all the files in the repo, at the moment of the selected commit
    #or just those modified in the selected commit.

    #by clicking on a file in said panel
    #a panel will open where we can see the contents of the file,
    #its diff, its blame and its history.

    #by holding Ctrl/Cmd and clicking on two commits,
    #we can select both and make them show up in the right panel,
    #so that by clicking on a file in it,
    #we can see its diff between the two commits.

    #by right clicking on a commit
    #we can checkout to it, tag it,
    #and many other options.

    #at any point, we can do Ctrl/Cmd + P
    #to bring up a command palette.
    #we can write any of the commands we've seen in there
    #and gitkraken will give us options to execute the command.
#end

#-----------------------------------------------------------------------------------
#END OF SECTION 03
