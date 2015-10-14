From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v4 1/8] crypto/compress: introduce contextless compression and remove unused pcomp
Date: Wed, 14 Oct 2015 16:38:17 +0900
Message-ID: <1444808304-29320-2-git-send-email-iamjoonsoo.kim@lge.com>
References: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444808304-29320-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Until now, tfm for crypto compression embeds (de)compression context.
According to (de)compression algorithm, requirement on context varys but
to be safe to use (de)compression API, tfm should be passed to
(de)compression API one by one.

This causes unbearable overhead in some cases. For example, if someone
want to decompress 100 data in parallel with LZO, 100 tfms are needed and
it causes large memory overhead. But, LZO algorithm doesn't require
context in decompress so if we directly use decompress on LZO lib we don't
need 100 contexts in tfms thus there is no memory overhead.

This patch tries to fix this problem by introducing new compression API,
contextless compression. Although above problem can be solved by some
modifications on existing compression API, but, crypto maintainer, Herbert
recommends introducing new API because existing compression API
is obsolete.

This new compression API doesn't require user to use tfm one by one.
Tfm is only used for distinguish compression algorithm and maybe keeping
algorithm parameter so can be used concurrently. Context is now separate
from tfm and user needs to allocate and manage it separately.

crypto_ccomp_decomp_noctx() is provided to distinguish compression
algorithm which doesn't require context in decompression. If context isn't
needed, user can decompress something without passing allocated context
and can get maximum performance without additional memory overhead.

This API will be used in zram in following patches.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 crypto/Kconfig                     |  17 +-
 crypto/Makefile                    |   3 +-
 crypto/ccompress.c                 |  95 +++++++++
 crypto/pcompress.c                 | 115 -----------
 crypto/zlib.c                      | 381 -------------------------------------
 include/crypto/compress.h          | 118 ++++--------
 include/crypto/internal/compress.h |  28 ---
 include/linux/crypto.h             |   2 +-
 8 files changed, 134 insertions(+), 625 deletions(-)
 create mode 100644 crypto/ccompress.c
 delete mode 100644 crypto/pcompress.c
 delete mode 100644 crypto/zlib.c
 delete mode 100644 include/crypto/internal/compress.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index fc93444..cfc42e6 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -84,14 +84,8 @@ config CRYPTO_RNG_DEFAULT
 	tristate
 	select CRYPTO_DRBG_MENU
 
-config CRYPTO_PCOMP
+config CRYPTO_CCOMPRESS
 	tristate
-	select CRYPTO_PCOMP2
-	select CRYPTO_ALGAPI
-
-config CRYPTO_PCOMP2
-	tristate
-	select CRYPTO_ALGAPI2
 
 config CRYPTO_AKCIPHER2
 	tristate
@@ -1497,15 +1491,6 @@ config CRYPTO_DEFLATE
 
 	  You will most probably want this if using IPSec.
 
-config CRYPTO_ZLIB
-	tristate "Zlib compression algorithm"
-	select CRYPTO_PCOMP
-	select ZLIB_INFLATE
-	select ZLIB_DEFLATE
-	select NLATTR
-	help
-	  This is the zlib algorithm.
-
 config CRYPTO_LZO
 	tristate "LZO compression algorithm"
 	select CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
index e2c5981..93adbfe 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -28,7 +28,7 @@ crypto_hash-y += ahash.o
 crypto_hash-y += shash.o
 obj-$(CONFIG_CRYPTO_HASH2) += crypto_hash.o
 
-obj-$(CONFIG_CRYPTO_PCOMP2) += pcompress.o
+obj-$(CONFIG_CRYPTO_CCOMPRESS) += ccompress.o
 obj-$(CONFIG_CRYPTO_AKCIPHER2) += akcipher.o
 
 $(obj)/rsakey-asn1.o: $(obj)/rsakey-asn1.c $(obj)/rsakey-asn1.h
