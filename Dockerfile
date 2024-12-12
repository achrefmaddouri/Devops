# Use OpenJDK 17 as the base image
FROM openjdk:17-jdk-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the JAR file from the target directory
COPY target/eventsProject-1.0.0.jar app.jar

# Expose port 8080 (or the port your Spring Boot application uses)
EXPOSE 8080

# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
