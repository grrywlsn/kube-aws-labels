FROM xueshanf/awscli

RUN curl -O https://storage.googleapis.com/kubernetes-release/release/v1.5.2/bin/linux/amd64/kubectl
RUN chmod +x kubectl
RUN mv kubectl /usr/local/bin/kubectl

ADD tagger.sh /tagger.sh
RUN chmod +x /tagger.sh

CMD /tagger.sh
