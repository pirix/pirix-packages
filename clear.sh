#!/bin/bash

find -maxdepth 3 -type d -name "pkg" -exec rm -r {} \;
find -maxdepth 3 -type d -name "src" -exec rm -r {} \;
