From: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
Subject: [PATCH v7 3/5] crypto: add unsafe decompression to api
Date: Fri, 13 Apr 2018 17:48:38 +0200
Message-ID: <20180413154840.5901-4-4bwarnke@informatik.uni-hamburg.de>
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

Up to Version 3 of this patch the decompressor of zbewalgo did not verify
that there is no overflow in the output buffer. Now zbewalgo includes a
safe decompressor which does check for buffer overflows and heap-error.
ZBewalgo and other Algorithms like lz4 include an unsafe decompressor version,
which is a bit faster, but does no error checking. These unsafe decompressors
can be applied when the datasource and the whole datapath is trusted.

This patch publishes these existing functions in the crypto-api

Signed-off-by: Benjamin Warnke <4bwarnke@informatik.uni-hamburg.de>
---
 crypto/842.c                         |  3 ++-
 crypto/compress.c                    | 10 ++++++++++
 crypto/crypto_null.c                 |  3 ++-
 crypto/deflate.c                     |  3 ++-
 crypto/lz4.c                         | 23 ++++++++++++++++++++++-
 crypto/lz4hc.c                       | 23 ++++++++++++++++++++++-
 crypto/lzo.c                         |  3 ++-
 crypto/testmgr.c                     | 27 ++++++++++++++++++++++++++-
 crypto/zbewalgo.c                    | 29 ++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.c        | 34 +++++++++++++++++++++++++++++++++-
 drivers/block/zram/zram_drv.h        |  1 +
 drivers/crypto/cavium/zip/zip_main.c |  6 ++++--
 drivers/crypto/nx/nx-842-powernv.c   |  3 ++-
 drivers/crypto/nx/nx-842-pseries.c   |  3 ++-
 include/linux/crypto.h               | 16 ++++++++++++++++
 15 files changed, 174 insertions(+), 13 deletions(-)

diff --git a/crypto/842.c b/crypto/842.c
index bc26dc94..7e74ea26 100644
--- a/crypto/842.c
+++ b/crypto/842.c
@@ -112,7 +112,8 @@ static struct crypto_alg alg = {
 	.cra_exit		= crypto842_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= crypto842_compress,
-	.coa_decompress		= crypto842_decompress } }
+	.coa_decompress		= crypto842_decompress,
+	.coa_decompress_unsafe		= crypto842_decompress } }
 };
 
 static struct scomp_alg scomp = {
diff --git a/crypto/compress.c b/crypto/compress.c
index f2d52292..bec79624 100644
--- a/crypto/compress.c
+++ b/crypto/compress.c
@@ -33,12 +33,22 @@ static int crypto_decompress(struct crypto_tfm *tfm,
 	                                                   dlen);
 }
 
+static int crypto_decompress_unsafe(struct crypto_tfm *tfm,
+				    const u8 *src, unsigned int slen,
+			     u8 *dst, unsigned int *dlen)
+{
+	return tfm->__crt_alg->cra_compress.coa_decompress_unsafe(tfm, src,
+								  slen, dst,
+								  dlen);
+}
+
 int crypto_init_compress_ops(struct crypto_tfm *tfm)
 {
 	struct compress_tfm *ops = &tfm->crt_compress;
 
 	ops->cot_compress = crypto_compress;
 	ops->cot_decompress = crypto_decompress;
+	ops->cot_decompress_unsafe = crypto_decompress_unsafe;
 
 	return 0;
 }
diff --git a/crypto/crypto_null.c b/crypto/crypto_null.c
index 20ff2c74..6e15e8c0 100644
--- a/crypto/crypto_null.c
+++ b/crypto/crypto_null.c
@@ -146,7 +146,8 @@ static struct crypto_alg null_algs[3] = { {
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{ .compress = {
 	.coa_compress		=	null_compress,
-	.coa_decompress		=	null_compress } }
+	.coa_decompress		=	null_compress,
+	.coa_decompress_unsafe		=	null_compress } }
 } };
 
 MODULE_ALIAS_CRYPTO("compress_null");
