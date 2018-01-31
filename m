From: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Subject: Re: Subject: [PATCH] crypto: add zbewalgo compression algorithm for
 zram
Date: Wed, 31 Jan 2018 07:40:34 +0100
Message-ID: <360D7326-8FF2-45A8-9FCA-53796768C5D0@informatik.uni-hamburg.de>
References: <450300D8-6A7C-4D63-971A-AB6279C3B3DD@informatik.uni-hamburg.de>
 <2893047.8sTGZPTY3e@tauon.chronox.de>
 <C1EF6641-08EB-436C-AD2A-F2581A5BE3FE@informatik.uni-hamburg.de>
 <11497171.7hPfTiqTsK@positron.chronox.de>
 <AD307ECF-E18F-402B-83DE-9A12496653E8@informatik.uni-hamburg.de>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org
To: =?utf-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:58858 "EHLO
        mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751399AbeAaGkl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 01:40:41 -0500
In-Reply-To: <AD307ECF-E18F-402B-83DE-9A12496653E8@informatik.uni-hamburg.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I modified my code as suggested by Stephan and Eric.

Moving the code from the header files into *.c source files slowed down the compression and decompression speed by a factor of up to 20.
I made no changes to the code itself, that would explain, why it is so much slower.

Signed-off-by: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>

---
 crypto/Kconfig            |   8 +
 crypto/Makefile           |   1 +
 crypto/zbewalgo.c         | 208 ++++++++++++++++
 include/linux/zbewalgo.h  |  59 +++++
 lib/Kconfig               |   3 +
 lib/Makefile              |   1 +
 lib/zbewalgo/BWT.c        | 111 +++++++++
 lib/zbewalgo/BWT.h        |  34 +++
 lib/zbewalgo/JBE.c        | 131 ++++++++++
 lib/zbewalgo/JBE.h        |  26 ++
 lib/zbewalgo/JBE2.c       | 135 +++++++++++
 lib/zbewalgo/JBE2.h       |  26 ++
 lib/zbewalgo/MTF.c        |  98 ++++++++
 lib/zbewalgo/MTF.h        |  26 ++
 lib/zbewalgo/Makefile     |   4 +
 lib/zbewalgo/RLE.c        | 130 ++++++++++
 lib/zbewalgo/RLE.h        |  26 ++
 lib/zbewalgo/bewalgo.c    | 369 +++++++++++++++++++++++++++++
 lib/zbewalgo/bewalgo.h    |  26 ++
 lib/zbewalgo/bewalgo2.c   | 385 ++++++++++++++++++++++++++++++
 lib/zbewalgo/bewalgo2.h   |  26 ++
 lib/zbewalgo/bitshuffle.c | 101 ++++++++
 lib/zbewalgo/bitshuffle.h |  26 ++
 lib/zbewalgo/huffman.c    | 227 ++++++++++++++++++
 lib/zbewalgo/huffman.h    |  26 ++
 lib/zbewalgo/include.h    | 106 +++++++++
 lib/zbewalgo/zbewalgo.c   | 590 ++++++++++++++++++++++++++++++++++++++++++++++
 27 files changed, 2909 insertions(+)
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
index b44c0ae04..f63f543e9 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1667,6 +1667,14 @@ config CRYPTO_LZ4
 	help
 	  This is the LZ4 algorithm.
 
