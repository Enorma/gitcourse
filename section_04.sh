#SECTION 04: BRANCHING

#-----------------------------------------------------------------------------------
#S04L01 & S04L03 - INTRODUCTION

    #just a summary of the section here...
    #this section uses the "Venus" repo, included in the course materials.
#end

#-----------------------------------------------------------------------------------
#S04L02 - BRANCHING BASICS

    #we saw the concept of branch pointer before.
    #we also got to know the HEAD pointer.

    #every pointer is just a reference to a commit's hex ID.

    #every branch pointer always points to
    #the most recent commit in its branch
    #(usually called the branch's "tip").

    #a branch without a branch pointer at its tip
    #is a dead branch and will be autodeleted.

    #the head pointer can be in one of two states:
    #---- A) both HEAD and a branch pointer point to a branch's tip.
    #-------- this means we're properly working on that branch.
    #-------- the filesystem will reflect the state of the repo
    #         at that branch's latest commit, plus the changes we're working on.
    #---- B) any other case:
    #-------- this means we're in the detached-head state.
    #-------- the filesystem will reflect the state of that commit exactly.
    #-------- we shouldn't make commits in this case.

    #selecting a branch to work on
    #means re-pointing the HEAD to some branch pointer
    #(the default is the master branch).

    #using git checkout and then committing code
    #will effectively branch us out, BUT
    #it WON'T create a new branch pointer!

    #therefore, the key concept to learn
    #when it comes to branching properly,
    #is how to create a new branch pointer.
#end

#-----------------------------------------------------------------------------------
#S04L02 - BEHAVIOR OF THE BRANCH POINTERS

    #detached or not, we're ALWAYS on a branch.

    #if not in the detached-head state,
    #whenever we commit, a new commit will be added
    #at the tip of the current branch.

    #and then, the current branch pointer will move to the new tip.
    #the HEAD pointer will then do the same.
    #all other pointers will not be affected!

    #at any point (except when in the detached-head state),
    #git knows which branch we're working on.
    #this means, git always knows which branch pointer to move
    #when we commit.

    #that's what "working on a branch" means.
    #it's git's knowledge of which pointer to move at each commit.

    #the current branch is the branch pointer
    #that will move if we commit!
#end

#-----------------------------------------------------------------------------------
#S04L04 - WORKING WITH BRANCHES

    #assuming we aren't in the detached-head state,
    #we have 2 pointers pointing to the same commit:
    #---- the branch pointer of whatever branch we are working on, and
    #---- the HEAD pointer.

    #to see the list of all existing branches we do:
    git branch

    #in the output of "git branch" we'll see
    #the current branch highlighted in green and prepended with an asterisk.

    #to create a new branch pointer, and auto-point it
    #to the same commit HEAD is pointing to, we do:
    git branch <branch_name>

    #where branch_name should be a descriptive name with no spaces.

    #assuming we weren't in the detached-head state,
    #at this point we have 3 pointers pointing to the same commit:
    #---- the branch pointer of whatever branch we are working on,
    #---- the branch pointer we just created, and
    #---- the HEAD pointer.

    #git will consider we're still working on the same branch,
    #so, in the output of "git branch" we'll still see
    #the same branch as before, highlighted.

    #to show the current working branch, we do:
    git status

    #which will show something like:
    #"On branch master", for example.

    #in order to switch to another (existing) branch, we do:
    git switch <branch_name>

    #if we want to create a new branch and immediately switch to it, we do:
    git switch -C <branch_name>

    #now check the output
    #of "git branch" and "git status"
    #to see we've switched to the other branch.

    #also, check the output of "git log --oneline"
    #to see how the HEAD is attached to the newly selected branch.

    #let's say we were on the master branch
    #and just switched to the "branch2" branch.

    #if we commit new changes at this point
    #and then do "git log --oneline"
    #we'll see both the branch2 and HEAD pointers moved to the recent commit
    #but master stayed behind!

    #in such cases, we say that master is 1 commit behind branch2.

    #to test that, check that the recently-made changes
    #are present in branch2 but not in master.

    #at this point, if we switch back to master
    #and then run "git log --oneline"
    #we wouldn't see anything about branch2.
    #so we can't see changes made
    #by other branches that are ahead of the current one.

    #to view those changes and all changes across all branches, we do:
    git log --oneline --all

    #at some point in the future,
    #we'll be satisfied with our work in branch2
    #so we should merge branch2 with master.
    #(we'll study merging in a later version)

    #after merging a branch to master, it becomes noise
    #so we should delete it. we do so with:
    git branch -d <branch_name>

    #the last command will fail if the branch
    #hasn't been merged to master.
    #but we can force the deletion with:
    git branch -D <branch_name>

    #finally, we can rename a branch with:
    git branch -m <branch_name> <new_branch_name>
#end

#-----------------------------------------------------------------------------------
#S04L05 - COMPARING BRANCHES

    #a very useful command lets us see
    #all the commits in some branch B
    #that are not in some branch A:

    git log <branchA>..<branchB>

    #this is useful in scenarios where
    #branchB is more recent than branchA.

    #for example, before merging branch2 into master
    #we may want to see which commits would that introduce:

    git log master..branch2

    #furthermore, we can see not just the commits,
    #but also the actual text changes, in the form of a diff:

    git diff <branchA>..<branchB>

    #if branchA is master, we can omit it
    #and the resulting diff will be the same:

    git diff <branchB>

    #in these cases, "git diff"
    #can use the --name-only and --name-status flags
    #we saw before.
