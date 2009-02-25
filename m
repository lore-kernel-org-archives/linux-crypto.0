From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: [PATCH 4/6] crypto: new zlib crypto module, using pcomp
Date: Wed, 25 Feb 2009 14:43:12 +0100
Message-ID: <1235569394-15217-5-git-send-email-Geert.Uytterhoeven@sonycom.com>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-3-git-send-email-Geert.Uytterhoeven@sonycom.com>
 <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
	James Morris <jmorris@namei.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63877 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754282AbZBYNnU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 08:43:20 -0500
In-Reply-To: <1235569394-15217-4-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: James Morris <jmorris@namei.org>
---
 crypto/Kconfig            |    9 +
 crypto/Makefile           |    1 +
 crypto/zlib.c             |  378 +++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/compress.h |   20 +++
 4 files changed, 408 insertions(+), 0 deletions(-)
 create mode 100644 crypto/zlib.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index c00c985..8845eff 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -743,6 +743,15 @@ config CRYPTO_DEFLATE
 
 	  You will most probably want this if using IPSec.
 
+config CRYPTO_ZLIB
+	tristate "Zlib compression algorithm"
+	select CRYPTO_PCOMP
+	select ZLIB_INFLATE
+	select ZLIB_DEFLATE
+	select NLATTR
+	help
+	  This is the zlib algorithm.
+
 config CRYPTO_LZO
 	tristate "LZO compression algorithm"
 	select CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
index 8de194f..836a764 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -72,6 +72,7 @@ obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
 obj-$(CONFIG_CRYPTO_SEED) += seed.o
 obj-$(CONFIG_CRYPTO_SALSA20) += salsa20_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
