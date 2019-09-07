module vraklib

interface Packeter {

}

struct Packet {
pub:
    byte_buffer ByteBuffer

mut:
    ip string
    port int
}

fn new_packet(buffer byteptr, size u32) Packet {
    bytebuffer := new_bytebuffer(buffer, size)

    return Packet{
        byte_buffer: bytebuffer
        ip: ''
        port: 0
    }
}