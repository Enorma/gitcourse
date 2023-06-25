#SECTION 06: COLLABORATION

#-----------------------------------------------------------------------------------
#S06L01 - INTRODUCTION

    #basic introduction here...
    #this section uses the "Mercury" repo, included in the course materials.
#end

#-----------------------------------------------------------------------------------
#S06L02 - WHY REWRITE HISTORY

    #we need a repo's commit history to see
    #what changed, why, when and by whom.

    #the history is supposed to be clean
    #and easily readable.
    #it's supposed to tell the story of our repo
    #at first glance.

    #it is NOT good history when:
    #---- related commits are scattered instead of together
    #     (reordering them could solve that).
    #---- commit comments are not short, concise and descriptive
    #     (editing the comments could solve that).
    #---- commits are not well-bounded to exactly one issue at a time
    #     (splitting them could solve that).
    #---- there are too many commits dealing with tiny steps of one task
    #     (squashing them could solve that).
    #---- there are accidentally-made commits which shouldn't be there
    #     (dropping them could solve that).
    #---- some commits are incomplete by mistake
    #     (modifying them could solve that).

    #so we have operations to fix the history if it's bad,
    #but rewriting history is generally dangerous.
#end

#-----------------------------------------------------------------------------------
#S06L03 - THE GOLDEN RULE

    #the golden rule is:
    #"do NOT rewrite public history".

    #anything we've pushed to github is public
    #and should be set in stone forever.

    #here's why.
    #we begin in the following state:

    #LOCAL'S POV:
    #         ↙ master
    # Ca ← Cb
    #         ↖ origin/master

    #GITHUB'S POV:
    #         ↙ master
    # Ca ← Cb

    #commits, once committed, are immutable.
    #modifying them actually means to duplicate them
    #and making the modifications on the duplicate.

    #given commit Cb, say we modify its comment.
    #if we attempt to modify commit Cb,
    #we'll actually create a new commit Cb'.

    #attempting to "replace" a publicly-known past commit Cb
    #with a modified commit Cb' is to rewrite public history,
    #so that's one way to violate the golden rule!

    #if we do so, we'll be in a state like:

    #LOCAL'S POV:
    #   ↙ Cb' ← master
    # Ca
    #   ↖ Cb  ← origin/master

    #and now the problems begin.
    #if we attempt to push our modified Cb',
    #the push will be rejected, because:

    #in github, master points to Cb,
    #while in local, Cb still exists, but master points to some new commit Cb',
    #and both Cb and Cb' come from Ca.
    #so, in fact, Cb' has become a new, diverging branch,
    #not the same master github knows.

    #so notice how we've caused problems just by
    #modifying the comment of a commit,
    #which is a seemingly innocent and harmless operation.
    #imagine the problems if we actually modified its code changes.

    #it gets worse.
    #here's 3 scenarios where we experience problems down the line
    #because of our initial violation of the golden rule:
#end

#-----------------------------------------------------------------------------------
#S06L03 - SCENARIO #1 (FORCE PUSH)

    #to override the rejected push,
    #we could just force it through, with
    #"git push --force".

    #(the --force flag allows us to rewrite public history,
    #so it, too, violates the golden rule!)

    #forcing the push will result in the following state:

    #LOCAL'S POV:
    #         ↙ master
    # Ca ← Cb'
    #         ↖ origin/master

    #GITHUB'S POV:
    #         ↙ master
    # Ca ← Cb'

    #this new state is very dangerous, since
    #there is probably one collaborator (say, John) or more
    #who are working on some new commit Cc
    #but aren't aware that Cb was replaced by Cb':

    #JOHN'S POV:
    #             ↙ master
    # Ca ← Cb ← Cc
    #         ↖ origin/master

    #John might want to push Cc,
    #which is going to be rejected, since
    #in his local, Cc comes from Cb,
    #but there is no Cb anymore in github!

    #so we've caused problems for John and everyone in the team,
    #because we attempted to modify Cb into Cb' in the first place,
    #and then made it worse by force-pushing it!
#end

