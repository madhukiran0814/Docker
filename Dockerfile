FROM ubuntu:18.04
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN mkdir /opt/mopac

RUN chmod 777 /opt/mopac

RUN cp ./MOPAC2016.exe /opt/mopac

RUN cp ./libiomp5.so /opt/mopac

RUN chmod +x /opt/mopac/MOPAC2016.exe

RUN alias mopac='/opt/mopac/MOPAC2016.exe'

RUN export LD_LIBRARY_PATH=/opt/mopac:$LD_LIBRARY_PATH

RUN apt-get update

RUN apt-get install -y wget && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-x86_64.sh -b \
    && rm -f Miniconda3-latest-Linux-x86_64.sh 


RUN conda --version

RUN conda init bash

RUN conda create -n ligtmap -c rmg python=2.7

SHELL ["conda", "run", "-n", "ligtmap", "/bin/bash", "-c"]

RUN conda install rdkit -c rdkit

RUN conda install -c conda-forge openbabel

RUN export python=/root/miniconda3/envs/ligtmap/bin/python

RUN tar xfz pychem-1.0.tar.gz

RUN mv pychem-1.0 /opt

WORKDIR /opt/pychem-1.0

RUN python setup.py install

RUN python -m pip install pybel

RUN conda install -c conda-forge scikit-learn=0.19.2

RUN conda install -c conda-forge pandas=0.23.4 

RUN python -m pip install oddt

WORKDIR /usr/src/app

RUN tar xfz boost_1_59_0.tar.gz

RUN mv boost_1_59_0 /opt

WORKDIR /opt/boost_1_59_0

RUN ./bootstrap.sh --prefix=/opt/boostNew

RUN ./b2 -j 4

RUN ./b2 install

RUN export LD_LIBRARY_PATH=/opt/boost-new/lib:$LD_LIBRARY_PATH

RUN tar xfz psovina-2.0.tar.gz

RUN mv psovina-2.0 /opt

WORKDIR /opt/psovina-2.0/build/linux/release

RUN rm -f Makefile

WORKDIR /usr/src/app

RUN cp ./Makefile /opt/psovina-2.0/build/linux/release

RUN make

RUN mkdir /opt/psovina

RUN cp psovina /opt/psovina

RUN cp psovina_split /opt/psovina

RUN export PATH=/opt/psovina:$PATH

RUN tar xfz mgltools_x86_64Linux2_1.5.6.tar.gz

RUN mv mgltools_x86_64Linux2_1.5.6 /opt

WORKDIR /opt/mgltools_x86_64Linux2_1.5.6

RUN ./install.sh

WORKDIR /usr/src/app

RUN git clone https://github.com/ShirleyWISiu/LigTMap.git

RUN mv LigTMap /opt

RUN export LIGTMAP=/opt/LigTMap

RUN export MGLTools=/opt/mgltools_x86_64Linux2_1.5.6

WORKDIR /opt/LigTMap/test_case

CMD ['$LIGTMAP','predict']






