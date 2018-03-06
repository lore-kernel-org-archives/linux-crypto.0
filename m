From: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Subject: [RESEND PATCH v3] crypto: add zBeWalgo compression for zram
Date: Tue, 6 Mar 2018 21:23:08 +0100
Message-ID: <A4A8A981-9668-4F3F-B718-8F05B0506074@informatik.uni-hamburg.de>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, minchan@kernel.org, ngupta@vflare.org,
        sergey.senozhatsky.work@gmail.com
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Currently ZRAM uses compression-algorithms from the crypto-api. ZRAM
compresses each page individually. As a result the compression algorithm is
forced to use a very small sliding window. None of the available compression
algorithms is designed to achieve high compression ratios with small inputs.

This patch adds a new compression algorithm 'zBeWalgo' to the crypto api. This
algorithm focusses on increasing the capacity of the compressed block-device
created by ZRAM. The choice of compression algorithms is always a tradeoff
between speed and compression ratio.

If faster algorithms like 'lz4' are chosen the compression ratio is often
lower than the ratio of zBeWalgo as shown in the following benchmarks. Due to
the lower compression ratio, ZRAM needs to fall back to backing_devices
earlier. If backing_devices are required, the effective speed of ZRAM is a
weighted average of de/compression time and writing/reading from the
backing_device. This should be considered when comparing the speeds in the
benchmarks.

There are different kinds of backing_devices, each with its own drawbacks.
1. HDDs: This kind of backing device is very slow. If the compression ratio 
of an algorithm is much lower than the ratio of zBeWalgo, it might be faster
to use zBewalgo instead.
2. SSDs: I tested a swap partition on my NVME-SSD. The speed is even higher
than zram with lz4, but after about 5 Minutes the SSD is blocking all
read/write requests due to overheating. This is definitly not an option.



zBeWalgo is a completely new algorithm - Currently it is not published
somewhere else right now, googleing it would not show up any results. The
following section describes how the algorithm works.

zBeWalgo itself is a container compression algorithm, which can execute
multiple different compression and transformation algorithms after each other.
The execution of different compression algorithms after each other will be
called 'combination' in this description and in the code. Additionally to be
able to execute combinations of algorithms, zBeWalgo can try different
combinations on the same input. This allows high compression ratios on
completely different datasets, which would otherwise require its own
algorithm each. Executing all known combinations on each input page would be
very slow. Therefore the data is compressed at first with that combination,
which was already successful on the last input page. If the compressed data
size of the current page is similar to that of the last page, the compressed
data is returned immediately without even trying the other combinations. Even
if there is no guarantee that consecutive calls to the algorithm belong to
each other, the speed improvement is obvious.

ZRAM uses zsmalloc for the management of the compressed pages. The largest
size-class in zsmalloc is 3264 Bytes. If the compressed data is larger than
that threshold, ZRAM ignores the compression and writes the uncompressed page
instead. As a consequence it is useless to continue compression, if the
algorithm detects, that the data can not be compressed using the current
combination. The threshold for aborting compression can be changed via sysfs at
any time, even if the algorithm is currently in use. If a combination fails to
compress the data, zBeWalgo tries the next combination. If no combination is
able to reduce the data in size, zBeWalgo returns a negative value.

Each combination consists of up to 7 compression and transformation steps.
Combinations can be added and removed at any time via sysfs. Already compressed
Data can always be decompressed, even if the combination used to produce it
does not exist anymore. Technically the user could add up to 256 combinations
concurrently, but that would be very time consuming if the data can not be
compressed.

To be able to build combinations and call different algorithms, all those
algorithms are implementing the same interface. This enables the user to
specify additional combinations while ZRAM is running.

Within the combinations many different algorithms can be used. Some of those
algorithms are published. This patch adds the following algorithms to be used
within the combinations:
- bwt: The Burrows-Wheeler-Transformation was published by 'M. Burrows' and
     'D. J. Wheeler' in 1994. This implementation uses counting sort for
     sorting the data. Their original paper is online available at:
     http://www.hpl.hp.com/techreports/Compaq-DEC/SRC-RR-124.pdf
- mtf: The Move-To-Front algorithm as described by 'M. Burrows' and
     'D. J. Wheeler' in the same paper as bwt.
- jbe: j-bit-encoding as proposed by 'I Made Agus Dwi Suarjaya' in 2012.
     https://arxiv.org/pdf/1209.1045.pdf
- jbe2: A minor modification of jbe. Swapping groups of 4 Bit in consecutive
     Bytes can increase the compression ratio, if for example the first
     4 Bits of each Byte are zero. If jbe2 is called after mtf, this
     happens ofthen.
- rle: Run Length Encoding
- huffman: Huffman encoding
- bewalgo: I invented this algorithm for my bachelors thesis
     'Page-Based compression in the Linux Kernel'. This algorithm is
     mainly inspired by lz4, focusing on increasing the speed even more,
     with the help of page aligned read an write access. To achieve the
     page alignment, the input and output data is accessed only in
     blocks of 8 Bytes, therefore the encoding of the compressed data is
     changed.
     https://wr.informatik.uni-hamburg.de/_media/research:theses:benjamin_warnke_page_based_compression_in_the_linux_kernel.pdf
- bewalgo2: At the beginning of my work to improve ZRAM this was the whole
     algorithm. The input is read in blocks of 8 Bytes. These Blocks
     are added to an avl-tree. The avl-tree is mapped directly to an
     array. The encoding is a variation of Run Length Encoding using the
     indices in the avl-tree as data. The reason for using the tree
     with indices is, that the indices can be encoded in less then
     8 Bytes each.


Benchmarks:


To obtain reproducable benchmarks, the datasets were first loaded into a
userspace-program. Than the data is written directly to a clean
zram-partition without any filesystem. Between writing and reading 'sync'
and 'echo 3 > /proc/sys/vm/drop_caches' is called. All time measurements are
wall clock times, and the benchmarks are using only one cpu-core at a time.
The new algorithm is compared to all available compression algorithms from
the crypto-api.

Zstd is not in the list of compared algorithms, because it is not available
for Zram in the currently available kernel trees.

- '/dev/zero' (8 GiB) This dataset is used to measure the speed limitations
for ZRAM. ZRAM filters zero-data internally and does not even call the
specified compression algorithm.

algorithm | compression    | decompression
--zram--  | 2724.08 MBit/s | 2828.87 MBit/s


- 'ecoham' (100 MiB) This dataset is one of the input files for the scientific
application ECOHAM which runs an ocean simulation. This dataset contains a
lot of zeros. Where the data is not zero there are arrays of floating point
values, adjacent float values are likely to be similar to each other,
allowing for high compression ratios.

algorithm | ratio   | compression    | decompression
zbewalgo  |   12.94 |  294.10 MBit/s | 1242.59 MBit/s
deflate   |   12.54 |   75.51 MBit/s |  736.39 MBit/s
842       |   12.26 |  182.59 MBit/s |  683.61 MBit/s
lz4hc     |   12.00 |   51.23 MBit/s | 1524.73 MBit/s
lz4       |   10.68 | 1334.37 MBit/s | 1603.54 MBit/s
lzo       |    9.79 | 1333.76 MBit/s | 1534.63 MBit/s


- 'source-code' (800 MiB) This dataset is a tarball of the source-code from a
linux-kernel.

algorithm | ratio   | compression    | decompression
deflate   |    3.27 |   42.48 MBit/s |  250.36 MBit/s
lz4hc     |    2.40 |  104.14 MBit/s | 1150.53 MBit/s
lzo       |    2.27 |  444.77 MBit/s |  886.97 MBit/s
lz4       |    2.18 |  453.08 MBit/s | 1101.45 MBit/s
842       |    1.65 |   64.10 MBit/s |  158.40 MBit/s
zbewalgo  |    1.19 |   52.89 MBit/s |  197.58 MBit/s


- 'hpcg' (8 GiB) This dataset is a (partial) memory-snapshot of the
running hpcg-benchmark. At the time of the snapshot, that application
performed a sparse matrix - vector multiplication.

algorithm | ratio   | compression    | decompression
zbewalgo  |   16.16 |  179.97 MBit/s |  468.36 MBit/s
deflate   |    9.52 |   65.11 MBit/s |  632.69 MBit/s
lz4hc     |    4.96 |  193.33 MBit/s | 1607.12 MBit/s
842       |    4.20 |  150.99 MBit/s |  316.22 MBit/s
lzo       |    4.14 |  922.74 MBit/s |  865.32 MBit/s
lz4       |    3.79 |  908.39 MBit/s | 1375.33 MBit/s


- 'partdiff' (8 GiB) Array of double values. Adjacent doubles are similar, but
not equal. This array is produced by a partial differential equation solver
using a Jakobi-implementation.

algorithm | ratio   | compression    | decompression
zbewalgo  |    1.30 |  203.30 MBit/s |  530.87 MBit/s
deflate   |    1.02 |   37.06 MBit/s | 1131.88 MBit/s
lzo       |    1.00 | 1741.46 MBit/s | 2012.78 MBit/s
lz4       |    1.00 | 1458.08 MBit/s | 2013.88 MBit/s
lz4hc     |    1.00 |  173.19 MBit/s | 2012.37 MBit/s
842       |    1.00 |   64.10 MBit/s | 2013.64 MBit/s


Signed-off-by: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>

Changes since v2:

- added linux-kernel Mailinglist

Changes since v1:

- improved documentation
- improved code style
- replaced numerous casts with get_unaligned*
- added tests in crypto/testmgr.h/c
- added zBeWalgo to the list of algorithms shown by 
  /sys/block/zram0/comp_algorithm

---
crypto/Kconfig                |   8 +
crypto/Makefile               |   1 +
crypto/testmgr.c              |  10 +
crypto/testmgr.h              | 134 +++++++++
crypto/zbewalgo.c             | 176 ++++++++++++
drivers/block/zram/zcomp.c    |   3 +
drivers/block/zram/zram_drv.h |   4 +-
include/linux/zbewalgo.h      |  53 ++++
lib/Kconfig                   |   3 +
lib/Makefile                  |   1 +
lib/zbewalgo/BWT.c            | 112 ++++++++
lib/zbewalgo/BWT.h            |  33 +++
lib/zbewalgo/JBE.c            | 195 +++++++++++++
lib/zbewalgo/JBE.h            |  25 ++
lib/zbewalgo/JBE2.c           | 210 ++++++++++++++
lib/zbewalgo/JBE2.h           |  25 ++
lib/zbewalgo/MTF.c            | 100 +++++++
lib/zbewalgo/MTF.h            |  25 ++
lib/zbewalgo/Makefile         |   4 +
lib/zbewalgo/RLE.c            | 128 +++++++++
lib/zbewalgo/RLE.h            |  25 ++
lib/zbewalgo/bewalgo.c        | 381 +++++++++++++++++++++++++
lib/zbewalgo/bewalgo.h        |  25 ++
lib/zbewalgo/bewalgo2.c       | 396 ++++++++++++++++++++++++++
lib/zbewalgo/bewalgo2.h       |  25 ++
lib/zbewalgo/bitshuffle.c     | 104 +++++++
lib/zbewalgo/bitshuffle.h     |  25 ++
lib/zbewalgo/huffman.c        | 244 ++++++++++++++++
lib/zbewalgo/huffman.h        |  25 ++
lib/zbewalgo/include.h        | 103 +++++++
lib/zbewalgo/zbewalgo.c       | 628 ++++++++++++++++++++++++++++++++++++++++++
31 files changed, 3230 insertions(+), 1 deletion(-)
create mode 100644 crypto/zbewalgo.c
create mode 100644 include/linux/zbewalgo.h
create mode 100644 lib/zbewalgo/BWT.c
create mode 100644 lib/zbewalgo/BWT.h
create mode 100644 lib/zbewalgo/JBE.c
create mode 100644 lib/zbewalgo/JBE.h
create mode 100644 lib/zbewalgo/JBE2.c
create mode 100644 lib/zbewalgo/JBE2.h
create mode 100644 lib/zbewalgo/MTF.c
create mode 100644 lib/zbewalgo/MTF.h
create mode 100644 lib/zbewalgo/Makefile
create mode 100644 lib/zbewalgo/RLE.c
create mode 100644 lib/zbewalgo/RLE.h
create mode 100644 lib/zbewalgo/bewalgo.c
create mode 100644 lib/zbewalgo/bewalgo.h
create mode 100644 lib/zbewalgo/bewalgo2.c
create mode 100644 lib/zbewalgo/bewalgo2.h
create mode 100644 lib/zbewalgo/bitshuffle.c
create mode 100644 lib/zbewalgo/bitshuffle.h
create mode 100644 lib/zbewalgo/huffman.c
create mode 100644 lib/zbewalgo/huffman.h
create mode 100644 lib/zbewalgo/include.h
create mode 100644 lib/zbewalgo/zbewalgo.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index b75264b09..f0974566c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1668,6 +1668,14 @@ config CRYPTO_LZ4
	help
	  This is the LZ4 algorithm.

+config CRYPTO_ZBEWALGO
+	tristate "zBeWalgo compression algorithm"
+	select CRYPTO_ALGAPI
+	select CRYPTO_ACOMP2
+	select ZBEWALGO_COMPRESS
+	help
+	  This is the zBeWalgo algorithm.
+
config CRYPTO_LZ4HC
	tristate "LZ4HC compression algorithm"
	select CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
index cdbc03b35..2a42fb289 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -121,6 +121,7 @@ obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_common.o crct10dif_generic.o
obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
obj-$(CONFIG_CRYPTO_LZO) += lzo.o
obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
+obj-$(CONFIG_CRYPTO_ZBEWALGO) += zbewalgo.o
obj-$(CONFIG_CRYPTO_LZ4HC) += lz4hc.o
obj-$(CONFIG_CRYPTO_842) += 842.o
obj-$(CONFIG_CRYPTO_RNG2) += rng.o
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index d5e23a142..294075476 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -3566,6 +3566,16 @@ static const struct alg_test_desc alg_test_descs[] = {
				.dec = __VECS(tf_xts_dec_tv_template)
			}
		}
