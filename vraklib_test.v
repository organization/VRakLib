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
    bytebuffer.put_ulong(u64(12345678912345789123))
    //bytebuffer.put_string('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa')
    bytebuffer.put_float(f32(3214.1567))
    bytebuffer.put_double(f64(3214567585955.1234))

    //println(bytebuffer.length)
    //println(bytebuffer.position)

    bytebuffer.position = u32(0)

    println(bytebuffer.get_string())
    println(bytebuffer.get_string())
    println(bytebuffer.get_ushort())
    println(bytebuffer.get_short())
    println(bytebuffer.get_int())
    println(bytebuffer.get_long())
    println(bytebuffer.get_ulong())
    //println(bytebuffer.get_string())
    println(bytebuffer.get_float())
    println(bytebuffer.get_double())

    //bytebuffer.print()

    mut v32 := u32(1)
    print_bit32(v32)

    v32 = vraklib.swap32(v32)
    print_bit32(v32)

    mut v64 := u64(487234123123213)
    print_bit64(v64)

    v64 = vraklib.swap64(v64)
    print_bit64(v64)
}

fn print_bit32(v u32) {
    b1 := byte(v)
    b2 := byte(v >> u32(8))
    b3 := byte(v >> u32(16))
    b4 := byte(v >> u32(24))
    println('${b1} ${b2} ${b3} ${b4}')
}

fn print_bit64(v u64) {
    b1 := byte(v)
    b2 := byte(v >> u64(8))
    b3 := byte(v >> u64(16))
    b4 := byte(v >> u64(24))
    b5 := byte(v >> u64(32))
    b6 := byte(v >> u64(40))
    b7 := byte(v >> u64(48))
    b8 := byte(v >> u64(56))
    println('${b1} ${b2} ${b3} ${b4} ${b5} ${b6} ${b7} ${b8}')
}