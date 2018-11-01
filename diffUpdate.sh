#/bin/bash

DIFF_GITLAB=/var/www/html/hooky/gitlab.log
if [ ! -f $DIFF_GITLAB ]; then
    echo "No news from Gitlab. Exiting."
    exit 1
fi

SATIS_ROOT=/var/www/satis.lemundo.de/web/satis-gitlab
GITLAB=$SATIS_ROOT/gitlab.log
cp $DIFF_GITLAB $GITLAB && echo "" > $DIFF_GITLAB

input=$GITLAB

# Read from file and only include matching repositories
while IFS= read -r repo
do
if [[ $repo == *"mage"* ]] || [[ $repo == *"code/acceptanceTest"* ]] || [[ $repo == *"lib"* ]] || [[ $repo == *"shop2/"* ]] || [[ $repo == *"config/"* ]] || [[ $repo == *"playground"* ]]
then
    allChangedRepos="$allChangedRepos $repo"
fi
done < <(sort -u $input)

if [[ -z $allChangedRepos ]]
then
   echo "Gitlab sent news, but no matching repositories were found. Exiting."
   exit 1
fi

cd $SATIS_ROOT

bash generateJsonFromInputs.sh $allChangedRepos > diff.json
for repo in $allChangedRepos
do
   bin/satis-gitlab build --repository-url $repo diff.json web/ --skip-errors # Update one repo at a time to only overwrite that one
done

