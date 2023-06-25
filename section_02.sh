#SECTION 02: CREATING SNAPSHOTS

#-----------------------------------------------------------------------------------
#S02L01 - GETTING STARTED

    #just super basic explanations here...
#end

#-----------------------------------------------------------------------------------
#S02L02 - INITIALIZING A REPO

    #how to create a repo:

    #1. create a new directory. doesn't matter what it's called or where it's stored.
    mkdir moon #in these examples we'll call our repo "moon".

    #2. step into the new directory.
    cd moon

    #3. initialize the repo with:
    git init

    #at this point there should be a .git directory inside the current directory.
    #DO NOT EVER modify or delete the .git directory in any way.
#end

#-----------------------------------------------------------------------------------
#S02L03 - BASIC WORKFLOW

    #the contents of our repo are intended to be modified constantly
    #by editing, creating or removing files.

    #at some points, we will be satisfied with the (temporary) state of our repo
    #so we'll want to save a snapshot of it at that point in time.

    #this is called "committing changes".

    #there is a place called the "staging area" in every repo,
    #which is a different place from the repo directory or the .git directory.
    #(the staging area is also known as the "index")

    #any modification that we want to include in our next commit
    #should be added manually to the staging area.
    #adding a modified file to the staging area is called "staging a file".

    #this way we can do commits that include only related changes.
    #for example, one commit should include only those changes
    #needed to fix some bug or introduce some feature.

    #and then, other changes related to some other purpose
    #should be part of another commit.

    #that's how we keep our workflow organized!

    #in order to stage a file manually, we do:
    git add <path_to_file>

    #if we want to stage more than one file:
    git add <path_to_file_1> <path_to_file_2> ... <path_to_file_N>

    #keep in mind that, if the file in question has not been modified
    #it will not be staged. Because there's no need to.

    #to add all files modified since the last commit:
    git add *

    #same as the previous one, but limited to the current directory
    #and its subdirectories, recursively:
    git add .

    #(with the last two commands, just be careful
    #to not add something you don't want.)

    #at this point, our staging area includes our code changes.
    #it is GOOD practice to test the code at this point.
    #because, it is BAD practice to commit a breaking change.
    #(why would we commit a bug?)

    #always be sure to commit ONLY working code!

    #to commit the staged changes, we do:
    git commit -m "<comment>"

    #the comment describes the commit.
    #the comment is mandatory, because, as explained earlier,
    #there needs to be one (and only one!) clear and concrete purpose for each commit.
    #other programmers can, then, read the comment
    #and know what changes to expect from the commit.

    #keep comments short and concise!
#end

#-----------------------------------------------------------------------------------
#S02L03 - EXAMPLE

    #let's say we've just created file1 and file2,
    #staged them both,
    #and committed the changes.

    #at this point, our code changes have been committed.
    #this means, they are permanently added to the recorded history of the repo.

    #BUT! our staging area still contains the committed files.
    #committing code doesn't empty the staging area!

    #so, at any point in time, the staging area represents either:
    #case A: the current production code,
    #        (when the staging area and the latest commit are equal), or
    #case B: the version of the code that will go into production next
    #        (when the staging area includes uncommitted changes).

    #at this point case A is true,
    #but then we modify file1.
    #at this point, case A is still true
    #(because the modified file1 hasn't been staged yet).

    #so, we stage file1 again
    #(we can, since it's been modified just now).
    #now case B is true.

    #then we commit the changes.
    #now case A is true again.

    #in summary:
    #---- the repo history only includes those files committed with git commit.
    #---- the staging area only includes those files staged with git add.
    #---- the rest of the contents in our repo exist only in our filesystem as regular files.
#end

#-----------------------------------------------------------------------------------
#S02L03 - HANDLING DELETIONS

    #one misleading bit is how to add file deletions to the staging area.
    #we use the "git add" command to stage ALL kinds of changes,
    #including deletions.

    #so if we delete file2
    #we stage the removed file2 with "git add file2"
    #which, in effect, will unstage file2 (delete it from the staging area).
    #so it's misleading to use "git add" to actually remove a file,
    #but that's how it is. get used to it.
#end

