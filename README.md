# Guestbook

Guestbook is an Ansible playbook, which together with two Ruby scripts, gathers and saves meta data relating to a WordPress users most recent login. The information is stored in Linux Epoch time.

## Prerequisites

- Variables declared in a defaults/main.yaml file:
    1. HOME: Remote server directory where output files are created.
    2. GIT: Local path to your git repository.
    3. TRAIL: Path to the wordpress installation.
    4. URL: Wordpress root domain.

```ansible
    - name: Retrieve the last login timestamps
    ansible.builtin.script:
    args:
        chdir: '{{ HOME }}'
        cmd: '{{ GIT }}guestbook/meta.rb {{ TRAIL }} {{ URL }}'
```

## Run

Navigate to the folder containing your ***playbook.yaml*** file and run:

```console
ansible-playbook -i inventory.yaml playbook.yaml
```

## License

Code is distributed under [The Unlicense](https://github.com/nausicaan/free/blob/main/LICENSE.md) and is part of the Public Domain.
