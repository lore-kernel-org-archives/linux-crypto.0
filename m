From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 6/8] zram: change zcomp_compress interface
Date: Thu, 20 Aug 2015 15:35:02 +0900
Message-ID: <1440052504-15442-7-git-send-email-iamjoonsoo.kim@lge.com>
References: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Stephan Mueller <smueller@chronox.de>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1440052504-15442-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

zram regards zstrm's buffer as compression destination buffer, but,
it is not intuitive and there is no document about it. Providing
destination buffer to zcomp_compress() directly seems more intuitive
interface to me so this patch changes zcomp_compress interface.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 drivers/block/zram/zcomp.c    | 5 ++---
 drivers/block/zram/zcomp.h    | 2 +-
 drivers/block/zram/zram_drv.c | 2 +-
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 965d1af..2ad504b 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -307,10 +307,9 @@ void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm)
 }
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
-		const unsigned char *src, size_t *dst_len)
+		const unsigned char *src, unsigned char *dst, size_t *dst_len)
 {
-	return comp->backend->compress(src, zstrm->buffer, dst_len,
-			zstrm->private);
+	return comp->backend->compress(src, dst, dst_len, zstrm->private);
 }
 
 int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 46e2b9f..b2388e0 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -60,7 +60,7 @@ struct zcomp_strm *zcomp_strm_find(struct zcomp *comp);
 void zcomp_strm_release(struct zcomp *comp, struct zcomp_strm *zstrm);
 
 int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
-		const unsigned char *src, size_t *dst_len);
+		const unsigned char *src, unsigned char *dst, size_t *dst_len);
 
 int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
 		size_t src_len, unsigned char *dst);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index b088ca9..4801e4d 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -701,7 +701,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
-	ret = zcomp_compress(zram->comp, zstrm, uncmem, &clen);
+	ret = zcomp_compress(zram->comp, zstrm, uncmem, zstrm->buffer, &clen);
 	if (!is_partial_io(bvec)) {
 		kunmap_atomic(user_mem);
 		user_mem = NULL;
-- 
1.9.1
