# Base image for both stages
FROM python:3.12-slim AS base

# Install common dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    openjdk-17-jre-headless \
    procps \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# First stage: Jupyter Notebook
FROM base AS jupyter-notebook

# Install Jupyter, PySpark, and FindSpark
RUN pip install --no-cache-dir jupyter pyspark findspark

# Expose the necessary port for Jupyter
EXPOSE 8888

# Set the working directory
WORKDIR /notebooks

# Command to run Jupyter Lab
CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]

# Second stage: Spark
FROM base AS spark

# Download and install Spark
ENV SPARK_VERSION=3.5.1
ENV HADOOP_VERSION=3
RUN curl -O https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && tar -xzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /opt \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Set environment variables for Spark
ENV SPARK_HOME=/opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV PATH=$SPARK_HOME/bin:$PATH

# Expose necessary ports for Spark
EXPOSE 8080 7077 4040
