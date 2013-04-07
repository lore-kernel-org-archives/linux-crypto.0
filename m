From: Jussi Kivilinna <jussi.kivilinna@iki.fi>
Subject: [PATCH 2/4] crypto: gcm - fix rfc4543 to handle async crypto
 correctly
Date: Sun, 07 Apr 2013 16:43:46 +0300
Message-ID: <20130407134346.8718.18383.stgit@localhost6.localdomain6>
References: <20130407134340.8718.96643.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sd-mail-sa-02.sanoma.fi ([158.127.18.162]:41996 "EHLO
	sd-mail-sa-02.sanoma.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933606Ab3DGNns (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Apr 2013 09:43:48 -0400
In-Reply-To: <20130407134340.8718.96643.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If the gcm cipher used by rfc4543 does not complete request immediately,
the authentication tag is not copied to destination buffer. Patch adds
correct async logic for this case.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@iki.fi>
---
 crypto/gcm.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 4ff2139..b0d3cb1 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -1099,6 +1099,21 @@ static int crypto_rfc4543_setauthsize(struct crypto_aead *parent,
 	return crypto_aead_setauthsize(ctx->child, authsize);
 }
 
+static void crypto_rfc4543_done(struct crypto_async_request *areq, int err)
+{
+	struct aead_request *req = areq->data;
+	struct crypto_aead *aead = crypto_aead_reqtfm(req);
+	struct crypto_rfc4543_req_ctx *rctx = crypto_rfc4543_reqctx(req);
+
+	if (!err) {
+		scatterwalk_map_and_copy(rctx->auth_tag, req->dst,
+					 req->cryptlen,
+					 crypto_aead_authsize(aead), 1);
+	}
+
+	aead_request_complete(req, err);
+}
+
 static struct aead_request *crypto_rfc4543_crypt(struct aead_request *req,
 						 bool enc)
 {
@@ -1145,8 +1160,8 @@ static struct aead_request *crypto_rfc4543_crypt(struct aead_request *req,
 	scatterwalk_crypto_chain(assoc, payload, 0, 2);
 
 	aead_request_set_tfm(subreq, ctx->child);
-	aead_request_set_callback(subreq, req->base.flags, req->base.complete,
-				  req->base.data);
+	aead_request_set_callback(subreq, req->base.flags, crypto_rfc4543_done,
+				  req);
 	aead_request_set_crypt(subreq, cipher, cipher, enc ? 0 : authsize, iv);
 	aead_request_set_assoc(subreq, assoc, assoclen);
 
