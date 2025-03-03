# Use the official MySQL image from the Docker Hub
FROM mysql:latest

# Set environment variables for MySQL
ENV MYSQL_ROOT_PASSWORD=rootpassword
ENV MYSQL_DATABASE=mydatabase
ENV MYSQL_USER=myuser
ENV MYSQL_PASSWORD=mypassword

# # Copy your custom MySQL configuration to disable --secure-file-priv
COPY my.cnf /etc/mysql/my.cnf

EXPOSE 3306
