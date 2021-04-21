#!/usr/bin/env bash

export CUSTOMPLAIN_SKIPGLOBALLOGINFLAG=${CUSTOMPLAIN_SKIPGLOBALLOGINFLAG:-false}
export CUSTOMPLAIN_PRDMODEFLAG=${CUSTOMPLAIN_PRDMODEFLAG:-true}

env | grep CUSTOM

echo "above env"

while IFS='=' read -r name value ; do
    if [[ $name == 'CUSTOMPLAIN_'* ]]; then
        sed -i "s#'<$name>'#${!name}#g" environment.custom.ts
        echo "replacing <$name> to ${!name}"
    fi
done < <(env)
while IFS='=' read -r name value ; do
    if [[ $name == 'CUSTOM_'* ]]; then
        sed -i "s#<$name>#${!name}#g" environment.custom.ts
        echo "replacing <$name> to ${!name}"
    fi
done < <(env)