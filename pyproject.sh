#!/bin/bash

read -p "Project Name: " name

mkdir $name

cd $name

touch requirements.txt
touch LICENCE
cat > README.md << EOF 
# $name
EOF
cat > .gitignore << EOF
# System files
.DS_Store
Thumbs.db
# Python files
__pycache__/
# Other Files
.env
EOF

mkdir src

cd src

touch main.py
touch __init__.py