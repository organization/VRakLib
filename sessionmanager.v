module vraklib

/* Need to change to V style
interface SessionManager {
    add_session(ip string, port u16, client_id i64, mtu i16)
    remove_session(ip string, port u16)
    get_session(ip string, port u16) Session

    get_type() string
    get_name() string
    get_protocol() int
    get_game_version() string
    get_active_players() u32
    get_max_player() u32
}

interface PacketHandler {
    handle_data_packet(packet Packet)
    send_packet(packet Packet)
}

enum QueuePriority {
    immediate, update
}

struct Session {
    client_id u64

    mtu_size u16

    normal_queue CustomPacket
    update_queue CustomPacket

pub:
    ip string
    port u16
}

fn (s Session) update() {
    if s.update_queue.packets.len != 0 {

    }
}

fn (s Session) receive_packet(packet Packet) {
    packet_id := packet.buffer.buffer[0]
    if packet_id == 0xC0 { // ACK

    } else if packet_id == 0xA0 { // NACK

    } else if packet_id >= 0x80 && packet_id <= 0x8F { // Custom

    } else {
        s.handle_data_packet(packet)
    }
}

fn (s Session) handle_data_packet(packet Packet) {}

fn (s Session) add_to_queue(packet DataPacketHandler, priority QueuePriority) {

}

fn (s Session) send_packet() {}
*/