#-----------------------------------------------------------------------------------
#S02L03 - WHAT EXACTLY IS INCLUDED IN A COMMIT?

    #each commit contains:
    #---- a unique ID (a 40-character long hex hash string)
    #---- the commit comment
    #---- a timestamp (of the instant the commit was created)
    #---- the username of the author of the commit
    #---- a complete snapshot of the repo at the moment of the commit.

    #that last bit is important.
    #if every commit includes the full snapshot of the repo,
    #it means git can trivially revert the state of a repo to an earlier commit.

    #every snapshot is stored compressed so as to waste as little disk space as possible.
#end

#-----------------------------------------------------------------------------------
#S02L04 - STAGING FILES

    #consider this example:

    #create two files (file1.txt and file2.txt) in our repo
    #and write "hello" in both of them:

    echo hello > file1.txt
    echo hello > file2.txt

    #the '>' operator in bash or zsh means "redirect and overwrite"
    #it creates the file on its right side if it doesn't exist,
    #or rather, deletes its contents if it does,
    #then takes the text on its left side,
    #and then writes that text into the file.

    #at this point we have two unstaged files.
    #(also called "untracked" files)

    #to view a list of all unstaged files, do:
    git status

    #the unstaged files will be shown in red.

    #if we stage those files, and
    #then do "git status" again
    #those files will be shown in green.

    #now that file1.txt is staged
    #let's edit it further.
    #we'll append more text to it:

    echo world >> file1.txt

    #similar to '>', the '>>' operator means "redirect and append"
    #it does mostly the same, except it doesn't delete the contents of the file
    #and then just appends the text at the end of it.

    #now we do "git status" again
    #we'll see BOTH file1.txt in green, because it's staged
    #AND file1.txt in red, because it has unstaged changes.

    #if we "git add" the file again
    #the recent changes will be staged
    #and "git status" will show only green files again.

    #remember how to interpret the output of "git status"!
    #GREEN files are staged, but not necessarily up-to-date.
    #RED files are unstaged, or have recent unstaged changes.
#end

#-----------------------------------------------------------------------------------
#S02L05 - COMMITTING CHANGES

    #we saw how every commit includes a short comment.

    #but, if instead of committing like: git commit -m <comment>
    #we commit like: git commit
    #what would happen?
    #do we avoid providing a comment?

    #no. we do that when, in fact,
    #we want to provide a very long comment
    #because our commit requires a long explanation.

    #so, by doing:
    git commit
    #git will open its default text editor
    #and open a file called COMMIT_EDITMSG
    #which gives us a template where we can write the explanation.

    #inside that file, we use the very first line
    #to write a short title
    #then leave a blank line below it
    #and then write an explanation for the commit,
    #which can be as long as we want.
#end

#-----------------------------------------------------------------------------------
#S02L05 - EXAMPLE

    #this represents the contents of COMMIT_EDITMSG:

    #*************************************************************************
    #<our short title>
    #
    #<a long>
    #<explanation>
    #<message>
    #<...>
    #<for the commit>
    #
    #from here onwards there is autogenerated text which we can leave as-is
    #...
    #*************************************************************************

    #after writing the title and the explanation
    #we save the file and close the editor.
#end

#-----------------------------------------------------------------------------------
#S02L05 - CLEAN REPOS

    #a very basic concept is that of a "clean repo".

    #let's say that, after working on several issues,
    #several bugfixes and improvements have been committed
    #and no new issues have been started.

    #so at this point, there are no unstaged modifications to any file
    #and also, the contents of our staging area and the last commit are the same.

    #we say such a repo is "clean".
#end

#-----------------------------------------------------------------------------------
#S02L06 - BEST PRACTICES WHEN COMMITTING

    #here are some basic recommendations for when committing code:

    #1) do NOT do a commit per-file.
    #that's just overhead.
    #plus, more than likely a bugfix or an improvement
    #involves changing several files,
    #so all those files should be grouped into a single commit.
    #imagine reverting many commits instead of just one,
    #every time something goes wrong!

    #2) on the opposite, don't do just one huge commit
    #at the end of a huge development sprint.
    #instead, if the work is too big, do incremental commits
    #every so often, which at the end will build up
    #to the intended bugfix or improvement.
    #BUT don't commit breaking changes!
    #so think how to split your work into harmless parts
    #before committing them.

    #3) group only related changes into every one commit.
    #this is so the commit comment can be short
    #and still explain all the changes made.

    #4) make commit comments short but meaningful.
    #so someone checking the repo history can
    #understand it easily.

    #5) all developers should stick to convention.
    #this means all developers should phrase their
    #commit comments in the same way.
    #for example, only using the past tense.
