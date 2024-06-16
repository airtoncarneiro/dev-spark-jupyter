FROM python:3.12-slim AS base

# Install common dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    openjdk-17-jre-headless \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
# Download and install Spark
ENV SPARK_VERSION=3.5.1
ENV HADOOP_VERSION=3
RUN curl -O https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
&& tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /opt \
&& rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Load build arguments as environment variables
ARG USER_NAME
ARG USER_HOME

# Create user
RUN useradd -m -s /bin/bash ${USER_NAME}

# Switch to the created user
USER ${USER_NAME}
WORKDIR ${USER_HOME}

# Set environment variables for Spark
ENV SPARK_HOME=/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV PATH=$SPARK_HOME/bin:$USER_HOME/venv/bin:$PATH

# Ensure the virtual environment is used in future sessions
ENV VIRTUAL_ENV=$USER_HOME/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# Set up Python virtual environment
RUN python -m venv venv

# Activate virtual environment and install packages
RUN . venv/bin/activate && pip install --no-cache-dir jupyter pyspark findspark


