FROM microsoft/windowsservercore

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN $url = 'https://cygwin.com/setup-x86_64.exe'; \
 Write-Host ('Downloading {0} ...' -f $url); \
 Invoke-WebRequest -Uri $url -OutFile 'C:/setup-x86_64.exe'; \
 \
 Write-Host 'Installing ...'; \
 New-Item -ItemType directory -Path 'C:/tmp'; \
 Start-Process "C:/setup-x86_64.exe" -NoNewWindow -Wait -PassThru -ArgumentList @('-q','-v','-n','-B','-R','C:/cygwin64','-l','C:/tmp','-s','http://cygwin.mirror.constant.com/', '-P', '\
flex,\
gcc-fortran,\
gcc-objc++,\
gcc-objc,\
gobject-introspection,\
itstool,\
libQt5Core-devel,\
libQt5Gui-devel,\
libSDL2-devel,\
libboost-devel,\
libglib2.0-devel,\
libgtk3-devel,\
libllvm-devel,\
libllvm-devel-static,\
libncurses-devel,\
libopenmpi-devel,\
libprotobuf-devel,\
libwmf-devel,\
ninja,\
python3-cython,\
python3-devel,\
python3-gi,\
python3-pip,\
vala,\
zlib-devel\
'); \
 \
 Write-Host 'Removing temporary files...'; \
 Remove-Item -Path 'C:/tmp' -Force -Recurse -ErrorAction Ignore; \
 \
 Write-Host 'Verifying install ...'; \
 Start-Process "C:/cygwin64/bin/cygcheck.exe" -NoNewWindow -Wait -PassThru -ArgumentList @('-c'); \
 \
 Write-Host 'Complete.';

# This prevents /etc/profile from changing the working directory to $HOME, so running this container with --workdir works as expected
ENV CHERE_INVOKING=1

ENTRYPOINT ["C:\\cygwin64\\bin\\bash.exe", "-lc"]
CMD ["--version"]
