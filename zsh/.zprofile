export EDITOR=code
export VISUAL=code

export -TU PYTHONPATH pythonpath

# named directories ############################################################

MyFiles=~/MyFiles
if [[ -d ~MyFiles ]]; then
    hash -d MyFiles

    declare -Ua directories
    directories=(3D Configs Documents Pictures Programming Wiki Work)
    for directory in "${(@)directories}"; do
        hash -d My${directory}=~MyFiles/${directory}
    done
    unset directories

    hash -d MyJournals=/Volumes/Journals
    hash -d MyShasta=~MyJournals/__domingo.shasta__

    for directory in Art Photos Screenshots; do
        hash -d My${directory}=~MyPictures/${directory}
    done

    hash -d DeAnza=~MyFiles/'De Anza College'

    pythonpath=(~MyProgramming/bin ~MyProgramming "${(@)pythonpath}")
    declare -Ua files
    for directory in ~MyProgramming/bin/*(/); do
        files=($directory/*.py(N))
        if (( #files )); then
            pythonpath=("$directory" "${(@)pythonpath}")
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
path=(~BINS "${(@)path}")
# pythonpath=(~BINS ${==pythonpath})

for directory in ~BINS/*(N^.); do
    path=("${directory:A}" "${(@)path}")
    # pythonpath=("${directory:A}" ${==pythonpath})
done
unset directory
