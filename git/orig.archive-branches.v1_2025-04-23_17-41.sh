# Original file: archive-branches.sh 
# Version date: Wed Apr 23 05:42:01 PM EDT 2025 
# Git branch: enhancement/git-archive 
# Last commit: Add GitHub repo opener script 

# NEW VERSION - Original backed up to: orig.archive-branches_2025-04-23_17-39.sh 
# Version date: Wed Apr 23 05:39:45 PM EDT 2025 
# Git branch: enhancement/git-archive 
# Last commit: Add GitHub repo opener script 
#!/bin/zsh
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# 🧹 Git Branch Archiver – archive-branches.sh
# Safely archives remote branches and cleans up local ones
# Logs activity to ~/git-branch-archive/logs/
# Author: Trauco (trau.co)
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
set -e

# Branches that must never be touched
protected_branches=("develop" "main" "master")
default_branch="develop"

timestamp=$(date "+%Y-%m-%d_%H-%M-%S")
log_dir="$HOME/git-branch-archive/logs"
log_file="$log_dir/archive-log-$timestamp.log"

# ANSI colors
GREEN=$'\e[32m'; YELLOW=$'\e[33m'; RED=$'\e[31m'; BLUE=$'\e[34m'; NC=$'\e[0m'

mkdir -p "$log_dir"

# Build regex like ^develop$|^main$|^master$
protected_regex="$(printf '^%s$|' "${protected_branches[@]}")"
protected_regex="${protected_regex%|}"

# All local branches except the protected ones
branches=(
  $(git for-each-ref --format='%(refname:short)' refs/heads | grep -Ev "(${protected_regex})")
)

if [[ ${#branches[@]} -eq 0 ]]; then
  printf "${YELLOW}⚠️  No local branches to process.${NC}\n"
  exit 0
fi

printf "\n${BLUE}🔍 The following local branches were found:${NC}\n"
for b in "${branches[@]}"; do printf " - %s\n" "$b"; done

printf "\n${YELLOW}⚠️  Archive remote branches and delete these local branches? (y/n) ${NC}"
read -r confirm
if [[ ! "$confirm" =~ ^[yY]$ ]]; then
  printf "${RED}❌  Operation cancelled.${NC}\n"
  exit 1
fi

for branch in "${branches[@]}"; do
  printf "${BLUE}⏳  Processing branch: %s${NC}\n" "$branch" | tee -a "$log_file"

  if git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
    printf "${GREEN}✅  Remote branch exists: origin/%s${NC}\n" "$branch" | tee -a "$log_file"

    archive_tag="archive/$(echo "$branch" | tr '/' '-')"
    git tag "$archive_tag" "$branch" 2>/dev/null
    printf "🏷️  Tagged as %s\n" "$archive_tag" | tee -a "$log_file"

    git push origin "refs/tags/$archive_tag" | tee -a "$log_file"
    git push origin --delete "$branch" | tee -a "$log_file"
    printf "🗑️  Deleted remote branch: origin/%s\n" "$branch" | tee -a "$log_file"
  else
    printf "${YELLOW}⚠️  No matching remote branch for: %s${NC}\n" "$branch" | tee -a "$log_file"
  fi

  git branch -D "$branch" | tee -a "$log_file"
  printf "${GREEN}✅  Deleted local branch: %s${NC}\n" "$branch" | tee -a "$log_file"
done

git checkout "$default_branch" >/dev/null

printf "\n${GREEN}🎉  Done. Log saved to:%s${NC}\n" " $log_file"
printf "${GREEN}🛡️  You're now back on:%s${NC}\n\n" " $default_branch"
