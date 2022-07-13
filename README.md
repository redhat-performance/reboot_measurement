# reboot_measurement

reboot the system, get how long it took for the reboot to happen, as well as pull the 
systemd information


Several files required to run
  ansible_vars.yml
  ansible_test_group
  ignore.yml

Files content/format
ansible_vars.yml

---
config_info:
  test_user: <user logging in as>
  ssh_key: <full path to the ssh key to use>
  user_parent: <parent directory of the users home directory>


ansible_test_group

---
test_group_list:
  - <host name>

ignore.yml (dummy file to keep ansible happy)

---
ignore:
  ignore: 0


