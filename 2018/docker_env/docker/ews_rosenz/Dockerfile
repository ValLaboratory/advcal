# syntax =docker/dockerfile:experimental
FROM centos:7
LABEL maintainer "@valsitoh"
WORKDIR /root

#RUN mkdir /public_html
RUN yum update -y
RUN yum install -y \
		epel-release \
		curl \
		git
RUN yum install -y nginx
COPY file_tree/etc/nginx/nginx.conf /etc/nginx/nginx.conf

STOPSIGNAL SIGTERM 
CMD ["nginx", "-g", "daemon off;"] 

