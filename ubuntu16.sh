#Specify OpenCV version
isOpenCV=false
cvVersion="3.4.4"

#old kernel installation
#apt install linux-image-4.4.0-171-generic
#vi /etc/default/grub
#GRUB_DEFAULT='Advanced options for Ubuntu>Ubuntu, with Linux 4.4.0-171-generic'
#
#update-grub

apt update
apt install -y openssh-server git curl tmux gcc g++ cmake clang wget
systemctl enable ssh

cd
git clone https://github.com/youkis/dotfiles
apt install -y zsh
chsh -s /bin/zsh root
cd dotfiles
./dotlink.sh

apt install -y build-essential
apt install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev
wget 'https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz'
tar -xvf Python-3.6.9.tgz
cd Python-3.6.9/
./configure --enable-shared --enable-optimizations
#./configure --enable-shared --enable-optimizations --with-tcltk-includes='-I/opt/ActiveTcl-8.6/include' --with-tcltk-libs='/opt/ActiveTcl-8.6/lib/libtcl8.6.so /opt/ActiveTcl-8.6/lib/libtk8.6.so'
sudo make altinstall
cd ..
rm -rf Python-3.6.9*
pip3.6 install jedi neovim

if "${isOpenCV}"; then
	mkdir -p installation/OpenCV-"$cvVersion"
	cd installation/OpenCV-"$cvVersion"
	apt -y remove x264 libx264-dev
	apt -y install build-essential checkinstall cmake pkg-config yasm
	apt -y install git gfortran
	apt -y install libjpeg8-dev libjasper-dev libpng12-dev
	apt -y install libtiff5-dev
	apt -y install libtiff-dev
	apt -y install libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev
	apt -y install libxine2-dev libv4l-dev
	cd /usr/include/linux
	ln -s -f ../libv4l1-videodev.h videodev.h
	cd -
	apt -y install libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev
	apt -y install libgtk2.0-dev libtbb-dev qt5-default
	apt -y install libatlas-base-dev
	apt -y install libfaac-dev libmp3lame-dev libtheora-dev
	apt -y install libvorbis-dev libxvidcore-dev
	apt -y install libopencore-amrnb-dev libopencore-amrwb-dev
	apt -y install libavresample-dev
	apt -y install x264 v4l-utils
	apt -y install libprotobuf-dev protobuf-compiler
	apt -y install libgoogle-glog-dev libgflags-dev
	apt -y install libgphoto2-dev libeigen3-dev libhdf5-dev doxygen

	git clone https://github.com/opencv/opencv.git
	cd opencv
	git checkout $cvVersion
	cd ..
	cd opencv
	mkdir build
	cd build
	cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_GTK=ON -D WITH_QT=ON ..
	make -j7
	make install
	echo /usr/local/lib > /etc/ld.so.conf.d/opencv.conf
	ldconfig -v
fi


wget 'https://github.com/peco/peco/releases/download/v0.5.3/peco_linux_386.tar.gz'
tar xzvf peco_linux_386.tar.gz
mv peco_linux_386/peco /usr/local/bin/
rm -rf peco_linux_386 peco_linux_386.tar.gz
chmod +x /usr/local/bin/peco

apt install -y software-properties-common
add-apt-repository -y ppa:neovim-ppa/stable
apt update
apt install -y neovim

wget 'https://dl.bintray.com/tigervnc/stable/ubuntu-16.04LTS/amd64/tigervncserver_1.9.0-1ubuntu1_amd64.deb'
apt install -y ./tigervncserver_1.9.0-1ubuntu1_amd64.deb
rm ./tigervncserver_1.9.0-1ubuntu1_amd64.deb

echo '
[color]
	ui = true
[core]
	editor = vim
[alias]
	co = checkout
	b = branch
	st = status
	cm = commit
[core]
	excludesfile = ~/.gitignore_global
	quotepath = false
[http]
	sslVerify = true' > ~/.gitconfig
echo '
__pycache__
*.py[cod]
*.out' > .gitignore_global

# kvm case
#echo '@reboot mount -t 9p -o trans=virtio work /work'|crontab -u root -
	
