From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [RFC][PATCH 6/9] zram: make stream find and release functions static
Date: Mon, 21 Sep 2015 22:13:46 +0900
Message-ID: <1442841229-8122-7-git-send-email-sergey.senozhatsky@gmail.com>
References: <1442553564-3476-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
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
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35121 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932266AbbIUNPf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Sep 2015 09:15:35 -0400
In-Reply-To: <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hide (make static) zstrm find and release function and introduce
zcomp_compress_begin()/zcomp_compress_end(). We will have begin
and end functions around compression (this patch) and decompression
(next patch). So the work flow is evolving to:

	zstrm = foo_begin();
	foo(zstrm);
	foo_end(zstrm);

where foo is compress or decompress zcomp functions.

This patch is a preparation to make crypto API-powered zcomp
possible. The reasoning is that some crypto compression backends
require zstrm for decompression.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c    | 27 +++++++++++++++++++++++++--
 drivers/block/zram/zcomp.h    |  8 ++++++--
 drivers/block/zram/zram_drv.c |  6 +++---
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 5cb13ca..52d5b04 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -296,16 +296,39 @@ bool zcomp_set_max_streams(struct zcomp *comp, int num_strm)
 	return comp->set_max_streams(comp, num_strm);
 }
 
-struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
+static struct zcomp_strm *zcomp_strm_find(struct zcomp *comp)
 {
 	return comp->strm_find(comp);
 }
 
-void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
+static void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
 {
 	comp->strm_release(comp, zstrm);
 }
 
+/* Never return NULL, may sleep */
+struct zcomp_strm *zcomp_compress_begin(struct zcomp *comp)
+{
+	return zcomp_strm_find(comp);
+}
+
+void zcomp_compress_end(struct zcomp *comp, struct zcomp_strm *zstrm)
+{
+	zcomp_strm_release(comp, zstrm);
+}
+
+/* May return NULL, may sleep */
+struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp)
+{
+	return NULL;
+}
+
+void zcomp_decompress_end(struct zcomp *comp, struct zcomp_strm *zstrm)
+{
+	if (zstrm)
+		zcomp_strm_release(comp, zstrm);
+}
+
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		const unsigned char *src, size_t *dst_len)
 {
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 46e2b9f..616e013 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -56,12 +56,16 @@ bool zcomp_available_algorithm(const char *comp);
 struct zcomp *zcomp_create(const char *comp, int max_strm);
 void zcomp_destroy(struct zcomp *comp);
 
-struct zcomp_strm *zcomp_strm_find(struct zcomp *comp);
-void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm);
+
+struct zcomp_strm *zcomp_compress_begin(struct zcomp *comp);
+void zcomp_compress_end(struct zcomp *comp, struct zcomp_strm *zstrm);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 		const unsigned char *src, size_t *dst_len);
 
+struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp);
+void zcomp_decompress_end(struct zcomp *comp, struct zcomp_strm *zstrm);
+
 int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
 		size_t src_len, unsigned char *dst);
 
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index c93aeb8..7dda8a5 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -673,7 +673,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			goto out;
 	}
 
-	zstrm = zcomp_strm_find(zram->comp);
+	zstrm = zcomp_compress_begin(zram->comp);
 	user_mem = kmap_atomic(page);
 
 	if (is_partial_io(bvec)) {
@@ -744,7 +744,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		memcpy(cmem, src, clen);
 	}
 
-	zcomp_strm_release(zram->comp, zstrm);
+	zcomp_compress_end(zram->comp, zstrm);
 	zstrm = NULL;
 	zs_unmap_object(meta->mem_pool, handle);
 
@@ -764,7 +764,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	atomic64_inc(&zram->stats.pages_stored);
 out:
 	if (zstrm)
-		zcomp_strm_release(zram->comp, zstrm);
+		zcomp_compress_end(zram->comp, zstrm);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
 	return ret;
-- 
2.6.0.rc2.10.gf4d9753