+obj-$(CONFIG_CRYPTO_ZLIB) += zlib.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o
diff --git a/crypto/zlib.c b/crypto/zlib.c
new file mode 100644
index 0000000..33609ba
--- /dev/null
+++ b/crypto/zlib.c
@@ -0,0 +1,378 @@
+/*
+ * Cryptographic API.
+ *
+ * Zlib algorithm
+ *
+ * Copyright 2008 Sony Corporation
+ *
+ * Based on deflate.c, which is
+ * Copyright (c) 2003 James Morris <jmorris@intercode.com.au>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ * FIXME: deflate transforms will require up to a total of about 436k of kernel
+ * memory on i386 (390k for compression, the rest for decompression), as the
+ * current zlib kernel code uses a worst case pre-allocation system by default.
+ * This needs to be fixed so that the amount of memory required is properly
+ * related to the winbits and memlevel parameters.
+ */
+
+#define pr_fmt(fmt)	"%s: " fmt, __func__
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/zlib.h>
+#include <linux/vmalloc.h>
+#include <linux/interrupt.h>
+#include <linux/mm.h>
+#include <linux/net.h>
+#include <linux/slab.h>
+
+#include <crypto/internal/compress.h>
+
+#include <net/netlink.h>
+
+
+struct zlib_ctx {
+	struct z_stream_s comp_stream;
+	struct z_stream_s decomp_stream;
+	int decomp_windowBits;
+};
+
+
+static void zlib_comp_exit(struct zlib_ctx *ctx)
+{
+	struct z_stream_s *stream = &ctx->comp_stream;
+
+	if (stream->workspace) {
+		zlib_deflateEnd(stream);
+		vfree(stream->workspace);
+		stream->workspace = NULL;
+	}
+}
+
+static void zlib_decomp_exit(struct zlib_ctx *ctx)
+{
+	struct z_stream_s *stream = &ctx->decomp_stream;
+
+	if (stream->workspace) {
+		zlib_inflateEnd(stream);
+		kfree(stream->workspace);
+		stream->workspace = NULL;
+	}
+}
+
+static int zlib_init(struct crypto_tfm *tfm)
+{
+	return 0;
+}
+
+static void zlib_exit(struct crypto_tfm *tfm)
+{
+	struct zlib_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	zlib_comp_exit(ctx);
+	zlib_decomp_exit(ctx);
+}
+
+
+static int zlib_compress_setup(struct crypto_pcomp *tfm, void *params,
+			       unsigned int len)
+{
+	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
+	struct z_stream_s *stream = &ctx->comp_stream;
+	struct nlattr *tb[ZLIB_COMP_MAX + 1];
+	size_t workspacesize;
+	int ret;
+
+	ret = nla_parse(tb, ZLIB_COMP_MAX, params, len, NULL);
+	if (ret)
+		return ret;
+
+	zlib_comp_exit(ctx);
+
+	workspacesize = zlib_deflate_workspacesize();
+	stream->workspace = vmalloc(workspacesize);
+	if (!stream->workspace)
+		return -ENOMEM;
+
+	memset(stream->workspace, 0, workspacesize);
+	ret = zlib_deflateInit2(stream,
+				tb[ZLIB_COMP_LEVEL]
+					? nla_get_u32(tb[ZLIB_COMP_LEVEL])
+					: Z_DEFAULT_COMPRESSION,
+				tb[ZLIB_COMP_METHOD]
+					? nla_get_u32(tb[ZLIB_COMP_METHOD])
+					: Z_DEFLATED,
+				tb[ZLIB_COMP_WINDOWBITS]
+					? nla_get_u32(tb[ZLIB_COMP_WINDOWBITS])
+					: MAX_WBITS,
+				tb[ZLIB_COMP_MEMLEVEL]
+					? nla_get_u32(tb[ZLIB_COMP_MEMLEVEL])
+					: DEF_MEM_LEVEL,
+				tb[ZLIB_COMP_STRATEGY]
+					? nla_get_u32(tb[ZLIB_COMP_STRATEGY])
+					: Z_DEFAULT_STRATEGY);
+	if (ret != Z_OK) {
+		vfree(stream->workspace);
+		stream->workspace = NULL;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int zlib_compress_init(struct crypto_pcomp *tfm)
+{
+	int ret;
+	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
+	struct z_stream_s *stream = &dctx->comp_stream;
+
+	ret = zlib_deflateReset(stream);
+	if (ret != Z_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int zlib_compress_update(struct crypto_pcomp *tfm,
+				struct comp_request *req)
+{
+	int ret;
+	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
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
+	}
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
+static int zlib_compress_final(struct crypto_pcomp *tfm,
+			       struct comp_request *req)
+{
+	int ret;
+	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
+	struct z_stream_s *stream = &dctx->comp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
+
+	ret = zlib_deflate(stream, Z_FINISH);
+	if (ret != Z_STREAM_END) {
+		pr_debug("zlib_deflate failed %d\n", ret);
+		return -EINVAL;
+	}
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
+
+static int zlib_decompress_setup(struct crypto_pcomp *tfm, void *params,
+				 unsigned int len)
+{
+	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
+	struct z_stream_s *stream = &ctx->decomp_stream;
+	struct nlattr *tb[ZLIB_DECOMP_MAX + 1];
+	int ret = 0;
+
+	ret = nla_parse(tb, ZLIB_DECOMP_MAX, params, len, NULL);
+	if (ret)
+		return ret;
+
+	zlib_decomp_exit(ctx);
+
+	ctx->decomp_windowBits = tb[ZLIB_DECOMP_WINDOWBITS]
+				 ? nla_get_u32(tb[ZLIB_DECOMP_WINDOWBITS])
+				 : DEF_WBITS;
+
+	stream->workspace = kzalloc(zlib_inflate_workspacesize(), GFP_KERNEL);
+	if (!stream->workspace)
+		return -ENOMEM;
+
+	ret = zlib_inflateInit2(stream, ctx->decomp_windowBits);
+	if (ret != Z_OK) {
+		kfree(stream->workspace);
+		stream->workspace = NULL;
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int zlib_decompress_init(struct crypto_pcomp *tfm)
+{
+	int ret;
+	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
+	struct z_stream_s *stream = &dctx->decomp_stream;
+
+	ret = zlib_inflateReset(stream);
+	if (ret != Z_OK)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int zlib_decompress_update(struct crypto_pcomp *tfm,
+				  struct comp_request *req)
+{
+	int ret;
+	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
+	struct z_stream_s *stream = &dctx->decomp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
+
+	ret = zlib_inflate(stream, Z_SYNC_FLUSH);
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
+	}
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
+static int zlib_decompress_final(struct crypto_pcomp *tfm,
+				 struct comp_request *req)
+{
+	int ret;
+	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
+	struct z_stream_s *stream = &dctx->decomp_stream;
+
+	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
+	stream->next_in = req->next_in;
+	stream->avail_in = req->avail_in;
+	stream->next_out = req->next_out;
+	stream->avail_out = req->avail_out;
+
+	if (dctx->decomp_windowBits < 0) {
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
+	if (ret != Z_STREAM_END) {
+		pr_debug("zlib_inflate failed %d\n", ret);
+		return -EINVAL;
+	}
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
+
+static struct pcomp_alg zlib_alg = {
+	.compress_setup		= zlib_compress_setup,
+	.compress_init		= zlib_compress_init,
+	.compress_update	= zlib_compress_update,
+	.compress_final		= zlib_compress_final,
+	.decompress_setup	= zlib_decompress_setup,
+	.decompress_init	= zlib_decompress_init,
+	.decompress_update	= zlib_decompress_update,
+	.decompress_final	= zlib_decompress_final,
+
+	.base			= {
+		.cra_name	= "zlib",
+		.cra_flags	= CRYPTO_ALG_TYPE_PCOMPRESS,
+		.cra_ctxsize	= sizeof(struct zlib_ctx),
+		.cra_module	= THIS_MODULE,
+		.cra_init	= zlib_init,
+		.cra_exit	= zlib_exit,
+	}
+};
+
+static int __init zlib_mod_init(void)
+{
+	return crypto_register_pcomp(&zlib_alg);
+}
+
+static void __exit zlib_mod_fini(void)
+{
+	crypto_unregister_pcomp(&zlib_alg);
+}
+
+module_init(zlib_mod_init);
+module_exit(zlib_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Zlib Compression Algorithm");
+MODULE_AUTHOR("Sony Corporation");
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
index b7d2287..86163ef 100644
--- a/include/crypto/compress.h
+++ b/include/crypto/compress.h
@@ -30,6 +30,26 @@ struct comp_request {
 	unsigned int avail_out;		/* bytes available at next_out */
 };
 
+enum zlib_comp_params {
+	ZLIB_COMP_LEVEL = 1,		/* e.g. Z_DEFAULT_COMPRESSION */
+	ZLIB_COMP_METHOD,		/* e.g. Z_DEFLATED */
+	ZLIB_COMP_WINDOWBITS,		/* e.g. MAX_WBITS */
+	ZLIB_COMP_MEMLEVEL,		/* e.g. DEF_MEM_LEVEL */
+	ZLIB_COMP_STRATEGY,		/* e.g. Z_DEFAULT_STRATEGY */
+	__ZLIB_COMP_MAX,
+};
+
+#define ZLIB_COMP_MAX	(__ZLIB_COMP_MAX - 1)
+
+
+enum zlib_decomp_params {
+	ZLIB_DECOMP_WINDOWBITS = 1,	/* e.g. DEF_WBITS */
+	__ZLIB_DECOMP_MAX,
+};
+
+#define ZLIB_DECOMP_MAX	(__ZLIB_DECOMP_MAX - 1)
+
+
 struct crypto_pcomp {
 	struct crypto_tfm base;
 };
-- 
1.6.0.4

