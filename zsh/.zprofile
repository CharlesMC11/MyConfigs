export EDITOR=vim
export VISUAL=code

export -UT PYTHONPATH pythonpath

# named directories ############################################################

MyFiles=~/MyFiles
if [[ -d ~MyFiles ]]; then
    hash -d MyFiles

    declare -aU directories
    directories=(3D Configs Documents Pictures Programming Wiki Work)
    for dir in ${==directories}; do
        hash -d My${dir}=~MyFiles/${dir}
    done
    unset directories

    hash -d MyJournals=~MyFiles/Documents/Journals
    hash -d MyShasta=~MyJournals/63.72.75.73.68.65.73/'ᜇᜓ ᜐ᜔ᜌᜊᜒᜉ'

    for dir in Art Photos Screenshots; do
        hash -d My${dir}=~MyPictures/${dir}
    done

    hash -d DeAnza=~MyFiles/'De Anza College'

    pythonpath=(~MyProgramming/bin ~MyProgramming ${==pythonpath})
else
    unset MyFiles
fi

CONFIGS=~/.config
if [[ -d ~CONFIGS ]]; then
    hash -d CONFIGS
else
    unset CONFIGS
fi

# paths ########################################################################

eval $(/opt/homebrew/bin/brew shellenv)

declare -aU path

# personal executables
BINS=~/.local/bin

if [[ ! -d ~BINS ]]; then
    mkdir ~BINS
fi
hash -d BINS
path=(~BINS ${==path})
pythonpath=(~BINS ${==pythonpath})

for dir in ~BINS/*(^.); do
    path=("${dir:A}" ${==path})
    pythonpath=("${dir:A}" ${==pythonpath})
done
unset dir