@@ -94,7 +94,6 @@ obj-$(CONFIG_CRYPTO_SALSA20) += salsa20_generic.o
 obj-$(CONFIG_CRYPTO_CHACHA20) += chacha20_generic.o
 obj-$(CONFIG_CRYPTO_POLY1305) += poly1305_generic.o
 obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
-obj-$(CONFIG_CRYPTO_ZLIB) += zlib.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32.o
diff --git a/crypto/ccompress.c b/crypto/ccompress.c
new file mode 100644
index 0000000..1983372
--- /dev/null
+++ b/crypto/ccompress.c
@@ -0,0 +1,95 @@
+/*
+ * Cryptographic API.
+ *
+ * Contextless (de)compression operations.
+ *
+ * Copyright 2015 LG Electronics Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; version 2 of the License.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.
+ * If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/crypto.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+
+#include <crypto/compress.h>
+
+#include "internal.h"
+
+
+static int crypto_ccomp_init(struct crypto_tfm *tfm, u32 type, u32 mask)
+{
+	return 0;
+}
+
+static int crypto_ccomp_init_tfm(struct crypto_tfm *tfm)
+{
+	return 0;
+}
+
+static int crypto_ccomp_report(struct sk_buff *skb, struct crypto_alg *alg)
+{
+	return -EINVAL;
+}
+
+static void crypto_ccomp_show(struct seq_file *m, struct crypto_alg *alg)
+	__attribute__ ((unused));
+static void crypto_ccomp_show(struct seq_file *m, struct crypto_alg *alg)
+{
+	seq_puts(m, "type         : ccomp\n");
+}
+
+static const struct crypto_type crypto_ccomp_type = {
+	.extsize	= crypto_alg_extsize,
+	.init		= crypto_ccomp_init,
+	.init_tfm	= crypto_ccomp_init_tfm,
+#ifdef CONFIG_PROC_FS
+	.show		= crypto_ccomp_show,
+#endif
+	.report		= crypto_ccomp_report,
+	.maskclear	= ~CRYPTO_ALG_TYPE_MASK,
+	.maskset	= CRYPTO_ALG_TYPE_MASK,
+	.type		= CRYPTO_ALG_TYPE_CCOMPRESS,
+	.tfmsize	= offsetof(struct crypto_ccomp, base),
+};
+
+struct crypto_ccomp *crypto_alloc_ccomp(const char *alg_name, u32 type,
+					u32 mask)
+{
+	return crypto_alloc_tfm(alg_name, &crypto_ccomp_type, type, mask);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_ccomp);
+
+int crypto_register_ccomp(struct ccomp_alg *alg)
+{
+	struct crypto_alg *base = &alg->base;
+
+	base->cra_type = &crypto_ccomp_type;
+	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
+	base->cra_flags |= CRYPTO_ALG_TYPE_CCOMPRESS;
+
+	return crypto_register_alg(base);
+}
+EXPORT_SYMBOL_GPL(crypto_register_ccomp);
+
+int crypto_unregister_ccomp(struct ccomp_alg *alg)
+{
+	return crypto_unregister_alg(&alg->base);
+}
+EXPORT_SYMBOL_GPL(crypto_unregister_ccomp);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Contextless (de)compression operations");
+MODULE_AUTHOR("LG Electronics Inc.");
diff --git a/crypto/pcompress.c b/crypto/pcompress.c
deleted file mode 100644
index 7a13b40..0000000
--- a/crypto/pcompress.c
+++ /dev/null
@@ -1,115 +0,0 @@
-/*
- * Cryptographic API.
- *
- * Partial (de)compression operations.
- *
- * Copyright 2008 Sony Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.
- * If not, see <http://www.gnu.org/licenses/>.
- */
-
-#include <linux/crypto.h>
-#include <linux/errno.h>
-#include <linux/module.h>
-#include <linux/seq_file.h>
-#include <linux/string.h>
-#include <linux/cryptouser.h>
-#include <net/netlink.h>
-
-#include <crypto/compress.h>
-#include <crypto/internal/compress.h>
-
-#include "internal.h"
-
-
-static int crypto_pcomp_init(struct crypto_tfm *tfm, u32 type, u32 mask)
-{
-	return 0;
-}
-
-static int crypto_pcomp_init_tfm(struct crypto_tfm *tfm)
-{
-	return 0;
-}
-
-#ifdef CONFIG_NET
-static int crypto_pcomp_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	struct crypto_report_comp rpcomp;
-
-	strncpy(rpcomp.type, "pcomp", sizeof(rpcomp.type));
-	if (nla_put(skb, CRYPTOCFGA_REPORT_COMPRESS,
-		    sizeof(struct crypto_report_comp), &rpcomp))
-		goto nla_put_failure;
-	return 0;
-
-nla_put_failure:
-	return -EMSGSIZE;
-}
-#else
-static int crypto_pcomp_report(struct sk_buff *skb, struct crypto_alg *alg)
-{
-	return -ENOSYS;
-}
-#endif
-
-static void crypto_pcomp_show(struct seq_file *m, struct crypto_alg *alg)
-	__attribute__ ((unused));
-static void crypto_pcomp_show(struct seq_file *m, struct crypto_alg *alg)
-{
-	seq_printf(m, "type         : pcomp\n");
-}
-
-static const struct crypto_type crypto_pcomp_type = {
-	.extsize	= crypto_alg_extsize,
-	.init		= crypto_pcomp_init,
-	.init_tfm	= crypto_pcomp_init_tfm,
-#ifdef CONFIG_PROC_FS
-	.show		= crypto_pcomp_show,
-#endif
-	.report		= crypto_pcomp_report,
-	.maskclear	= ~CRYPTO_ALG_TYPE_MASK,
-	.maskset	= CRYPTO_ALG_TYPE_MASK,
-	.type		= CRYPTO_ALG_TYPE_PCOMPRESS,
-	.tfmsize	= offsetof(struct crypto_pcomp, base),
-};
-
-struct crypto_pcomp *crypto_alloc_pcomp(const char *alg_name, u32 type,
-					u32 mask)
-{
-	return crypto_alloc_tfm(alg_name, &crypto_pcomp_type, type, mask);
-}
-EXPORT_SYMBOL_GPL(crypto_alloc_pcomp);
-
-int crypto_register_pcomp(struct pcomp_alg *alg)
-{
-	struct crypto_alg *base = &alg->base;
-
-	base->cra_type = &crypto_pcomp_type;
-	base->cra_flags &= ~CRYPTO_ALG_TYPE_MASK;
-	base->cra_flags |= CRYPTO_ALG_TYPE_PCOMPRESS;
-
-	return crypto_register_alg(base);
-}
-EXPORT_SYMBOL_GPL(crypto_register_pcomp);
-
-int crypto_unregister_pcomp(struct pcomp_alg *alg)
-{
-	return crypto_unregister_alg(&alg->base);
-}
-EXPORT_SYMBOL_GPL(crypto_unregister_pcomp);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Partial (de)compression type");
-MODULE_AUTHOR("Sony Corporation");
diff --git a/crypto/zlib.c b/crypto/zlib.c
deleted file mode 100644
index d51a30a..0000000
--- a/crypto/zlib.c
+++ /dev/null
@@ -1,381 +0,0 @@
-/*
- * Cryptographic API.
- *
- * Zlib algorithm
- *
- * Copyright 2008 Sony Corporation
- *
- * Based on deflate.c, which is
- * Copyright (c) 2003 James Morris <jmorris@intercode.com.au>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * FIXME: deflate transforms will require up to a total of about 436k of kernel
- * memory on i386 (390k for compression, the rest for decompression), as the
- * current zlib kernel code uses a worst case pre-allocation system by default.
- * This needs to be fixed so that the amount of memory required is properly
- * related to the winbits and memlevel parameters.
- */
-
-#define pr_fmt(fmt)	"%s: " fmt, __func__
-
-#include <linux/init.h>
-#include <linux/module.h>
-#include <linux/zlib.h>
-#include <linux/vmalloc.h>
-#include <linux/interrupt.h>
-#include <linux/mm.h>
-#include <linux/net.h>
-
-#include <crypto/internal/compress.h>
-
-#include <net/netlink.h>
-
-
-struct zlib_ctx {
-	struct z_stream_s comp_stream;
-	struct z_stream_s decomp_stream;
-	int decomp_windowBits;
-};
-
-
-static void zlib_comp_exit(struct zlib_ctx *ctx)
-{
-	struct z_stream_s *stream = &ctx->comp_stream;
-
-	if (stream->workspace) {
-		zlib_deflateEnd(stream);
-		vfree(stream->workspace);
-		stream->workspace = NULL;
-	}
-}
-
-static void zlib_decomp_exit(struct zlib_ctx *ctx)
-{
-	struct z_stream_s *stream = &ctx->decomp_stream;
-
-	if (stream->workspace) {
-		zlib_inflateEnd(stream);
-		vfree(stream->workspace);
-		stream->workspace = NULL;
-	}
-}
-
-static int zlib_init(struct crypto_tfm *tfm)
-{
-	return 0;
-}
-
-static void zlib_exit(struct crypto_tfm *tfm)
-{
-	struct zlib_ctx *ctx = crypto_tfm_ctx(tfm);
-
-	zlib_comp_exit(ctx);
-	zlib_decomp_exit(ctx);
-}
-
-
-static int zlib_compress_setup(struct crypto_pcomp *tfm, const void *params,
-			       unsigned int len)
-{
-	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &ctx->comp_stream;
-	struct nlattr *tb[ZLIB_COMP_MAX + 1];
-	int window_bits, mem_level;
-	size_t workspacesize;
-	int ret;
-
-	ret = nla_parse(tb, ZLIB_COMP_MAX, params, len, NULL);
-	if (ret)
-		return ret;
-
-	zlib_comp_exit(ctx);
-
-	window_bits = tb[ZLIB_COMP_WINDOWBITS]
-					? nla_get_u32(tb[ZLIB_COMP_WINDOWBITS])
-					: MAX_WBITS;
-	mem_level = tb[ZLIB_COMP_MEMLEVEL]
-					? nla_get_u32(tb[ZLIB_COMP_MEMLEVEL])
-					: DEF_MEM_LEVEL;
-
-	workspacesize = zlib_deflate_workspacesize(window_bits, mem_level);
-	stream->workspace = vzalloc(workspacesize);
-	if (!stream->workspace)
-		return -ENOMEM;
-
-	ret = zlib_deflateInit2(stream,
-				tb[ZLIB_COMP_LEVEL]
-					? nla_get_u32(tb[ZLIB_COMP_LEVEL])
-					: Z_DEFAULT_COMPRESSION,
-				tb[ZLIB_COMP_METHOD]
-					? nla_get_u32(tb[ZLIB_COMP_METHOD])
-					: Z_DEFLATED,
-				window_bits,
-				mem_level,
-				tb[ZLIB_COMP_STRATEGY]
-					? nla_get_u32(tb[ZLIB_COMP_STRATEGY])
-					: Z_DEFAULT_STRATEGY);
-	if (ret != Z_OK) {
-		vfree(stream->workspace);
-		stream->workspace = NULL;
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int zlib_compress_init(struct crypto_pcomp *tfm)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->comp_stream;
-
-	ret = zlib_deflateReset(stream);
-	if (ret != Z_OK)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int zlib_compress_update(struct crypto_pcomp *tfm,
-				struct comp_request *req)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->comp_stream;
-
-	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
-	stream->next_in = req->next_in;
-	stream->avail_in = req->avail_in;
-	stream->next_out = req->next_out;
-	stream->avail_out = req->avail_out;
-
-	ret = zlib_deflate(stream, Z_NO_FLUSH);
-	switch (ret) {
-	case Z_OK:
-		break;
-
-	case Z_BUF_ERROR:
-		pr_debug("zlib_deflate could not make progress\n");
-		return -EAGAIN;
-
-	default:
-		pr_debug("zlib_deflate failed %d\n", ret);
-		return -EINVAL;
-	}
-
-	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
-		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in, ret);
-	req->next_in = stream->next_in;
-	req->avail_in = stream->avail_in;
-	req->next_out = stream->next_out;
-	req->avail_out = stream->avail_out;
-	return ret;
-}
-
-static int zlib_compress_final(struct crypto_pcomp *tfm,
-			       struct comp_request *req)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->comp_stream;
-
-	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
-	stream->next_in = req->next_in;
-	stream->avail_in = req->avail_in;
-	stream->next_out = req->next_out;
-	stream->avail_out = req->avail_out;
-
-	ret = zlib_deflate(stream, Z_FINISH);
-	if (ret != Z_STREAM_END) {
-		pr_debug("zlib_deflate failed %d\n", ret);
-		return -EINVAL;
-	}
-
-	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
-		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in, ret);
-	req->next_in = stream->next_in;
-	req->avail_in = stream->avail_in;
-	req->next_out = stream->next_out;
-	req->avail_out = stream->avail_out;
-	return ret;
-}
-
-
-static int zlib_decompress_setup(struct crypto_pcomp *tfm, const void *params,
-				 unsigned int len)
-{
-	struct zlib_ctx *ctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &ctx->decomp_stream;
-	struct nlattr *tb[ZLIB_DECOMP_MAX + 1];
-	int ret = 0;
-
-	ret = nla_parse(tb, ZLIB_DECOMP_MAX, params, len, NULL);
-	if (ret)
-		return ret;
-
-	zlib_decomp_exit(ctx);
-
-	ctx->decomp_windowBits = tb[ZLIB_DECOMP_WINDOWBITS]
-				 ? nla_get_u32(tb[ZLIB_DECOMP_WINDOWBITS])
-				 : DEF_WBITS;
-
-	stream->workspace = vzalloc(zlib_inflate_workspacesize());
-	if (!stream->workspace)
-		return -ENOMEM;
-
-	ret = zlib_inflateInit2(stream, ctx->decomp_windowBits);
-	if (ret != Z_OK) {
-		vfree(stream->workspace);
-		stream->workspace = NULL;
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int zlib_decompress_init(struct crypto_pcomp *tfm)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->decomp_stream;
-
-	ret = zlib_inflateReset(stream);
-	if (ret != Z_OK)
-		return -EINVAL;
-
-	return 0;
-}
-
-static int zlib_decompress_update(struct crypto_pcomp *tfm,
-				  struct comp_request *req)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->decomp_stream;
-
-	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
-	stream->next_in = req->next_in;
-	stream->avail_in = req->avail_in;
-	stream->next_out = req->next_out;
-	stream->avail_out = req->avail_out;
-
-	ret = zlib_inflate(stream, Z_SYNC_FLUSH);
-	switch (ret) {
-	case Z_OK:
-	case Z_STREAM_END:
-		break;
-
-	case Z_BUF_ERROR:
-		pr_debug("zlib_inflate could not make progress\n");
-		return -EAGAIN;
-
-	default:
-		pr_debug("zlib_inflate failed %d\n", ret);
-		return -EINVAL;
-	}
-
-	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
-		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in, ret);
-	req->next_in = stream->next_in;
-	req->avail_in = stream->avail_in;
-	req->next_out = stream->next_out;
-	req->avail_out = stream->avail_out;
-	return ret;
-}
-
-static int zlib_decompress_final(struct crypto_pcomp *tfm,
-				 struct comp_request *req)
-{
-	int ret;
-	struct zlib_ctx *dctx = crypto_tfm_ctx(crypto_pcomp_tfm(tfm));
-	struct z_stream_s *stream = &dctx->decomp_stream;
-
-	pr_debug("avail_in %u, avail_out %u\n", req->avail_in, req->avail_out);
-	stream->next_in = req->next_in;
-	stream->avail_in = req->avail_in;
-	stream->next_out = req->next_out;
-	stream->avail_out = req->avail_out;
-
-	if (dctx->decomp_windowBits < 0) {
-		ret = zlib_inflate(stream, Z_SYNC_FLUSH);
-		/*
-		 * Work around a bug in zlib, which sometimes wants to taste an
-		 * extra byte when being used in the (undocumented) raw deflate
-		 * mode. (From USAGI).
-		 */
-		if (ret == Z_OK && !stream->avail_in && stream->avail_out) {
-			const void *saved_next_in = stream->next_in;
-			u8 zerostuff = 0;
-
-			stream->next_in = &zerostuff;
-			stream->avail_in = 1;
-			ret = zlib_inflate(stream, Z_FINISH);
-			stream->next_in = saved_next_in;
-			stream->avail_in = 0;
-		}
-	} else
-		ret = zlib_inflate(stream, Z_FINISH);
-	if (ret != Z_STREAM_END) {
-		pr_debug("zlib_inflate failed %d\n", ret);
-		return -EINVAL;
-	}
-
-	ret = req->avail_out - stream->avail_out;
-	pr_debug("avail_in %lu, avail_out %lu (consumed %lu, produced %u)\n",
-		 stream->avail_in, stream->avail_out,
-		 req->avail_in - stream->avail_in, ret);
-	req->next_in = stream->next_in;
-	req->avail_in = stream->avail_in;
-	req->next_out = stream->next_out;
-	req->avail_out = stream->avail_out;
-	return ret;
-}
-
-
-static struct pcomp_alg zlib_alg = {
-	.compress_setup		= zlib_compress_setup,
-	.compress_init		= zlib_compress_init,
-	.compress_update	= zlib_compress_update,
-	.compress_final		= zlib_compress_final,
-	.decompress_setup	= zlib_decompress_setup,
-	.decompress_init	= zlib_decompress_init,
-	.decompress_update	= zlib_decompress_update,
-	.decompress_final	= zlib_decompress_final,
-
-	.base			= {
-		.cra_name	= "zlib",
-		.cra_flags	= CRYPTO_ALG_TYPE_PCOMPRESS,
-		.cra_ctxsize	= sizeof(struct zlib_ctx),
-		.cra_module	= THIS_MODULE,
-		.cra_init	= zlib_init,
-		.cra_exit	= zlib_exit,
-	}
-};
-
-static int __init zlib_mod_init(void)
-{
-	return crypto_register_pcomp(&zlib_alg);
-}
-
-static void __exit zlib_mod_fini(void)
-{
-	crypto_unregister_pcomp(&zlib_alg);
-}
-
-module_init(zlib_mod_init);
-module_exit(zlib_mod_fini);
-
-MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("Zlib Compression Algorithm");
-MODULE_AUTHOR("Sony Corporation");
-MODULE_ALIAS_CRYPTO("zlib");
diff --git a/include/crypto/compress.h b/include/crypto/compress.h
index 5b67af8..1ae35ee 100644
--- a/include/crypto/compress.h
+++ b/include/crypto/compress.h
@@ -2,6 +2,7 @@
  * Compress: Compression algorithms under the cryptographic API.
  *
  * Copyright 2008 Sony Corporation
