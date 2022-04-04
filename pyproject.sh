#!/bin/bash

read -r -p "Project Name: " name
read -r -p "Version: " version
read -r -p "Description: " description
read -r -p "Author: " author
read -r -p "Author Email: " author_email
read -r -p "URL: : " url
read -r -p "GitGub Actions (y/n): " github_actions
read -r -p "Pre written License (y/n): " license

year=$(date +"%Y")
name_py="${name}.py"

mkdir "$name"

cd "$name" || exit

if [ -z "$version" ];
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
cat > setup.py << EOF
from setuptools import setup
setup()
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

mkdir "$name"

cd "$name" || exit

touch "$name_py"
touch __init__.py

if [ "$github_actions" == "y" ]; 
    then
    cd .. || exit

    mkdir .github
    cd .github || exit
    mkdir workflows
    cd workflows || exit

    cat > python-app.yml << EOF
    # This workflow will install Python dependencies, run tests and lint with a single version of Python
    # For more information see: https://help.github.com/actions/language-and-framework-guides/using-python-with-github-actions

    name: Python application

    on:
    push:
        branches: [ master ]
    pull_request:
        branches: [ master ]

    jobs:
    build:

        runs-on: ubuntu-latest

        steps:
        - uses: actions/checkout@v2
        - name: Set up Python 3.10
        uses: actions/setup-python@v2
        with:
            python-version: "3.10"
        - name: Install dependencies
        run: |
            python -m pip install --upgrade pip
            pip install flake8 pytest
            if [ -f requirements.txt ]; then pip install -r requirements.txt; fi
        - name: Lint with flake8
        run: |
            # stop the build if there are Python syntax errors or undefined names
            flake8 . --count --select=E9,F63,F7,F82 --show-source --statistics
            # exit-zero treats all errors as warnings. The GitHub editor is 127 chars wide
            flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics
EOF
fi