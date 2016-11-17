FROM nrel/openstudio

MAINTAINER Phylroy Lopez phylroy.lopez@canada.ca

ARG DISPLAY=local
ENV DISPLAY ${DISPLAY}

#Repository utilities add on list.
ARG repository_utilities='ca-certificates software-properties-common python-software-properties dpkg-dev debconf-utils'

#Basic software
ARG software='git curl zip lynx nano unzip xterm terminator firefox diffuse mongodb-org postgresql postgresql-contrib'

#Netbeans Dependancies (requires $java_repositories to be set)
ARG netbeans_deps='oracle-java8-installer libxext-dev libxrender-dev libxtst-dev oracle-java8-set-default'

#VCCode Dependancies
ARG vscode_deps='curl libc6-dev nodejs npm libasound2 libgconf-2-4 libgnome-keyring-dev libgtk2.0-0 libnss3 libpci3  libxtst6 libcanberra-gtk-module libnotify4 libxss1 wget'
#Java repositories needed for Netbeans

#D3 parallel coordinates deps due to canvas deps
ARG d3_deps='libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++'

#Purge software 
ARG intial_purge_software='openjdk*'

#set Java ENV
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH

#Ubuntu install commands
ARG apt_install='apt-get install -y --no-install-recommends'

#Ubuntu install clean up command
ARG clean='rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /downloads/*'

#Create folder for downloads
RUN mkdir /downloads

# Add ability to add ubuntu repositories required for development.

# Add mongo and postgresql database software repositories.
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 \
&& echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.0.list \
&& sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list' \
&& curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add - \
&& apt-get update \
&& $apt_install $repository_utilities \
&& add-apt-repository ppa:webupd8team/java -y && add-apt-repository ppa:git-core/ppa \ 
&& apt-get update \
&& (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) \
&& apt-get update && $apt_install $software $vscode_deps $netbeans_deps $d3_deps \
&& apt-get clean && $clean

#Update NodeJS and express
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - \
&& ln -s `which nodejs` /usr/bin/node \ 
&& npm install -g express-generator nodemon
EXPOSE 3000

#Install VSCode and set firefox as default browser for it Also install Netbeans
RUN set -x \
&& curl -sSL https://go.microsoft.com/fwlink/?LinkID=760868 -o /downloads/vs.deb \
&& ln -s /usr/bin/firefox /bin/xdg-open \
&& dpkg -i /downloads/vs.deb \
&& rm /downloads/vs.deb \
&& apt-get clean && $clean

#Install Netbeans.
RUN curl -sSL http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-php-linux-x64.sh -o /downloads/netbeans.sh \
&& chmod +x /downloads/netbeans.sh \
&& /downloads/netbeans.sh --silent \
&& rm /downloads/netbeans.sh \
&& apt-get clean && $clean

#Add regular user
RUN useradd -m nrcan && echo "nrcan:nrcan" | chpasswd \
&& adduser nrcan sudo

#Create Mongodb folder and expose Mongo port
RUN mkdir -p /data/db && chown nrcan /data/db
EXPOSE 27017

#Configure Postgres
RUN mkdir -p /data/pgsql && chown nrcan /data/pgsql
USER nrcan
RUN /usr/lib/postgresql/9.6/bin/initdb -D /data/pgsql

USER nrcan
# Add RUBYLIB link for openstudio.rb
RUN echo 'export RUBYLIB="/usr/local/lib/site_ruby/2.0.0"' >> ~/.bashrc
ENV RUBYLIB /usr/local/lib/site_ruby/2.0.0

# Build and install Ruby 2.0 using rbenv for flexibility
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN RUBY_CONFIGURE_OPTS=--enable-shared ~/.rbenv/bin/rbenv install 2.0.0-p594
RUN ~/.rbenv/bin/rbenv global 2.0.0-p594

# Ruby paths
RUN echo 'export PATH="~/.rbenv/bin:~/.rbenv/shims:$PATH"' >> ~/.bashrc \
&& echo 'eval "$(rbenv init -)"' >> ~/.bashrc

#Install gems for user.
RUN ~/.rbenv/shims/gem install bundler debase debride fasterer rcodetools rubocop ruby-beautify ruby-debug-ide ruby-lint pry pry-doc parallel watchr google-api-client


WORKDIR /home/nrcan

#Download Ruby plugin for Netbeans (user needs to install manually on their own.) and extensions for vscode
RUN mkdir ~/ruby_netbeans_plugin \
&& curl -sSL http://plugins.netbeans.org/download/plugin/3696 -o ~/ruby_netbeans_plugin/ruby_netbeans.zip \
&& unzip ~/ruby_netbeans_plugin/ruby_netbeans.zip -d ~/ruby_netbeans_plugin \
&& rm ~/ruby_netbeans_plugin/ruby_netbeans.zip \
&& for ext in ilich8086.launcher rebornix.Ruby ms-vscode.cpptools karyfoundation.idf robertohuertasm.vscode-icons Tyriar.sort-lines; do code --install-extension  $ext; done

#Add netbeans, postgres and help script to bashrc.
RUN echo 'PATH="/usr/local/netbeans-8.2/bin:$PATH"' >> ~/.bashrc \
&& echo 'PATH="/usr/lib/postgresql/9.6/bin:$PATH"' >> ~/.bashrc \
&& echo 'PATH="~/btap_utilities:$PATH"' >> ~/.bashrc \
&& git clone https://github.com/phylroy/btap_utilities.git && cd ~/btap_utilities && chmod  774 *  && ./btap_gem_update_standards.sh \
&& cd ~/btap_utilities && ./configure_user.sh


#Add Git support and color to bash
RUN cp /usr/lib/git-core/git-sh-prompt ~/.git-prompt.sh \
&& echo 'source ~/.git-prompt.sh' >> ~/.bashrc \
&& echo 'red=$(tput setaf 1) && green=$(tput setaf 2) && yellow=$(tput setaf 3) &&  blue=$(tput setaf 4) && magenta=$(tput setaf 5) && reset=$(tput sgr0) && bold=$(tput bold)' >> ~/.bashrc \
&& echo PS1=\''\[$magenta\]\u\[$reset\]@\[$green\]\h\[$reset\]:\[$blue\]\w\[$reset\]\[$yellow\][$(__git_ps1 "%s")]\[$reset\]\$'\' >> ~/.bashrc

#Add openstudio and openstudio-standards to pry and irb config files.
RUN echo require \'openstudio\' >> ~/.pryrc \
&& echo require \'openstudio-standards\' >>~/.pryrc \
&& cp ~/.pryrc ~/.irbrc


ENTRYPOINT ["terminator"]
# docker rm $(docker ps -a -q) && docker rmi $(docker images -q)
# /c/Program\ Files/Xming/Xming.exe -ac -multiwindow -clipboard
# docker build --build-arg DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}'):0.0 -t openstudio-dev .
# docker run -ti -e DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}'):0.0 openstudio-dev
