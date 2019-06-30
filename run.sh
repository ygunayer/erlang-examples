#!/usr/bin/env sh
PROJECT=$1

if [ -z "$PROJECT" ]; then
    echo "Please specify a project name."
    exit 1
fi

if [ -f "./$PROJECT/$PROJECT.erl" ]; then
    cd "$PROJECT"
    echo $(pwd)

    if [ -f "run.sh" ]; then
        ./run.sh
    else
        rm *.beam
        for f in *.erl
        do
            MODULE=$(echo $f | sed s/\.erl//)
            echo "Compiling $MODULE..."
            erl -compile $MODULE
        done
        echo "Compile finished, running $PROJECT..."
        erl -noshell -s $PROJECT -s init stop
    fi
else
    echo "Project $PROJECT was not found"
    exit 1
fi
