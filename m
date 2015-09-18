From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v3 9/9] zram: use crypto decompress_noctx API
Date: Fri, 18 Sep 2015 14:19:24 +0900
Message-ID: <1442553564-3476-10-git-send-email-iamjoonsoo.kim@lge.com>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Crypto subsystem now supports decompress_noctx API that requires
special tfm_noctx. This tfm can be shared by multiple concurrent
decompress user because this API doesn't rely on this tfm object
except to fetch decompress function pointer.

Until changing to use crypto API, zram doesn't require any zstrm
on decompress so decompress is parallelized unlimitedly. But, previous
patch make zram to use crypto API and this requires one zstrm on every
decompress users so, in some zstrm contended situations, zram's
performance would be degraded.

This patch makes zram use decompress_noctx API and restore zram's
performance as the time that zram doesn't use crypto API.

Following is zram's read performance number.

* iozone -t 4 -R -r 16K -s 60M -I +Z -i 0 -i 1
* max_stream is set to 1
* Output is in Kbytes/sec

zram-base vs zram-crypto vs zram-crypto-noctx

Read		10411701.88	6426911.62	9423894.38
Re-read		10017386.62	6428218.88	11000063.50

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 drivers/block/zram/zcomp.c | 24 +++++++++++++++++++++++-
 drivers/block/zram/zcomp.h |  1 +
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index c2ed7c8..a020200 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -319,9 +319,12 @@ void zcomp_compress_end(struct zcomp *comp, struct zcomp_strm *zstrm)
 	zcomp_strm_release(comp, zstrm);
 }
 
-/* Never return NULL, may sleep */
+/* May return NULL, may sleep */
 struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp)
 {
+	if (comp->tfm_noctx)
+		return NULL;
+
 	return zcomp_strm_find(comp);
 }
 
@@ -346,11 +349,18 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
 {
 	unsigned int size = PAGE_SIZE;
 
+	if (!zstrm) {
+		return crypto_comp_decompress_noctx(comp->tfm_noctx,
+						src, src_len, dst, &size);
+	}
+
 	return crypto_comp_decompress(zstrm->tfm, src, src_len,	dst, &size);
 }
 
 void zcomp_destroy(struct zcomp *comp)
 {
+	if (comp->tfm_noctx)
+		crypto_free_comp_noctx(comp->tfm_noctx);
 	comp->destroy(comp);
 	kfree(comp);
 }
@@ -366,6 +376,7 @@ struct zcomp *zcomp_create(const char *compress, int max_strm)
 {
 	struct zcomp *comp;
 	const char *backend;
+	struct crypto_comp *tfm;
 
 	backend = find_backend(compress);
 	if (!backend)
@@ -384,5 +395,16 @@ struct zcomp *zcomp_create(const char *compress, int max_strm)
 		kfree(comp);
 		return ERR_PTR(-ENOMEM);
 	}
+
+	/*
+	 * Prepare to use crypto decompress_noctx API. One tfm is required
+	 * to initialize crypto algorithm properly and fetch corresponding
+	 * function pointer. But, it is sharable for multiple concurrent
+	 * decompress users.
+	 */
+	tfm = crypto_alloc_comp_noctx(compress, 0, 0);
+	if (!IS_ERR(tfm))
+		comp->tfm_noctx = tfm;
+
 	return comp;
 }
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 4f9df8e..c76d8e4 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -26,6 +26,7 @@ struct zcomp_strm {
 /* dynamic per-device compression frontend */
 struct zcomp {
 	void *stream;
+	struct crypto_comp *tfm_noctx;
 	const char *backend;
 
 	struct zcomp_strm *(*strm_find)(struct zcomp *comp);
-- 
1.9.1
