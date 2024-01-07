FROM alpine:3.13

#LABEL org.opencontainers.image.source=https://github.com/mongodb-developer/get-started-cxx
#
ARG DRIVER_VERSION=3.6.6
ARG DRIVER_C_VERSION=1.21.1
#
RUN apk add --no-cache wget cmake make git tar gcc g++ musl-dev openssl-dev perl boost-dev
RUN apk add --no-cache build-base
# Install build tools and dependencies
RUN apk add --no-cache \
    build-base \
    wget \
    git \
    && rm -rf /var/cache/apk/*

## Clone tcmalloc repository and build from source
#WORKDIR /tmp
#RUN git clone https://github.com/google/tcmalloc.git \
#    && cd tcmalloc \
#    && ./autogen.sh \
#    && ./configure --enable-minimal \
#    && make \
#    && make install \
#    && cd .. \
#    && rm -rf tcmalloc
#
## Set LD_PRELOAD environment variable
#ENV LD_PRELOAD=/usr/local/lib/libtcmalloc_minimal.so
RUN addgroup -S gsgroup && adduser -S gsuser -G gsgroup

ENV CDRIVER_VERSION ${DRIVER_C_VERSION}
ENV LD_LIBRARY_PATH /usr/local/lib64
ENV DRIVER_VERSION ${DRIVER_VERSION}
ENV HOME /home/gsuser
# Set LD_LIBRARY_PATH environment variable to include the directory where libmongocxx.so is located
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

RUN cd ${HOME} && wget https://github.com/mongodb/mongo-c-driver/releases/download/${CDRIVER_VERSION}/mongo-c-driver-${CDRIVER_VERSION}.tar.gz && \
    tar xzf mongo-c-driver-${CDRIVER_VERSION}.tar.gz

RUN cd ${HOME} && wget https://github.com/mongodb/mongo-cxx-driver/archive/r${DRIVER_VERSION}.tar.gz && \
    tar -xzf r${DRIVER_VERSION}.tar.gz

RUN chown -R gsuser ${HOME} && chmod -R 750 ${HOME}

RUN cd ${HOME}/mongo-c-driver-${CDRIVER_VERSION} && \
    mkdir cmake-build && \
    cd cmake-build && \
    cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_TESTS=OFF .. && \
    make && make install

RUN cd ${HOME}/mongo-cxx-driver-r${DRIVER_VERSION}/build && \
    cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DBUILD_VERSION=0.0.1 -DCMAKE_PREFIX_PATH=/usr/local -DENABLE_TESTS=OFF .. && \
    make EP_mnmlstc_core && \
    make && make install && \
    for i in `ls /usr/local/lib64/pkgconfig | grep cxx-static.pc`; do sed -i -e 's;libdir=${prefix}/lib;libdir=${prefix}/lib64;g' /usr/local/lib64/pkgconfig/$i; done && \
    apk --update --no-cache del perl



# Expose port (if needed)
EXPOSE 8080

# Define default command
CMD ["sh"]

#USER gsuser
#
#ENTRYPOINT ["/bin/sh", "-c"]




## Set the working directory
#WORKDIR /app
#
## Copy the source code of your C++ application into the container
#COPY . /app
#
## Build your C++ application
#RUN mkdir build \
#    && cd build \
#    && cmake .. \
#    && make
#
## Set the entry point for the container
#CMD ["./build/your_cpp_application"]



#FROM gcc:10.5.0
#
## Expose port 8080 (example)
#EXPOSE 8080
#
#RUN apt-get -qq update
#RUN apt-get -qq upgrade
#RUN apt-get -qq install cmake
#
## Install required packages
#RUN apt-get -qq install -y cmake clang clang-format clang-tidy
#
#RUN apt-get install -y libboost-all-dev --no-install-recommends
#RUN apt-get -qq install build-essential libtcmalloc-minimal4 && \
#  ln -s /usr/lib/libtcmalloc_minimal.so.4 /usr/lib/libtcmalloc_minimal.so
#
## Grap mongo driver \
#
#WORKDIR /usr/src
#
#RUN git clone https://github.com/mongodb/mongo-c-driver.git \
#&& cd mongo-c-driver && git checkout 1.10.1 \
#&& mkdir cmake-build && cd cmake-build \
#&& cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF .. \
#&& make && make install && ldconfig /usr/local/lib
#
#RUN git clone https://github.com/mongodb/mongo-cxx-driver.git --branch releases/stable --depth 1 && \
#    cd mongo-cxx-driver/build && \
#    cmake \
#         -DBSONCXX_POLY_USE_MNMLSTC=1 \
#         -DCMAKE_BUILD_TYPE=Release \
#         -DCMAKE_INSTALL_PREFIX=/usr/local \
#         -DLIBMONGOC_DIR=/usr/lib/x86_64-linux-gnu \
#         -DLIBBSON_DIR=/usr/lib/x86_64-linux-gnu \
#         -DCMAKE_MODULE_PATH=/usr/src/mongo-cxx-driver/cmake .. && \
#    make EP_mnmlstc_core && \
#    make && \
#    make install
