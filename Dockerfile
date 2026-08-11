# ==========================================
# STAGE 1 : Build de l'application (Builder)
# ==========================================
FROM maven:3.9-eclipse-temurin-17 AS builder
WORKDIR /app

# Optimisation du cache Docker : on copie d'abord uniquement le pom.xml
COPY pom.xml .
# On télécharge les dépendances (si le pom.xml ne change pas, Docker mettra cette étape en cache)
RUN mvn dependency:go-offline

# On copie ensuite le code source et on build
COPY src ./src
RUN mvn clean package -DskipTests

# ==========================================
# STAGE 2 : Image finale d'exécution (Runtime)
# ==========================================
FROM tomcat:10.1-jdk17-temurin
LABEL maintainer="Younes - DevSecOps Platform"

# Sécurité : on supprime les applications par défaut de Tomcat pour réduire la surface d'attaque
RUN rm -rf /usr/local/tomcat/webapps/*

# On récupère UNIQUEMENT le WAR compilé depuis le Stage 1 (builder)
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]