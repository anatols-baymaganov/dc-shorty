# this shortcuts is taken from
# https://github.com/anatols-baymaganov/dc-shorty/blob/master/dc-shorty.sh

# declare parse_yaml function
# this code snipped is taken from https://gist.github.com/pkuczynski/8665367
. ~/.parse_yaml.sh

dc_service() {
  eval $(parse_yaml .dc-shorty.yml "dc_")
  echo $dc_service
}

dc_js_lint() {
  eval $(parse_yaml .dc-shorty.yml "dc_")
  echo $dc_lint_js
}

dc_coffee_lint() {
  eval $(parse_yaml .dc-shorty.yml "dc_")
  echo $dc_lint_coffee
}

dc_scss_lint() {
  eval $(parse_yaml .dc-shorty.yml "dc_")
  echo $dc_lint_scss
}

dc_slim_lint() {
  eval $(parse_yaml .dc-shorty.yml "dc_")
  echo $dc_lint_slim
}

dc_haml_lint() {
  eval $(parse_yaml .dc-shorty.yml "dc_")
  echo $dc_lint_haml
}

dc_erb_lint() {
  eval $(parse_yaml .dc-shorty.yml "dc_")
  echo $dc_lint_erb
}

dc_rubocop() {
  eval $(parse_yaml .dc-shorty.yml "dc_")
  echo $dc_lint_ruby
}

dc_best_practices() {
  eval $(parse_yaml .dc-shorty.yml "dc_")
  echo $dc_lint_rails
}

# create template for docker-compose shorty commands
# this command doesn't update config file after it was created
dc_init() {
  # $1 - docker service (must be present)
  if [ -z "$1" ]; then
    echo 'Specify service name for container with application'   
  else
    if [ ! -f .dc-shorty.yml ]; then
      touch .dc-shorty.yml
      echo "service: $1" >> .dc-shorty.yml
      echo "#put command here to start lint" >> .dc-shorty.yml
      echo "#lint:" >> .dc-shorty.yml
      echo "#  ruby: rubocop" >> .dc-shorty.yml
      echo "#  rails: rails_best_practices" >> .dc-shorty.yml
      echo "#  scss: scss-lint" >> .dc-shorty.yml
      echo "#  slim: slim-lint" >> .dc-shorty.yml
      echo "#  haml: haml-lint" >> .dc-shorty.yml
      echo "#  erb: erblint" >> .dc-shorty.yml
      echo "#  js: rake eslint:run_all" >> .dc-shorty.yml
      echo "#  coffee: rails coffeelint" >> .dc-shorty.yml
    fi
  fi
}
alias dc-init='dc_init'

dc_up() {
  # $1 - can be omitted or equal -d - detach mode
  local service=$(dc_service)
  if [ ! -z "$service" ]; then
    local dir=${PWD##*/}
    local container="${dir}_${service}_1"
    docker-compose up -d    
    if [ "$1" != "-d" ]; then
      docker attach $container
    fi
  fi
}
alias dc-up='dc_up'

alias dc-ps='docker-compose ps'

alias dc-sp='docker-compose stop'

dc_exec() {
  # $1 - command to execute (must be presented)
  docker-compose exec $(dc_service) $@
}
alias dc-ex='dc_exec'

dc_rc() {
  docker-compose exec $(dc_service) bundle exec rails c
}
alias dc-rc='dc_rc'

dc_mg() {
  # $1 - can be VERSION=20170112053006 etc (can be omitted)
  docker-compose exec $(dc_service) bundle exec rails db:migrate $1
}
alias dc-mg='dc_mg'

dc_rl() {
  # $1 - can be STEP=1 or VERSION=20170112053006 etc (can be omitted)
  docker-compose exec $(dc_service) bundle exec rails db:rollback $1
}
alias dc-rl='dc_rl'

dc_seeds() {
  # $1 - seeds name, if omitted then seeds.rb will be performed
  if [ ! -z "$1" ]; then
    docker-compose exec $(dc_service) bundle exec rails db:seed:$1
  else
    docker-compose exec $(dc_service) bundle exec rails db:seed
  fi
}
alias dc-sd='dc_seeds'

dc_st() {
  docker-compose exec $(dc_service) bundle exec rails db:migrate:status
}
alias dc-st='dc_st'

dc_gm() {
  # $1 - migration's name (must be present)
  docker-compose exec $(dc_service) bundle exec rails generate migration $1
}
alias dc-gm='dc_gm'

dc_lint() {
  # $1 - sequence of linters names, if omitted then all linters from .dc-shorty.yml wiil be started
  if [ $# == 0 ]; then
    dc_start_linters 'all'
  else
    for lint in "$@"
    do
      dc_start_linters "$lint"
    done
  fi
}
alias dc-lint='dc_lint'

dc_start_linters() {
  # $1 - linter name in .dc-shorty.yml or 'all'
  local rubocop_run=$(dc_rubocop)
  if [ ! -z "$rubocop_run" ] && [ "$1" == 'ruby' -o "$1" == 'all' ]; then
    echo 'Start rubocop'
    docker-compose exec $(dc_service) bundle exec $rubocop_run && echo ''
  fi

  local rails_best_practices_run=$(dc_best_practices)
  if [ ! -z "$rails_best_practices_run" ] && [ "$1" == 'rails' -o "$1" == 'all' ]; then
    echo 'Start rails best practices'    
    docker-compose exec $(dc_service) bundle exec $rails_best_practices_run && echo ''
  fi

  local scss_lint_run=$(dc_scss_lint)
  if [ ! -z "$scss_lint_run" ] && [ "$1" == 'scss' -o "$1" == 'all' ]; then
    echo 'Start scss lint'    
    docker-compose exec $(dc_service) bundle exec $scss_lint_run && echo ''
  fi

  local slim_lint_run=$(dc_slim_lint)
  if [ ! -z "$slim_lint_run" ] && [ "$1" == 'slim' -o "$1" == 'all' ]; then
    echo 'Start slim lint'    
    docker-compose exec $(dc_service) bundle exec $slim_lint_run && echo ''
  fi

  local haml_lint_run=$(dc_haml_lint)
  if [ ! -z "$haml_lint_run" ] && [ "$1" == 'haml' -o "$1" == 'all' ]; then
    echo 'Start haml lint'    
    docker-compose exec $(dc_service) bundle exec $haml_lint_run && echo ''
  fi

  local erb_lint_run=$(dc_erb_lint)
  if [ ! -z "$erb_lint_run" ] && [ "$1" == 'erb' -o "$1" == 'all' ]; then
    echo 'Start erb lint'    
    docker-compose exec $(dc_service) bundle exec $erb_lint_run && echo ''
  fi

  local js_lint_run=$(dc_js_lint)
  if [ ! -z "$js_lint_run" ] && [ "$1" == 'js' -o "$1" == 'all' ]; then
    echo 'Start js lint'    
    docker-compose exec $(dc_service) bundle exec $js_lint_run && echo ''
  fi

  local coffee_lint_run=$(dc_coffee_lint)
  if [ ! -z "$coffee_lint_run" ] && [ "$1" == 'coffee' -o "$1" == 'all' ]; then
    echo 'Start coffee lint'    
    docker-compose exec $(dc_service) bundle exec $coffee_lint_run && echo ''
  fi
}

dc_in() {
  # $1 - docker service (must be present)
  docker-compose exec $1 bash
}
alias dc-in='dc_in'
