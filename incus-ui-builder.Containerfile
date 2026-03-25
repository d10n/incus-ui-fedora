FROM localhost/rpm-builder
USER root
RUN dnf install -y \
        git \
        nodejs \
        npm \
        yarnpkg \
    && dnf clean all \
    && rm -rf /var/cache/dnf
USER builder
WORKDIR /rpmbuild
