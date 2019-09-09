module vraklib

enum Endianness {
    little big
}

struct ByteBuffer {
pub mut:
    endianness Endianness
    buffer byteptr
    length u32
    position u32
}

pub fn new_bytebuffer(buffer byteptr, size u32) ByteBuffer {
    return ByteBuffer{
        endianness: Endianness.big
        buffer: buffer
        length: size
        position: u32(0)
    }
}

pub fn (b mut ByteBuffer) put_byte(v byte) {
    assert b.position + u32(sizeof(byte)) <= b.length
    b.buffer[b.position] = v
    b.position++
}

pub fn (b mut ByteBuffer) put_bytes(bytes byteptr, size int) {
    assert b.position + u32(size) <= b.length
    if size > 0 {
        mut i := 0
        for i < size {
            b.buffer[b.position] = bytes[i]
            b.position++
            i++
        }
    }
}

pub fn (b mut ByteBuffer) put_char(c i8) {
    assert b.position + u32(sizeof(i8)) <= b.length
    b.buffer[b.position] = byte(c)
    b.position++
}

pub fn (b mut ByteBuffer) put_bool(v bool) {
    assert b.position + u32(sizeof(bool)) <= b.length
    b.buffer[b.position] = if v { 0x01 } else { 0x00 }
    b.position++
}

pub fn (b mut ByteBuffer) put_short(v i16) {
    assert b.position + u32(sizeof(i16)) <= b.length
    if b.get_system_endianness() != b.endianness {
        
    }
    b.buffer[b.position + u32(1)] = byte(v)
    b.buffer[b.position         ] = byte(v >> i16(8))
    b.position += u32(sizeof(i16))
}

pub fn (b mut ByteBuffer) put_ushort(v u16) {
    assert b.position + u32(sizeof(u16)) <= b.length
    b.buffer[b.position + u32(1)] = byte(v)
    b.buffer[b.position         ] = byte(v >> u16(8))
    b.position += u32(sizeof(u16))
}

pub fn (b mut ByteBuffer) put_triad(v int) {
    assert b.position + u32(3) <= b.length
    b.buffer[b.position         ] = byte(v)
    b.buffer[b.position + u32(1)] = byte(v >> 8)
    b.buffer[b.position + u32(2)] = byte(v >> 16)
    b.position += u32(3)
}

pub fn (b mut ByteBuffer) put_ltriad(v int) {
    assert b.position + u32(3) <= b.length
    b.buffer[b.position + u32(2)] = byte(v)
    b.buffer[b.position + u32(1)] = byte(v >> 8)
    b.buffer[b.position         ] = byte(v >> 16)
    b.position += u32(3)
}

pub fn (b mut ByteBuffer) put_int(v int) {
    assert b.position + u32(sizeof(int)) <= b.length
    b.buffer[b.position + u32(3)] = byte(v)
    b.buffer[b.position + u32(2)] = byte(v >> int(8))
    b.buffer[b.position + u32(1)] = byte(v >> int(16))
    b.buffer[b.position         ] = byte(v >> int(24))
    b.position += u32(sizeof(int))
}

pub fn (b mut ByteBuffer) put_uint(v u32) {
    assert b.position + u32(sizeof(u32)) <= b.length
    b.buffer[b.position + u32(3)] = byte(v)
    b.buffer[b.position + u32(2)] = byte(v >> u32(8))
    b.buffer[b.position + u32(1)] = byte(v >> u32(16))
    b.buffer[b.position         ] = byte(v >> u32(24))
    b.position += u32(sizeof(u32))
}

pub fn (b mut ByteBuffer) put_long(v i64) {
    assert b.position + u32(sizeof(i64)) <= b.length
    b.buffer[b.position + u32(7)] = byte(v)
    b.buffer[b.position + u32(6)] = byte(v >> i64(8))
    b.buffer[b.position + u32(5)] = byte(v >> i64(16))
    b.buffer[b.position + u32(4)] = byte(v >> i64(24))
    b.buffer[b.position + u32(3)] = byte(v >> i64(32))
    b.buffer[b.position + u32(2)] = byte(v >> i64(40))
    b.buffer[b.position + u32(1)] = byte(v >> i64(48))
    b.buffer[b.position         ] = byte(v >> i64(56))
    b.position += u32(sizeof(i64))
}

