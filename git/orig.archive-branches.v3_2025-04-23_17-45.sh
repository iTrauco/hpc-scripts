# Original file: archive-branches.sh 
# Version date: Wed Apr 23 05:45:46 PM EDT 2025 
# Git branch: enhancement/git-archive 
# Last commit: debug: breaking due to bash to zsh shell syntax nuances 

# NEW VERSION - Original backed up to: orig.archive-branches.v2_2025-04-23_17-43.sh 
# Version date: Wed Apr 23 05:43:55 PM EDT 2025 
# Git branch: enhancement/git-archive 
# Last commit: debug: breaking due to bash to zsh shell syntax nuances 
protected_branches=("develop" "main" "master")
timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
log_dir="$HOME/git-branch-archive/logs"
log_file="$log_dir/archive-log-$timestamp.log"

# Colors
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
RED=$'\e[31m'
BLUE=$'\e[34m'
NC=$'\e[0m'

# Create log dir if needed
mkdir -p "$log_dir"

# Build grep exclude pattern for protected branches
exclude_pattern=$(printf "^%s$|" "${protected_branches[@]}")
exclude_pattern=${exclude_pattern%|}  # Remove trailing pipe

# Get all local branches except protected ones
branches=($(git for-each-ref --format='%(refname:short)' refs/heads | grep -v -E "$exclude_pattern"))

if [[ ${#branches[@]} -eq 0 ]]; then
  echo "${YELLOW}⚠️ No local branches found to process.${NC}"
  exit 0
fi

echo "\n${BLUE}🔍 The following local branches were found:${NC}"
for b in "${branches[@]}"; do echo " - $b"; done

# Prompt user for confirmation
echo "\n${YELLOW}⚠️ Are you sure you want to archive remote branches and delete these local branches? (y/n)${NC}"
read -r confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "${RED}❌ Operation cancelled.${NC}"
  exit 1
fi

# Loop over branches
for branch in "${branches[@]}"; do
  echo "${BLUE}⏳ Processing branch: ${branch}${NC}" | tee -a "$log_file"
  
  # Check for remote
  if git ls-remote --exit-code --heads origin "$branch" > /dev/null 2>&1; then
    echo "${GREEN}✅ Remote branch exists: origin/$branch${NC}" | tee -a "$log_file"
    
    # Tag as archive
    archive_tag="archive/$(echo $branch | tr / -)"
    git tag "$archive_tag" "$branch" 2>/dev/null
    echo "🏷️ Tagged as $archive_tag" | tee -a "$log_file"
    
    # Push tag
    git push origin "refs/tags/$archive_tag" | tee -a "$log_file"
    
    # Delete remote branch
    git push origin --delete "$branch" | tee -a "$log_file"
    echo "🗑️ Deleted remote branch: origin/$branch" | tee -a "$log_file"
  else
    echo "${YELLOW}⚠️ No matching remote branch for: $branch${NC}" | tee -a "$log_file"
  fi
  
  # Delete local branch
  git branch -D "$branch" | tee -a "$log_file"
  echo "${GREEN}✅ Deleted local branch: $branch${NC}" | tee -a "$log_file"
done

# Return to a protected branch (preferring develop)
if git rev-parse --verify develop >/dev/null 2>&1; then
  git checkout develop > /dev/null
  current_branch="develop"
elif git rev-parse --verify main >/dev/null 2>&1; then
  git checkout main > /dev/null
  current_branch="main"
else
  git checkout master > /dev/null
  current_branch="master"
fi

# Final output
echo "\n${GREEN}🎉 Done. All actions logged to:${NC} $log_file"
echo "${GREEN}🛡️ You're now back on:${NC} $current_branch\n"