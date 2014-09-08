#!/usr/bin/env zsh
PORTSDIR=$(make -V PORTSDIR)
function showdep() {
        local level=$1
        cd $2
        all_dep=(${${=${(f)"$(make -V BUILD_DEPENDS)"}}#*:} ${${=${(f)"$(make -V LIB_DEPENDS)"}}#*:} ${${=${(f)"$(make -V RUN_DEPENDS)"}}#*:})
        for dep (${(ou)all_dep}){
                repeat $level print -n "  "
                print ${dep//${PORTSDIR}\//}
                (( newlevel = level + 1 ))
                showdep $newlevel $dep
        }
}
showdep 0 "."
