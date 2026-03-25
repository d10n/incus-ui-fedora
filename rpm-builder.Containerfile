FROM registry.fedoraproject.org/fedora:latest

RUN dnf install -y \
        @buildsys-build \
        rpm-build \
        rpmdevtools \
        rpmlint \
        systemd-rpm-macros \
        gcc \
        gcc-c++ \
        make \
        automake \
        autoconf \
    && dnf clean all \
    && rm -rf /var/cache/dnf

RUN mkdir -p /rpmbuild/{SOURCES,SPECS,BUILD,RPMS,SRPMS,OUTPUT}

# Run as non-root since rpmbuild refuses to run as root by default
RUN useradd -m builder \
    && chown -R builder:builder /rpmbuild
USER builder

# rpmbuild --define '_topdir /rpmbuild' --define '_rpmdir /rpmbuild/OUTPUT'
RUN echo '%_topdir /rpmbuild' >~/.rpmmacros \
 && echo '%_rpmdir /rpmbuild/OUTPUT' >>~/.rpmmacros

WORKDIR /rpmbuild
