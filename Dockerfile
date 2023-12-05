# python3.8 lambda base image
FROM public.ecr.aws/lambda/python:3.8

# Install CMake
RUN yum -y install cmake

# Copy requirements.txt to container
COPY requirements.txt ./

# Install required build tools
RUN yum -y groupinstall "Development Tools"

# Installing dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy function code to container
COPY app.py ./

# Handling librosa error
RUN mkdir -m 777 /tmp/NUMBA_CACHE_DIR /tmp/MPLCONFIGDIR
ENV NUMBA_CACHE_DIR=/tmp/NUMBA_CACHE_DIR/
ENV MPLCONFIGDIR=/tmp/MPLCONFIGDIR/

# Handling sndfile not found error
RUN yum -y update && \
    yum -y install libsndfile && \
    yum clean all

# Set the CMD to your handler file_name.function_name
CMD [ "app.handler" ]
