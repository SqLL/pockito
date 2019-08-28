FROM centos:7

ARG LDAP_OPENLDAP_GID
ARG LDAP_OPENLDAP_UID

ARG PQCHECKER_VERSION=2.0.0
ARG PQCHECKER_MD5=c005ce596e97d13e39485e711dcbc7e1

# Add openldap user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# If explicit uid or gid is given, use it.
RUN if [ -z "${LDAP_OPENLDAP_GID}" ]; then groupadd -r openldap; else groupadd -r -g ${LDAP_OPENLDAP_GID} openldap; fi \
    && if [ -z "${LDAP_OPENLDAP_UID}" ]; then useradd -r -g openldap openldap; else useradd -r -g openldap -u ${LDAP_OPENLDAP_UID} openldap; fi


# Install OpenLDAP, ldap-utils and ssl-tools from the (backported) baseimage and clean apt-get files
# sources: https://github.com/osixia/docker-light-baseimage/blob/stable/image/tool/add-service-available
#          https://github.com/osixia/docker-light-baseimage/blob/stable/image/service-available/:ssl-tools/download.sh
RUN yum update \
    && LC_ALL=C yum install -y \
    ca-certificates \
    curl \
    openssl \
    slapd \
    krb5-kdc-ldap 
    # ldap-utils \
    # libsasl2-modules \
    # libsasl2-modules-db \
    # libsasl2-modules-gssapi-mit \
    # libsasl2-modules-ldap \
    # libsasl2-modules-otp \
    # libsasl2-modules-sql \ 