#end

#-----------------------------------------------------------------------------------
#S02L07 - SKIPPING THE STAGE

    #do we always have to stage changes
    #before committing them?

    #no. there's a way to skip the staging area
    #and commit unstaged changes directly:

    git commit -am "<commit comment>"

    #BUT, keep in mind this is a BAD PRACTICE!

    #the whole point of the staging area is to keep track of
    #the files that are critical to some bugfix or improvement
    #so, we can do code modifications and testing to them
    #while we keep them staged.

    #and at the end, when the code works in a satisfying way
    #and all testing has passed correctly,
    #we just simply commit the staging area.

    #to be safe, NEVER SKIP THE STAGING AREA.
#end

#-----------------------------------------------------------------------------------
#S02L08 - REMOVING FILES

    #to see a list of all staged files, do:
    git ls-files

    #if we staged file1.txt and file2.txt before,
    #we'd see them there.

    #but, if we deleted file2.txt, like:
    rm file2.txt #(rm command in bash/zsh removes a file)

    #file2.txt's removal would have happened AFTER
    #the last time we staged file2.txt,
    #and so, the removal is an unstaged change!

    #if we do "git ls-files" again
    #file2.txt will be right there!
    #even though it actually doesn't exist in our repo anymore!

    #moreover, if we do "git status"
    #we'll se something like:
    #"deleted: file2.txt"
    #in RED!

    #so, to actually tell our repo to have file2.txt
    #deleted in the next version of its history,
    #we have to stage and then commit the deletion.

    #so we do: "git add file2.txt"

    #at this point, "git ls-files" won't show file2.txt anymore
    #and "git status" will show it in green.

    #BUT, there's a shorthand for that!

    #to remove a file BOTH from the filesystem AND the staging area, do:
    git rm <path_to_file>

    #same, but for several files:
    git rm <path_to_file_1> <path_to_file_2> ... <path_to_file_N>

    #this is much better, since it is confusing
    #to use "add" to remove a file,
    #and also because it is a pretty common workflow.

    #finally, to commit the removal, we do:
    #"git commit -m <removed file2.txt>"
#end

#-----------------------------------------------------------------------------------
#S02L09 - RENAMING AND MOVING FILES

    #let's say we did this:
    mv file1.txt main.js

    #the "mv" command simultaneously moves and renames a file.
    #in this case, since the path provided for both files is the same
    #it only renamed file1.txt to main.js.

    #however, git interprets this like:
    #file1.txt was deleted (since it can't find it by that name anymore), and
    #main.js was created.

    #so at this point, "git status" will show both files in red.
    #we now need to "git add" both files.

    #BUT, now if we do "git status"
    #git recognizes that the file was in fact renamed,
    #and shows it in green.

    #so, there were 3 steps involved:
    #the move/rename, staging a deletion and staging a new file

    #since that is cumbersome, git gives us a shorthand for that!
    git mv file1.txt main.js

    #it performs all steps in one go,
    #and then stages all the changes properly!
#end

#-----------------------------------------------------------------------------------
#S02L10 - IGNORING FILES

    #let's say our program being developed
    #generates some log files.

    #every developer who works on it should be
    #generating their own log files, plus
    #these are not needed as input to the program.

    #therefore, it's not necessary to include them
    #as part of the repo!

    #we should tell git to ignore those files.
    #ignoring them means never tracking/staging/comitting them.

    #let's simulate this scenario.
    #create a logs directory with:
    mkdir logs
    #and then place a log file inside it, with some text:
    echo hello > logs/dev.log

    #at this point, "git status" would
    #show the entire logs directory in red.

    #now, to tell git to ignore the whole logs directory
    #we need to add it to a .gitignore file.

    #.gitignore is a text file which contains
    #a list of paths to be ignored.
    #(including paths recursively inside those specified)

    #we create the .gitignore file
    #and add the logs directory to it with:
    echo "logs/" > .gitignore

    #at this point, "git status" won't show
    #the logs directory anymore
    #BUT it will show the .gitignore file in red!

    #no problem. just "git add" it.
#end

