# cython: profile=False

from libc.stdint cimport int32_t, uint64_t
from smoke.io.stream cimport generic as io_strm_gnrc
from smoke.model.dt cimport prop as mdl_dt_prp
from smoke.replay.decoder.recv_prop cimport abstract


cdef class Decoder(abstract.Decoder):
    def __init__(Decoder self, mdl_dt_prp.Prop prop):
        abstract.Decoder.__init__(self, prop)
        self.bits = prop.bits
        self.eat = bool(prop.flags & mdl_dt_prp.ENCODEDAGAINSTTICKCOUNT)
        self.unsign = bool(prop.flags & mdl_dt_prp.UNSIGNED)

    cpdef int32_t decode(Decoder self, io_strm_gnrc.Stream stream):
        cdef uint64_t v, s

        if self.eat:
            v = stream.read_varint()

            if self.unsign:
                return v # as is -- why?

            return (-(v & mdl_dt_prp.UNSIGNED)) ^ (v >> mdl_dt_prp.UNSIGNED)

        v = <uint64_t>stream.read_numeric_bits(self.bits)
        s = (0x80000000 >> (32 - self.bits)) & (self.unsign - mdl_dt_prp.UNSIGNED)

        return (v ^ s) - s