#-----------------------------------------------------------------------------------
#S06L03 - SCENARIO #2 (FORCE PUSH + MERGE)

    #coming from scenario #1,
    #John might attempt to fix his situation.

    #to do so, before he pushes Cc,
    #he could fetch from github,
    #to be aware of commit Cb':

    #JOHN'S POV:
    #             ↙ master
    # Ca ← Cb ← Cc
    #    ↖ Cb'
    #         ↖ origin/master

    #and then, merge Cc and Cb',
    #creating the commit Cm:

    #JOHN'S POV:
    #                   ↙ master
    # Ca ← Cb ← Cc ← Cm
    #    ↖ Cb'       ↲
    #        ↖ origin/master

    #finally, John pushes his changes
    #which are allowed:

    #GITHUB'S POV:
    #                   ↙ master
    # Ca ← Cb ← Cc ← Cm
    #    ↖ Cb'       ↲

    #so John has successfully pushed his changes,
    #and the situation is seemingly fixed for him, but
    #now the repo has a non-linear and noisy history.

    #notice that a clean, equivalent history would be:
    #              ↙ master
    # Ca ← Cb ← Cc

    #because:
    #Cb' is identical to Cb in terms of code changes,
    #they just differ in their comment.

    #Cm also doesn't introduce any new code changes
    #different from those Cb, Cb' and Cc already had introduced.

    #therefore, Cb' and Cm are just noise.
    #we should avoid these scenarios by sticking to the golden rule.
#end

#-----------------------------------------------------------------------------------
#S06L03 - SCENARIO #3 (MERGE BEFORE PUSH)

    #let's go back to before we forced the push in scenario #1,
    #so we're the only collaborator affected so far.

    #our push was rejected, but we won't force it.
    #to fix it, we first merge Cb and Cb' into a new commit Cm.

    #LOCAL'S POV:
    #   ↙ Cb' ↰  ↙ master
    # Ca      Cm
    #   ↖ Cb  ↲
    #       ↖ origin/master

    #then, we push the changes and this time the push works:

    #GITHUB'S POV:
    #   ↙ Cb' ↰  ↙ master
    # Ca      Cm
    #   ↖ Cb  ↲

    #this seemingly works, but again,
    #we've created a non-linear and noisy history.

    #so, in all 3 scenarios we found some way
    #to work around the problem, but
    #it wasn't an elegant solution, and now we have a polluted history.

    #the problem should have been avoided in the first place
    #by sticking to the golden rule.
#end

#-----------------------------------------------------------------------------------
#S06L03 - GOOD REWRITING PRACTICE

    #if we're working on a local-only branch,
    #rewriting that branch's history is totally fine.

    #in fact, operations like squashing are
    #recommended, as long as they only affect local history,
    #since they can clean up our local changes
    #before we push them.

    #that's an addendum to the golden rule:
    #"do clean up your contributions by rewriting history
    #of your local-only branches and commits".
#end

#-----------------------------------------------------------------------------------
#S06L04 - A BAD HISTORY

    #suppose we check the history of our repo with:
    git log --oneline --all --graph

    #and the output is as follows:

    # * 088455d (HEAD -> master) .
    # * f666091 WIP
    # * 111bd75 Update terms of service and Google Map SDK version.
    # * 72856ea WIP
    # * 8441b05 Add a reference to Google Map SDK.
    # * 8527033 Change the color of restaurant icons.
    # * af26a96 Fix a typo.
    # * 6fb2ba7 Render restaurants the map.
    # * 70ef834 Initial commit

    #we can see many bad practices, like:

    #---- commit 088455d doesn't have a comment.
    #---- commits f666091 and 72856ea aren't descriptive at all.
    #---- commit 111bd75 does two unrelated things.
    #---- commit af26a96 cites a typo that shouldn't have been made in the first place.
    #---- commit 6fb2ba7 should say "Render restaurants ON the map."
    #---- commits 6fb2ba7, af26a96, 8527033 and 8441b05 are related to displaying a map of restaurants,
    #     so they are part of the same unit of work, so they should be squashed together.
    #---- commit 8441b05 is a basic component of the restaurant map feature,
    #     so the restaurant map feature won't work any earlier than that,
    #     so it should appear earlier in the history,
    #     or else, earlier commits would essentially have introduced non-working code.

    #in future lessons we'll fix all of those.
