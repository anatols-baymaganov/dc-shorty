# dc-shorty

The set of short docker-compose commands' aliases to speed up and simplify using with Ruby On Rails projects.

### Steps to use

1. Copy `dc-shorty.sh` to `~/.dc-shorty.sh`
2. Download and past [parse_yaml.sh](https://gist.github.com/pkuczynski/8665367) to `~/.parse_yaml.sh`
3. Add next lines to your `~/.bashrc`

        . ~/.dc-shorty.sh

4. Reopen terminal or/and type `. ~/.bashrc`
5. Add next line to your global gitignore file if you don't want to have `.dc-shorty.yml` in git repository of your project

        .dc-shorty.yml

6. Inside directory of your Ruby on Rails project start command `dc-init app`. Where `app` - is the name of your application service in `docker-compose.yml`

7. Modify the list of linters in `.dc-shorty.yml`
8. That's it ;)

### List of shortcuts

* `dc-init <application service name>`
* `dc-up` - `docker-compose up`. Currently this command expects that the name of container of application will have name like `<dir name>_<app service name>_1`, in another case it will not work. So you can start application usual way and use other presented shortcuts.
* `dc-ps` - equivalent to `docker-compose ps`
* `dc-sp` - equivalent to `docker-compose stop`
* `dc-ex <command>` - execute command in context of application
* `dc-rc` - rails console
* `dc-mg <options>` - migrate db
* `dc-gm <migration name>` - generate migration
* `dc-rl <options>` - rollback migration
* `dc-sd <seeds name>` - start task seeds for gotten "seeds name", if name is ommited then seeds.rb will be started
* `dc-st` - `rails db:migrate:status`
* `dc-lint <sequence of linters names>` - start linters from list defined in config file. Linter name can be one of the list, separated by comma or if arguments are omitted then all linters will be started.
* `dc-in <service name>` - ssh for docker container by service name (`docker-compose bash`)
