FROM parrotsec/security:latest

LABEL maintainer = "steinily (henczistvan87@gmail.com)"


RUN apt-get update\ 
    && apt-get install git xfce4 faenza-icon-theme bash python3 tigervnc-standalone-server xfce4-terminal firefox-esr -y \
    && adduser parrotos -shell /bin/bash -System -disabled-password && echo -e "admin\nadmin" | passwd parrotos  \
    && echo 'parrotos ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && git clone https://github.com/novnc/noVNC /opt/noVNC \
    && git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify 

USER parrotos

WORKDIR /home/parrotos

RUN mkdir -p /home/parrotos/.vnc \
    && echo -e '#!/bin/bash\nstartxfce4 & ' > /home/parrotos/.vnc/xstartup \
    && echo -e 'parrotos\nparrotos\nn\n' | vncpasswd 

CMD ["/bin/bash", "/usr/bin/vncserver :99" , "/opt/noVNC/utils/novnc_proxy --vnc 127.0.0.1:5999"]