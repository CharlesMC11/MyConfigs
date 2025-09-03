export EDITOR=code
export VISUAL=code

export -TU PYTHONPATH pythonpath

# named directories ############################################################

MyFiles=~/MyFiles
if [[ -d ~MyFiles ]]; then
    hash -d MyFiles

    declare -Ua directories
    directories=(3D Configs Documents Pictures Programming Wiki Work)
    for dir in ${==directories}; do
        hash -d My${dir}=~MyFiles/${dir}
    done
    unset directories

    hash -d MyJournals=/Volumes/Journals
    hash -d MyShasta=~MyJournals/__domingo.shasta__

    for dir in Art Photos Screenshots; do
        hash -d My${dir}=~MyPictures/${dir}
    done

    hash -d DeAnza=~MyFiles/'De Anza College'

    pythonpath=(~MyProgramming/bin ~MyProgramming ${==pythonpath})
    for dir in ~MyProgramming/bin/*(/); do
        declare -Ua files
        files=($dir/*.py(N))
        if ((${#files})); then
            pythonpath=("$dir" ${==pythonpath})
        fi
    done
    unset files
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

# personal executables

export -Ua path

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

