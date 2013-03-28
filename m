From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH] crypto: gcm - fix assumption that assoc has one segment
Date: Thu, 28 Mar 2013 21:54:03 +0200
Message-ID: <20130328195403.13775.20772.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:33224 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738Ab3C1TyI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Mar 2013 15:54:08 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

rfc4543(gcm(*)) code for GMAC assumes that assoc scatterlist always contains
only one segment and only makes use of this first segment. However ipsec passes
assoc with three segments when using 'extended sequence number' thus in this
case rfc4543(gcm(*)) fails to function correctly. Patch fixes this issue.

Reported-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Tested-by: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/gcm.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 137ad1e..13ccbda 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -44,6 +44,7 @@ struct crypto_rfc4543_ctx {
 
 struct crypto_rfc4543_req_ctx {
 	u8 auth_tag[16];
+	u8 assocbuf[32];
 	struct scatterlist cipher[1];
 	struct scatterlist payload[2];
 	struct scatterlist assoc[2];
@@ -1133,9 +1134,19 @@ static struct aead_request *crypto_rfc4543_crypt(struct aead_request *req,
 	scatterwalk_crypto_chain(payload, dst, vdst == req->iv + 8, 2);
 	assoclen += 8 + req->cryptlen - (enc ? 0 : authsize);
 
-	sg_init_table(assoc, 2);
-	sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
-		    req->assoc->offset);
+	if (req->assoc->length == req->assoclen) {
+		sg_init_table(assoc, 2);
+		sg_set_page(assoc, sg_page(req->assoc), req->assoc->length,
+			    req->assoc->offset);
+	} else {
+		BUG_ON(req->assoclen > sizeof(rctx->assocbuf));
+
+		scatterwalk_map_and_copy(rctx->assocbuf, req->assoc, 0,
+					 req->assoclen, 0);
+
+		sg_init_table(assoc, 2);
+		sg_set_buf(assoc, rctx->assocbuf, req->assoclen);
+	}
 	scatterwalk_crypto_chain(assoc, payload, 0, 2);
 
 	aead_request_set_tfm(subreq, ctx->child);
