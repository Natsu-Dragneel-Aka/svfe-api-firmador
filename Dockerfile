FROM openjdk:8-jdk-alpine
WORKDIR /app
VOLUME /tmp

# Copy the built JAR
COPY target/svfe-api-firmador-0.1.1.jar app.jar

# Extract dependencies for layered build
RUN mkdir -p target/dependency && (cd target/dependency; jar -xf /app/app.jar)

# Copy extracted layers
COPY target/dependency/BOOT-INF/lib /app/lib
COPY target/dependency/META-INF /app/META-INF
COPY target/dependency/BOOT-INF/classes /app

# Default uploads dir
RUN mkdir -p /uploads && chmod 777 /uploads

EXPOSE 8113
ENTRYPOINT ["java","-cp","app:app/lib/*","sv.mh.fe.Application"]
