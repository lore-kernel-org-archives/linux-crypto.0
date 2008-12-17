From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH/RFC 6/8] crypto: deflate - switch to pcomp
Date: Wed, 17 Dec 2008 17:36:41 +0100
Message-ID: <20081217164036.784802597@vixen.sonytel.be>
References: <20081217163634.998961917@vixen.sonytel.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	James Morris <jmorris@intercode.com.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:65210 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751964AbYLQQmD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 17 Dec 2008 11:42:03 -0500
Content-Disposition: inline; filename=crypto-convert-deflate-to-pcomp.patch
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=46rom: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Change the "deflate" crypto module from the "comp" to the "pcomp" inter=
face.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Morris <jmorris@intercode.com.au>
---
 crypto/deflate.c       |  342 ++++++++++++++++++++++++++++++++++++----=
---------
 include/linux/crypto.h |   12 +
 2 files changed, 266 insertions(+), 88 deletions(-)

--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -1,14 +1,15 @@
-/*=20
+/*
  * Cryptographic API.
  *
- * Deflate algorithm (RFC 1951), implemented here primarily for use
- * by IPCOMP (RFC 3173 & RFC 2394).
+ * Deflate algorithm (RFC 1951), implemented here for use
+ * by e.g. IPCOMP (RFC 3173 & RFC 2394).
  *
  * Copyright (c) 2003 James Morris <jmorris@intercode.com.au>
- *=20
+ * Copyright 2008 Sony Corporation
+ *
  * This program is free software; you can redistribute it and/or modif=
y it
  * under the terms of the GNU General Public License as published by t=
he Free
- * Software Foundation; either version 2 of the License, or (at your o=
ption)=20
+ * Software Foundation; either version 2 of the License, or (at your o=
ption)
  * any later version.
  *
  * FIXME: deflate transforms will require up to a total of about 436k =
of kernel
@@ -16,14 +17,10 @@
  * current zlib kernel code uses a worst case pre-allocation system by=
 default.
  * This needs to be fixed so that the amount of memory required is pro=
perly
  * related to the  winbits and memlevel parameters.
- *
- * The default winbits of 11 should suit most packets, and it may be s=
omething
- * to configure on a per-tfm basis in the future.
- *
- * Currently, compression history is not maintained between tfm calls,=
 as
- * it is not needed for IPCOMP and keeps the code simpler.  It can be
- * implemented if someone wants it.
  */
+
+#define pr_fmt(fmt)	"%s: " fmt, __func__
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
@@ -39,6 +36,7 @@
 #define DEFLATE_DEF_MEMLEVEL		MAX_MEM_LEVEL
=20
 struct deflate_ctx {
+	struct deflate_comp_params params;
 	struct z_stream_s comp_stream;
 	struct z_stream_s decomp_stream;
 };
