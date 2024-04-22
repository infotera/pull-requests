AMOUNT=$1
BASE_BRANCH="$(git branch --show-current)"
ITERATION=$(git branch | grep "${BASE_BRANCH}" | sed -e "s/[^0-9]//g" | sort -n | tail -n 1)
(( AMOUNT += ITERATION ))
CHANGED_FILE="changes.txt"
while [ ${ITERATION} -lt ${AMOUNT} ]
do
    CHANGE=$(date)
    PR_BRANCH="${BASE_BRANCH}-${ITERATION}"
    git checkout "${BASE_BRANCH}"
    git pull
    sleep 3
    git branch "${PR_BRANCH}"    
    git checkout "${PR_BRANCH}"    
    echo "${CHANGE}" > "${CHANGED_FILE}"
    git add "${CHANGED_FILE}"
    git commit -am "iteration ${ITERATION}"
    git push -u origin "${PR_BRANCH}"
    gh pr create --title "pr no. (${ITERATION})" --body "appended ${CHANGE} to ${CHANGED_FILE}"
    ((COUNTER++))
done
