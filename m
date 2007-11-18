From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 1/4] [CRYPTO] scatterwalk: Use generic scatterlist chaining
Date: Sun, 18 Nov 2007 21:31:58 +0800
Message-ID: <E1ItkFi-0007Sk-00@gondolin.me.apana.org.au>
References: <20071118133054.GA28619@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4575 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752163AbXKRNcB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Nov 2007 08:32:01 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1ItkFj-00073O-Dl
	for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2007 00:31:59 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] scatterwalk: Use generic scatterlist chaining

This patch converts the crypto scatterwalk code to use the generic
scatterlist chaining rather the version specific to crypto.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/digest.c      |    3 +--
 crypto/hmac.c        |    2 +-
 crypto/scatterwalk.c |    2 +-
 crypto/scatterwalk.h |    5 -----
 4 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/crypto/digest.c b/crypto/digest.c
index 8871dec..d3e827a 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -21,7 +21,6 @@
 #include <linux/scatterlist.h>
 
 #include "internal.h"
-#include "scatterwalk.h"
 
 static int init(struct hash_desc *desc)
 {
@@ -77,7 +76,7 @@ static int update2(struct hash_desc *desc,
 
 		if (!nbytes)
 			break;
-		sg = scatterwalk_sg_next(sg);
+		sg = sg_next(sg);
 	}
 
 	return 0;
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 0f05be7..34c3706 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -160,7 +160,7 @@ static int hmac_digest(struct hash_desc *pdesc, struct scatterlist *sg,
 
 	sg_init_table(sg1, 2);
 	sg_set_buf(sg1, ipad, bs);
-	sg_set_page(&sg1[1], (void *) sg, 0, 0);
+	sg_chain(sg1, 2, sg);
 
 	sg_init_table(sg2, 1);
 	sg_set_buf(sg2, opad, bs + ds);
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index b9bbda0..206c39a 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -62,7 +62,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 		walk->offset += PAGE_SIZE - 1;
 		walk->offset &= PAGE_MASK;
 		if (walk->offset >= walk->sg->offset + walk->sg->length)
-			scatterwalk_start(walk, scatterwalk_sg_next(walk->sg));
+			scatterwalk_start(walk, sg_next(walk->sg));
 	}
 }
 
diff --git a/crypto/scatterwalk.h b/crypto/scatterwalk.h
index 87ed681..fd5517d 100644
--- a/crypto/scatterwalk.h
+++ b/crypto/scatterwalk.h
@@ -20,11 +20,6 @@
 
 #include "internal.h"
 
-static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
-{
-	return (++sg)->length ? sg : (void *) sg_page(sg);
-}
-
 static inline unsigned long scatterwalk_samebuf(struct scatter_walk *walk_in,
 						struct scatter_walk *walk_out)
 {
