# Base runit image
FROM sugi/debian-i386:etch
RUN apt-get update
ADD atokx3.tar.gz /var/local/
ADD atokx3up2.tar.gz /var/local/ATOKX3
RUN apt-get -y install dpkg-dev
RUN cd /var/local/ATOKX3 && dpkg-scanpackages . /dev/null | gzip -c9 > Packages.gz
RUN echo "deb file:///var/local/ATOKX3 /" >> /etc/apt/sources.list
RUN apt-get update && apt-get -y --force-yes install atokx iiimf-gtk iiimf-x iiimf-server iiimf-properties
ADD a20y1311lx.tgz /var/local/
RUN apt-get install locales-all ttf-vlgothic

# Change to your user name and uid/gid.
RUN useradd --uid 1000 sugi
