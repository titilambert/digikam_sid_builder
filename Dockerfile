FROM debian:sid


RUN echo "deb http://ftp.ca.debian.org/debian sid non-free contrib main" > /etc/apt/sources.list
RUN echo "deb http://ftp.ca.debian.org/debian experimental non-free contrib main" >> /etc/apt/sources.list
RUN echo "deb-src http://ftp.ca.debian.org/debian sid contrib main" >> /etc/apt/sources.list
RUN apt-get update && apt-get upgrade -y
RUN apt-get update && apt-get build-dep digikam -y

#RUN apt-get update && apt-get source digikam

RUN apt-get update && apt-get install -y shared-desktop-ontologies libsane-dev libexiv2-dev dh-apparmor valgrind libkface-dev wget

RUN mkdir sources

WORKDIR /sources

# Get source from ubuntu
RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/d/digikam/digikam_4.12.0-0ubuntu5.debian.tar.xz
RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/d/digikam/digikam_4.12.0.orig.tar.bz2
RUN tar xf digikam_4.12.0-0ubuntu5.debian.tar.xz
RUN tar xf digikam_4.12.0.orig.tar.bz2
RUN mv debian digikam-4.12.0


WORKDIR /sources/digikam-4.12.0

RUN sed  -i 's/ libkqoauth-dev,/# libkqoauth-dev,/g' debian/control 

RUN dpkg-buildpackage -tc -uc -us

RUN mkdir /output
RUN mkdir /sources/debs

VOLUME /output
RUN cp /sources/*deb /sources/debs/
