FROM swift:focal

RUN apt update && apt install -y libgoogle-perftools-dev

WORKDIR /work/SampleApp

COPY Package.*  /work/
COPY SampleApp/Package.* /work/SampleApp/
RUN swift package resolve

COPY Sources /work/Sources
COPY SampleApp/Sources /work/SampleApp/Sources
RUN swift build -c release

EXPOSE 8080
CMD [".build/release/Run", "serve", "--hostname", "0.0.0.0"]