#end

#-----------------------------------------------------------------------------------
#S04L06 - STASHING

    #whenever we do "git switch <some branch B>"
    #our filesystem will reflect the last commit in branch B.
    #(the same would happen if we checkout to another branch/commit).

    #however, as explained before,
    #attempting to switch/checkout to another branch/commit
    #while having uncommitted changes in the current working branch
    #won't work.

    #git will tell us we need to commit those changes first.
    #OR...
    #there's an alternative called "stashing those changes".

    #a stash is a place in our repo
    #different from the filesystem, the staging area or the commit history
    #where we can store uncommitted changes
    #and not make them part of the repo's history.

    #by stashing changes
    #those changes will be stored in the stash,
    #while the filesystem will become
    #equal to the latest commit in the current branch.

    #stashing works on UNCOMMITTED changes,
    #regardless if they are staged or unstaged.

    #stashing is preferred to committing
    #when our changes are still unfinished/untested.

    #we stash all our uncommitted changes with:
    git stash push -am "<comment>"

    #where the comment explains what are the changes we're stashing.

    #to view a list of all our stashes:
    git stash list

    #the output of which will show entries like:
    # "stash@{N}: On <branch>: <comment>"

    #where "N" is the stash identifier (a simple number) and
    #<branch> is the branch from which we created that stash.

    #to see the changes in one stash, we do:
    git stash show <N>

    #where "N" is the stash identifier
    #from "git stash list".

    #at this point we have stashed our changes
    #so we can switch/checkout no problem.

    #at some point, we'll return to the branch
    #where we stashed our changes,
    #and we'll want to recover those changes from the stash
    #so we can resume our work where we left it.

    #to do so, we NEED:
    #---- to be in the same branch which we stashed from.
    #---- the identifier number <N> of the stash we want to recover
    #     (run "git stash list" to find it).

    #and then, recover the stashed changes with:
    git stash apply <N>

    #once we've recovered a stash, we probably don't need it anymore
    #so we can delete it with:
    git stash drop <N>

    #or we can delete all stashes with:
    git stash clear
#end

#-----------------------------------------------------------------------------------
#S04L07 - MERGING

    #merging means mixing the changes committed in one branch A
    #with those comitted in another branch B
    #(in formal terms: "merging branch A into branch B"),
    #so that, afterwards, B contains both sets of changes
    #and A can disappear.

    #remember, every commit except the first one
    #points to the previous one (we may call it its "parent").

    #however, merges can be represented as commits too,
    #(called "merge commits").
    #merge commits point to TWO parent commits:
    #those branches that were merged into it.

    #there are two basic types of merges:
    #fast-forward and 3-way.
#end

#-----------------------------------------------------------------------------------
#S04L07 - FAST-FORWARD MERGE

    #fast-forward merges happen when
    #both branches A and B point to the same latest commit C0,
    #and then only one of those branches (say, A)
    #introduces new commits on top of C0.

    #so now, A points to, say, C2
    #and B still points to C0.

    #   ↙ B
    # C0 ← C1 ← C2
    #             ↖ A

    #to merge A into B, all that's needed is
    #to move B so that it points to the same latest commit
    #as A. so now both point to C2.

    #             ↙ B
    # C0 ← C1 ← C2
    #             ↖ A

    #so, if two branches have not diverged
    #and there is a linear path between both,
    #merging them just means
    #moving the branch pointing to the older commit
    #to the same commit the other branch is pointing to.
#end

#-----------------------------------------------------------------------------------
#S04L07 - 3-WAY MERGE

    #3-way merges happen when
    #first, both branches A and B point to the same latest commit C0,
    #and then they both introduce new commits, so they diverge.

    #let's say now A points to Ca3 (so A is 3 commits ahead of C0)
    #and B points to Cb5 (so B is 5 commits ahead of C0).

    #   ↙ Cb1 ← ... ← Cb5 ← B
    # C0
    #   ↖ Ca1 ← ... ← Ca3 ← A

    #to merge A into B, a new commit Cab needs to be created
    #which comes after BOTH Ca3 and Cb5.
    #Cab is known as a "merge commit".

    #merge commits don't happen when fast-forwarding
    #because a new commit is not needed in that case, only moving a pointer.

    #   ↙ Cb1 ← ... ← Cb5 ↖   ↙ B
    # C0                   Cab
    #   ↖ Ca1 ← ... ← Ca3 ↙   ↖ A

    #Cab is what happens after taking C0
    #and then applying the changes from both Ca3 and Cb5.

    #this is called a 3-way merge because 3 commits are critical:
    #---- the latest commit before the branching (C0),
    #---- the latest commit in branch A (Ca3), and
    #---- the latest commit in branch B (Cb5)
#end

