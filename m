From: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Subject: [PATCH v7 4/5] crypto: configurable compression level
Date: Fri, 13 Apr 2018 17:48:39 +0200
Message-ID: <20180413154840.5901-5-4bwarnke@informatik.uni-hamburg.de>
References: <20180413154840.5901-1-4bwarnke@informatik.uni-hamburg.de>
Cc: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        minchan@kernel.org, sergey.senozhatsky.work@gmail.com,
        ngupta@vflare.org, pombredanne@nexb.com, ebiggers3@gmail.com,
        smueller@chronox.de
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180413154840.5901-1-4bwarnke@informatik.uni-hamburg.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Most compression algorithms published by the crypto api are supporting
multiple different compression levels. The crypto api currently just
calls these algorithms with their default compression level.

This patch enables the caller to specify the compression level.

Signed-off-by: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
---
 crypto/api.c                  | 76 +++++++++++++++++++++++++++++++++++++++++++
 crypto/deflate.c              | 16 +++++----
 crypto/lz4.c                  | 16 +++++----
 crypto/lz4hc.c                | 13 +++++---
 crypto/testmgr.c              |  2 +-
 drivers/block/zram/zcomp.c    | 10 +++---
 drivers/block/zram/zcomp.h    |  3 +-
 drivers/block/zram/zram_drv.c | 24 ++++++++++++--
 drivers/block/zram/zram_drv.h |  1 +
 fs/pstore/platform.c          |  2 +-
 fs/ubifs/compress.c           |  2 +-
 include/linux/crypto.h        |  9 +++--
 mm/zswap.c                    |  2 +-
 net/xfrm/xfrm_ipcomp.c        |  3 +-
 14 files changed, 147 insertions(+), 32 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index 1d5290c6..81c3d416 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -388,6 +388,47 @@ struct crypto_tfm *__crypto_alloc_tfm(struct crypto_alg *alg, u32 type,
 }
 EXPORT_SYMBOL_GPL(__crypto_alloc_tfm);
 
+struct crypto_tfm *__crypto_alloc_tfm_compress(struct crypto_alg *alg,
+					       u32 type, u32 mask, int level)
+{
+	struct crypto_tfm *tfm = NULL;
+	unsigned int tfm_size;
+	int err = -ENOMEM;
+
+	tfm_size = sizeof(*tfm) + crypto_ctxsize(alg, type, mask);
+	tfm = kzalloc(tfm_size, GFP_KERNEL);
+	if (!tfm)
+		goto out_err;
+
+	tfm->__crt_alg = alg;
+	if (alg->cra_flags & CRYPTO_ALG_TYPE_COMPRESS)
+		tfm->crt_compress.cot_level = level;
+
+	err = crypto_init_ops(tfm, type, mask);
+	if (err)
+		goto out_free_tfm;
+
+	if (!tfm->exit && alg->cra_init) {
+		err = alg->cra_init(tfm);
+		if (err)
+			goto cra_init_failed;
+	}
+
+	goto out;
+
+cra_init_failed:
+	crypto_exit_ops(tfm);
+out_free_tfm:
+	if (err == -EAGAIN)
+		crypto_shoot_alg(alg);
+	kfree(tfm);
+out_err:
+	tfm = ERR_PTR(err);
+out:
+	return tfm;
+}
+EXPORT_SYMBOL_GPL(__crypto_alloc_tfm_compress);
+
 /*
  *	crypto_alloc_base - Locate algorithm and allocate transform
  *	@alg_name: Name of algorithm
@@ -444,6 +485,41 @@ struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask)
 }
 EXPORT_SYMBOL_GPL(crypto_alloc_base);
 
+struct crypto_tfm *crypto_alloc_base_compress(const char *alg_name, u32 type,
+					      u32 mask, int level)
+{
+	struct crypto_tfm *tfm;
+	int err;
+
+	for (;;) {
+		struct crypto_alg *alg;
+
+		alg = crypto_alg_mod_lookup(alg_name, type, mask);
+		if (IS_ERR(alg)) {
+			err = PTR_ERR(alg);
+			goto err;
+		}
+
+		tfm = __crypto_alloc_tfm_compress(alg, type, mask, level);
+		if (!IS_ERR(tfm))
+			return tfm;
+
+		crypto_mod_put(alg);
+		err = PTR_ERR(tfm);
+
+err:
+		if (err != -EAGAIN)
+			break;
+		if (fatal_signal_pending(current)) {
+			err = -EINTR;
+			break;
+		}
+	}
+
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL_GPL(crypto_alloc_base_compress);
+
 void *crypto_create_tfm(struct crypto_alg *alg,
 			const struct crypto_type *frontend)
 {
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 4b681a37..54a2ff21 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -24,6 +24,7 @@
  * it is not needed for IPCOMP and keeps the code simpler.  It can be
  * implemented if someone wants it.
  */
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/crypto.h>
@@ -43,7 +44,7 @@ struct deflate_ctx {
 	struct z_stream_s decomp_stream;
 };
 
