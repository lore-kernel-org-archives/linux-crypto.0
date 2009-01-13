From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH] crypto: deflate - switch to pcomp
Date: Tue, 13 Jan 2009 16:59:44 +0100
Message-ID: <1231862386-11128-6-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1231862386-11128-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1231862386-11128-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	James Morris <jmorris@namei.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:47647 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753554AbZAMP77 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2009 10:59:59 -0500
In-Reply-To: <1231862386-11128-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Change the "deflate" crypto module from the "comp" to the "pcomp" interface.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Morris <jmorris@namei.org>
---
 crypto/Kconfig            |    2 +-
 crypto/deflate.c          |  350 ++++++++++++++++++++++++++++++++------------
 include/crypto/compress.h |   12 ++
 3 files changed, 267 insertions(+), 97 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 740e3bc..36547fc 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -709,7 +709,7 @@ comment "Compression"
 
 config CRYPTO_DEFLATE
 	tristate "Deflate compression algorithm"
-	select CRYPTO_ALGAPI
+	select CRYPTO_PCOMP
 	select ZLIB_INFLATE
 	select ZLIB_DEFLATE
 	help
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 9128da4..0bb2619 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -1,14 +1,15 @@
-/* 
+/*
  * Cryptographic API.
  *
- * Deflate algorithm (RFC 1951), implemented here primarily for use
- * by IPCOMP (RFC 3173 & RFC 2394).
+ * Deflate algorithm (RFC 1951), implemented here for use
+ * by e.g. IPCOMP (RFC 3173 & RFC 2394).
  *
  * Copyright (c) 2003 James Morris <jmorris@intercode.com.au>
- * 
+ * Copyright 2008 Sony Corporation
+ *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option) 
+ * Software Foundation; either version 2 of the License, or (at your option)
  * any later version.
  *
  * FIXME: deflate transforms will require up to a total of about 436k of kernel
@@ -16,17 +17,10 @@
  * current zlib kernel code uses a worst case pre-allocation system by default.
  * This needs to be fixed so that the amount of memory required is properly
  * related to the  winbits and memlevel parameters.
- *
- * The default winbits of 11 should suit most packets, and it may be something
- * to configure on a per-tfm basis in the future.
- *
- * Currently, compression history is not maintained between tfm calls, as
- * it is not needed for IPCOMP and keeps the code simpler.  It can be
- * implemented if someone wants it.
  */
+
 #include <linux/init.h>
 #include <linux/module.h>
-#include <linux/crypto.h>
 #include <linux/zlib.h>
 #include <linux/vmalloc.h>
 #include <linux/interrupt.h>
@@ -34,11 +28,14 @@
 #include <linux/net.h>
 #include <linux/slab.h>
 
+#include <crypto/internal/compress.h>
+
 #define DEFLATE_DEF_LEVEL		Z_DEFAULT_COMPRESSION
 #define DEFLATE_DEF_WINBITS		11
 #define DEFLATE_DEF_MEMLEVEL		MAX_MEM_LEVEL
 
 struct deflate_ctx {
+	struct deflate_comp_params params;
 	struct z_stream_s comp_stream;
 	struct z_stream_s decomp_stream;
 };
