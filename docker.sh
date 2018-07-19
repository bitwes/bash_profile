alias dls='docker ps -a '
alias drm='docker rm '
alias dmnt='docker run -v /Users/tomwesley:/mac_home '


alias searchls_prompt="docker run -v /Users/tomwesley/docker_mount:/docker_mount  --env-file local.env -it pa_searchls /bin/bash"
alias searchls_build='docker build -t "pa_searchls" .'
alias es_indexes='curl "http://localhost:9200/_cat/indices?v&s=index"'

alias elastic_clear='curl -X DELETE "localhost:9200/_all"'
