FROM gcc:10.5.0

# Expose port 8080 (example)
EXPOSE 8080

RUN apt-get -qq update
RUN apt-get -qq upgrade
RUN apt-get -qq install cmake

# Install required packages
RUN apt-get -qq install -y cmake clang clang-format clang-tidy

RUN apt-get install -y libboost-all-dev --no-install-recommends
RUN apt-get -qq install build-essential libtcmalloc-minimal4 && \
  ln -s /usr/lib/libtcmalloc_minimal.so.4 /usr/lib/libtcmalloc_minimal.so