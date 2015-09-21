From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [RFC][PATCH 9/9] zram: use crypto CRYPTO_ALG_TFM_MAY_SHARE API
Date: Mon, 21 Sep 2015 22:25:53 +0900
Message-ID: <1442841953-11588-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Joonsoo Kim <js1304@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35528 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490AbbIUN1G (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 09:27:06 -0400
In-Reply-To: <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Crypto subsystem now supports CRYPTO_ALG_TFM_MAY_SHARE API that
requires special tfm_noctx. This tfm can be shared by multiple
concurrent decompress user because this API doesn't rely on this
tfm object except to fetch decompress function pointer.

Until changing to use crypto API, zram doesn't require any zstrm
on decompress so decompress is parallelized unlimitedly. But, previous
patch make zram to use crypto API and this requires one zstrm on every
decompress users so, in some zstrm contended situations, zram's
performance would be degraded.

This patch makes zram use CRYPTO_ALG_TFM_MAY_SHARE API and
restore zram's performance as the time that zram doesn't use
crypto API.

Following is zram's read performance number.

* iozone -t 4 -R -r 16K -s 60M -I +Z -i 0 -i 1
* max_stream is set to 1
* Output is in Kbytes/sec

zram-base vs zram-crypto vs zram-crypto-CRYPTO_ALG_TFM_MAY_SHARE

Read		10411701.88	6426911.62	9423894.38
Re-read		10017386.62	6428218.88	11000063.50

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c | 27 +++++++++++++++++++++++++--
 drivers/block/zram/zcomp.h |  1 +
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 6219d4d..b768dc9 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -319,9 +319,14 @@ void zcomp_compress_end(struct zcomp *comp, struct zcomp_strm *zstrm)
 	zcomp_strm_release(comp, zstrm);
 }
 
-/* Never return NULL, may sleep */
+/* May return NULL, may sleep */
 struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp)
 {
+	struct crypto_comp *tfm = comp->tfm_noctx;
+
+	if (tfm && crypto_tfm_may_share(crypto_comp_tfm(tfm)))
+		return NULL;
+
 	return zcomp_strm_find(comp);
 }
 
@@ -345,12 +350,18 @@ int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		unsigned int src_len, unsigned char *dst)
 {
 	unsigned int size = PAGE_SIZE;
+	struct crypto_comp *tfm = comp->tfm_noctx;
+
+	if (tfm && crypto_tfm_may_share(crypto_comp_tfm(tfm)))
+		return crypto_comp_decompress(tfm, src, src_len, dst, &size);
 
-	return crypto_comp_decompress(zstrm->tfm, src, src_len,	dst, &size);
+	return crypto_comp_decompress(zstrm->tfm, src, src_len, dst, &size);
 }
 
 void zcomp_destroy(struct zcomp *comp)
 {
+	if (comp->tfm_noctx)
+		crypto_free_comp(comp->tfm_noctx);
 	comp->destroy(comp);
 	kfree(comp);
 }
@@ -367,6 +378,7 @@ struct zcomp *zcomp_create(const char *compress, int max_strm)
 {
 	struct zcomp *comp;
 	const char *backend;
+	struct crypto_comp *tfm;
 	int error;
 
 	backend = find_backend(compress);
@@ -386,5 +398,16 @@ struct zcomp *zcomp_create(const char *compress, int max_strm)
 		kfree(comp);
 		return ERR_PTR(error);
 	}
+
+	/*
+	 * Prepare to use crypto decompress_noctx API. One tfm is required
+	 * to initialize crypto algorithm properly and fetch corresponding
+	 * function pointer. But, it is sharable for multiple concurrent
+	 * decompress users.
+	 */
+	tfm = crypto_alloc_comp(compress, 0, 0);
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
2.5.3
