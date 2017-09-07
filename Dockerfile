FROM openjdk:8-jdk
#FROM jdk-test:latest
#RUN ls /home

# RUN useradd -u 1000 -M -s /bin/bash android
# RUN chown 1000 /opt

# USER android 
ENV ANDROID_COMPILE_SDK="25" ANDROID_BUILD_TOOLS="24.0.0" NODE_VER="6.11.3" ANDROID_SDK_TOOLS="24.4.1" PATH="/opt/node/bin:/opt/android-sdk-linux/tools:/opt/android-sdk-linux/tools/bin:${PATH}"

RUN cd /opt && \ 
    apt-get --quiet update --yes && \
    apt-get --quiet install --yes wget tar unzip lib32stdc++6 lib32z1 && \
    wget --quiet --output-document=android-sdk.tgz https://dl.google.com/android/android-sdk_r${ANDROID_SDK_TOOLS}-linux.tgz && \
    tar --extract --gzip --file=android-sdk.tgz && rm android-sdk.tgz && \
    wget --quiet --output-document=node.tar.xz  https://nodejs.org/dist/v${NODE_VER}/node-v${NODE_VER}-linux-x64.tar.xz && \
    tar -xf node.tar.xz	&& rm node.tar.xz && \
    mv /opt/node-v${NODE_VER}-linux-x64 /opt/node

run echo y | android --silent update sdk --no-ui --all --filter android-${ANDROID_COMPILE_SDK} && \
    echo y | android --silent update sdk --no-ui --all --filter platform-tools && \
    echo y | android --silent update sdk --no-ui --all --filter build-tools-${ANDROID_BUILD_TOOLS} && \
    echo y | android --silent update sdk --no-ui --all --filter extra-android-m2repository && \
    echo y | android --silent update sdk --no-ui --all --filter extra-google-google_play_services && \
    echo y | android --silent update sdk --no-ui --all --filter extra-google-m2repository

run npm install -g phonegap cordova