#-----------------------------------------------------------------------------------
#S04L08 - FAST-FORWARD MERGE

    #from this point on
    #it is advisable to add the "--graph" flag to "git log",
    #so we can actually see the diverging branches.

    #let's assume we have a repo with only two branches:
    #---- a master branch
    #---- another branch called branch2 which is 1 commit ahead of master.
    #also, assume they don't diverge.

    #once we have a scenario like that, we can see it with:
    git log --oneline --all --graph

    #now we can see:
    #---- master is BEHIND branch2, so it is OLDER.
    #---- branch2 is AHEAD of master, so it is NEWER.

    #in all merges (fast-forward or 3-way),
    #of the two branches being merged...
    #---- one will be the "current branch", and
    #---- the other one will be the "target branch".
    #the target branch will be MERGED INTO the current branch.
    #remember that!

    #to merge one branch into another
    #we use the "git merge" command.

    #the branch from which the "git merge" command is run
    #is the "current branch".
    #in the case of fast-forwardable merges,
    #the current branch should be the OLDER one.

    #so, first we need to be in the older branch:
    git switch <older_branch>
    #in this case:
    git switch master

    #second, we do:
    git merge <newer_branch>
    #in this case:
    git merge branch2

    #afterwards, check what we've done with:
    git log --oneline --all --graph
#end

#-----------------------------------------------------------------------------------
#S04L08 - NO-FAST-FORWARD MERGE

    #a no-fast forward merge means that,
    #even in scenarios where fast-forwarding is possible
    #we choose not to do so.

    #this has the advantage of generating a merge commit,
    #which is always good, since it serves as a record
    #of the merge in the repo's history.
    #plus, merges are easier to revert this way (see below).

    #however, the disadvantage is that
    #the repo history cannot be read linearly
    #which would be much cleaner and more readable.

    #to do it, same conditions apply.
    #we have two branches, one older than the other,
    #and then from the older branch we do:
    git merge --no-ff <newer_branch>
    #in this case:
    git merge --no-ff branch2

    #this will open our default text editor
    #since we're obligated to write a comment
    #describing the merge.
    #(git will autogenerate a default comment for us).

    #once we've written the comment,
    #save and exit the editor.

    #if we prefer no-fast-forward merges,
    #we can disable them at the config level with:
    git config --<LEVEL> ff no

    #this way, all merges by default will NOT
    #be fast forward merges.

    #at this point our merge is done.
    #we can check with:
    git log --oneline --all --graph
#end

#-----------------------------------------------------------------------------------
#S04L08 - UNDOING A MERGE

    #given two non-diverging branches A and B
    #where A is older than B,
    #we might merge B into A by...

    #---- just fast-forwarding A's pointer into B's tip. or...

    #---- creating a new merge commit,
    #     which is ahead of both A and B's tips
    #     and which combines both tips.
    #     we'll call that commit Cab.
    #     then, moving A's pointer forward to Cab.

    #(in both cases, B's pointer doesn't move.)

    #we could undo both kinds of merges
    #simply by returning A's pointer back to where it was.

    #HOWEVER... there are caveats.
    #see lesson 14 on undoing merges below.
#end

#-----------------------------------------------------------------------------------
#S04L09 - 3-WAY MERGE

    #now let's assume we have two branches
    #(we'll call them master and branch2)
    #which have diverged.

    #we can see the divergence with:
    git log --oneline --all --graph

    #at this point it is unclear which branch
    #is the older one and which is the newer one.

    #we need to choose one branch to be the merge's current branch
    #considering that the other one (the target branch)
    #will probably be deleted after the merge.

    #to determine which branch should be the current,
    #here are a few guidelines:
    #---- if one of the branches is master, it should be the current.
    #---- if the merge is fast-forwardable, the older branch should be the current.
    #---- if branch A contains a finished feature or bugfix,
    #     while branch B is still work in progress, B should be the current.
    #---- in any other case, it's a matter of preference.

    #in this case, one of our branches is master
    #so we'll run the merge command from it:

    #first, we need to be in the current branch, so:
    git switch <current_branch>
    #in this case:
    git switch master

    #second, we do:
    git merge <target_branch>
    #in this case:
    git merge branch2

    #afterwards, we fill the merge commit comment,
    #save and exit the editor.

    #afterwards, check what we've done with:
    git log --oneline --all --graph
#end

#-----------------------------------------------------------------------------------
#S04L10 - VIEWING BRANCHES

    #from the point of view of the current working branch
    #we can see the list of all the branches that
    #we've merged to it, by doing:
    git branch --merged

    #all branches shown in that list are probably stale
    #and it's better to delete them.

    #on the opposite side, we can get the list
    #of those branches still not merged, with:
    git branch --no-merged
#end

#-----------------------------------------------------------------------------------
#S04L11 - MERGE CONFLICTS

    #imagine scenarios like these.
    #given two branches A and B at the moment of merging them...
    #---- the same file is changed in different ways in A and B.
    #---- the same file is changed in A but deleted in B (or vice-versa)

    #let's imagine we ran into the first scenario
    #when trying to merge branch2 to master.

    #so, we ran:
    git switch master
    #and then:
    git merge branch2

    #git will tell us there is a MERGE CONFLICT.

    #these are merges that can't be performed automatically
    #since git doesn't know how to proceed.

    #in such cases, we need to resolve the conflicts manually.

    #if we run "git status"
    #we'll see we're actually in a mid-merge/mid-commit state,
    #which is when git is waiting for us to resolve the conflicts.
    #(we'll call this the "conflicted state").

    #so, we need to open the conflicted file(s)
    #in a git-enabled code editor, like vscode.

    #we'll see, apart from the regular contents of the file,
    #both committed versions of the conflicting chunk of text inside the file.
    #and we'll also see ways to auto-resolve the conflict by...
    #---- keeping only the changes from master,
    #---- keeping only the changes from branch2, or
    #---- keeping the changes from both.

    #we could also edit the file(s) by hand,
    #with the resulting contents being
    #what is taken into the merged commit.

    #just be careful of only using lines of code
    #that were already on the conflicted commits.
    #do NOT add new code while resolving merge conflicts!

    #a merge commit which introduces new code
    #not coming from any of the merged branches
    #is called an "evil commit".

    #once we've resolved the conflicts in the file(s),
    #we need to stage the file(s) since we made changes to them.
    #so we need to "git add" them.

    #finally, we run:
    git commit

    #in this case we don't provide the "-m" flag nor a comment
    #since we already are in a conflicted state.
    #(so we were kinda already in the middle of a commit).

    #this means, the default code editor will open
    #and we can accept or edit the merge comment.
    #then, save and exit the editor.

    #at this point, the merge is completed.
