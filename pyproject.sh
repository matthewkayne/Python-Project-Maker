#!/bin/bash

read -p "Project Name: " name
read -p "Version: " version
read -p "Description: " description
read -p "Author: " author
read -p "Author Email: " author_email
read -p "URL: : " url
read -p "Pre written License (y/n): " license

year=$(date +"%Y")

mkdir $name

cd $name

if [ -z $version ];
  then
    version=1.0.0
fi

if [ "$license" == "y" ]; 
    then
    cat > LICENSE << EOF
MIT License

Copyright (c) $year $author

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
else
    touch LICENSE
fi    

cat > setup.cfg << EOF
[metadata]
name = $name
version = $version
description = $description
long_description = file: README.md
long_description_content_type = text/markdown
author = $author
author_email = $author_email
url = $url

[options]
packages = find:
include_package_data = True
EOF
cat > pyproject.toml << EOF
[build-system]
requires = [
    "setuptools>=54",
    "wheel"
]
build-backend = "setuptools.build_meta"
EOF
cat > setup.py << EOF
from setuptools import setup
setup()
EOF
cat > README.md << EOF 
# $name
EOF
cat > .gitignore << EOF
# System files
.DS_Store
Thumbs.db

# Visual Studio Code
.vscode

# Byte-compiled / optimized / DLL files
__pycache__/
*.py[cod]
*$py.class

# Distribution / packaging
.Python
build/
develop-eggs/
dist/
downloads/
eggs/
.eggs/
lib/
lib64/
parts/
sdist/
var/
wheels/
share/python-wheels/
*.egg-info/
.installed.cfg
*.egg
MANIFEST

# Environments
.env
.venv
env/
venv/
ENV/
env.bak/
venv.bak/

# Custom
test.py
EOF
touch requirements.txt
touch MANIFEST.in

mkdir src

cd src

touch main.py
touch __init__.py
