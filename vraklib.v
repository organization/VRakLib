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
                
                /*ping.p.buffer.position = u32(1)

                println('s')
                mut i := 0
                bytes := ping.p.buffer.get_bytes(8)
                for i < 8 {
                    println(int(bytes[i]).hex())
                    i++
                }
                println('e')*/

                println('ping')
                println(ping.ping_id)
                println(ping.client_id)
                //println(ping.p.ip)
                //println(ping.p.port)

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

                //println('pong')
                //println(pong.ping_id)
                //println(pong.p.ip)
                //println(pong.p.port)

                r.socket.send(pong, pong.p)
            } else if pid == ConnectionRequest1 {
                // Request1
            } else if pid == ConnectionRequest2 {
                // Request2
            } else {
                // custom receive packet
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