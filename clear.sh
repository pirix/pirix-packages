#!/bin/bash

find | grep .pkg.tar.xz | xargs rm
find -maxdepth 3 -type d -name "pkg" -exec rm -rf {} \;
find -maxdepth 3 -type d -name "src" -exec rm -rf {} \;
