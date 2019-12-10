#!/usr/bin/env bash

blue_log $log_add_packages
for (( i=0; i<number_of_pkg ; i++ )); do
    echo ${add_pkg[$i]} >> $working_directory/packages.$make_arch
done
for (( i=0; i<number_add_pkg_aur ; i++ )); do
    echo ${add_pkg_aur[$i]} >> $working_directory/packages.$make_arch
done