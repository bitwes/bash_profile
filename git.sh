#alias git=hub
alias gitcod='git checkout .'

#----------------------
#git
#----------------------
alias gitinfo='
echo "Remotes";
echo "-------";
git remote -v;
echo
echo "Branches";
echo "-------";
git branch;
echo
echo "Status"
echo "-------";
git status'


# Opens the github page for the current git repository in your browser
# git@github.com:jasonneylon/dotfiles.git
# https://github.com/jasonneylon/dotfiles/
function gh() {
  giturl=$(git config --get remote.origin.url)
  if [ "$giturl" == "" ]
    then
     echo "Not a git repository or no remote.origin.url set"
     exit 1;
  fi

  giturl=${giturl/git\@github\.com\:/https://github.com/}
  giturl=${giturl/git\@github\.build\.ge\.com\:/https://github\.build\.ge\.com/}
  giturl=${giturl/\.git/\/tree/}
  branch="$(git symbolic-ref HEAD 2>/dev/null)" ||
  branch="(unnamed branch)"     # detached HEAD
  branch=${branch##refs/heads/}
  giturl=$giturl$branch

  `open $giturl`
}

function origin_to_upstream(){
  `git remote remove upstream`
  `git remote rename origin upstream`
  `git remote add origin $1`
  echo `git remote -v`
}

function upstream_to_origin(){
  `git remote remove origin`
  `git remote rename upstream origin`
  echo `git remote -v`
}


function master_diff(){
  local file=''

  if [ $1 ]; then
    file=`find ./ -iname "$1"`
    match_count=`find ./ -iname "$1" | wc -l`
    echo $match_count
    if [ "$match_count" -eq "1" ]; then
      git diff master $file
    else
      git diff master "*$1*"
    fi
  else
    git diff master
  fi

}


GIT_EXTERNAL_DIFF=$BASHFILES/bin/git_external_diff
export GIT_EXTERNAL_DIFF
