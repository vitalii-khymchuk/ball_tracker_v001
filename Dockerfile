FROM ros:jazzy-ros-base

# create non root user in the end (to share access to files with default linux user)
ARG USERNAME=orange_build
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid ${USER_UID} --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
    && mkdir /home/${USERNAME}/.config && chown ${USER_GID}:${USER_UID} /home/${USERNAME}/.config


# set up sudo command and other packages installation
RUN apt-get update \
    && apt-get install -y bash-completion python3-argcomplete \ 
    && apt-get install -y sudo \
    && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
    && chmod 0440 /etc/sudoers.d/${USERNAME} \
    && rm -rf /var/lib/apt/lists/*



# source ros2 automatically
COPY bashrc /home/${USERNAME}/.bashrc    
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/bin/bash", "entrypoint.sh" ]
CMD [ "bash" ]