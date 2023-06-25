#SECTION 01: GETTING STARTED

#-----------------------------------------------------------------------------------
#S01L01 to S01L04 - GETTING STARTED

    #just super basic explanations here...
#end

#-----------------------------------------------------------------------------------
#S01L05 - BASIC GIT COMMANDS

    #check if git is installed, and if so, which version:
    git --version
#end

#-----------------------------------------------------------------------------------
#S01L06 - BASIC GIT CONFIG

    #we can set the git configuration parameters for...
    #----all users (system), or...
    #----all repositories of the current user (global), or...
    #----only the current repository of the current user (local).

    #"system", "global" and "local" are config LEVELS.
    #they are used in the following commands:

    #view the current configuration values:
    git config --<LEVEL> -e

    #set username (should be the same username as in the github account):
    git config --<LEVEL> user.name "<username>"

    #set email (should be the same email as in the github account):
    git config --<LEVEL> user.email "<email>"

    #set default editor:
    git config --<LEVEL> core.editor "<path or alias to preferred code editor> --wait"

    #set how to handle line endings:
    git config --<LEVEL> core.autocrlf input #for linux or mac
    git config --<LEVEL> core.autocrlf true  #for windows

    #save our github credentials, so we don't have to type them on every "git push".
    #just cache them for 15 minutes:
    git config --<LEVEL> credential.helper cache
    #save them securely and permanently (MacOS only):
    git config --<LEVEL> credential.helper osxkeychain

    #THESE NEXT CONFIG VALUES
    #ARE EXPLAINED IN FUTURE SECTIONS:

    #set default program for viewing the diff between two files:
    #(see section 02 lesson 13 for more info)
    git config --<LEVEL> diff.tool "<name of the preferred program, without spaces>" #just a name for the program, not the actual command to run it
    git config --<LEVEL> difftool.<name_we_just_set>.cmd "<path or alias to preferred diff program> <flags or options>"
    #for example, for setting visual studio code as our global diff program:
    git config --global diff.tool "vscode"
    git config --global difftool.vscode.cmd "code --wait --diff $LOCAL $REMOTE"
    #then double-check and fix this configuration if needed:
    git config --global -e

    #set default program for resolving merge conflicts:
    #(see section 04 lesson 12 for more info)
    git config --<LEVEL> merge.tool "<name of the preferred program, without spaces>" #just a name for the program, not the actual command to run it
    git config --<LEVEL> mergetool.<name_we_just_set>.path "<path to preferred diff program>"
    #for example, for setting p4merge as our global merge program:
    git config --global merge.tool "p4merge"
    git config --global mergetool.p4merge.path "/Applications/p4merge.app/Contents/MacOS/p4merge"
    #allow or prevent p4merge to create (noisy) backup files:
    #(see section 04 lesson 16 for more info)
    git config --<LEVEL> mergetool.keepBackup <true|false>
    #for example, to disallow it:
    git config --global mergetool.keepBackup false
    #then double-check and fix this configuration if needed:
    git config --global -e
#end

#-----------------------------------------------------------------------------------
#S01L07 - GIT HELP

    #config is just one of the many git commands.
    #to know which other commands are there,
    #we can get help by displaying a list of commands, or
    #a list of possible options for a command, like this:

    #get a short summary of possible commands:
    git help #or...
    git --help #or...
    git -h

    #get a full list of possible commands:
    git help -a

    #get a short summary of possible options for a command:
    git <command> -h

    #get a full list of possible options for a command:
    git <command> --help #or...
    git help <command>

    #get a list of tutorials/guides on concepts related to git:
    git help -g

    #start one of the aforementioned tutorials:
    git help <concept>

    #start the overall git manual:
    git help git

    #the resulting info pages could be too long, but we can:
    #----hit SPACEBAR to move forward one page.
    #----hit Q to exit.
#end

#-----------------------------------------------------------------------------------
#END OF SECTION 01
