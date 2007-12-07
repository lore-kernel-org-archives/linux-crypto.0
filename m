From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5/5] [CRYPTO] scatterwalk: Restore custom sg chaining for now
Date: Fri, 07 Dec 2007 16:19:47 +0800
Message-ID: <E1J0YR1-000229-00@gondolin.me.apana.org.au>
References: <20071207081904.GA7733@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1995 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752351AbXLGITv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Dec 2007 03:19:51 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J0YR2-0005Eh-Pw
	for <linux-crypto@vger.kernel.org>; Fri, 07 Dec 2007 19:19:49 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] scatterwalk: Restore custom sg chaining for now

Unfortunately the generic chaining hasn't been ported to all architectures
yet, and notably not s390.  So this patch restores the chainging that we've
been using previously which does work everywhere.

eigned-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/digest.c              |    2 +-
 crypto/gcm.c                 |    2 +-
 crypto/hmac.c                |    3 ++-
 crypto/scatterwalk.c         |    4 ++--
 include/crypto/scatterwalk.h |   11 +++++++++++
 5 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/crypto/digest.c b/crypto/digest.c
index 52845f5..6fd43bd 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -75,7 +75,7 @@ static int update2(struct hash_desc *desc,
 
 		if (!nbytes)
 			break;
-		sg = sg_next(sg);
+		sg = scatterwalk_sg_next(sg);
 	}
 
 	return 0;
diff --git a/crypto/gcm.c b/crypto/gcm.c
index 67cd067..f293502 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -98,7 +98,7 @@ static void crypto_gcm_ghash_update_sg(struct crypto_gcm_ghash_ctx *ctx,
 		n = scatterwalk_clamp(&walk, len);
 
 		if (!n) {
-			scatterwalk_start(&walk, sg_next(walk.sg));
+			scatterwalk_start(&walk, scatterwalk_sg_next(walk.sg));
 			n = scatterwalk_clamp(&walk, len);
 		}
 
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 34c3706..a1d016a 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -17,6 +17,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/scatterwalk.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
@@ -160,7 +161,7 @@ static int hmac_digest(struct hash_desc *pdesc, struct scatterlist *sg,
 
 	sg_init_table(sg1, 2);
 	sg_set_buf(sg1, ipad, bs);
-	sg_chain(sg1, 2, sg);
+	scatterwalk_sg_chain(sg1, 2, sg);
 
 	sg_init_table(sg2, 1);
 	sg_set_buf(sg2, opad, bs + ds);
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 12d1901..297e19d 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -61,7 +61,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 		walk->offset += PAGE_SIZE - 1;
 		walk->offset &= PAGE_MASK;
 		if (walk->offset >= walk->sg->offset + walk->sg->length)
-			scatterwalk_start(walk, sg_next(walk->sg));
+			scatterwalk_start(walk, scatterwalk_sg_next(walk->sg));
 	}
 }
 
@@ -112,7 +112,7 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			break;
 
 		offset += sg->length;
-		sg = sg_next(sg);
+		sg = scatterwalk_sg_next(sg);
 	}
 
 	scatterwalk_advance(&walk, start - offset);
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 07b6f17..bd62431 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -52,6 +52,17 @@ static inline void crypto_yield(u32 flags)
 		cond_resched();
 }
 
+static inline void scatterwalk_sg_chain(struct scatterlist *sg1, int num,
+					struct scatterlist *sg2)
+{
+	sg_set_page(&sg1[num - 1], (void *)sg2, 0, 0);
+}
+
+static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
+{
+	return (++sg)->length ? sg : (void *)sg_page(sg);
+}
+
 static inline unsigned long scatterwalk_samebuf(struct scatter_walk *walk_in,
 						struct scatter_walk *walk_out)
 {