#end

#-----------------------------------------------------------------------------------
#S06L05 - UNDOING COMMITS

    #remember that
    #undoing by resetting rewrites the history,
    #while undoing by reverting doesn't.

    #to stick to the golden rule,
    #if a commit is public, we may undo it
    #only by reverting it.

    #here we intend to undo commit 088455d
    #from the previous example.

    #but, let's see what we might lose if we undo it.
    #to see what changes were introduced by 088455d, we do:
    git show 088455d

    #in the output, this diff is shown:

    #------------------------------------
    # diff --git a/terms.txt b/terms.txt
    # index 6ab9fed..63cbee7 100644

    # --- a/terms.txt
    # +++ b/terms.txt

    # @@ -1 +1,2 @@

    # completed
    # +TEST
    #------------------------------------

    #so, 088455d only added the word "TEST" to terms.txt.
    #we can afford to lose that, so let's go forward
    #with undoing it.

    #first, let's assume commit 088455d is public.

    #we revert any commit with:
    git revert <commit_identifier>
    #in this example:
    git revert 088455d
    #or, since it's the latest commit, we may also do:
    git revert HEAD

    #now, let's assume 088455d is NOT public.

    #we are allowed to reset such a commit with:
    git reset --<hardness_flag> <commit_identifier>
    #in this example, assuming we want to reset our whole environment:
    git reset --hard 088455d
    #or, since it's the latest commit:
    git reset --hard HEAD~1

    #keep in mind, these operations might generate conflicts.
#end

#-----------------------------------------------------------------------------------
#S06L06 - REVERTING COMMITS

    #when resetting to a commit relative to HEAD,
    #we specify which commit will become the new tip of the branch.

    #in contrast, when reverting a commit,
    #we specify which commit will be reverted.

    #for example:

    git reset --hard HEAD~3
    #will make the whole local repo
    #reflect the state it was in
    #at the time of making the "HEAD~3" commit.

    #and...

    git revert HEAD~3
    #will make a new commit,
    #which substracts the changes
    #introduced by the "HEAD~3" commit.

    #where...

    #HEAD~3 is the commit made 3 commits before
    #the commit HEAD is pointing to.

    #for example...

    #considering the output of this:
    git log --oneline --all --graph
    # * 088455d (HEAD -> master) .
    # * f666091 WIP
    # * 111bd75 Update terms of service and Google Map SDK version.
    # * 72856ea WIP
    # * 8441b05 Add a reference to Google Map SDK.
    # * 8527033 Change the color of restaurant icons.
    # * af26a96 Fix a typo.
    # * 6fb2ba7 Render restaurants the map.
    # * 70ef834 Initial commit

    #HEAD is 088455d.
    #HEAD~3 is 72856ea.

    #resetting to HEAD~3 will undo all commits after 72856ea.
    #reverting HEAD~3 will only undo 72856ea and will create a new revert commit.
#end

#-----------------------------------------------------------------------------------
#S06L06 - REVERTING A RANGE

    #so we've seen how to revert a single commit.
    #but we can revert a range of commits with:

    git revert <older_bound_commit>..<newer_bound_commit>

    #where the older and newer bounds are commit identifiers,
    #like 7-digit hex ID's or pointers relative to HEAD.

    #keep in mind:
    #---- the older bound is NOT INCLUSIVE,
    #     which means it won't be reverted.
    #---- the newer bound is INCLUSIVE,
    #     which means it will be reverted.
    #---- every commit inbetween them will be reverted.

    #so for example, with this revert:
    git revert 72856ea..088455d
    #or the equivalent:
    git revert HEAD~3..HEAD
    #or, since the newer bound is HEAD itself, we can omit it:
    git revert HEAD~3..

    #we'll make 3 new commits, reverting the changes
    #introduced by 088455d, f666091 and 111bd75, respectively, in that order.

    #however, the reverts will happen one-by-one,
    #which means, for every reverted commit in the range,
    #the default text editor will pop up
    #asking for a comment for the revert commit.

    #so this operation will introduce 3 revert commits,
    #which pollutes the history.