diff --git a/crypto/deflate.c b/crypto/deflate.c
index 94ec3b36..4b681a37 100644
--- a/crypto/deflate.c
+++ b/crypto/deflate.c
@@ -286,7 +286,8 @@ static struct crypto_alg alg = {
 	.cra_exit		= deflate_exit,
 	.cra_u			= { .compress = {
 	.coa_compress 		= deflate_compress,
-	.coa_decompress  	= deflate_decompress } }
+	.coa_decompress	= deflate_decompress,
+	.coa_decompress_unsafe	= deflate_decompress } }
 };
 
 static struct scomp_alg scomp[] = { {
diff --git a/crypto/lz4.c b/crypto/lz4.c
index 2ce2660d..60a1914b 100644
--- a/crypto/lz4.c
+++ b/crypto/lz4.c
@@ -103,6 +103,19 @@ static int __lz4_decompress_crypto(const u8 *src, unsigned int slen,
 	return 0;
 }
 
+static int __lz4_decompress_crypto_unsafe(const u8 *src, unsigned int slen,
+					  u8 *dst, unsigned int *dlen,
+					   void *ctx)
+{
+	int out_len = LZ4_decompress_fast(src, dst, *dlen);
+
+	if (out_len < 0)
+		return -EINVAL;
+
+	*dlen = out_len;
+	return 0;
+}
+
 static int lz4_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 			   unsigned int slen, u8 *dst, unsigned int *dlen,
 			   void *ctx)
@@ -117,6 +130,13 @@ static int lz4_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return __lz4_decompress_crypto(src, slen, dst, dlen, NULL);
 }
 
+static int lz4_decompress_crypto_unsafe(struct crypto_tfm *tfm, const u8 *src,
+					unsigned int slen, u8 *dst,
+					  unsigned int *dlen)
+{
+	return __lz4_decompress_crypto_unsafe(src, slen, dst, dlen, NULL);
+}
+
 static struct crypto_alg alg_lz4 = {
 	.cra_name		= "lz4",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -127,7 +147,8 @@ static struct crypto_alg alg_lz4 = {
 	.cra_exit		= lz4_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= lz4_compress_crypto,
-	.coa_decompress		= lz4_decompress_crypto } }
+	.coa_decompress		= lz4_decompress_crypto,
+	.coa_decompress_unsafe		= lz4_decompress_crypto_unsafe } }
 };
 
 static struct scomp_alg scomp = {
diff --git a/crypto/lz4hc.c b/crypto/lz4hc.c
index 2be14f05..9ecb4e18 100644
--- a/crypto/lz4hc.c
+++ b/crypto/lz4hc.c
@@ -104,6 +104,19 @@ static int __lz4hc_decompress_crypto(const u8 *src, unsigned int slen,
 	return 0;
 }
 
+static int __lz4hc_decompress_crypto_unsafe(const u8 *src, unsigned int slen,
+					    u8 *dst, unsigned int *dlen,
+					    void *ctx)
+{
+	int out_len = LZ4_decompress_fast(src, dst, *dlen);
+
+	if (out_len < 0)
+		return -EINVAL;
+
+	*dlen = out_len;
+	return 0;
+}
+
 static int lz4hc_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 			     unsigned int slen, u8 *dst, unsigned int *dlen,
 			     void *ctx)
@@ -118,6 +131,13 @@ static int lz4hc_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 	return __lz4hc_decompress_crypto(src, slen, dst, dlen, NULL);
 }
 
