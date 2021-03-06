# cython: profile=False

from smoke.io.stream cimport generic as io_strm_gnrc
from smoke.model.dt cimport prop as mdl_dt_prp
from smoke.replay.decoder.recv_prop cimport abstract


cdef class Decoder(abstract.Decoder):
    def __init__(Decoder self, mdl_dt_prp.Prop prop, object array_prop_decoder):
        abstract.Decoder.__init__(self, prop)

        shift, bits = prop.len, 0

        # this is really a bitlength count
        while shift:
            shift >>= 1
            bits += 1

        self.bits = bits
        self.decoder = array_prop_decoder

    cpdef list decode(Decoder self, io_strm_gnrc.Stream stream):
        cdef int count = stream.read_numeric_bits(self.bits)
        return [self.decoder.decode(stream) for _ in range(count)]
