# sinatra 
FROM debian:jessie

MAINTAINER Josh Cox <josh@webhosting.coop>

ENV DEBIAN_FRONTEND noninteractive

# Install node.js, then npm install yo and the generators
RUN apt-get -yq update && \
    apt-get -yq install git curl net-tools sudo bzip2 libpng-dev locales-all
RUN apt-get install -yq libavahi-compat-libdnssd-dev vim keychain

# Add a sinatra user because grunt doesn't like being root
RUN adduser --uid 1000 --disabled-password --gecos "" sinatra && \
  echo "sinatra ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# set HOME so 'npm install' and 'bower install' don't write to /
ENV HOME /home/sinatra

ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN mkdir /src && chown sinatra:sinatra /src
WORKDIR /src

ADD set_env.sh /usr/local/sbin/
RUN chmod +x /usr/local/sbin/set_env.sh
ENTRYPOINT ["set_env.sh"]

# Always run as the sinatra user
USER sinatra

# RVM install ruby
RUN ["/bin/bash", "-c",  "gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3"]
RUN ["/bin/bash", "-c",  "curl -L get.rvm.io | bash -s stable"]
RUN ["/bin/bash", "-c",  "echo 'source /home/sinatra/.rvm/scripts/rvm '>>~/.bashrc"]
RUN ["/bin/bash", "-c",  "source /home/sinatra/.rvm/scripts/rvm ; rvm requirements; rvm install ruby-2.1.4; rvm use --default 2.1.4; source /home/sinatra/.rvm/scripts/rvm"]
RUN ["/bin/bash", "-c",  "source /home/sinatra/.rvm/scripts/rvm ; rvm use --default 2.1.4; gem install bundler sinatra"]

USER root
WORKDIR /srv/www
#ADD www/. /srv/www/
#ADD www/.* /srv/www/
#RUN rm -Rf app
RUN git clone  https://github.com/joshuacox/microservice.git app
RUN cd app; git remote add ssh  git@github.com/joshuacox/microservice.git
RUN sudo chown -R sinatra. /srv/www 
USER sinatra

RUN ["/bin/bash", "-c",  "source /home/sinatra/.rvm/scripts/rvm ; bundle install"]
#RUN ["/bin/bash", "-c",  "npm owner ls bufferutil"]
#RUN ["/bin/bash", "-c",  "source /home/sinatra/.rvm/scripts/rvm ; npm install"]
# RUN ["/bin/bash", "-c",  "source /home/sinatra/.rvm/scripts/rvm ; npm install coffeelint"]
#RUN ["/bin/bash", "-c",  "source /home/sinatra/.rvm/scripts/rvm ; bower install"]

# Expose the ports
EXPOSE 3000 3001

ADD start.sh /srv/www/
ADD run.sh /srv/www/
# RUN cd app; git pull
USER root
CMD ["/bin/bash", "-c",  "source /home/sinatra/.rvm/scripts/rvm ; ./start.sh"]
