FROM bitnami/kubectl:1.23 as kubectl

FROM ubuntu:20.04

COPY --from=kubectl /opt/bitnami/kubectl/bin/kubectl /usr/local/bin/

###AWS CLI
RUN apt update -y && apt install curl -y  && apt install zip -y && apt install wget -y
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && unzip awscliv2.zip &&  ./aws/install

## Terraform
RUN wget https://releases.hashicorp.com/terraform/1.7.4/terraform_1.7.4_linux_amd64.zip && unzip terraform_1.7.4_linux_amd64.zip && mv terraform /usr/local/bin/ && terraform --version 

###eksctl
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
RUN mv /tmp/eksctl /usr/local/bin
RUN eksctl version

###nginx
RUN apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring
RUN curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
RUN gpg --dry-run --quiet --no-keyring --import --import-options import-show /usr/share/keyrings/nginx-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/debian `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list
# RUN apt update -y
RUN apt install nginx -y && apt install git -y
CMD ["nginx", "-g", "daemon off;"]