# Stage 1: Build with Maven
FROM maven:3.9.9-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Deploy to Tomcat
FROM tomcat:9.0-jdk17
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Optional health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD curl --fail http://localhost:8080/ || exit 1