@@ -47,24 +44,27 @@ static int deflate_comp_init(struct deflate_ctx *ctx)
 {
 	int ret = 0;
 	struct z_stream_s *stream = &ctx->comp_stream;
+	size_t workspacesize;
 
-	stream->workspace = vmalloc(zlib_deflate_workspacesize());
-	if (!stream->workspace ) {
+	workspacesize = zlib_deflate_workspacesize();
+	stream->workspace = vmalloc(workspacesize);
+	if (!stream->workspace) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	memset(stream->workspace, 0, zlib_deflate_workspacesize());
-	ret = zlib_deflateInit2(stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
-	                        -DEFLATE_DEF_WINBITS, DEFLATE_DEF_MEMLEVEL,
-	                        Z_DEFAULT_STRATEGY);
+	memset(stream->workspace, 0, workspacesize);
+	ret = zlib_deflateInit2(stream, ctx->params.level, ctx->params.method,
+				ctx->params.windowBits, ctx->params.memLevel,
+				ctx->params.strategy);
 	if (ret != Z_OK) {
 		ret = -EINVAL;
 		goto out_free;
 	}
-out:	
+out:
 	return ret;
 out_free:
 	vfree(stream->workspace);
+	stream->workspace = NULL;
 	goto out;
 }
 
@@ -74,11 +74,11 @@ static int deflate_decomp_init(struct deflate_ctx *ctx)
 	struct z_stream_s *stream = &ctx->decomp_stream;
 
 	stream->workspace = kzalloc(zlib_inflate_workspacesize(), GFP_KERNEL);
-	if (!stream->workspace ) {
+	if (!stream->workspace) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	ret = zlib_inflateInit2(stream, -DEFLATE_DEF_WINBITS);
+	ret = zlib_inflateInit2(stream, ctx->params.windowBits);
 	if (ret != Z_OK) {
 		ret = -EINVAL;
 		goto out_free;
@@ -87,34 +87,35 @@ out:
 	return ret;
 out_free:
 	kfree(stream->workspace);
+	stream->workspace = NULL;
 	goto out;
 }
 
 static void deflate_comp_exit(struct deflate_ctx *ctx)
 {
-	zlib_deflateEnd(&ctx->comp_stream);
-	vfree(ctx->comp_stream.workspace);
+	struct z_stream_s *stream = &ctx->comp_stream;
+
+	if (stream->workspace) {
+		zlib_deflateEnd(stream);
+		vfree(stream->workspace);
+		stream->workspace = NULL;
+	}
 }
 
 static void deflate_decomp_exit(struct deflate_ctx *ctx)
 {
-	zlib_inflateEnd(&ctx->decomp_stream);
-	kfree(ctx->decomp_stream.workspace);
+	struct z_stream_s *stream = &ctx->decomp_stream;
+
+	if (stream->workspace) {
+		zlib_inflateEnd(stream);
+		kfree(stream->workspace);
+		stream->workspace = NULL;
+	}
 }
 
 static int deflate_init(struct crypto_tfm *tfm)
 {
-	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
-	int ret;
-	
-	ret = deflate_comp_init(ctx);
-	if (ret)
-		goto out;
-	ret = deflate_decomp_init(ctx);
-	if (ret)
-		deflate_comp_exit(ctx);
-out:
-	return ret;
+	return 0;
 }
 
 static void deflate_exit(struct crypto_tfm *tfm)
@@ -125,103 +126,260 @@ static void deflate_exit(struct crypto_tfm *tfm)
 	deflate_decomp_exit(ctx);
 }
 
-static int deflate_compress(struct crypto_tfm *tfm, const u8 *src,
-			    unsigned int slen, u8 *dst, unsigned int *dlen)
+static int deflate_setup(struct crypto_tfm *tfm, const void *params)
 {
-	int ret = 0;
+	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
+	const struct deflate_comp_params *zparams = params;
+	int ret;
+
+	deflate_comp_exit(ctx);
+	deflate_decomp_exit(ctx);
+
+	ctx->params = *zparams;
+
+	if (zparams->enable_comp) {
+		ret = deflate_comp_init(ctx);
+		if (ret)
+			return ret;
+	}
+
+	if (zparams->enable_decomp) {
+		ret = deflate_decomp_init(ctx);
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
+static int deflate_compress_init(struct crypto_tfm *tfm)
+{
+	int ret;
 	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
 	struct z_stream_s *stream = &dctx->comp_stream;
 
 	ret = zlib_deflateReset(stream);
-	if (ret != Z_OK) {
-		ret = -EINVAL;
-		goto out;
+	if (ret != Z_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int deflate_compress_update(struct crypto_tfm *tfm,
+				   struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream = &dctx->comp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
+
+	ret = zlib_deflate(stream, Z_NO_FLUSH);
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
 
-	stream->next_in = (u8 *)src;
-	stream->avail_in = slen;
-	stream->next_out = (u8 *)dst;
-	stream->avail_out = *dlen;
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in = stream->next_in;
+	req->avail_in = stream->avail_in;
+	req->next_out = stream->next_out;
+	req->avail_out = stream->avail_out;
+	return 0;
+}
+
+static int deflate_compress_final(struct crypto_tfm *tfm,
+				  struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream = &dctx->comp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
 
 	ret = zlib_deflate(stream, Z_FINISH);
 	if (ret != Z_STREAM_END) {
-		ret = -EINVAL;
-		goto out;
+		pr_debug("zlib_deflate failed %d\n", ret);
+		return -EINVAL;
 	}
-	ret = 0;
-	*dlen = stream->total_out;
-out:
-	return ret;
+
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in = stream->next_in;
+	req->avail_in = stream->avail_in;
+	req->next_out = stream->next_out;
+	req->avail_out = stream->avail_out;
+	return 0;
 }
- 
-static int deflate_decompress(struct crypto_tfm *tfm, const u8 *src,
-			      unsigned int slen, u8 *dst, unsigned int *dlen)
+
+static int deflate_decompress_init(struct crypto_tfm *tfm)
 {
-	
-	int ret = 0;
+	int ret;
 	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
 	struct z_stream_s *stream = &dctx->decomp_stream;
 
 	ret = zlib_inflateReset(stream);
-	if (ret != Z_OK) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (ret != Z_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int deflate_decompress_update(struct crypto_tfm *tfm,
+				     struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream = &dctx->decomp_stream;
 
-	stream->next_in = (u8 *)src;
-	stream->avail_in = slen;
-	stream->next_out = (u8 *)dst;
-	stream->avail_out = *dlen;
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
 
 	ret = zlib_inflate(stream, Z_SYNC_FLUSH);
-	/*
-	 * Work around a bug in zlib, which sometimes wants to taste an extra
-	 * byte when being used in the (undocumented) raw deflate mode.
-	 * (From USAGI).
-	 */
-	if (ret == Z_OK && !stream->avail_in && stream->avail_out) {
-		u8 zerostuff = 0;
-		stream->next_in = &zerostuff;
-		stream->avail_in = 1; 
-		ret = zlib_inflate(stream, Z_FINISH);
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
+
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in = stream->next_in;
+	req->avail_in = stream->avail_in;
+	req->next_out = stream->next_out;
+	req->avail_out = stream->avail_out;
+	return 0;
+}
+
+static int deflate_decompress_final(struct crypto_tfm *tfm,
+				    struct comp_request *req)
+{
+	int ret;
+	struct deflate_ctx *dctx = crypto_tfm_ctx(tfm);
+	struct z_stream_s *stream = &dctx->decomp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
+
+	if (dctx->params.windowBits < 0) {
+		ret = zlib_inflate(stream, Z_SYNC_FLUSH);
+		/*
+		 * Work around a bug in zlib, which sometimes wants to taste an
+		 * extra byte when being used in the (undocumented) raw deflate
+		 * mode. (From USAGI).
+		 */
+		if (ret == Z_OK && !stream->avail_in && stream->avail_out) {
+			const void *saved_next_in = stream->next_in;
+			u8 zerostuff = 0;
+
+			stream->next_in = &zerostuff;
+			stream->avail_in = 1;
+			ret = zlib_inflate(stream, Z_FINISH);
+			stream->next_in = saved_next_in;
+			stream->avail_in = 0;
+		}
+	} else
+		ret = zlib_inflate(stream, Z_FINISH);
 	if (ret != Z_STREAM_END) {
-		ret = -EINVAL;
-		goto out;
+		pr_debug("zlib_inflate failed %d\n", ret);
+		return -EINVAL;
 	}
-	ret = 0;
-	*dlen = stream->total_out;
-out:
-	return ret;
+
+	pr_debug("avail_in %u, avail_out %u (consumed %u, produced %u)\n",
+		 stream->avail_in, stream->avail_out,
+		 req->avail_in - stream->avail_in,
+		 req->avail_out - stream->avail_out);
+	req->next_in = stream->next_in;
+	req->avail_in = stream->avail_in;
+	req->next_out = stream->next_out;
+	req->avail_out = stream->avail_out;
+	return 0;
 }
 
-static struct crypto_alg alg = {
-	.cra_name		= "deflate",
-	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
-	.cra_ctxsize		= sizeof(struct deflate_ctx),
-	.cra_module		= THIS_MODULE,
-	.cra_list		= LIST_HEAD_INIT(alg.cra_list),
-	.cra_init		= deflate_init,
-	.cra_exit		= deflate_exit,
-	.cra_u			= { .compress = {
-	.coa_compress 		= deflate_compress,
-	.coa_decompress  	= deflate_decompress } }
+
+static const struct deflate_comp_params deflate_default_params = {
+	.enable_comp		= 1,
+	.enable_decomp		= 1,
+	.windowBits		= -DEFLATE_DEF_WINBITS,
+	.level			= DEFLATE_DEF_LEVEL,
+	.method			= Z_DEFLATED,
+	.memLevel		= DEFLATE_DEF_MEMLEVEL,
+	.strategy		= Z_DEFAULT_STRATEGY
+};
+
+static struct pcomp_alg alg = {
+	.setup			= deflate_setup,
+	.compress_init		= deflate_compress_init,
+	.compress_update	= deflate_compress_update,
+	.compress_final		= deflate_compress_final,
+	.decompress_init	= deflate_decompress_init,
+	.decompress_update	= deflate_decompress_update,
+	.decompress_final	= deflate_decompress_final,
+
+	.default_params		= &deflate_default_params,
+	.base			= {
+		.cra_name	= "deflate",
+		.cra_flags	= CRYPTO_ALG_TYPE_PCOMPRESS,
+		.cra_ctxsize	= sizeof(struct deflate_ctx),
+		.cra_init	= deflate_init,
+		.cra_exit	= deflate_exit,
+	}
 };
 
 static int __init deflate_mod_init(void)
 {
-	return crypto_register_alg(&alg);
+	return crypto_register_pcomp(&alg);
 }
 
 static void __exit deflate_mod_fini(void)
 {
-	crypto_unregister_alg(&alg);
+	crypto_unregister_pcomp(&alg);
 }
 
 module_init(deflate_mod_init);
 module_exit(deflate_mod_fini);
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Deflate Compression Algorithm for IPCOMP");
+MODULE_DESCRIPTION("Deflate Compression Algorithm");
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
 
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
index 8b3e816..c4798fe 100644
--- a/include/crypto/compress.h
+++ b/include/crypto/compress.h
@@ -30,6 +30,18 @@ struct comp_request {
 	unsigned int avail_out;		/* bytes available at next_out */
 };
 
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
 struct pcomp_alg {
 	int (*setup)(struct crypto_tfm *tfm, const void *params);
 	int (*compress_init)(struct crypto_tfm *tfm);
-- 
1.6.0.4