#end

#-----------------------------------------------------------------------------------
#S06L06 - REVERTING A RANGE IN A SINGLE COMMIT

    #it's better to just let git figure out
    #which changes were introduced by the commits we intend to revert,
    #and then make new changes which substract those changes.

    #finally, our substractions will only be staged, not committed,
    #so we can commit them as a single revert commit afterwards.

    #we do so with the "--no-commit" flag:
    git revert --no-commit 72856ea..088455d
    #or:
    git revert --no-commit HEAD~3..HEAD
    #or:
    git revert --no-commit HEAD~3..

    #after that, if we check our staging area:
    git status -s

    #we'll see the same files changed in the range of reverted commits
    #which means we've substracted those changes and staged those files
    #without them.

    #at this point we're in the mid-revert state.

    #we might abort the reversion with:
    git revert --abort

    #or we might finish the reversion with:
    git revert --continue

    #which will bring up the default text editor
    #asking for a comment for the revert commit.

    #in this case the default autogenerated comment
    #only addresses one commit in the reverted range
    #so it is advisable to write a better one.

    #watch out for conflicts throughout this process.
#end

#-----------------------------------------------------------------------------------
#S06L07 - RECOVERING A LOST COMMIT

    #unreferenced commits remain in the history for a while
    #before git's garbage collector comes and autodeletes them.

    #this gives us plenty time to recover them if we deleted
    #or unreferenced them by accident.

    #to see a complete history of a pointer
    #and all its movements, including the deleted stuff,
    #we do:

    #for the HEAD pointer (by default):
    git reflog
    #for any other pointer:
    git reflog show <pointer>

    #in its output, we'll see a list of commits
    #sorted top-to-bottom from newest to oldest.

    #so every entry is a commit
    #the pointer has pointed to over time.

    #every entry has a unique ID in the format:
    # HEAD@{<N>}
    #or, more generally:
    # <pointer>@{<N>}

    #it also shows the operation which caused it to move,
    #commit, rebase, revert and reset are the most common.

    #finally it shows us a brief description of the operation.

    #since "git reflog" shows us the unique ID's,
    #we can use those with "git reset" to recover some previous state.

    #for example, let's say we did a reset to a commit
    #older than HEAD@{5} by accident,
    #so HEAD@{5} is an unreferenced commit.

    #we can recover to the state we were at
    #when HEAD@{5} was freshly committed, with:
    git reset --hard HEAD@{5}
#end

#-----------------------------------------------------------------------------------
#S06L08 - FIXING THE LAST COMMIT

    #the most-recent commit is always the most
    #prone to modifications.

    #we could fix the situation by doing more changes
    #and making a new commit

    #but we can also fix the latest commit itself.

    #to do so, first we make the fixing changes and stage them,
    #and then we do:
    git commit --amend -m "<comment>"

    #but be aware this rewrites history!

    #another way to do this is, first,
    #resetting to the next-to-last commit,
    #but keeping the changes in the filesystem:
    git reset --mixed HEAD~1

    #then, check our changes are still in the filesystem:
    git status -s

    #then, make the fixing changes.

    #(if we introduced a new file in the bad commit,
    #and the fix we intend to do involves
    #not introducing it after all, remember to
    #remove it safely with "git clean -fd")

    #then just as in any regular commit,
    #stage the fixing changes with "git add",
    #and then do "git commit -m <comment>" normally.

    #no need for the --amend flag
    #since we did reset to the penultimate commit previously.
#end