@@ -47,24 +45,27 @@ static int deflate_comp_init(struct defl
 {
 	int ret =3D 0;
 	struct z_stream_s *stream =3D &ctx->comp_stream;
+	size_t workspacesize;
=20
-	stream->workspace =3D vmalloc(zlib_deflate_workspacesize());
-	if (!stream->workspace ) {
+	workspacesize =3D zlib_deflate_workspacesize();
+	stream->workspace =3D vmalloc(workspacesize);
+	if (!stream->workspace) {
 		ret =3D -ENOMEM;
 		goto out;
 	}
-	memset(stream->workspace, 0, zlib_deflate_workspacesize());
-	ret =3D zlib_deflateInit2(stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
-	                        -DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
-	                        Z_DEFAULT_STRATEGY);
+	memset(stream->workspace, 0, workspacesize);
+	ret =3D zlib_deflateInit2(stream, ctx->params.level, ctx->params.meth=
od,
+				ctx->params.windowBits, ctx->params.memLevel,
+				ctx->params.strategy);
 	if (ret !=3D Z_OK) {
 		ret =3D -EINVAL;
 		goto out_free;
 	}
-out:=09
+out:
 	return ret;
 out_free:
 	vfree(stream->workspace);
+	stream->workspace =3D NULL;
 	goto out;
 }
=20
@@ -74,11 +75,11 @@ static int deflate_decomp_init(struct de
 	struct z_stream_s *stream =3D &ctx->decomp_stream;
=20
 	stream->workspace =3D kzalloc(zlib_inflate_workspacesize(), GFP_KERNE=
L);
-	if (!stream->workspace ) {
+	if (!stream->workspace) {
 		ret =3D -ENOMEM;
 		goto out;
 	}
-	ret =3D zlib_inflateInit2(stream, -DEFLATE_DEF_WINBITS);
+	ret =3D zlib_inflateInit2(stream, ctx->params.windowBits);
 	if (ret !=3D Z_OK) {
 		ret =3D -EINVAL;
 		goto out_free;
@@ -87,34 +88,35 @@ out:
 	return ret;
 out_free:
 	kfree(stream->workspace);
+	stream->workspace =3D NULL;
 	goto out;
 }
=20
 static void deflate_comp_exit(struct deflate_ctx *ctx)
 {
-	zlib_deflateEnd(&ctx->comp_stream);
-	vfree(ctx->comp_stream.workspace);
+	struct z_stream_s *stream =3D &ctx->comp_stream;
+
+	if (stream->workspace) {
+		zlib_deflateEnd(stream);
+		vfree(stream->workspace);
+		stream->workspace =3D NULL;
+	}
 }
=20
 static void deflate_decomp_exit(struct deflate_ctx *ctx)
 {
-	zlib_inflateEnd(&ctx->decomp_stream);
-	kfree(ctx->decomp_stream.workspace);
+	struct z_stream_s *stream =3D &ctx->decomp_stream;
+
+	if (stream->workspace) {
+		zlib_inflateEnd(stream);
+		kfree(stream->workspace);
+		stream->workspace =3D NULL;
+	}
 }
=20
 static int deflate_init(struct crypto_tfm *tfm)
 {
-	struct deflate_ctx *ctx =3D crypto_tfm_ctx(tfm);
-	int ret;
-=09
-	ret =3D deflate_comp_init(ctx);
-	if (ret)
-		goto out;
-	ret =3D deflate_decomp_init(ctx);
-	if (ret)
-		deflate_comp_exit(ctx);
-out:
-	return ret;
+	return 0;
 }
=20
 static void deflate_exit(struct crypto_tfm *tfm)
@@ -125,87 +127,251 @@ static void deflate_exit(struct crypto_t
 	deflate_decomp_exit(ctx);
 }
=20
-static int deflate_compress(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen)
+static int deflate_setup(struct crypto_tfm *tfm, const void *params)
 {
-	int ret =3D 0;
+	struct deflate_ctx *ctx =3D crypto_tfm_ctx(tfm);
+	const struct deflate_comp_params *zparams =3D params;
+	int ret;
+
+	deflate_comp_exit(ctx);
+	deflate_decomp_exit(ctx);
+
+	ctx->params =3D *zparams;
+
+	if (zparams->enable_comp) {
+		ret =3D deflate_comp_init(ctx);
+		if (ret)
+			return ret;
+	}
+
+	if (zparams->enable_decomp) {
+		ret =3D deflate_decomp_init(ctx);
+		if (ret) {
+			deflate_comp_exit(ctx);
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+
+static int deflate_compress_update(struct crypto_tfm *tfm,
+				   struct comp_request *req)
+{
+	int ret;
 	struct deflate_ctx *dctx =3D crypto_tfm_ctx(tfm);
 	struct z_stream_s *stream =3D &dctx->comp_stream;
=20
-	ret =3D zlib_deflateReset(stream);
-	if (ret !=3D Z_OK) {
-		ret =3D -EINVAL;
-		goto out;
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out=
);
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
+		pr_debug("zlib_deflate could not make progress\n");
+		return -EAGAIN;
+
+	default:
+		pr_debug("zlib_deflate failed %d\n", ret);
+		return -EINVAL;
 	}
=20
-	stream->next_in =3D (u8 *)src;
-	stream->avail_in =3D slen;
-	stream->next_out =3D (u8 *)dst;
-	stream->avail_out =3D *dlen;
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in =3D stream->next_in;
+	req->avail_in =3D stream->avail_in;
+	req->next_out =3D stream->next_out;
+	req->avail_out =3D stream->avail_out;
+	return 0;
+}
+
+static int deflate_compress_init(struct crypto_tfm *tfm,
+				 struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->comp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out=
);
+	ret =3D zlib_deflateReset(stream);
+	if (ret !=3D Z_OK)
+		return -EINVAL;
+
+	return deflate_compress_update(tfm, req);
+}
+
+static int deflate_compress_final(struct crypto_tfm *tfm,
+				  struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->comp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out=
);
+	stream->next_in =3D req->next_in;
+	stream->avail_in =3D req->avail_in;
+	stream->next_out =3D req->next_out;
+	stream->avail_out =3D req->avail_out;
=20
 	ret =3D zlib_deflate(stream, Z_FINISH);
 	if (ret !=3D Z_STREAM_END) {
-		ret =3D -EINVAL;
-		goto out;
+		pr_debug("zlib_deflate failed %d\n", ret);
+		return -EINVAL;
 	}
-	ret =3D 0;
-	*dlen =3D stream->total_out;
-out:
-	return ret;
+
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in =3D stream->next_in;
+	req->avail_in =3D stream->avail_in;
+	req->next_out =3D stream->next_out;
+	req->avail_out =3D stream->avail_out;
+	return 0;
 }
-=20
-static int deflate_decompress(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
+
+static int deflate_decompress_update(struct crypto_tfm *tfm,
+				     struct comp_request *req)
 {
-=09
-	int ret =3D 0;
+	int ret;
 	struct deflate_ctx *dctx =3D crypto_tfm_ctx(tfm);
 	struct z_stream_s *stream =3D &dctx->decomp_stream;
=20
-	ret =3D zlib_inflateReset(stream);
-	if (ret !=3D Z_OK) {
-		ret =3D -EINVAL;
-		goto out;
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out=
);
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
+		pr_debug("zlib_inflate could not make progress\n");
+		return -EAGAIN;
+
+	default:
+		pr_debug("zlib_inflate failed %d\n", ret);
+		return -EINVAL;
 	}
=20
-	stream->next_in =3D (u8 *)src;
-	stream->avail_in =3D slen;
-	stream->next_out =3D (u8 *)dst;
-	stream->avail_out =3D *dlen;
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in =3D stream->next_in;
+	req->avail_in =3D stream->avail_in;
+	req->next_out =3D stream->next_out;
+	req->avail_out =3D stream->avail_out;
+	return 0;
+}
=20
-	ret =3D zlib_inflate(stream, Z_SYNC_FLUSH);
-	/*
-	 * Work around a bug in zlib, which sometimes wants to taste an extra
-	 * byte when being used in the (undocumented) raw deflate mode.
-	 * (From USAGI).
-	 */
-	if (ret =3D=3D Z_OK && !stream->avail_in && stream->avail_out) {
-		u8 zerostuff =3D 0;
-		stream->next_in =3D &zerostuff;
-		stream->avail_in =3D 1;=20
+static int deflate_decompress_init(struct crypto_tfm *tfm,
+				   struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->decomp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out=
);
+	ret =3D zlib_inflateReset(stream);
+	if (ret !=3D Z_OK)
+		return -EINVAL;
+
+	return deflate_decompress_update(tfm, req);
+}
+
+static int deflate_decompress_final(struct crypto_tfm *tfm,
+				    struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx =3D crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream =3D &dctx->decomp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out=
);
+	stream->next_in =3D req->next_in;
+	stream->avail_in =3D req->avail_in;
+	stream->next_out =3D req->next_out;
+	stream->avail_out =3D req->avail_out;
+
+	if (dctx->params.windowBits < 0) {
+		ret =3D zlib_inflate(stream, Z_SYNC_FLUSH);
+		/*
+		 * Work around a bug in zlib, which sometimes wants to taste an
+		 * extra byte when being used in the (undocumented) raw deflate
+		 * mode. (From USAGI).
+		 */
+		if (ret =3D=3D Z_OK && !stream->avail_in && stream->avail_out) {
+			const void *saved_next_in =3D stream->next_in;
+			u8 zerostuff =3D 0;
+
+			stream->next_in =3D &zerostuff;
+			stream->avail_in =3D 1;
+			ret =3D zlib_inflate(stream, Z_FINISH);
+			stream->next_in =3D saved_next_in;
+			stream->avail_in =3D 0;
+		}
+	} else
 		ret =3D zlib_inflate(stream, Z_FINISH);
-	}
 	if (ret !=3D Z_STREAM_END) {
-		ret =3D -EINVAL;
-		goto out;
+		pr_debug("zlib_inflate failed %d\n", ret);
+		return -EINVAL;
 	}
-	ret =3D 0;
-	*dlen =3D stream->total_out;
-out:
-	return ret;
+
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in =3D stream->next_in;
+	req->avail_in =3D stream->avail_in;
+	req->next_out =3D stream->next_out;
+	req->avail_out =3D stream->avail_out;
+	return 0;
 }
=20
+
+static const struct deflate_comp_params deflate_default_params =3D {
+	.enable_comp		=3D 1,
+	.enable_decomp		=3D 1,
+	.windowBits		=3D -DEFLATE_DEF_WINBITS,
+	.level			=3D DEFLATE_DEF_LEVEL,
+	.method			=3D Z_DEFLATED,
+	.memLevel		=3D DEFLATE_DEF_MEMLEVEL,
+	.strategy		=3D Z_DEFAULT_STRATEGY
+};
+
 static struct crypto_alg alg =3D {
 	.cra_name		=3D "deflate",
-	.cra_flags		=3D CRYPTO_ALG_TYPE_COMPRESS,
+	.cra_flags		=3D CRYPTO_ALG_TYPE_PCOMPRESS,
 	.cra_ctxsize		=3D sizeof(struct deflate_ctx),
 	.cra_module		=3D THIS_MODULE,
 	.cra_list		=3D LIST_HEAD_INIT(alg.cra_list),
 	.cra_init		=3D deflate_init,
 	.cra_exit		=3D deflate_exit,
-	.cra_u			=3D { .compress =3D {
-	.coa_compress 		=3D deflate_compress,
-	.coa_decompress  	=3D deflate_decompress } }
+	.cra_u			=3D {
+		.pcompress =3D {
+			.coa_setup		=3D deflate_setup,
+			.coa_compress_init	=3D deflate_compress_init,
+			.coa_compress_update	=3D deflate_compress_update,
+			.coa_compress_final	=3D deflate_compress_final,
+			.coa_decompress_init	=3D deflate_decompress_init,
+			.coa_decompress_update	=3D deflate_decompress_update,
+			.coa_decompress_final	=3D deflate_decompress_final,
+			.coa_default_params	=3D &deflate_default_params
+		}
+	}
 };
=20
 static int __init deflate_mod_init(void)
@@ -222,6 +388,6 @@ module_init(deflate_mod_init);
 module_exit(deflate_mod_fini);
=20
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Deflate Compression Algorithm for IPCOMP");
+MODULE_DESCRIPTION("Deflate Compression Algorithm");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
=20
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -311,6 +311,18 @@ struct compress_alg {
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
 };
=20
+struct deflate_comp_params {
+	unsigned int enable_comp:1;
+	unsigned int enable_decomp:1;
+	/* common (de)compression (deflate and inflate) parameters */
+	int windowBits;		/* e.g. MAX_WBITS or DEF_WBITS */
+	/* compression only (deflate) parameters */
+	int level;		/* e.g. Z_DEFAULT_COMPRESSION */
+	int method;		/* e.g. Z_DEFLATED */
+	int memLevel;		/* e.g. DEF_MEM_LEVEL */
+	int strategy		/* e.g. Z_DEFAULT_STRATEGY */;
+};
+
 struct pcompress_alg {
 	int (*coa_setup)(struct crypto_tfm *tfm, const void *params);
 	int (*coa_compress_init)(struct crypto_tfm *tfm,

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
