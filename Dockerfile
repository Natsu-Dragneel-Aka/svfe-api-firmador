# ---- Build stage ----
FROM maven:3.8.5-openjdk-8 AS build
WORKDIR /app

# Copy pom.xml and download dependencies (cached layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source and build
COPY src ./src
RUN mvn clean package -DskipTests

# ---- Runtime stage ----
FROM eclipse-temurin:8-jre-alpine
WORKDIR /app

# Create uploads directory
RUN mkdir -p /app/uploads

# Copy JAR from build stage
COPY --from=build /app/target/*.jar /app/app.jar

# Copy your certificate into the image
COPY uploads/06231505241014.crt /app/uploads/06231505241014.crt

# Environment variables for your app
ENV SVFE_ARCHIVO=/app/uploads/06231505241014.crt
ENV SVFE_PASSWORD="SS3S2O26@Clave!"

# Expose the app port
EXPOSE 8113

# Start your Spring Boot app
ENTRYPOINT ["java","-jar","/app/app.jar"]
