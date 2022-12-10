FROM fuzzers/libfuzzer:12.0 as builder

RUN apt-get update && apt-get install -y wget cmake clang

ADD . /sonic-cpp
WORKDIR /sonic-cpp
RUN cmake -S . -B build -DBUILD_FUZZ=ON -DCMAKE_CXX_COMPILER=clang++ .
RUN cmake --build ./build --target fuzz 

FROM fuzzers/libfuzzer:12.0 
COPY --from=builder /sonic-cpp/build/fuzz/fuzz /

ENTRYPOINT []
CMD ["/fuzz"]