#-----------------------------------------------------------------------------------
#S06L09 - FIXING OLDER COMMITS

    #let's say we have these commits in our history:

    # * a6d03aa (HEAD -> master) Render cafes on the map.
    # * 3d8e437 Revert bad code.
    # * f666091 WIP
    # * 111bd75 Update terms of service and Google Map SDK version.
    # * 72856ea WIP
    # * 8441b05 Add a reference to Google Map SDK.
    # * 8527033 Change the color of restaurant icons.
    # * af26a96 Fix a typo.
    # * 6fb2ba7 Render restaurants the map.
    # * 70ef834 Initial commit

    #now, let's say we want to modify a bad commit (8441b05),
    #but keep it in the same place in the history.

    #(of course this rewrites history,
    #so if this is a public repo, just make the
    #desired modifications into a new regular commit.)

    #what we intend to do is called "interactive rebasing" (IR).

    #this technique involves:
    #---- the commit we intend to fix (8441b05).
    #---- every commit after it.
    #---- its parent (8527033).

    #we'll basically make a new commit which
    #combines the bad one (8441b05)
    #with some fixing changes.

    #then, rebase that commit to come
    #right after the bad commit's parent (8527033).

    #then, rebase every newer commit in the branch
    #(72856ea to a6d03aa) to come after the fixed commit (8441b05).

    #for example:

    #say we have these four commits considered
    #in an IR session:

    #                 ↙ branch
    #Ca ← Cb ← Cc ← Cd

    #Cb is a bad commit we intend to fix.
    #so, we fix it, which means we're actually
    #creating a new commit. we'll call it Fb.

    #Fb is equal to Cb in anything except the fixes we made,
    #meaning its parent is Ca, too:

    #                 ↙ branch
    #Ca ← Cb ← Cc ← Cd
    #   ↖ Fb

    #in order to keep the history working, we need to
    #rebase every later commit to come after Fb (Cc and Cd).
    #but to do that, git also has to create new commits
    #(we'll call them Rc and Rd).

    #(rebasing changes the parent of a commit,
    #which counts as modifying it,
    #which is why git has to create a new one.
    #remember: commits are immutable!)

    #                 ↙ branch
    #Ca ← Cb ← Cc ← Cd
    #   ↖ Fb ← Rc ← Rd

    #finally, the branch pointer needs to
    #point to our newly made commits:

    #Ca ← Cb ← Cc ← Cd
    #   ↖ Fb ← Rc ← Rd
    #                 ↖ branch

    #eventually, git will autodelete the unreferenced commits
    #leaving us with:

    #Ca ← Fb ← Rc ← Rd
    #                 ↖ branch
#end

#-----------------------------------------------------------------------------------
#S06L09 - INTERACTIVE REBASING

    #IR is done with:
    git rebase -i <parent_commit>
    #in this case:
    git rebase -i 8527033

    #at this point we've entered the IR state.

    #our default text editor will pop up,
    #and show us a list of all the commits that will be rebased
    #(those after the parent).

    #it also shows us a list of operations we can perform
    #while in the IR state.

    #by default, the text editor will prepend all
    #commits at the top with "pick"
    #which means to include them in the rebasing.

    #but we can change "pick" to any other of the
    #operations listed below.

    #in this case, we'll change the bad commit (8441b05)
    #from "pick" to "edit",
    #since we want to edit that commit, not just pick it as-is.

    #picked commits are just included in the rebasing as-is.
    #but as soon as one commit is modified in any way,
    #all commits which follow it will be rebased
    #(which means git will actually create new commits that replace them!)

    #after we have chosen the operations to make,
    #save and exit the text editor.

    #at this point, git will auto-perform the operations it can
    #but when it hits the "edit" operation
    #(like the one we chose for commit 8441b05)
    #it will give us back the control of the terminal
    #so we can make the desired changes to the bad commit.

    #in this case, we make the fixes to 8441b05,
    #then stage them
    #then do:
    git commit --amend -m <comment>

    #at this point, if we checked our history with
    git log --oneline --all --graph

    #we'll get the output:

    # * 278e318 (HEAD) Add a reference to Google Map SDK.
    # | * a6d03aa (master) Render cafes on the map.
    # | * 3d8e437 Revert bad code.
    # | * f666091 WIP
    # | * 111bd75 Update terms of service and Google Map SDK version.
    # | * 72856ea WIP
    # | * 8441b05 Add a reference to Google Map SDK.
    # |/
    # * 8527033 Change the color of restaurant icons.
    # * af26a96 Fix a typo.
    # * 6fb2ba7 Render restaurants the map.
    # * 70ef834 Initial commit

    #we'll see we branched out from the parent commit (8527033),
    #and now we have our old bad commit (8441b05) in one branch
    #and the new, fixed version of it (278e318).

    #next is the mass-rebasing of all later commits.
    #since we didn't choose to edit any other commit
    #(we left the rest of the commits marked with "pick")
    #the rest of the IR can be done automatically.

    #to let the IR continue, we do:
    git rebase --continue

    #all the rest of the steps will be performed
    #automatically and the IR will finish.

    #after the IR, our history looks like:
    git log --oneline --all --graph

    # * 42337c8 (HEAD -> master) Render cafes on the map.
    # * fd7430b Revert bad code.
    # * deb3501 WIP
    # * 4033249 Update terms of service and Google Map SDK version.
    # * 6cbd931 WIP
    # * 278e318 Add a reference to Google Map SDK.
    # * 8527033 Change the color of restaurant icons.
    # * af26a96 Fix a typo.
    # * 6fb2ba7 Render restaurants the map.
    # * 70ef834 Initial commit

    #where every commit after 8527033
    #has been changed by a new one,
    #and our old commits are now unreferenced.

    #we can test that our rebasing worked
    #by checking out one of the later commits
    #(say, deb3501) and seeing that the fixes
    #we made to 278e318 are right there.

    #so, each one of the new commits
    #knows the changes made to the old ones.

    #note:
    #at any point while IR'ing,
    #we can discard the whole operation and go back
    #to the previous state with:
    git rebase --abort
