#!/bin/bash

# gh_repo_setup
# Simple local repository setup with branches and workflow

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

clear
echo -e "${GREEN}🚀 Local Git Repository Setup${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}Current directory: ${NC}$(pwd)"
echo ""

# Check git config
GIT_NAME=$(git config user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config user.email 2>/dev/null || echo "")

if [ -z "$GIT_NAME" ] || [ -z "$GIT_EMAIL" ]; then
    echo -e "${RED}❌ Git configuration missing${NC}"
    echo "   Please configure git first:"
    echo "   git config --global user.name \"Your Name\""
    echo "   git config --global user.email \"your.email@example.com\""
    exit 1
fi

echo -e "${CYAN}👤 Git Config: ${NC}$GIT_NAME <$GIT_EMAIL>"
echo ""

# Ask if user wants to proceed in current directory
echo -e "${YELLOW}Initialize repository in current directory?${NC}"
echo "1) Yes, initialize here"
echo "2) No, exit"
echo ""
read -p "Choose [1-2]: " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[1]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""

# Check if already a git repo
if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Git repository already exists here${NC}"
    echo "1) Continue with existing repo"
    echo "2) Exit"
    echo ""
    read -p "Choose [1-2]: " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[1]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
else
    echo -e "${GREEN}📁 Initializing git repository...${NC}"
    git init
    echo ""
fi

# Ask about branches
echo -e "${YELLOW}Branch setup:${NC}"
echo "1) Master + Development branches"
echo "2) Main + Development branches"
echo "3) Single branch only"
echo ""
read -p "Choose [1-3]: " -n 1 -r
echo ""

# Create initial commit if needed
if [ -z "$(git log --oneline 2>/dev/null)" ]; then
    echo -e "${GREEN}📝 Creating initial commit...${NC}"
    if [ ! -f "README.md" ]; then
        echo "# $(basename "$(pwd)")" > README.md
    fi
    git add .
    git commit -m "Initial commit"
fi

case $REPLY in
    1)
        echo -e "${GREEN}🌿 Setting up master + development branches...${NC}"
        git checkout -b master 2>/dev/null || git checkout master
        git checkout -b development 2>/dev/null || git checkout development
        git checkout master
        ;;
    2)
        echo -e "${GREEN}🌿 Setting up main + development branches...${NC}"
        git checkout -b main 2>/dev/null || git checkout main
        git checkout -b development 2>/dev/null || git checkout development
        git checkout main
        ;;
    3)
        echo -e "${GREEN}🌿 Single branch setup...${NC}"
        git checkout -b main 2>/dev/null || git checkout main
        ;;
esac

echo ""

# Ask about workflow
echo -e "${YELLOW}Add Jupyter + Mermaid workflow?${NC}"
echo "1) Yes, add auto-convert workflow"
echo "2) No, skip workflow"
echo ""
read -p "Choose [1-2]: " -n 1 -r
echo ""

if [[ $REPLY =~ ^[1]$ ]]; then
    echo -e "${GREEN}⚙️  Creating Jupyter + Mermaid workflow...${NC}"
    mkdir -p .github/workflows
    
    cat > .github/workflows/auto-convert.yml << EOF
name: Auto Convert Notebooks and Compile Mermaid
on:
  push:
    paths: ['**.ipynb', '**.md']
jobs:
  convert-and-process:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.x'
      
      - name: Install jupyter
        run: pip install jupyter
      
      - name: Convert notebooks to markdown
        run: |
          find . -name "*.ipynb" -exec jupyter nbconvert --to markdown {} \;
      
      - uses: neenjaw/compile-mermaid-markdown-action@master
        with:
          files: '.'
          output: '.'
      
      - name: Commit files
        run: |
          git config --local user.email "$GIT_EMAIL"
          git config --local user.name "$GIT_NAME"
          git add .
          git diff --staged --quiet || git commit -m "Auto-convert notebooks and compile mermaid"
          git push
EOF
    echo -e "${GREEN}   ✓ Auto-convert workflow created${NC}"
fi

echo ""
echo -e "${GREEN}🎉 Local Repository Setup Complete!${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${BLUE}📋 Summary:${NC}"
echo "   • Repository: $(pwd)"
echo "   • Branches: $(git branch --format='%(refname:short)' | tr '\n' ' ')"
if [ -f ".github/workflows/auto-convert.yml" ]; then
    echo "   • Workflow: Jupyter + Mermaid auto-convert"
fi
echo ""
echo -e "${CYAN}📝 Next steps:${NC}"
echo "   • Add your remote: git remote add origin <url>"
echo "   • Push: git push -u origin <branch>"
if [ -f ".github/workflows/auto-convert.yml" ]; then
    echo "   • Configure GitHub Actions permissions when you push"
fi
echo ""
echo -e "${GREEN}✨ Done!${NC}"
