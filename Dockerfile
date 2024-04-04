# Stage 1: Build Stage
FROM openjdk:11-jdk-slim AS build
WORKDIR /app

# Copy Gradle build files
COPY build.gradle.kts gradle.properties settings.gradle.kts gradlew ./
COPY gradle ./gradle

# Download and cache Gradle dependencies
RUN ./gradlew --no-daemon dependencies

# Copy the application source code
COPY src ./src

# Build the application with Gradle properties
ARG logback_version
RUN ./gradlew --no-daemon assemble

# Stage 2: Runtime Stage
FROM openjdk:11-jre-slim
WORKDIR /app

# Copy the built JAR file from the build stage
COPY --from=build /app/build/libs/*.jar ./app.jar

# Expose port 8080
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]