#end

#-----------------------------------------------------------------------------------
#S06L10 - DROPPING COMMITS

    #as a similar operation to before,
    #inside an IR session
    #we can choose to drop a commit.

    #which means, making it so
    #the changes introduced by said commit
    #never happened.

    #to do so, given a set of commits
    #chosen for IR'ing,
    #we change the prefix of the commit we want to drop
    #from "pick" to "drop".

    #for example, given the history:
    git log --oneline --all --graph

    # * 42337c8 (HEAD -> master) Render cafes on the map.
    # * fd7430b Revert bad code.
    # * deb3501 WIP
    # * 4033249 Update terms of service and Google Map SDK version.
    # * 6cbd931 WIP
    # * 278e318 Add a reference to Google Map SDK.
    # * 8527033 Change the color of restaurant icons.
    # * af26a96 Fix a typo.
    # * 6fb2ba7 Render restaurants the map.
    # * 70ef834 Initial commit

    #if we want to drop commit 6cbd931

    #we start an IR session from its parent:
    git rebase -i 278e318
    #we can also reference a commit's parent with:
    git rebase -i 6cbd931~1
    #or with:
    git rebase -i 6cbd931^

    #the text editor will pop up
    #where we'll need to prefix 6cbd931 with "drop".

    #however, in this particular case,
    #we will hit a conflict.

    #because 6cbd931 introduced a file terms.txt
    #and a later commit 4033249 made changes to terms.txt.

    #by dropping 6cbd931 we're telling git
    #terms.txt was never created,
    #so 4033249 can't apply changes to it.

    #we'll need to resolve this conflict manually.
#end

#-----------------------------------------------------------------------------------
#S06L10 - CONFLICTS WHILE INTERACTIVE REBASING

    #from where we were, save the changes and exit the editor.
    #git will immediately become aware of the conflict.

    #if we do:
    git status -s
    #we'd see:
    # DU terms.txt (in red)
    #which means terms.txt is staged for deletion,
    #but is updated in the filesystem.

    #but, good news.
    #these are the kind of conflicts that can be resolved
    #semi-automatically.

    #this means we still have to run our merge tool:
    git mergetool

    #however, we don't actually have to go inside p4merge.
    #we just need to make a choice between:
    #---- keeping the file with its latest changes
    #     (so keep the version from 4033249), or...
    #---- deleting the file
    #     (so just undoing its creation from 6cbd931).

    #we pick "m" for "modified" to keep the file and its changes.
    #("d" is for deleting the file
    #and "a" is for aborting the conflict resolution).

    #note: if aborting the conflict resolution
    #we'd remain in both the IR session
    #AND in a conflicted state.

    #after resolving the conflict, if we do:
    git status -s
    #we'd see:
    # A  terms.txt (in green)
    #which means terms.txt is freshly added
    #including its up-to-date contents,
    #and is staged.

    #now, we can continue the IR
    #and have it finish automatically:
    git rebase --continue

    #the text editor will pop up,
    #and we'll have to re-write one or more commit comments
    #(or keep the provided defaults)
    #and then save and exit the editor.

    #a quick note:
    #if dropping commits on an IR session
    #and if no conflicts are hit,
    #the IR will auto-finish
    #as soon as we save the IR operations
    #and close the text editor.
