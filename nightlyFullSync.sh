#!/bin/bash

cd /var/www/satis.lemundo.de/web/satis-gitlab
filename=.config.gitlab.api.key
gitlab_api_key=$(head -n 1 $filename)

bin/satis-gitlab gitlab-to-config \
    --homepage http://satis.lemundo.de \
    --output satis.json \
    --template lemundo-template.json \
    https://glab.lemundo.de $gitlab_api_key

    #--gitlab-namespace 'Diverse - Gitolite' \ To filter for specific namespaces

bin/satis-gitlab build satis.json web

echo "" > /var/log/satisCron.log # clean up diff log file