+static int lz4hc_decompress_crypto_unsafe(struct crypto_tfm *tfm, const u8 *src,
+				   unsigned int slen, u8 *dst,
+				   unsigned int *dlen)
+{
+	return __lz4hc_decompress_crypto_unsafe(src, slen, dst, dlen, NULL);
+}
+
 static struct crypto_alg alg_lz4hc = {
 	.cra_name		= "lz4hc",
 	.cra_flags		= CRYPTO_ALG_TYPE_COMPRESS,
@@ -128,7 +148,8 @@ static struct crypto_alg alg_lz4hc = {
 	.cra_exit		= lz4hc_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= lz4hc_compress_crypto,
-	.coa_decompress		= lz4hc_decompress_crypto } }
+	.coa_decompress		= lz4hc_decompress_crypto,
+	.coa_decompress_unsafe		= lz4hc_decompress_crypto_unsafe } }
 };
 
 static struct scomp_alg scomp = {
diff --git a/crypto/lzo.c b/crypto/lzo.c
index 218567d7..81fb2d63 100644
--- a/crypto/lzo.c
+++ b/crypto/lzo.c
@@ -129,7 +129,8 @@ static struct crypto_alg alg = {
 	.cra_exit		= lzo_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= lzo_compress,
-	.coa_decompress		= lzo_decompress } }
+	.coa_decompress		= lzo_decompress,
+	.coa_decompress_unsafe		= lzo_decompress } }
 };
 
 static struct scomp_alg scomp = {
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 53fd43d1..a41ef290 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1383,9 +1383,9 @@ static int test_comp(struct crypto_comp *tfm,
 		int ilen;
 		unsigned int dlen = COMP_BUF_SIZE;
 
-		memset(result, 0, sizeof (result));
 
 		ilen = dtemplate[i].inlen;
+		memset(result, 0, sizeof(result));
 		ret = crypto_comp_decompress(tfm, dtemplate[i].input,
 		                             ilen, result, &dlen);
 		if (ret) {
@@ -1410,6 +1410,31 @@ static int test_comp(struct crypto_comp *tfm,
 			ret = -EINVAL;
 			goto out;
 		}
+		memset(result, 0, sizeof(result));
+		ret = crypto_comp_decompress_unsafe(tfm, dtemplate[i].input,
+						    ilen, result, &dlen);
+		if (ret) {
+			printk(KERN_ERR "alg: comp: unsafe decompression failed on test %d for %s: ret=%d\n",
+			       i + 1, algo,
+			       -ret);
+			goto out;
+		}
+
+		if (dlen != dtemplate[i].outlen) {
+			printk(KERN_ERR "alg: comp: unsafe Decompression test %d failed for %s: output len = %d\n",
+			       i + 1, algo,
+			       dlen);
+			ret = -EINVAL;
+			goto out;
+		}
+
+		if (memcmp(result, dtemplate[i].output, dlen)) {
+			printk(KERN_ERR "alg: comp: unsafe Decompression test %d failed for %s\n",
+			       i + 1, algo);
+			hexdump(result, dlen);
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	ret = 0;
diff --git a/crypto/zbewalgo.c b/crypto/zbewalgo.c
index 044b8811..9db0d43b 100644
--- a/crypto/zbewalgo.c
+++ b/crypto/zbewalgo.c
@@ -90,6 +90,20 @@ static int __zbewalgo_decompress_crypto(const u8 *src, unsigned int slen,
 	return 0;
 }
 
+static int __zbewalgo_decompress_crypto_unsafe(const u8 *src,
+					       unsigned int slen,
+						u8 *dst, unsigned int *dlen,
+						void *ctx)
+{
+	int out_len;
+
+	out_len = zbewalgo_decompress_fast(src, dst, ctx, slen);
+	if (out_len < 0)
+		return -EINVAL;
+	*dlen = out_len;
+	return 0;
+}
+
 static int zbewalgo_sdecompress(struct crypto_scomp *tfm, const u8 *src,
 				unsigned int slen, u8 *dst, unsigned int *dlen,
 				void *ctx)
@@ -107,6 +121,17 @@ static int zbewalgo_decompress_crypto(struct crypto_tfm *tfm, const u8 *src,
 		ctx->zbewalgo_comp_mem);
 }
 
+static int zbewalgo_decompress_crypto_unsafe(struct crypto_tfm *tfm,
+					     const u8 *src,
+					      unsigned int slen, u8 *dst,
+					      unsigned int *dlen)
+{
+	struct zbewalgo_ctx *ctx = crypto_tfm_ctx(tfm);
+
+	return __zbewalgo_decompress_crypto_unsafe(src, slen, dst, dlen,
+		ctx->zbewalgo_comp_mem);
+}
+
 static struct crypto_alg crypto_alg_zbewalgo = {
 	.cra_name = "zbewalgo",
 	.cra_flags = CRYPTO_ALG_TYPE_COMPRESS,
@@ -117,7 +142,9 @@ static struct crypto_alg crypto_alg_zbewalgo = {
 	.cra_u = {
 		.compress = {
 			.coa_compress = zbewalgo_compress_crypto,
-			.coa_decompress = zbewalgo_decompress_crypto
+			.coa_decompress = zbewalgo_decompress_crypto,
+			.coa_decompress_unsafe =
+				zbewalgo_decompress_crypto_unsafe
 		}
 	}
 };
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 0f3fadd7..c46f21ce 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -219,6 +219,15 @@ static ssize_t disksize_show(struct device *dev,
 	return scnprintf(buf, PAGE_SIZE, "%llu\n", zram->disksize);
 }
 
+static ssize_t unsafe_decompression_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%u\n", zram->unsafe_decompression);
+}
+
 static ssize_t mem_limit_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
@@ -886,9 +895,17 @@ static int __zram_bvec_read(struct zram *zram, struct page *page, u32 index,
 		ret = 0;
 	} else {
 		struct zcomp_strm *zstrm = zcomp_stream_get(zram->comp);
+		unsigned int dst_len = PAGE_SIZE;
 
 		dst = kmap_atomic(page);
-		ret = zcomp_decompress(zstrm, src, size, dst);
+		if (zram->unsafe_decompression)
+			ret = crypto_comp_decompress_unsafe(zstrm->tfm,
+							    src, size,
+				dst, &dst_len);
+		else
+			ret = crypto_comp_decompress(zstrm->tfm,
+						     src, size,
+				dst, &dst_len);
 		kunmap_atomic(dst);
 		zcomp_stream_put(zram->comp);
 	}
@@ -1334,6 +1351,19 @@ static void zram_reset_device(struct zram *zram)
 	memset(&zram->stats, 0, sizeof(zram->stats));
 	zcomp_destroy(comp);
 	reset_bdev(zram);
+	zram->unsafe_decompression = 1;
+}
+
+static ssize_t unsafe_decompression_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	unsigned char flag;
+	struct zram *zram = dev_to_zram(dev);
+
+	flag = memparse(buf, NULL);
+	zram->unsafe_decompression = flag ? 1 : 0;
+	return len;
 }
 
 static ssize_t disksize_store(struct device *dev,
@@ -1454,6 +1484,7 @@ static const struct block_device_operations zram_devops = {
 
 static DEVICE_ATTR_WO(compact);
 static DEVICE_ATTR_RW(disksize);
+static DEVICE_ATTR_RW(unsafe_decompression);
 static DEVICE_ATTR_RO(initstate);
 static DEVICE_ATTR_WO(reset);
 static DEVICE_ATTR_WO(mem_limit);
@@ -1466,6 +1497,7 @@ static DEVICE_ATTR_RW(backing_dev);
 
 static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
+	&dev_attr_unsafe_decompression.attr,
 	&dev_attr_initstate.attr,
 	&dev_attr_reset.attr,
 	&dev_attr_compact.attr,
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 00886122..3448316c 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -99,6 +99,7 @@ struct zram {
 	 * zram is claimed so open request will be failed
 	 */
 	bool claim; /* Protected by bdev->bd_mutex */
+	unsigned char unsafe_decompression;
 #ifdef CONFIG_ZRAM_WRITEBACK
 	struct file *backing_dev;
 	struct block_device *bdev;
diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
index 1cd8aa48..bd5d9f64 100644
--- a/drivers/crypto/cavium/zip/zip_main.c
+++ b/drivers/crypto/cavium/zip/zip_main.c
@@ -359,7 +359,8 @@ static struct crypto_alg zip_comp_deflate = {
 	.cra_exit		= zip_free_comp_ctx,
 	.cra_u			= { .compress = {
 		.coa_compress	= zip_comp_compress,
-		.coa_decompress	= zip_comp_decompress
+		.coa_decompress	= zip_comp_decompress,
+		.coa_decompress_unsafe	= zip_comp_decompress
 		 } }
 };
 
@@ -373,7 +374,8 @@ static struct crypto_alg zip_comp_lzs = {
 	.cra_exit		= zip_free_comp_ctx,
 	.cra_u			= { .compress = {
 		.coa_compress	= zip_comp_compress,
-		.coa_decompress	= zip_comp_decompress
+		.coa_decompress	= zip_comp_decompress,
+		.coa_decompress_unsafe	= zip_comp_decompress
 		 } }
 };
 
diff --git a/drivers/crypto/nx/nx-842-powernv.c b/drivers/crypto/nx/nx-842-powernv.c
index 1e87637c..f00326b4 100644
--- a/drivers/crypto/nx/nx-842-powernv.c
+++ b/drivers/crypto/nx/nx-842-powernv.c
@@ -981,7 +981,8 @@ static struct crypto_alg nx842_powernv_alg = {
 	.cra_exit		= nx842_crypto_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= nx842_crypto_compress,
-	.coa_decompress		= nx842_crypto_decompress } }
+	.coa_decompress		= nx842_crypto_decompress,
+	.coa_decompress_unsafe		= nx842_crypto_decompress } }
 };
 
 static __init int nx842_powernv_init(void)