#-----------------------------------------------------------------------------------
#S02L10 - IGNORING SOMETHING NOT NEW

    #in the last example, we added the logs to .gitignore
    #before staging/committing them.

    #this is trivial, because git saw the logs as
    #a new item in the filesystem, never the repo.
    #so it never had to
    #start ignoring something that was already in the repo.

    #however, let's say we try this:

    #create a directory, let's call it bin
    mkdir bin
    #add a file to it, with text in it
    echo hello > bin/app.bin
    #stage bin:
    git add bin
    #commit all we just did:
    git commit -m "created bin directory"

    #but then realize committing it was a mistake, because:

    #in real scenarios, a bin directory
    #is for generating a binary compiled file
    #every time we compile our code,
    #which happens dozens of times in every sprint,
    #plus it's something that can be generated by our code
    #so it's better to ignore it.

    #we add the bin directory to .gitignore:
    echo "bin/" >> .gitignore
    #stage that:
    git add .gitignore
    #and commit that:
    git commit -m "ignored bin"

    #are we done? will bin be ignored from now on?
    #in fact, no.
    #because it is already being tracked in the staging area.

    #let's demo that. edit something inside bin:
    echo helloworld > bin/app.bin
    #now do "git status"
    #and see how the change we just made was not ignored.

    #because app.bin is still staged.
    #we can check that with "git ls-files".

    #in order to fully unstage the bin directory,
    #we need to do something similar to staging a deletion.

    #the shorthand for staging the deletions is "git rm"
    #if we do "git rm -h" we can see alternative ways to run it.

    #the "--cached" option removes a file only from the staging area,
    #not the filesystem.
    #(the staging area is referred to as the "index").

    #also, we see that the "-r" option
    #removes everything inside a directory, recursively.

    #so, the command we need is:
    git rm --cached -r bin/

    #if we check "git ls-files"
    #we see app.bin is not tracked anymore.

    #if we check "git status"
    #we'll see it marks app.bin as deleted,
    #with the deletion already staged (in green).

    #all that's left is committing our work so far.

    #from this point on, git will properly ignore
    #the bin directory and all its contents.
#end

#-----------------------------------------------------------------------------------
#S02L10 - TEMPLATES

    #we can find
    #a .gitignore template
    #for every programming language
    #in github.com/github/gitignore
#end

#-----------------------------------------------------------------------------------
#S02L11 - SHORT STATUS

    #we know that "git status" shows
    #a comprehensive and verbose status of our repo.

    #but if we wanted something less verbose,
    #we could do:
    git status -s

    #in the output of "git status -s" we see
    #the names of the relevant files, prepended with two characters
    #where the first character represents the staging area (can be blank)
    #and the second represents the filesystem.

    #the meanings of the characters are as follows:
    #( "staged/unstaged changes" refers to changes since the last commit.)

    #staged files with only unstaged changes will have:
    #---- a blank first character,
    #---- and a red "M" in the second character (" M").

    #staged files with only staged changes will have:
    #---- a green "M" in the first character,
    #---- and a blank second character ("M ").

    #staged files with both staged and unstaged changes will have:
    #---- a green "M" in the first character,
    #---- and a red "M" in the second character ("MM").

    #new and unstaged files will have:
    #---- two red question marks ("??").

    #new and staged files will have:
    #---- a green "A" in the first character,
    #---- and a blank second character ("A ").

    #recently deleted files, with staged deletion, will have:
    #---- a green "D" in the first character,
    #---- and a blank second character ("D ").

    #recently updated files, with staged deletion, will have:
    #---- a red "D" in the first character,
    #---- and a red "U" in the second character ("DU").
#end

#-----------------------------------------------------------------------------------
#S02L12 - VIEWING CHANGES

    #COMPARING OLD COMMITTED VS NEW STAGED

    #in order to see what are the actual changes
    #in the actual lines of text/code
    #in all the staged files with staged changes, we do:

    git diff --staged

    #this runs the UNIX diff tool, which
    #compares text between two files.

    #in this case, it compares two versions of the same file:
    #the last comitted version (called "a/<filename>, we'll call it A),
    #and the current staged version (called "b/<filename>", we'll call it B).

    #keep in mind, if a file is shown as "/dev/null"
    #it means there is no file.
    #this happens when introducing a new file in B (there won't be a file in A),
    #or when deleting a file in B (the file will only exist in A).
    #in those cases the text comparison is trivial and can be ignored.

    #in the output, we'll see:

    #changes made to A are indicated by a minus sign ("-"), and
    #changes introduced in B are indicated by a plus sign ("+").

    #further down there is one or more headers.
    #headers start and end with "@@" in blue.
    #each header represents a chunk of the compared files
    #where code changes can be found.

    #the full header format is like:
    #"@@ -<lines_in_A> +<lines_in_B> @@"
    #(notice the minus and plus signs)

    #<lines_in_X> represents which lines from file X
    #are shown, in a format like
    #"<from_line_#>,<how_many_lines>"

    #so for example, if we have a header like:
    #"@@ -1,3 +1,5 @@"

    #it means we're comparing text between:
    #---- a 3-line-long chunk in A, starting from line 1, and
    #---- a 5-line-long chunk in B, starting from line 1.

    #below every header, the changed lines can be found,
    #in a format like:
    #---- unchanged lines are simply shown in white.
    #---- newly added/changed lines in B are shown in green and prepended with "+".
    #---- newly deleted/changed lines in A are shown in red and prepended with "-".
    #---- so, changed lines will show up as a red line immediately followed by a green line.