+config CRYPTO_ZBEWALGO
+	tristate "ZBeWalgo compression algorithm"
+	select CRYPTO_ALGAPI
+	select CRYPTO_ACOMP2
+	select ZBEWALGO_COMPRESS
+	help
+	  This is the ZBeWalgo algorithm.
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
diff --git a/crypto/zbewalgo.c b/crypto/zbewalgo.c
new file mode 100644
index 000000000..3d12f9cdf
--- /dev/null
+++ b/crypto/zbewalgo.c
@@ -0,0 +1,208 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
+static int __zbewalgo_compress_crypto(
+	const u8 *src,
+	unsigned int slen,
+	u8 *dst,
+	unsigned int *dlen,
+	void *ctx)
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
+static int zbewalgo_scompress(
+	struct crypto_scomp *tfm,
+	const u8 *src,
+	unsigned int slen,
+	u8 *dst,
+	unsigned int *dlen,
+	void *ctx)
+{
+	return __zbewalgo_compress_crypto(src, slen, dst, dlen, ctx);
+}
+
+static int zbewalgo_compress_crypto(
+	struct crypto_tfm *tfm,
+	const u8 *src,
+	unsigned int slen,
+	u8 *dst,
+	unsigned int *dlen)
+{
+	struct zbewalgo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __zbewalgo_compress_crypto(
+		src,
+		slen,
+		dst,
+		dlen,
+		ctx->zbewalgo_comp_mem);
+}
+
+static int __zbewalgo_decompress_crypto(
+	const u8 *src,
+	unsigned int slen,
+	u8 *dst,
+	unsigned int *dlen,
+	void *ctx)
+{
+	int out_len;
+
+	out_len = zbewalgo_decompress(src, dst, ctx);
+	if (out_len < 0)
+		return -EINVAL;
+	return 0;
+}
+
+static int zbewalgo_sdecompress(
+	struct crypto_scomp *tfm,
+	const u8 *src,
+	unsigned int slen,
+	u8 *dst,
+	unsigned int *dlen,
+	void *ctx)
+{
+	return __zbewalgo_decompress_crypto(src, slen, dst, dlen, ctx);
+}
+
+static int zbewalgo_decompress_crypto(
+	struct crypto_tfm *tfm,
+	const u8 *src,
+	unsigned int slen,
+	u8 *dst,
+	unsigned int *dlen)
+{
+	struct zbewalgo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __zbewalgo_decompress_crypto(
+		src,
+		slen,
+		dst,
+		dlen,
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
+MODULE_DESCRIPTION("ZBeWalgo Compression Algorithm");
+MODULE_ALIAS_CRYPTO("zbewalgo");
diff --git a/include/linux/zbewalgo.h b/include/linux/zbewalgo.h
new file mode 100644
index 000000000..6b0de177b
--- /dev/null
+++ b/include/linux/zbewalgo.h
@@ -0,0 +1,59 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
+ * given, the resulting data might be corrupt.
+ * If the data is not compressible the function returns -1. Otherwise the
+ * size of the compressed data is returned.
+ * wrkmem must point to a memory region of at least the size returned by
+ * 'zbewalgo_get_wrkmem_size'.
+ */
+int zbewalgo_compress(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem,
+	const uint16_t source_length);
+
+/*
+ * this function decompresses data which was already successfully compressed
+ * with 'zbewalgo_compress'.
+ * the function decompresses the data given by 'source' into the preallocated
+ * buffer 'dest'.
+ * wrkmem must point to a memory region of at least the size returned by
+ * 'zbewalgo_get_wrkmem_size'.
+ * the wrkmem for compression and decompression dont need to be the same
+ */
+int zbewalgo_decompress(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem);
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index c5e84fbcb..ad72aeacc 100644
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
index d11c48ec8..a6a65c183 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -120,6 +120,7 @@ obj-$(CONFIG_LZO_DECOMPRESS) += lzo/
 obj-$(CONFIG_LZ4_COMPRESS) += lz4/
 obj-$(CONFIG_LZ4HC_COMPRESS) += lz4/
 obj-$(CONFIG_LZ4_DECOMPRESS) += lz4/
+obj-$(CONFIG_ZBEWALGO_COMPRESS) += zbewalgo/
 obj-$(CONFIG_ZSTD_COMPRESS) += zstd/
 obj-$(CONFIG_ZSTD_DECOMPRESS) += zstd/
 obj-$(CONFIG_XZ_DEC) += xz/
diff --git a/lib/zbewalgo/BWT.c b/lib/zbewalgo/BWT.c
new file mode 100644
index 000000000..56920a9d1
--- /dev/null
+++ b/lib/zbewalgo/BWT.c
@@ -0,0 +1,111 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include "BWT.h"
+
+/*
+ * implementation of the Burrows-Wheeler transformation. Optimized for speed
+ * and small input sizes
+ */
+static __always_inline int compress_bwt(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem,
+	const uint16_t source_length)
+{
+	uint16_t * const C = (uint16_t *) wrkmem;
+	uint16_t i;
+	uint16_t alphabet;
+	uint8_t * const op = dest + 3;
+	*dest = source[source_length - 1];
+	*((uint16_t *) (dest + 1)) = source_length;
+	memset(C, 0, 512);
+	for (i = 0; i < source_length; i++)
+		C[source[i]]++;
+	alphabet = (C[0] > 0);
+	for (i = 1; i < 256; i++) {
+		alphabet += (C[i] > 0);
+		C[i] += C[i - 1];
+	}
+	if (alphabet > zbewalgo_bwt_max_alphabet)
+		return -1;
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
+	return source_length + 3;
+}
+
+/*
+ * reverses the transformation
+ */
+static __always_inline int decompress_bwt(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem)
+{
+	const uint16_t dest_length = *((uint16_t *) (source + 1));
+	uint16_t * const C = (uint16_t *) wrkmem;
+	uint8_t * const L = wrkmem + 512;
+	uint8_t key = *source;
+	uint8_t *dest_end = dest + dest_length;
+	const uint8_t *ip = source + 3;
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
index 000000000..76262e239
--- /dev/null
+++ b/lib/zbewalgo/BWT.h
@@ -0,0 +1,34 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
index 000000000..4bf4de609
--- /dev/null
+++ b/lib/zbewalgo/JBE.c
@@ -0,0 +1,131 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include "JBE.h"
+
+/*
+ * Implementation of the J-Bit encoding as published by
+ * 'I Made Agus Dwi Suarjaya' 2012
+ */
+static __always_inline int compress_jbe(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem,
+	const uint16_t source_length)
+{
+	uint64_t source_tmp;
+	uint8_t tmp;
+	const uint64_t *source_end = (uint64_t *) (source + source_length);
+	const uint64_t *ip = (uint64_t *) source;
+	uint8_t *dataI = dest + 2;
+	uint8_t *dataII = dataI + DIV_BY_8_ROUND_UP(source_length);
+	uint8_t * const source_tmp_ptr = (uint8_t *) (&source_tmp);
+	*(uint16_t *) dest = source_length;
+	do {
+		source_tmp = *ip++;
+		tmp = source_tmp_ptr[0] > 0;
+		*dataII = source_tmp_ptr[0];
+		*dataI = tmp << 7;
+		dataII += tmp;
+		tmp = source_tmp_ptr[1] > 0;
+		*dataII = source_tmp_ptr[1];
+		*dataI |= tmp << 6;
+		dataII += tmp;
+		tmp = source_tmp_ptr[2] > 0;
+		*dataII = source_tmp_ptr[2];
+		*dataI |= tmp << 5;
+		dataII += tmp;
+		tmp = source_tmp_ptr[3] > 0;
+		*dataII = source_tmp_ptr[3];
+		*dataI |= tmp << 4;
+		dataII += tmp;
+		tmp = source_tmp_ptr[4] > 0;
+		*dataII = source_tmp_ptr[4];
+		*dataI |= tmp << 3;
+		dataII += tmp;
+		tmp = source_tmp_ptr[5] > 0;
+		*dataII = source_tmp_ptr[5];
+		*dataI |= tmp << 2;
+		dataII += tmp;
+		tmp = source_tmp_ptr[6] > 0;
+		*dataII = source_tmp_ptr[6];
+		*dataI |= tmp << 1;
+		dataII += tmp;
+		tmp = source_tmp_ptr[7] > 0;
+		*dataII = source_tmp_ptr[7];
+		*dataI |= tmp;
+		dataII += tmp;
+		dataI++;
+	} while (ip < source_end);
+	return dataII - dest;
+}
+
+static __always_inline int decompress_jbe(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem)
+{
+	uint64_t dest_tmp;
+	const uint16_t dest_length = *(uint16_t *) source;
+	const uint8_t *dataI = source + 2;
+	const uint8_t *dataII = dataI + DIV_BY_8_ROUND_UP(dest_length);
+	const uint64_t *dest_end = (uint64_t *) (dest + dest_length);
+	uint8_t * const dest_tmp_ptr = (uint8_t *) (&dest_tmp);
+	uint64_t *op = (uint64_t *) dest;
+
+	do {
+		dest_tmp_ptr[0] = ((*dataI & 0x80) ? *dataII : 0);
+		dataII += (*dataI & 0x80) > 0;
+		dest_tmp_ptr[1] = ((*dataI & 0x40) ? *dataII : 0);
+		dataII += (*dataI & 0x40) > 0;
+		dest_tmp_ptr[2] = ((*dataI & 0x20) ? *dataII : 0);
+		dataII += (*dataI & 0x20) > 0;
+		dest_tmp_ptr[3] = ((*dataI & 0x10) ? *dataII : 0);
+		dataII += (*dataI & 0x10) > 0;
+		dest_tmp_ptr[4] = ((*dataI & 0x08) ? *dataII : 0);
+		dataII += (*dataI & 0x08) > 0;
+		dest_tmp_ptr[5] = ((*dataI & 0x04) ? *dataII : 0);
+		dataII += (*dataI & 0x04) > 0;
+		dest_tmp_ptr[6] = ((*dataI & 0x02) ? *dataII : 0);
+		dataII += (*dataI & 0x02) > 0;
+		dest_tmp_ptr[7] = ((*dataI & 0x01) ? *dataII : 0);
+		dataII += (*dataI & 0x01) > 0;
+		dataI++;
+		*op++ = dest_tmp;
+	} while (op < dest_end);
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
index 000000000..5bc766ac5
--- /dev/null
+++ b/lib/zbewalgo/JBE.h
@@ -0,0 +1,26 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
index 000000000..51f828c46
--- /dev/null
+++ b/lib/zbewalgo/JBE2.c
@@ -0,0 +1,135 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include "JBE2.h"
+
+/*
+ * Variant of the J-Bit encoding published by 'I Made Agus Dwi Suarjaya' 2012
+ */
+static __always_inline int compress_jbe2(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem,
+	const uint16_t source_length)
+{
+	uint64_t source_tmp;
+	uint8_t tmp;
+	const uint64_t *source_end = (uint64_t *) (source + source_length);
+	const uint64_t *ip = (uint64_t *) source;
+	uint8_t *dataI = dest + 2;
+	uint8_t *dataII = dataI + DIV_BY_8_ROUND_UP(source_length);
+	uint8_t * const source_tmp_ptr = (uint8_t *) (&source_tmp);
+	*(uint16_t *) dest = source_length;
+	do {
+		source_tmp = *ip++;
+		source_tmp = (source_tmp & 0xF0F0F0F00F0F0F0F)
+			  | ((source_tmp & 0x0F0F0F0F00000000) >> 28)
+			  | ((source_tmp & 0x00000000F0F0F0F0) << 28);
+		tmp = source_tmp_ptr[0] > 0;
+		*dataII = source_tmp_ptr[0];
+		*dataI = tmp << 7;
+		dataII += tmp;
+		tmp = source_tmp_ptr[1] > 0;
+		*dataII = source_tmp_ptr[1];
+		*dataI |= tmp << 6;
+		dataII += tmp;
+		tmp = source_tmp_ptr[2] > 0;
+		*dataII = source_tmp_ptr[2];
+		*dataI |= tmp << 5;
+		dataII += tmp;
+		tmp = source_tmp_ptr[3] > 0;
+		*dataII = source_tmp_ptr[3];
+		*dataI |= tmp << 4;
+		dataII += tmp;
+		tmp = source_tmp_ptr[4] > 0;
+		*dataII = source_tmp_ptr[4];
+		*dataI |= tmp << 3;
+		dataII += tmp;
+		tmp = source_tmp_ptr[5] > 0;
+		*dataII = source_tmp_ptr[5];
+		*dataI |= tmp << 2;
+		dataII += tmp;
+		tmp = source_tmp_ptr[6] > 0;
+		*dataII = source_tmp_ptr[6];
+		*dataI |= tmp << 1;
+		dataII += tmp;
+		tmp = source_tmp_ptr[7] > 0;
+		*dataII = source_tmp_ptr[7];
+		*dataI |= tmp;
+		dataII += tmp;
+		dataI++;
+	} while (ip < source_end);
+	return dataII - dest;
+}
+
+static __always_inline int decompress_jbe2(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem)
+{
+	uint64_t dest_tmp;
+	const uint16_t dest_length = *(uint16_t *) source;
+	const uint8_t *dataI = source + 2;
+	const uint8_t *dataII = dataI + DIV_BY_8_ROUND_UP(dest_length);
+	const uint64_t *dest_end = (uint64_t *) (dest + dest_length);
+	uint8_t * const dest_tmp_ptr = (uint8_t *) (&dest_tmp);
+	uint64_t *op = (uint64_t *) dest;
+
+	do {
+		dest_tmp_ptr[0] = ((*dataI & 0x80) ? *dataII : 0);
+		dataII += (*dataI & 0x80) > 0;
+		dest_tmp_ptr[1] = ((*dataI & 0x40) ? *dataII : 0);
+		dataII += (*dataI & 0x40) > 0;
+		dest_tmp_ptr[2] = ((*dataI & 0x20) ? *dataII : 0);
+		dataII += (*dataI & 0x20) > 0;
+		dest_tmp_ptr[3] = ((*dataI & 0x10) ? *dataII : 0);
+		dataII += (*dataI & 0x10) > 0;
+		dest_tmp_ptr[4] = ((*dataI & 0x08) ? *dataII : 0);
+		dataII += (*dataI & 0x08) > 0;
+		dest_tmp_ptr[5] = ((*dataI & 0x04) ? *dataII : 0);
+		dataII += (*dataI & 0x04) > 0;
+		dest_tmp_ptr[6] = ((*dataI & 0x02) ? *dataII : 0);
+		dataII += (*dataI & 0x02) > 0;
+		dest_tmp_ptr[7] = ((*dataI & 0x01) ? *dataII : 0);
+		dataII += (*dataI & 0x01) > 0;
+		dataI++;
+		dest_tmp = (dest_tmp & 0xF0F0F0F00F0F0F0F)
+			| ((dest_tmp & 0x0F0F0F0F00000000) >> 28)
+			| ((dest_tmp & 0x00000000F0F0F0F0) << 28);
+		*op++ = dest_tmp;
+	} while (op < dest_end);
+	return dest_length;
+}
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
index 000000000..54da22f2a
--- /dev/null
+++ b/lib/zbewalgo/JBE2.h
@@ -0,0 +1,26 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
index 000000000..a40b63575
--- /dev/null
+++ b/lib/zbewalgo/MTF.c
@@ -0,0 +1,98 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include "MTF.h"
+
+/*
+ * Move To Front encoding
+ */
+static __always_inline int compress_mtf(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem,
+	const uint16_t source_length)
+{
+	const uint8_t *source_end = source + source_length;
+	const uint8_t *ip = source;
+	uint8_t *op = dest + 2;
+	uint16_t i;
+	uint8_t tmp;
+	*(uint16_t *) dest = source_length;
+	for (i = 0; i < 256; i++)
+		wrkmem[i] = i;
+	do {
+		i = 0;
+		while (wrkmem[i] != *ip)
+			i++;
+		ip++;
+		*op++ = i;
+		tmp = wrkmem[i];
+		while (i > 0) {
+			wrkmem[i] = wrkmem[i - 1];
+			i--;
+		}
+		wrkmem[0] = tmp;
+	} while (ip < source_end);
+	return source_length + 2;
+}
+
+static __always_inline int decompress_mtf(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem)
+{
+	const uint16_t dest_length = *(uint16_t *) source;
+	uint8_t *dest_end = dest + dest_length;
+	uint16_t i;
+	uint8_t tmp;
+	const uint8_t *ip = source + 2;
+	uint8_t *op = dest;
+
+	for (i = 0; i < 256; i++)
+		wrkmem[i] = i;
+	do {
+		i = *ip++;
+		*op++ = wrkmem[i];
+		tmp = wrkmem[i];
+		while (i > 0) {
+			wrkmem[i] = wrkmem[i - 1];
+			i--;
+		}
+		wrkmem[0] = tmp;
+	} while (op < dest_end);
+	return dest_length;
+}
+
+static int init_mtf(void)
+{
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
+	.wrkmem_size = 1 << 8,
+	.init = init_mtf,
+	.exit = exit_mtf,
+	.compress = compress_mtf,
+	.decompress = decompress_mtf
+};
diff --git a/lib/zbewalgo/MTF.h b/lib/zbewalgo/MTF.h
new file mode 100644
index 000000000..cc2f2a612
--- /dev/null
+++ b/lib/zbewalgo/MTF.h
@@ -0,0 +1,26 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
index 000000000..dc015a01b
--- /dev/null
+++ b/lib/zbewalgo/Makefile
@@ -0,0 +1,4 @@
+ccflags-y += -O3 -fno-tree-vrp -Werror
+
+obj-$(CONFIG_ZBEWALGO_COMPRESS) += zbewalgo_compress.o
+zbewalgo_compress-objs := zbewalgo.o bewalgo.o bewalgo2.o bitshuffle.o BWT.o huffman.o JBE.o JBE2.o MTF.o RLE.o
diff --git a/lib/zbewalgo/RLE.c b/lib/zbewalgo/RLE.c
new file mode 100644
index 000000000..b2d35b434
--- /dev/null
+++ b/lib/zbewalgo/RLE.c
@@ -0,0 +1,130 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include "RLE.h"
+
+#define RLE_REPEAT 0x80
+#define RLE_SIMPLE 0x00
+#define RLE_MAX_LENGTH ((1 << 7) - 1)
+
+
+/*
+ * Run Length Encoder
+ */
+static __always_inline int compress_rle(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem,
+	const uint16_t source_length)
+{
+	const uint8_t *anchor = source;
+	const uint8_t *source_end = source + source_length;
+	unsigned int count;
+	uint8_t lastval;
+	uint8_t *op = dest + 2;
+	const uint8_t *ip = source;
+	*((uint16_t *) dest) = source_length;
+	while (1) {
+		// RLE_SIMPLE
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
+		// RLE_REPEAT
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
+static __always_inline int decompress_rle(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem)
+{
+	const uint16_t source_length = *((uint16_t *) source);
+	const uint8_t *dest_end = dest + source_length;
+	unsigned int length;
+	const uint8_t *ip = source + 2;
+	uint8_t *op = dest;
+
+	do {
+		if ((*ip & RLE_REPEAT) == RLE_REPEAT) {
+			length = *ip++ - RLE_REPEAT + 1;
+			memset(op, *ip++, length);
+			op += length;
+		} else {
+			length = *ip++ - RLE_SIMPLE + 1;
+			memcpy(op, ip, length);
+			ip += length;
+			op += length;
+		}
+	} while (op < dest_end);
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
index 000000000..09a806ab4
--- /dev/null
+++ b/lib/zbewalgo/RLE.h
@@ -0,0 +1,26 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
index 000000000..34833a2f7
--- /dev/null
+++ b/lib/zbewalgo/bewalgo.c
@@ -0,0 +1,369 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
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
+#define BEWALGO_HASH_SIZE_uint32_t (1 << BEWALGO_HASHLOG)
+struct bewalgo_compress_internal {
+	uint32_t table[BEWALGO_HASH_SIZE_uint32_t];
+};
+
+#define bewalgo_copy_helper_src(dest, src, target) \
+do { \
+	while ((src) < (target) - 3) { \
+		(dest)[0] = (src)[0]; \
+		(dest)[1] = (src)[1]; \
+		(dest)[2] = (src)[2]; \
+		(dest)[3] = (src)[3]; \
+		(dest) += 4; \
+		(src) += 4; \
+	} \
+	if ((src) < (target) - 1) { \
+		(dest)[0] = (src)[0]; \
+		(dest)[1] = (src)[1]; \
+		(dest) += 2; \
+		(src) += 2; \
+	} \
+	if ((src) < (target)) \
+		*(dest)++ = *(src)++; \
+} while (0)
+
+static __always_inline int decompress_bewalgo(
+	const uint8_t * const source_,
+	uint8_t * const dest_,
+	uint8_t * const wrkmem)
+{
+	const uint64_t * const source = (const uint64_t *) source_;
+	uint64_t * const dest = (uint64_t *) dest_;
+	const uint64_t *ip;
+	uint64_t *match;
+	uint64_t *op;
+	const uint64_t *dest_end_ptr;
+	const uint8_t *controll_block_ptr;
+	const uint64_t *target;
+	uint32_t to_read;
+	uint32_t avail;
+	const uint16_t dest_length = *(uint16_t *) source;
+	const uint32_t dest_end = DIV_BY_8_ROUND_UP(dest_length);
+
+	ip = (uint64_t *) (((uint8_t *) source) + 2);
+	controll_block_ptr = (uint8_t *) ip;
+	match = op = dest;
+	dest_end_ptr = dest_end + dest;
+	do {
+		if (unlikely(dest_end_ptr <= op))
+			goto _last_control_block;
+		controll_block_ptr = (uint8_t *) ip;
+		ip++;
+		target = ip + controll_block_ptr[0];
+		bewalgo_copy_helper_src(op, ip, target);
+		match = op - ((uint16_t *) controll_block_ptr)[1];
+		target = match + controll_block_ptr[1];
+		bewalgo_copy_helper_src(op, match, target);
+		target = ip + controll_block_ptr[4];
+		bewalgo_copy_helper_src(op, ip, target);
+		match = op - ((uint16_t *) controll_block_ptr)[3];
+		target = match + controll_block_ptr[5];
+		bewalgo_copy_helper_src(op, match, target);
+	} while (1);
+_last_control_block:
+	to_read = controll_block_ptr[0];
+	avail = dest_end_ptr - op;
+	target = ip + min_t(uint32_t, to_read, avail);
+	bewalgo_copy_helper_src(op, ip, target);
+	match = op - ((uint16_t *) controll_block_ptr)[1];
+	to_read = controll_block_ptr[1];
+	avail = dest_end_ptr - op;
+	target = match + min_t(uint32_t, to_read, avail);
+	bewalgo_copy_helper_src(op, match, target);
+	to_read = controll_block_ptr[4];
+	avail = dest_end_ptr - op;
+	target = ip + min_t(uint32_t, to_read, avail);
+	bewalgo_copy_helper_src(op, ip, target);
+	match = op - ((uint16_t *) controll_block_ptr)[3];
+	to_read = controll_block_ptr[5];
+	avail = dest_end_ptr - op;
+	target = match + min_t(uint32_t, to_read, avail);
+	bewalgo_copy_helper_src(op, match, target);
+	return (op - dest) << 3;
+}
+
+static __always_inline uint32_t bewalgo_compress_hash(uint64_t sequence)
+{
+	return (uint32_t) (
+		((sequence >> 24) * 11400714785074694791ULL)
+		 >> (64 - BEWALGO_HASHLOG));
+}
+
+static __always_inline int compress_bewalgo_(
+	struct bewalgo_compress_internal *wrkmem,
+	const uint64_t * const source,
+	uint64_t * const dest,
+	const uint16_t source_length,
+	uint8_t acceleration)
+{
+	const int acceleration_start =
+		(acceleration < 4 ? 32 >> acceleration : 4);
+	const uint64_t * const dest_end_ptr =
+		dest + zbewalgo_max_output_size;
+	const uint32_t source_end =
+		(source_length >> 3) + ((source_length & 7) > 0);
+	const uint64_t * const source_end_ptr = source + source_end;
+	const uint64_t * const source_end_ptr_1 = source_end_ptr - 1;
+	const uint64_t *match = source;
+	const uint64_t *anchor = source;
+	const uint64_t *ip = source;
+	uint64_t *op = (uint64_t *) (((uint8_t *) dest) + 2);
+	uint8_t *op_control = NULL;
+	uint32_t op_control_available = 0;
+	const uint64_t *target;
+	int length;
+	uint16_t offset;
+	uint32_t h;
+	int j;
+	int tmp_literal_length;
+	int match_nodd;
+	int match_nzero_nodd;
+	*(uint16_t *) dest = source_length;
+	memset(wrkmem, 0, sizeof(struct bewalgo_compress_internal));
+	h = bewalgo_compress_hash(*ip);
+	wrkmem->table[h] = 0;
+	do {
+		j = acceleration_start;
+		length = source_end_ptr_1 - ip;
+		j = j < length ? j : length;
+		for (length = 1; length <= j; length++) {
+			ip++;
+			h = bewalgo_compress_hash(*ip);
+			match = source + wrkmem->table[h];
+			wrkmem->table[h] = ip - source;
+			if (*(uint64_t *) match == *(uint64_t *) ip)
+				goto _find_match_left;
+		}
+		length = acceleration_start
+			+ (acceleration << BEWALGO_SKIPTRIGGER);
+		ip++;
+		do {
+			if (unlikely(ip >= source_end_ptr))
+				goto _encode_last_literal;
+			h = bewalgo_compress_hash(*ip);
+			match = source + wrkmem->table[h];
+			wrkmem->table[h] = ip - source;
+			if (*(uint64_t *) match == *(uint64_t *) ip)
+				goto _find_match_left;
+			ip += (length++ >> BEWALGO_SKIPTRIGGER);
+		} while (1);
+_find_match_left:
+		while ((match != source) && (match[-1] == ip[-1])) {
+			ip--;
+			match--;
+			if (ip == anchor)
+				goto _find_match_right;
+		}
+		length = ip - anchor;
+		tmp_literal_length = length
+			- (op_control_available ? BEWALGO_LENGTH_MAX : 0);
+		if (unlikely(op
+			 + ((tmp_literal_length / (BEWALGO_LENGTH_MAX * 2)))
+			 + ((tmp_literal_length % (BEWALGO_LENGTH_MAX * 2)) > 0)
+			 + length > dest_end_ptr)) {
+			goto _error;
+		}
+		while (length > BEWALGO_LENGTH_MAX) {
+			if (op_control_available == 0) {
+				op_control = (uint8_t *) op;
+				*op++ = 0;
+			}
+			op_control_available = !op_control_available;
+			*op_control = BEWALGO_LENGTH_MAX;
+			op_control += 4;
+			target = anchor + BEWALGO_LENGTH_MAX;
+			bewalgo_copy_helper_src(op, anchor, target);
+			length -= BEWALGO_LENGTH_MAX;
+		}
+		if (likely(length > 0)) {
+			if (op_control_available == 0) {
+				op_control = (uint8_t *) op;
+				*op++ = 0;
+			}
+			op_control_available = !op_control_available;
+			*op_control = length;
+			op_control += 4;
+			bewalgo_copy_helper_src(op, anchor, ip);
+		}
+_find_match_right:
+		do {
+			ip++;
+			match++;
+		} while ((ip < source_end_ptr) && (*match == *ip));
+		length = ip - anchor;
+		offset = ip - match;
+		anchor = ip;
+		if (length > BEWALGO_LENGTH_MAX) {
+			uint32_t control_match_value =
+				(BEWALGO_LENGTH_MAX << 8) | (offset << 16);
+			size_t match_length_div_255 = length / 255;
+			size_t match_length_mod_255 = length % 255;
+			uint32_t match_zero = match_length_mod_255 == 0;
+			uint32_t match_nzero = !match_zero;
+			int control_blocks_needed = match_length_div_255
+				+ match_nzero
+				- op_control_available;
+			if (unlikely((op
+					+ (control_blocks_needed >> 1)
+					+ (control_blocks_needed & 1)
+					) > dest_end_ptr))
+				goto _error;
+			op_control = op_control_available > 0
+				? op_control
+				: (uint8_t *) op;
+			*((uint32_t *) op_control) = control_match_value;
+			match_length_div_255 -= op_control_available > 0;
+			match_nodd = !(match_length_div_255 & 1);
+			match_nzero_nodd = match_nzero && match_nodd;
+			if (match_length_div_255 > 0) {
+				uint64_t control_match_value_long =
+					control_match_value
+					| (((uint64_t) control_match_value)
+						<< 32);
+				target = op
+					+ (match_length_div_255 >> 1)
+					+ (match_length_div_255 & 1);
+				do {
+					*op++ = control_match_value_long;
+				} while (op < target);
+			}
+			op_control = ((uint8_t *) op) - 4;
+			*(uint32_t *) (op_control
+				+ (match_nzero_nodd << 3)) = 0;
+			*(uint32_t *) (op_control
+				+ (match_nzero_nodd << 2)) = 0;
+			*(op_control + (match_nzero_nodd << 2) + 1) =
+				(match_zero & match_nodd)
+				 ? BEWALGO_LENGTH_MAX
+				 : match_length_mod_255;
+			*(uint16_t *) (op_control
+				+ (match_nzero_nodd << 2) + 2) = offset;
+			op_control += match_nzero_nodd << 3;
+			op += match_nzero_nodd;
+			op_control_available =
+				(match_length_div_255 & 1) == match_zero;
+		} else {
+			if (unlikely((op_control_available == 0)
+				&& (op >= dest_end_ptr)
+				&& (op_control[-3] != 0)))
+				goto _error;
+			if (op_control[-3] != 0) {
+				if (op_control_available == 0) {
+					op_control = (uint8_t *) op;
+					*op++ = 0;
+				}
+				op_control_available = !op_control_available;
+				op_control += 4;
+			}
+			op_control[-3] = length;
+			((uint16_t *) op_control)[-1] = offset;
+		}
+		if (unlikely(ip == source_end_ptr))
+			goto _finish;
+		h = bewalgo_compress_hash(*ip);
+		match = source + wrkmem->table[h];
+		wrkmem->table[h] = ip - source;
+		if (*(uint64_t *) match == *(uint64_t *) ip)
+			goto _find_match_right;
+	} while (1);
+_encode_last_literal:
+	length = source_end_ptr - anchor;
+	tmp_literal_length = length
+		- (op_control_available ? BEWALGO_LENGTH_MAX : 0);
+	if (op
+		+ ((tmp_literal_length / (BEWALGO_LENGTH_MAX * 2)))
+		+ ((tmp_literal_length % (BEWALGO_LENGTH_MAX * 2)) > 0)
+		+ length > dest_end_ptr)
+		goto _error;
+	while (length > BEWALGO_LENGTH_MAX) {
+		if (op_control_available == 0) {
+			op_control = (uint8_t *) op;
+			*op++ = 0;
+		}
+		op_control_available = !op_control_available;
+		*op_control = BEWALGO_LENGTH_MAX;
+		op_control += 4;
+		target = anchor + BEWALGO_LENGTH_MAX;
+		bewalgo_copy_helper_src(op, anchor, target);
+		length -= BEWALGO_LENGTH_MAX;
+	}
+	if (length > 0) {
+		if (op_control_available == 0) {
+			op_control = (uint8_t *) op;
+			*op++ = 0;
+		}
+		op_control_available = !op_control_available;
+		*op_control = length;
+		op_control += 4;
+		bewalgo_copy_helper_src(op, anchor, source_end_ptr);
+	}
+_finish:
+	return ((uint8_t *) op) - ((uint8_t *) dest);
+_error:
+	return -1;
+}
+
+static __always_inline int compress_bewalgo(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem,
+	const uint16_t source_length)
+{
+	return compress_bewalgo_(
+		(struct bewalgo_compress_internal *) wrkmem,
+		(const uint64_t *) source,
+		(uint64_t *) dest,
+		source_length, 1);
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
+	.wrkmem_size = sizeof(struct bewalgo_compress_internal),
+	.init = init_bewalgo,
+	.exit = exit_bewalgo,
+	.compress = compress_bewalgo,
+	.decompress = decompress_bewalgo
+};
diff --git a/lib/zbewalgo/bewalgo.h b/lib/zbewalgo/bewalgo.h
new file mode 100644
index 000000000..c8e0f163b
--- /dev/null
+++ b/lib/zbewalgo/bewalgo.h
@@ -0,0 +1,26 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
index 000000000..12027c623
--- /dev/null
+++ b/lib/zbewalgo/bewalgo2.c
@@ -0,0 +1,385 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include "bewalgo2.h"
+
+#define MAX_LITERALS ((zbewalgo_max_output_size >> 3) - 4)
+
+#define OFFSET_BITS 9
+#define OFFSET_SHIFT (16 - OFFSET_BITS)
+#define MATCH_BIT_SHIFT 6
+#define MATCH_BIT_MASK (1 << MATCH_BIT_SHIFT)
+#define LENGTH_BITS 6
+#define LENGTH_MASK ((1 << LENGTH_BITS) - 1)
+#define LEFT 0
+#define RIGHT 1
+#define NEITHER 2
+#define TREE_NODE_NULL 0xffff
+
+
+/*
+ * insert first node into an empty avl-tree
+ * the function returns the index of the node in the preallocated array
+ */
+static __always_inline int avl_insert_first(
+	uint64_t *wrk_literal,
+	uint16_t *wrk_tree,
+	uint16_t *treep,
+	uint64_t target,
+	uint16_t *treesize)
+{
+	uint16_t g_a_tree, g_o_tree2;
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
+static __always_inline int avl_insert(
+	uint64_t *wrk_literal,
+	uint16_t *wrk_tree,
+	uint16_t *treep,
+	uint64_t target,
+	uint16_t *treesize)
+{
+	uint16_t *path_top[2];
+	uint16_t g_a_tree, g_o_tree2, g_o_next_step;
+	uint16_t r_1_arr[10];
+	uint16_t path, path2, first[2], second;
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
+ */
+static __always_inline int compress_bewalgo2(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem,
+	const uint16_t source_length)
+{
+	const uint64_t * const source_begin = (const uint64_t *) source;
+	uint64_t *wrk_literal = (uint64_t *) wrkmem;
+	uint16_t *wrk_tree = (uint16_t *) (wrkmem + PAGE_SIZE);
+	uint16_t *op_match = (uint16_t *) (dest + 4);
+	int count;
+	uint16_t i;
+	uint16_t j;
+	uint16_t tree_root = TREE_NODE_NULL;
+	uint16_t tree_size = 0;
+	const uint64_t *ip = ((const uint64_t *) source)
+		+ DIV_BY_8_ROUND_UP(source_length) - 1;
+
+	/*
+	 * add first value into the tree
+	 */
+	i = avl_insert_first(
+		wrk_literal,
+		wrk_tree,
+		&tree_root,
+		*ip,
+		&tree_size);
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
+			avl_insert(
+				wrk_literal,
+				wrk_tree,
+				&tree_root,
+				ip[-i],
+				&tree_size);
+		if (tree_size < 6)
+			goto _start;
+		/*
+		 * verify that there are at most 12 different values
+		 * at the first 10 and last 10 positions
+		 */
+		for (i = 0; i < 10; i++)
+			avl_insert(
+				wrk_literal,
+				wrk_tree,
+				&tree_root,
+				source_begin[i],
+				&tree_size);
+		if (tree_size < 13)
+			goto _start;
+		/*
+		 * if the previous conditions do not pass, check some bytes
+		 * in the middle for matches.
+		 * if not enough matches found abort
+		 */
+		for (i = 0; i < 10; i++)
+			avl_insert(
+				wrk_literal,
+				wrk_tree,
+				&tree_root,
+				source_begin[256 + i],
+				&tree_size);
+		if (tree_size >= 21)
+			return -1;
+	}
+_start:
+	i = 0;
+_loop1_after_insert:
+	count = 0;
+	do {
+		ip--;
+		count++;
+	} while (likely(ip > source_begin) && (*ip == wrk_literal[i]));
+	if (count == 1) {
+		count = 0;
+		ip++;
+		j = i + count;
+		do {
+			ip--;
+			count++;
+			j++;
+		} while (likely(ip > source_begin)
+			&& (j < tree_size)
+			&& (*ip == wrk_literal[j]));
+		ip++;
+		count--;
+		if (likely(ip > source_begin)) {
+			do {
+				ip--;
+				count++;
+				j = avl_insert(
+					wrk_literal,
+					wrk_tree,
+					&tree_root,
+					*ip,
+					&tree_size);
+				if (unlikely(tree_size > MAX_LITERALS))
+					return -1;
+			} while ((j == i + count)
+				&& likely(ip > source_begin));
+		}
+		while (unlikely(count > LENGTH_MASK)) {
+			*op_match++ = (i << OFFSET_SHIFT)
+				+ MATCH_BIT_MASK
+				+ LENGTH_MASK;
+			count -= LENGTH_MASK;
+			i += LENGTH_MASK;
+		}
+		*op_match++ = (i << OFFSET_SHIFT) + MATCH_BIT_MASK + count;
+		if (unlikely(ip <= source_begin))
+			goto _finish;
+		i = j;
+		goto _loop1_after_insert;
+	} else {
+		while (unlikely(count > LENGTH_MASK)) {
+			*op_match++ = (i << OFFSET_SHIFT) + LENGTH_MASK;
+			count -= LENGTH_MASK;
+		}
+		*op_match++ = (i << OFFSET_SHIFT) + count;
+	}
+	if (unlikely(ip <= source_begin))
+		goto _finish;
+	i = avl_insert(wrk_literal, wrk_tree, &tree_root, *ip, &tree_size);
+	goto _loop1_after_insert;
+_finish:
+	j = avl_insert(wrk_literal, wrk_tree, &tree_root, *ip, &tree_size);
+	*op_match++ = (j << OFFSET_SHIFT) + 1;
+	((uint16_t *) dest)[0] = op_match - ((uint16_t *) dest);
+	((uint16_t *) dest)[1] = source_length;
+	count = sizeof(uint64_t) * (tree_size);
+	memcpy(op_match, wrk_literal, count);
+	return ((op_match - ((uint16_t *) dest)) << 1) + count;
+}
+
+/*
+ * decompress the data and return the uncompressed length
+ */
+static __always_inline int decompress_bewalgo2(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem)
+{
+	uint64_t *dest_anchor = (uint64_t *) dest;
+	const uint16_t *ip_match = ((const uint16_t *) (source + 4));
+	const uint16_t *ip_match_end =
+		((const uint16_t *) source) + ((const uint16_t *) source)[0];
+	const uint64_t *ip_literal = (uint64_t *) ip_match_end;
+	uint16_t i;
+	uint16_t count;
+	uint64_t *op = dest_anchor
+		+ DIV_BY_8_ROUND_UP(((uint16_t *) source)[1]) - 1;
+
+	while (ip_match < ip_match_end) {
+		i = (*ip_match) >> OFFSET_SHIFT;
+		count = (*ip_match) & LENGTH_MASK;
+		if ((*ip_match) & MATCH_BIT_MASK)
+			while (count-- > 0)
+				*op-- = ip_literal[i++];
+		else
+			while (count-- > 0)
+				*op-- = ip_literal[i];
+		ip_match++;
+	}
+	return ((const uint16_t *) source)[1];
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
+	.wrkmem_size = 4096 << 1,
+	.init = init_bewalgo2,
+	.exit = exit_bewalgo2,
+	.compress = compress_bewalgo2,
+	.decompress = decompress_bewalgo2
+};
diff --git a/lib/zbewalgo/bewalgo2.h b/lib/zbewalgo/bewalgo2.h
new file mode 100644
index 000000000..b4438ff47
--- /dev/null
+++ b/lib/zbewalgo/bewalgo2.h
@@ -0,0 +1,26 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
index 000000000..5661cbfd4
--- /dev/null
+++ b/lib/zbewalgo/bitshuffle.c
@@ -0,0 +1,101 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include "bitshuffle.h"
+
+/*
+ * performs a static transformation on the data. Moves every eighth byte into
+ * a consecutive range
+ */
+static __always_inline int compress_bitshuffle(
+	const uint8_t *source, uint8_t *dest,
+	uint8_t * const wrkmem,
+	uint16_t source_length)
+{
+	uint16_t i;
+	*((uint16_t *) dest) = source_length;
+	dest += 2;
+	source_length = (source_length + 7) & (~7);
+	for (i = 0; i < source_length; i += 8)
+		*dest++ = source[i];
+	for (i = 1; i < source_length; i += 8)
+		*dest++ = source[i];
+	for (i = 2; i < source_length; i += 8)
+		*dest++ = source[i];
+	for (i = 3; i < source_length; i += 8)
+		*dest++ = source[i];
+	for (i = 4; i < source_length; i += 8)
+		*dest++ = source[i];
+	for (i = 5; i < source_length; i += 8)
+		*dest++ = source[i];
+	for (i = 6; i < source_length; i += 8)
+		*dest++ = source[i];
+	for (i = 7; i < source_length; i += 8)
+		*dest++ = source[i];
+	return source_length + 2;
+}
+
+/*
+ * reverses the transformation step
+ */
+static __always_inline int decompress_bitshuffle(
+	const uint8_t *source,
+	uint8_t *dest,
+	uint8_t * const wrkmem)
+{
+	uint16_t i;
+	uint16_t dest_length = *((uint16_t *) source);
+	uint16_t dest_length2 = (dest_length + 7) & (~7);
+
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
index 000000000..0f1783cb5
--- /dev/null
+++ b/lib/zbewalgo/bitshuffle.h
@@ -0,0 +1,26 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
index 000000000..3eb814b5e
--- /dev/null
+++ b/lib/zbewalgo/huffman.c
@@ -0,0 +1,227 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#include "huffman.h"
+
+/*
+ * compression using the bare huffman encoding. Optimized for speed and small
+ * input buffers
+ */
+static __always_inline int compress_huffman(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem,
+	const uint16_t source_length)
+{
+	const uint8_t * const source_end = source + source_length;
+	const uint8_t * const dest_end = dest + zbewalgo_max_output_size;
+	short * const nodes_index = (short *) (wrkmem);
+	uint16_t * const leaf_parent_index = (uint16_t *) (wrkmem + 1536);
+	uint16_t * const nodes_weight = (uint16_t *) (wrkmem + 2048);
+	uint16_t * const frequency = (uint16_t *) (wrkmem + 3072);
+	uint16_t * const code_lengths = (uint16_t *) (wrkmem + 3584);
+	uint32_t * const code_words = (uint32_t *) (wrkmem + 4096);
+	short i;
+	uint16_t node_index;
+	int i2;
+	short max_codeword_length;
+	uint32_t weight2;
+	short num_nodes;
+	uint32_t bits_in_buffer;
+	uint32_t bits_in_stack;
+	uint16_t free_index;
+	const uint8_t *ip;
+	uint8_t *op;
+	uint32_t stack;
+#ifdef __LITTLE_ENDIAN
+	uint8_t * const stack_ptr = (uint8_t *) &stack;
+#endif
+	memset(dest, 0, zbewalgo_max_output_size);
+	memset(wrkmem, 0, 5120);
+	op = dest;
+	ip = source;
+	*(uint16_t *) dest = source_length;
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
+		*(uint16_t *) op = nodes_weight[i];
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
+	if (num_nodes > 400)
+		return -1;
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
+	if (max_codeword_length > 24)
+		return -1;
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
+		*(uint32_t *) op |= stack;
+#endif
+		op += bits_in_buffer >> 3;
+		bits_in_buffer = bits_in_buffer & 0x7;
+		if (unlikely(op >= dest_end))
+			return -1;
+	} while (likely(ip < source_end));
+	return op - dest + (bits_in_buffer > 0);
+}
+
+/*
+ * reverses the huffman compression
+ */
+static __always_inline int decompress_huffman(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem)
+{
+	const uint32_t dest_length = *(uint16_t *) source;
+	const uint8_t * const dest_end = dest + dest_length;
+	short * const nodes_index = (short *) (wrkmem);
+	uint16_t * const nodes_weight = (uint16_t *) (wrkmem + 1024);
+	uint32_t i;
+	int node_index;
+	uint32_t i2;
+	uint32_t weight2;
+	uint32_t num_nodes;
+	uint32_t current_bit;
+	uint32_t free_index;
+	const uint8_t *ip;
+	uint8_t *op;
+
+	memset(wrkmem, 0, 2048);
+	num_nodes = source[2];
+	ip = source + 3;
+	op = dest;
+	for (i = 1; i <= num_nodes; ++i) {
+		nodes_index[i] = -(*ip++ + 1);
+		nodes_weight[i] = *(uint16_t *) ip;
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
+			ip += current_bit == 8;
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
index 000000000..cd1ae8100
--- /dev/null
+++ b/lib/zbewalgo/huffman.h
@@ -0,0 +1,26 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
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
index 000000000..f6b9475b5
--- /dev/null
+++ b/lib/zbewalgo/include.h
@@ -0,0 +1,106 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
+ */
+
+#ifndef ZBEWALGO_INCLUDE_H
+#define ZBEWALGO_INCLUDE_H
+
+#include "linux/module.h"
+
+#define ZBEWALGO_ALG_MAX_NAME 128
+#define ZBEWALGO_ALG_FLAG_COMPRESS 1
+#define ZBEWALGO_ALG_FLAG_TRANSFORM 2
+#define ZBEWALGO_COMBINATION_MAX_IDS 7
+#define ZBEWALGO_MAX_BASE_ALGORITHMS 16
+#define ZBEWALGO_COMBINATION_MAX_ACTIVE 256
+
+#define DIV_BY_8_ROUND_UP(val) ((val >> 3) + ((val & 0x7) > 0))
+
+struct zbewalgo_alg {
+	char name[ZBEWALGO_ALG_MAX_NAME];
+	/* flag wheether this algorithm compresses the data or
+	 * transforms the data only
+	 */
+	uint8_t flags;
+	/* the wrkmem required for this algorithm */
+	uint32_t wrkmem_size;
+	int (*init)(void);
+	void (*exit)(void);
+	/* the compression function must store the size of
+	 * input/output data itself
+	 */
+	int (*compress)(
+		const uint8_t * const source,
+		uint8_t * const dest,
+		uint8_t * const wrkmem,
+		const uint16_t source_length);
+	int (*decompress)(
+		const uint8_t * const source,
+		uint8_t * const dest,
+		uint8_t * const wrkmem);
+	uint8_t id;
+};
+
+/*
+ * to gain speed the compression starts with the algorithm wich was good for
+ * the last compressed page.
+ */
+struct zbewalgo_combination {
+	uint8_t count;
+	uint8_t ids[ZBEWALGO_COMBINATION_MAX_IDS];
+};
+
+struct zbewalgo_main_data {
+	/*
+	 * best_id contains the id of the best combination for the last page
+	 */
+	uint8_t best_id;
+
+	/*
+	 * if zero search again for best_id - must be unsigned - underflow of
+	 * values is intended
+	 */
+	uint8_t counter_search;
+
+	/*
+	 * a bit larger than original compressed size to be still accepted
+	 * immediately
+	 */
+	uint16_t best_id_accepted_size;
+};
+
+/*
+ * compression aborts automatically if the compressed data is too large.
+ */
+extern unsigned long zbewalgo_max_output_size;
+
+/*
+ * add an combination to the current active ones. All combinations are the
+ * same for all instances of this algorithm
+ */
+int zbewalgo_add_combination(
+	const char * const string,
+	const int string_length);
+
+/*
+ * replace ALL combinations with the one specified.
+ */
+int zbewalgo_set_combination(
+	const char * const string,
+	const int string_length);
+
+#endif
diff --git a/lib/zbewalgo/zbewalgo.c b/lib/zbewalgo/zbewalgo.c
new file mode 100644
index 000000000..a039b6841
--- /dev/null
+++ b/lib/zbewalgo/zbewalgo.c
@@ -0,0 +1,590 @@
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
+ * this program; if not, write to the Free Software Foundation, Inc., 51
+ * Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
+ *
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
+
+unsigned long zbewalgo_max_output_size;
+
+/*
+ * all currently available combination sequences of algorithms
+ */
+static struct zbewalgo_combination
+	zbewalgo_combinations[ZBEWALGO_COMBINATION_MAX_ACTIVE];
+static uint8_t zbewalgo_combinations_count;
+
+/*
+ * maximum required wrkmem for compression and decompression for each instance
+ * of the algorithm
+ */
+static uint32_t zbewalgo_wrkmem_size;
+
+/*
+ * compression can be aborted if the data is smaller than this theshold to
+ * speed up the algorithm.
+ */
+static unsigned long zbewalgo_early_abort_size;
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
+static uint8_t zbewalgo_base_algorithms_count;
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
+ * if 'flag' is set, replaces all combinations with the new supplied one.
+ * this function is called from the sysfs context, and therefore accepts
+ * a string as input.
+ */
+static __always_inline int add_set_combination(
+	const char * const string,
+	const int string_length,
+	int flag)
+{
+	/* points behind the string for fast looping over the entire string */
+	const char * const string_end = string + string_length;
+	/* the string up to 'anchor' is parsed */
+	const char *anchor = string;
+	const char *pos = string;
+	struct zbewalgo_combination combination;
+	uint8_t i;
+
+	memset(&combination, 0, sizeof(struct zbewalgo_combination));
+	/* loop over entire string */
+	while ((pos < string_end) && (*pos != 0)) {
+		while ((pos < string_end) && (*pos != 0) && (*pos != '-'))
+			pos++;
+		if (pos - anchor <= 0) {
+			/* skipp leading or consecutive '-' chars */
+			pos++;
+			anchor = pos;
+			continue;
+		}
+		/* find the algorithm by name in the list of all algorithms */
+		for (i = 0; i < zbewalgo_base_algorithms_count; i++) {
+			if (((unsigned int) (pos - anchor)
+				== strlen(zbewalgo_base_algorithms[i].name))
+				&& (memcmp(anchor,
+					zbewalgo_base_algorithms[i].name,
+					pos - anchor)
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
+		if ((combination.count >= ZBEWALGO_COMBINATION_MAX_IDS)
+			|| (*pos != '-'))
+			goto _finalize;
+		if (i == zbewalgo_base_algorithms_count)
+			/* misstyped arguments */
+			return -1;
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
+			if (memcmp(
+				&zbewalgo_combinations[i],
+				&combination,
+				sizeof(struct zbewalgo_combination)) == 0) {
+				return 0;
+			}
+		/* store the new combination */
+		memcpy(
+			&zbewalgo_combinations[zbewalgo_combinations_count],
+			&combination,
+			sizeof(struct zbewalgo_combination));
+		zbewalgo_combinations_count++;
+		return 0;
+	}
+	return -1; /* empty algorithm is not allowed */
+}
+
+int zbewalgo_add_combination(
+	const char * const string,
+	const int string_length)
+{
+	return add_set_combination(string, string_length, 0);
+}
+EXPORT_SYMBOL(zbewalgo_add_combination);
+
+int zbewalgo_set_combination(
+	const char * const string,
+	const int string_length)
+{
+	return add_set_combination(string, string_length, 1);
+}
+EXPORT_SYMBOL(zbewalgo_set_combination);
+
+#define compress(i, j, s, d, w, l) \
+	(zbewalgo_base_algorithms[zbewalgo_combinations[i].ids[j]] \
+		.compress(s, d, w, l))
+
+
+__always_inline int zbewalgo_compress(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem,
+	const uint16_t source_length)
+{
+	struct zbewalgo_main_data * const main_data =
+		get_cpu_ptr(zbewalgo_main_data_ptr);
+	uint8_t *dest_best = wrkmem;
+	uint8_t *dest1 = dest_best + (4096 << 1);
+	uint8_t *dest2 = dest1 + (4096 << 1);
+	uint8_t * const wrk = dest2 + (4096 << 1);
+	uint8_t *dest_tmp;
+	const uint8_t *current_source;
+	uint8_t i, j;
+	uint16_t dest_best_size = source_length << 1;
+	int dest_current_size;
+	uint8_t dest_best_id = 0;
+	uint8_t i_from = main_data->best_id
+		+ (main_data->counter_search-- == 0);
+	uint8_t i_to = zbewalgo_combinations_count;
+	uint8_t looped = 0;
+	uint16_t local_abort_size = max_t(uint16_t,
+		main_data->best_id_accepted_size,
+		zbewalgo_early_abort_size);
+	uint16_t counter = 0;
+	struct zbewalgo_combination * const dest_best_combination =
+		(struct zbewalgo_combination *) dest;
+_begin:
+	/*
+	 * loop from 0 to zbewalgo_combinations_count starting with the last
+	 * successfull combination
+	 */
+	i = i_from;
+	while (i < i_to) {
+		current_source	  = source;
+		dest_current_size = source_length;
+		counter++;
+		for (j = 0; j < zbewalgo_combinations[i].count; j++) {
+			dest_current_size = compress(i, j,
+				current_source,
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
+	/* if a higher compression ratio is found, update to the best */
+				dest_best_id = i;
+				dest_best_size = dest_current_size;
+				dest_tmp = dest_best;
+				dest_best = dest1;
+				dest1 = dest_tmp;
+				memcpy(
+					dest_best_combination,
+					&zbewalgo_combinations[i],
+					sizeof(struct zbewalgo_combination));
+	/* partial combination is allowed, if its compression ratio is high */
+				dest_best_combination->count = j + 1;
+			}
+		}
+		if (dest_best_size < local_abort_size)
+			goto _early_abort;
+_next_algorithm:
+		local_abort_size = zbewalgo_early_abort_size;
+		i++;
+	}
+	if (!(looped++) && (i_from > 0)) {
+		i_to = min_t(uint8_t, i_from, zbewalgo_combinations_count);
+		i_from = 0;
+		goto _begin;
+	}
+	if (dest_best_size > zbewalgo_max_output_size)
+		return -1;
+_early_abort:
+	atomic64_inc(&zbewalgo_stat_combination[dest_best_id]);
+	atomic64_inc(&zbewalgo_stat_count[counter]);
+	main_data->best_id = dest_best_id;
+	main_data->best_id_accepted_size =
+		max_t(uint8_t,
+			dest_best_size + (dest_best_size >> 3),
+			zbewalgo_early_abort_size);
+	memcpy(
+		dest + sizeof(struct zbewalgo_combination),
+		dest_best,
+		dest_best_size);
+	return sizeof(struct zbewalgo_combination) + dest_best_size;
+}
+EXPORT_SYMBOL(zbewalgo_compress);
+
+#define decompress(i, s, d, w) \
+	(zbewalgo_base_algorithms[combination->ids[i]] \
+		.decompress(s, d, w))
+
+__always_inline int zbewalgo_decompress(
+	const uint8_t * const source,
+	uint8_t * const dest,
+	uint8_t * const wrkmem)
+{
+	uint8_t *dest1 = wrkmem;
+	uint8_t *dest2 = dest1 + (4096 << 1);
+	uint8_t *wrk = dest2 + (4096 << 1);
+	const struct zbewalgo_combination * const combination =
+		(struct zbewalgo_combination *) source;
+	uint8_t j;
+	int res;
+
+	if (combination->count == 1) {
+		res = decompress(0,
+			(source + sizeof(struct zbewalgo_combination)),
+			dest,
+			wrk);
+		return res;
+	}
+	res = decompress(combination->count - 1,
+		(source + sizeof(struct zbewalgo_combination)),
+		dest1,
+		wrk);
+	for (j = combination->count - 2; j > 1; j -= 2) {
+		res = decompress(j, dest1, dest2, wrk);
+		res = decompress(j - 1, dest2, dest1, wrk);
+	}
+	if (j == 1) {
+		res = decompress(1, dest1, dest2, wrk);
+		res = decompress(0, dest2, dest, wrk);
+		return res;
+	}
+	res = decompress(0, dest1, dest, wrk);
+	return res;
+}
+EXPORT_SYMBOL(zbewalgo_decompress);
+
+#define add_combination_compile_time(name) \
+	zbewalgo_add_combination(name, sizeof(name))
+
+static ssize_t zbewalgo_combinations_show(
+	struct kobject *kobj,
+	struct kobj_attribute *attr,
+	char *buf)
+{
+	ssize_t res = 0;
+	ssize_t tmp;
+	uint8_t i, j;
+	struct zbewalgo_combination *com;
+
+	res = tmp = scnprintf(buf, PAGE_SIZE - res, "combinations={\n");
+	buf += tmp;
+	for (i = 0; i < zbewalgo_combinations_count; i++) {
+		com = &zbewalgo_combinations[i];
+		res += tmp = scnprintf(
+			buf,
+			PAGE_SIZE - res,
+			"\tcombination[%d]=",
+			i);
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
+static ssize_t zbewalgo_combinations_store(
+	struct kobject *kobj,
+	struct kobj_attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	ssize_t res;
+
+	count--;
+	if (count < 5)
+		return -1;
+	if (memcmp(buf, "add ", 4) == 0) {
+		res = zbewalgo_add_combination(buf + 4, count - 4);
+		return res < 0 ? res : count+1;
+	}
+	if (memcmp(buf, "set ", 4) == 0) {
+		res = zbewalgo_set_combination(buf + 4, count - 4);
+		return res < 0 ? res : count+1;
+	}
+	if (memcmp(buf, "reset", 5) == 0) {
+		zbewalgo_combinations_count = 0;
+		add_combination_compile_time(
+			"bewalgo2-bitshuffle-jbe-rle");
+		add_combination_compile_time(
+			"bwt-mtf-bewalgo-huffman");
+		add_combination_compile_time(
+			"bitshuffle-bewalgo2-mtf-bewalgo-jbe");
+		add_combination_compile_time(
+			"bitshuffle-rle-bitshuffle-rle");
+		return count;
+	}
+	return -1;
+}
+
+static ssize_t zbewalgo_max_output_size_show(
+	struct kobject *kobj,
+	struct kobj_attribute *attr,
+	char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%lu", zbewalgo_max_output_size);
+}
+
+static ssize_t zbewalgo_max_output_size_store(
+	struct kobject *kobj,
+	struct kobj_attribute *attr,
+	const char *buf,
+	size_t count)
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
+static ssize_t zbewalgo_early_abort_size_show(
+	struct kobject *kobj,
+	struct kobj_attribute *attr,
+	char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%lu", zbewalgo_early_abort_size);
+}
+
+static ssize_t zbewalgo_early_abort_size_store(
+	struct kobject *kobj,
+	struct kobj_attribute *attr,
+	const char *buf,
+	size_t count)
+{
+	char localbuf[10];
+	ssize_t res;
+
+	memcpy(&localbuf[0], buf, count < 10 ? count : 10);
+	localbuf[count < 9 ? count : 9] = 0;
+	res = kstrtoul(localbuf, 10, &zbewalgo_early_abort_size);
+	return res < 0 ? res : count;
+}
+
+static ssize_t zbewalgo_bwt_max_alphabet_show(
+	struct kobject *kobj,
+	struct kobj_attribute *attr,
+	char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%lu", zbewalgo_bwt_max_alphabet);
+}
+
+static ssize_t zbewalgo_bwt_max_alphabet_store(
+	struct kobject *kobj,
+	struct kobj_attribute *attr,
+	const char *buf,
+	size_t count)
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
+static struct kobj_attribute zbewalgo_combinations_attribute = __ATTR(
+	combinations,
+	0664,
+	zbewalgo_combinations_show,
+	zbewalgo_combinations_store);
+static struct kobj_attribute zbewalgo_max_output_size_attribute = __ATTR(
+	max_output_size,
+	0664,
+	zbewalgo_max_output_size_show,
+	zbewalgo_max_output_size_store);
+static struct kobj_attribute zbewalgo_early_abort_size_attribute = __ATTR(
+	early_abort_size,
+	0664,
+	zbewalgo_early_abort_size_show,
+	zbewalgo_early_abort_size_store);
+static struct kobj_attribute zbewalgo_bwt_max_alphabet_attribute = __ATTR(
+	bwt_max_alphabet,
+	0664,
+	zbewalgo_bwt_max_alphabet_show,
+	zbewalgo_bwt_max_alphabet_store);
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
+	uint8_t i;
+	int j;
+	int res = 0;
+
+	zbewalgo_early_abort_size = 400;
+	/*
+	 * this algorithm is intended to be used for zram with zsmalloc.
+	 * Therefore zbewalgo_max_output_size equals zsmalloc max size class
+	 */
+	i = 0;
+	zbewalgo_max_output_size = 3264;
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
+		if (res) {
+			if (i > 0)
+				zbewalgo_base_algorithms[0].exit();
+			i--;
+			while (i > 0)
+				zbewalgo_base_algorithms[i].exit();
+			return res;
+		}
+		zbewalgo_base_algorithms[i].id = i;
+		zbewalgo_wrkmem_size = max_t(uint32_t,
+			zbewalgo_wrkmem_size,
+			zbewalgo_base_algorithms[i].wrkmem_size);
+	}
+	/* adding some pages for temporary compression results */
+	zbewalgo_wrkmem_size += 4096 * 6;
+	zbewalgo_main_data_ptr = alloc_percpu(struct zbewalgo_main_data);
+	for_each_possible_cpu(j) {
+		memset(
+			per_cpu_ptr(zbewalgo_main_data_ptr, j),
+			0,
+			sizeof(struct zbewalgo_main_data));
+	}
+
+	memset(&zbewalgo_stat_combination[0], 0, 256 * sizeof(atomic64_t));
+	memset(&zbewalgo_stat_count[0], 0, 256 * sizeof(atomic64_t));
+
+	zbewalgo_kobj = kobject_create_and_add("zbewalgo", kernel_kobj);
+	if (!zbewalgo_kobj)
+		return -ENOMEM;
+	res = sysfs_create_group(zbewalgo_kobj, &attr_group);
+	if (res) {
+		kobject_put(zbewalgo_kobj);
+		zbewalgo_combinations_store(
+			zbewalgo_kobj,
+			&zbewalgo_combinations_attribute,
+			"reset",
+			sizeof("reset"));
+	}
+	return res;
+}
+
+static void __exit zbewalgo_mod_fini(void)
+{
+	uint16_t i;
+	uint64_t tmp;
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
+				__func__, i, tmp);
+	}
+	for (i = 0; i < 256; i++) {
+		tmp = atomic64_read(&zbewalgo_stat_count[i]);
+		if (tmp > 0)
+			printk(KERN_INFO "%s %4d -> %llu counter\n",
+				__func__, i, tmp);
+	}
+}
+
+module_init(zbewalgo_mod_init);
+module_exit(zbewalgo_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ZBeWalgo Compression Algorithm");
+
-- 
2.11.0
