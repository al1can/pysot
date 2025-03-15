FROM nvidia/cuda:12.3.2-cudnn9-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/root/miniconda3/bin:$PATH"

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    ca-certificates \
    git \
    python3 \
    python3-pip \
    libglib2.0-0 \
    libgl1 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxcb1 \
    libqt5gui5 \
    libqt5widgets5 \
    && rm -rf /var/lib/apt/lists/*

# Download and install Miniconda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh \
    && chmod +x /tmp/miniconda.sh \
    && /tmp/miniconda.sh -b -p /root/miniconda3 \
    && rm /tmp/miniconda.sh \
    && conda clean -afy

# Set conda default environment
RUN conda init

# Default shell
SHELL ["/bin/bash", "-c"]

# Set working directory for PySOT
WORKDIR /pysot

# Copy local PySOT repository into the container
COPY . /pysot

RUN bash install.sh /root/miniconda3 pysot

# Set entrypoint
CMD ["bash"]