-static int deflate_comp_init(struct deflate_ctx *ctx, int format)
+static int deflate_comp_init(struct deflate_ctx *ctx, int format, int level)
 {
 	int ret = 0;
 	struct z_stream_s *stream = &ctx->comp_stream;
@@ -55,9 +56,9 @@ static int deflate_comp_init(struct deflate_ctx *ctx, int format)
 		goto out;
 	}
 	if (format)
-		ret = zlib_deflateInit(stream, 3);
+		ret = zlib_deflateInit(stream, level);
 	else
-		ret = zlib_deflateInit2(stream, DEFLATE_DEF_LEVEL, Z_DEFLATED,
+		ret = zlib_deflateInit2(stream, level, Z_DEFLATED,
 					-DEFLATE_DEF_WINBITS,
 					DEFLATE_DEF_MEMLEVEL,
 					Z_DEFAULT_STRATEGY);
@@ -109,11 +110,11 @@ static void deflate_decomp_exit(struct deflate_ctx *ctx)
 	vfree(ctx->decomp_stream.workspace);
 }
 
-static int __deflate_init(void *ctx, int format)
+static int __deflate_init(void *ctx, int format, int level)
 {
 	int ret;
 
-	ret = deflate_comp_init(ctx, format);
+	ret = deflate_comp_init(ctx, format, level);
 	if (ret)
 		goto out;
 	ret = deflate_decomp_init(ctx, format);
@@ -132,7 +133,7 @@ static void *gen_deflate_alloc_ctx(struct crypto_scomp *tfm, int format)
 	if (!ctx)
 		return ERR_PTR(-ENOMEM);
 
-	ret = __deflate_init(ctx, format);
+	ret = __deflate_init(ctx, format, DEFLATE_DEF_LEVEL);
 	if (ret) {
 		kfree(ctx);
 		return ERR_PTR(ret);
@@ -154,8 +155,9 @@ static void *zlib_deflate_alloc_ctx(struct crypto_scomp *tfm)
 static int deflate_init(struct crypto_tfm *tfm)
 {
 	struct deflate_ctx *ctx = crypto_tfm_ctx(tfm);
+	const int level = tfm->crt_compress.cot_level;
 
-	return __deflate_init(ctx, 0);
+	return __deflate_init(ctx, 0, level);
 }
 
 static void __deflate_exit(void *ctx)
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 60a1914b..8486188e 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -63,11 +63,11 @@ static void lz4_exit(struct crypto_tfm *tfm)
 	lz4_free_ctx(NULL, ctx->lz4_comp_mem);
 }
 
-static int __lz4_compress_crypto(const u8 *src, unsigned int slen,
-				 u8 *dst, unsigned int *dlen, void *ctx)
+static int __lz4_compress_crypto(const u8 *src, unsigned int slen, u8 *dst,
+				 unsigned int *dlen, void *ctx, int level)
 {
-	int out_len = LZ4_compress_default(src, dst,
-		slen, *dlen, ctx);
+	int out_len = LZ4_compress_fast(src, dst,
+		slen, *dlen, level, ctx);
 
 	if (!out_len)
 		return -EINVAL;
@@ -80,15 +80,19 @@ static int lz4_scompress(struct crypto_scomp *tfm, const u8 *src,
 			 unsigned int slen, u8 *dst, unsigned int *dlen,
 			 void *ctx)
 {
-	return __lz4_compress_crypto(src, slen, dst, dlen, ctx);
+	return __lz4_compress_crypto(src, slen, dst, dlen, ctx,
+				     LZ4_ACCELERATION_DEFAULT);
 }
 
 static int lz4_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 			       unsigned int slen, u8 *dst, unsigned int *dlen)
 {
 	struct lz4_ctx *ctx = crypto_tfm_ctx(tfm);
+	const int level = tfm->crt_compress.cot_level;
 
-	return __lz4_compress_crypto(src, slen, dst, dlen, ctx->lz4_comp_mem);
+	return __lz4_compress_crypto(src, slen, dst, dlen, ctx->lz4_comp_mem,
+				     level != 0 ? level
+						: LZ4_ACCELERATION_DEFAULT);
 }
 
 static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 9ecb4e18..96de5227 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -63,10 +63,12 @@ static void lz4hc_exit(struct crypto_tfm *tfm)
 }
 
 static int __lz4hc_compress_crypto(const u8 *src, unsigned int slen,
-				   u8 *dst, unsigned int *dlen, void *ctx)
+				   u8 *dst, unsigned int *dlen, void *ctx,
+				   int level)
 {
 	int out_len = LZ4_compress_HC(src, dst, slen,
-		*dlen, LZ4HC_DEFAULT_CLEVEL, ctx);
+		*dlen, level != 0 ? level
+						: LZ4HC_DEFAULT_CLEVEL, ctx);
 
 	if (!out_len)
 		return -EINVAL;