#end

#-----------------------------------------------------------------------------------
#S04L12 - GUI MERGE TOOLS

    #BEFORE we start here,
    #make sure a GUI merge tool is installed
    #(we'll assume p4merge in these examples)
    #see lesson S01L06.

    #given two branches (we'll assume master and branch2)
    #which we intend to merge (branch2 into master),
    #we'd do:

    git switch master
    git merge branch2

    #now we'll assume a merge conflict happened.
    #so, we're now in the conflicted state.

    #to solve the merge conflict(s), in the previous lesson,
    #we opened the conflicted files manually in vscode,
    #which admittedly has some merge-conflict-resolving capabilities,
    #but not the best ones.

    #instead of manually choosing vscode and
    #manually opening the conflicted files in it,
    #we can call our default GUI merge tool
    #while in the conflicted state.
    #(in this example we'll assume the tool is p4merge):

    git mergetool

    #this will open our default GUI merge tool
    #(in this case p4merge)
    #which we should solve the merge conflict(s) on.
    #and afterwards, save the changes and exit the tool.
#end

#-----------------------------------------------------------------------------------
#S04L12 - HOW TO USE P4MERGE

    #p4merge shows 4 panels,
    #where each panel is a version of the same file:
    #---- REMOTE (left): the latest commit in the target branch (branch2).
    #---- BASE (center): the latest commit before the branches diverged.
    #---- LOCAL (right): the latest commit in the current branch (master).
    #---- MERGED (bottom): the resulting merge commit.
    #(remember: target merges into current. remote merges into local.)

    #so, we're supposed to resolve a 3-way merge manually.
    #once again, do try to solve the conflicts
    #without introducing any new code.

    #after we're done, save the changes and exit p4merge.

    #after using p4merge (or any GUI merge tool)
    #we need to do "git add" on all the files where we resolved conflicts
    #and then do "git commit".

    #the default code editor will open
    #and we can accept or edit the merge comment.
    #then, save and exit the editor.

    #at this point, the merge is completed.
#end

#-----------------------------------------------------------------------------------
#S04L13 - ABORTING A MERGE

    #if we ever are in the conflicted state
    #and don't want to continue with the merging process
    #(maybe we need someone's help to resolve the conflicts?)
    #we can do:

    git merge --abort

    #but beware, that will undo
    #any conflict resolutions done so far
    #(even if we've staged them!).
#end

#-----------------------------------------------------------------------------------
#S04L14 - UNDOING A MERGE

    #note: this lesson does not apply
    #for fast-forward merges.

    #it is possible to undo a merge commit
    #so the state of the repo goes back to when
    #it had two unmerged branches.

    #remember, before the merge, we had two branches
    #(we'll call them master and branch2).

    #this is the state before merging them
    #(and also ideally after undoing the merge):

    #                   ↙ branch2
    #              ↙ Cb1 ← ... ← Cbn
    # C0 ← ... ← Cn
    #              ↖ Cm1 ← ... ← Cmn
    #                   ↖ master

    #Cbn is the tip of branch2.
    #Cmn is the tip of master.
    #if we merge branch2 into master,
    #we'd effectively merge Cbn into Cmn.

    #this is the result of that merge
    #(in a non-fast-forward way):

    #                   ↙ branch2
    #              ↙ Cb1 ← ... ← Cbn
    # C0 ← ... ← Cn                  ↖
    #              ↖ Cm1 ← ... ← Cmn ← Cmb
    #                   ↖ master          ↖ merge!

    #the merge commit is called Cmb.

    #we'll refer to this state as a "freshly committed merge".
    #if we introduced new commits afterwards, it wouldn't
    #be freshly committed anymore.

    #now, to undo the merge,
    #there is a proper way to do it,
    #or it would be a risky operation.
#end

#-----------------------------------------------------------------------------------
#S04L14 - RISKY MERGE UNDOING

    #as we can see, the merge commit is part of master
    #while having all the commits from branch2.

    #so branch2 might seem redundant,
    #and also we probably finished all the work
    #we intended to do in branch2,
    #that's why we merged it, after all.

    #so, is it safe to delete branch2 at this point?
    #that will result in something like:

    # C0 ← ... ← Cn ← Cm1 ← ... ← Cmn ← Cmb
    #                                      ↖ master + branch2

    #at this point, branch2 exists no more.

    #what would happen if we undid the merge?
    #basically, the changes on Cbn (the target: branch2)
    #would be substracted from Cmb (the merge: master's tip)
    #giving us Cmn (the current: master's previous commit) back.
    #like this:

    #                                            ↙ merge - branch2 = reverted master
    # C0 ← ... ← Cn ← Cm1 ← ... ← Cmn ← Cmb ← Cmn
    #                                      ↖ master + branch2 = merge

    #so at that point, Cmn holds ONLY
    #the changes we had in master,
    #but which commit/branch holds the changes
    #from branch2 now? ...NONE!

    #so, if we undid/reverted a merge commit
    #after deleting the target branch,
    #the changes introduced by it would be lost.

    #So, the moral of the story is...
    #only delete a merged target branch after
    #we're absolutely sure the merge is not
    #going to be reverted.
