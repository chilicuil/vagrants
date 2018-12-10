About
-----

HA based in keepalived (floating/virtual IP), haproxy (load balancing) and
nginx (web service).

Usage
-----

    $ vagrant up #or VAGRANT_VAGRANTFILE=Vagrantfile.minimal vagrant up

Go to http://10.10.10.10 (floating ip) to see the site or to
http://10.10.10.10/haproxy?stats to see the proxy status, it works like this:

 * `site.example.com       => 10.10.10.10`

 * `haproxy-01.example.com => 10.10.10.11`
 * `haproxy-02.example.com => 10.10.10.12`
 * `haproxy-03.example.com => 10.10.10.13`

 * `nginx-01.example.com   => 10.10.10.14`
 * `nginx-02.example.com   => 10.10.10.15`
 * `nginx-03.example.com   => 10.10.10.16`

```
                       +---------------------------+         +-------------+
                       |    Keepalive / HAProxy    |_________|    Nginx    |  ____
                       |     - - - - / 10.10.10.12 |    |    | 10.10.10.14 |      |
                       +---------------------------+    |    +-------------+      |  R
                                                        |                         |  O
                                                        |                         |  U
    +----------+       +---------------------------+___/ \___+-------------+      |  N
    |  Client  |_______|    Keepalive / HAProxy    |_________|    Nginx    |  ____|  D
    |  x.x.x.x |       | 10.10.10.10 / 10.10.10.11 |___   ___| 10.10.10.15 |      |
    +----------+       +---------------------------+   \ /   +-------------+      |  R
                                                        |                         |  O
                                                        |                         |  B
                                                        |                         |  I
                       +---------------------------+    |    +-------------+      |  N
                       |    Keepalive / HAProxy    |____|____|    Nginx    |  ____|
                       |    - - - -  / 10.10.10.13 |         | 10.10.10.16 |
                       +---------------------------+         +-------------+
```

Additional information
----------------------

Use `ip addr | grep 10.10.10.10` on haproxy sites to find out the current node
attached to the floating ip:

    $ for node in 01 02 03; do
        vagrant ssh haproxy-$node.example.com -c "ip addr | grep 10.10.10.10 && echo haproxy-$node has it!"
      done

Use `curl 10.10.10.10` to test the current infraestructure while destroying
nodes:

    $ while :; do curl 10.10.10.10; echo ------; sleep 1; done
        <html><head><title>nginx-01.example.com</title></head>
        <body><h1>nginx-01.example.com</h1></body></html>
        ------
        <html><head><title>nginx-02.example.com</title></head>
        <body><h1>nginx-02.example.com</h1></body></html>
        ------
        <html><head><title>nginx-03.example.com</title></head>
        <body><h1>nginx-03.example.com</h1></body></html>
        ------

Pro tip: use `socat` to redirect LAN traffic to your private floating ip:

    $ sudo socat TCP4-LISTEN:www,reuseaddr,fork TCP4:10.10.10.10:80

Now your LAN clients would be able to connect through http://your-host-machine-ip
