# Use an official OpenJDK runtime as a parent image
FROM openjdk:17-jdk-slim

# Set environment variables to avoid interactive apt installations
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory in the container
WORKDIR /app

# Copy the compiled jar file from the target directory to the container
COPY target/Osasea-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the application port (change to match your application port)
EXPOSE 8081

# Add a health check to periodically check if the app is running (optional)
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s CMD curl --fail http://localhost:8081/ || exit 1

# Run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]