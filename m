From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 2/4] crypto: Add a "zlib" crypto module
Date: Mon, 24 Nov 2008 17:13:05 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0811241712390.9844@vixen.sonytel.be>
References: <20080829134158.108976037@vixen.sonytel.be>
 <20080829134418.874948211@vixen.sonytel.be> <20080830062315.GA18441@gondor.apana.org.au>
 <Pine.LNX.4.64.0811241700100.9844@vixen.sonytel.be>
 <Pine.LNX.4.64.0811241711510.9844@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51162 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752928AbYKXQNG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Nov 2008 11:13:06 -0500
In-Reply-To: <Pine.LNX.4.64.0811241711510.9844@vixen.sonytel.be>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a "zlib" crypto module, which differs from the existing "deflate" c=
rypto
module in the following aspects:
  - Support for the new partial (de)compression API has been added,
  - The (de)compression parameters have been changed to accomodate Squa=
shFS
    ("zlib" format with 15 window bits instead of "raw deflate" format =
with 11
     windows bits).

Todo:
  - Make the (de)compression parameters configurable, so it can be merg=
ed
    back into the "deflate" crypto module

Caveats:
  - Compression hasn't been tested yet

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 Kconfig  |    8 +
 Makefile |    1=20
 zlib.c   |  389 ++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++++++
 3 files changed, 398 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 39dbd8e..51bf6fa 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -695,6 +695,14 @@ config CRYPTO_LZO
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
 comment "Random Number Generation"
=20
 config CRYPTO_ANSI_CPRNG
diff --git a/crypto/Makefile b/crypto/Makefile
index 5862b80..8d4cdb7 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_CRYPTO_LZO) +=3D lzo.o
 obj-$(CONFIG_CRYPTO_RNG) +=3D rng.o
 obj-$(CONFIG_CRYPTO_RNG) +=3D krng.o
 obj-$(CONFIG_CRYPTO_ANSI_CPRNG) +=3D ansi_cprng.o
+obj-$(CONFIG_CRYPTO_ZLIB) +=3D zlib.o
 obj-$(CONFIG_CRYPTO_TEST) +=3D tcrypt.o
=20
 #
