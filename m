From: Logan Gunthorpe <logang@deltatee.com>
Subject: [PATCH] crypto: hifn_795x: Fix a handful of minor bugs spotted by eye
Date: Fri, 28 Apr 2017 11:02:40 -0600
Message-ID: <1493398960-25643-1-git-send-email-logang@deltatee.com>
Cc: Logan Gunthorpe <logang@deltatee.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ale.deltatee.com ([207.54.116.67]:60759 "EHLO ale.deltatee.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755333AbdD1RDy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Apr 2017 13:03:54 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Cleaned up the formatting of ablkcipher_get arguments so it complies
  with kernel style
* The offset in ablkcipher_get sould be added to the source, not the
  destination. We rename it to soffset for clarity.
* dst++ should be dst=sg_next(dst)
* We call kunmap_atomic earlier so we only have to do it once.
* If ablkcipher_get fails, we should probably ensure the request
  completes with an error.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
---
 drivers/crypto/hifn_795x.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
index e09d405..4c19e4a 100644
--- a/drivers/crypto/hifn_795x.c
+++ b/drivers/crypto/hifn_795x.c
@@ -1619,8 +1619,9 @@ static int hifn_start_device(struct hifn_device *dev)
 	return 0;
 }
 
-static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset,
-		struct scatterlist *dst, unsigned int size, unsigned int *nbytesp)
+static int ablkcipher_get(void *saddr, unsigned int *srestp,
+			  unsigned int soffset, struct scatterlist *dst,
+			  unsigned int size, unsigned int *nbytesp)
 {
 	unsigned int srest = *srestp, nbytes = *nbytesp, copy;
 	void *daddr;
@@ -1633,19 +1634,19 @@ static int ablkcipher_get(void *saddr, unsigned int *srestp, unsigned int offset
 		copy = min3(srest, dst->length, size);
 
 		daddr = kmap_atomic(sg_page(dst));
-		memcpy(daddr + dst->offset + offset, saddr, copy);
+		memcpy(daddr + dst->offset, saddr + soffset, copy);
 		kunmap_atomic(daddr);
 
 		nbytes -= copy;
 		size -= copy;
 		srest -= copy;
 		saddr += copy;
-		offset = 0;
+		soffset = 0;
 
 		pr_debug("%s: copy: %u, size: %u, srest: %u, nbytes: %u.\n",
 			 __func__, copy, size, srest, nbytes);
 
-		dst++;
+		dst = sg_next(dst);
 		idx++;
 	}
 
@@ -1699,13 +1700,15 @@ static void hifn_process_ready(struct ablkcipher_request *req, int error)
 
 			err = ablkcipher_get(saddr, &t->length, t->offset,
 					dst, nbytes, &nbytes);
+			kunmap_atomic(saddr);
+
 			if (err < 0) {
-				kunmap_atomic(saddr);
+				if (!error)
+					error = err;
 				break;
 			}
 
 			idx += err;
-			kunmap_atomic(saddr);
 		}
 
 		hifn_cipher_walk_exit(&rctx->walk);
-- 
2.1.4