#end

#-----------------------------------------------------------------------------------
#S04L14 - PROPER MERGE UNDOING

    #merge undoing is only safe and easy when:
    #---- branch2 still exists, and
    #---- the merge is freshly committed.

    #here's both pointers' positions
    #right after the merge:

    #                               ↙ branch2's pointer
    #              ↙ Cb1 ← ... ← Cbn
    # C0 ← ... ← Cn                  ↖
    #              ↖ Cm1 ← ... ← Cmn ← Cmb
    #                                     ↖ master's pointer

    #there are two ways to undo a merge: reset and revert.
#end

#-----------------------------------------------------------------------------------
#S04L14 - RESET A MERGE

    #reset means just
    #making the current branch pointer move back one commit.
    #so it doesn't point to the merge commit anymore.
    #(master's pointer moves back from Cmb to Cmn).

    #so, the current branch (master)'s pointer will point to
    #a commit from before taking the changes from branch2.

    #we say we reset a branch TO some previous commit in it.
    #the commit we reset to is called the "new tip" of the branch.

    #after reseting the merge:

    #                               ↙ branch2's pointer
    #              ↙ Cb1 ← ... ← Cbn
    # C0 ← ... ← Cn                  ↖
    #              ↖ Cm1 ← ... ← Cmn ← Cmb
    #                               ↖ master's pointer

    #notice that now,
    #nothing points to the merge commit (Cmb) anymore
    #so git will autodelete it.

    #however! one cool thing though:
    #if needed, we can reset the current branch pointer
    #back to any specific commit in it. not just one step.

    #what happens to the HEAD pointer?

    #as a general rule, HEAD follows the current branch (master)
    #both when merging and reseting a merge.

    #this means, during merge/reset operations,
    #the state of our filesystem will reflect
    #the state of the new tip of the current branch.

    #however, this behavior during the reset operation
    #can (and must!) be customized.

    #we do so with the following flags (we'll call them "hardness flags"):

    # --soft:  the HEAD pointer
    #          will reflect the new tip of the current branch.
    #          nothing else will be affected.
    # --mixed: the HEAD pointer and the staging area
    #          will reflect the new tip of the current branch.
    #          the filesystem won't be affected.
    # --hard:  the HEAD pointer, the staging area and the filesystem
    #          will all reflect the new tip of the current branch.
    #          (be sure to stash uncommitted changes beforehand!)

    #in order to reset the merge, we need to choose:
    #---- a hardness flag
    #---- a previous commit from the current branch
    #     (which will become its new tip)

    #finally, to reset a merge back to some commit, the command is:
    git reset --<hardness_flag> <commit_identifier>

    #for example, to reset to one commit back,
    #assuming we're in the freshly-merged master branch:
    git reset --hard HEAD~1
    #or, to reset it to 10 commits back:
    git reset --hard HEAD~10
    #or, to reset it to a specific commit (say 4a6c8f2) in master:
    git reset --hard 4a6c8f2

    #at this point, the merge commit has become unreferenced
    #(meaning there aren't any pointers pointing to it)
    #so it will be autodeleted eventually.

    #but before that happens, if we know its 7-digit hex ID,
    #we may recover it with:
    git reset --<hardness_flag> <hex_commit_identifier>
    #(so yes, we technically can reset FORWARD!)

    #we may notice we can also use "git reset"
    #to bring back the state of any branch
    #to any previous commit on it.
    #regardless if there's a merge involved or not!

    #one last thing.
    #using reset, we're effectively rewriting the repo's history.
    #this is harmless if we're the only contributors to it,
    #but if we aren't, resetting is NOT RECOMMENDED.

    #see next section on collaborating on repos,
    #and last section on rewriting history.
#end

#-----------------------------------------------------------------------------------
#S04L14 - CHECKOUT, SWITCH & RESET

    #at this point we might notice the similarities
    #and differences bettween the checkout, switch and reset commands:

    #checkout: moves HEAD to any commit,
    #          and makes the filesystem reflect it.

    #switch:   moves HEAD to the tip of some branch,
    #          and makes the filesystem reflect it.

    #reset:    moves BOTH the current branch and HEAD pointers
    #          back to some previous commit on the current branch,
    #          with custom behavior of the staging area and the filesystem.
#end

