FROM freebsd:12.2

# comment
RUN pkg install apache24-2.4.46
RUN sysrc apache24_enable=yes

COPYALL
COPY somefile /usr/home/me/

ENV testing=whoknew

