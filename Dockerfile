FROM microsoft/windowsservercore

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

RUN $url = 'https://cygwin.com/setup-x86_64.exe'; \
 Write-Host ('Downloading {0} ...' -f $url); \
 Invoke-WebRequest -Uri $url -OutFile 'C:/setup-x86_64.exe'; \
 \
 Write-Host 'Installing ...'; \
 New-Item -ItemType directory -Path 'C:/tmp'; \
 Start-Process "C:/setup-x86_64.exe" -NoNewWindow -Wait -PassThru -ArgumentList @('-q','-v','-n','-B','-R','C:/cygwin64','-l','C:/tmp','-s','http://cygwin.mirror.constant.com/', \
 '-P','ninja,gcc-objc,gcc-objc++,libglib2.0-devel,zlib-devel,python3-pip,vala,gobject-introspection,libgtk3-devel'); \
 \
 Write-Host 'Removing temporary files...'; \
 Remove-Item -Path 'C:/tmp' -Force -Recurse -ErrorAction Ignore; \
 \
 Write-Host 'Verifying install ...'; \
 Start-Process "C:/cygwin64/bin/cygcheck.exe" -NoNewWindow -Wait -PassThru -ArgumentList @('-c'); \
 \
 Write-Host 'Complete.';

ENTRYPOINT ["C:\\cygwin64\\bin\\bash.exe", "-lc"]
CMD ["--version"]
