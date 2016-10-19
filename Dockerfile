FROM nrel/openstudio

MAINTAINER Phylroy Lopez phylroy.lopez@canada.ca


ARG DISPLAY=local
ENV DISPLAY ${DISPLAY}

# Add ability to add ubuntu repositories required for development.
RUN apt-get update \
  && apt-get install -y \
  software-properties-common \
  python-software-properties \
  debconf-utils \
  dpkg-dev \
  zip

#install Java & Netbeans
RUN add-apt-repository -y ppa:webupd8team/java && add-apt-repository -y ppa:openjdk-r/ppa && apt-get update \
&& apt-get -y purge openjdk* \
&& apt-get install -y python-software-properties debconf-utils \
&& echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections \
&& apt-get update && apt-get install -y oracle-java8-installer openjdk-8-jdk

#Get installer for netbeans, but do not install.. leave it up to user.
RUN curl -sSL http://download.netbeans.org/netbeans/8.1/final/bundles/netbeans-8.1-javase-linux.sh -o /tmp/netbeans.sh \
&& chmod +x /tmp/netbeans.sh \
&& curl -sSL http://plugins.netbeans.org/download/plugin/3696 -o /tmp/ruby_netbeans.zip \
&& unzip  /tmp/ruby_netbeans.zip
RUN /tmp/netbeans.sh --silent

RUN curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - \
  && apt-get update \
  && apt-get install -y \
    ca-certificates \
	  git \
	  gfortran \
    gconf2 \
	  qt5-default \
	  libqt5webkit5-dev \
	  libboost1.55-all-dev \
	  swig \
	  libssl-dev \
	  libxt-dev \
	  curl \
	  gvfs-bin \
	  xdg-utils \
	  libasound2 \
	  libatk1.0-0 \
	  libcairo2 \
	  libcups2 \
	  libdatrie1 \
	  libdbus-1-3 \
	  libfontconfig1 \
	  libfreetype6 \
	  libgconf-2-4 \
	  libgcrypt20 \
	  libgl1-mesa-dri \
	  libgl1-mesa-glx \
	  libgdk-pixbuf2.0-0 \
	  libglib2.0-0 \
	  libgtk2.0-0 \
	  libgpg-error0 \
	  libgraphite2-3 \
	  libnotify-bin \
	  libnss3 \
	  libnspr4 \
	  libpango-1.0-0 \
	  libpangocairo-1.0-0 \
    libreoffice-calc \
    libxcomposite1 \
	  libxcursor1 \
	  libxdmcp6 \
	  libxi6 \
	  libxrandr2 \
	  libxrender1 \
    libxss1 \
	  libxtst6 \
	  liblzma5 \
    lynx \
    nano \
    nodejs \
	  software-properties-common \
    terminator \
    texlive-xetex \
	  unzip \
	  xterm \
    icnsutils \
    graphicsmagick \
    xz-utils \
    firefox \
  && rm -rf /var/lib/apt/lists/* \
  && set -x \
	&& curl -sSL https://go.microsoft.com/fwlink/?LinkID=760868 -o /tmp/vs.deb \
	&& dpkg -i /tmp/vs.deb \
	&& rm -rf /tmp/vs.deb \
  && curl -sSL https://release.gitkraken.com/linux/gitkraken-amd64.deb -o /tmp/gitkraken.deb \
  && dpkg -i /tmp/gitkraken.deb

##Configuration
#Fix X11 bug of 	electron not running under remote x11
RUN sed -i 's/BIG-REQUESTS/_IG-REQUESTS/' /usr/lib/x86_64-linux-gnu/libxcb.so.1

#ensure OS is part of the ruby lib
RUN echo 'export RUBYLIB="/usr/local/lib/site_ruby/2.0.0"' >> ~/.bashrc

#add regular user
RUN useradd -m nrcan && echo "nrcan:nrcan" | chpasswd && adduser nrcan sudo
WORKDIR /home/nrcan

RUN apt-get install libtinfo-dev \
&& wget http://www.cmake.org/files/v3.3/cmake-3.3.0.tar.gz \
&& tar -xzf cmake-3.3.0.tar.gz \
&& cd cmake-3.3.0 \
&& ./configure \
&& make -j2 \
&& make install

### nrcan's ruby setup....
USER nrcan
# Add RUBYLIB link for openstudio.rb
ENV RUBYLIB /usr/local/lib/site_ruby/2.0.0
# Build and install Ruby 2.0 using rbenv for flexibility for user.
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv \
  && git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build \
  && RUBY_CONFIGURE_OPTS=--enable-shared ~/.rbenv/bin/rbenv install 2.0.0-p594 \
  && ~/.rbenv/bin/rbenv global 2.0.0-p594 \
  && echo 'PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc \
  && echo 'eval "$(rbenv init -)"' >> ~/.bashrc
RUN ~/.rbenv/shims/gem install  \
    bundler \
    debase \
    debride \
    fasterer \
    rcodetools \
#    reek \
    rubocop \
    ruby-beautify \
    ruby-debug-ide \
    ruby-lint
# Add extensions to nrcan vscode installation.
RUN code --install-extension ilich8086.launcher \
  && code --install-extension rebornix.Ruby \
  && code --install-extension ms-vscode.cpptools \
  && code --install-extension karyfoundation.idf
#Add netbeans to nrcan's path in bashrc.
RUN echo 'PATH="/usr/local/netbeans-8.1/bin:$PATH"' >> ~/.bashrc





ENTRYPOINT ["terminator"]
# docker rm $(docker ps -a -q) && docker rmi $(docker images -q)
# /c/Program\ Files/Xming/Xming.exe -ac -multiwindow -clipboard
# docker build --build-arg DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}'):0.0 -t openstudio-dev .
# docker run -ti -e DISPLAY=$(ipconfig | grep -m 1 "IPv4" | awk '{print $NF}'):0.0 openstudio-dev