+ * Copyright 2015 LG Electronics Inc.
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -22,124 +23,77 @@
 
 #include <linux/crypto.h>
 
+#define CCOMP_TYPE_DECOMP_NOCTX 0x000000001
 
-struct comp_request {
-	const void *next_in;		/* next input byte */
-	void *next_out;			/* next output byte */
-	unsigned int avail_in;		/* bytes available at next_in */
-	unsigned int avail_out;		/* bytes available at next_out */
-};
-
-enum zlib_comp_params {
-	ZLIB_COMP_LEVEL = 1,		/* e.g. Z_DEFAULT_COMPRESSION */
-	ZLIB_COMP_METHOD,		/* e.g. Z_DEFLATED */
-	ZLIB_COMP_WINDOWBITS,		/* e.g. MAX_WBITS */
-	ZLIB_COMP_MEMLEVEL,		/* e.g. DEF_MEM_LEVEL */
-	ZLIB_COMP_STRATEGY,		/* e.g. Z_DEFAULT_STRATEGY */
-	__ZLIB_COMP_MAX,
-};
-
-#define ZLIB_COMP_MAX	(__ZLIB_COMP_MAX - 1)
-
-
-enum zlib_decomp_params {
-	ZLIB_DECOMP_WINDOWBITS = 1,	/* e.g. DEF_WBITS */
-	__ZLIB_DECOMP_MAX,
-};
-
-#define ZLIB_DECOMP_MAX	(__ZLIB_DECOMP_MAX - 1)
-
-
-struct crypto_pcomp {
+struct crypto_ccomp {
 	struct crypto_tfm base;
 };
 
-struct pcomp_alg {
-	int (*compress_setup)(struct crypto_pcomp *tfm, const void *params,
-			      unsigned int len);
-	int (*compress_init)(struct crypto_pcomp *tfm);
-	int (*compress_update)(struct crypto_pcomp *tfm,
-			       struct comp_request *req);
-	int (*compress_final)(struct crypto_pcomp *tfm,
-			      struct comp_request *req);
-	int (*decompress_setup)(struct crypto_pcomp *tfm, const void *params,
-				unsigned int len);
-	int (*decompress_init)(struct crypto_pcomp *tfm);
-	int (*decompress_update)(struct crypto_pcomp *tfm,
-				 struct comp_request *req);
-	int (*decompress_final)(struct crypto_pcomp *tfm,
-				struct comp_request *req);
+struct ccomp_alg {
+	void *(*alloc_context)(struct crypto_ccomp *tfm);
+	void (*free_context)(struct crypto_ccomp *tfm, void *ctx);
+	int (*compress)(const u8 *src, unsigned int slen, u8 *dst,
+			unsigned int *dlen, void *ctx);
+	int (*decompress)(const u8 *src, unsigned int slen, u8 *dst,
+			unsigned int *dlen, void *ctx);
 
+	unsigned long flags;
 	struct crypto_alg base;
 };
 
-extern struct crypto_pcomp *crypto_alloc_pcomp(const char *alg_name, u32 type,
+extern struct crypto_ccomp *crypto_alloc_ccomp(const char *alg_name, u32 type,
 					       u32 mask);
 
-static inline struct crypto_tfm *crypto_pcomp_tfm(struct crypto_pcomp *tfm)
+static inline struct crypto_tfm *crypto_ccomp_tfm(struct crypto_ccomp *tfm)
 {
 	return &tfm->base;
 }
 
-static inline void crypto_free_pcomp(struct crypto_pcomp *tfm)
-{
-	crypto_destroy_tfm(tfm, crypto_pcomp_tfm(tfm));
-}
-
-static inline struct pcomp_alg *__crypto_pcomp_alg(struct crypto_alg *alg)
-{
-	return container_of(alg, struct pcomp_alg, base);
-}
-
-static inline struct pcomp_alg *crypto_pcomp_alg(struct crypto_pcomp *tfm)
-{
-	return __crypto_pcomp_alg(crypto_pcomp_tfm(tfm)->__crt_alg);
-}
-
-static inline int crypto_compress_setup(struct crypto_pcomp *tfm,
-					const void *params, unsigned int len)
+static inline void crypto_free_ccomp(struct crypto_ccomp *tfm)
 {
-	return crypto_pcomp_alg(tfm)->compress_setup(tfm, params, len);
+	crypto_destroy_tfm(tfm, crypto_ccomp_tfm(tfm));
 }
 
-static inline int crypto_compress_init(struct crypto_pcomp *tfm)
+static inline struct ccomp_alg *__crypto_ccomp_alg(struct crypto_alg *alg)
 {
-	return crypto_pcomp_alg(tfm)->compress_init(tfm);
+	return container_of(alg, struct ccomp_alg, base);
 }
 
-static inline int crypto_compress_update(struct crypto_pcomp *tfm,
-					 struct comp_request *req)
+static inline struct ccomp_alg *crypto_ccomp_alg(struct crypto_ccomp *tfm)
 {
-	return crypto_pcomp_alg(tfm)->compress_update(tfm, req);
+	return __crypto_ccomp_alg(crypto_ccomp_tfm(tfm)->__crt_alg);
 }
 
-static inline int crypto_compress_final(struct crypto_pcomp *tfm,
-					struct comp_request *req)
+static inline void *crypto_ccomp_alloc_context(struct crypto_ccomp *tfm)
 {
-	return crypto_pcomp_alg(tfm)->compress_final(tfm, req);
+	return crypto_ccomp_alg(tfm)->alloc_context(tfm);
 }
 
-static inline int crypto_decompress_setup(struct crypto_pcomp *tfm,
-					  const void *params, unsigned int len)
+static inline void crypto_ccomp_free_context(struct crypto_ccomp *tfm,
+						void *ctx)
 {
-	return crypto_pcomp_alg(tfm)->decompress_setup(tfm, params, len);
+	return crypto_ccomp_alg(tfm)->free_context(tfm, ctx);
 }
 
-static inline int crypto_decompress_init(struct crypto_pcomp *tfm)
+static inline int crypto_ccomp_compress(struct crypto_ccomp *tfm,
+				const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen, void *ctx)
 {
-	return crypto_pcomp_alg(tfm)->decompress_init(tfm);
+	return crypto_ccomp_alg(tfm)->compress(src, slen, dst, dlen, ctx);
 }
 
-static inline int crypto_decompress_update(struct crypto_pcomp *tfm,
-					   struct comp_request *req)
+static inline int crypto_ccomp_decompress(struct crypto_ccomp *tfm,
+				const u8 *src, unsigned int slen,
+				u8 *dst, unsigned int *dlen, void *ctx)
 {
-	return crypto_pcomp_alg(tfm)->decompress_update(tfm, req);
+	return crypto_ccomp_alg(tfm)->decompress(src, slen, dst, dlen, ctx);
 }
 
-static inline int crypto_decompress_final(struct crypto_pcomp *tfm,
-					  struct comp_request *req)
+static inline bool crypto_ccomp_decomp_noctx(struct crypto_ccomp *tfm)
 {
-	return crypto_pcomp_alg(tfm)->decompress_final(tfm, req);
+	return crypto_ccomp_alg(tfm)->flags & CCOMP_TYPE_DECOMP_NOCTX;
 }
 
+extern int crypto_register_ccomp(struct ccomp_alg *alg);
+extern int crypto_unregister_ccomp(struct ccomp_alg *alg);
 #endif	/* _CRYPTO_COMPRESS_H */
diff --git a/include/crypto/internal/compress.h b/include/crypto/internal/compress.h
deleted file mode 100644
index 178a888..0000000
--- a/include/crypto/internal/compress.h
+++ /dev/null
@@ -1,28 +0,0 @@
-/*
- * Compress: Compression algorithms under the cryptographic API.
- *
- * Copyright 2008 Sony Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; version 2 of the License.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program.
- * If not, see <http://www.gnu.org/licenses/>.
- */
-
-#ifndef _CRYPTO_INTERNAL_COMPRESS_H
-#define _CRYPTO_INTERNAL_COMPRESS_H
-
-#include <crypto/compress.h>
-
-extern int crypto_register_pcomp(struct pcomp_alg *alg);
-extern int crypto_unregister_pcomp(struct pcomp_alg *alg);
-
-#endif	/* _CRYPTO_INTERNAL_COMPRESS_H */
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index e71cb70..a581b1e 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -54,7 +54,7 @@
 #define CRYPTO_ALG_TYPE_AHASH		0x0000000a
 #define CRYPTO_ALG_TYPE_RNG		0x0000000c
 #define CRYPTO_ALG_TYPE_AKCIPHER	0x0000000d
-#define CRYPTO_ALG_TYPE_PCOMPRESS	0x0000000f
+#define CRYPTO_ALG_TYPE_CCOMPRESS	0x0000000f
 
 #define CRYPTO_ALG_TYPE_HASH_MASK	0x0000000e
 #define CRYPTO_ALG_TYPE_AHASH_MASK	0x0000000c
-- 
1.9.1
