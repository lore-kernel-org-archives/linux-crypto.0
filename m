From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH v2 5/6] crypto: ccree: use CBC-CS3 CTS mode
Date: Sun,  1 Jul 2018 08:02:38 +0100
Message-ID: <1530428560-4440-6-git-send-email-gilad@benyossef.com>
References: <1530428560-4440-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, Hadar Gat <hadar.gat@arm.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530428560-4440-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The ccree driver implemented NIST 800-38A CBC-CS2 ciphertext format,
which only reverses the last two blocks if the stolen ciphertext amount
are none zero. Move it to the kernel chosen format of CBC-CS3  which swaps
the final blocks unconditionally and rename it to "cts" now that it
complies with the kernel format and passes the self tests.

Ironically, the CryptoCell REE HW does just that, so the fix is dropping
the code that forced it to use plain CBC if the ciphertext was block
aligned.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 5d12372..7a80963 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -687,7 +687,7 @@ static int cc_cipher_process(struct skcipher_request *req,
 	struct device *dev = drvdata_to_dev(ctx_p->drvdata);
 	struct cc_hw_desc desc[MAX_ABLKCIPHER_SEQ_LEN];
 	struct cc_crypto_req cc_req = {};
-	int rc, cts_restore_flag = 0;
+	int rc;
 	unsigned int seq_len = 0;
 	gfp_t flags = cc_gfp_flags(&req->base);
 
@@ -719,13 +719,6 @@ static int cc_cipher_process(struct skcipher_request *req,
 		goto exit_process;
 	}
 
-	/*For CTS in case of data size aligned to 16 use CBC mode*/
-	if (((nbytes % AES_BLOCK_SIZE) == 0) &&
-	    ctx_p->cipher_mode == DRV_CIPHER_CBC_CTS) {
-		ctx_p->cipher_mode = DRV_CIPHER_CBC;
-		cts_restore_flag = 1;
-	}
-
 	/* Setup request structure */
 	cc_req.user_cb = (void *)cc_cipher_complete;
 	cc_req.user_arg = (void *)req;
@@ -770,9 +763,6 @@ static int cc_cipher_process(struct skcipher_request *req,
 	}
 
 exit_process:
-	if (cts_restore_flag)
-		ctx_p->cipher_mode = DRV_CIPHER_CBC_CTS;
-
 	if (rc != -EINPROGRESS && rc != -EBUSY) {
 		kzfree(req_ctx->backup_info);
 		kzfree(req_ctx->iv);
@@ -1026,8 +1016,8 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.min_hw_rev = CC_HW_REV_712,
 	},
 	{
-		.name = "cts1(cbc(paes))",
-		.driver_name = "cts1-cbc-paes-ccree",
+		.name = "cts(cbc(paes))",
+		.driver_name = "cts-cbc-paes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
@@ -1261,8 +1251,8 @@ static const struct cc_alg_template skcipher_algs[] = {
 		.min_hw_rev = CC_HW_REV_630,
 	},
 	{
-		.name = "cts1(cbc(aes))",
-		.driver_name = "cts1-cbc-aes-ccree",
+		.name = "cts(cbc(aes))",
+		.driver_name = "cts-cbc-aes-ccree",
 		.blocksize = AES_BLOCK_SIZE,
 		.type = CRYPTO_ALG_TYPE_ABLKCIPHER,
 		.template_skcipher = {
-- 
2.7.4
