module vraklib

const (
    Ping = 0x00
    Pong = 0x03

    UnConnectedPong = 0x01
    UnConnectedPong2 = 0x02

    UnConnectedPing = 0x1c

    ConnectionRequest1 = 0x05
    ConnectionRequest2 = 0x07

    ConnectionReply1 = 0x06
    ConnectionReply2 = 0x08
)

interface DataPacketHandler {
    encode()
    decode()
}

// Login packets
struct UnConnectedPongPacket {
mut:
    p Packet

    server_id i64
    ping_id i64
    str string
}

struct UnConnectedPingPacket {
mut:
    p Packet

    ping_id u64
}

struct Replay1Packet {
mut:
    p Packet

    security bool
    server_id i64
    mtu_size u16
}

struct Request1Packet {
mut:
    p Packet

    version byte
    mtu_size i16
}

// UnConnectedPong
fn (u mut UnConnectedPongPacket) encode() {
    u.p.buffer.put_byte(UnConnectedPing)
    u.p.buffer.put_long(u.ping_id)
    u.p.buffer.put_long(u.server_id)
    u.p.buffer.put_bytes(get_packet_magic().data, RaknetMagicLength)
    u.p.buffer.put_string(u.str)
}

fn (u UnConnectedPongPacket) decode() {}

// UnConnectedPing
fn (u mut UnConnectedPingPacket) decode() {
    u.p.buffer.position += u32(1) // Packet ID
    u.ping_id = u.p.buffer.get_ulong()
}

// Replay1
fn (r mut Replay1Packet) encode() {
    r.p.buffer.put_byte(ConnectionReply1)
    r.p.buffer.put_bytes(get_packet_magic().data, RaknetMagicLength)
    r.p.buffer.put_long(r.server_id)
    r.p.buffer.put_ushort(r.mtu_size)
}

fn (r Replay1Packet) decode () {}

// Request1
fn (r mut Request1Packet) encode() {}

fn (r mut Request1Packet) decode() {
    r.p.buffer.position += u32(17) // Skip Raknet Magic And Packet ID
    r.version = r.p.buffer.get_byte()
    r.mtu_size = i16(r.p.buffer.length - r.p.buffer.position)
}