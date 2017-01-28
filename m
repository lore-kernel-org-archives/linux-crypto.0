From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH -stable] crypto: ccm - deal with CTR ciphers that honour iv_out
Date: Sat, 28 Jan 2017 20:40:05 +0000
Message-ID: <1485636005-5192-1-git-send-email-ard.biesheuvel@linaro.org>
Cc: herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37818 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751960AbdA1UkS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 28 Jan 2017 15:40:18 -0500
Received: by mail-wm0-f52.google.com with SMTP id c206so192353550wme.0
        for <linux-crypto@vger.kernel.org>; Sat, 28 Jan 2017 12:40:17 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The skcipher API mandates that chaining modes involving IVs calculate
an outgoing IV value that is suitable for encrypting additional blocks
of data. This means the CCM driver cannot assume that req->iv points to
the original IV value when it calls crypto_ccm_auth. So pass a copy to
the skcipher instead.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/ccm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index b388ac6edfb9..8976ef9bc2e7 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -362,7 +362,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 	unsigned int cryptlen = req->cryptlen;
 	u8 *authtag = pctx->auth_tag;
 	u8 *odata = pctx->odata;
-	u8 *iv = req->iv;
+	u8 iv[16];
 	int err;
 
 	cryptlen -= authsize;
@@ -378,6 +378,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 	if (req->src != req->dst)
 		dst = pctx->dst;
 
+	memcpy(iv, req->iv, sizeof(iv));
 	skcipher_request_set_tfm(skreq, ctx->ctr);
 	skcipher_request_set_callback(skreq, pctx->flags,
 				      crypto_ccm_decrypt_done, req);
-- 
2.7.4
