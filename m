From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [RFC][PATCH 7/9] zram: pass zstrm down to decompression path
Date: Mon, 21 Sep 2015 22:13:47 +0900
Message-ID: <1442841229-8122-8-git-send-email-sergey.senozhatsky@gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1442841229-8122-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Introduce zcomp_decompress_begin()/zcomp_decompress_end() as a
preparation for crypto API-powered zcomp.

Change zcomp_decompress() signature to require zstrm parameter.

Unlike zcomp_compress_begin(), zcomp_decompress_begin() may return
zstrm if currently selected compression backend require zstrm for
decompression or NULL if it does not.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zcomp.c    |  3 ++-
 drivers/block/zram/zcomp.h    |  3 ++-
 drivers/block/zram/zram_drv.c | 20 ++++++++++++++++----
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
index 52d5b04..e3016da 100644
--- a/drivers/block/zram/zcomp.c
+++ b/drivers/block/zram/zcomp.c
@@ -336,7 +336,8 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 			zstrm->private);
 }
 
-int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
+int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		const unsigned char *src,
 		size_t src_len, unsigned char *dst)
 {
 	return comp->backend->decompress(src, src_len, dst);
diff --git a/drivers/block/zram/zcomp.h b/drivers/block/zram/zcomp.h
index 616e013..4c09c01 100644
--- a/drivers/block/zram/zcomp.h
+++ b/drivers/block/zram/zcomp.h
@@ -66,7 +66,8 @@ int zcomp_compress(struct zcomp *comp, struct zcomp_strm *zstrm,
 struct zcomp_strm *zcomp_decompress_begin(struct zcomp *comp);
 void zcomp_decompress_end(struct zcomp *comp, struct zcomp_strm *zstrm);
 
-int zcomp_decompress(struct zcomp *comp, const unsigned char *src,
+int zcomp_decompress(struct zcomp *comp, struct zcomp_strm *zstrm,
+		const unsigned char *src,
 		size_t src_len, unsigned char *dst);
 
 bool zcomp_set_max_streams(struct zcomp *comp, int num_strm);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7dda8a5..74cbb81 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -560,7 +560,8 @@ static void zram_free_page(struct zram *zram, size_t index)
 	zram_set_obj_size(meta, index, 0);
 }
 
-static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
+static int zram_decompress_page(struct zram *zram, struct zcomp_strm *zstrm,
+		char *mem, u32 index)
 {
 	int ret = 0;
 	unsigned char *cmem;
@@ -582,7 +583,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	if (size == PAGE_SIZE)
 		copy_page(mem, cmem);
 	else
-		ret = zcomp_decompress(zram->comp, cmem, size, mem);
+		ret = zcomp_decompress(zram->comp, zstrm, cmem, size, mem);
 	zs_unmap_object(meta->mem_pool, handle);
 	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
@@ -602,6 +603,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	struct page *page;
 	unsigned char *user_mem, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
+	struct zcomp_strm *zstrm;
 	page = bvec->bv_page;
 
 	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
@@ -617,6 +619,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 		/* Use  a temporary buffer to decompress the page */
 		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
 
+	zstrm = zcomp_decompress_begin(zram->comp);
 	user_mem = kmap_atomic(page);
 	if (!is_partial_io(bvec))
 		uncmem = user_mem;
@@ -627,7 +630,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 		goto out_cleanup;
 	}
 
-	ret = zram_decompress_page(zram, uncmem, index);
+	ret = zram_decompress_page(zram, zstrm, uncmem, index);
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret))
 		goto out_cleanup;
@@ -636,10 +639,14 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
 				bvec->bv_len);
 
+	zcomp_decompress_end(zram->comp, zstrm);
+	zstrm = NULL;
+
 	flush_dcache_page(page);
 	ret = 0;
 out_cleanup:
 	kunmap_atomic(user_mem);
+	zcomp_decompress_end(zram->comp, zstrm);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
 	return ret;
@@ -659,6 +666,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	page = bvec->bv_page;
 	if (is_partial_io(bvec)) {
+		struct zcomp_strm *zstrm;
 		/*
 		 * This is a partial IO. We need to read the full page
 		 * before to write the changes.
@@ -668,7 +676,11 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			ret = -ENOMEM;
 			goto out;
 		}
-		ret = zram_decompress_page(zram, uncmem, index);
+
+		zstrm = zcomp_decompress_begin(zram->comp);
+		ret = zram_decompress_page(zram, zstrm, uncmem, index);
+		zcomp_decompress_end(zram->comp, zstrm);
+
 		if (ret)
 			goto out;
 	}
-- 
2.6.0.rc2.10.gf4d9753
