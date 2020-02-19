FROM python:3.8-alpine

LABEL "com.github.actions.name"="Cloudfront Invalidate"
LABEL "com.github.actions.description"="Invalidate a path for an AWS Cloudfront distribution"
LABEL "com.github.actions.icon"="cloud-off"
LABEL "com.github.actions.color"="green"

LABEL version="0.1.0"
LABEL repository="https://github.com/rewindio/github-action-cloudfront-invalidate"
LABEL homepage="https://www.rewind.io/"
LABEL maintainer="Dave North <dave.north@rewind.io>"

# https://github.com/aws/aws-cli/blob/master/CHANGELOG.rst
ENV AWSCLI_VERSION='1.18.2'

RUN pip install --quiet --no-cache-dir awscli==${AWSCLI_VERSION}

ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
