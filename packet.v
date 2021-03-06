module vraklib

import math

const (
    RaknetMagicLength = 16
)

const (
    BitflagValid = 0x80
    BitflagAck = 0x40
    BitflagNak = 0x20

    BitflagPacketPair = 0x10
    BitflagContinuousSend = 0x08
    BitflagNeedsBAndAs = 0x04
)

struct Packet {
mut:
    buffer ByteBuffer

    ip string
    port int
}

fn new_packet_from_packet(packet Packet) Packet {
    return Packet {
        buffer: new_bytebuffer(packet.buffer.buffer, packet.buffer.length)
        ip: packet.ip
        port: packet.port
    }
}

fn new_packet(buffer byteptr, length u32) Packet {
    return Packet {
        buffer: new_bytebuffer(buffer, length)
    }
}

fn new_packet_from_bytebuffer(buffer ByteBuffer) Packet {
    return Packet {
        buffer: buffer
    }
}

fn get_packet_magic() []byte {
    return [ byte(0x00), 0xff, 0xff, 0x00, 0xfe, 0xfe, 0xfe, 0xfe, 0xfd, 0xfd, 0xfd, 0xfd, 0x12, 0x34, 0x56, 0x78 ]
}

struct EncapsulatedPacket {
mut:
    buffer byteptr
    length u16
    reliability byte
    has_split bool
    message_index int
    sequence_index int
    order_index int
    order_channel byte
    split_count int
    split_id u16
    split_index int
    need_ack bool
    identifier_ack int
}

struct Datagram {
mut:
    p Packet

    packet_id byte
    sequence_number u32
    packets []EncapsulatedPacket
}

fn encapsulated_packet_from_binary(p Packet) []EncapsulatedPacket {
    mut packets := []EncapsulatedPacket
    mut packet := p
    for packet.buffer.position < packet.buffer.length {
        mut internal_packet := EncapsulatedPacket{}
        flags := packet.buffer.get_byte()
        internal_packet.reliability = (flags & 0xE0) >> 5
        internal_packet.has_split = (flags & 0x10) > 0

        length := math.ceil(f32(packet.buffer.get_ushort()) / f32(8))

        if internal_packet.reliability > Unreliable {
            if reliability_is_reliable(internal_packet.reliability) {
                internal_packet.message_index = packet.buffer.get_ltriad()
            }
            if reliability_is_sequenced(internal_packet.reliability) {
                internal_packet.sequence_index = packet.buffer.get_ltriad()
            }
            if reliability_is_sequenced_or_ordered(internal_packet.reliability) {
                internal_packet.order_index = packet.buffer.get_ltriad()
                internal_packet.order_channel = packet.buffer.get_byte()
            }
        }
        if internal_packet.has_split {
            internal_packet.split_count == packet.buffer.get_int()
            internal_packet.split_id == u16(packet.buffer.get_short())
            internal_packet.split_index == packet.buffer.get_int()
        }
        internal_packet.buffer = packet.buffer.get_bytes(int(length))
        packets << internal_packet
    }
    return packets
}

fn (p EncapsulatedPacket) to_binary() Packet {
    mut packet := Packet{ buffer: new_bytebuffer([byte(0)].repeat(int(p.get_length())).data, p.get_length()) }
    packet.buffer.put_byte(byte(p.reliability << 5 | (if p.has_split { 0x01 } else { 0x00 })))
    packet.buffer.put_ushort(u16(p.length << u16(3)))

    if p.reliability == Reliable ||
        p.reliability == ReliableOrdered ||
        p.reliability == ReliableSequenced ||
        p.reliability == ReliableWithAckReceipt ||
        p.reliability == ReliableOrderedWithAckReceipt {
            packet.buffer.put_ltriad(p.message_index)
    }

    if p.reliability == UnreliableSequenced ||
        p.reliability == ReliableOrdered ||
        p.reliability == ReliableSequenced ||
        p.reliability == ReliableOrderedWithAckReceipt {
        packet.buffer.put_ltriad(p.order_index)
        packet.buffer.put_byte(p.order_channel)
    }

    if p.has_split {
        packet.buffer.put_int(p.split_count)
        packet.buffer.put_short(i16(p.split_id))
        packet.buffer.put_int(p.split_index)
    }

    packet.buffer.put_bytes(p.buffer, int(p.length))
    return packet
}

fn (e EncapsulatedPacket) get_length() u32 {
    return u32(u16(3) + e.length + u16(if e.message_index != -1 { 3 } else { 0 })
     + u16(if e.order_index != -1 { 4 } else { 0 })
     + u16(if e.has_split { 10 } else { 0 }))
}

fn (c Datagram) get_total_length() u32 {
    mut total_length := u32(4)
    for packet in c.packets {
        total_length += packet.get_length()
    }
    return total_length
}

fn (c mut Datagram) decode() {
    c.packet_id = c.p.buffer.get_byte()
    c.sequence_number = u32(c.p.buffer.get_ltriad())
    c.packets = encapsulated_packet_from_binary(c.p)
}

fn (c mut Datagram) encode() {
    c.p.buffer.length = c.get_total_length()
    c.p.buffer.buffer = [byte(0)].repeat(int(c.get_total_length())).data

    c.p.buffer.put_byte(byte(BitflagValid) | c.packet_id)
    c.p.buffer.put_ltriad(int(c.sequence_number))
    for internal_packet in c.packets {
        packet := internal_packet.to_binary()
        c.p.buffer.put_bytes(packet.buffer.buffer, int(packet.buffer.length))
    }
}