#end

#-----------------------------------------------------------------------------------
#S06L11 - EDITING COMMIT COMMENTS

    #if we look at commit 6fb2ba7
    #we see its comment has a typo:
    #"Render restaurants the map."
    #which should be:
    #"Render restaurants on the map."

    #also, in commit 278e318 we introduced the
    #Google Map SDK, but the version
    #is not mentioned in the comment.

    #so 6fb2ba7 and 278e318 are bad commits.
    #we'll fix both starting from 6fb2ba7
    #because it's the older one.

    #to fix a commit comment,
    #we start an IR session from its parent:
    git rebase -i 6fb2ba7^

    #then prefix the bad commit with "reword"
    #instead of "pick".

    #so, the operations will read:
    #reword 6fb2ba7 Render restaurants the map.
    #...
    #reword 278e318 Add a reference to Google Map SDK.
    #...

    #one by one, git will bring up the text editor
    #so we can edit the commit comment for our bad commits.

    #in the first one (6fb2ba7) we write:
    #"Render restaurants on the map."
    #and in the second one (278e318):
    #"Add a reference to Google Map SDK v1.0."

    #save and exit the editor after each.
    #then the IR will auto-finish.

    #at this point, looking at the history:
    git log --oneline --all --graph

    #we'll see every commit starting from 6fb2ba7
    #has changed (the 7-digit hex IDs are all different)
    #so once again, we've rewritten history.
#end

#-----------------------------------------------------------------------------------
#S06L12 - REORDERING COMMITS

    #as we've noticed before,
    #there is one commit which
    #adds a reference to Google Map SDK v1.0.
    #(commit 6439ec3, coming from the previous lesson).

    #this commit came too late,
    #since said SDK is a required dependency
    #of all map-related functionality,
    #but there are map-related features
    #introduced in earlier commits.

    #that means those features didn't actually work
    #at the moment they were committed!
    #why would we ever want to commit non-working code?

    #so, we need to reorder the commits
    #so that 6439ec3 comes before all other
    #map-related commits (a64e89e to 6f7fefe).

    #to do so, we start an IR session
    #starting from the parent of the earliest commit involved (a64e89e):
    git rebase -i a64e89e^

    #at the IR editor,
    #just reorder the commits line-by-line
    #until they are in the order we want.
    #(keep in mind earlier comments go at the top
    #and later ones go at the bottom.)

    #save and exit the editor

    #at this point, if there are conflicts,
    #resolve them and then do "git rebase --continue".

    #afterwards, the IR session will auto-finish.

    #now check the new reordered history:
    git log --oneline --all --graph
#end

#-----------------------------------------------------------------------------------
#S06L13 - SQUASHING COMMITS

    #these 3 commits:
    # 8b134d2 Render restaurants on the map.
    # 24c6d63 Fix a typo.
    # 87d23b3 Change the color of restaurant icons.

    #are related to the same unit of work.
    #so, they would pollute the public history
    #if pushed like that.

    #it's better to squash them together while we still can.
    #(let's call them "squashable commits").

    #to do so, we start an IR session
    #starting from the parent of the earliest commit involved:
    git rebase -i 8b134d2^

    #at the IR editor,
    #first make sure the squashable commits
    #are contiguous and sorted
    #earliest (top) to latest (bottom),
    #and also in the proper place
    #with respect to the other commits.

    #then mark the squashable commits
    #by replacing the "pick" prefix
    #with "squash", EXCEPT THE EARLIEST ONE.

    #this is because every commit marked
    #with "squash", will be squashed into the previous one.
    #so the earliest squashable commit
    #must be marked with "pick", like normal.

    #so the squashable commits will look like:
    # pick 8b134d2 Render restaurants on the map.
    # squash 24c6d63 Fix a typo.
    # squash 87d23b3 Change the color of restaurant icons.

    #save and exit the editor.
    #then another editor window will come up
    #where we can provide a new commit comment
    #for the resulting squashed commit.
    #after we do so, save and exit it too.

    #if there are conflicts, the regular procedure applies.

    #then the IR session will auto-finish.

    #now check the new history:
    git log --oneline --all --graph
