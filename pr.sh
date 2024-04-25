if [ -z $1 ]
then
    echo "you need to specify amount"
else
    AMOUNT=$1
    ITERATION=0
    CHANGED_FILE="changes.txt"
    BRANCH="$(git branch --show-current)"

    BASE_BRANCH="${BRANCH}-$(date +%s)"
    git branch "${BASE_BRANCH}" && git checkout "${BASE_BRANCH}"    
    touch ${CHANGED_FILE} && git add ${CHANGED_FILE} && git commit -am "pull request base" || true
    git push -u origin "${PR_BRANCH}"

    while [ ${ITERATION} -lt ${AMOUNT} ]
    do
	(( ITERATION++ ))
	PR_BRANCH="${BASE_BRANCH}-${ITERATION}"
	CHANGE=$(date)
	git branch "${PR_BRANCH}" && git checkout "${PR_BRANCH}"    
	echo "${CHANGE}" > "${CHANGED_FILE}"
	git commit -am "iteration ${ITERATION}"
	git push -u origin "${PR_BRANCH}"
	gh pr create --title "pr no. (${ITERATION})" --body "appended ${CHANGE} to ${CHANGED_FILE}"
	git checkout "${BASE_BRANCH}"
	sleep 1
    done

    git checkout "${BRANCH}"
fi
