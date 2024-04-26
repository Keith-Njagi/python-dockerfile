# Compile image from python's official slim image
FROM python:3.9-slim-buster as compile-image

# Create and activate virtual environment
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt .

# Install the dependencies
RUN pip install -U pip setuptools wheel 
RUN pip install -r requirements.txt

# Build image from python's official slim image
FROM python:3.9-slim-buster as build-image

# # Install Git
# RUN apt-get update; apt-get install -y git; git config --global credential.helper store 

# Copy artifacts from the compile-image stage
COPY --from=compile-image /opt/venv /opt/venv

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
ADD . /app

# Activate virtual environment
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

EXPOSE 8000

# Start our server
CMD [ "python", "./main.py" ]