+	}, {
+		.alg = "zbewalgo",
+		.test = alg_test_comp,
+		.fips_allowed = 1,
+		.suite = {
+			.comp = {
+				.comp = __VECS(zbewalgo_comp_tv_template),
+				.decomp = __VECS(zbewalgo_decomp_tv_template)
+			}
+		}
	}, {
		.alg = "zlib-deflate",
		.test = alg_test_comp,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 6044f6906..996d8321e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -35133,6 +35133,140 @@ static const struct hash_testvec bfin_crc_tv_template[] = {

};

+static const struct comp_testvec zbewalgo_comp_tv_template[] = {
+	{
+		.inlen	= 512,
+		.outlen	= 402,
+		.input	=
+			"\x8a\x3a\xf3\xbe\x33\xf9\xab\x3d\xa1\x51\x9f\x7f\xad\xf6\xab\x3d"
+			"\xad\x29\x8f\x3c\x27\xf4\xab\x3d\x06\x19\xc3\xf5\xa0\xf1\xab\x3d"
+			"\xfb\x75\x3b\xab\x1a\xef\xab\x3d\xe3\x96\xf8\x5c\x94\xec\xab\x3d"
+			"\x13\xd2\xfa\x0a\x0e\xea\xab\x3d\xe0\x7d\x42\xb5\x87\xe7\xab\x3d"
+			"\xa1\xf0\xcf\x5b\x01\xe5\xab\x3d\xad\x80\xa3\xfe\x7a\xe2\xab\x3d"
+			"\x59\x84\xbd\x9d\xf4\xdf\xab\x3d\xff\x51\x1e\x39\x6e\xdd\xab\x3d"
+			"\xf5\x3f\xc6\xd0\xe7\xda\xab\x3d\x96\xa4\xb5\x64\x61\xd8\xab\x3d"
+			"\x3b\xd6\xec\xf4\xda\xd5\xab\x3d\x3b\x2b\x6c\x81\x54\xd3\xab\x3d"
+			"\xf2\xf9\x33\x0a\xce\xd0\xab\x3d\xbb\x98\x44\x8f\x47\xce\xab\x3d"
+			"\xed\x5d\x9e\x10\xc1\xcb\xab\x3d\xe7\x9f\x41\x8e\x3a\xc9\xab\x3d"
+			"\x07\xb5\x2e\x08\xb4\xc6\xab\x3d\xa9\xf3\x65\x7e\x2d\xc4\xab\x3d"
+			"\x28\xb2\xe7\xf0\xa6\xc1\xab\x3d\xe3\x46\xb4\x5f\x20\xbf\xab\x3d"
+			"\x38\x08\xcc\xca\x99\xbc\xab\x3d\x85\x4c\x2f\x32\x13\xba\xab\x3d"
+			"\x2a\x6a\xde\x95\x8c\xb7\xab\x3d\x85\xb7\xd9\xf5\x05\xb5\xab\x3d"
+			"\xf7\x8a\x21\x52\x7f\xb2\xab\x3d\xe2\x3a\xb6\xaa\xf8\xaf\xab\x3d"
+			"\xa5\x1d\x98\xff\x71\xad\xab\x3d\xa3\x89\xc7\x50\xeb\xaa\xab\x3d"
+			"\x3d\xd5\x44\x9e\x64\xa8\xab\x3d\xd6\x56\x10\xe8\xdd\xa5\xab\x3d"
+			"\xce\x64\x2a\x2e\x57\xa3\xab\x3d\x8d\x55\x93\x70\xd0\xa0\xab\x3d"
+			"\x76\x7f\x4b\xaf\x49\x9e\xab\x3d\xeb\x38\x53\xea\xc2\x9b\xab\x3d"
+			"\x53\xd8\xaa\x21\x3c\x99\xab\x3d\x13\xb4\x52\x55\xb5\x96\xab\x3d"
+			"\x92\x22\x4b\x85\x2e\x94\xab\x3d\x35\x7a\x94\xb1\xa7\x91\xab\x3d"
+			"\x65\x11\x2f\xda\x20\x8f\xab\x3d\x86\x3e\x1b\xff\x99\x8c\xab\x3d"
+			"\x02\x58\x59\x20\x13\x8a\xab\x3d\x41\xb4\xe9\x3d\x8c\x87\xab\x3d"
+			"\xaf\xa9\xcc\x57\x05\x85\xab\x3d\xb5\x8e\x02\x6e\x7e\x82\xab\x3d"
+			"\xb9\xb9\x8b\x80\xf7\x7f\xab\x3d\x27\x81\x68\x8f\x70\x7d\xab\x3d"
+			"\x6a\x3b\x99\x9a\xe9\x7a\xab\x3d\xef\x3e\x1e\xa2\x62\x78\xab\x3d"
+			"\x20\xe2\xf7\xa5\xdb\x75\xab\x3d\x6a\x7b\x26\xa6\x54\x73\xab\x3d"
+			"\x3b\x61\xaa\xa2\xcd\x70\xab\x3d\xfe\xe9\x83\x9b\x46\x6e\xab\x3d"
+			"\x22\x6c\xb3\x90\xbf\x6b\xab\x3d\x16\x3e\x39\x82\x38\x69\xab\x3d"
+			"\x48\xb6\x15\x70\xb1\x66\xab\x3d\x26\x2b\x49\x5a\x2a\x64\xab\x3d"
+			"\x23\xf3\xd3\x40\xa3\x61\xab\x3d\xae\x64\xb6\x23\x1c\x5f\xab\x3d"
+			"\x37\xd6\xf0\x02\x95\x5c\xab\x3d\x30\x9e\x83\xde\x0d\x5a\xab\x3d",
+		.output	=
+			"\x02\x02\x07\x02\x07\x00\x00\x00\x0f\x00\x02\x8a\xa1\xad\x06\xfb"
+			"\xe3\x13\xe0\xa1\xad\x59\xff\xf5\x96\x81\x3b\x7f\xf2\xbb\xed\xe7"
+			"\x07\xa9\x28\xe3\x38\x85\x2a\x85\xf7\xe2\xa5\xa3\x3d\xd6\xce\x8d"
+			"\x76\xeb\x53\x13\x92\x35\x65\x86\x02\x41\xaf\xb5\xb9\x27\x6a\xef"
+			"\x20\x6a\x3b\xfe\x22\x16\x48\x26\x23\xae\x37\x30\x3a\x51\x29\x19"
+			"\x75\x96\xd2\x7d\xf0\x80\x84\x51\x3f\xa4\xd6\x2b\xf9\x98\x5d\x9f"
+			"\xb5\xf3\xb2\x46\x08\x4c\x6a\xb7\x8a\x3a\x1d\x89\xd5\x56\x64\x55"
+			"\x7f\x38\xd8\xb4\x22\x7a\x11\x3e\x58\xb4\xa9\x8e\xb9\x81\x3b\x3e"
+			"\xe2\x7b\x61\xe9\x6c\x3e\xb6\x2b\xf3\x64\xd6\x9e\xf3\x9f\x8f\xc3"
+			"\x3b\xf8\xfa\x42\xcf\xa3\xbd\x1e\xc6\xb5\xec\x6c\x7f\x33\x44\x9e"
+			"\x41\x2e\x65\xe7\xb4\xcc\x2f\xde\xd9\x21\xb6\x98\xc7\x44\x10\x2a"
+			"\x93\x4b\x53\xaa\x52\x4b\x94\x2f\x1b\x59\xe9\xcc\x02\x8b\x68\x99"
+			"\x1e\xf7\x26\xaa\x83\xb3\x39\x15\x49\xd3\xb6\xf0\x83\xbe\x7f\x3c"
+			"\xf5\xab\x5c\x0a\xb5\x5b\xfe\x9d\x39\xd0\x64\xf4\x81\x0a\x8f\x10"
+			"\x8e\x08\x7e\xf0\x5f\xca\x32\x95\xf5\x52\xaa\xff\x50\x9e\xe8\x2e"
+			"\x70\xaf\xea\x21\x55\x85\xb1\xda\xff\x20\x3d\x57\x6e\x80\x8f\x9a"
+			"\xa2\xa5\xa6\xa2\x9b\x90\x82\x70\x5a\x40\x23\x02\xde\x33\xad\x27"
+			"\xa0\x1a\x94\x0e\x87\x01\x7a\xf4\x6e\xe7\x61\xda\x54\x6f\xce\x47"
+			"\xc1\x3a\xb4\x2d\xa6\x20\x99\x13\x8c\x05\x7f\xf8\x71\xeb\x64\xdd"
+			"\x57\xd0\x49\xc2\x3c\xb5\x2e\xa7\x20\x99\x13\x8c\x05\x7e\xf7\x70"
+			"\xe9\x62\xdb\x54\xcd\x46\xbf\x38\xb1\x2a\xa3\x1c\x95\x0d\xf9\xf6"
+			"\xf4\xf1\xef\xec\xea\xe7\xe5\xe2\xdf\xdd\xda\xd8\xd5\xd3\xd0\xce"
+			"\xcb\xc9\xc6\xc4\xc1\xbf\xbc\xba\xb7\xb5\xb2\xaf\xad\xaa\xa8\xa5"
+			"\xa3\xa0\x9e\x9b\x99\x96\x94\x91\x8f\x8c\x8a\x87\x85\x82\x7f\x7d"
+			"\x7a\x78\x75\x73\x70\x6e\x6b\x69\x66\x64\x61\x5f\x5c\x5a\xbf\xab"
+			"\xbf\x3d",
+	},
+};
+
+static const struct comp_testvec zbewalgo_decomp_tv_template[] = {
+	{
+		.inlen	= 402,
+		.outlen	= 512,
+		.input	=
+			"\x02\x02\x07\x02\x07\x00\x00\x00\x0f\x00\x02\x8a\xa1\xad\x06\xfb"
+			"\xe3\x13\xe0\xa1\xad\x59\xff\xf5\x96\x81\x3b\x7f\xf2\xbb\xed\xe7"
+			"\x07\xa9\x28\xe3\x38\x85\x2a\x85\xf7\xe2\xa5\xa3\x3d\xd6\xce\x8d"
+			"\x76\xeb\x53\x13\x92\x35\x65\x86\x02\x41\xaf\xb5\xb9\x27\x6a\xef"
+			"\x20\x6a\x3b\xfe\x22\x16\x48\x26\x23\xae\x37\x30\x3a\x51\x29\x19"
+			"\x75\x96\xd2\x7d\xf0\x80\x84\x51\x3f\xa4\xd6\x2b\xf9\x98\x5d\x9f"
+			"\xb5\xf3\xb2\x46\x08\x4c\x6a\xb7\x8a\x3a\x1d\x89\xd5\x56\x64\x55"
+			"\x7f\x38\xd8\xb4\x22\x7a\x11\x3e\x58\xb4\xa9\x8e\xb9\x81\x3b\x3e"
+			"\xe2\x7b\x61\xe9\x6c\x3e\xb6\x2b\xf3\x64\xd6\x9e\xf3\x9f\x8f\xc3"
+			"\x3b\xf8\xfa\x42\xcf\xa3\xbd\x1e\xc6\xb5\xec\x6c\x7f\x33\x44\x9e"
+			"\x41\x2e\x65\xe7\xb4\xcc\x2f\xde\xd9\x21\xb6\x98\xc7\x44\x10\x2a"
+			"\x93\x4b\x53\xaa\x52\x4b\x94\x2f\x1b\x59\xe9\xcc\x02\x8b\x68\x99"
+			"\x1e\xf7\x26\xaa\x83\xb3\x39\x15\x49\xd3\xb6\xf0\x83\xbe\x7f\x3c"
+			"\xf5\xab\x5c\x0a\xb5\x5b\xfe\x9d\x39\xd0\x64\xf4\x81\x0a\x8f\x10"
+			"\x8e\x08\x7e\xf0\x5f\xca\x32\x95\xf5\x52\xaa\xff\x50\x9e\xe8\x2e"
+			"\x70\xaf\xea\x21\x55\x85\xb1\xda\xff\x20\x3d\x57\x6e\x80\x8f\x9a"
+			"\xa2\xa5\xa6\xa2\x9b\x90\x82\x70\x5a\x40\x23\x02\xde\x33\xad\x27"
+			"\xa0\x1a\x94\x0e\x87\x01\x7a\xf4\x6e\xe7\x61\xda\x54\x6f\xce\x47"
+			"\xc1\x3a\xb4\x2d\xa6\x20\x99\x13\x8c\x05\x7f\xf8\x71\xeb\x64\xdd"
+			"\x57\xd0\x49\xc2\x3c\xb5\x2e\xa7\x20\x99\x13\x8c\x05\x7e\xf7\x70"
+			"\xe9\x62\xdb\x54\xcd\x46\xbf\x38\xb1\x2a\xa3\x1c\x95\x0d\xf9\xf6"
+			"\xf4\xf1\xef\xec\xea\xe7\xe5\xe2\xdf\xdd\xda\xd8\xd5\xd3\xd0\xce"
+			"\xcb\xc9\xc6\xc4\xc1\xbf\xbc\xba\xb7\xb5\xb2\xaf\xad\xaa\xa8\xa5"
+			"\xa3\xa0\x9e\x9b\x99\x96\x94\x91\x8f\x8c\x8a\x87\x85\x82\x7f\x7d"
+			"\x7a\x78\x75\x73\x70\x6e\x6b\x69\x66\x64\x61\x5f\x5c\x5a\xbf\xab"
+			"\xbf\x3d",
+		.output	=
+			"\x8a\x3a\xf3\xbe\x33\xf9\xab\x3d\xa1\x51\x9f\x7f\xad\xf6\xab\x3d"
+			"\xad\x29\x8f\x3c\x27\xf4\xab\x3d\x06\x19\xc3\xf5\xa0\xf1\xab\x3d"
+			"\xfb\x75\x3b\xab\x1a\xef\xab\x3d\xe3\x96\xf8\x5c\x94\xec\xab\x3d"
+			"\x13\xd2\xfa\x0a\x0e\xea\xab\x3d\xe0\x7d\x42\xb5\x87\xe7\xab\x3d"
+			"\xa1\xf0\xcf\x5b\x01\xe5\xab\x3d\xad\x80\xa3\xfe\x7a\xe2\xab\x3d"
+			"\x59\x84\xbd\x9d\xf4\xdf\xab\x3d\xff\x51\x1e\x39\x6e\xdd\xab\x3d"
+			"\xf5\x3f\xc6\xd0\xe7\xda\xab\x3d\x96\xa4\xb5\x64\x61\xd8\xab\x3d"
+			"\x3b\xd6\xec\xf4\xda\xd5\xab\x3d\x3b\x2b\x6c\x81\x54\xd3\xab\x3d"
+			"\xf2\xf9\x33\x0a\xce\xd0\xab\x3d\xbb\x98\x44\x8f\x47\xce\xab\x3d"
+			"\xed\x5d\x9e\x10\xc1\xcb\xab\x3d\xe7\x9f\x41\x8e\x3a\xc9\xab\x3d"
+			"\x07\xb5\x2e\x08\xb4\xc6\xab\x3d\xa9\xf3\x65\x7e\x2d\xc4\xab\x3d"
+			"\x28\xb2\xe7\xf0\xa6\xc1\xab\x3d\xe3\x46\xb4\x5f\x20\xbf\xab\x3d"
+			"\x38\x08\xcc\xca\x99\xbc\xab\x3d\x85\x4c\x2f\x32\x13\xba\xab\x3d"
+			"\x2a\x6a\xde\x95\x8c\xb7\xab\x3d\x85\xb7\xd9\xf5\x05\xb5\xab\x3d"
+			"\xf7\x8a\x21\x52\x7f\xb2\xab\x3d\xe2\x3a\xb6\xaa\xf8\xaf\xab\x3d"
+			"\xa5\x1d\x98\xff\x71\xad\xab\x3d\xa3\x89\xc7\x50\xeb\xaa\xab\x3d"
+			"\x3d\xd5\x44\x9e\x64\xa8\xab\x3d\xd6\x56\x10\xe8\xdd\xa5\xab\x3d"
+			"\xce\x64\x2a\x2e\x57\xa3\xab\x3d\x8d\x55\x93\x70\xd0\xa0\xab\x3d"
+			"\x76\x7f\x4b\xaf\x49\x9e\xab\x3d\xeb\x38\x53\xea\xc2\x9b\xab\x3d"
+			"\x53\xd8\xaa\x21\x3c\x99\xab\x3d\x13\xb4\x52\x55\xb5\x96\xab\x3d"
+			"\x92\x22\x4b\x85\x2e\x94\xab\x3d\x35\x7a\x94\xb1\xa7\x91\xab\x3d"
+			"\x65\x11\x2f\xda\x20\x8f\xab\x3d\x86\x3e\x1b\xff\x99\x8c\xab\x3d"
+			"\x02\x58\x59\x20\x13\x8a\xab\x3d\x41\xb4\xe9\x3d\x8c\x87\xab\x3d"
+			"\xaf\xa9\xcc\x57\x05\x85\xab\x3d\xb5\x8e\x02\x6e\x7e\x82\xab\x3d"
+			"\xb9\xb9\x8b\x80\xf7\x7f\xab\x3d\x27\x81\x68\x8f\x70\x7d\xab\x3d"
+			"\x6a\x3b\x99\x9a\xe9\x7a\xab\x3d\xef\x3e\x1e\xa2\x62\x78\xab\x3d"
+			"\x20\xe2\xf7\xa5\xdb\x75\xab\x3d\x6a\x7b\x26\xa6\x54\x73\xab\x3d"
+			"\x3b\x61\xaa\xa2\xcd\x70\xab\x3d\xfe\xe9\x83\x9b\x46\x6e\xab\x3d"
+			"\x22\x6c\xb3\x90\xbf\x6b\xab\x3d\x16\x3e\x39\x82\x38\x69\xab\x3d"
+			"\x48\xb6\x15\x70\xb1\x66\xab\x3d\x26\x2b\x49\x5a\x2a\x64\xab\x3d"
+			"\x23\xf3\xd3\x40\xa3\x61\xab\x3d\xae\x64\xb6\x23\x1c\x5f\xab\x3d"
+			"\x37\xd6\xf0\x02\x95\x5c\xab\x3d\x30\x9e\x83\xde\x0d\x5a\xab\x3d",
+	},
+};
+
static const struct comp_testvec lz4_comp_tv_template[] = {
	{
		.inlen	= 255,
diff --git a/crypto/zbewalgo.c b/crypto/zbewalgo.c
new file mode 100644
index 000000000..ccca3c359
--- /dev/null
+++ b/crypto/zbewalgo.c
@@ -0,0 +1,176 @@
+/*
+ * Cryptographic API.
+ *
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#include <crypto/internal/scompress.h>
+#include <linux/crypto.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/vmalloc.h>
+#include "linux/zbewalgo.h"
+
+struct zbewalgo_ctx {
+	void *zbewalgo_comp_mem;
+};
+
+static void *zbewalgo_alloc_ctx(struct crypto_scomp *tfm)
+{
+	void *ctx;
+
+	ctx = vmalloc(zbewalgo_get_wrkmem_size());
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+	return ctx;
+}
+
+static int zbewalgo_init(struct crypto_tfm *tfm)
+{
+	struct zbewalgo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	ctx->zbewalgo_comp_mem = zbewalgo_alloc_ctx(NULL);
+	if (IS_ERR(ctx->zbewalgo_comp_mem))
+		return -ENOMEM;
+	return 0;
+}
+
+static void zbewalgo_free_ctx(struct crypto_scomp *tfm, void *ctx)
+{
+	vfree(ctx);
+}
+
+static void zbewalgo_exit(struct crypto_tfm *tfm)
+{
+	struct zbewalgo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	zbewalgo_free_ctx(NULL, ctx->zbewalgo_comp_mem);
+}
+
+static int __zbewalgo_compress_crypto(const u8 *src, unsigned int slen,
+				      u8 *dst, unsigned int *dlen, void *ctx)
+{
+	int out_len;
+
+	if (slen > 4096)
+		return -EINVAL;
+	out_len = zbewalgo_compress(src, dst, ctx, slen);
+	if (!out_len)
+		return -EINVAL;
+	*dlen = out_len;
+	return 0;
+}
+
+static int zbewalgo_scompress(struct crypto_scomp *tfm, const u8 *src,
+			      unsigned int slen, u8 *dst, unsigned int *dlen,
+			      void *ctx)
+{
+	return __zbewalgo_compress_crypto(src, slen, dst, dlen, ctx);
+}
+
+static int zbewalgo_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
+				    unsigned int slen, u8 *dst,
+				    unsigned int *dlen)
+{
+	struct zbewalgo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __zbewalgo_compress_crypto(src, slen, dst, dlen,
+		ctx->zbewalgo_comp_mem);
+}
+
+static int __zbewalgo_decompress_crypto(const u8 *src, unsigned int slen,
+					u8 *dst, unsigned int *dlen, void *ctx)
+{
+	int out_len;
+
+	out_len = zbewalgo_decompress(src, dst, ctx, slen);
+	if (out_len < 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int zbewalgo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
+				unsigned int slen, u8 *dst, unsigned int *dlen,
+				void *ctx)
+{
+	return __zbewalgo_decompress_crypto(src, slen, dst, dlen, ctx);
+}
+
+static int zbewalgo_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
+				      unsigned int slen, u8 *dst,
+				      unsigned int *dlen)
+{
+	struct zbewalgo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __zbewalgo_decompress_crypto(src, slen, dst, dlen,
+		ctx->zbewalgo_comp_mem);
+}
+
+static struct crypto_alg crypto_alg_zbewalgo = {
+	.cra_name = "zbewalgo",
+	.cra_flags = CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize = sizeof(struct zbewalgo_ctx),
+	.cra_module = THIS_MODULE,
+	.cra_init = zbewalgo_init,
+	.cra_exit = zbewalgo_exit,
+	.cra_u = {
+		.compress = {
+			.coa_compress = zbewalgo_compress_crypto,
+			.coa_decompress = zbewalgo_decompress_crypto
+		}
+	}
+};
+
+static struct scomp_alg scomp = {
+	.alloc_ctx = zbewalgo_alloc_ctx,
+	 .free_ctx = zbewalgo_free_ctx,
+	 .compress = zbewalgo_scompress,
+	 .decompress = zbewalgo_sdecompress,
+	 .base = {
+		 .cra_name = "zbewalgo",
+		 .cra_driver_name = "zbewalgo-scomp",
+		 .cra_module = THIS_MODULE,
+	}
+};
+
+static int __init zbewalgo_mod_init(void)
+{
+	int ret;
+
+	ret = crypto_register_alg(&crypto_alg_zbewalgo);
+	if (ret)
+		return ret;
+	ret = crypto_register_scomp(&scomp);
+	if (ret) {
+		crypto_unregister_alg(&crypto_alg_zbewalgo);
+		return ret;
+	}
+	return ret;
+}
+
+static void __exit zbewalgo_mod_fini(void)
+{
+	crypto_unregister_alg(&crypto_alg_zbewalgo);
+	crypto_unregister_scomp(&scomp);
+}
+
+module_init(zbewalgo_mod_init);
+module_exit(zbewalgo_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("zBeWalgo Compression Algorithm");
+MODULE_ALIAS_CRYPTO("zbewalgo");
diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 4ed0a78fd..15b3a0162 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -23,6 +23,9 @@ static const char * const backends[] = {
#if IS_ENABLED(CONFIG_CRYPTO_LZ4)
	"lz4",
#endif
+#if IS_ENABLED(CONFIG_CRYPTO_ZBEWALGO)
+	"zbewalgo",
+#endif
#if IS_ENABLED(CONFIG_CRYPTO_LZ4HC)
	"lz4hc",
#endif
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 31762db86..84dee5383 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -27,7 +27,9 @@
* Pages that compress to size greater than this are stored
* uncompressed in memory.
*/
-static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
+static const size_t max_zpage_size =
+	3264 /* largest reported size_class by zsmalloc */
+	- (sizeof(unsigned long)); /* zsmalloc internal overhead */

/*
* NOTE: max_zpage_size must be less than or equal to:
diff --git a/include/linux/zbewalgo.h b/include/linux/zbewalgo.h
new file mode 100644
index 000000000..0a8502b52
--- /dev/null
+++ b/include/linux/zbewalgo.h
@@ -0,0 +1,53 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_INCLUDE_H
+#define ZBEWALGO_INCLUDE_H
+
+/*
+ * zbewalgo_get_wrkmem_size must be used to determine the size which is
+ * required for allocating the working memory for the compression and
+ * decompression algorithm
+ */
+int zbewalgo_get_wrkmem_size(void);
+
+/*
+ * this function compresses the data given by 'source' into the
+ * preallocated memory given by 'dest'.
+ * The maximum allowed source_length is 4096 Bytes. If larger values are
+ * given, the algorithm returns an error.
+ * If the data is not compressible the function returns -1. Otherwise the
+ * size of the compressed data is returned.
+ * wrkmem must point to a memory region of at least the size returned by
+ * 'zbewalgo_get_wrkmem_size'.
+ */
+int zbewalgo_compress(const u8 * const source, u8 * const dest,
+		      u8 * const wrkmem, const uint16_t source_length);
+
+/*
+ * this function decompresses data which was already successfully compressed
+ * with 'zbewalgo_compress'.
+ * the function decompresses the data given by 'source' into the preallocated
+ * buffer 'dest'.
+ * wrkmem must point to a memory region of at least the size returned by
+ * 'zbewalgo_get_wrkmem_size'.
+ * the wrkmem for compression and decompression does not need to be the same
+ */
+int zbewalgo_decompress(const u8 * const source, u8 * const dest,
+			u8 * const wrkmem, const uint16_t source_length);
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index e96089499..ebcdd615b 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -239,6 +239,9 @@ config LZO_DECOMPRESS
config LZ4_COMPRESS
	tristate

+config ZBEWALGO_COMPRESS
+	tristate
+
config LZ4HC_COMPRESS
	tristate

diff --git a/lib/Makefile b/lib/Makefile
index 7adb06669..ff693e714 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -118,6 +118,7 @@ obj-$(CONFIG_BCH) += bch.o
obj-$(CONFIG_LZO_COMPRESS) += lzo/
obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
obj-$(CONFIG_LZ4_COMPRESS) += lz4/
+obj-$(CONFIG_ZBEWALGO_COMPRESS) += zbewalgo/
obj-$(CONFIG_LZ4HC_COMPRESS) += lz4/
obj-$(CONFIG_LZ4_DECOMPRESS) += lz4/
obj-$(CONFIG_ZSTD_COMPRESS) += zstd/
diff --git a/lib/zbewalgo/BWT.c b/lib/zbewalgo/BWT.c
new file mode 100644
index 000000000..ab30ba13f
--- /dev/null
+++ b/lib/zbewalgo/BWT.c
@@ -0,0 +1,112 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ * The Burrows-Wheeler-Transformation was published by 'M. Burrows' and
+ * 'D. J. Wheeler' in 1994. This implementation uses counting sort for
+ * sorting the data. Their original paper is online available at:
+ * http://www.hpl.hp.com/techreports/Compaq-DEC/SRC-RR-124.pdf
+ */
+
+#include "BWT.h"
+
+/*
+ * implementation of the Burrows-Wheeler transformation. Optimized for speed
+ * and small input sizes
+ */
+static __always_inline int compress_bwt(const u8 * const source,
+					u8 * const dest, u16 * const wrkmem,
+					const u16 source_length)
+{
+	u16 * const C = wrkmem;
+	u16 i;
+	u16 alphabet;
+	u8 * const op = dest + 1;
+	*dest = source[source_length - 1];
+	memset(C, 0, 512);
+	for (i = 0; i < source_length; i++)
+		C[source[i]]++;
+	alphabet = (C[0] > 0);
+	for (i = 1; i < 256; i++) {
+		alphabet += (C[i] > 0);
+		C[i] += C[i - 1];
+	}
+	if (alphabet > zbewalgo_bwt_max_alphabet) {
+		/* not compressible */
+		return -EINVAL;
+	}
+	i = source_length - 1;
+	C[source[i]]--;
+	op[C[source[i]]] = source[i - 1];
+	i--;
+	while (i > 0) {
+		C[source[i]]--;
+		op[C[source[i]]] = source[i - 1];
+		i--;
+	}
+	C[source[0]]--;
+	op[C[source[0]]] = source[source_length - 1];
+	return source_length + 1;
+}
+
+/*
+ * reverses the transformation
+ */
+static __always_inline int decompress_bwt(const u8 * const source,
+					  u8 * const dest, u16 * const wrkmem,
+					  const u16 source_length)
+{
+	const u16 dest_length = source_length - 1;
+	u16 * const C = wrkmem;
+	u8 * const L = (u8 *)(wrkmem + 256);
+	u8 key = *source;
+	u8 *dest_end = dest + dest_length;
+	const u8 *ip = source + 1;
+	int i, j;
+
+	memset(C, 0, 512);
+	for (i = 0; i < dest_length; i++)
+		C[ip[i]]++;
+	for (i = 1; i < 256; i++)
+		C[i] += C[i - 1];
+	j = 0;
+	for (i = 0; i < 256; i++)
+		while (j < C[i])
+			L[j++] = i;
+	do {
+		C[key]--;
+		*--dest_end = L[C[key]];
+		key = ip[C[key]];
+	} while (dest < dest_end);
+	return dest_length;
+}
+
+static int init_bwt(void)
+{
+	return 0;
+}
+
+static void exit_bwt(void)
+{
+}
+
+struct zbewalgo_alg alg_bwt = {
+	.name = "bwt",
+	.flags = ZBEWALGO_ALG_FLAG_TRANSFORM,
+	.wrkmem_size = PAGE_SIZE << 1,
+	.init = init_bwt,
+	.exit = exit_bwt,
+	.compress = compress_bwt,
+	.decompress = decompress_bwt
+};
diff --git a/lib/zbewalgo/BWT.h b/lib/zbewalgo/BWT.h
new file mode 100644
index 000000000..fd473aade
--- /dev/null
+++ b/lib/zbewalgo/BWT.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_BWT_H
+#define ZBEWALGO_BWT_H
+
+#include "include.h"
+
+extern struct zbewalgo_alg alg_bwt;
+
+/*
+ * If more than the specified number of chars are to be transformed,
+ * it is unlikely that the compression will achieve high ratios.
+ * As a consequence the Burrows-Wheeler Transformation will abort if the number
+ * of different bytes exeeds this value.
+ */
+static unsigned long zbewalgo_bwt_max_alphabet = 90;
+
+#endif
diff --git a/lib/zbewalgo/JBE.c b/lib/zbewalgo/JBE.c
new file mode 100644
index 000000000..01507bca9
--- /dev/null
+++ b/lib/zbewalgo/JBE.c
@@ -0,0 +1,195 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ * j-bit-encoding as proposed by 'I Made Agus Dwi Suarjaya' in 2012.
+ * https://arxiv.org/pdf/1209.1045.pdf
+ */
+
+#include "JBE.h"
+
+/*
+ * source_length is increased to the next multiple of 8 to increase speed.
+ */
+static __always_inline int compress_jbe(const u8 * const source,
+					u8 * const dest, u16 * const wrkmem,
+					const u16 source_length)
+{
+	u64 source_tmp;
+	u8 tmp;
+	const u8 *source_end = source + ((source_length + 0x7) & ~0x7);
+	const u8 *ip = source;
+	u8 *data1 = dest + 2;
+	u8 *data2 = data1 + DIV_BY_8_ROUND_UP(source_length);
+	u8 * const source_tmp_ptr = (u8 *)(&source_tmp);
+
+	put_unaligned_le16(source_length, dest);
+	do {
+		source_tmp = get_unaligned_le64(ip);
+		ip += 8;
+		tmp = source_tmp_ptr[0] > 0;
+		*data2 = source_tmp_ptr[0];
+		*data1 = tmp << 7;
+		data2 += tmp;
+		tmp = source_tmp_ptr[1] > 0;
+		*data2 = source_tmp_ptr[1];
+		*data1 |= tmp << 6;
+		data2 += tmp;
+		tmp = source_tmp_ptr[2] > 0;
+		*data2 = source_tmp_ptr[2];
+		*data1 |= tmp << 5;
+		data2 += tmp;
+		tmp = source_tmp_ptr[3] > 0;
+		*data2 = source_tmp_ptr[3];
+		*data1 |= tmp << 4;
+		data2 += tmp;
+		tmp = source_tmp_ptr[4] > 0;
+		*data2 = source_tmp_ptr[4];
+		*data1 |= tmp << 3;
+		data2 += tmp;
+		tmp = source_tmp_ptr[5] > 0;
+		*data2 = source_tmp_ptr[5];
+		*data1 |= tmp << 2;
+		data2 += tmp;
+		tmp = source_tmp_ptr[6] > 0;
+		*data2 = source_tmp_ptr[6];
+		*data1 |= tmp << 1;
+		data2 += tmp;
+		tmp = source_tmp_ptr[7] > 0;
+		*data2 = source_tmp_ptr[7];
+		*data1 |= tmp;
+		data2 += tmp;
+		data1++;
+	} while (ip < source_end);
+	return data2 - dest;
+}
+
+static __always_inline int decompress_jbe(const u8 * const source,
+					  u8 * const dest, u16 * const wrkmem,
+					  const u16 source_length)
+{
+	u64 dest_tmp;
+	const u16 dest_length = get_unaligned_le16(source);
+	const u8 *data1 = source + 2;
+	const u8 *data2 = data1 + DIV_BY_8_ROUND_UP(dest_length);
+	const u8 *dest_end = dest + dest_length;
+	u8 * const dest_tmp_ptr = (u8 *)(&dest_tmp);
+	u8 *op = dest;
+	const u8 * const source_end = source + source_length;
+	const u8 * const source_end_8 = source_end - 8;
+
+	do {
+		if (data2 >= source_end_8)
+			goto _last_8;
+		dest_tmp_ptr[0] = ((*data1 & 0x80) ? *data2 : 0);
+		data2 += (*data1 & 0x80) > 0;
+		dest_tmp_ptr[1] = ((*data1 & 0x40) ? *data2 : 0);
+		data2 += (*data1 & 0x40) > 0;
+		dest_tmp_ptr[2] = ((*data1 & 0x20) ? *data2 : 0);
+		data2 += (*data1 & 0x20) > 0;
+		dest_tmp_ptr[3] = ((*data1 & 0x10) ? *data2 : 0);
+		data2 += (*data1 & 0x10) > 0;
+		dest_tmp_ptr[4] = ((*data1 & 0x08) ? *data2 : 0);
+		data2 += (*data1 & 0x08) > 0;
+		dest_tmp_ptr[5] = ((*data1 & 0x04) ? *data2 : 0);
+		data2 += (*data1 & 0x04) > 0;
+		dest_tmp_ptr[6] = ((*data1 & 0x02) ? *data2 : 0);
+		data2 += (*data1 & 0x02) > 0;
+		dest_tmp_ptr[7] = ((*data1 & 0x01) ? *data2 : 0);
+		data2 += (*data1 & 0x01) > 0;
+		data1++;
+		put_unaligned_le64(dest_tmp, op);
+		op += 8;
+	} while (op < dest_end);
+	if (((dest_length + 0x7) & (~0x7)) != (op - dest)) {
+		/* output incomplete - error */
+		return -EINVAL;
+	}
+	return dest_length;
+_last_8:
+	/*
+	 * Reading last 8 bytes from data2. This may produce a lot of output,
+	 * if data1 indicates to NOT read from - and inrement - data2
+	 */
+	do {
+		dest_tmp = 0;
+		if (*data1 & 0x80) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[0] = *data2++;
+		}
+		if (*data1 & 0x40) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[1] = *data2++;
+		}
+		if (*data1 & 0x20) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[2] = *data2++;
+		}
+		if (*data1 & 0x10) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[3] = *data2++;
+		}
+		if (*data1 & 0x08) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[4] = *data2++;
+		}
+		if (*data1 & 0x04) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[5] = *data2++;
+		}
+		if (*data1 & 0x02) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[6] = *data2++;
+		}
+		if (*data1 & 0x01) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[7] = *data2++;
+		}
+		data1++;
+		put_unaligned_le64(dest_tmp, op);
+		op += 8;
+	} while (op < dest_end);
+	if (((dest_length + 0x7) & (~0x7)) != (op - dest)) {
+		/* output incomplete - error */
+		return -EINVAL;
+	}
+	return dest_length;
+}
+
+static int init_jbe(void)
+{
+	return 0;
+}
+
+static void exit_jbe(void)
+{
+}
+
+struct zbewalgo_alg alg_jbe = {
+	.name = "jbe",
+	.flags = ZBEWALGO_ALG_FLAG_COMPRESS,
+	.wrkmem_size = 0,
+	.init = init_jbe,
+	.exit = exit_jbe,
+	.compress = compress_jbe,
+	.decompress = decompress_jbe
+};
diff --git a/lib/zbewalgo/JBE.h b/lib/zbewalgo/JBE.h
new file mode 100644
index 000000000..963d6a561
--- /dev/null
+++ b/lib/zbewalgo/JBE.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_JBE_H
+#define ZBEWALGO_JBE_H
+
+#include "include.h"
+
+extern struct zbewalgo_alg alg_jbe;
+
+#endif
diff --git a/lib/zbewalgo/JBE2.c b/lib/zbewalgo/JBE2.c
new file mode 100644
index 000000000..762be3b44
--- /dev/null
+++ b/lib/zbewalgo/JBE2.c
@@ -0,0 +1,210 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ * j-bit-encoding was published by 'I Made Agus Dwi Suarjaya' in 2012.
+ * https://arxiv.org/pdf/1209.1045.pdf
+ *
+ * jbe2 is a minor modification of jbe. Swapping groups of 4 Bit in consecutive
+ * Bytes can increase the compression ratio, if for example the first
+ * 4 Bits of each Byte are zero. If jbe2 is called after mtf, this
+ * happens ofthen.
+ */
+
+#include "JBE2.h"
+
+/*
+ * source_length is increased to the next multiple of 8 to increase speed.
+ * This implementation is modified to swap groups of 4 bits before processing
+ */
+static __always_inline int compress_jbe2(const u8 * const source,
+					 u8 * const dest, u16 * const wrkmem,
+					 const u16 source_length)
+{
+	u64 source_tmp;
+	u8 tmp;
+	const u8 *source_end = source + source_length;
+	const u8 *ip = source;
+	u8 *data1 = dest + 2;
+	u8 *data2 = data1 + DIV_BY_8_ROUND_UP(source_length);
+	u8 * const source_tmp_ptr = (u8 *)(&source_tmp);
+
+	put_unaligned_le16(source_length, dest);
+	do {
+		source_tmp = get_unaligned_le64(ip);
+		ip += 8;
+		source_tmp = (source_tmp & 0xF0F0F0F00F0F0F0F)
+			| ((source_tmp & 0x0F0F0F0F00000000) >> 28)
+			| ((source_tmp & 0x00000000F0F0F0F0) << 28);
+		tmp = source_tmp_ptr[0] > 0;
+		*data2 = source_tmp_ptr[0];
+		*data1 = tmp << 7;
+		data2 += tmp;
+		tmp = source_tmp_ptr[1] > 0;
+		*data2 = source_tmp_ptr[1];
+		*data1 |= tmp << 6;
+		data2 += tmp;
+		tmp = source_tmp_ptr[2] > 0;
+		*data2 = source_tmp_ptr[2];
+		*data1 |= tmp << 5;
+		data2 += tmp;
+		tmp = source_tmp_ptr[3] > 0;
+		*data2 = source_tmp_ptr[3];
+		*data1 |= tmp << 4;
+		data2 += tmp;
+		tmp = source_tmp_ptr[4] > 0;
+		*data2 = source_tmp_ptr[4];
+		*data1 |= tmp << 3;
+		data2 += tmp;
+		tmp = source_tmp_ptr[5] > 0;
+		*data2 = source_tmp_ptr[5];
+		*data1 |= tmp << 2;
+		data2 += tmp;
+		tmp = source_tmp_ptr[6] > 0;
+		*data2 = source_tmp_ptr[6];
+		*data1 |= tmp << 1;
+		data2 += tmp;
+		tmp = source_tmp_ptr[7] > 0;
+		*data2 = source_tmp_ptr[7];
+		*data1 |= tmp;
+		data2 += tmp;
+		data1++;
+	} while (ip < source_end);
+	return data2 - dest;
+}
+
+static __always_inline int decompress_jbe2(const u8 * const source,
+					   u8 * const dest, u16 * const wrkmem,
+					   const u16 source_length)
+{
+	u64 dest_tmp;
+	const u16 dest_length = get_unaligned_le16(source);
+	const u8 *data1 = source + 2;
+	const u8 *data2 = data1 + DIV_BY_8_ROUND_UP(dest_length);
+	const u8 *dest_end = dest + dest_length;
+	u8 * const dest_tmp_ptr = (u8 *)(&dest_tmp);
+	u8 *op = dest;
+	const u8 * const source_end = source + source_length;
+	const u8 * const source_end_8 = source_end - 8;
+
+	do {
+		if (data2 >= source_end_8)
+			goto _last_8;
+		dest_tmp_ptr[0] = ((*data1 & 0x80) ? *data2 : 0);
+		data2 += (*data1 & 0x80) > 0;
+		dest_tmp_ptr[1] = ((*data1 & 0x40) ? *data2 : 0);
+		data2 += (*data1 & 0x40) > 0;
+		dest_tmp_ptr[2] = ((*data1 & 0x20) ? *data2 : 0);
+		data2 += (*data1 & 0x20) > 0;
+		dest_tmp_ptr[3] = ((*data1 & 0x10) ? *data2 : 0);
+		data2 += (*data1 & 0x10) > 0;
+		dest_tmp_ptr[4] = ((*data1 & 0x08) ? *data2 : 0);
+		data2 += (*data1 & 0x08) > 0;
+		dest_tmp_ptr[5] = ((*data1 & 0x04) ? *data2 : 0);
+		data2 += (*data1 & 0x04) > 0;
+		dest_tmp_ptr[6] = ((*data1 & 0x02) ? *data2 : 0);
+		data2 += (*data1 & 0x02) > 0;
+		dest_tmp_ptr[7] = ((*data1 & 0x01) ? *data2 : 0);
+		data2 += (*data1 & 0x01) > 0;
+		data1++;
+		dest_tmp = (dest_tmp & 0xF0F0F0F00F0F0F0F)
+			| ((dest_tmp & 0x0F0F0F0F00000000) >> 28)
+			| ((dest_tmp & 0x00000000F0F0F0F0) << 28);
+		put_unaligned_le64(dest_tmp, op);
+		op += 8;
+	} while (op < dest_end);
+	if (((dest_length + 0x7) & (~0x7)) != (op - dest)) {
+		/* output incomplete - error */
+		return -EINVAL;
+	}
+	return dest_length;
+_last_8:
+	/*
+	 * Reading last 8 bytes from data2. This may produce a lot of output,
+	 * if data1 indicates to NOT read from - and inrement - data2
+	 */
+	do {
+		dest_tmp = 0;
+		if (*data1 & 0x80) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[0] = *data2++;
+		}
+		if (*data1 & 0x40) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[1] = *data2++;
+		}
+		if (*data1 & 0x20) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[2] = *data2++;
+		}
+		if (*data1 & 0x10) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[3] = *data2++;
+		}
+		if (*data1 & 0x08) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[4] = *data2++;
+		}
+		if (*data1 & 0x04) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[5] = *data2++;
+		}
+		if (*data1 & 0x02) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[6] = *data2++;
+		}
+		if (*data1 & 0x01) {
+			if (unlikely(data2 >= source_end))
+				return -EINVAL;
+			dest_tmp_ptr[7] = *data2++;
+		}
+		data1++;
+		dest_tmp = (dest_tmp & 0xF0F0F0F00F0F0F0F)
+			| ((dest_tmp & 0x0F0F0F0F00000000) >> 28)
+			| ((dest_tmp & 0x00000000F0F0F0F0) << 28);
+		put_unaligned_le64(dest_tmp, op);
+		op += 8;
+	} while (op < dest_end);
+	if (((dest_length + 0x7) & (~0x7)) != (op - dest)) {
+		/* output incomplete - error */
+		return -EINVAL;
+	}
+	return dest_length;
+}
+
+static int init_jbe2(void)
+{
+	return 0;
+}
+
+static void exit_jbe2(void)
+{
+}
+
+struct zbewalgo_alg alg_jbe2 = {
+	.name = "jbe2",
+	.flags = ZBEWALGO_ALG_FLAG_COMPRESS,
+	.wrkmem_size = 0,
+	.init = init_jbe2,
+	.exit = exit_jbe2,
+	.compress = compress_jbe2,
+	.decompress = decompress_jbe2
+};
diff --git a/lib/zbewalgo/JBE2.h b/lib/zbewalgo/JBE2.h
new file mode 100644
index 000000000..09ddd7d96
--- /dev/null
+++ b/lib/zbewalgo/JBE2.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_JBE2_H
+#define ZBEWALGO_JBE2_H
+
+#include "include.h"
+
+extern struct zbewalgo_alg alg_jbe2;
+
+#endif
diff --git a/lib/zbewalgo/MTF.c b/lib/zbewalgo/MTF.c
new file mode 100644
index 000000000..ebe5e4a11
--- /dev/null
+++ b/lib/zbewalgo/MTF.c
@@ -0,0 +1,100 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ * The Move-To-Front algorithm as described by 'M. Burrows' and
+ * 'D. J. Wheeler' in the same paper as bwt.
+ * Their original paper is online available at:
+ * http://www.hpl.hp.com/techreports/Compaq-DEC/SRC-RR-124.pdf
+ */
+
+#include "MTF.h"
+
+static u8 initial_data[256];
+
+static __always_inline int compress_mtf(const u8 * const source,
+					u8 * const dest, u16 * const wrkmem,
+					const u16 source_length)
+{
+	u8 * const wrk = (u8 *)wrkmem;
+	const u8 *source_end = source + source_length;
+	const u8 *ip = source;
+	u8 *op = dest;
+	u16 i;
+	u8 tmp;
+
+	memcpy(wrk, &initial_data[0], 256);
+	do {
+		i = 0;
+		while (wrk[i] != *ip)
+			i++;
+		ip++;
+		*op++ = i;
+		tmp = wrk[i];
+		while (i > 0) {
+			wrk[i] = wrk[i - 1];
+			i--;
+		}
+		wrk[0] = tmp;
+	} while (ip < source_end);
+	return source_length;
+}
+
+static __always_inline int decompress_mtf(const u8 * const source,
+					  u8 * const dest, u16 * const wrkmem,
+					  const u16 source_length)
+{
+u8 * const wrk = (u8 *)wrkmem;
+	u8 *dest_end = dest + source_length;
+	u16 i;
+	u8 tmp;
+	const u8 *ip = source;
+	u8 *op = dest;
+
+	memcpy(wrk, &initial_data[0], 256);
+	do {
+		i = *ip++;
+		*op++ = wrk[i];
+		tmp = wrk[i];
+		while (i > 0) {
+			wrk[i] = wrk[i - 1];
+			i--;
+		}
+		wrk[0] = tmp;
+	} while (op < dest_end);
+	return source_length;
+}
+
+static int init_mtf(void)
+{
+	int i;
+
+	for (i = 0; i < 256; i++)
+		initial_data[i] = i;
+	return 0;
+}
+
+static void exit_mtf(void)
+{
+}
+
+struct zbewalgo_alg alg_mtf = {
+	.name = "mtf",
+	.flags = ZBEWALGO_ALG_FLAG_TRANSFORM,
+	.wrkmem_size = 256,
+	.init = init_mtf,
+	.exit = exit_mtf,
+	.compress = compress_mtf,
+	.decompress = decompress_mtf
+};
diff --git a/lib/zbewalgo/MTF.h b/lib/zbewalgo/MTF.h
new file mode 100644
index 000000000..593ccf9b2
--- /dev/null
+++ b/lib/zbewalgo/MTF.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_MTF_H
+#define ZBEWALGO_MTF_H
+
+#include "include.h"
+
+extern struct zbewalgo_alg alg_mtf;
+
+#endif
diff --git a/lib/zbewalgo/Makefile b/lib/zbewalgo/Makefile
new file mode 100644
index 000000000..f8cf7bfcc
--- /dev/null
+++ b/lib/zbewalgo/Makefile
@@ -0,0 +1,4 @@
+ccflags-y += -O3 -fno-tree-vrp
+
+obj-$(CONFIG_ZBEWALGO_COMPRESS) += zbewalgo_compress.o
+zbewalgo_compress-objs := zbewalgo.o bewalgo.o bewalgo2.o bitshuffle.o BWT.o huffman.o JBE.o JBE2.o MTF.o RLE.o
diff --git a/lib/zbewalgo/RLE.c b/lib/zbewalgo/RLE.c
new file mode 100644
index 000000000..e89ef46c5
--- /dev/null
+++ b/lib/zbewalgo/RLE.c
@@ -0,0 +1,128 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#include "RLE.h"
+
+#define RLE_REPEAT 0x80
+#define RLE_SIMPLE 0x00
+#define RLE_MAX_LENGTH ((1 << 7) - 1)
+
+/*
+ * Run Length Encoder
+ */
+static __always_inline int compress_rle(const u8 * const source,
+					u8 * const dest, u16 * const wrkmem,
+					const u16 source_length)
+{
+	const u8 *anchor = source;
+	const u8 *source_end = source + source_length;
+	unsigned int count;
+	u8 lastval;
+	u8 *op = dest;
+	const u8 *ip = source;
+
+	while (1) {
+		/* RLE_SIMPLE */
+		do {
+			lastval = *ip++;
+		} while ((ip < source_end) && (lastval != *ip));
+		count = ip - anchor - (ip < source_end);
+		if (count > 0) {
+			while (count > RLE_MAX_LENGTH) {
+				*op++ = RLE_SIMPLE | RLE_MAX_LENGTH;
+				memcpy(op, anchor, RLE_MAX_LENGTH + 1);
+				anchor += RLE_MAX_LENGTH + 1;
+				op += RLE_MAX_LENGTH + 1;
+				count -= RLE_MAX_LENGTH + 1;
+			}
+			if (count > 0) {
+				*op++ = RLE_SIMPLE | (count - 1);
+				memcpy(op, anchor, count);
+				anchor += count;
+				op += count;
+			}
+		}
+		if (ip == source_end)
+			return op - dest;
+		/* RLE_REPEAT */
+		do {
+			lastval = *ip++;
+		} while ((ip < source_end) && (lastval == *ip));
+		count = ip - anchor;
+		if (count > 0) {
+			anchor += count;
+			while (count > RLE_MAX_LENGTH) {
+				*op++ = RLE_REPEAT | RLE_MAX_LENGTH;
+				*op++ = lastval;
+				count -= RLE_MAX_LENGTH + 1;
+			}
+			if (count > 0) {
+				*op++ = RLE_REPEAT | (count - 1);
+				*op++ = lastval;
+			}
+		}
+		if (ip == source_end)
+			return op - dest;
+	}
+}
+
+static __always_inline int decompress_rle(const u8 * const source,
+					  u8 * const dest, u16 * const wrkmem,
+					  const u16 source_length)
+{
+	unsigned int length;
+	const u8 *ip = source;
+	u8 *op = dest;
+	const u8 *const source_end = source + source_length;
+
+	while (ip + 1 < source_end) {
+		if ((*ip & RLE_REPEAT) == RLE_REPEAT) {
+			length = *ip++ - RLE_REPEAT + 1;
+			memset(op, *ip++, length);
+			op += length;
+		} else {
+			length = *ip++ - RLE_SIMPLE + 1;
+			if (unlikely(ip + length > source_end)) {
+				/* source_length too small */
+				return -EINVAL;
+			}
+			memcpy(op, ip, length);
+			ip += length;
+			op += length;
+		}
+	}
+	return op - dest;
+}
+
+static int init_rle(void)
+{
+	return 0;
+}
+
+static void exit_rle(void)
+{
+}
+
+struct zbewalgo_alg alg_rle = {
+	.name = "rle",
+	.flags = ZBEWALGO_ALG_FLAG_COMPRESS,
+	.wrkmem_size = 0,
+	.init = init_rle,
+	.exit = exit_rle,
+	.compress = compress_rle,
+	.decompress = decompress_rle
+};
diff --git a/lib/zbewalgo/RLE.h b/lib/zbewalgo/RLE.h
new file mode 100644
index 000000000..0377d68f5
--- /dev/null
+++ b/lib/zbewalgo/RLE.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_RLE_H
+#define ZBEWALGO_RLE_H
+
+#include "include.h"
+
+extern struct zbewalgo_alg alg_rle;
+
+#endif
diff --git a/lib/zbewalgo/bewalgo.c b/lib/zbewalgo/bewalgo.c
new file mode 100644
index 000000000..b2b94c256
--- /dev/null
+++ b/lib/zbewalgo/bewalgo.c
@@ -0,0 +1,381 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ * Benjamin Warnke invented this algorithm for his bachelors thesis
+ * 'Page-Based compression in the Linux Kernel'. This algorithm is
+ * mainly inspired by lz4, focusing on increasing the speed even more,
+ * with the help of page aligned read an write access. To achieve the
+ * page alignment, the input and output data is accessed only in
+ * blocks of 8 Bytes, therefore the encoding of the compressed data is
+ * changed.
+ *
+ * His thesis is available at:
+ * https://wr.informatik.uni-hamburg.de/_media/research:theses:benjamin_warnke_page_based_compression_in_the_linux_kernel.pdf
+ */
+
+#include "bewalgo.h"
+
+#define BEWALGO_ACCELERATION_DEFAULT 1
+
+#define BEWALGO_MEMORY_USAGE 14
+
+#define BEWALGO_SKIPTRIGGER 6
+
+#define BEWALGO_LENGTH_BITS 8
+#define BEWALGO_LENGTH_MAX ((1 << BEWALGO_LENGTH_BITS) - 1)
+#define BEWALGO_OFFSET_BITS 16
+#define BEWALGO_OFFSET_MAX ((1 << BEWALGO_OFFSET_BITS) - 1)
+
+#define BEWALGO_HASHLOG (BEWALGO_MEMORY_USAGE - 2)
+
+/*
+ * this macro is faster than memcpy if mostly short byte sequences are
+ * copied
+ */
+#define bewalgo_copy_helper_src(d, s, t) \
+do { \
+	while (s + 32 <= t) { \
+		put_unaligned_le64(get_unaligned_le64(s), d);\
+		put_unaligned_le64(get_unaligned_le64(s + 8), d + 8);\
+		put_unaligned_le64(get_unaligned_le64(s + 16), d + 16);\
+		put_unaligned_le64(get_unaligned_le64(s + 24), d + 24);\
+		d += 32; \
+		s += 32; \
+	} \
+	if (s + 16 <= t) { \
+		put_unaligned_le64(get_unaligned_le64(s), d);\
+		put_unaligned_le64(get_unaligned_le64(s + 8), d + 8);\
+		d += 16; \
+		s += 16; \
+	} \
+	if (s < t) {\
+		put_unaligned_le64(get_unaligned_le64(s), d);\
+		d += 8; \
+		s += 8; \
+	} \
+} while (0)
+
+static __always_inline int decompress_bewalgo(const u8 * const source,
+					      u8 * const dest,
+					      u16 * const wrkmem,
+					      const u16 source_length)
+{
+	const u16 dest_length =  get_unaligned_le16(source);
+	const u8 * const source_end = source + source_length;
+	const u8 *ip = source + 2;
+	u8 *match = dest;
+	u8 *op = dest;
+	const u8 *control_block_ptr;
+	const u8 *target;
+
+	if (unlikely(ip + 8 >= source_end)) {
+		/* there is no data */
+		return -EINVAL;
+	}
+	do {
+		control_block_ptr = ip;
+		ip += 8;
+		target = ip + (control_block_ptr[0] << 3);
+		if (unlikely(target > source_end)) {
+			/* source_length too small */
+			return -EINVAL;
+		}
+		bewalgo_copy_helper_src(op, ip, target);
+		match = op - (get_unaligned_le16(control_block_ptr + 2) << 3);
+		if (unlikely(match < dest)) {
+			/* invalid read position */
+			return -EINVAL;
+		}
+		target = match + (control_block_ptr[1] << 3);
+		bewalgo_copy_helper_src(op, match, target);
+		target = ip + (control_block_ptr[4] << 3);
+		if (unlikely(target > source_end)) {
+			/* source_length too small */
+			return -EINVAL;
+		}
+		bewalgo_copy_helper_src(op, ip, target);
+		match = op - (get_unaligned_le16(control_block_ptr + 6) << 3);
+		if (unlikely(match < dest)) {
+			/* invalid read position */
+			return -EINVAL;
+		}
+		target = match + (control_block_ptr[5] << 3);
+		bewalgo_copy_helper_src(op, match, target);
+	} while (likely(ip < source_end));
+	if (((dest_length + 0x7) & ~0x7) != (op - dest))
+		return -EINVAL;
+	return dest_length;
+}
+
+/*
+ * The hashtable 'wrkmem' allows indicees in the range
+ * [0 .. ((1 << BEWALGO_HASHLOG) - 1)].
+ * Each input sequence hashed and mapped to a fixed index in that array. The
+ * final shift '>> (64 - BEWALGO_HASHLOG)' guarantees, that the index is
+ * valid. The hashtable is used to find known sequences in the input array.
+ */
+static __always_inline u32 bewalgo_compress_hash(u64 sequence)
+{
+	return ((sequence >> 24) * 11400714785074694791ULL)
+		 >> (64 - BEWALGO_HASHLOG);
+}
+
+static __always_inline int
+compress_bewalgo_(u16 *wrkmem,
+		  const u8 * const source, u8 * const dest,
+		  const u16 source_length, u8 acceleration)
+{
+	u32 * const table = (u32 *)wrkmem;
+	const int acceleration_start =
+		(acceleration < 4 ? 32 >> acceleration : 4);
+	const u8 * const dest_end_ptr = dest
+		+ ((zbewalgo_max_output_size + 0x7) & ~0x7) + 2;
+	const u8 * const source_end_ptr = source
+		+ ((source_length + 0x7) & ~0x7);
+	const u8 * const source_end_ptr_1 = source_end_ptr - 8;
+	const u8 *match = source;
+	const u8 *anchor = source;
+	const u8 *ip = source;
+	u8 *op = dest + 2;
+	u8 *op_control = NULL;
+	u32 op_control_available = 0;
+	const u8 *target;
+	int length;
+	u16 offset;
+	u32 h;
+	int j;
+	int tmp_literal_length;
+	int match_nodd;
+	int match_nzero_nodd;
+
+	put_unaligned_le16(source_length, dest);
+	memset(wrkmem, 0, 1 << BEWALGO_MEMORY_USAGE);
+	do {
+		j = acceleration_start;
+		length = (source_end_ptr_1 - ip) >> 3;
+		j = j < length ? j : length;
+		for (length = 1; length <= j; length++) {
+			ip += 8;
+			h = bewalgo_compress_hash(get_unaligned_le64(ip));
+			match = source + table[h];
+			table[h] = ip - source;
+			if (get_unaligned_le64(match) == get_unaligned_le64(ip))
+				goto _find_match_left;
+		}
+		length = acceleration_start
+			+ (acceleration << BEWALGO_SKIPTRIGGER);
+		ip += 8;
+		do {
+			if (unlikely(ip >= source_end_ptr))
+				goto _encode_last_literal;
+			h = bewalgo_compress_hash(get_unaligned_le64(ip));
+			match = source + table[h];
+			table[h] = ip - source;
+			if (get_unaligned_le64(match) == get_unaligned_le64(ip))
+				goto _find_match_left;
+			ip += (length++ >> BEWALGO_SKIPTRIGGER) << 3;
+		} while (1);
+_find_match_left:
+		while ((match != source)
+		       && (get_unaligned_le64(match - 8)
+			   == get_unaligned_le64(ip - 8))) {
+			ip -= 8;
+			match -= 8;
+			if (ip == anchor)
+				goto _find_match_right;
+		}
+		length = (ip - anchor) >> 3;
+		tmp_literal_length = length
+			- (op_control_available ? BEWALGO_LENGTH_MAX : 0);
+		if (unlikely(op
+			 + ((((tmp_literal_length / (BEWALGO_LENGTH_MAX * 2)))
+			 + ((tmp_literal_length % (BEWALGO_LENGTH_MAX * 2)) > 0)
+			 + length) << 3) > dest_end_ptr)) {
+			/* not compressible */
+			return -EINVAL;
+		}
+		while (length > BEWALGO_LENGTH_MAX) {
+			if (op_control_available == 0) {
+				op_control = op;
+				put_unaligned_le64(0, op);
+				op += 8;
+			}
+			op_control_available = !op_control_available;
+			*op_control = BEWALGO_LENGTH_MAX;
+			op_control += 4;
+			target = anchor + (BEWALGO_LENGTH_MAX << 3);
+			bewalgo_copy_helper_src(op, anchor, target);
+			length -= BEWALGO_LENGTH_MAX;
+		}
+		if (likely(length > 0)) {
+			if (op_control_available == 0) {
+				op_control = op;
+				put_unaligned_le64(0, op);
+				op += 8;
+			}
+			op_control_available = !op_control_available;
+			*op_control = length;
+			op_control += 4;
+			bewalgo_copy_helper_src(op, anchor, ip);
+		}
+_find_match_right:
+		do {
+			ip += 8;
+			match += 8;
+		} while ((ip < source_end_ptr)
+			 && (get_unaligned_le64(match)
+			     == get_unaligned_le64(ip)));
+		length = (ip - anchor) >> 3;
+		offset = (ip - match) >> 3;
+		anchor = ip;
+		if (length > BEWALGO_LENGTH_MAX) {
+			u32 val =
+				(BEWALGO_LENGTH_MAX << 8) | (offset << 16);
+			size_t match_length_div_255 = length / 255;
+			size_t match_length_mod_255 = length % 255;
+			u32 match_zero = match_length_mod_255 == 0;
+			u32 match_nzero = !match_zero;
+			int control_blocks_needed = match_length_div_255
+				+ match_nzero
+				- op_control_available;
+
+			if (unlikely(op + (((control_blocks_needed >> 1)
+					+ (control_blocks_needed & 1))
+					 << 3) > dest_end_ptr)) {
+				/* not compressible */
+				return -EINVAL;
+			}
+			op_control = op_control_available > 0
+				? op_control
+				: op;
+			put_unaligned_le32(val, op_control);
+			match_length_div_255 -= op_control_available > 0;
+			match_nodd = !(match_length_div_255 & 1);
+			match_nzero_nodd = match_nzero && match_nodd;
+			if (match_length_div_255 > 0) {
+				u64 val_l =
+					val
+					| (((u64)val)
+						<< 32);
+				target = op + (((match_length_div_255 >> 1)
+					    + (match_length_div_255 & 1)) << 3);
+				do {
+					put_unaligned_le64(val_l, op);
+					op += 8;
+				} while (op < target);
+			}
+			op_control = op - 4;
+			put_unaligned_le32(0, op_control
+					   + (match_nzero_nodd << 3));
+			put_unaligned_le32(0, op_control
+					    + (match_nzero_nodd << 2));
+			*(op_control + (match_nzero_nodd << 2) + 1) =
+				(match_zero & match_nodd)
+				 ? BEWALGO_LENGTH_MAX
+				 : match_length_mod_255;
+			put_unaligned_le16(offset, op_control
+					   + (match_nzero_nodd << 2) + 2);
+			op_control += match_nzero_nodd << 3;
+			op += match_nzero_nodd << 3;
+			op_control_available =
+				(match_length_div_255 & 1) == match_zero;
+		} else {
+			if (unlikely(op_control_available == 0
+				     && op >= dest_end_ptr
+				     && op_control[-3] != 0))
+				return -EINVAL;
+			if (op_control[-3] != 0) {
+				if (op_control_available == 0) {
+					op_control = op;
+					put_unaligned_le64(0, op);
+					op += 8;
+				}
+				op_control_available = !op_control_available;
+				op_control += 4;
+			}
+			op_control[-3] = length;
+			put_unaligned_le16(offset, op_control - 2);
+		}
+		if (unlikely(ip == source_end_ptr))
+			goto _finish;
+		h = bewalgo_compress_hash(get_unaligned_le64(ip));
+		match = source + table[h];
+		table[h] = ip - source;
+		if (get_unaligned_le64(match) == get_unaligned_le64(ip))
+			goto _find_match_right;
+	} while (1);
+_encode_last_literal:
+	length = (source_end_ptr - anchor) >> 3;
+	tmp_literal_length = length
+		- (op_control_available ? BEWALGO_LENGTH_MAX : 0);
+	if (op + ((((tmp_literal_length / (BEWALGO_LENGTH_MAX * 2)))
+		+ ((tmp_literal_length % (BEWALGO_LENGTH_MAX * 2)) > 0)
+		+ length) << 3) > dest_end_ptr)
+		return -EINVAL;
+	while (length > BEWALGO_LENGTH_MAX) {
+		if (op_control_available == 0) {
+			op_control = op;
+			put_unaligned_le64(0, op);
+			op += 8;
+		}
+		op_control_available = !op_control_available;
+		*op_control = BEWALGO_LENGTH_MAX;
+		op_control += 4;
+		target = anchor + (BEWALGO_LENGTH_MAX << 3);
+		bewalgo_copy_helper_src(op, anchor, target);
+		length -= BEWALGO_LENGTH_MAX;
+	}
+	if (length > 0) {
+		if (op_control_available == 0) {
+			op_control = op;
+			put_unaligned_le64(0, op);
+			op += 8;
+		}
+		op_control_available = !op_control_available;
+		*op_control = length;
+		op_control += 4;
+		bewalgo_copy_helper_src(op, anchor, source_end_ptr);
+	}
+_finish:
+	return op - dest;
+}
+
+static __always_inline int compress_bewalgo(const u8 * const source,
+					    u8 * const dest, u16 * const wrkmem,
+					    const u16 source_length)
+{
+	return compress_bewalgo_(wrkmem,
+				 source, dest,
+				 source_length, 1);
+}
+
+static int init_bewalgo(void)
+{
+	return 0;
+}
+
+static void exit_bewalgo(void)
+{
+}
+
+struct zbewalgo_alg alg_bewalgo = {
+	.name = "bewalgo",
+	.flags = ZBEWALGO_ALG_FLAG_COMPRESS,
+	.wrkmem_size = 1 << BEWALGO_MEMORY_USAGE,
+	.init = init_bewalgo,
+	.exit = exit_bewalgo,
+	.compress = compress_bewalgo,
+	.decompress = decompress_bewalgo
+};
diff --git a/lib/zbewalgo/bewalgo.h b/lib/zbewalgo/bewalgo.h
new file mode 100644
index 000000000..47b05a677
--- /dev/null
+++ b/lib/zbewalgo/bewalgo.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_BEWALGO_H
+#define ZBEWALGO_BEWALGO_H
+
+#include "include.h"
+
+extern struct zbewalgo_alg alg_bewalgo;
+
+#endif
diff --git a/lib/zbewalgo/bewalgo2.c b/lib/zbewalgo/bewalgo2.c
new file mode 100644
index 000000000..1894033e3
--- /dev/null
+++ b/lib/zbewalgo/bewalgo2.c
@@ -0,0 +1,396 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ * BeWalgo2 reads it's input in blocks of 8 Bytes. These Blocks
+ * are added to an avl-tree. The avl-tree is mapped directly to an
+ * array. The encoding is a variation of Run Length Encoding using the
+ * indices in the avl-tree as data. The reason for using the tree
+ * with indices is, that the indices can be encoded in less then
+ * 8 Bytes each.
+ */
+
+#include "bewalgo2.h"
+
+#define MAX_LITERALS ((zbewalgo_max_output_size >> 3) - 4)
+
+#define OFFSET_BITS 9
+#define OFFSET_SHIFT (16 - OFFSET_BITS)
+#define MATCH_BIT_SHIFT 6
+#define MATCH_BIT_MASK BIT(MATCH_BIT_SHIFT)
+#define LENGTH_BITS 6
+#define LENGTH_MASK ((1 << LENGTH_BITS) - 1)
+#define LEFT 0
+#define RIGHT 1
+#define NEITHER 2
+#define TREE_NODE_NULL 0xffff
+
+/*
+ * insert first node into an empty avl-tree
+ * the function returns the index of the node in the preallocated array
+ */
+static __always_inline int avl_insert_first(u64 *wrk_literal, u16 *wrk_tree,
+					    u16 *treep, u64 target,
+					    u16 *treesize)
+{
+	u16 g_a_tree, g_o_tree2;
+
+	g_a_tree = *treesize;
+	g_o_tree2 = g_a_tree << 2;
+	*treesize = *treesize + 1;
+	wrk_tree[g_o_tree2 + 0] = TREE_NODE_NULL;
+	wrk_tree[g_o_tree2 + 1] = TREE_NODE_NULL;
+	wrk_tree[g_o_tree2 + 2] = NEITHER;
+	wrk_literal[g_a_tree] = target;
+	*treep = g_a_tree;
+	return g_a_tree;
+}
+
+/*
+ * insert a node into a non-empty avl-tree
+ * for speed, the nodes are saved in preallocated arrays
+ * the function returns the index of the node in the preallocated array
+ */
+static __always_inline int avl_insert(u64 *wrk_literal, u16 *wrk_tree,
+				      u16 *treep, u64 target,
+				      u16 *treesize)
+{
+	u16 *path_top[2];
+	u16 g_a_tree, g_o_tree2, g_o_next_step;
+	u16 r_1_arr[10];
+	u16 path, path2, first[2], second;
+
+	if (unlikely(target == wrk_literal[*treep]))
+		return *treep;
+	path_top[0] = treep;
+	g_o_next_step = target > wrk_literal[*treep];
+	g_o_tree2 = *treep << 2;
+	path_top[wrk_tree[g_o_tree2 + 2] == NEITHER] = treep;
+	treep = &wrk_tree[g_o_tree2 + g_o_next_step];
+	if (unlikely(*treep == TREE_NODE_NULL))
+		goto _insert_new_node;
+_search_node:
+	if (target == wrk_literal[*treep])
+		return *treep;
+	g_o_next_step = target > wrk_literal[*treep];
+	g_o_tree2 = *treep << 2;
+	path_top[wrk_tree[g_o_tree2 + 2] == NEITHER] = treep;
+	treep = &wrk_tree[g_o_tree2 + g_o_next_step];
+	if (likely(*treep != TREE_NODE_NULL))
+		goto _search_node;
+_insert_new_node:
+	g_a_tree = *treesize;
+	g_o_tree2 = g_a_tree << 2;
+	*treesize = *treesize + 1;
+	wrk_tree[g_o_tree2 + 0] = TREE_NODE_NULL;
+	wrk_tree[g_o_tree2 + 1] = TREE_NODE_NULL;
+	wrk_tree[g_o_tree2 + 2] = NEITHER;
+	wrk_literal[g_a_tree] = target;
+	*treep = g_a_tree;
+	path = *path_top[0];
+	path2 = path << 2;
+	if (wrk_tree[path2 + 2] == NEITHER) {
+		while (1) {
+			r_1_arr[0] = target > wrk_literal[path];
+			wrk_tree[path2 + 2] = r_1_arr[0];
+			path = wrk_tree[path2 + r_1_arr[0]];
+			if (target == wrk_literal[path])
+				return g_a_tree;
+			path2 = path << 2;
+		}
+	}
+	first[0] = target > wrk_literal[path];
+	if (wrk_tree[path2 + 2] != first[0]) {
+		wrk_tree[path2 + 2] = NEITHER;
+		r_1_arr[2] = wrk_tree[path2 + first[0]];
+		if (target == wrk_literal[r_1_arr[2]])
+			return g_a_tree;
+		while (1) {
+			r_1_arr[0] = target > wrk_literal[r_1_arr[2]];
+			r_1_arr[1] = r_1_arr[2] << 2;
+			r_1_arr[2] = wrk_tree[r_1_arr[1] + r_1_arr[0]];
+			wrk_tree[r_1_arr[1] + 2] = r_1_arr[0];
+			if (target == wrk_literal[r_1_arr[2]])
+				return g_a_tree;
+		}
+	}
+	second = target > wrk_literal[wrk_tree[path2 + first[0]]];
+	first[1] = 1 - first[0];
+	if (first[0] == second) {
+		r_1_arr[2] = *path_top[0];
+		r_1_arr[3] = r_1_arr[2] << 2;
+		r_1_arr[4] = wrk_tree[r_1_arr[3] + first[0]];
+		r_1_arr[5] = r_1_arr[4] << 2;
+		wrk_tree[r_1_arr[3] + first[0]] =
+			wrk_tree[r_1_arr[5] + first[1]];
+		path = wrk_tree[r_1_arr[5] + first[0]];
+		*path_top[0] = r_1_arr[4];
+		wrk_tree[r_1_arr[5] + first[1]] = r_1_arr[2];
+		wrk_tree[r_1_arr[3] + 2] = NEITHER;
+		wrk_tree[r_1_arr[5] + 2] = NEITHER;
+		if (target == wrk_literal[path])
+			return g_a_tree;
+		while (1) {
+			r_1_arr[0] = target > wrk_literal[path];
+			r_1_arr[1] = path << 2;
+			wrk_tree[r_1_arr[1] + 2] = r_1_arr[0];
+			path = wrk_tree[r_1_arr[1] + r_1_arr[0]];
+			if (target == wrk_literal[path])
+				return g_a_tree;
+		}
+	}
+	path = wrk_tree[(wrk_tree[path2 + first[0]] << 2) + second];
+	r_1_arr[5] = *path_top[0];
+	r_1_arr[1] = r_1_arr[5] << 2;
+	r_1_arr[8] = wrk_tree[r_1_arr[1] + first[0]];
+	r_1_arr[0] = r_1_arr[8] << 2;
+	r_1_arr[6] = wrk_tree[r_1_arr[0] + first[1]];
+	r_1_arr[7] = r_1_arr[6] << 2;
+	r_1_arr[2] = wrk_tree[r_1_arr[7] + first[1]];
+	r_1_arr[3] = wrk_tree[r_1_arr[7] + first[0]];
+	*path_top[0] = r_1_arr[6];
+	wrk_tree[r_1_arr[7] + first[1]] = r_1_arr[5];
+	wrk_tree[r_1_arr[7] + first[0]] = r_1_arr[8];
+	wrk_tree[r_1_arr[1] + first[0]] = r_1_arr[2];
+	wrk_tree[r_1_arr[0] + first[1]] = r_1_arr[3];
+	wrk_tree[r_1_arr[7] + 2] = NEITHER;
+	wrk_tree[r_1_arr[1] + 2] = NEITHER;
+	wrk_tree[r_1_arr[0] + 2] = NEITHER;
+	if (target == wrk_literal[path])
+		return g_a_tree;
+	r_1_arr[9] = (target > wrk_literal[path]) == first[0];
+	wrk_tree[r_1_arr[r_1_arr[9]] + 2] = first[r_1_arr[9]];
+	path = r_1_arr[r_1_arr[9] + 2];
+	if (target == wrk_literal[path])
+		return g_a_tree;
+	while (1) {
+		path2 = path << 2;
+		r_1_arr[4] = target > wrk_literal[path];
+		wrk_tree[path2 + 2] = r_1_arr[4];
+		path = wrk_tree[path2 + r_1_arr[4]];
+		if (target == wrk_literal[path])
+			return g_a_tree;
+	}
+}
+
+/*
+ * compress the given data using a binary tree holding all the previously
+ * seen 64-bit values
+ * returns the length of the compressed data
+ * wrkmem should be aligned to at least 8 by the caller
+ */
+static __always_inline int compress_bewalgo2(const u8 * const source,
+					     u8 * const dest,
+					     u16 * const wrkmem,
+					     const u16 source_length)
+{
+	const u8 * const source_begin = source;
+	u64 *wrk_literal = (u64 *)wrkmem;
+	u16 *wrk_tree = wrkmem + 2048;
+	u8 *op_match = dest + 4;
+	int count;
+	u16 i;
+	u16 j;
+	u16 tree_root = TREE_NODE_NULL;
+	u16 tree_size = 0;
+	const u8 *ip = source + ((source_length + 0x7) & (~0x7)) - 8;
+
+	/*
+	 * add first value into the tree
+	 */
+	i = avl_insert_first(wrk_literal, wrk_tree, &tree_root,
+			     get_unaligned_le64(ip), &tree_size);
+	/*
+	 * to gain performance abort if the data does not seem to be
+	 * compressible
+	 */
+	if (source_length > 512) {
+		/*
+		 * verify that at there are at most 5 different values
+		 * at the first 10 positions
+		 */
+		for (i = 2; i < 11; i++)
+			avl_insert(wrk_literal, wrk_tree, &tree_root,
+				   get_unaligned_le64(ip - (i << 3)),
+				   &tree_size);
+		if (tree_size < 6)
+			goto _start;
+		/*
+		 * verify that there are at most 12 different values
+		 * at the first 10 and last 10 positions
+		 */
+		for (i = 0; i < 10; i++)
+			avl_insert(wrk_literal, wrk_tree, &tree_root,
+				   get_unaligned_le64(source_begin + (i << 3)),
+				   &tree_size);
+		if (tree_size < 13)
+			goto _start;
+		/*
+		 * if the previous conditions do not pass, check some bytes
+		 * in the middle for matches.
+		 * if not enough matches found: abort
+		 */
+		for (i = 0; i < 10; i++)
+			avl_insert(wrk_literal, wrk_tree, &tree_root,
+				   get_unaligned_le64(source_begin
+						       + (256 + (i << 3))),
+						      &tree_size);
+		if (tree_size >= 21) {
+			/* not compressible */
+			return -EINVAL;
+		}
+	}
+_start:
+	i = 0;
+_loop1_after_insert:
+	count = 0;
+	do {
+		ip -= 8;
+		count++;
+	} while (likely(ip > source_begin)
+		 && (get_unaligned_le64(ip) == wrk_literal[i]));
+	if (count == 1) {
+		count = 0;
+		ip += 8;
+		j = i + count;
+		do {
+			ip -= 8;
+			count++;
+			j++;
+		} while (likely(ip > source_begin)
+			 && (j < tree_size)
+			 && (get_unaligned_le64(ip) == wrk_literal[j]));
+		ip += 8;
+		count--;
+		if (likely(ip > source_begin)) {
+			do {
+				ip -= 8;
+				count++;
+				j = avl_insert(wrk_literal, wrk_tree,
+					       &tree_root,
+					       get_unaligned_le64(ip),
+					       &tree_size);
+				if (unlikely(tree_size > MAX_LITERALS)) {
+					/* not compressible */
+					return -EINVAL;
+				}
+			} while ((j == i + count) && likely(ip > source_begin));
+		}
+		while (unlikely(count > LENGTH_MASK)) {
+			put_unaligned_le16((i << OFFSET_SHIFT)
+					   + MATCH_BIT_MASK + LENGTH_MASK,
+					   op_match);
+			op_match += 2;
+			count -= LENGTH_MASK;
+			i += LENGTH_MASK;
+		}
+		put_unaligned_le16((i << OFFSET_SHIFT) + MATCH_BIT_MASK
+				   + count, op_match);
+		op_match += 2;
+		if (unlikely(ip <= source_begin))
+			goto _finish;
+		i = j;
+		goto _loop1_after_insert;
+	} else {
+		while (unlikely(count > LENGTH_MASK)) {
+			put_unaligned_le16((i << OFFSET_SHIFT) + LENGTH_MASK,
+					   op_match);
+			op_match += 2;
+			count -= LENGTH_MASK;
+		}
+		put_unaligned_le16((i << OFFSET_SHIFT) + count, op_match);
+		op_match += 2;
+	}
+	if (unlikely(ip <= source_begin))
+		goto _finish;
+	i = avl_insert(wrk_literal, wrk_tree, &tree_root,
+		       get_unaligned_le64(ip), &tree_size);
+	goto _loop1_after_insert;
+_finish:
+	j = avl_insert(wrk_literal, wrk_tree, &tree_root,
+		       get_unaligned_le64(ip), &tree_size);
+	put_unaligned_le16((j << OFFSET_SHIFT) + 1, op_match);
+	op_match += 2;
+	put_unaligned_le16(op_match - dest, dest);
+	put_unaligned_le16(source_length, dest + 2);
+	count = sizeof(u64) * (tree_size);
+	memcpy(op_match, wrk_literal, count);
+	return (op_match - dest) + count;
+}
+
+static __always_inline int decompress_bewalgo2(const u8 * const source,
+					       u8 * const dest,
+					       u16 * const wrkmem,
+					       const u16 source_length)
+{
+	const u8 * const source_end1 = source + source_length;
+	u8 *dest_anchor1 = dest;
+	const u8 *ip_match1 = source + 4;
+	const u8 *ip_match_end1 = source + get_unaligned_le16(source);
+	const u8 *ip_literal1 = ip_match_end1;
+	u16 i;
+	u16 count;
+	u64 tmp;
+	u8 *op1 = dest_anchor1
+		 + ((get_unaligned_le16(source + 2) + 0x7) & (~0x7)) - 8;
+
+	while (ip_match1 < ip_match_end1) {
+		i = (get_unaligned_le16(ip_match1) >> OFFSET_SHIFT) << 3;
+		count = get_unaligned_le16(ip_match1) & LENGTH_MASK;
+		if (get_unaligned_le16(ip_match1) & MATCH_BIT_MASK) {
+			if (unlikely(ip_literal1 + i
+				+ (count << 3) > source_end1)) {
+				/* input too small */
+				return -EINVAL;
+			}
+			while (count-- > 0) {
+				tmp = get_unaligned_le64(ip_literal1 + i);
+				i += 8;
+				put_unaligned_le64(tmp, op1);
+				op1 -= 8;
+			}
+		} else{
+			if (unlikely(ip_literal1 + i > source_end1)) {
+				/* input too small */
+				return -EINVAL;
+			}
+			while (count-- > 0) {
+				tmp = get_unaligned_le64(ip_literal1 + i);
+				put_unaligned_le64(tmp, op1);
+				op1 -= 8;
+			}
+		}
+		ip_match1 += 2;
+	}
+	return get_unaligned_le16(source + 2);
+}
+
+static int init_bewalgo2(void)
+{
+	return 0;
+}
+
+static void exit_bewalgo2(void)
+{
+}
+
+struct zbewalgo_alg alg_bewalgo2 = {
+	.name = "bewalgo2",
+	.flags = ZBEWALGO_ALG_FLAG_COMPRESS,
+	.wrkmem_size = 8192,
+	.init = init_bewalgo2,
+	.exit = exit_bewalgo2,
+	.compress = compress_bewalgo2,
+	.decompress = decompress_bewalgo2
+};
diff --git a/lib/zbewalgo/bewalgo2.h b/lib/zbewalgo/bewalgo2.h
new file mode 100644
index 000000000..18e2a0d9f
--- /dev/null
+++ b/lib/zbewalgo/bewalgo2.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_BEWALGO2_H
+#define ZBEWALGO_BEWALGO2_H
+
+#include "include.h"
+
+extern struct zbewalgo_alg alg_bewalgo2;
+
+#endif
diff --git a/lib/zbewalgo/bitshuffle.c b/lib/zbewalgo/bitshuffle.c
new file mode 100644
index 000000000..3efcfcecf
--- /dev/null
+++ b/lib/zbewalgo/bitshuffle.c
@@ -0,0 +1,104 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#include "bitshuffle.h"
+
+/*
+ * performs a static transformation on the data. Moves every eighth byte into
+ * a consecutive range
+ */
+static __always_inline int compress_bitshuffle(const u8 *source, u8 *dest,
+					       u16 * const wrkmem,
+					       const u16 source_length)
+{
+	u16 i;
+	const u16 source_length2 = (source_length + 0x7) & (~0x7);
+
+	put_unaligned_le16(source_length, dest);
+	dest += 2;
+	for (i = 0; i < source_length2; i += 8)
+		*dest++ = source[i];
+	for (i = 1; i < source_length2; i += 8)
+		*dest++ = source[i];
+	for (i = 2; i < source_length2; i += 8)
+		*dest++ = source[i];
+	for (i = 3; i < source_length2; i += 8)
+		*dest++ = source[i];
+	for (i = 4; i < source_length2; i += 8)
+		*dest++ = source[i];
+	for (i = 5; i < source_length2; i += 8)
+		*dest++ = source[i];
+	for (i = 6; i < source_length2; i += 8)
+		*dest++ = source[i];
+	for (i = 7; i < source_length2; i += 8)
+		*dest++ = source[i];
+	return source_length2 + 2;
+}
+
+/*
+ * reverses the transformation step
+ */
+static __always_inline int decompress_bitshuffle(const u8 *source, u8 *dest,
+						 u16 * const wrkmem,
+						 const u16 source_length)
+{
+	u16 i;
+	const u16 dest_length = get_unaligned_le16(source);
+	const u16 dest_length2 = ((dest_length + 0x7) & (~0x7));
+
+	if (source_length - 2 != dest_length2) {
+		/* data must be decompressed at once */
+		return -EINVAL;
+	}
+	source += 2;
+	for (i = 0; i < dest_length2; i += 8)
+		dest[i] = *source++;
+	for (i = 1; i < dest_length2; i += 8)
+		dest[i] = *source++;
+	for (i = 2; i < dest_length2; i += 8)
+		dest[i] = *source++;
+	for (i = 3; i < dest_length2; i += 8)
+		dest[i] = *source++;
+	for (i = 4; i < dest_length2; i += 8)
+		dest[i] = *source++;
+	for (i = 5; i < dest_length2; i += 8)
+		dest[i] = *source++;
+	for (i = 6; i < dest_length2; i += 8)
+		dest[i] = *source++;
+	for (i = 7; i < dest_length2; i += 8)
+		dest[i] = *source++;
+	return dest_length;
+}
+
+static int init_bitshuffle(void)
+{
+	return 0;
+}
+
+static void exit_bitshuffle(void)
+{
+}
+
+struct zbewalgo_alg alg_bitshuffle = {
+	.name = "bitshuffle",
+	.flags = ZBEWALGO_ALG_FLAG_TRANSFORM,
+	.wrkmem_size = 0,
+	.init = init_bitshuffle,
+	.exit = exit_bitshuffle,
+	.compress = compress_bitshuffle,
+	.decompress = decompress_bitshuffle
+};
diff --git a/lib/zbewalgo/bitshuffle.h b/lib/zbewalgo/bitshuffle.h
new file mode 100644
index 000000000..fc095be69
--- /dev/null
+++ b/lib/zbewalgo/bitshuffle.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_BITSHUFFLE_H
+#define ZBEWALGO_BITSHUFFLE_H
+
+#include "include.h"
+
+extern struct zbewalgo_alg alg_bitshuffle;
+
+#endif
diff --git a/lib/zbewalgo/huffman.c b/lib/zbewalgo/huffman.c
new file mode 100644
index 000000000..9693acb10
--- /dev/null
+++ b/lib/zbewalgo/huffman.c
@@ -0,0 +1,244 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#include "huffman.h"
+
+/*
+ * compression using the bare huffman encoding. Optimized for speed and small
+ * input buffers.
+ * wrkmem should be aligned by the caller to at least 4
+ */
+static __always_inline int compress_huffman(const u8 * const source,
+					    u8 * const dest, u16 * const wrkmem,
+					    const u16 source_length)
+{
+	const u8 * const source_end = source + source_length;
+	const u8 * const dest_end = dest + zbewalgo_max_output_size;
+	short * const nodes_index = (short *)(wrkmem);
+	u16 * const leaf_parent_index = wrkmem + 768;
+	u16 * const nodes_weight = wrkmem + 1024;
+	u16 * const frequency = wrkmem + 1536;
+	u16 * const code_lengths = wrkmem + 1792;
+	u32 * const code_words = (u32 *)(wrkmem + 2048);
+	short i;
+	u16 node_index;
+	int i2;
+	short max_codeword_length;
+	u32 weight2;
+	short num_nodes;
+	u32 bits_in_buffer;
+	u32 bits_in_stack;
+	u16 free_index;
+	const u8 *ip;
+	u8 *op;
+	u32 stack;
+	u8 * const stack_ptr = (u8 *)&stack;
+
+	memset(dest, 0, zbewalgo_max_output_size);
+	memset(wrkmem, 0, 5120);
+	op = dest;
+	ip = source;
+	put_unaligned_le16(source_length, dest);
+	do {
+		frequency[*ip++]++;
+	} while (ip < source_end);
+	ip = source;
+	num_nodes = 0;
+	for (i = 0; i < 256; i++) {
+		if (frequency[i] > 0) {
+			i2 = num_nodes++;
+			while ((i2 > 0) && (nodes_weight[i2] > frequency[i])) {
+				nodes_weight[i2 + 1] = nodes_weight[i2];
+				nodes_index[i2 + 1] = nodes_index[i2];
+				leaf_parent_index[nodes_index[i2]]++;
+				i2--;
+			}
+			i2++;
+			nodes_index[i2] = -(i + 1);
+			leaf_parent_index[-(i + 1)] = i2;
+			nodes_weight[i2] = frequency[i];
+		}
+	}
+	dest[2] = num_nodes;
+	op = dest + 3;
+	for (i = 1; i <= num_nodes; ++i) {
+		*op++ = -(nodes_index[i] + 1);
+		put_unaligned_le16(nodes_weight[i], op);
+		op += 2;
+	}
+	free_index = 2;
+	while (free_index <= num_nodes) {
+		weight2 = nodes_weight[free_index - 1]
+			+ nodes_weight[free_index];
+		i2 = num_nodes++;
+		while ((i2 > 0) && (nodes_weight[i2] > weight2)) {
+			nodes_weight[i2 + 1] = nodes_weight[i2];
+			nodes_index[i2 + 1] = nodes_index[i2];
+			leaf_parent_index[nodes_index[i2]]++;
+			i2--;
+		}
+		i2++;
+		nodes_index[i2] = free_index >> 1;
+		leaf_parent_index[free_index >> 1] = i2;
+		nodes_weight[i2] = weight2;
+		free_index += 2;
+	}
+	if (num_nodes > 400) {
+		/* not compressible */
+		return -EINVAL;
+	}
+	for (i = 0; i < 256; i++) {
+		if (frequency[i] == 0)
+			continue;
+		bits_in_stack = 0;
+		stack = 0;
+		node_index = leaf_parent_index[-(i + 1)];
+		while (node_index < num_nodes) {
+			stack |= (node_index & 0x1) << bits_in_stack;
+			bits_in_stack++;
+			node_index = leaf_parent_index[(node_index + 1) >> 1];
+		}
+		code_lengths[i] = bits_in_stack;
+		code_words[i] = stack;
+	}
+	max_codeword_length = 0;
+	node_index = leaf_parent_index[nodes_index[1]];
+	while (node_index < num_nodes) {
+		node_index = leaf_parent_index[(node_index + 1) >> 1];
+		max_codeword_length++;
+	}
+	if (max_codeword_length > 24) {
+		/* not encodeable with optimizations */
+		return -EINVAL;
+	}
+	bits_in_buffer = 0;
+	do {
+		bits_in_stack = code_lengths[*ip];
+		stack = code_words[*ip];
+		ip++;
+		bits_in_buffer += bits_in_stack;
+		stack = stack << (32 - bits_in_buffer);
+#ifdef __LITTLE_ENDIAN
+		op[0] |= stack_ptr[3];
+		op[1] |= stack_ptr[2];
+		op[2] |= stack_ptr[1];
+		op[3] |= stack_ptr[0];
+#else
+		op[0] |= stack_ptr[0];
+		op[1] |= stack_ptr[1];
+		op[2] |= stack_ptr[2];
+		op[3] |= stack_ptr[3];
+#endif
+		op += bits_in_buffer >> 3;
+		bits_in_buffer = bits_in_buffer & 0x7;
+		if (unlikely(op >= dest_end)) {
+			/* not compressible */
+			return -EINVAL;
+		}
+	} while (likely(ip < source_end));
+	return op - dest + (bits_in_buffer > 0);
+}
+
+/*
+ * reverses the huffman compression
+ */
+static __always_inline int decompress_huffman(const u8 * const source,
+					      u8 * const dest,
+					      u16 * const wrkmem,
+					      const u16 source_length)
+{
+	const u8 * const source_end = source + source_length;
+	const u32 dest_length = get_unaligned_le16(source);
+	const u8 * const dest_end = dest + dest_length;
+	short * const nodes_index = (short *)(wrkmem);
+	u16 * const nodes_weight = wrkmem + 512;
+	u32 i;
+	int node_index;
+	u32 i2;
+	u32 weight2;
+	u32 num_nodes;
+	u32 current_bit;
+	u32 free_index;
+	const u8 *ip;
+	u8 *op;
+
+	memset(wrkmem, 0, 2048);
+	num_nodes = source[2];
+	ip = source + 3;
+	op = dest;
+	if (unlikely(ip + 3 * num_nodes > source_end)) {
+		/* source_length too small */
+		return -EINVAL;
+	}
+	for (i = 1; i <= num_nodes; ++i) {
+		nodes_index[i] = -(*ip++ + 1);
+		nodes_weight[i] = get_unaligned_le16(ip);
+		ip += 2;
+	}
+	free_index = 2;
+	while (free_index <= num_nodes) {
+		weight2 = nodes_weight[free_index - 1]
+			+ nodes_weight[free_index];
+		i2 = num_nodes++;
+		while (i2 > 0 && nodes_weight[i2] > weight2) {
+			nodes_weight[i2 + 1] = nodes_weight[i2];
+			nodes_index[i2 + 1] = nodes_index[i2];
+			i2--;
+		}
+		i2++;
+		nodes_index[i2] = free_index >> 1;
+		nodes_weight[i2] = weight2;
+		free_index += 2;
+	}
+	current_bit = 0;
+	do {
+		node_index = nodes_index[num_nodes];
+		while (node_index > 0) {
+			if (current_bit == 8) {
+				ip++;
+				if (ip >= source_end) {
+					/* source_length too small */
+					return -EINVAL;
+				}
+			}
+			current_bit = ((current_bit) & 0x7) + 1;
+			node_index = nodes_index[(node_index << 1)
+				- ((*ip >> (8 - current_bit)) & 0x1)];
+		}
+		*op++ = -(node_index + 1);
+	} while (op < dest_end);
+	return dest_length;
+}
+
+static int init_huffman(void)
+{
+	return 0;
+}
+
+static void exit_huffman(void)
+{
+}
+
+struct zbewalgo_alg alg_huffman = {
+	.name = "huffman",
+	.flags = ZBEWALGO_ALG_FLAG_COMPRESS,
+	.wrkmem_size = 5120,
+	.init = init_huffman,
+	.exit = exit_huffman,
+	.compress = compress_huffman,
+	.decompress = decompress_huffman
+};
diff --git a/lib/zbewalgo/huffman.h b/lib/zbewalgo/huffman.h
new file mode 100644
index 000000000..2f7a10011
--- /dev/null
+++ b/lib/zbewalgo/huffman.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_HUFFMAN_H
+#define ZBEWALGO_HUFFMAN_H
+
+#include "include.h"
+
+extern struct zbewalgo_alg alg_huffman;
+
+#endif
diff --git a/lib/zbewalgo/include.h b/lib/zbewalgo/include.h
new file mode 100644
index 000000000..730f96579
--- /dev/null
+++ b/lib/zbewalgo/include.h
@@ -0,0 +1,103 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ */
+
+#ifndef ZBEWALGO_INCLUDE_H
+#define ZBEWALGO_INCLUDE_H
+
+#include "linux/module.h"
+#include "asm/unaligned.h"
+
+#define ZBEWALGO_ALG_MAX_NAME 128
+#define ZBEWALGO_ALG_FLAG_COMPRESS 1
+#define ZBEWALGO_ALG_FLAG_TRANSFORM 2
+#define ZBEWALGO_COMBINATION_MAX_IDS 7
+#define ZBEWALGO_MAX_BASE_ALGORITHMS 16
+#define ZBEWALGO_COMBINATION_MAX_ACTIVE 256
+
+/*
+ * __KERNEL_DIV_ROUND_UP(..) is not used since shifting is faster than dividing
+ * if the divisor is a power of 2.
+ */
+#define DIV_BY_8_ROUND_UP(val) ((val + 0x7) >> 3)
+
+struct zbewalgo_alg {
+	char name[ZBEWALGO_ALG_MAX_NAME];
+	/* flag wheather this algorithm compresses the data or
+	 * transforms the data only
+	 */
+	u8 flags;
+	/* the wrkmem required for this algorithm */
+	u32 wrkmem_size;
+	int (*init)(void);
+	void (*exit)(void);
+	/* the compression function must store the size of
+	 * input/output data itself
+	 */
+	int (*compress)(const u8 * const source, u8 * const dest,
+			u16 * const wrkmem, const u16 source_length);
+	int (*decompress)(const u8 * const source, u8 * const dest,
+			  u16 * const wrkmem, const u16 source_length);
+	u8 id;
+};
+
+/*
+ * to gain speed the compression starts with the algorithm which was good for
+ * the last compressed page.
+ */
+struct zbewalgo_combination {
+	u8 count;
+	u8 ids[ZBEWALGO_COMBINATION_MAX_IDS];
+};
+
+struct zbewalgo_main_data {
+	/*
+	 * best_id contains the id of the best combination for the last page
+	 */
+	u8 best_id;
+
+	/*
+	 * if zero search again for best_id - must be unsigned - underflow of
+	 * values is intended
+	 */
+	u8 counter_search;
+
+	/*
+	 * a bit larger than original compressed size to be still accepted
+	 * immediately
+	 */
+	u16 best_id_accepted_size;
+};
+
+/*
+ * compression aborts automatically if the compressed data is too large.
+ */
+extern unsigned long zbewalgo_max_output_size;
+
+/*
+ * add a combination to the current active ones. All combinations are the
+ * same for all instances of this algorithm
+ */
+int zbewalgo_add_combination(const char * const string,
+			     const int string_length);
+
+/*
+ * replace ALL combinations with the one specified.
+ */
+int zbewalgo_set_combination(const char * const string,
+			     const int string_length);
+
+#endif
diff --git a/lib/zbewalgo/zbewalgo.c b/lib/zbewalgo/zbewalgo.c
new file mode 100644
index 000000000..16640ddff
--- /dev/null
+++ b/lib/zbewalgo/zbewalgo.c
@@ -0,0 +1,628 @@
+/*
+ * Copyright (c) 2018 Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.
+ *
+ *
+ * zBeWalgo is a container compression algorithm, which can execute
+ * multiple different compression and transformation algorithms after each
+ * other. The execution of different compression algorithms after each other
+ * will be called 'combination' in this description and in the code.
+ * Additionally to be able to execute combinations of algorithms, zBeWalgo
+ * can try different combinations on the same input. This allows high
+ * compression ratios on completely different datasets, which would otherwise
+ * require its own algorithm each. Executing all known combinations on each
+ * input page would be very slow. Therefore the data is compressed at first
+ * with that combination, which was already successful on the last input
+ * page. If the compressed data size of the current page is similar to that
+ * of the last page, the compressed data is returned immediately without even
+ * trying the other combinations. Even if there is no guarantee that
+ * consecutive calls to the algorithm belong to each other, the speed
+ * improvement is obvious.
+ *
+ * ZRAM uses zsmalloc for the management of the compressed pages. The largest
+ * size-class in zsmalloc is 3264 Bytes. If the compressed data is larger than
+ * that threshold, ZRAM ignores the compression and writes the uncompressed
+ * page instead. As a consequence it is useless to continue compression, if the
+ * algorithm detects, that the data can not be compressed using the current
+ * combination. The threshold for aborting compression can be changed via
+ * sysfs at any time, even if the algorithm is currently in use. If a
+ * combination fails to compress the data, zBeWalgo tries the next
+ * combination. If no combination is able to reduce the data in size,
+ * zBeWalgo returns a negative value.
+ *
+ * Each combination consists of up to 7 compression and transformation steps.
+ * Combinations can be added and removed at any time via sysfs. Already
+ * compressed Data can always be decompressed, even if the combination used
+ * to produce it does not exist anymore. Technically the user could add up to
+ * 256 combinations concurrently, but that would be very time consuming if
+ * the data can not be compressed.
+ *
+ * To be able to build combinations and call different algorithms, all those
+ * algorithms are implementing the same interface. This enables the user to
+ * specify additional combinations while ZRAM is running.
+ */
+
+#include <linux/init.h>
+
+#include "include.h"
+
+#include "BWT.h"
+#include "JBE.h"
+#include "JBE2.h"
+#include "MTF.h"
+#include "RLE.h"
+#include "bewalgo.h"
+#include "bewalgo2.h"
+#include "bitshuffle.h"
+#include "huffman.h"
+
+static atomic64_t zbewalgo_stat_combination[256];
+static atomic64_t zbewalgo_stat_count[256];
+
+unsigned long zbewalgo_max_output_size;
+
+/*
+ * all currently available combination sequences of algorithms
+ */
+static struct zbewalgo_combination
+	zbewalgo_combinations[ZBEWALGO_COMBINATION_MAX_ACTIVE];
+static u8 zbewalgo_combinations_count;
+
+/*
+ * maximum required wrkmem for compression and decompression for each instance
+ * of the algorithm
+ */
+static u32 zbewalgo_wrkmem_size;
+
+/*
+ * compression can be aborted if the data is smaller than this threshold to
+ * speed up the algorithm.
+ */
+static u16 zbewalgo_early_abort_size;
+
+/*
+ * each cpu has its own independent compression history to avoid locks
+ */
+static struct zbewalgo_main_data __percpu *zbewalgo_main_data_ptr;
+
+/*
+ * all available algorithms
+ */
+static struct zbewalgo_alg
+	zbewalgo_base_algorithms[ZBEWALGO_MAX_BASE_ALGORITHMS];
+static u8 zbewalgo_base_algorithms_count;
+
+/*
+ * returns the required size of wrkmem for compression and decompression
+ */
+__always_inline int zbewalgo_get_wrkmem_size(void)
+{
+	return zbewalgo_wrkmem_size;
+}
+EXPORT_SYMBOL(zbewalgo_get_wrkmem_size);
+
+/*
+ * this function adds a combination to the set of enabled combinations or
+ * if 'flag' is set, replaces all combinations with the newly supplied one.
+ * this function is called from the sysfs context, and therefore accepts
+ * a string as input.
+ */
+static __always_inline int add_set_combination(const char * const string,
+					       const int string_length,
+					       int flag)
+{
+	/* points behind the string for fast looping over the entire string */
+	const char * const string_end = string + string_length;
+	/* the string up to 'anchor' is parsed */
+	const char *anchor = string;
+	const char *pos = string;
+	struct zbewalgo_combination combination;
+	u8 i;
+
+	memset(&combination, 0, sizeof(struct zbewalgo_combination));
+	/* loop over entire string */
+	while ((pos < string_end) && (*pos != 0)) {
+		while ((pos < string_end)
+		       && (*pos != 0)
+		       && (*pos != '-')
+		       && (*pos != '\n'))
+			pos++;
+		if (pos - anchor <= 0) {
+			/* skipp leading or consecutive '-' chars */
+			pos++;
+			anchor = pos;
+			continue;
+		}
+		/* find the algorithm by name in the list of all algorithms */
+		for (i = 0; i < zbewalgo_base_algorithms_count; i++) {
+			if (((unsigned int)(pos - anchor)
+			     == strlen(zbewalgo_base_algorithms[i].name))
+			    && (memcmp(anchor,
+				       zbewalgo_base_algorithms[i].name,
+				       pos - anchor)
+					 == 0)) {
+				/* found algorithm */
+				combination.ids[combination.count++] =
+					zbewalgo_base_algorithms[i].id;
+				break;
+			}
+		}
+		/*
+		 * abort parsing if maximum of algorithms reached or
+		 * if string is parsed completely
+		 */
+		if (combination.count >= ZBEWALGO_COMBINATION_MAX_IDS
+		    || (*pos != '-'))
+			goto _finalize;
+		if (i == zbewalgo_base_algorithms_count)
+			/* misstyped arguments */
+			return -EINVAL;
+		pos++;
+		anchor = pos;
+	}
+_finalize:
+	if (combination.count) {
+		/* if combination has at least 1 algorithm */
+		if (flag == 1)
+			zbewalgo_combinations_count = 0;
+		/* don't store the same combination twice */
+		for (i = 0; i < zbewalgo_combinations_count; i++)
+			if (memcmp(&zbewalgo_combinations[i], &combination,
+				   sizeof(struct zbewalgo_combination)) == 0) {
+				return 0;
+			}
+		/* store the new combination */
+		memcpy(&zbewalgo_combinations[zbewalgo_combinations_count],
+		       &combination, sizeof(struct zbewalgo_combination));
+		zbewalgo_combinations_count++;
+		return 0;
+	}
+	/* empty algorithm is not allowed */
+	return -EINVAL;
+}
+
+int zbewalgo_add_combination(const char * const string,
+			     const int string_length)
+{
+	return add_set_combination(string, string_length, 0);
+}
+EXPORT_SYMBOL(zbewalgo_add_combination);
+
+int zbewalgo_set_combination(const char * const string,
+			     const int string_length)
+{
+	return add_set_combination(string, string_length, 1);
+}
+EXPORT_SYMBOL(zbewalgo_set_combination);
+
+#define compress(i, j, s, d, w, l) \
+	(zbewalgo_base_algorithms[zbewalgo_combinations[i].ids[j]] \
+		.compress(s, d, w, l))
+
+__always_inline int zbewalgo_compress(const u8 * const source,
+	u8 * const dest, u16 * const wrkmem, const u16 source_length)
+{
+	struct zbewalgo_main_data * const main_data =
+		get_cpu_ptr(zbewalgo_main_data_ptr);
+	u16 * const wrkmem1 = PTR_ALIGN(wrkmem, 8);
+	u8 *dest_best = (u8 *)wrkmem1;
+	u8 *dest1 = (u8 *)(wrkmem1 + 4096);
+	u8 *dest2 = (u8 *)(wrkmem1 + 4096 * 2);
+	u16 * const wrk = wrkmem1 + 4096 * 3;
+	u8 *dest_tmp;
+	const u8 *current_source;
+	u8 i, j;
+	u16 dest_best_size = source_length << 1;
+	int dest_current_size;
+	u8 dest_best_id = 0;
+	u8 i_from = main_data->best_id
+		+ (main_data->counter_search-- == 0);
+	u8 i_to = zbewalgo_combinations_count;
+	u8 looped = 0;
+	u16 local_abort_size = max_t(u16,
+		main_data->best_id_accepted_size,
+		zbewalgo_early_abort_size);
+	u16 counter = 0;
+	struct zbewalgo_combination * const dest_best_combination =
+		(struct zbewalgo_combination *)dest;
+	if (source_length > 4096) {
+		/*
+		 * This algorithm is optimized for small data buffers
+		 * and can not handle larger inputs.
+		 */
+		return -EINVAL;
+	}
+_begin:
+	/*
+	 * loop over zbewalgo_combinations_count starting with the last
+	 * successful combination
+	 */
+	i = i_from;
+	while (i < i_to) {
+		current_source	  = source;
+		dest_current_size = source_length;
+		counter++;
+		for (j = 0; j < zbewalgo_combinations[i].count; j++) {
+			dest_current_size = compress(i, j,
+						     current_source,
+				dest2,
+				wrk,
+				dest_current_size);
+			if (dest_current_size <= 0)
+				goto _next_algorithm;
+			current_source = dest2;
+			dest_tmp = dest2;
+			dest2 = dest1;
+			dest1 = dest_tmp;
+			if (dest_current_size < dest_best_size) {
+				/*
+				 * if a higher compression ratio is found,
+				 * update to the best
+				 */
+				dest_best_id = i;
+				dest_best_size = dest_current_size;
+				dest_tmp = dest_best;
+				dest_best = dest1;
+				dest1 = dest_tmp;
+				memcpy(dest_best_combination,
+				       &zbewalgo_combinations[i],
+				       sizeof(struct zbewalgo_combination));
+				/*
+				 * partial combination is allowed, if its
+				 * compression ratio is high
+				 */
+				dest_best_combination->count = j + 1;
+			}
+		}
+_next_algorithm:
+		if (dest_best_size < local_abort_size)
+			goto _early_abort;
+		local_abort_size = zbewalgo_early_abort_size;
+		i++;
+	}
+	if (!(looped++) && i_from > 0) {
+		i_to = min_t(u8, i_from, zbewalgo_combinations_count);
+		i_from = 0;
+		goto _begin;
+	}
+	if (dest_best_size > zbewalgo_max_output_size) {
+		/* not compressible */
+		return -EINVAL;
+	}
+_early_abort:
+	atomic64_inc(&zbewalgo_stat_combination[dest_best_id]);
+	atomic64_inc(&zbewalgo_stat_count[counter]);
+	main_data->best_id = dest_best_id;
+	main_data->best_id_accepted_size =
+		max_t(u16,
+		      dest_best_size + (dest_best_size >> 3),
+			zbewalgo_early_abort_size);
+	memcpy(dest + sizeof(struct zbewalgo_combination),
+	       dest_best, dest_best_size);
+	return sizeof(struct zbewalgo_combination) + dest_best_size;
+}
+EXPORT_SYMBOL(zbewalgo_compress);
+
+#define decompress(i, s, d, w, l) \
+	(zbewalgo_base_algorithms[combination->ids[i]] \
+		.decompress(s, d, w, l))
+
+__always_inline int zbewalgo_decompress(const u8 * const source,
+	u8 * const dest, u16 * const wrkmem, const u16 source_length)
+{
+	u16 * const wrkmem1 = PTR_ALIGN(wrkmem, 8);
+	u8 *dest1 = (u8 *)wrkmem1;
+	u8 *dest2 = (u8 *)(wrkmem1 + 4096);
+	u16 *wrk = wrkmem1 + 4096 * 2;
+	const struct zbewalgo_combination * const combination =
+		(struct zbewalgo_combination *)source;
+	u8 j;
+	short res;
+
+	if (source_length < sizeof(struct zbewalgo_combination) + 1) {
+		/* input too small */
+		return -EINVAL;
+	}
+
+	if (combination->count == 1) {
+		res = decompress(0,
+				 (source + sizeof(struct zbewalgo_combination)),
+			dest,
+			wrk,
+			source_length - sizeof(struct zbewalgo_combination));
+		return res;
+	}
+	res = decompress(combination->count - 1,
+			 (source + sizeof(struct zbewalgo_combination)),
+		dest1,
+		wrk,
+		source_length - sizeof(struct zbewalgo_combination));
+	if (res < 0)
+		return res;
+	for (j = combination->count - 2; j > 1; j -= 2) {
+		res = decompress(j, dest1, dest2, wrk, res);
+		if (res < 0)
+			return res;
+		res = decompress(j - 1, dest2, dest1, wrk, res);
+		if (res < 0)
+			return res;
+	}
+	if (j == 1) {
+		res = decompress(1, dest1, dest2, wrk, res);
+		if (res < 0)
+			return res;
+		res = decompress(0, dest2, dest, wrk, res);
+		return res;
+	}
+	res = decompress(0, dest1, dest, wrk, res);
+	return res;
+}
+EXPORT_SYMBOL(zbewalgo_decompress);
+
+#define add_combination_compile_time(name) \
+	zbewalgo_add_combination(name, sizeof(name))
+
+static ssize_t zbewalgo_combinations_show(struct kobject *kobj,
+					  struct kobj_attribute *attr,
+					  char *buf)
+{
+	ssize_t res = 0;
+	ssize_t tmp;
+	u8 i, j;
+	struct zbewalgo_combination *com;
+
+	tmp = scnprintf(buf, PAGE_SIZE - res, "combinations={\n");
+	res = tmp;
+	buf += tmp;
+	for (i = 0; i < zbewalgo_combinations_count; i++) {
+		com = &zbewalgo_combinations[i];
+		res += tmp = scnprintf(buf, PAGE_SIZE - res,
+				       "\tcombination[%d]=", i);
+		buf += tmp;
+		for (j = 0; j < com->count - 1; j++) {
+			res += tmp = scnprintf(buf, PAGE_SIZE - res, "%s-",
+				zbewalgo_base_algorithms[com->ids[j]].name);
+			buf += tmp;
+		}
+		res += tmp = scnprintf(buf, PAGE_SIZE - res, "%s\n",
+			zbewalgo_base_algorithms[com->ids[j]].name);
+		buf += tmp;
+	}
+	res += tmp = scnprintf(buf, PAGE_SIZE - res, "}\n");
+	return res;
+}
+
+static __always_inline void zbewalgo_combinations_reset(void)
+{
+	zbewalgo_combinations_count = 0;
+	add_combination_compile_time("bewalgo2-bitshuffle-jbe-rle");
+	add_combination_compile_time("bwt-mtf-bewalgo-huffman");
+	add_combination_compile_time("bitshuffle-bewalgo2-mtf-bewalgo-jbe");
+	add_combination_compile_time("bitshuffle-rle-bitshuffle-rle");
+}
+
+static ssize_t zbewalgo_combinations_store(struct kobject *kobj,
+					   struct kobj_attribute *attr,
+					   const char *buf, size_t count)
+{
+	ssize_t res;
+
+	if (count < 5) {
+		/* input too short */
+		return -EINVAL;
+	}
+	if (memcmp(buf, "add ", 4) == 0) {
+		res = zbewalgo_add_combination(buf + 4, count - 4);
+		return res < 0 ? res : count;
+	}
+	if (memcmp(buf, "set ", 4) == 0) {
+		res = zbewalgo_set_combination(buf + 4, count - 4);
+		return res < 0 ? res : count;
+	}
+	if (memcmp(buf, "reset", 5) == 0) {
+		zbewalgo_combinations_reset();
+		return count;
+	}
+	return -EINVAL;
+}
+
+static ssize_t zbewalgo_max_output_size_show(struct kobject *kobj,
+					     struct kobj_attribute *attr,
+					     char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%lu", zbewalgo_max_output_size);
+}
+
+static ssize_t zbewalgo_max_output_size_store(struct kobject *kobj,
+					      struct kobj_attribute *attr,
+					      const char *buf, size_t count)
+{
+	char localbuf[10];
+	ssize_t res;
+
+	memcpy(&localbuf[0], buf, count < 10 ? count : 10);
+	localbuf[count < 9 ? count : 9] = 0;
+	res = kstrtoul(localbuf, 10, &zbewalgo_max_output_size);
+	return res < 0 ? res : count;
+}
+
+static ssize_t zbewalgo_early_abort_size_show(struct kobject *kobj,
+					      struct kobj_attribute *attr,
+char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%u", zbewalgo_early_abort_size);
+}
+
+static ssize_t zbewalgo_early_abort_size_store(struct kobject *kobj,
+					       struct kobj_attribute *attr,
+					       const char *buf, size_t count)
+{
+	char localbuf[10];
+	ssize_t res;
+	unsigned long tmp;
+
+	memcpy(&localbuf[0], buf, count < 10 ? count : 10);
+	localbuf[count < 9 ? count : 9] = 0;
+	res = kstrtoul(localbuf, 10, &tmp);
+	zbewalgo_early_abort_size = tmp;
+	return res < 0 ? res : count;
+}
+
+static ssize_t zbewalgo_bwt_max_alphabet_show(struct kobject *kobj,
+					      struct kobj_attribute *attr,
+					      char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%lu", zbewalgo_bwt_max_alphabet);
+}
+
+static ssize_t zbewalgo_bwt_max_alphabet_store(struct kobject *kobj,
+					       struct kobj_attribute *attr,
+					       const char *buf, size_t count)
+{
+	char localbuf[10];
+	ssize_t res;
+
+	memcpy(&localbuf[0], buf, count < 10 ? count : 10);
+	localbuf[count < 9 ? count : 9] = 0;
+	res = kstrtoul(localbuf, 10, &zbewalgo_bwt_max_alphabet);
+	return res < 0 ? res : count;
+}
+
+static struct kobj_attribute zbewalgo_combinations_attribute =
+	__ATTR(combinations, 0664, zbewalgo_combinations_show,
+	       zbewalgo_combinations_store);
+static struct kobj_attribute zbewalgo_max_output_size_attribute =
+	__ATTR(max_output_size, 0664, zbewalgo_max_output_size_show,
+	       zbewalgo_max_output_size_store);
+static struct kobj_attribute zbewalgo_early_abort_size_attribute =
+	__ATTR(early_abort_size, 0664, zbewalgo_early_abort_size_show,
+	       zbewalgo_early_abort_size_store);
+static struct kobj_attribute zbewalgo_bwt_max_alphabet_attribute =
+	__ATTR(bwt_max_alphabet, 0664, zbewalgo_bwt_max_alphabet_show,
+	       zbewalgo_bwt_max_alphabet_store);
+static struct attribute *attrs[] = {
+	&zbewalgo_combinations_attribute.attr,
+	&zbewalgo_max_output_size_attribute.attr,
+	&zbewalgo_early_abort_size_attribute.attr,
+	&zbewalgo_bwt_max_alphabet_attribute.attr,
+	NULL,
+};
+
+static struct attribute_group attr_group = {
+	.attrs = attrs,
+};
+
+static struct kobject *zbewalgo_kobj;
+
+static int __init zbewalgo_mod_init(void)
+{
+	u16 i;
+	int j;
+	int res = 0;
+
+	zbewalgo_early_abort_size = 400;
+	/*
+	 * this algorithm is intended to be used for zram with zsmalloc.
+	 * Therefore zbewalgo_max_output_size equals zsmalloc max size class
+	 */
+	i = 0;
+	zbewalgo_max_output_size =
+		3264 /* largest reported size_class by zsmalloc */
+		 - (sizeof(unsigned long)) /* zsmalloc internal overhead */
+		 - sizeof(struct zbewalgo_combination);/* zbewalgo overhead */
+	zbewalgo_base_algorithms[i++] = alg_bewalgo;
+	zbewalgo_base_algorithms[i++] = alg_bewalgo2;
+	zbewalgo_base_algorithms[i++] = alg_bitshuffle;
+	zbewalgo_base_algorithms[i++] = alg_bwt;
+	zbewalgo_base_algorithms[i++] = alg_jbe;
+	zbewalgo_base_algorithms[i++] = alg_jbe2;
+	zbewalgo_base_algorithms[i++] = alg_mtf;
+	zbewalgo_base_algorithms[i++] = alg_rle;
+	zbewalgo_base_algorithms[i++] = alg_huffman;
+	zbewalgo_base_algorithms_count = i;
+	/*
+	 * the wrkmem size is the largest wrkmem required by any callable
+	 * algorithm
+	 */
+	zbewalgo_wrkmem_size = 0;
+	for (i = 0; i < zbewalgo_base_algorithms_count; i++) {
+		res = zbewalgo_base_algorithms[i].init();
+		if (res < 0) {
+			if (i > 0)
+				zbewalgo_base_algorithms[0].exit();
+			i--;
+			while (i > 0)
+				zbewalgo_base_algorithms[i].exit();
+			return res;
+		}
+		zbewalgo_base_algorithms[i].id = i;
+		zbewalgo_wrkmem_size = max_t(u32,
+					     zbewalgo_wrkmem_size,
+			zbewalgo_base_algorithms[i].wrkmem_size);
+	}
+	/* adding some pages for temporary compression results */
+	zbewalgo_wrkmem_size += 4096 * 6;
+	zbewalgo_wrkmem_size += 8;/* for alignment */
+	zbewalgo_main_data_ptr = alloc_percpu(struct zbewalgo_main_data);
+	for_each_possible_cpu(j) {
+		memset(per_cpu_ptr(zbewalgo_main_data_ptr, j),
+		       0, sizeof(struct zbewalgo_main_data));
+	}
+	for (i = 0; i < 256; i++) {
+		atomic64_set(&zbewalgo_stat_combination[i], 0);
+		atomic64_set(&zbewalgo_stat_count[i], 0);
+	}
+
+	zbewalgo_kobj = kobject_create_and_add("zbewalgo", kernel_kobj);
+	if (!zbewalgo_kobj) {
+		/* allocation error */
+		return -ENOMEM;
+	}
+	res = sysfs_create_group(zbewalgo_kobj, &attr_group);
+	if (res)
+		kobject_put(zbewalgo_kobj);
+	zbewalgo_combinations_reset();
+	return res;
+}
+
+static void __exit zbewalgo_mod_fini(void)
+{
+	u16 i;
+	u64 tmp;
+
+	kobject_put(zbewalgo_kobj);
+	for (i = 0; i < zbewalgo_base_algorithms_count; i++)
+		zbewalgo_base_algorithms[i].exit();
+	free_percpu(zbewalgo_main_data_ptr);
+	/* log statistics via printk for debugging purpose */
+	for (i = 0; i < 256; i++) {
+		tmp = atomic64_read(&zbewalgo_stat_combination[i]);
+		if (tmp > 0)
+			printk(KERN_INFO "%s %4d -> %llu combination\n",
+			       __func__, i, tmp);
+	}
+	for (i = 0; i < 256; i++) {
+		tmp = atomic64_read(&zbewalgo_stat_count[i]);
+		if (tmp > 0)
+			printk(KERN_INFO "%s %4d -> %llu counter\n",
+			       __func__, i, tmp);
+	}
+}
+
+module_init(zbewalgo_mod_init);
+module_exit(zbewalgo_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("zBeWalgo Compression Algorithm");
+
-- 
2.14.1
