FROM canmet/docker-openstudio

MAINTAINER Phylroy Lopez phylroy.lopez@canada.ca

ARG DISPLAY=local
ENV DISPLAY ${DISPLAY}

#Repository utilities add on list.
ARG repository_utilities='ca-certificates software-properties-common python-software-properties dpkg-dev debconf-utils'

#Basic software
ARG software='git curl zip lynx xemacs21 nano unzip xterm terminator midori diffuse silversearcher-ag openssh-client'

#Netbeans Dependancies (requires $java_repositories to be set)
ARG netbeans_deps='oracle-java8-installer libxext-dev libxrender-dev libxtst-dev oracle-java8-set-default'

#VCCode Dependancies
ARG vscode_deps='curl libc6-dev  libasound2 libgconf-2-4 libgnome-keyring-dev libgtk2.0-0 libnss3 libpci3  libxtst6 libcanberra-gtk-module libnotify4 libxss1 wget'
#Java repositories needed for Netbeans

#D3 parallel coordinates deps due to canvas deps
ARG d3_deps='libcairo2-dev libjpeg-dev libpango1.0-dev libgif-dev build-essential g++'

#Purge software 
ARG intial_purge_software='openjdk*'

#set Java ENV
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $JAVA_HOME/bin:$PATH

#Ubuntu install commands
ARG apt_install='apt-get install -y --no-install-recommends --force-yes'

#Ubuntu install clean up command
ARG clean='rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /downloads/*'

#Create folder for downloads
RUN mkdir /downloads
#Install software packages
RUN apt-get update && $apt_install $software $d3_deps $r_deps $repository_utilities \ 
&& apt-get clean && $clean

#### Build R and install R packages.
# R deps
ARG r_deps='autoconf bison build-essential bzip2 ca-certificates curl imagemagick gdebi-core git libbz2-dev libcurl4-openssl-dev libgdbm3 libgdbm-dev libglib2.0-dev \
libncurses-dev libreadline-dev libxml2-dev libxslt-dev libffi-dev libssl-dev libyaml-dev procps ruby ruby-dev tar unzip wget zip zlib1g-dev debhelper \
fonts-cabin fonts-comfortaa fonts-droid fonts-font-awesome fonts-freefont-otf fonts-freefont-ttf fonts-gfs-artemisia fonts-gfs-complutum fonts-gfs-didot \
fonts-gfs-neohellenic fonts-gfs-olga fonts-gfs-solomos fonts-inconsolata fonts-junicode fonts-lato fonts-linuxlibertine fonts-lobster fonts-lobstertwo fonts-oflb-asana-math \
fonts-sil-gentium fonts-sil-gentium-basic fonts-stix gfortran gir1.2-freedesktop gir1.2-pango-1.0 libblas3 libcairo-script-interpreter2 libcairo2-dev libgs9 \
libintl-perl libjbig-dev libjpeg-dev libkpathsea6 liblapack-dev liblzma-dev libpoppler44 libtcl8.5 libtiff5-dev libtk8.5 libxml-libxml-perl libxss1 libxt-dev \
mpack tcl8.5 tcl8.5-dev tk8.5 tk8.5-dev ttf-adf-accanthis ttf-adf-gillius gfortran'
ENV R_VERSION 3.2.3
ENV R_MAJOR_VERSION 3
ENV R_SHA b93b7d878138279234160f007cb9b7f81b8a72c012a15566e9ec5395cfd9b6c1
RUN apt-get update && $apt_install $r_deps \ 
    && curl -fSL -o R.tar.gz "http://cran.fhcrc.org/src/base/R-$R_MAJOR_VERSION/R-$R_VERSION.tar.gz" \
    && echo "$R_SHA R.tar.gz" | sha256sum -c - \
    && mkdir /usr/src/R \
    && tar -xzf R.tar.gz -C /usr/src/R --strip-components=1 \
    && rm R.tar.gz \
    && cd /usr/src/R \
    && sed -i 's/NCONNECTIONS 128/NCONNECTIONS 2560/' src/main/connections.c \
    && ./configure --enable-R-shlib \
    && make -j$(nproc) \
    && make install \
    && make clean \
    && apt-get clean && $clean
