FROM openjdk:17-jdk-slim

# Add the jar from build directory
ADD target/demo-workshop-2.1.4.jar demo-workshop.jar

# Run the jar
ENTRYPOINT ["java", "-jar", "demo-workshop.jar"]
