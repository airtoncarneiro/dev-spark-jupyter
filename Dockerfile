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
ENV SPARK_RPC_AUTHENTICATION_ENABLED=no
ENV SPARK_RPC_ENCRYPTION_ENABLED=no
ENV SPARK_LOCAL_STORAGE_ENCRYPTION_ENABLED=no
ENV SPARK_SSL_ENABLED=no
ENV SPARK_USER=spark
ENV PYSPARK_PYTHON=$VIRTUAL_ENV/bin/python
ENV PYSPARK_DRIVER_PYTHON=$PYSPARK_PYTHON

# Downloading Spark Measure JAR
ARG JARS_USER_DIR=$USER_HOME/jars
ARG SPARK_MEASURE_URL="https://repo1.maven.org/maven2/ch/cern/sparkmeasure/spark-measure_2.12/0.24/spark-measure_2.12-0.24.jar"
RUN mkdir -p ${JARS_USER_DIR} \
&& curl -o ${JARS_USER_DIR}/$(basename ${SPARK_MEASURE_URL}) ${SPARK_MEASURE_URL}

# Set up Python virtual environment
RUN python -m venv venv

# Activate virtual environment and install packages
RUN . venv/bin/activate && pip install --no-cache-dir jupyter pyspark findspark sparkmeasure
