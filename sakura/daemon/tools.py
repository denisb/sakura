from gevent.socket import create_connection
import sakura.daemon.conf as conf

def connect_to_hub():
    sock = create_connection((conf.hub_host, conf.hub_port))
    sock_file = sock.makefile(mode='rwb')
    return sock, sock_file

def get_daemon_id(sock_file):
    sock_file.write(b'GETID\n')
    sock_file.flush()
    return int(sock_file.readline().strip())

def set_daemon_id(sock_file, daemon_id):
    sock_file.write(b'SETID\n')
    sock_file.write(("%d\n" % daemon_id).encode("ascii"))
    sock_file.flush()
