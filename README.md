# Guestbook

Guestbook is an Ansible playbook, which together with multiple Ruby scripts, gathers and saves meta data relating to a WordPress users most recent login. The information is stored in Unix epoch time.

![Book](book.webp)

## Prerequisites

Variables declared in a defaults/main.yaml file:

- HOME: Remote server directory where output files are created.
- WPATH: Path to the wordpress installation.
- GIT: Local path to the git repository.
- URL: Wordpress root domain.

```console
- name: Retrieve the last login timestamps
  ansible.builtin.script:
  args:
    chdir: '{{ HOME }}'
    cmd: '{{ GIT }}guestbook/meta.rb {{ TRAIL }} {{ URL }}'
```

## Run

Navigate to the folder containing your ***playbook.yaml*** file and (dependent on the location of your inventory file) run:

```console
ansible-playbook -i ~/inventory.yaml playbook.yaml
```

## Output

Outputs two files: (1) registered users who have no recorded logins anywhere, and (2) registered users who have recorded at leat one login at some point. These files are named *zeros.json* and *current.json* respectively.

## License

Code is distributed under [The Unlicense](https://github.com/nausicaan/free/blob/main/LICENSE.md) and is part of the Public Domain.
