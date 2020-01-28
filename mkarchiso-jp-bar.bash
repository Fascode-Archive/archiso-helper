#!/usr/bin/env bash

# Settings
out=/tmp/mkinitcpio-jp-bar.patch


# check root
if [[ ! $UID = 0 ]]; then
    echo "Please run as root." >&2
    exit 1
fi

# export path to $out
cat >> $out << 'EOF'
--- /usr/bin/mkarchiso	2019-10-16 15:23:14.000000000 +0000
+++ /usr/bin/mkarchiso	2019-11-24 22:41:30.594047717 +0000
@@ -2,7 +2,7 @@
 
 set -e -u
 
-export LANG=C
+#export LANG=C
 
 app_name=${0##*/}
 arch=$(uname -m)
@@ -223,9 +223,11 @@
     mkdir -p "${work_dir}/iso/${install_dir}/${arch}"
     _msg_info "Creating SquashFS image, this may take some time..."
     if [[ "${quiet}" = "y" ]]; then
-        mksquashfs "${work_dir}/airootfs.img" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}" -no-progress &> /dev/null
+        #mksquashfs "${work_dir}/airootfs.img" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}" -no-progress &> /dev/null
+        mksquashfs "${work_dir}/airootfs.img" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}" &> /dev/null
     else
-        mksquashfs "${work_dir}/airootfs.img" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}" -no-progress
+        #mksquashfs "${work_dir}/airootfs.img" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}" -no-progress
+        mksquashfs "${work_dir}/airootfs.img" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}"
     fi
     _msg_info "Done!"
     rm ${work_dir}/airootfs.img
@@ -240,9 +242,11 @@
     mkdir -p "${work_dir}/iso/${install_dir}/${arch}"
     _msg_info "Creating SquashFS image, this may take some time..."
     if [[ "${quiet}" = "y" ]]; then
+        #mksquashfs "${work_dir}/airootfs" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}" -no-progress &> /dev/null
         mksquashfs "${work_dir}/airootfs" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}" -no-progress &> /dev/null
     else
-        mksquashfs "${work_dir}/airootfs" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}" -no-progress
+        #mksquashfs "${work_dir}/airootfs" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}" -no-progress
+        mksquashfs "${work_dir}/airootfs" "${work_dir}/iso/${install_dir}/${arch}/airootfs.sfs" -noappend -comp "${sfs_comp}"
     fi
     _msg_info "Done!"
 }
EOF


# functions
function install () {
    patch < $out
}

function uninstall () {
    patch -R -u < $out
}

function usage () {
    echo "mkarchiso Japanese and progress bar patch."
    echo
    echo "Yamada Hayao <shun819.mail@gmail.com>"
    echo "Twitter : @Hayao0819"
    echo
    echo "How to use the patch script."
    echo
    echo "   -i   Apply the patch."
    echo "   -u   The applied patch is returned to the state before application."
    echo "   -h   Displays this help."
}

# option 
while getopts 'i:u:n' arg; do
    case "${arg}" in
        i) install ;;
        u) uninstall ;;
        *) usage ;;
    esac
done