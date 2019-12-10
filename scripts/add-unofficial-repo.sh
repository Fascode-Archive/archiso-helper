if [[ -n $add_repo_name ]]; then
    arch=$make_arch
    echo -e "[$add_repo_name]\nSigLevel = $add_repo_siglevel\nServer = $add_repo_server" >> $working_directory/pacman.conf
fi