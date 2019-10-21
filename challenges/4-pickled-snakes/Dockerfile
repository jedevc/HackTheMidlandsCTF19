FROM ubuntu

# install required packages
RUN echo 'APT::Get::Assume-Yes "true";\nAPT:Get:force-yes "true";' > /etc/apt/apt.conf.d/90forceyes && \
	echo 'y' | unminimize && \
	apt-get install -y openssh-server

# user management
RUN mkdir /var/run/sshd && \
	useradd -ms /bin/bash tom && \
	chown root:root /home/tom && \
	chmod 555 /home/tom && \
	chmod 3773 /tmp && \
	echo "tom:securityishard" | chpasswd

# the important files
WORKDIR /home/tom
COPY flag.unknown flag.unknown

# run the ssh server
RUN chmod -x /etc/update-motd.d/* && \
	truncate -s 0 /etc/legal
COPY motd /etc/motd
EXPOSE 22
CMD /usr/sbin/sshd -D