#end

#-----------------------------------------------------------------------------------
#S02L12 - COMPARING OLD STAGED VS NEW UNSTAGED

    #in order to compare the current staging area
    #with any unstaged changes we might have,
    #the command is even simpler:

    git diff

    #it compares:
    #the the current staged version (called "a/<filename>),
    #and the files in our filesystem, as they currently are (called "b/<filename>").
#end

#-----------------------------------------------------------------------------------
#S02L13 - VIEWING CHANGES WITH A GUI

    #before attempting this lesson, make sure
    #the config procedure in section 01 lesson 06
    #works as intended, and the preferred diff tool is a GUI tool.

    #the commands for viewing our diffs with a GUI are
    #almost exactly the same as before:

    #for comparing old staged vs new unstaged:
    git difftool
    #for comparing old committed vs new staged:
    git difftool --staged

    #since the CLI-only "git diff" shows changes
    #in subsequent lines,
    #the true value of a GUI tool is if it can
    #show changes side-by-side (like vscode does).
#end

#-----------------------------------------------------------------------------------
#S02L14 - VIEWING HISTORY

    #in order to view the entire list of commits
    #we have made in a repo, we run:
    git log

    #"git log" shows the repo history,
    #where each entry is a commit,
    #sorted top-to-bottom from the latest commit
    #to the earliest.

    #each commit also shows its 40-digit hex id,
    #its author, its timestamp and its comment.

    #if the list is too big we can
    #hit space to advance one page down, or
    #hit Q to exit.

    #or we can run:
    git log --oneline

    #to output only a short summary of the history.

    #in order to show the commits earliest to latest, we run:
    git log --reverse #or...
    git log --oneline --reverse
#end

#-----------------------------------------------------------------------------------
#S02L15 - VIEWING A COMMIT

    #using the command:
    git show <commit_identifier>

    #we can see extended info about one specific commit
    #including a diff with the changes it introduced.

    #the commit identifier can be either:
    #---- the first 7 (hex) digits of the commit ID, or
    #---- the word "HEAD", if we want the latest commit, or
    #---- a string like "HEAD~N", where N is a number,
    #     if we want the commit that was made N commits before the latest one

    #if we want to see the version of a file
    #that is stored as part of one commit, we do:
    git show <commit_identifier>:<file_path>

    #where file_path is the path to the file we want to check
    #relative to the repo's root.

    #if we want a full list of all files and directories
    #included in a commit, we do:
    git ls-tree <commit_identifier>

    #which shows us directories as "tree"
    #and files as "blob".

    #notice that ls-tree gives us
    #a unique 40-digit hex ID for each tree/blob, for each commit.

    #so this is a completely unambiguous ID which
    #identifies a snapshot of a file/directory in the repo's history.

    #in order to view the contents of the tree/blob, we do:
    git show <identifier>

    #where identifier is the first N digits
    #of the aforementioned hex ID for the tree/blob we want.
    #(7 digits is usually enough for avoiding ambiguity).

    #if the identifier belongs to a file (blob)
    #it'll just print the file content on the screen.

    #if it belongs to a directory (tree)
    #it'll print a list of the files and subdirectories inside it.
#end

