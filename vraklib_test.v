import vraklib

fn test_bytebuffer() {
    buffer := [1024]byte

    mut bytebuffer := vraklib.new_bytebuffer(buffer, u32(1024))
    
    bytebuffer.put_string('abcdefg')
    bytebuffer.put_string('MinecraftPacketStringTestLongTextIsPossible? Space Space ')
    bytebuffer.put_ushort(u16(153))
    bytebuffer.put_short(i16(12345))
    bytebuffer.put_int(123456789)
    bytebuffer.put_long(i64(123456789123456789))
    //bytebuffer.put_string('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
    bytebuffer.put_float(f32(3214.1567))
    bytebuffer.put_double(f64(3214567585955.1234))

    println(bytebuffer.length)
    println(bytebuffer.position)

    bytebuffer.set_position(u32(0))

    println(bytebuffer.get_string())
    println(bytebuffer.get_string())
    println(bytebuffer.get_ushort())
    println(bytebuffer.get_short())
    println(bytebuffer.get_int())
    println(bytebuffer.get_long())
    //println(bytebuffer.get_string())
    println(bytebuffer.get_float())
    println(bytebuffer.get_double())

    //bytebuffer.print()
}

fn test_bytes() {
    /*ushort := u16(65535)

    mut bytes := []byte

    bytes << byte(ushort & u16(0xFF))
    bytes << byte((ushort >> u16(8)) & int(0xFF))
    println('${bytes[0]} ${bytes[1]}')

    mut res := u16(0)
    res = u16((res << u16(8)) + int(bytes[1]))
    res = u16((res << u16(8)) + int(bytes[0]))
    println(res)*/

    /*mut bytes := []byte
    float := f32(168234.68)

    asdf := &int(&float)
    bytes << byte(u32(*asdf) & u32(0xFF))
    bytes << byte((u32(*asdf) >> u32(8)) & 0xFF)
    bytes << byte((u32(*asdf) >> u32(16)) & 0xFF)
    bytes << byte((u32(*asdf) >> u32(24)) & 0xFF)
    println('${bytes[0]} ${bytes[1]} ${bytes[2]} ${bytes[3]}')

    /
    v = f32((v << f32(8)) + int(b.buffer[b.position + u32(3)]))
    v = f32((v << f32(8)) + int(b.buffer[b.position + u32(2)]))
    v = f32((v << f32(8)) + int(b.buffer[b.position + u32(1)]))
    v = f32((v << f32(8)) + int(b.buffer[b.position]))
    /

    mut test := u32(0)
    test = u32((test << u32(8)) + int(bytes[3]))
    test = u32((test << u32(8)) + int(bytes[2]))
    test = u32((test << u32(8)) + int(bytes[1]))
    test = u32((test << u32(8)) + int(bytes[0]))

    t := &f32(&test)
    println(*t)*/

    mut bytes := []byte
    double := f64(1684.4565464568)

    asdf := &int(&double)
    bytes << byte(u32(*asdf) & u32(0xFF))
    bytes << byte((u32(*asdf) >> u32(8)) & 0xFF)
    bytes << byte((u32(*asdf) >> u32(16)) & 0xFF)
    bytes << byte((u32(*asdf) >> u32(24)) & 0xFF)
    bytes << byte((u32(*asdf) >> u32(32)) & 0xFF)
    bytes << byte((u32(*asdf) >> u32(40)) & 0xFF)
    bytes << byte((u32(*asdf) >> u32(48)) & 0xFF)
    bytes << byte((u32(*asdf) >> u32(56)) & 0xFF)
    println('${bytes[0]} ${bytes[1]} ${bytes[2]} ${bytes[3]} ${bytes[4]} ${bytes[5]} ${bytes[6]} ${bytes[7]}')
}

struct Test {
    asdf string
}

fn (t Test) some() string {
    return t.asdf
}

interface Tester {
    some() string
}

/*fn tester_return() Tester {
    return Test{ asdf: 'asdf' }
}*/

fn tester_some(tester Tester) string {
    return tester.some()
}

fn test_interface() {
    tester := Test{ asdf: 'asdf' }
    println(tester.some())
}