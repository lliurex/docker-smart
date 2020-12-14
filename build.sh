current_branch="$(git branch 2>/dev/null |sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
gbp buildpackage -ai386 --build=any -us -uc -rfakeroot --git-export-dir=../build-area --git-debian-branch=$current_branch --git-cleaner='fakeroot debian/rules clean'
gbp buildpackage -us -uc -rfakeroot --git-export-dir=../build-area --git-debian-branch=$current_branch --git-cleaner='fakeroot debian/rules clean'