diff --git a/drivers/crypto/nx/nx-842-pseries.c b/drivers/crypto/nx/nx-842-pseries.c
index 66869976..5badd418 100644
--- a/drivers/crypto/nx/nx-842-pseries.c
+++ b/drivers/crypto/nx/nx-842-pseries.c
@@ -982,7 +982,8 @@ static struct crypto_alg nx842_pseries_alg = {
 	.cra_exit		= nx842_crypto_exit,
 	.cra_u			= { .compress = {
 	.coa_compress		= nx842_crypto_compress,
-	.coa_decompress		= nx842_crypto_decompress } }
+	.coa_decompress		= nx842_crypto_decompress,
+	.coa_decompress_unsafe		= nx842_crypto_decompress } }
 };
 
 static int nx842_probe(struct vio_dev *viodev,
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 6eb06101..bb1fada2 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -362,6 +362,9 @@ struct compress_alg {
 			    unsigned int slen, u8 *dst, unsigned int *dlen);
 	int (*coa_decompress)(struct crypto_tfm *tfm, const u8 *src,
 			      unsigned int slen, u8 *dst, unsigned int *dlen);
+	int (*coa_decompress_unsafe)(struct crypto_tfm *tfm, const u8 *src,
+				     unsigned int slen, u8 *dst,
+				     unsigned int *dlen);
 };
 
 
@@ -578,6 +581,9 @@ struct compress_tfm {
 	int (*cot_decompress)(struct crypto_tfm *tfm,
 	                      const u8 *src, unsigned int slen,
 	                      u8 *dst, unsigned int *dlen);
+	int (*cot_decompress_unsafe)(struct crypto_tfm *tfm,
+				     const u8 *src, unsigned int slen,
+			      u8 *dst, unsigned int *dlen);
 };
 
 #define crt_ablkcipher	crt_u.ablkcipher
@@ -1660,5 +1666,15 @@ static inline int crypto_comp_decompress(struct crypto_comp *tfm,
 						    src, slen, dst, dlen);
 }
 
+static inline int crypto_comp_decompress_unsafe(struct crypto_comp *tfm,
+						const u8 *src,
+						unsigned int slen,
+						u8 *dst, unsigned int *dlen)
+{
+	return crypto_comp_crt(tfm)->cot_decompress_unsafe(crypto_comp_tfm(tfm),
+							   src, slen, dst,
+							   dlen);
+}
+
 #endif	/* _LINUX_CRYPTO_H */
 
-- 
2.14.1
