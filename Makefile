
version = 0.4
version-bb = 0.4.3
id = d76.mockup-job
pkg-job = MockupJob.pkg
pkg-uninstall = MockupJobUninstall.pkg
pkg-bb = MockupBB.pkg
pkg-bb-uninstall = MockupBBUininstall.pkg

job-root = target/mockup-job/root
job-scripts = target/mockup-job/scripts
bb-bin = target/bb/root

all: pkg pkg-uninstall

build:
	mkdir -p ${job-root}/usr/local/bin
	mkdir -p ${job-root}/Library/LaunchDaemons
	mkdir -p ${job-scripts}
	cp bin/mockup-job.sh ${job-root}/usr/local/bin/
	cp etc/d76.mockup-job.plist ${job-root}/Library/LaunchDaemons/
	cp scripts/preinstall ${job-scripts}/
	cp scripts/postinstall ${job-scripts}/

build-uninstall:
	mkdir -p target/uninstall/scripts
	cp scripts/uninstall target/uninstall/scripts/postinstall

build-bb:
	mkdir -p ${bb-bin}/usr/local/bin
	curl -s https://raw.githubusercontent.com/babashka/babashka/master/install > target/bb/bb-install
	sh target/bb/bb-install \
		--dir target/bb/root/usr/local/bin \
		--download-dir target/bb/ \
		--version ${version-bb} \
		--checksum 9a9af0f7ddc7ff1db1bc52ae27e1803d991d7ac88dab3d2f5fbd72c1ef7e9582 \
		--static

build-uninstall-bb:
	mkdir -p target/uninstall-bb/scripts
	cp scripts/uninstall-bb target/uninstall-bb/scripts/postinstall

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

pkg-bb: build-bb pkgs-root
	pkgbuild \
	--root ${bb-bin} \
	--install-location / \
	--identifier d76.mockup-bb \
	--version ${version-bb} \
	--ownership recommended \
	target/pkgs/${pkg-bb}

pkg-uninstall-bb: build-uninstall-bb pkgs-root
	pkgbuild \
	--nopayload \
	--scripts target/uninstall-bb/scripts \
	--identifier d76.mockup-bb-uninstall \
	--version ${version-bb} \
	target/pkgs/${pkg-bb-uninstall}

install: pkg
	sudo installer \
	-pkg target/pkgs/${pkg-job} \
	-target /

uninstall: pkg-uninstall
	sudo installer \
	-pkg target/pkgs/${pkg-uninstall} \
	-target /

install-bb: pkg-bb
	sudo installer \
	-pkg target/pkgs/${pkg-bb} \
	-target /

uninstall-bb: pkg-uninstall-bb
	sudo installer \
	-pkg target/pkgs/${pkg-bb-uninstall} \
	-target /
