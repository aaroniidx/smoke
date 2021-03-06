from smoke.io.stream cimport generic as io_strm_gnrc
from smoke.replay.decoder.recv_prop cimport abstract


cdef class Decoder(abstract.Decoder):
    cdef:
        public object decoder
        int bits

    cpdef list decode(Decoder self, io_strm_gnrc.Stream stream)
