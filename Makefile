WD = $(shell pwd)

libkface=libkface3_15.04.0-1_amd64.deb
libkface-data=libkface-data_15.04.0-1_all.deb

build:
	docker build -t builder-digikam .

get_debs:
	mkdir -p $(WD)/output
	docker run --name=digikam-builder -v $(WD)/output:/output -i -t builder-digikam cp -r /sources/debs /output
	docker rm digikam-builder

install:
	sudo chown -R `id -nu`: $(WD)/output
	cd $(WD)/output/debs && wget http://ftp.ca.debian.org/debian/pool/main/libk/libkface/$(libkface) -O $(libkface)
	cd $(WD)/output/debs && wget http://ftp.ca.debian.org/debian/pool/main/libk/libkface/$(libkface-data) -O $(libkface-data)
	cd $(WD)/output/debs && sudo dpkg -i digikam_*deb digikam-data_*deb kipi-plugins_*deb kipi-plugins-common_*deb libkvkontakte1_*deb libmediawiki1_*deb showfoto_*deb libkface3_*deb libkface-data_*deb

clean:
	docker rmi builder-digikam
	rm -rf $(WD)/output
