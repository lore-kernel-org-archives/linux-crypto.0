From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 11/11] [CRYPTO] authenc: Add givcrypt operation
Date: Thu, 22 Nov 2007 16:49:14 +0800
Message-ID: <E1Iv7kI-000220-00@gondolin.me.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au>
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:4698 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751506AbXKVItT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 03:49:19 -0500
Received: from gondolin.me.apana.org.au ([192.168.0.6] ident=mail)
	by arnor.apana.org.au with esmtp (Exim 4.50 #1 (Debian))
	id 1Iv7kI-0008F0-GG
	for <linux-crypto@vger.kernel.org>; Thu, 22 Nov 2007 19:49:14 +1100
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[CRYPTO] authenc: Add givcrypt operation

This patch implements the givcrypt function for authenc.  It simply
calls the givcrypt operation on the underlying cipher instead of encrypt.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 crypto/authenc.c |   21 +++++++++++++++++++++
 1 files changed, 21 insertions(+)

diff --git a/crypto/authenc.c b/crypto/authenc.c
index bc4e608..c06f808 100644
--- a/crypto/authenc.c
+++ b/crypto/authenc.c
@@ -144,6 +144,26 @@ static int crypto_authenc_encrypt(struct aead_request *req)
 	return crypto_authenc_hash(req);
 }
 
+static int crypto_authenc_givcrypt(struct aead_request *req)
+{
+	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
+	struct crypto_authenc_ctx *ctx = crypto_aead_ctx(authenc);
+	struct ablkcipher_request *abreq = aead_request_ctx(req);
+	int err;
+
+	ablkcipher_request_set_tfm(abreq, ctx->enc);
+	ablkcipher_request_set_callback(abreq, aead_request_flags(req),
+					crypto_authenc_encrypt_done, req);
+	ablkcipher_request_set_crypt(abreq, req->src, req->dst, req->cryptlen,
+				     req->iv);
+
+	err = crypto_ablkcipher_givcrypt(abreq);
+	if (err)
+		return err;
+
+	return crypto_authenc_hash(req);
+}
+
 static int crypto_authenc_verify(struct aead_request *req)
 {
 	struct crypto_aead *authenc = crypto_aead_reqtfm(req);
@@ -346,6 +366,7 @@ static struct crypto_instance *crypto_authenc_alloc(struct rtattr **tb)
 
 	inst->alg.cra_aead.setkey = crypto_authenc_setkey;
 	inst->alg.cra_aead.encrypt = crypto_authenc_encrypt;
+	inst->alg.cra_aead.givcrypt = crypto_authenc_givcrypt;
 	inst->alg.cra_aead.decrypt = crypto_authenc_decrypt;
 
 out:
