# D1 claims API training environment.
#
# Base image is unchanged from the reference compose file. Everything this
# image adds is under /opt/d1: the shipped classes, the CPF merge file that
# creates the D1DEV namespace, and the first-start setup code.
#
# No IRIS commands run at build time. The namespace is created by the CPF
# merge (before the superserver opens) and the classes are loaded by the
# -a hook (after IRIS is live) -- see docker-compose.yml.
FROM containers.intersystems.com/intersystems/irishealth-community:latest-preview

USER root

COPY src /opt/d1/src
COPY setup /opt/d1/setup
COPY merge.cpf /opt/d1/merge.cpf

# irisowner is uid 51773 in every IRIS image.
RUN chmod +x /opt/d1/setup/after-start.sh \
 && chown -R 51773:51773 /opt/d1

USER 51773
