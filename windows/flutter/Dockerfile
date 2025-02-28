ARG base_image_tag=wsc2022

FROM ky1vstar/flutter-tools:${base_image_tag}

ARG flutter_branch=stable
ARG flutter_hash=any

# Install Google Root R1 cert so pub.dartlang.org stays working

ADD https://pki.goog/repo/certs/gtsr1.pem C:/TEMP/gtsr1.pem
RUN powershell.exe -Command \
        Import-Certificate -FilePath C:\TEMP\gtsr1.pem -CertStoreLocation Cert:\LocalMachine\Root

# Install Flutter

RUN setx path "%path%;C:\flutter\bin;C:\flutter\bin\cache\dart-sdk\bin;"

RUN git clone -b %flutter_branch% https://github.com/flutter/flutter.git C:\flutter

RUN cd C:\flutter && powershell.exe -Command \
        if ($env:flutter_hash -ne 'any') { git reset --hard $env:flutter_hash }

RUN flutter config --no-analytics

RUN flutter config --enable-windows-desktop

RUN flutter precache --windows

RUN flutter doctor -v