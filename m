From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: authencesn - Fix breakage with new ESP code
Date: Fri, 7 Aug 2015 16:00:04 +0800
Message-ID: <20150807080004.GA26046@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48088 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030195AbbHGIAH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Aug 2015 04:00:07 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ESP code has been updated to generate a completely linear
AD SG list.  This unfortunately broke authencesn which expects
the AD to be divided into at least three parts.

This patch fixes it to cope with the new format.  Later we will
fix it properly to accept arbitrary input and not rely on the
input being linear as part of the AEAD conversion.

Fixes: 7021b2e1cddd ("esp4: Switch to new AEAD interface")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/authencesn.c b/crypto/authencesn.c
index a3da677..b8efe36 100644
--- a/crypto/authencesn.c
+++ b/crypto/authencesn.c
@@ -393,8 +393,6 @@ static int crypto_authenc_esn_genicv(struct aead_request *req, u8 *iv,
 	struct scatterlist *cipher = areq_ctx->cipher;
 	struct scatterlist *hsg = areq_ctx->hsg;
 	struct scatterlist *tsg = areq_ctx->tsg;
-	struct scatterlist *assoc1;
-	struct scatterlist *assoc2;
 	unsigned int ivsize = crypto_aead_ivsize(authenc_esn);
 	unsigned int cryptlen = req->cryptlen;
 	struct page *dstp;
@@ -412,27 +410,19 @@ static int crypto_authenc_esn_genicv(struct aead_request *req, u8 *iv,
 		cryptlen += ivsize;
 	}
 
-	if (sg_is_last(assoc))
-		return -EINVAL;
-
-	assoc1 = assoc + 1;
-	if (sg_is_last(assoc1))
-		return -EINVAL;
-
-	assoc2 = assoc + 2;
-	if (!sg_is_last(assoc2))
+	if (assoc->length < 12)
 		return -EINVAL;
 
 	sg_init_table(hsg, 2);
-	sg_set_page(hsg, sg_page(assoc), assoc->length, assoc->offset);
-	sg_set_page(hsg + 1, sg_page(assoc2), assoc2->length, assoc2->offset);
+	sg_set_page(hsg, sg_page(assoc), 4, assoc->offset);
+	sg_set_page(hsg + 1, sg_page(assoc), 4, assoc->offset + 8);
 
 	sg_init_table(tsg, 1);
-	sg_set_page(tsg, sg_page(assoc1), assoc1->length, assoc1->offset);
+	sg_set_page(tsg, sg_page(assoc), 4, assoc->offset + 4);
 
 	areq_ctx->cryptlen = cryptlen;
-	areq_ctx->headlen = assoc->length + assoc2->length;
-	areq_ctx->trailen = assoc1->length;
+	areq_ctx->headlen = 8;
+	areq_ctx->trailen = 4;
 	areq_ctx->sg = dst;
 
 	areq_ctx->complete = authenc_esn_geniv_ahash_done;
@@ -563,8 +553,6 @@ static int crypto_authenc_esn_iverify(struct aead_request *req, u8 *iv,
 	struct scatterlist *cipher = areq_ctx->cipher;
 	struct scatterlist *hsg = areq_ctx->hsg;
 	struct scatterlist *tsg = areq_ctx->tsg;
-	struct scatterlist *assoc1;
-	struct scatterlist *assoc2;
 	unsigned int ivsize = crypto_aead_ivsize(authenc_esn);
 	struct page *srcp;
 	u8 *vsrc;
@@ -580,27 +568,19 @@ static int crypto_authenc_esn_iverify(struct aead_request *req, u8 *iv,
 		cryptlen += ivsize;
 	}
 
-	if (sg_is_last(assoc))
-		return -EINVAL;
-
-	assoc1 = assoc + 1;
-	if (sg_is_last(assoc1))
-		return -EINVAL;
-
-	assoc2 = assoc + 2;
-	if (!sg_is_last(assoc2))
+	if (assoc->length < 12)
 		return -EINVAL;
 
 	sg_init_table(hsg, 2);
-	sg_set_page(hsg, sg_page(assoc), assoc->length, assoc->offset);
-	sg_set_page(hsg + 1, sg_page(assoc2), assoc2->length, assoc2->offset);
+	sg_set_page(hsg, sg_page(assoc), 4, assoc->offset);
+	sg_set_page(hsg + 1, sg_page(assoc), 4, assoc->offset + 8);
 
 	sg_init_table(tsg, 1);
-	sg_set_page(tsg, sg_page(assoc1), assoc1->length, assoc1->offset);
+	sg_set_page(tsg, sg_page(assoc), 4, assoc->offset + 4);
 
 	areq_ctx->cryptlen = cryptlen;
-	areq_ctx->headlen = assoc->length + assoc2->length;
-	areq_ctx->trailen = assoc1->length;
+	areq_ctx->headlen = 8;
+	areq_ctx->trailen = 4;
 	areq_ctx->sg = src;
 
 	areq_ctx->complete = authenc_esn_verify_ahash_done;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
