FROM ky1vstar/flutter-tools:wsc2019-vs2019

ARG flutter_branch=stable

# Install Google Root R1 cert so pub.dartlang.org stays working

ADD https://pki.goog/repo/certs/gtsr1.pem C:/TEMP/gtsr1.pem
RUN powershell.exe -Command \
        Import-Certificate -FilePath C:\TEMP\gtsr1.pem -CertStoreLocation Cert:\LocalMachine\Root

# Install Flutter

RUN setx path "%path%;C:\flutter\bin;C:\flutter\bin\cache\dart-sdk\bin;"

RUN git clone -b %flutter_branch% https://github.com/flutter/flutter.git C:\flutter

RUN flutter config --no-analytics

RUN flutter config --enable-windows-desktop

RUN flutter precache --windows

RUN flutter doctor -v