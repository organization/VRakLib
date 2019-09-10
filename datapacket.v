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

    ping_id i64
    client_id u64
}

struct Request1Packet {
mut:
    p Packet

    version byte
    mtu_size i16
}

struct Reply1Packet {
mut:
    p Packet

    security bool
    server_id i64
    mtu_size i16
}

struct Request2Packet {
mut:
    p Packet

    security bool
    cookie int
    rport u16
    mtu_size i16
    client_id u64
}

struct Reply2Packet {
mut:
    p Packet

    server_id i64
    rport u16
    mtu_size i16
    security bool
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
    u.p.buffer.get_byte() // Packet ID
    u.ping_id = u.p.buffer.get_long()
    u.p.buffer.get_bytes(RaknetMagicLength)
    u.client_id = u.p.buffer.get_ulong()
}

// Request1
fn (r mut Request1Packet) encode() {}

fn (r mut Request1Packet) decode() {
    r.p.buffer.get_byte() // Packet ID
    r.p.buffer.get_bytes(RaknetMagicLength)
    r.version = r.p.buffer.get_byte()
    r.mtu_size = i16(r.p.buffer.length - r.p.buffer.position)
}

// Reply1
fn (r mut Reply1Packet) encode() {
    r.p.buffer.put_byte(ConnectionReply1)
    r.p.buffer.put_bytes(get_packet_magic().data, RaknetMagicLength)
    r.p.buffer.put_long(r.server_id)
    r.p.buffer.put_bool(r.security)
    r.p.buffer.put_short(r.mtu_size)
}

fn (r Reply1Packet) decode () {}

// Request2
fn (r mut Request2Packet) encode() {}

fn (r mut Request2Packet) decode() {
    r.p.buffer.get_byte() // Packet ID
    r.security = r.p.buffer.get_bool()
    r.cookie = r.p.buffer.get_int()
    r.rport = r.p.buffer.get_ushort()
    r.mtu_size = r.p.buffer.get_short()
    r.client_id = r.p.buffer.get_ulong()
}

// Reply2
fn (r mut Reply2Packet) encode() {
    r.p.buffer.put_byte(ConnectionReply2)
    r.p.buffer.put_bytes(get_packet_magic().data, RaknetMagicLength)
    r.p.buffer.put_long(r.server_id)
    r.p.buffer.put_ushort(r.rport)
    r.p.buffer.put_short(r.mtu_size)
    r.p.buffer.put_bool(r.security)
}

fn (r Reply2Packet) decode () {}