if [ -z $1 ]
then
    echo "you need to specify amount; usage example: ./pull_requests.sh 50"
else
    AMOUNT=$1
    ITERATION=0
    #create base branch for pull requests (current branch name + timestamp)
    BRANCH="$(git branch --show-current)"
    BASE_BRANCH="${BRANCH}-$(date +%s)"
    git branch "${BASE_BRANCH}" && git checkout "${BASE_BRANCH}"    
    #prepare file which will be edited in prs
    CHANGED_FILE="changes.txt"
    touch ${CHANGED_FILE} && git add ${CHANGED_FILE} && git commit -am "pull request base" || true
    #push new branch and commit 
    git push -u origin "${PR_BRANCH}"

    while [ ${ITERATION} -lt ${AMOUNT} ]
    do
	(( ITERATION++ ))
	#create branch for pull request (base branch + iteration number)
	PR_BRANCH="${BASE_BRANCH}-${ITERATION}"
	git branch "${PR_BRANCH}" && git checkout "${PR_BRANCH}"    
	#modify a file
	CHANGE=$(date)
	echo "${CHANGE}" > "${CHANGED_FILE}"
	git commit -am "iteration ${ITERATION}"
	#push new branch and commit
	git push -u origin "${PR_BRANCH}"
	#create a pull request
	gh pr create --title "pr no. (${ITERATION})" --body "appended ${CHANGE} to ${CHANGED_FILE}"
	#return to base pull request branch
	git checkout "${BASE_BRANCH}"
	sleep 1
    done
    #return to starting branch
    git checkout "${BRANCH}"
fi
