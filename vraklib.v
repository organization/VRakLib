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

    go r.run()
}

fn (r mut VRakLib) run() {
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

                title := 'MCPE;Minecraft V Server!;361;1.12.0;0;100;123456789;Test;Survival;'
                len := 35 + title.len
                mut pong := UnConnectedPongPacket {
                    p: Packet {
                        buffer: new_bytebuffer([ byte(0) ; len].data, u32(len))
                        ip: ping.p.ip
                        port: ping.p.port
                    }
                    server_id: 123456789
                    ping_id: ping.ping_id
                    str: title
                }
                pong.encode()

                r.socket.send(pong, pong.p)
            } else if pid == ConnectionRequest1 {
                mut request := Request1Packet {
                    p: Packet {
                        buffer: new_bytebuffer(packet.buffer.buffer, packet.buffer.length)
                        ip: packet.ip
                        port: packet.port
                    }
                }
                request.decode()
                
                mut reply := Reply1Packet {
                    p: Packet {
                        buffer: new_bytebuffer([ byte(0) ; 28].data, u32(28))
                        ip: request.p.ip
                        port: request.p.port
                    }
                    security: true
                    server_id: 123456789
                    mtu_size: request.mtu_size
                }
                reply.encode()

                r.socket.send(reply, reply.p)
            } else if pid == ConnectionRequest2 {
                mut request := Request2Packet {
                    p: Packet {
                        buffer: new_bytebuffer(packet.buffer.buffer, packet.buffer.length)
                        ip: packet.ip
                        port: packet.port
                    }
                }
                request.decode()

                mut reply := Reply2Packet {
                    p: Packet {
                        buffer: new_bytebuffer([ byte(0) ; 30].data, u32(30))
                        ip: request.p.ip
                        port: request.p.port
                    }
                    server_id: 123456789
                    rport: request.rport
                    mtu_size: request.mtu_size
                    security: request.security
                }
                reply.encode()

                r.socket.send(reply, reply.p)
            } else {
                // custom receive packet
                println('$pid custom receive packet')
            }
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