#-----------------------------------------------------------------------------------
#S04L14 - REVERT A MERGE

    #revert means making a new commit
    #called a "revert commit"
    #which explicitly substracts branch2's changes from master.

    #just as we've freshly committed a merge, we can assume:
    #---- the tip of the current branch (master) is the merge commit (Cmb).
    #---- both HEAD and master's pointer are pointing to it.

    #                               ↙ branch2
    #              ↙ Cb1 ← ... ← Cbn
    # C0 ← ... ← Cn                  ↖
    #              ↖ Cm1 ← ... ← Cmn ← Cmb
    #                                     ↖ master & HEAD

    #so, if we revert the commit HEAD points to,
    #we'll effectively revert the merge.

    #this will generate a new commit, called a revert commit
    #which is exactly equal to master's tip before the merge (Cmn)
    #and will make master and HEAD's pointers point to it:

    #                               ↙ branch2
    #              ↙ Cb1 ← ... ← Cbn
    # C0 ← ... ← Cn                  ↖
    #              ↖ Cm1 ← ... ← Cmn ← Cmb ← Cmn'
    #                                           ↖ master & HEAD

    #to do so, we need to understand the concept of
    #a merge's "parents":
    #---- the current branch (master) of a commit is parent #1.
    #---- the target branch (branch2) of a commit is parent #2.

    #we need to specify which parent branch
    #will the merge commit be reverted into.

    #it is always recommended to pick parent #1
    #so that the revert commit comes immediately after the merge commit
    #in the same branch.

    #we revert a merge with:
    git revert -m <parent_number> <merge_commit_identifier>

    #for example, in this case since the merge is freshly committed:
    git revert -m 1 HEAD

    #since we're creating a new (revert) commit,
    #git will open the default editor
    #and ask for a commit comment
    #(it also gives us a default which we can just accept).

    #after writing the comment, save and exit the editor.

    #at this point the revert is finished,
    #and the target branch (branch2) still contains
    #the reverted changes, in case we need them.

    #since we've actually committed the revert,
    #the revert ADDS to the repo's history
    #instead of rewriting it, so this is the
    #right way to undo a merge in a shared repo.

    #we can use "git revert" to undo any kind of commit,
    #not just merges.
    #if we undo a non-merge commit, we don't need to
    #specify the parent:
    git revert <commit_identifier>
#end

#-----------------------------------------------------------------------------------
#S04L15 - SQUASHING

    #let's say we have a branch separate from master
    #through which we've worked on a quick and easy bugfix or feature
    #which nonetheless has many commits:

    #             ↙ master
    #M0 ← ... ← Mn               ↙ bugfix
    #             ↖ B0 ← ... ← Bn

    #since the work in the bugfix branch is quick and easy,
    #having many commits in it is noisy.

    #now let's imagine we're done with the bugfix
    #and we intend to merge it into master.

    #we don't want to pollute master's history
    #with too many commits related to some little
    #bugfix or feature.

    #same applies when the commits in the bugfix branch
    #are not well-delimited and meaningful or don't follow
    #a logical sequence. it would pollute master's history.

    #in both cases it would be better if all commits
    #on the bugfix branch were combined into one single meaningful unit
    #and then merged into master.

    #that is an operation called "squashing a branch",
    #which is the first part of "squash merging".
    #this operation introduces a new kind of commit: the "squash commit".
#end

#-----------------------------------------------------------------------------------
#S04L15 - HOW SQUASHING WORKS

    #let's squash-merge the bugfix branch into the master branch.

    #given the current state of our branches:

    #             ↙ master
    #M0 ← ... ← Mn
    #             ↖ B0 ← ... ← Bn
    #                            ↖ bugfix

    #bugfix's tip (Bn) holds all the changes introduced by it.
    #these changes will be put in the staging area of master:

    #             ↙ master (with Bn's changes in staging area)
    #M0 ← ... ← Mn
    #             ↖ B0 ← ... ← Bn
    #                            ↖ bugfix

    #so squashing just introduces a set of changes
    #to be committed on top of master.

    #it doesn't actually join two branches together,
    #nor does it generate a new commit with two parents.
    #so, squashing is technically NOT merging!

    #after squashing,
    #we commit the squashed changes as a separate step.
    #we'll call this commit "Ms":

    #                  ↙ master
    #M0 ← ... ← Mn ← Ms
    #             ↖
    #               ↖ B0 ← ... ← Bn
    #                            ↖ bugfix

    #we do squashing by:

    #first, making sure we're on the current branch (master):
    git switch master
    #and then squashing the target branch (bugfix) into master:
    git merge --squash bugfix

    #at this point we've consolidated all changes from bugfix
    #into the STAGING AREA of master.

    #so, we need to explicitly commit those changes:
    git commit -m "<comment>"

    #(if this commit introduces merge conflicts,
    #they are resolved exactly in the same way
    #we've seen before).

    #at this point our squash "merge" operation is done!

    #here's a confusing detail. if we do:
    git branch --merged
    #or...
    git branch --no-merged

    #it'll show the bugfix branch as NOT merged yet.

    #however if we do:
    git log --oneline --all --graph

    #we'll see the bugfix branch was, in fact
    #squashed into master.

    #this is because squashing is NOT technically merging,
    #so it is advisable to delete the bugfix branch ASAP
    #to avoid confusion.

    #it is preferable to do squashing
    #instead of regular merging
    #whenever we intend to merge a small contribution
    #which has a lot of commits in its branch.

    #for big features whose commits are actually significant
    #it's better to stick to regular 3-way merging.
#end

#-----------------------------------------------------------------------------------
#S04L16 - REBASING

    #given a scenario like:

    #                        ↙ master
    #M0 ← ... ← Mn ← ... ← Mm
    #             ↖
    #               B0 ← ... ← Bn
    #                            ↖ branch2

    #we see branch2 is based on Mn.
    #meaning, Mn is the parent of branch2's first commit (B0).

    #Mn was probably master's tip at the moment
    #we branched out into branch2.
    #but there are newer commits in master now.

    #merging branch2 into master
    #would potentially look like:

    #                              ↙ master
    #M0 ← ... ← Mn ← ... ← Mm  ← Mb
    #             ↖             ↙
    #               B0 ← ... ← Bn
    #                            ↖ branch2

    #which will result in a very convoluted history
    #given both branches bring in many commits.

    #a better way is to make history linear,
    #by moving THE STARTING COMMIT of branch2 forward
    #so that it's based on master's tip:

    #                        ↙ master
    #M0 ← ... ← Mn ← ... ← Mm
    #                        ↖
    #                          B0 ← ... ← Bn
    #                                       ↖ branch2

    #we achieve this by applying the changes
    #on the master-exclusive commits (every commit after Mn)
    #into branch2's first commit (B0).

    #we say we've moved branch2's BASE forward
    #from Mn to Mm.
    #or, we've REBASED branch2.
