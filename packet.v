module vraklib

const (
    RaknetMagicLength = 16
)

const (
    Unreliable = 0x00
    UnreliableSequenced = 0x01
    Reliable = 0x02
    ReliableOrdered = 0x03
    ReliableSequenced = 0x04
    UnreliableWithAckReceipt = 0x05
    ReliableWithAckReceipt = 0x06
    ReliableOrderedWithAckReceipt = 0x07
)

struct Packet {
mut:
    buffer ByteBuffer

    ip string
    port int
}

struct CustomPacket {
mut:
    p Packet

    packet_id byte
    sequence_number u32
    packets []InternalPacket
}

struct InternalPacket {
mut:
    buff byteptr
    length u16
    reliability byte
    has_split bool
    message_index int
    order_index int
    order_channel byte
    split_count int
    split_id u16
    split_index int
}

fn (p InternalPacket) to_binary() Packet {
    mut packet := Packet{ buffer: new_bytebuffer([byte(0) ; int(p.get_length())].data, p.get_length()) }

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

    packet.buffer.put_bytes(p.buff, int(p.length))
    return packet
}

fn (p InternalPacket) get_length() u32 {
    return u32(u16(3) + p.length + u16(if p.message_index != -1 { 3 } else { 0 })
     + u16(if p.order_index != -1 { 4 } else { 0 })
     + u16(if p.has_split { 10 } else { 0 }))
}

fn (c CustomPacket) get_total_length() u32 {
    mut total_length := u32(4)
    for packet in c.packets {
        total_length += packet.get_length()
    }
    return total_length
}

fn (c mut CustomPacket) decode() {
    c.packet_id = c.p.buffer.get_byte()
    c.sequence_number = u32(c.p.buffer.get_triad())
    c.packets = internal_packet_from_binary(c.p)
}

fn (c mut CustomPacket) encode() {
    c.p.buffer.length = c.get_total_length()

    buffer := [byte(0) ; int(c.get_total_length())]
    c.p.buffer.buffer = buffer.data

    c.p.buffer.put_byte(c.packet_id)
    c.p.buffer.put_ltriad(int(c.sequence_number))
    for internal_packet in c.packets {
        packet := internal_packet.to_binary()
        c.p.buffer.put_bytes(packet.buffer.buffer, int(packet.buffer.length))
    }
}

fn internal_packet_from_binary(p Packet) []InternalPacket {
    mut packets := []InternalPacket
    mut packet := p
    for packet.buffer.position < packet.buffer.length {
        mut internal_packet := InternalPacket{}
        flags := packet.buffer.get_byte()
        internal_packet.reliability = (flags & 0xE0) >> 5
        internal_packet.has_split = (flags & 0x10) > 0

        s := packet.buffer.get_ushort()
        internal_packet.length = u16((s + u16(7)) >> u16(3))

        if internal_packet.reliability == Reliable ||
            internal_packet.reliability == ReliableOrdered ||
            internal_packet.reliability == ReliableSequenced ||
            internal_packet.reliability == ReliableWithAckReceipt ||
            internal_packet.reliability == ReliableOrderedWithAckReceipt {
                internal_packet.message_index = packet.buffer.get_ltriad()
        }

        if internal_packet.reliability == UnreliableSequenced ||
            internal_packet.reliability == ReliableOrdered ||
            internal_packet.reliability == ReliableSequenced ||
            internal_packet.reliability == ReliableOrderedWithAckReceipt {
                internal_packet.order_index = packet.buffer.get_ltriad()
                internal_packet.order_channel = packet.buffer.get_byte()
        }

        if internal_packet.has_split {
            internal_packet.split_count == packet.buffer.get_int()
            internal_packet.split_id == u16(packet.buffer.get_short())
            internal_packet.split_index == packet.buffer.get_int()
        }

        internal_packet.buff = packet.buffer.get_byte()
        packets << internal_packet
    }
    return packets
}

fn get_packet_magic() []byte {
    return [ byte(0x00), 0xff, 0xff, 0x00, 0xfe, 0xfe, 0xfe, 0xfe, 0xfd, 0xfd, 0xfd, 0xfd, 0x12, 0x34, 0x56, 0x78 ]
}