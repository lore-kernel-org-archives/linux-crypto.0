From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 2/3] crypto: picoxcell - Make use of sg_nents_for_len
Date: Thu, 11 Jun 2015 11:28:33 +0800
Message-ID: <E1Z2tAP-0002jF-QI@gondolin.me.apana.org.au>
References: <20150611032703.GA10416@gondor.apana.org.au>
To: Jamie Iles <jamie@jamieiles.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45068 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbFKD2g (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 23:28:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch makes use of the new sg_nents_for_len helper to replace
the custom sg_count function.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/picoxcell_crypto.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index aabf9d4..9eb27c7 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -262,18 +262,9 @@ static unsigned spacc_load_ctx(struct spacc_generic_ctx *ctx,
 }
 
 /* Count the number of scatterlist entries in a scatterlist. */
-static int sg_count(struct scatterlist *sg_list, int nbytes)
+static inline int sg_count(struct scatterlist *sg_list, int nbytes)
 {
-	struct scatterlist *sg = sg_list;
-	int sg_nents = 0;
-
-	while (nbytes > 0) {
-		++sg_nents;
-		nbytes -= sg->length;
-		sg = sg_next(sg);
-	}
-
-	return sg_nents;
+	return sg_nents_for_len(sg_list, nbytes);
 }
 
 static inline void ddt_set(struct spacc_ddt *ddt, dma_addr_t phys, size_t len)