#end

#-----------------------------------------------------------------------------------
#S04L16 - RISKY REBASING

    #much in the same way as "git reset" does,
    #rebasing is a way of rewriting history
    #and is, thus, dangerous.

    #it is good practice to only rebase
    #when our repo is local, not shared.

    #this is because, commits in git are immutable.
    #they can be created and deleted,
    #but never modified nor re-pointed to a new parent.

    #while it may seem that by rebasing we re-pointed
    #B0 from Mn to Mm, this is not what actually happened.

    #in reality, rebasing clones the rebased branch,
    #meaning, given this initial scenario:

    #M0 ← ... ← Mn ← ... ← Mm ← master
    #             ↖ B0
    #                 ↖ ...
    #                      ↖ Bn ← branch2

    #---- first, it creates a new branch (branch2c)
    #     equal to the rebased branch (branch2).
    #---- next, it creates new commits (B0c - Bnc)
    #     equal to those in the rebased branch (B0 - Bn).
    #---- third, it points the clone of the first rebased commit (B0c)
    #     to the current branch (master)'s tip.
    #---- finally, it re-points the rebased branch's pointer
    #     to the cloned branch's tip.

    #                        ↙ master
    #M0 ← ... ← Mn ← ... ← Mm
    #             ↖ B0       ↖ B0c
    #                 ↖ ...       ↖ ...
    #                      ↖ Bn        ↖ Bnc ← branch2

    #the result is leaving the original branch2
    #unreferenced by any pointers, and thus,
    #git will eventually autodelete it.

    #what would happen if other contributors
    #are unaware of the rebasing and keep their
    #version of branch2 growing?

    #their history is going to be based on
    #a branch that will be autodeleted.
#end

#-----------------------------------------------------------------------------------
#S04L16 - HOW TO REBASE

    #in order to rebase a branch, we need:
    #---- two branches which have diverged by at least one commit each
    #     (say, master and branch2).
    #---- to know which branch will be rebased
    #     (we'll call it the rebased branch, in this case branch2,
    #     and the other one will be the base branch, in this case master)
    #---- to be in the rebased branch.

    #we begin by switching into the rebased branch:
    git switch <rebased_branch>
    #in this case:
    git switch branch2

    #and then, rebasing with:
    git rebase <base_branch>
    #in this case:
    git rebase master

    #at this point we might hit conflicts,
    #similar to merge conflicts.

    #if there are no conflicts, we're done!

    #if there are conflicts, we'll be in the mid-rebase state.
    #in this state we may do one of the following:

    #A) continue rebasing, but omit the current conflicting commit:
    git rebase --skip

    #B) cancel and abort the rebasing:
    git rebase --abort

    #C) solve the conflicts manually (using something like p4merge):

    #one cool thing,
    #we can just call our default merge tool
    #while in the mid-rebase state
    #and it will know which files to compare automatically:
    git mergetool

    #after resolving the conflicts,
    #save and stage the conflict-resolved files,
    #then retry the rebasing:
    git rebase --continue

    #it's possible that p4merge has created backup files
    #for the conflicts we resolved.
    #these files usually have the .orig extension.

    #we may delete all of them with:
    git clean -fd

    #or even better, we might add
    #the *.orig extension to our .gitignore file
    #so that these files never bother us.

    #also, remember we prevented these files
    #from being created on S01L06.
    #check the git config if they are created.
#end

#-----------------------------------------------------------------------------------
#S04L17 - CHERRY PICKING

    #sometimes, we have fixed a bug or introduced a feature
    #with some commit Cb in some branch B,
    #but haven't finished working on the whole issue
    #B was created for.

    #so, one little change Cb can be merged into other branches
    #but the whole branch B is not ready yet.

    #it's possible to take the one commit Cb that is ready
    #and apply it into another branch A,
    #without merging the whole branch B into A.

    #this is called CHERRY-PICKING.

    #to do so, we need:
    #---- two branches, with
    #     at least one (B) branched ahead of the other one (A).
    #---- one commit Cb in B that is finished, working and tested,
    #     and that A doesn't have.
    #---- the 7-digit hex ID of commit Cb.
    #---- to be in branch A (the current branch).

    #we begin by switching into A, our current branch:
    git switch <current_branch>
    #for example, if we intend to cherry-pick into master:
    git switch master

    #then we cherry-pick commit Cb from B into A:
    git cherry-pick <hex_commit_identifier>

    #at this point we might hit conflicts,
    #similar to when merging or rebasing.

    #if there are no conflicts, we're done!

    #if there are conflicts, we'll be in the mid-cherrypick state.
    #now we need to solve the conflicts manually (with p4merge as usual):

    #once again we can just call our default merge tool
    #while in the mid-cherrypick state
    #and it will know which files to compare automatically:
    git mergetool

    #after resolving the conflicts,
    #save and stage the conflict-resolved files.

    #now, we need to commit the cherrypicked files.
    #we may omit the commit comment if in the mid-cherrypick state:
    git commit

    #the default text editor will appear,
    #so we may accept or edit the commit comment.
    #then save and exit.
