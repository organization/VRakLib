module vraklib

struct VRakLib {
mut:
    socket UdpSocket

    ip string
    port u16

    running bool
}

pub fn (r mut VRakLib) start() {
    assert !r.running

    r.running = true

    socket := create_socket(r.ip, int(r.port)) or { panic(err) }
    r.socket = socket

    rr := *r
    go rr.run()
}

fn (r VRakLib) run() {
    for {
        if r.running {
            packet := r.socket.receive() or { continue }
            pid := packet.buffer.buffer[0]

            if pid == UnConnectedPong || pid == UnConnectedPong2 {
                mut ping := UnConnectedPingPacket {
                    p: Packet { // Is this the best?
                        buffer: new_bytebuffer(packet.buffer.buffer, packet.buffer.length)
                        ip: packet.ip
                        port: packet.port
                    }
                }
                ping.decode()

                mut pong := UnConnectedPongPacket {
                    p: Packet {
                        buffer: new_bytebuffer([ byte(0) ; 35+40].data, u32(35 + 40))
                    }
                    server_id: 123456789
                    ping_id: i64(ping.ping_id)
                    str: 'MCPE;Minecraft V Server!;34;0.12.2;0;100'
                }
                pong.encode()

                pong.p.ip = ping.p.ip
                pong.p.port = ping.p.port

                r.socket.send(pong, pong.p)
            } else if pid == ConnectionRequest1 {
                // Request1
            } else if pid == ConnectionRequest2 {
                // Request2
            } else {
                // custom receive packet
            }
            println(packet.buffer.length)
        }
    }
}

pub fn (r VRakLib) send_packet(packet DataPacketHandler, p Packet) {
    r.socket.send(packet, p)
}

pub fn (r mut VRakLib) stop() {
    assert r.running

    r.running = false
}