From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 3/3] crypto: picoxcell - Clamp AEAD SG list by input length
Date: Thu, 11 Jun 2015 11:28:34 +0800
Message-ID: <E1Z2tAQ-0002jY-UK@gondolin.me.apana.org.au>
References: <20150611032703.GA10416@gondor.apana.org.au>
To: Jamie Iles <jamie@jamieiles.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:36408 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbFKD2i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Jun 2015 23:28:38 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Currently the driver assumes that the SG list contains exactly
the number of bytes required.  This assumption is incorrect.
    
Up until now this has been harmless.  However with the new AEAD
interface this now breaks as the AD SG list contains more bytes
than just the AD.
    
This patch fixes this by always clamping the AD SG list by the
specified AD length.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 drivers/crypto/picoxcell_crypto.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 9eb27c7..c2fd860 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -318,6 +318,7 @@ static int spacc_aead_make_ddts(struct spacc_req *req, u8 *giv)
 	struct spacc_ddt *src_ddt, *dst_ddt;
 	unsigned ivsize = crypto_aead_ivsize(crypto_aead_reqtfm(areq));
 	unsigned nents = sg_count(areq->src, areq->cryptlen);
+	unsigned total;
 	dma_addr_t iv_addr;
 	struct scatterlist *cur;
 	int i, dst_ents, src_ents, assoc_ents;
@@ -361,11 +362,18 @@ static int spacc_aead_make_ddts(struct spacc_req *req, u8 *giv)
 	 * Map the associated data. For decryption we don't copy the
 	 * associated data.
 	 */
+	total = areq->assoclen;
 	for_each_sg(areq->assoc, cur, assoc_ents, i) {
-		ddt_set(src_ddt++, sg_dma_address(cur), sg_dma_len(cur));
+		unsigned len = sg_dma_len(cur);
+
+		if (len > total)
+			len = total;
+
+		total -= len;
+
+		ddt_set(src_ddt++, sg_dma_address(cur), len);
 		if (req->is_encrypt)
-			ddt_set(dst_ddt++, sg_dma_address(cur),
-				sg_dma_len(cur));
+			ddt_set(dst_ddt++, sg_dma_address(cur), len);
 	}
 	ddt_set(src_ddt++, iv_addr, ivsize);
 
