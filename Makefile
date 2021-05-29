
version = 0.4
id = d76.mockup-job
pkg-job = MockupJob.pkg
pkg-uninstall = MockupJobUninstall.pkg

job-root = target/mockup-job/root
job-scripts = target/mockup-job/scripts

all: pkg pkg-uninstall

build:
	mkdir -p ${job-root}/usr/local/bin
	mkdir -p ${job-root}/Library/LaunchDaemons
	mkdir -p ${job-scripts}
	cp bin/mockup-job.sh ${job-root}/usr/local/bin/
	cp etc/d76.mockup-job.plist ${job-root}/Library/LaunchDaemons/
	cp scripts/postinstall ${job-scripts}/

build-uninstall:
	mkdir -p target/uninstall/scripts
	cp scripts/uninstall target/uninstall/scripts/postinstall

clean:
	rm -rf target/*

pkgs-root:
	mkdir -p target/pkgs

pkg: build pkgs-root
	pkgbuild \
	--root ${job-root} \
	--scripts ${job-scripts} \
	--install-location / \
	--identifier ${id} \
	--version ${version} \
	--ownership recommended \
	target/pkgs/${pkg-job}

pkg-uninstall: build-uninstall pkgs-root
	pkgbuild \
	--nopayload \
	--scripts target/uninstall/scripts \
	--identifier ${id}-uninstall \
	--version ${version} \
	target/pkgs/${pkg-uninstall}

install: pkg
	sudo installer \
	-pkg target/pkgs/${pkg-job} \
	-target /

uninstall: pkg-uninstall
	sudo installer \
	-pkg target/pkgs/${pkg-uninstall} \
	-target /
