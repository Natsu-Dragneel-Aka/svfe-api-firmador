FROM openjdk:8-jdk-alpine
WORKDIR /app

# Create uploads dir
RUN mkdir -p /app/uploads

# Copy dependencies
ARG DEPENDENCY=target/dependency
COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app

# ✅ Copy certificate into uploads folder
COPY uploads/06231505241014.crt /app/uploads/06231505241014.crt

# Environment variables
ENV SVFE_ARCHIVO=/app/uploads/06231505241014.crt
ENV SVFE_PASSWORD="SS3S2O26@Clave!"

ENTRYPOINT ["java","-cp","app:app/lib/*","sv.mh.fe.Application"]
