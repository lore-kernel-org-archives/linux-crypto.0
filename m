From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 13/16] crypto: scatterwalk - Check for same address in map_and_copy
Date: Thu, 21 May 2015 15:11:12 +0800
Message-ID: <E1YvKdM-0005gB-AG@gondolin.me.apana.org.au>
References: <20150521070915.GA20997@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45448 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbbEUHLP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 21 May 2015 03:11:15 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6])
	by norbury.hengli.com.au with esmtp (Exim 4.80 #3 (Debian))
	id 1YvKdM-00030i-Km
	for <linux-crypto@vger.kernel.org>; Thu, 21 May 2015 17:11:12 +1000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch adds a check for in scatterwalk_map_and_copy to avoid
copying from the same address to the same address.  This is going
to be used for IV copying in AEAD IV generators.

There is no provision for partial overlaps.

This patch also uses the new scatterwalk_ffwd instead of doing
it by hand in scatterwalk_map_and_copy.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/scatterwalk.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index db920b5..8690324 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -104,22 +104,18 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			      unsigned int start, unsigned int nbytes, int out)
 {
 	struct scatter_walk walk;
-	unsigned int offset = 0;
+	struct scatterlist tmp[2];
 
 	if (!nbytes)
 		return;
 
-	for (;;) {
-		scatterwalk_start(&walk, sg);
-
-		if (start < offset + sg->length)
-			break;
+	sg = scatterwalk_ffwd(tmp, sg, start);
 
-		offset += sg->length;
-		sg = sg_next(sg);
-	}
+	if (sg_page(sg) == virt_to_page(buf) &&
+	    sg->offset == offset_in_page(buf))
+		return;
 
-	scatterwalk_advance(&walk, start - offset);
+	scatterwalk_start(&walk, sg);
 	scatterwalk_copychunks(buf, &walk, nbytes, out);
 	scatterwalk_done(&walk, out, 0);
 }
