#/bin/bash

filename=.config.gitlab.api.key
gitlab_api_key=$(head -n 1 $filename)

out='{
    "name": "Lemundo Repository",
    "homepage": "http://satis.lemundo.de",
    "repositories": [
'

for repo in "$@"
do
out="$out {\"type\": \"vcs\",\"url\": \"$repo\"},"
done

echo "${out%?}" # removes last character which is a comma

# Now echo final ending part

echo "     ],
    \"require-all\": true,
    \"config\": {
        \"gitlab-domains\": [
            \"glab.lemundo.de\"
        ],
        \"gitlab-token\": {
            \"glab.lemundo.de\": \"$gitlab_api_key\"
        }
    }
}
"