# Add in the additional R packages
ADD config/install_packages.R install_packages.R  
RUN Rscript install_packages.R

#### Build sqlite with json support
RUN curl -fSL -o sqlite.tar.gz https://www.sqlite.org/2017/sqlite-autoconf-3160200.tar.gz \ 
    && mkdir /usr/src/sqlite3 \
    && tar -xzf sqlite.tar.gz -C /usr/src/sqlite3 \
    && rm sqlite.tar.gz \
    && cd /usr/src/sqlite3/sqlite-autoconf-3160200 \
    && ./configure --prefix=/usr/local --enable-json1 --enable-readline \
    && make  \ 
    && make install \
    && make clean
	
# MongoDB:
# Import MongoDB public GPG key AND create a MongoDB list file
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
&& apt-get install -y --no-install-recommends software-properties-common \
&& echo "deb http://repo.mongodb.org/apt/ubuntu $(cat /etc/lsb-release | grep DISTRIB_CODENAME | cut -d= -f2)/mongodb-org/3.2 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list 	
# Update apt-get sources AND install MongoDB
RUN apt-get update && apt-get install -y mongodb-org	
# Create the MongoDB data directory
RUN mkdir -p /data/db	
# Expose port 27017 from the container to the host
EXPOSE 27017


#Update NodeJS and express
RUN curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash - \
&& apt-get install -y nodejs nodejs  build-essential \
&& npm install -g express-generator nodemon bower
EXPOSE 3000

# Install vim
RUN apt-get update && apt-get remove --purge -y --force-yes vim  vim-gnome vim-tiny vim-common  \
&& $apt_install exuberant-ctags liblua5.1-dev luajit libluajit-5.1 python-dev ruby-dev libperl-dev git libncurses5-dev libgnome2-dev libgnomeui-dev libgtk2.0-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev \
&& mkdir /usr/include/lua5.1/include \
&& ln -s /usr/include/luajit-2.0 /usr/include/lua5.1/include \
&& git clone https://github.com/vim/vim.git \ 
&& cd vim \
&& ./configure --with-features=huge \
            --enable-rubyinterp \
            --enable-largefile \
            --disable-netbeans \
            --enable-pythoninterp \
            --with-python-config-dir=/usr/lib/python2.7/config \
            --enable-perlinterp \
            --enable-luainterp \
            --with-luajit \
	        --enable-gui=auto \
            --enable-fail-if-missing \
            --with-lua-prefix=/usr/include/lua5.1 \
            --enable-cscope \ 
&& make && make install \
&& cd ../ rm -fr vim

#install Amazon AWS CLI and packer
RUN wget https://releases.hashicorp.com/packer/1.0.0/packer_1.0.0_linux_amd64.zip \
&& unzip packer_1.0.0_linux_amd64.zip -d /usr/bin/ \
&& rm packer_1.0.0_linux_amd64.zip
RUN curl -O http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip \
&& mkdir /usr/local/ec2 \
&& unzip ec2-api-tools.zip -d /usr/local/ec2 \
&& mv  `find  /usr/local/ec2/ec2-api-tools-* -maxdepth 0` /usr/local/ec2/ec2-api-tools \
&& rm ec2-api-tools.zip  
ENV EC2_HOME=/usr/local/ec2/ec2-api-tools


USER  osdev
WORKDIR /home/osdev

RUN echo 'PATH="~/btap_utilities:$PATH"' >> ~/.bashrc \
&& git clone https://github.com/canmet-energy/btap_utilities.git \
&& cd ~/btap_utilities && chmod  774 *  \
&& /bin/bash -c "source /etc/user_config_bashrc \
&& cd ~/btap_utilities && ./configure_user.sh \
&& ln -s /usr/bin/midori /bin/xdg-open
CMD ["/bin/bash"]

