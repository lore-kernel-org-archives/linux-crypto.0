From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [patch 1/3] crypto: Add a zlib crypto module
Date: Fri, 29 Aug 2008 15:41:59 +0200
Message-ID: <20080829134418.874948211@vixen.sonytel.be>
References: <20080829134158.108976037@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: linux-crypto@vger.kernel.org, squashfs-devel@lists.sourceforge.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:33840 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756725AbYH2Noo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 Aug 2008 09:44:44 -0400
Content-Disposition: inline; filename=crypto/add-zlib-crypto-module.diff
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Add a (de)compression module for the "zlib" format using the crypto API=
=2E

While both the "zlib" and "deflate" crypto modules are implemented on t=
op of
the zlib library, they differ in the following aspects:
  - The "deflate" crypto module (used by IPSec and UBIFS) does not supp=
ort
    partial decompression, i.e. all compressed data has to be passed at=
 once.
    The "zlib" crypto module does support partial decompression;
    zlib_decompress() will return -EAGAIN if not all compressed data ha=
s been
    passed.
  - The deflate crypto module uses the raw deflate data format (zlib is
    initialized with a windowBits parameter of -DEFLATE_DEF_WINBITS =3D=
 -11),
    while e.g. squashfs and axfs use the zlib data format, with the def=
ault
    windowBits parameter DEF_WBITS =3D 15.
    Both parameters are incompatible with each other due to the differe=
nt data
    formats, as indicated by the sign of the windowbits parameter.
    The absolute value of this parameter is the base two logarithm of t=
he
    maximum window size, and larger values are backwards compatible wit=
h
    smaller values (as far as decompression is concerned).

TODO:
  - As the crypto wrapper around the zlib library supports both compres=
sion and
    decompression (and always allocates temporary space for both during
    initialization; lazy allocation was removed in 2004 because IPComp =
calls
    the crypto routines in non-process context), more memory is needed:
      * decompression (inflate) needs only ca. 41 KiB
      * compression (deflate) needs ca. 262 KiB!=20
    It would be nice to allow having support for decompression only.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 crypto/Kconfig  |    8 ++
 crypto/Makefile |    1=20
 crypto/zlib.c   |  216 +++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
 3 files changed, 225 insertions(+)

--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -666,6 +666,14 @@ config CRYPTO_LZO
 	help
 	  This is the LZO algorithm.
=20
+config CRYPTO_ZLIB
+	tristate "Zlib compression algorithm"
+	select CRYPTO_ALGAPI
+	select ZLIB_INFLATE
+	select ZLIB_DEFLATE
+	help
+	  This is the Zlib algorithm.
+
 source "drivers/crypto/Kconfig"
=20
 endif	# if CRYPTO
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -69,6 +69,7 @@ obj-$(CONFIG_CRYPTO_MICHAEL_MIC) +=3D mich
 obj-$(CONFIG_CRYPTO_CRC32C) +=3D crc32c.o
 obj-$(CONFIG_CRYPTO_AUTHENC) +=3D authenc.o
 obj-$(CONFIG_CRYPTO_LZO) +=3D lzo.o
+obj-$(CONFIG_CRYPTO_ZLIB) +=3D zlib.o
=20
 obj-$(CONFIG_CRYPTO_TEST) +=3D tcrypt.o
