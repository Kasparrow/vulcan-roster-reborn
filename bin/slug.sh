#!/bin/bash

echo $1 | sed "s~é~%C3%A9~g" \
        | sed "s~è~%C3%AA~g" \
        | sed "s~ë~%C3%AB~g" \
        | sed "s~î~%C3%AE~g" \
        | sed "s~ï~%C3%AF~g" \
        | sed "s~ô~%C3%B4~g" \
        | sed "s~ù~%C3%B9~g" \
        | sed "s~û~%C3%BB~g" \