pub fn (b mut ByteBuffer) put_ulong(v u64) {
    assert b.position + u32(sizeof(u64)) <= b.length
    b.buffer[b.position + u32(7)] = byte(v)
	b.buffer[b.position + u32(6)] = byte(v >> u64(8))
	b.buffer[b.position + u32(5)] = byte(v >> u64(16))
	b.buffer[b.position + u32(4)] = byte(v >> u64(24))
	b.buffer[b.position + u32(3)] = byte(v >> u64(32))
	b.buffer[b.position + u32(2)] = byte(v >> u64(40))
	b.buffer[b.position + u32(1)] = byte(v >> u64(48))
	b.buffer[b.position         ] = byte(v >> u64(56))
    b.position += u32(sizeof(u64))
}

pub fn (b mut ByteBuffer) put_float(v f32) {
    assert b.position + u32(sizeof(f32)) <= b.length
    as_int := &int(&v)
    b.buffer[b.position + u32(3)] = byte(u32(*as_int))
    b.buffer[b.position + u32(2)] = byte(u32(*as_int) >> u32(8))
    b.buffer[b.position + u32(1)] = byte(u32(*as_int) >> u32(16))
    b.buffer[b.position         ] = byte(u32(*as_int) >> u32(24))
    b.position += u32(sizeof(f32))
}

pub fn (b mut ByteBuffer) put_double(v f64) {
    assert b.position + u32(sizeof(f64)) <= b.length
    as_int := &u64(&v)
    b.buffer[b.position + u32(7)] = byte(u64(*as_int))
    b.buffer[b.position + u32(6)] = byte(u64(*as_int) >> u64(8))
    b.buffer[b.position + u32(5)] = byte(u64(*as_int) >> u64(16))
    b.buffer[b.position + u32(4)] = byte(u64(*as_int) >> u64(24))
    b.buffer[b.position + u32(3)] = byte(u64(*as_int) >> u64(32))
    b.buffer[b.position + u32(2)] = byte(u64(*as_int) >> u64(40))
    b.buffer[b.position + u32(1)] = byte(u64(*as_int) >> u64(48))
    b.buffer[b.position         ] = byte(u64(*as_int) >> u64(56))
    b.position += u32(sizeof(f64))
}

pub fn (b mut ByteBuffer) put_string(v string) {
    b.put_ushort(u16(v.len))
    if v.len != 0 {
        assert b.position + u32(v.len) <= b.length
        for c in v.bytes() {
            b.buffer[b.position] = c
            b.position++
        }
    }
}

pub fn (b mut ByteBuffer) get_bytes(size int) byteptr {
    assert b.position + u32(size) <= b.length

    if size == 0 {
        //return []byte
    }

    mut v := []byte

    mut i := 0
    for i < size {
        v << b.buffer[i]
        i++
    }
    b.position += u32(size)
    return v.data
}

pub fn (b mut ByteBuffer) get_byte() byte {
    assert b.position + u32(sizeof(byte)) <= b.length
    v := b.buffer[b.position]
    b.position++
    return v
}

pub fn (b mut ByteBuffer) get_char() i8 {
    assert b.position + u32(sizeof(i8)) <= b.length
    v := i8(b.buffer[b.position])
    b.position++
    return v
}

pub fn (b mut ByteBuffer) get_bool() bool {
    assert b.position + u32(sizeof(bool)) <= b.length
    v := if b.buffer[b.position] == 0x01 { true } else { false }
    b.position++
    return v
}

pub fn (b mut ByteBuffer) get_short() i16 {
    assert b.position + u32(sizeof(i16)) <= b.length
    v := i16(i16(b.buffer[b.position]) << i16(8)) |
        i16(b.buffer[b.position + u32(1)])
    b.position += u32(sizeof(i16))
    return v
}

pub fn (b mut ByteBuffer) get_ushort() u16 {
    assert b.position + u32(sizeof(u16)) <= b.length
    v := u16(u16(b.buffer[b.position]) << u16(8)) |
        u16(b.buffer[b.position + u32(1)])
    b.position += u32(sizeof(u16))
    return v
}

pub fn (b mut ByteBuffer) get_triad() int {
    assert b.position + u32(3) <= b.length
    v := int(int(b.buffer[b.position]) << int(16)) |
        int(int(b.buffer[b.position + u32(1)]) << int(8)) |
        int(b.buffer[b.position + u32(2)])
    b.position += u32(3)
    return v
}

pub fn (b mut ByteBuffer) get_ltriad() int {
    assert b.position + u32(3) <= b.length
    v := int(int(b.buffer[b.position + u32(2)]) << int(16)) |
        int(int(b.buffer[b.position + u32(1)]) << int(8)) |
        int(b.buffer[b.position])
    b.position += u32(3)
    return v
}

pub fn (b mut ByteBuffer) get_int() int {
    assert b.position + u32(sizeof(int)) <= b.length
    v := int(int(b.buffer[b.position]) << int(24)) |
        int(int(b.buffer[b.position + u32(1)]) << int(16)) |
        int(int(b.buffer[b.position + u32(2)]) << int(8))  |
        int(b.buffer[b.position + u32(3)])
    b.position += u32(sizeof(int))
    return v
}