diff --git a/crypto/zlib.c b/crypto/zlib.c
new file mode 100644
index 0000000..a95340d
--- /dev/null
+++ b/crypto/zlib.c
@@ -0,0 +1,389 @@
+#define DEBUG
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
+};
+
+static int zlib_comp_init(struct zlib_ctx *ctx)
+{
+	int ret =3D 0;
+	struct z_stream_s *stream =3D &ctx->comp_stream;
+
+	stream->workspace =3D vmalloc(zlib_deflate_workspacesize());
+	if (!stream->workspace) {
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
+	if (!stream->workspace) {
+		ret =3D -ENOMEM;
+		goto out;
+	}
+	ret =3D zlib_inflateInit(stream);
+	if (ret !=3D Z_OK) {
+		ret =3D -EINVAL;
+		goto out_free;
+	}
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
+	int ret;
+	struct zlib_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->comp_stream;
+
+	pr_debug("%s: slen %u, dlen %u\n", __func__, slen, *dlen);
+	ret =3D zlib_deflateReset(stream);
+	if (ret !=3D Z_OK) {
+		pr_err("%s: zlib_deflateReset failed %d\n", __func__, ret);
+		return -EINVAL;
+	}
+
+	stream->next_in =3D (u8 *)src;
+	stream->avail_in =3D slen;
+	stream->next_out =3D (u8 *)dst;
+	stream->avail_out =3D *dlen;
+
+	ret =3D zlib_deflate(stream, Z_FINISH);
+	if (ret !=3D Z_STREAM_END) {
+		pr_err("%s: zlib_deflate failed %d\n", __func__, ret);
+		return -EINVAL;
+	}
+
+	*dlen =3D stream->total_out;
+	pr_debug("%s: dlen_out %u\n", __func__, *dlen);
+	return 0;
+}
+
+static int zlib_decompress(struct crypto_tfm *tfm, const u8 *src,
+			   unsigned int slen, u8 *dst, unsigned int *dlen)
+{
+	int ret;
+	struct zlib_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->decomp_stream;
+
+	pr_debug("%s: slen %u, dlen %u\n", __func__, slen, *dlen);
+	ret =3D zlib_inflateReset(stream);
+	if (ret !=3D Z_OK) {
+		pr_err("%s: zlib_inflateReset failed %d\n", __func__, ret);
+		return -EINVAL;
+	}
+
+	stream->next_in =3D (u8 *)src;
+	stream->avail_in =3D slen;
+	stream->next_out =3D (u8 *)dst;
+	stream->avail_out =3D *dlen;
+
+	ret =3D zlib_inflate(stream, Z_FINISH);
+	if (ret !=3D Z_STREAM_END) {
+		pr_err("%s: zlib_inflate failed %d\n", __func__, ret);
+		return -EINVAL;
+	}
+
+	*dlen =3D stream->total_out;
+	pr_debug("%s: dlen_out %u\n", __func__, *dlen);
+	return 0;
+}
+
+static int zlib_compress_update(struct crypto_tfm *tfm,
+				struct comp_request *req)
+{
+	int ret;
+	struct zlib_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->comp_stream;
+
+	pr_debug("%s: avail_in %u, avail_out %u\n", __func__, req->avail_in,
+		 req->avail_out);
+	stream->next_in =3D req->next_in;
+	stream->avail_in =3D req->avail_in;
+	stream->next_out =3D req->next_out;
+	stream->avail_out =3D req->avail_out;
+
+	ret =3D zlib_deflate(stream, Z_NO_FLUSH);
+	switch (ret) {
+	case Z_OK:
+		break;
+
+	case Z_BUF_ERROR:
+		pr_err("%s: zlib_deflate could not make progress\n", __func__);
+		return -EAGAIN;
+
+	default:
+		pr_err("%s: zlib_deflate failed %d\n", __func__, ret);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: avail_in %u, avail_out %u (consumed %u, produced %u)\n"=
,
+		 __func__, stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in =3D stream->next_in;
+	req->avail_in =3D stream->avail_in;
+	req->next_out =3D stream->next_out;
+	req->avail_out =3D stream->avail_out;
+	return 0;
+}
+
+static int zlib_compress_init(struct crypto_tfm *tfm, struct comp_requ=
est *req)
+{
+	int ret;
+	struct zlib_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->comp_stream;
+
+	pr_debug("%s: avail_in %u, avail_out %u\n", __func__, req->avail_in,
+		 req->avail_out);
+	ret =3D zlib_deflateReset(stream);
+	if (ret !=3D Z_OK)
+		return -EINVAL;
+
+	return zlib_compress_update(tfm, req);
+}
+
+static int zlib_compress_final(struct crypto_tfm *tfm,
+			       struct comp_request *req)
+{
+	int ret;
+	struct zlib_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->comp_stream;
+
+	pr_debug("%s: avail_in %u, avail_out %u\n", __func__, req->avail_in,
+		 req->avail_out);
+	stream->next_in =3D req->next_in;
+	stream->avail_in =3D req->avail_in;
+	stream->next_out =3D req->next_out;
+	stream->avail_out =3D req->avail_out;
+
+	ret =3D zlib_deflate(stream, Z_FINISH);
+	if (ret !=3D Z_OK) {
+		pr_err("%s: zlib_deflate failed %d\n", __func__, ret);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: avail_in %u, avail_out %u (consumed %u, produced %u)\n"=
,
+		 __func__, stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in =3D stream->next_in;
+	req->avail_in =3D stream->avail_in;
+	req->next_out =3D stream->next_out;
+	req->avail_out =3D stream->avail_out;
+	return 0;
+}
+
+static int zlib_decompress_update(struct crypto_tfm *tfm,
+				  struct comp_request *req)
+{
+	int ret;
+	struct zlib_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->decomp_stream;
+
+	pr_debug("%s: avail_in %u, avail_out %u\n", __func__, req->avail_in,
+		 req->avail_out);
+	stream->next_in =3D req->next_in;
+	stream->avail_in =3D req->avail_in;
+	stream->next_out =3D req->next_out;
+	stream->avail_out =3D req->avail_out;
+
+	ret =3D zlib_inflate(stream, Z_SYNC_FLUSH);
+	switch (ret) {
+	case Z_OK:
+	case Z_STREAM_END:
+		break;
+
+	case Z_BUF_ERROR:
+		pr_err("%s: zlib_inflate could not make progress\n", __func__);
+		return -EAGAIN;
+
+	default:
+		pr_err("%s: zlib_inflate failed %d\n", __func__, ret);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: avail_in %u, avail_out %u (consumed %u, produced %u)\n"=
,
+		 __func__, stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in =3D stream->next_in;
+	req->avail_in =3D stream->avail_in;
+	req->next_out =3D stream->next_out;
+	req->avail_out =3D stream->avail_out;
+	return 0;
+}
+
+static int zlib_decompress_init(struct crypto_tfm *tfm,
+				struct comp_request *req)
+{
+	int ret;
+	struct zlib_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->decomp_stream;
+
+	pr_debug("%s: avail_in %u, avail_out %u\n", __func__, req->avail_in,
+		 req->avail_out);
+	ret =3D zlib_inflateReset(stream);
+	if (ret !=3D Z_OK)
+		return -EINVAL;
+
+	return zlib_decompress_update(tfm, req);
+}
+
+static int zlib_decompress_final(struct crypto_tfm *tfm,
+				 struct comp_request *req)
+{
+	int ret;
+	struct zlib_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->decomp_stream;
+
+	pr_debug("%s: avail_in %u, avail_out %u\n", __func__, req->avail_in,
+		 req->avail_out);
+	stream->next_in =3D req->next_in;
+	stream->avail_in =3D req->avail_in;
+	stream->next_out =3D req->next_out;
+	stream->avail_out =3D req->avail_out;
+
+	ret =3D zlib_inflate(stream, Z_FINISH);
+	if (ret !=3D Z_STREAM_END) {
+		pr_err("%s: zlib_inflate failed %d\n", __func__, ret);
+		return -EINVAL;
+	}
+
+	pr_debug("%s: avail_in %u, avail_out %u (consumed %u, produced %u)\n"=
,
+		 __func__, stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in =3D stream->next_in;
+	req->avail_in =3D stream->avail_in;
+	req->next_out =3D stream->next_out;
+	req->avail_out =3D stream->avail_out;
+	return 0;
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
+	.cra_u		=3D {
+		.compress =3D {
+			/* one shot */
+			.coa_compress		=3D zlib_compress,
+			.coa_decompress		=3D zlib_decompress,
+			/* partial */
+			.coa_compress_init	=3D zlib_compress_init,
+			.coa_compress_update	=3D zlib_compress_update,
+			.coa_compress_final	=3D zlib_compress_final,
+			.coa_decompress_init	=3D zlib_decompress_init,
+			.coa_decompress_update	=3D zlib_decompress_update,
+			.coa_decompress_final	=3D zlib_decompress_final
+		}
+	}
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
