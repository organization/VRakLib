import vraklib

fn test_bytebuffer() {
    buffer := [1024]byte

    mut bytebuffer := vraklib.new_bytebuffer(buffer, u32(1024))
    bytebuffer.put_byte(101)
    bytebuffer.put_string('abcdefg')

    buf := bytebuffer.get_buffer()
    len := int(bytebuffer.get_length())

    for b in buf {
        println(b)
    }
    //println('Buffer: ${ tos(buf, len) }')
    //println(bytebuffer.get_length())
}