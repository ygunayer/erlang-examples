#!/usr/bin/env sh
set -e

PROJECT=$1

if [ -z "$PROJECT" ]; then
    echo "Please specify a project name."
    exit 1
fi

if [ ! -d "./$PROJECT" ]; then
    echo "No such project exists: $PROJECT"
    exit 1
fi

cd "$PROJECT"

if [ -f "run.sh" ]; then
    ./run.sh
elif [ -f "$PROJECT.erl" ]; then
    rm -f *.beam
    for f in *.erl
    do
        MODULE=$(echo $f | sed s/\.erl//)
        echo "Compiling $MODULE..."
        erl -compile $MODULE
    done
    echo "Compile finished, running $PROJECT..."
    erl -noshell -s $PROJECT -s init stop
else
    echo "No entrypoint found for project $PROJECT"
    exit 1
fi
