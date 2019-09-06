module vraklib

enum Endianness {
    little big
}

struct ByteBuffer {
mut:
    endianness Endianness
    buffer []byte
    length u32
    position u32
}

pub fn new_bytebuffer(buffer []byte, size u32) ByteBuffer {
    return ByteBuffer{
        endianness: Endianness.big
        buffer: buffer
        length: size
        position: u32(0)
    }
}

pub fn (b mut ByteBuffer) put_byte(v byte) {
    b.buffer[b.position] = v
    b.position++
}

pub fn (b mut ByteBuffer) put_bytes(bytes []byte, size int) {
    if size > 0 {
        for v in bytes {
            b.buffer[b.position] = v
            b.position++
        }
    }
}

pub fn (b mut ByteBuffer) put_char(c i8) {
    b.buffer[b.position] = byte(c)
    b.position++
}

pub fn (b mut ByteBuffer) put_bool(v bool) {
    b.buffer[b.position] = if v { 0x01 } else { 0x00 }
}

pub fn (b mut ByteBuffer) put_short(v i16) {
    
}

pub fn (b mut ByteBuffer) put_ushort(v u16) {
    b.buffer[b.position] = byte(v & u16(0xFF))
    b.buffer[b.position + u32(1)] = byte((v >> u16(8)) & int(0xFF))
    b.position += u32(sizeof(u16))
}

pub fn (b ByteBuffer) put_int(v int) {
    
}

pub fn (b ByteBuffer) put_uint(v u32) {
    
}

pub fn (b ByteBuffer) put_long(v i64) {
    
}

pub fn (b ByteBuffer) put_ulong(v u64) {
    
}

pub fn (b mut ByteBuffer) put_float(v f32) {
    
}

pub fn (b mut ByteBuffer) put_double(v f64) {

}

pub fn (b mut ByteBuffer) put_string(v string) {
    b.put_ushort(u16(v.len))
    if v.len != 0 {
        for c in v.bytes() {
            b.buffer[b.position] = c
            b.position++
        }
    }
}

pub fn (b mut ByteBuffer) get_byte() byte {
    v := b.buffer[b.position]
    b.position++
    return v
}

pub fn (b mut ByteBuffer) get_char() i8 {
    v := i8(b.buffer[b.position])
    b.position++
    return v
}

pub fn (b ByteBuffer) get_bool() bool {
    return false
}

pub fn (b ByteBuffer) get_short() i16 {
    return i16(0)
}

pub fn (b mut ByteBuffer) get_ushort() u16 {
    mut v := u16(0)
    v = u16((v << u16(8)) + int(b.buffer[b.position + u32(1)]))
    v = u16((v << u16(8)) + int(b.buffer[b.position]))
    b.position += u32(sizeof(u16))
    return v
}

pub fn (b ByteBuffer) get_int() int {
    return 0
}

pub fn (b ByteBuffer) get_uint() u32 {
    return u32(0)
}

pub fn (b ByteBuffer) get_long() i64 {
    return i64(0)
}

pub fn (b ByteBuffer) get_ulong() u64 {
    return u64(0)
}

pub fn (b ByteBuffer) get_float() f32 {
    return 0
}

pub fn (b ByteBuffer) get_double() f64 {
    return 0
}

pub fn (b ByteBuffer) get_string() string {
    return ''
}

pub fn (b mut ByteBuffer) set_position(newPosition u32) {
    b.position = newPosition
}

pub fn (b ByteBuffer) get_position() u32 {
    return b.position
}

pub fn (b mut ByteBuffer) set_endianness(newEndianness Endianness) {
    b.endianness = newEndianness
}

pub fn (b ByteBuffer) get_endianness() Endianness {
    return b.endianness
}

pub fn (b ByteBuffer) get_buffer() []byte {
    return b.buffer
}

pub fn (b ByteBuffer) get_length() u32 {
    return b.length
}