# -------- Build Stage --------
FROM maven:3.9.6-eclipse-temurin-8 AS builder
WORKDIR /build

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Package the app (creates target/svfe-api-firmador-0.1.1.jar)
RUN mvn -B -DskipTests clean package

# -------- Runtime Stage --------
FROM openjdk:8-jdk-alpine
WORKDIR /app

# Copy the built JAR from builder
COPY --from=builder /build/target/svfe-api-firmador-0.1.1.jar app.jar

# Default uploads dir
RUN mkdir -p /uploads && chmod 777 /uploads

# Expose API port
EXPOSE 8113

# Run the application
ENTRYPOINT ["java","-jar","/app/app.jar"]