#-----------------------------------------------------------------------------------
#S02L16 - UNSTAGING FILES

    #to revert the state of a staged file
    #means to discard the staged version of it
    #and replace it in the staging area
    #with the last committed version of it.

    #this is also called "unstaging a file".

    #after unstaging a file,
    #all recent changes to it will still exist, but only in the filesystem.
    #and the versions of it in the staging area and in the last commit will be the same.

    #in order to unstage a file
    #there used to be one command that is now deprecated:
    git reset #do NOT use this!

    #nowadays however, we have a better command:

    #to unstage a single file:
    git restore --staged <file_path>
    #to unstage several files:
    git restore --staged <file_path_1> <file_path_2> ... <file_path_N>
    #to unstage the whole staging area:
    git restore --staged .

    #if unstaging a newly created file,
    #the file will still exist, but only in the filesystem.
    #(it'll show up as "??" in git status -s)
#end

#-----------------------------------------------------------------------------------
#S02L17 - DISCARDING UNCOMMITTED CHANGES

    #every time we create a new file
    #or make changes to a file
    #we've got ourselves an unstaged file
    #(or, a file with unstaged changes).

    #keep in mind here we're referring to changes
    #OUTSIDE the staging area. changes that are only in our filesystem.

    #before staging a file,
    #we might decide the changes we've made to it so far are wrong,
    #and want to undo them, so we can restart editing it from scratch
    #or not edit it at all.

    #effectively, what we'd be doing is
    #restoring a file to its last staged version.
    #and we do so with the commands:

    #to restore a single file:
    git restore <file_path>
    #to restore several files:
    git restore <file_path_1> <file_path_2> ... <file_path_N>
    #to restore every edited file in the current directory:
    git restore .

    #which is very similar to unstaging files,
    #only dropping the --staged flag:

    #this restores a staged file to its latest comitted version:
    git restore --staged <file_path>
    #this restores an unstaged file to its latest staged version:
    git restore <file_path>

    #if we attempt to do this to a newly created
    #and unstaged file, it won't work.
    #because there is no last staged version of it to take.

    #in order to restore such a file, we do:
    git clean -fd

    #which deletes the file permanently, so use with caution.
#end

#-----------------------------------------------------------------------------------
#S02L18 - RESTORING TO AN EARLIER VERSION

    #we already know that restoring a file
    #means replacing it with an older version of it
    #taken from somewhere.

    #by logic, we know:
    #---- the filesystem is only equal or newer than the staging area.
    #---- the staging area is only equal or newer than the last commit.

    #so, by default, if we don't specify
    #where to take an older version from,
    #---- restoring a file on the filesystem will take its version from the staging area.
    #---- restoring a file on the staging area will take its version from the last commit.

    #but what if we want to restore a file
    #to its version from a specific commit?

    #we can do so, by running:
    git restore --source=<commit_identifier> <file_path>

    #where the commit_identifier works the same
    #as with "git show".

    #this is very useful, since it works per-file,
    #not per-commit, so we can make fine-grained restorations.

    #it is also useful for recovering
    #files that we've deleted by mistake.
#end

#-----------------------------------------------------------------------------------
#S02L19 - SNAPSHOTS IN VSCODE

    #in the left panel of vscode,
    #click the git logo to go into git panel.

    #any file shown with a "U" to the left is unstaged/untracked.

    #we can see a few buttons by mouse-hovering over the file:
    #if unstaged, we can "git add" it by clicking on the plus button,
    #and if staged, we can "git restore --staged" it by clicking on the minus button.

    #to commit our staged changes, we write a commit comment
    #on the text field at the top of the panel
    #and then click the checkmark above it.

    #in the file explorer panel (the default one)
    #if we select a file and then expand the "timeline"
    #section below, we can see the commit history of the file.
    #we can click on each entry to see the committed changes in it.
#end

#-----------------------------------------------------------------------------------
#S02L20 - SNAPSHOTS IN GITKRAKEN

    #after opening gitkraken,
    #go to "Open a repo" > "Open" > "Open a Repository"
    #then select our repo's root directory to open it.

    #we are taken to a history view
    #with all the commits ordered top-to-bottom
    #from latest to earliest.

    #if we click on any commit, we can
    #see the details of it,
    #included the changed files.

    #if we click on a file, we can see its contents
    #either straightforward or in a side-by-side diff.

    #(keep in mind gitkraken allows us to read
    #the files in our repo and do git operations,
    #but it is NOT a code editor, so
    #we can't use it to actually make changes to files).

    #if there were any unstaged changes detected in our repo
    #gitkraken will provide a view to check them
    #and in that view we can stage and commit them.
#end

#-----------------------------------------------------------------------------------
#END OF SECTION 02
