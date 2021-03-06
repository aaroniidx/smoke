# cython: profile=False

from smoke.io.stream cimport generic as io_strm_gnrc
from smoke.model.dt cimport prop as mdl_dt_prp
from smoke.replay.decoder.recv_prop cimport abstract


cdef class Decoder(abstract.Decoder):
    def __init__(Decoder self, mdl_dt_prp.Prop prop):
        abstract.Decoder.__init__(self, prop)

    cpdef str decode(Decoder self, io_strm_gnrc.Stream stream):
        cdef int bytelength = stream.read_numeric_bits(9)
        return str(stream.read_string(bytelength))
