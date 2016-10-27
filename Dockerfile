FROM nrel/openstudio

MAINTAINER Phylroy Lopez phylroy.lopez@canada.ca

ARG DISPLAY=local
ENV DISPLAY ${DISPLAY}

#Repository utilities add on list.
ARG repository_utilities='ca-certificates software-properties-common python-software-properties dpkg-dev debconf-utils'

#Basic software
ARG software='git curl zip lynx nano unzip xterm terminator firefox'

#Netbeans Dependancies (requires $java_repositories to be set)
ARG netbeans_deps='oracle-java8-installer libxext-dev libxrender-dev libxtst-dev'

#VCCode Dependancies
ARG vscode_deps='curl libc6-dev nodejs npm libasound2 libgconf-2-4 libgnome-keyring-dev libgtk2.0-0 libnss3 libpci3  libxtst6 libcanberra-gtk-module libnotify4 libxss1 wget'
#Java repositories needed for Netbeans

#Purge software list
ARG intial_purge_software='openjdk*'

#Ubuntu install commands
ARG apt_install='apt-get install -y --no-install-recommends'

#Ubuntu install clean up command
ARG clean='rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /downloads/*'

#Create folder for downloads
RUN mkdir /downloads


# Add ability to add ubuntu repositories required for development.

RUN apt-get update && $apt_install $software $repository_utilities $vscode_deps && apt-get clean && $clean \
&& apt-get update && add-apt-repository ppa:webupd8team/java -y && apt-get update \
&& (echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections) && apt-get install -y oracle-java8-installer oracle-java8-set-default
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH
RUN apt-get update && $apt_install $netbeans_deps && apt-get clean && $clean


#Update NodeJS
RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
#Install VSCode and set firefox as default browser for it
RUN set -x \
&& curl -sSL https://go.microsoft.com/fwlink/?LinkID=760868 -o /downloads/vs.deb \
&& ln -s /usr/bin/firefox /bin/xdg-open \
&& dpkg -i /downloads/vs.deb && apt-get clean && $clean


#ensure OS is part of the ruby lib
RUN echo 'export RUBYLIB="/usr/local/lib/site_ruby/2.0.0"' >> ~/.bashrc

#Install Netbeans.
RUN curl -sSL http://download.netbeans.org/netbeans/8.2/final/bundles/netbeans-8.2-php-linux-x64.sh -o /downloads/netbeans.sh \
&& chmod +x /downloads/netbeans.sh \
&& /downloads/netbeans.sh --silent \
&& apt-get clean && $clean



#Add regular user
RUN useradd -m nrcan && echo "nrcan:nrcan" | chpasswd \
&& adduser nrcan sudo

USER nrcan
# Build and install Ruby 2.0 using rbenv for flexibility
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN RUBY_CONFIGURE_OPTS=--enable-shared ~/.rbenv/bin/rbenv install 2.0.0-p594
RUN ~/.rbenv/bin/rbenv global 2.0.0-p594

# Ruby paths
RUN echo 'export PATH="~/.rbenv/bin:~/.rbenv/shims:$PATH"' >> ~/.bashrc \
&& echo 'eval "$(rbenv init -)"' >> ~/.bashrc

#Install gems for user.
RUN ~/.rbenv/shims/gem install bundler debase debride fasterer rcodetools rubocop ruby-beautify ruby-debug-ide ruby-lint

WORKDIR /home/nrcan

# Add RUBYLIB link for openstudio.rb
ENV RUBYLIB /usr/local/lib/site_ruby/2.0.0

#Download Ruby plugin for Netbeans (user needs to install manually on their own.)
RUN mkdir ~/ruby_netbeans_plugin \
&& curl -sSL http://plugins.netbeans.org/download/plugin/3696 -o ~/ruby_netbeans_plugin/ruby_netbeans.zip \
&& unzip ~/ruby_netbeans_plugin/ruby_netbeans.zip -d ~/ruby_netbeans_plugin \
&& rm ~/ruby_netbeans_plugin/ruby_netbeans.zip

# Add extensions to nrcan vscode installation.
RUN for ext in ilich8086.launcher rebornix.Ruby ms-vscode.cpptools karyfoundation.idf ; \
    do code --install-extension  $ext; done
#Add netbeans to nrcan's path in bashrc.
RUN echo 'PATH="/usr/local/netbeans-8.2/bin:$PATH"' >> ~/.bashrc

#Add helper scripts to path
RUN echo 'PATH="~/btap_utilities:$PATH"' >> ~/.bashrc
RUN git clone https://github.com/phylroy/btap_utilities.git

WORKDIR /home/nrcan
ENTRYPOINT ["terminator"]
# docker rm $(docker ps -a -q) && docker rmi $(docker images -q)
# /c/Program\ Files/Xming/Xming.exe -ac -multiwindow -clipboard
# docker build --build-arg DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}'):0.0 -t openstudio-dev .
# docker run -ti -e DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}'):0.0 openstudio-dev
