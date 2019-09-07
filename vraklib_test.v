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
    bytebuffer.put_float(-15896.1567)
    bytebuffer.put_double(0.123)

    println(bytebuffer.get_length())
    println(bytebuffer.get_position())

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
}