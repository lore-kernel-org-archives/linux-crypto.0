From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 7/8] [CRYPTO] gcm: Fix givencrypt/givdecrypt
Date: Mon, 17 Dec 2007 18:31:19 +0800
Message-ID: <E1J4DFn-00039O-00@gondolin.me.apana.org.au>
References: <20071217103037.GA11988@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4844 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759994AbXLQKb0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 17 Dec 2007 05:31:26 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1J4DFq-0008Vf-1M
	for <linux-crypto@vger.kernel.org>; Mon, 17 Dec 2007 21:31:22 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

[CRYPTO] gcm: Fix givencrypt/givdecrypt

This patch makes givencrypt and givdecrypt call skcipher_givcrypt_set_tfm
to set the correct tfm for the sub-request.  Without this we may try to
call givencrypt and givdecrypt on an skcipher that does not have these
operations.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/gcm.c |    6 ++++++
 1 files changed, 6 insertions(+)

diff --git a/crypto/gcm.c b/crypto/gcm.c
index 6f23f02..8f1d08c 100644
--- a/crypto/gcm.c
+++ b/crypto/gcm.c
@@ -305,6 +305,8 @@ static int crypto_gcm_encrypt(struct aead_request *req)
 
 static int crypto_gcm_givencrypt(struct aead_givcrypt_request *req)
 {
+	struct crypto_aead *aead = aead_givcrypt_reqtfm(req);
+	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	struct aead_request *areq = &req->areq;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(areq);
 	struct skcipher_givcrypt_request *greq = &pctx->greq;
@@ -312,6 +314,7 @@ static int crypto_gcm_givencrypt(struct aead_givcrypt_request *req)
 	int err;
 
 	crypto_gcm_init_encrypt(abreq, areq);
+	skcipher_givcrypt_set_tfm(greq, ctx->ctr);
 	skcipher_givcrypt_set_giv(greq, req->giv, req->seq);
 
 	err = crypto_skcipher_givencrypt(greq);
@@ -388,6 +391,8 @@ static int crypto_gcm_decrypt(struct aead_request *req)
 
 static int crypto_gcm_givdecrypt(struct aead_givcrypt_request *req)
 {
+	struct crypto_aead *aead = aead_givcrypt_reqtfm(req);
+	struct crypto_gcm_ctx *ctx = crypto_aead_ctx(aead);
 	struct aead_request *areq = &req->areq;
 	struct crypto_gcm_req_priv_ctx *pctx = crypto_gcm_reqctx(areq);
 	struct skcipher_givcrypt_request *greq = &pctx->greq;
@@ -398,6 +403,7 @@ static int crypto_gcm_givdecrypt(struct aead_givcrypt_request *req)
 	if (err)
 		return err;
 
+	skcipher_givcrypt_set_tfm(greq, ctx->ctr);
 	skcipher_givcrypt_set_giv(greq, req->giv, req->seq);
 
 	err = crypto_skcipher_givdecrypt(greq);
