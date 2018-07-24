From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 3/4] crypto: ccree: zero all of request ctx before use
Date: Tue, 24 Jul 2018 15:12:45 +0100
Message-ID: <1532441567-11694-4-git-send-email-gilad@benyossef.com>
References: <1532441567-11694-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1532441567-11694-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

In certain error path req_ctx->iv was being freed despite
not being allocated because it was not initialized to NULL.
Rather than play whack a mole with the structure various
field, zero it before use.

This fixes a kernel panic that may occur if an invalid
buffer size was requested triggering the bug above.

Fixes: 63ee04c8b491 ("crypto: ccree - add skcipher support")
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 64740dd..9da0ecc 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -767,7 +767,7 @@ static int cc_cipher_encrypt(struct skcipher_request *req)
 {
 	struct cipher_req_ctx *req_ctx = skcipher_request_ctx(req);
 
-	req_ctx->backup_info = NULL;
+	memset(req_ctx, 0, sizeof(*req_ctx));
 
 	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_ENCRYPT);
 }
@@ -782,6 +782,8 @@ static int cc_cipher_decrypt(struct skcipher_request *req)
 	gfp_t flags = cc_gfp_flags(&req->base);
 	unsigned int len;
 
+	memset(req_ctx, 0, sizeof(*req_ctx));
+
 	if (ctx_p->cipher_mode == DRV_CIPHER_CBC) {
 
 		/* Allocate and save the last IV sized bytes of the source,
@@ -794,8 +796,6 @@ static int cc_cipher_decrypt(struct skcipher_request *req)
 		len = req->cryptlen - ivsize;
 		scatterwalk_map_and_copy(req_ctx->backup_info, req->src, len,
 					 ivsize, 0);
-	} else {
-		req_ctx->backup_info = NULL;
 	}
 
 	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-- 
2.7.4