@@ -79,7 +81,8 @@ static int lz4hc_scompress(struct crypto_scomp *tfm, const u8 *src,
 			   unsigned int slen, u8 *dst, unsigned int *dlen,
 			   void *ctx)
 {
-	return __lz4hc_compress_crypto(src, slen, dst, dlen, ctx);
+	return __lz4hc_compress_crypto(src, slen, dst, dlen, ctx,
+				       LZ4HC_DEFAULT_CLEVEL);
 }
 
 static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
@@ -87,9 +90,9 @@ static int lz4hc_compress_crypto(struct crypto_tfm *tfm, const u8 *src,
 				 unsigned int *dlen)
 {
 	struct lz4hc_ctx *ctx = crypto_tfm_ctx(tfm);
-
+const int level = tfm->crt_compress.cot_level;
 	return __lz4hc_compress_crypto(src, slen, dst, dlen,
-					ctx->lz4hc_comp_mem);
+					ctx->lz4hc_comp_mem, level);
 }
 
 static int __lz4hc_decompress_crypto(const u8 *src, unsigned int slen,
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a41ef290..2dde03a9 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1782,7 +1782,7 @@ static int alg_test_comp(const struct alg_test_desc *desc, const char *driver,
 				 desc->suite.comp.decomp.count);
 		crypto_free_acomp(acomp);
 	} else {
-		comp = crypto_alloc_comp(driver, type, mask);
+		comp = crypto_alloc_comp(driver, type, mask, 0);
 		if (IS_ERR(comp)) {
 			pr_err("alg: comp: Failed to load transform for %s: %ld\n",
 			       driver, PTR_ERR(comp));
diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 15b3a016..5806a06b 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -50,13 +50,13 @@ static void zcomp_strm_free(struct zcomp_strm *zstrm)
  * allocate new zcomp_strm structure with ->tfm initialized by
  * backend, return NULL on error
  */
-static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp)
+static struct zcomp_strm *zcomp_strm_alloc(struct zcomp *comp, int level)
 {
 	struct zcomp_strm *zstrm = kmalloc(sizeof(*zstrm), GFP_KERNEL);
 	if (!zstrm)
 		return NULL;
 
-	zstrm->tfm = crypto_alloc_comp(comp->name, 0, 0);
+	zstrm->tfm = crypto_alloc_comp(comp->name, 0, 0, level);
 	/*
 	 * allocate 2 pages. 1 for compressed data, plus 1 extra for the
 	 * case when compressed size is larger than the original one
@@ -165,11 +165,12 @@ int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node)
 {
 	struct zcomp *comp = hlist_entry(node, struct zcomp, node);
 	struct zcomp_strm *zstrm;
+	int level = comp->level;
 
 	if (WARN_ON(*per_cpu_ptr(comp->stream, cpu)))
 		return 0;
 
-	zstrm = zcomp_strm_alloc(comp);
+	zstrm = zcomp_strm_alloc(comp, level);
 	if (IS_ERR_OR_NULL(zstrm)) {
 		pr_err("Can't allocate a compression stream\n");
 		return -ENOMEM;
@@ -223,7 +224,7 @@ void zcomp_destroy(struct zcomp *comp)
  * case of allocation error, or any other error potentially
  * returned by zcomp_init().
  */
-struct zcomp *zcomp_create(const char *compress)
+struct zcomp *zcomp_create(const char *compress, int level)
 {
 	struct zcomp *comp;
 	int error;
@@ -236,6 +237,7 @@ struct zcomp *zcomp_create(const char *compress)
 		return ERR_PTR(-ENOMEM);
 
 	comp->name = compress;
+	comp->level = level;
 	error = zcomp_init(comp);
 	if (error) {
 		kfree(comp);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 41c1002a..e1b3023e 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -21,6 +21,7 @@ struct zcomp {
 	struct zcomp_strm * __percpu *stream;
 	const char *name;
 	struct hlist_node node;
+	int level;
 };
 
 int zcomp_cpu_up_prepare(unsigned int cpu, struct hlist_node *node);
@@ -28,7 +29,7 @@ int zcomp_cpu_dead(unsigned int cpu, struct hlist_node *node);
 ssize_t zcomp_available_show(const char *comp, char *buf);
 bool zcomp_available_algorithm(const char *comp);
 
-struct zcomp *zcomp_create(const char *comp);
+struct zcomp *zcomp_create(const char *comp, int level);
 void zcomp_destroy(struct zcomp *comp);
 
 struct zcomp_strm *zcomp_stream_get(struct zcomp *comp);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index c46f21ce..8fb0c429 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -631,6 +631,23 @@ static ssize_t max_comp_streams_store(struct device *dev,
 	return len;
 }
 
+static ssize_t comp_level_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", zram->comp_level);
+}
+
+static ssize_t comp_level_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	zram->comp_level = memparse(buf, NULL);
+	return len;
+}
 static ssize_t comp_algorithm_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
@@ -1332,6 +1349,8 @@ static void zram_reset_device(struct zram *zram)
 	down_write(&zram->init_lock);
 
 	zram->limit_pages = 0;
+	zram->unsafe_decompression = 1;
+	zram->comp_level = 0;
 
 	if (!init_done(zram)) {
 		up_write(&zram->init_lock);
@@ -1351,7 +1370,6 @@ static void zram_reset_device(struct zram *zram)
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	zcomp_destroy(comp);
 	reset_bdev(zram);
-	zram->unsafe_decompression = 1;
 }
 
 static ssize_t unsafe_decompression_store(struct device *dev,
@@ -1391,7 +1409,7 @@ static ssize_t disksize_store(struct device *dev,
 		goto out_unlock;
 	}
 
-	comp = zcomp_create(zram->compressor);
+	comp = zcomp_create(zram->compressor, zram->comp_level);
 	if (IS_ERR(comp)) {
 		pr_err("Cannot initialise %s compressing backend\n",
 				zram->compressor);
@@ -1491,6 +1509,7 @@ static DEVICE_ATTR_WO(mem_limit);
 static DEVICE_ATTR_WO(mem_used_max);
 static DEVICE_ATTR_RW(max_comp_streams);
 static DEVICE_ATTR_RW(comp_algorithm);
+static DEVICE_ATTR_RW(comp_level);
 #ifdef CONFIG_ZRAM_WRITEBACK
 static DEVICE_ATTR_RW(backing_dev);
 #endif
@@ -1505,6 +1524,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_mem_used_max.attr,
 	&dev_attr_max_comp_streams.attr,
 	&dev_attr_comp_algorithm.attr,
+	&dev_attr_comp_level.attr,
 #ifdef CONFIG_ZRAM_WRITEBACK
 	&dev_attr_backing_dev.attr,
 #endif
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 3448316c..5809df24 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -100,6 +100,7 @@ struct zram {
 	 */
 	bool claim; /* Protected by bdev->bd_mutex */
 	unsigned char unsafe_decompression;
+	int comp_level;
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
 	struct block_device *bdev;
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index dc720573..e6507cef 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -276,7 +276,7 @@ static void allocate_buf_for_compression(void)
 		return;
 	}
 
-	tfm = crypto_alloc_comp(zbackend->name, 0, 0);
+	tfm = crypto_alloc_comp(zbackend->name, 0, 0, 0);
 	if (IS_ERR_OR_NULL(tfm)) {
 		kfree(big_oops_buf);
 		big_oops_buf = NULL;
diff --git a/fs/ubifs/compress.c b/fs/ubifs/compress.c
index 565cb56d..b5bf7c12 100644
--- a/fs/ubifs/compress.c
+++ b/fs/ubifs/compress.c
@@ -191,7 +191,7 @@ int ubifs_decompress(const struct ubifs_info *c, const void *in_buf,
 static int __init compr_init(struct ubifs_compressor *compr)
 {
 	if (compr->capi_name) {
-		compr->cc = crypto_alloc_comp(compr->capi_name, 0, 0);
+		compr->cc = crypto_alloc_comp(compr->capi_name, 0, 0, 0);
 		if (IS_ERR(compr->cc)) {
 			pr_err("UBIFS error (pid %d): cannot initialize compressor %s, error %ld",
 			       current->pid, compr->name, PTR_ERR(compr->cc));
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index bb1fada2..6bfb1aea 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -584,6 +584,7 @@ struct compress_tfm {
 	int (*cot_decompress_unsafe)(struct crypto_tfm *tfm,
 				     const u8 *src, unsigned int slen,
 			      u8 *dst, unsigned int *dlen);
+	int cot_level;
 };
 
 #define crt_ablkcipher	crt_u.ablkcipher
@@ -656,6 +657,8 @@ struct crypto_attr_u32 {
  */
  
 struct crypto_tfm *crypto_alloc_base(const char *alg_name, u32 type, u32 mask);
+struct crypto_tfm *crypto_alloc_base_compress(const char *alg_name, u32 type,
+					      u32 mask, int level);
 void crypto_destroy_tfm(void *mem, struct crypto_tfm *tfm);
 
 static inline void crypto_free_tfm(struct crypto_tfm *tfm)
@@ -1612,13 +1615,15 @@ static inline struct crypto_comp *crypto_comp_cast(struct crypto_tfm *tfm)
 }
 
 static inline struct crypto_comp *crypto_alloc_comp(const char *alg_name,
-						    u32 type, u32 mask)
+						    u32 type, u32 mask,
+						    int level)
 {
 	type &= ~CRYPTO_ALG_TYPE_MASK;
 	type |= CRYPTO_ALG_TYPE_COMPRESS;
 	mask |= CRYPTO_ALG_TYPE_MASK;
 
-	return __crypto_comp_cast(crypto_alloc_base(alg_name, type, mask));
+	return __crypto_comp_cast(crypto_alloc_base_compress(alg_name, type,
+							     mask, level));
 }
 
 static inline struct crypto_tfm *crypto_comp_tfm(struct crypto_comp *tfm)
diff --git a/mm/zswap.c b/mm/zswap.c
index 61a5c419..98b756ad 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -412,7 +412,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 	if (WARN_ON(*per_cpu_ptr(pool->tfm, cpu)))
 		return 0;
 
-	tfm = crypto_alloc_comp(pool->tfm_name, 0, 0);
+	tfm = crypto_alloc_comp(pool->tfm_name, 0, 0, 0);
 	if (IS_ERR_OR_NULL(tfm)) {
 		pr_err("could not alloc crypto comp %s : %ld\n",
 		       pool->tfm_name, PTR_ERR(tfm));
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index a00ec715..0602ed4b 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -305,7 +305,8 @@ static struct crypto_comp * __percpu *ipcomp_alloc_tfms(const char *alg_name)
 
 	for_each_possible_cpu(cpu) {
 		struct crypto_comp *tfm = crypto_alloc_comp(alg_name, 0,
-							    CRYPTO_ALG_ASYNC);
+							    CRYPTO_ALG_ASYNC,
+							    0);
 		if (IS_ERR(tfm))
 			goto error;
 		*per_cpu_ptr(tfms, cpu) = tfm;
-- 
2.14.1