pub fn (b mut ByteBuffer) get_uint() u32 {
    assert b.position + u32(sizeof(u32)) <= b.length
    v := u32(u32(b.buffer[b.position]) << u32(24)) |
        u32(u32(b.buffer[b.position + u32(1)]) << u32(16)) |
        u32(u32(b.buffer[b.position + u32(2)]) << u32(8))  |
        u32(b.buffer[b.position + u32(3)])
    b.position += u32(sizeof(u32))
    return v
}

pub fn (b mut ByteBuffer) get_long() i64 {
    assert b.position + u32(sizeof(i64)) <= b.length
    v := i64(i64(b.buffer[b.position]) << int(56)) |
        i64(i64(b.buffer[b.position + u32(1)]) << i64(48)) |
        i64(i64(b.buffer[b.position + u32(2)]) << i64(40))  |
        i64(i64(b.buffer[b.position + u32(3)]) << i64(32)) |
        i64(i64(b.buffer[b.position + u32(4)]) << i64(24)) |
        i64(i64(b.buffer[b.position + u32(5)]) << i64(16)) |
        i64(i64(b.buffer[b.position + u32(6)]) << i64(8)) |
        i64(b.buffer[b.position + u32(7)])
    b.position += u32(sizeof(i64))
    return v
}

pub fn (b mut ByteBuffer) get_ulong() u64 {
    assert b.position + u32(sizeof(u64)) <= b.length
    v := u64(u64(b.buffer[b.position]) << u64(56)) |
        u64(u64(b.buffer[b.position + u32(1)]) << u64(48)) |
        u64(u64(b.buffer[b.position + u32(2)]) << u64(40)) |
        u64(u64(b.buffer[b.position + u32(3)]) << u64(32)) |
        u64(u64(b.buffer[b.position + u32(4)]) << u64(24)) |
        u64(u64(b.buffer[b.position + u32(5)]) << u64(16)) |
        u64(u64(b.buffer[b.position + u32(6)]) << u64(8)) |
        u64(b.buffer[b.position + u32(7)])
    b.position += u32(sizeof(u64))
    return v
}

pub fn (b mut ByteBuffer) get_float() f32 {
    assert b.position + u32(sizeof(f32)) <= b.length
    v := u32(u32(b.buffer[b.position]) << u32(24)) |
        u32(u32(b.buffer[b.position + u32(1)]) << u32(16)) |
        u32(u32(b.buffer[b.position + u32(2)]) << u32(8)) |
        u32(b.buffer[b.position + u32(3)])
    ptr := &f32(&v)
    b.position += u32(sizeof(f32))
    return *ptr
}

pub fn (b mut ByteBuffer) get_double() f64 {
    assert b.position + u32(sizeof(f64)) <= b.length
    v := u64(u64(b.buffer[b.position]) << u64(56)) |
        u64(u64(b.buffer[b.position + u32(1)]) << u64(48)) |
        u64(u64(b.buffer[b.position + u32(2)]) << u64(40)) |
        u64(u64(b.buffer[b.position + u32(3)]) << u64(32)) |
        u64(u64(b.buffer[b.position + u32(4)]) << u64(24)) |
        u64(u64(b.buffer[b.position + u32(5)]) << u64(16)) |
        u64(u64(b.buffer[b.position + u32(6)]) << u64(8)) |
        u64(b.buffer[b.position + u32(7)])
    ptr := &f64(&v)
    b.position += u32(sizeof(f64))
    return *ptr
}

pub fn (b mut ByteBuffer) get_string() string {
    size := int(b.get_ushort())

    mut v := []byte
    if size > 0 {
        assert b.position + u32(sizeof(string)) <= b.length
        mut i := 0
        for i < size {
            v << b.buffer[b.position] & 0xFF
            b.position++
            i++
        }
    }
    return tos(v.data, size)
}

pub fn (b ByteBuffer) get_endianness() Endianness {
    return b.endianness
}

pub fn (b ByteBuffer) get_system_endianness() Endianness {
    return Endianness.big //TODO
}

pub fn (b mut ByteBuffer) set_position(newPosition u32) {
    b.position = newPosition
}

pub fn (b mut ByteBuffer) set_endianness(newEndianness Endianness) {
    b.endianness = newEndianness
}

pub fn (b ByteBuffer) print() {
    mut i := 0
    for i < int(b.length) {
        println(b.buffer[i])
        if (i + 1) % 8 == 0 || i == int(b.length) - 1 {
            println('\n')
        }
        i++
    }
}