#end

#-----------------------------------------------------------------------------------
#S06L13 - FIXING UP COMMITS

    #an alternative to squashing
    #which is useful for the same purposes,
    #is called fixup.

    #it does much the same as squash,
    #but it won't take the commit comment
    #into consideration.

    #to do it, we start an IR session
    #starting from the parent of the earliest commit involved:
    git rebase -i 8b134d2^

    #almost equally as before,
    #this time we'll mark the squashable commits
    #with the "fixup" prefix:

    # pick 8b134d2 Render restaurants on the map.
    # fixup 24c6d63 Fix a typo.
    # fixup 87d23b3 Change the color of restaurant icons.

    #save and exit the editor.
    #the resulting fixed-up commit's comment
    #will be auto-generated,
    #so there won't be another prompt
    #to write it.

    #if there are conflicts, the regular procedure applies.

    #then the IR session will auto-finish.

    #now check the new history:
    git log --oneline --all --graph
#end

#-----------------------------------------------------------------------------------
#S06L14 - SPLITTING A COMMIT

    #coming from the previous lessons,
    #we see commit 1c5ec5c introduced two
    #unrelated changes:
    #updating the T.O.S. and the Google Map version.

    #so for clarity, this commit should be split into two.

    #to do so, we start an IR session
    #starting from the parent of the splittable commit:
    git rebase -i 1c5ec5c^

    #now, prefix the splittable commit
    #with "edit" instead of "pick".
    #then save and exit the editor.

    #the IR will pause
    #to give us the chance to make the split manually.

    #first, notice HEAD is in the splittable commit
    #(in IR sessions, commits marked with "edit"
    #will be pointed to by HEAD while we edit them).

    #so, if we go one commit back,
    #but we keep the changes from it in our filesystem,
    #we can only stage those we want:

    git reset --mixed HEAD^

    #at this point, if we do:
    git status -s

    #we'll get:
    #  M package.txt (in red)
    # ?? terms.txt (in red)

    #so, there's modifications to package.txt
    #which are related to the Google Map SDK version.

    #and there's a terms.txt file introduced
    #which is related to the T.O.S.

    #we'll stage and commit them separately.

    #we start with the Google Map version-related changes:
    git add package.txt
    git commit -m "Update Google Map SDK version to 2.0"

    #at this point, if we check the history:
    git log --oneline --all --graph
    #we'll see we're branched out.
    #but this is normal when in the middle of an IR,
    #as seen before.

    #now we'll do the T.O.S.-related changes:
    git add terms.txt
    git commit -m "Add terms of service"

    #check the history again:
    git log --oneline --all --graph
    #we'll see all that's left is the auto-mass-rebasing step.

    #notice the original splittable commit is still in the history.
    #since we didn't add the --amend flag to the two resulting commits
    #then the original splittable commit will be replaced by them entirely.

    #at this point we can let the IR finish:
    git rebase --continue

    #check the history again:
    git log --oneline --all --graph
    #we'll see the two new commits in place of the old one
    #and we have a simple linear history.
#end

#-----------------------------------------------------------------------------------
#S06L15 - REWRITING HISTORY WITH GITKRAKEN

    #in the main view of gitkraken,
    #if we right-click on any commit, we can start
    #an IR session from it.

    #on the IR, we can choose the operation
    #to do on each commit with a dropdown.

    #we can also drag and drop them to reorder them.

    #if we choose to squash a commit,
    #we can see which commit it's gonna get squashed with.

    #if we have conflicts, we can simply
    #pick the version of the file to keep
    #using the provided buttons in case it's semi-automatic
    #like before, or manually if it isn't.

    #however, gitkrakren doesn't let us split or amend a commit.
#end

#-----------------------------------------------------------------------------------
#END OF SECTION 06
