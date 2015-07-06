From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: crypto: cryptd - Fix AEAD request context corruption
Date: Mon, 6 Jul 2015 19:11:03 +0800
Message-ID: <20150706111103.GA21776@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46060 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482AbbGFLLI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 6 Jul 2015 07:11:08 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The AEAD version of cryptd uses the same context for its own state
as well as that of the child.  In doing so it did not maintain the
proper ordering, thus resulting in potential state corruption where
the child will overwrite the state stored by cryptd.

This patch fixes and also sets the request size properly.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/cryptd.c b/crypto/cryptd.c
index 22ba81f..2f833dc 100644
--- a/crypto/cryptd.c
+++ b/crypto/cryptd.c
@@ -688,16 +688,18 @@ static void cryptd_aead_crypt(struct aead_request *req,
 			int (*crypt)(struct aead_request *req))
 {
 	struct cryptd_aead_request_ctx *rctx;
+	crypto_completion_t compl;
+
 	rctx = aead_request_ctx(req);
+	compl = rctx->complete;
 
 	if (unlikely(err == -EINPROGRESS))
 		goto out;
 	aead_request_set_tfm(req, child);
 	err = crypt( req );
-	req->base.complete = rctx->complete;
 out:
 	local_bh_disable();
-	rctx->complete(&req->base, err);
+	compl(&req->base, err);
 	local_bh_enable();
 }
 
@@ -756,7 +758,9 @@ static int cryptd_aead_init_tfm(struct crypto_aead *tfm)
 		return PTR_ERR(cipher);
 
 	ctx->child = cipher;
-	crypto_aead_set_reqsize(tfm, sizeof(struct cryptd_aead_request_ctx));
+	crypto_aead_set_reqsize(
+		tfm, max((unsigned)sizeof(struct cryptd_aead_request_ctx),
+			 crypto_aead_reqsize(cipher)));
 	return 0;
 }
 
@@ -775,7 +779,7 @@ static int cryptd_create_aead(struct crypto_template *tmpl,
 	struct aead_alg *alg;
 	const char *name;
 	u32 type = 0;
-	u32 mask = 0;
+	u32 mask = CRYPTO_ALG_ASYNC;
 	int err;
 
 	cryptd_check_internal(tb, &type, &mask);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
