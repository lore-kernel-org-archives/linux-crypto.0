From: Romain Izard <romain.izard.pro@gmail.com>
Subject: [PATCH] crypto: ccm - preserve the IV buffer
Date: Tue, 31 Oct 2017 15:42:35 +0100
Message-ID: <20171031144235.22818-1-romain.izard.pro@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Romain Izard <romain.izard.pro@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The IV buffer used during CCM operations is used twice, during both the
hashing step and the ciphering step.

When using a hardware accelerator that updates the contents of the IV
buffer at the end of ciphering operations, the value will be modified.
In the decryption case, the subsequent setup of the hashing algorithm
will interpret the updated IV instead of the original value, which can
lead to out-of-bounds writes.

Reuse the idata buffer, only used in the hashing step, to preserve the
IV's value during the ciphering step in the decryption case.

Signed-off-by: Romain Izard <romain.izard.pro@gmail.com>
---
 crypto/ccm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/ccm.c b/crypto/ccm.c
index 1ce37ae0ce56..0a083342ec8c 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -363,7 +363,7 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 	unsigned int cryptlen = req->cryptlen;
 	u8 *authtag = pctx->auth_tag;
 	u8 *odata = pctx->odata;
-	u8 *iv = req->iv;
+	u8 *iv = pctx->idata;
 	int err;
 
 	cryptlen -= authsize;
@@ -379,6 +379,8 @@ static int crypto_ccm_decrypt(struct aead_request *req)
 	if (req->src != req->dst)
 		dst = pctx->dst;
 
+	memcpy(iv, req->iv, 16);
+
 	skcipher_request_set_tfm(skreq, ctx->ctr);
 	skcipher_request_set_callback(skreq, pctx->flags,
 				      crypto_ccm_decrypt_done, req);
-- 
2.14.1
