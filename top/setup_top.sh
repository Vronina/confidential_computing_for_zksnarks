#!/bin/bash

set -e
set -x

mkdir .config/procps

mv toprc .config/procps
mv processtoprc .config/procps
mv memorytoprc .config/procps