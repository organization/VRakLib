module vraklib

import net

const (
    Default_Buffer_Size = 2097152 // 1024 * 1024 * 2
)

struct UdpSocket {
mut:
    socket net.Socket
}

pub fn socket(port int) ?UdpSocket {
    sock := net.socket_udp() or { panic(err) }

    res := sock.bind(port) or {
        return error('Failed to bind')
    }

    // level, optname, optvalue
    bufsize := Default_Buffer_Size
    sock.setsockopt(C.SOL_SOCKET, C.SO_RCVBUF, bufsize)

    zero := 0
    sock.setsockopt(C.SOL_SOCKET, C.SO_REUSEADDR, zero)

    return UdpSocket{ socket: sock }
}

fn (s UdpSocket) receive() ?Packet {
    bufsize := Default_Buffer_Size
	bytes := [Default_Buffer_Size]byte

    res := s.socket.crecv(bytes, bufsize) 
    if res < 0 { return error('Error') }

    return Packet{

    }
}

fn (s UdpSocket) send(packet Packet) {
    
}

fn (s UdpSocket) close() {
    s.socket.close()
}