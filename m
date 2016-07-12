From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 21/30] crypto: scatterwalk - Remove scatterwalk_bytes_sglen
Date: Tue, 12 Jul 2016 13:17:53 +0800
Message-ID: <E1bMq4v-0007TX-VP@gondolin.me.apana.org.au>
References: <20160712051554.GA28324@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58197 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972AbcGLFR4 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Jul 2016 01:17:56 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1bMq4w-0004fX-8X
	for <linux-crypto@vger.kernel.org>; Tue, 12 Jul 2016 15:17:54 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch removes the now unused scatterwalk_bytes_sglen.  Anyone
using this out-of-tree should switch over to sg_nents_for_len.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c         |   22 ----------------------
 include/crypto/scatterwalk.h |    2 --
 2 files changed, 24 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index ea5815c..03ca4ae 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -125,28 +125,6 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 }
 EXPORT_SYMBOL_GPL(scatterwalk_map_and_copy);
 
-int scatterwalk_bytes_sglen(struct scatterlist *sg, int num_bytes)
-{
-	int offset = 0, n = 0;
-
-	/* num_bytes is too small */
-	if (num_bytes < sg->length)
-		return -1;
-
-	do {
-		offset += sg->length;
-		n++;
-		sg = sg_next(sg);
-
-		/* num_bytes is too large */
-		if (unlikely(!sg && (num_bytes < offset)))
-			return -1;
-	} while (sg && (num_bytes > offset));
-
-	return n;
-}
-EXPORT_SYMBOL_GPL(scatterwalk_bytes_sglen);
-
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
 				     unsigned int len)
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 35f99b6..7e1a336 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -92,8 +92,6 @@ void scatterwalk_done(struct scatter_walk *walk, int out, int more);
 void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			      unsigned int start, unsigned int nbytes, int out);
 
-int scatterwalk_bytes_sglen(struct scatterlist *sg, int num_bytes);
-
 struct scatterlist *scatterwalk_ffwd(struct scatterlist dst[2],
 				     struct scatterlist *src,
 				     unsigned int len);
