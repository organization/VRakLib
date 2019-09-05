module vraklib

#include <sys/socket.h>
#include <arpa/inet.h>
// #include <netinet/in.h>
// #include <unistd.h>
// #include <netdb.h>

import net

const (
    WSA_V1  = 0x100 // C.MAKEWORD(1, 0)
    WSA_V11 = 0x101 // C.MAKEWORD(1, 1)
    WSA_V2  = 0x200 // C.MAKEWORD(2, 0)
    WSA_V21 = 0x201 // C.MAKEWORD(2, 1)
    WSA_V22 = 0x202 // C.MAKEWORD(2, 2)
)

struct C.in_addr {
mut:
	s_addr int
}

struct C.sockaddr_in {
mut:
	sin_family int
	sin_port int
	sin_addr C.in_addr
}

struct C.addrinfo {
mut:
	ai_family int
	ai_socktype int
	ai_flags int
	ai_protocol int
	ai_addrlen int
	ai_next voidptr
	ai_addr voidptr
}

const (
    Default_Buffer_Size = 2097152 // 1024 * 1024 * 2
)

struct UdpSocket {
mut:
    sock int
}

pub fn create_socket(port int) ?UdpSocket {
    $if windows {
        mut wsadata := C.WSAData{}
        res := C.WSAStartup(WSA_V22, &wsadata)
        if res != 0 {
            return error('Socket WSAStartup failed')
        }
    }

    sock := C.socket(C.AF_INET, C.SOCK_DGRAM, C.IPPROTO_UDP)
    if sock == 0 {
        return error('Socket init failed')
    }

    mut addr := C.sockaddr_in{}
    addr.sin_family = C.AF_INET
    addr.sin_port = C.htons(port)
    addr.sin_addr.s_addr = C.htonl(C.INADDR_ANY)
    size := 16

    if int(C.bind(sock, &addr, size)) == -1 {
        return error('Socket bind failed')
    }

    // level, optname, optvalue
    bufsize := Default_Buffer_Size
    C.setsockopt(sock, C.SOL_SOCKET, C.SO_RCVBUF, &bufsize, C.sizeof(bufsize))

    zero := 0
    C.setsockopt(sock, C.SOL_SOCKET, C.SO_REUSEADDR, &zero, C.sizeof(zero))

    return UdpSocket{ sock: sock }
}

fn (s UdpSocket) receive() ?Packet {
    mut addr := C.sockaddr_in{}

    bufsize := Default_Buffer_Size
	bytes := [Default_Buffer_Size]byte

    size := 16
    res := C.recvfrom(s.sock, bytes, bufsize, 0, &addr, 16)
    if res == -1 { return error('Could not receive the packet.') }

    sie := C.INET_ADDRSTRLEN
    ip := [sie]byte
    C.inet_ntop(C.AF_INET, &addr.sin_addr, ip, C.INET_ADDRSTRLEN)
    return Packet{
        buffer: bytes
    }
}

fn (s UdpSocket) send(packet Packet) {
    
}

fn (s UdpSocket) close() {
    $if windows {
        C.closesocket(s.sock)
        C.WSACleanup()
    }
    $else {
        C.close(s.sock)
    }
}