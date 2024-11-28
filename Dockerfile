# Use an Ubuntu base image
FROM ubuntu:20.04

# Set environment variables for non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
    openjdk-8-jdk \
    ssh \
    rsync \
    wget \
    vim \
    net-tools \
    iputils-ping \
    python3 \
    python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Install Hadoop
RUN wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.6/hadoop-3.3.6.tar.gz && \
    tar -xzvf hadoop-3.3.6.tar.gz -C /usr/local/ && \
    mv /usr/local/hadoop-3.3.6 /usr/local/hadoop && \
    rm hadoop-3.3.6.tar.gz
ENV HADOOP_HOME=/usr/local/hadoop
ENV PATH=$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$PATH

# Install Hive
RUN wget https://dlcdn.apache.org/hive/hive-4.0.1/apache-hive-4.0.1-bin.tar.gz && \
    tar -xzvf apache-hive-4.0.1-bin.tar.gz -C /usr/local/ && \
    mv /usr/local/apache-hive-4.0.1-bin /usr/local/hive && \
    rm apache-hive-4.0.1-bin.tar.gz
ENV HIVE_HOME=/usr/local/hive
ENV PATH=$HIVE_HOME/bin:$PATH

# Configure SSH for Hadoop
RUN ssh-keygen -t rsa -f ~/.ssh/id_rsa -P "" && \
    cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
    chmod 600 ~/.ssh/authorized_keys

# Copy Hadoop and Hive configuration files
COPY config/hadoop/* $HADOOP_HOME/etc/hadoop/
COPY config/hive/* $HIVE_HOME/conf/

# Start SSH and default to bash
CMD service ssh start && bash