=20
--- /dev/null
+++ b/crypto/zlib.c
@@ -0,0 +1,216 @@
+/*
+ * Cryptographic API.
+ *
+ * "zlib" crypto module, based on the "deflate" crypto module
+ *
+ * Copyright (c) 2003 James Morris <jmorris@intercode.com.au>
+ * Copyright 2008 Sony Corp.
+ *
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License as published by t=
he Free
+ * Software Foundation; either version 2 of the License, or (at your o=
ption)
+ * any later version.
+ *
+ * FIXME: deflate transforms will require up to a total of about 436k =
of kernel
+ * memory on i386 (390k for compression, the rest for decompression), =
as the
+ * current zlib kernel code uses a worst case pre-allocation system by=
 default.
+ * This needs to be fixed so that the amount of memory required is pro=
perly
+ * related to the  winbits and memlevel parameters.
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/crypto.h>
+#include <linux/zlib.h>
+#include <linux/vmalloc.h>
+#include <linux/interrupt.h>
+#include <linux/mm.h>
+#include <linux/net.h>
+#include <linux/slab.h>
+
+#define ZLIB_DEF_LEVEL		Z_DEFAULT_COMPRESSION
+
+struct zlib_ctx {
+	struct z_stream_s comp_stream;
+	struct z_stream_s decomp_stream;
+	bool decomp_needs_reset;
+};
+
+static int zlib_comp_init(struct zlib_ctx *ctx)
+{
+	int ret =3D 0;
+	struct z_stream_s *stream =3D &ctx->comp_stream;
+
+	stream->workspace =3D vmalloc(zlib_deflate_workspacesize());
+	if (!stream->workspace ) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+	memset(stream->workspace, 0, zlib_deflate_workspacesize());
+	ret =3D zlib_deflateInit(stream, ZLIB_DEF_LEVEL);
+	if (ret !=3D Z_OK) {
+		ret =3D -EINVAL;
+		goto out_free;
+	}
+out:
+	return ret;
+out_free:
+	vfree(stream->workspace);
+	goto out;
+}
+
+static int zlib_decomp_init(struct zlib_ctx *ctx)
+{
+	int ret =3D 0;
+	struct z_stream_s *stream =3D &ctx->decomp_stream;
+
+	stream->workspace =3D kzalloc(zlib_inflate_workspacesize(), GFP_KERNE=
L);
+	if (!stream->workspace ) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+	ret =3D zlib_inflateInit(stream);
+	if (ret !=3D Z_OK) {
+		ret =3D -EINVAL;
+		goto out_free;
+	}
+	ctx->decomp_needs_reset =3D true;
+out:
+	return ret;
+out_free:
+	kfree(stream->workspace);
+	goto out;
+}
+
+static void zlib_comp_exit(struct zlib_ctx *ctx)
+{
+	zlib_deflateEnd(&ctx->comp_stream);
+	vfree(ctx->comp_stream.workspace);
+}
+
+static void zlib_decomp_exit(struct zlib_ctx *ctx)
+{
+	zlib_inflateEnd(&ctx->decomp_stream);
+	kfree(ctx->decomp_stream.workspace);
+}
+
+static int zlib_init(struct crypto_tfm *tfm)
+{
+	struct zlib_ctx *ctx =3D crypto_tfm_ctx(tfm);
+	int ret;
+
+	ret =3D zlib_comp_init(ctx);
+	if (ret)
+		goto out;
+	ret =3D zlib_decomp_init(ctx);
+	if (ret)
+		zlib_comp_exit(ctx);
+out:
+	return ret;
+}
+
+static void zlib_exit(struct crypto_tfm *tfm)
+{
+	struct zlib_ctx *ctx =3D crypto_tfm_ctx(tfm);
+
+	zlib_comp_exit(ctx);
+	zlib_decomp_exit(ctx);
+}
+
+static int zlib_compress(struct crypto_tfm *tfm, const u8 *src,
+			 unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	int ret =3D 0;
+	struct zlib_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->comp_stream;
+
+	ret =3D zlib_deflateReset(stream);
+	if (ret !=3D Z_OK) {
+		ret =3D -EINVAL;
+		goto out;
+	}
+
+	stream->next_in =3D (u8 *)src;
+	stream->avail_in =3D slen;
+	stream->next_out =3D (u8 *)dst;
+	stream->avail_out =3D *dlen;
+
+	ret =3D zlib_deflate(stream, Z_FINISH);
+	if (ret !=3D Z_STREAM_END) {
+		ret =3D -EINVAL;
+		goto out;
+	}
+	ret =3D 0;
+	*dlen =3D stream->total_out;
+out:
+	return ret;
+}
+
+static int zlib_decompress(struct crypto_tfm *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	int ret =3D 0;
+	struct zlib_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->decomp_stream;
+	unsigned long old_total_out;
+
+	if (dctx->decomp_needs_reset) {
+		ret =3D zlib_inflateReset(stream);
+		if (ret !=3D Z_OK)
+			return -EINVAL;
+		dctx->decomp_needs_reset =3D false;
+	}
+
+	stream->next_in =3D (u8 *)src;
+	stream->avail_in =3D slen;
+	stream->next_out =3D (u8 *)dst;
+	stream->avail_out =3D *dlen;
+	old_total_out =3D stream->total_out;
+
+	ret =3D zlib_inflate(stream, Z_SYNC_FLUSH);
+	switch (ret) {
+	case Z_STREAM_END:
+		dctx->decomp_needs_reset =3D true;
+		ret =3D 0;
+		break;
+
+	case Z_OK:
+		ret =3D -EAGAIN;
+		break;
+
+	default:
+		return -EINVAL;
+	}
+
+	*dlen =3D stream->total_out - old_total_out;
+	return ret;
+}
+
+static struct crypto_alg alg =3D {
+	.cra_name	=3D "zlib",
+	.cra_flags	=3D CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_ctxsize	=3D sizeof(struct zlib_ctx),
+	.cra_module	=3D THIS_MODULE,
+	.cra_list	=3D LIST_HEAD_INIT(alg.cra_list),
+	.cra_init	=3D zlib_init,
+	.cra_exit	=3D zlib_exit,
+	.cra_u		=3D { .compress =3D {
+	.coa_compress	=3D zlib_compress,
+	.coa_decompress	=3D zlib_decompress } }
+};
+
+static int __init zlib_mod_init(void)
+{
+	return crypto_register_alg(&alg);
+}
+
+static void __exit zlib_mod_fini(void)
+{
+	crypto_unregister_alg(&alg);
+}
+
+module_init(zlib_mod_init);
+module_exit(zlib_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Zlib Compression Algorithm");
+

--=20
With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village =C2=B7 Da Vincilaan 7-D1 =C2=B7 B-1935 Zaventem =C2=
=B7 Belgium

Phone:    +32 (0)2 700 8453
=46ax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 =C2=B7 RPR Brussels
=46ortis =C2=B7 BIC GEBABEBB =C2=B7 IBAN BE41293037680010

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