#end

#-----------------------------------------------------------------------------------
#S04L18 - SINGLE-FILE CHERRY PICKING

    #instead of cherrypicking a whole commit
    #from another branch B into branch A,
    #we may just get B's latest version of some file Fb
    #and have it replace A's version of it.

    #first, we need to be in the current branch A:
    git switch <current_branch>
    #in case we are cherrypicking into master:
    git switch master

    #then, we pick the target branch B and the file Fb:
    git restore --source=<target_branch> -- <file_path>
    #in case we're cherrypicking index.txt from branch2 into master:
    git restore --source=branch2 -- index.txt

    #notice the two dashes just before the file path.

    #or, we may also pick a file
    #from a specific commit from any branch
    #all we need is the commit's 7-digit hex ID:
    git restore --source=<hex_commit_identifier> -- <file_path>
    #in case we're cherrypicking index.txt from commit 6e9b2d4 into master:
    git restore --source=6e9b2d4 -- index.txt
#end

#-----------------------------------------------------------------------------------
#S04L19 - BRANCHING IN VSCODE

    #be sure to have the gitlens and git graph plugins installed.

    #click on the gitlens icon, and then
    #expand the REPOSITORIES section, and then
    #expand our repo section.

    #we'll see a section called Branches.
    #expanding it, we'll see one branch marked
    #with a tickmark. That is the branch we're currently on.
    #(so we'll know HEAD points to that branch's tip).

    #the current working branch is also shown
    #in vscode's lower left corner.
    #by clicking it, we can switch to another branch.

    #if we name our branches like <something>/<something else>
    #we'll see them here organized by folder in a tree structure.

    #we also can show all branches as a simple list.

    #by expanding a branch, we'll see its commit history.

    #we can create a new branch B
    #based on some existing branch A's tip
    #by right clicking on A and selecting "create branch".

    #do not confuse the gitlens icon on the left
    #with the source control icon.

    #in the source control section we can stage any changes
    #to any file(s) we've made (as part of the current working branch).
    #by clicking the plus sign to "git add"
    #and the tickmark to "git commit"
    #like we've done in previous sections.

    #at the top of the gitlens section,
    #by expanding REPOSITORIES and then our repo,
    #we can find the Compare option.

    #it compares the current working branch
    #against whichever branch we pick.
    #it shows the differences in commits and files.

    #by right-clicking on some branch
    #OTHER THAN the current working one
    #we get the option of merging or rebasing it
    #into the current working one.

    #by choosing to merge, we get the option to do
    #a regular merge, a fast-forward, a 3-way or a squash merge.

    #by picking any of those (or rebasing)
    #we can run into conflicts.
    #we may fix them manually by going into the source control section
    #and double click on any file marked with a C.

    #there we can resolve the conflicts manually,
    #and then save and exit.
    #then stage the changes and commit.

    #our merge commit will show up in the gitlens section.
    #by right-clicking it and selecting "reset commit"
    #we can reset the branch back 1 commit.

    #we can only undo commits with reset.
    #the revert option is there, but it does not work.

    #the reset commit option lets us choose
    #between a hard or soft reset.

    #in the gitlens section, at the bottom of our expanded repo
    #we can find the stashes section.
    #by clicking on the curved arrow with a plus sign,
    #we stash all uncommitted changes.

    #every stash in this section will have a button
    #for applying the changes in it to the current branch,
    #and another one for deleting the stash.

    #by clicking the source control icon on the left
    #and then clicking the git graph icon on the top
    #we can see a graphical representation of all the repo's history,
    #including all branches.
#end

#-----------------------------------------------------------------------------------
#S04L20 - BRANCHING IN GITKRAKEN

    #gitkraken shows a graphical view of all branches by default.
    #the master branch and all unmerged branches will be shown in saturated colors
    #while the merged branches will be shown in pale colors.

    #the dropdown menu on the top lets us switch to a different branch.

    #by right-clicking into any branch A's tag on the left
    #we get a menu where we can choose "create branch here"
    #with which we can create a new branch B based on A's tip.

    #at this point we can use some text editor to make changes
    #and then back at gitkraken, use the right panel to stage and commit them.

    #if we had unmerged changes across branches,
    #we'd see the divergence in the main view's graph.

    #we can also compare two branches
    #by holding shift and clicking on the two branches,
    #then picking a file from the right panel.
    #this sends us to the diff viewer like we've done before.

    #while only one branch A is selected,
    #we can click on another one B and choose to merge B into A.

    #if that hits a conflict, we can navigate the right panel
    #to find the conflicting files, and then right clicking them
    #to go to the diff/merge view.

    #the diff/merge view lets us choose between the changed lines
    #on the two branches, side by side,
    #and also shows us the resulting file on the bottom.

    #after resolving the conflicts, back in the main view
    #we can go to the right panel and stage and commit the
    #resolved conflicts.

    #to undo a merge commit, simply right click a merge commit
    #on the graph, and choose to revert it.

    #it's also possible to, given the current working branch A,
    #right click in any previous commit in A
    #and choose to reset A to this commit.
#end

#-----------------------------------------------------------------------------------
#END OF SECTION 04
