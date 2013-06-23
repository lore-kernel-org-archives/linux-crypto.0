From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 3/4] crypto: talitos: use sg_pcopy_to_buffer()
Date: Sun, 23 Jun 2013 21:37:40 +0900
Message-ID: <1371991061-19437-4-git-send-email-akinobu.mita@gmail.com>
References: <1371991061-19437-1-git-send-email-akinobu.mita@gmail.com>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Horia Geanta <horia.geanta@freescale.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1371991061-19437-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Use sg_pcopy_to_buffer() which is better than the function previously used.
Because it doesn't do kmap/kunmap for skipped pages.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Horia Geanta <horia.geanta@freescale.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---

* No change from v2

 drivers/crypto/talitos.c | 60 +-----------------------------------------------
 1 file changed, 1 insertion(+), 59 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index 5b2b5e6..661dc3e 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -1112,64 +1112,6 @@ static int sg_count(struct scatterlist *sg_list, int nbytes, bool *chained)
 	return sg_nents;
 }
 
-/**
- * sg_copy_end_to_buffer - Copy end data from SG list to a linear buffer
- * @sgl:		 The SG list
- * @nents:		 Number of SG entries
- * @buf:		 Where to copy to
- * @buflen:		 The number of bytes to copy
- * @skip:		 The number of bytes to skip before copying.
- *                       Note: skip + buflen should equal SG total size.
- *
- * Returns the number of copied bytes.
- *
- **/
-static size_t sg_copy_end_to_buffer(struct scatterlist *sgl, unsigned int nents,
-				    void *buf, size_t buflen, unsigned int skip)
-{
-	unsigned int offset = 0;
-	unsigned int boffset = 0;
-	struct sg_mapping_iter miter;
-	unsigned long flags;
-	unsigned int sg_flags = SG_MITER_ATOMIC;
-	size_t total_buffer = buflen + skip;
-
-	sg_flags |= SG_MITER_FROM_SG;
-
-	sg_miter_start(&miter, sgl, nents, sg_flags);
-
-	local_irq_save(flags);
-
-	while (sg_miter_next(&miter) && offset < total_buffer) {
-		unsigned int len;
-		unsigned int ignore;
-
-		if ((offset + miter.length) > skip) {
-			if (offset < skip) {
-				/* Copy part of this segment */
-				ignore = skip - offset;
-				len = miter.length - ignore;
-				if (boffset + len > buflen)
-					len = buflen - boffset;
-				memcpy(buf + boffset, miter.addr + ignore, len);
-			} else {
-				/* Copy all of this segment (up to buflen) */
-				len = miter.length;
-				if (boffset + len > buflen)
-					len = buflen - boffset;
-				memcpy(buf + boffset, miter.addr, len);
-			}
-			boffset += len;
-		}
-		offset += miter.length;
-	}
-
-	sg_miter_stop(&miter);
-
-	local_irq_restore(flags);
-	return boffset;
-}
-
 /*
  * allocate and map the extended descriptor
  */
@@ -1800,7 +1742,7 @@ static int ahash_process_req(struct ahash_request *areq, unsigned int nbytes)
 
 	if (to_hash_later) {
 		int nents = sg_count(areq->src, nbytes, &chained);
-		sg_copy_end_to_buffer(areq->src, nents,
+		sg_pcopy_to_buffer(areq->src, nents,
 				      req_ctx->bufnext,
 				      to_hash_later,
 				      nbytes - to_hash_later);
-- 
1.8.1.4
