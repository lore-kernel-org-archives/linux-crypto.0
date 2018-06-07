From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH] crypto: ccree: fix iv copying for small buffers
Date: Thu,  7 Jun 2018 09:58:47 +0100
Message-ID: <1528361927-4172-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>, stable@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

We are copying our last cipher block into the request for use as IV as
required by the Crypto API but we failed to handle correctly the case the
buffer we are working on is smaller than a block. Fix it by calculating
how much we need to copy based on buffer size.

CC: stable@vger.kernel.org
Fixes: 63ee04c8b491 ("crypto: ccree - add skcipher support")
Reported by: Hadar Gat <hadar.gat@arm.com>
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 drivers/crypto/ccree/cc_cipher.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index d2810c1..a07547f 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -616,9 +616,18 @@ static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
 		memcpy(req->iv, req_ctx->backup_info, ivsize);
 		kzfree(req_ctx->backup_info);
 	} else if (!err) {
-		scatterwalk_map_and_copy(req->iv, req->dst,
-					 (req->cryptlen - ivsize),
-					 ivsize, 0);
+		unsigned int len;
+
+		if (req->cryptlen > ivsize) {
+			len = req->cryptlen - ivsize;
+		} else {
+			memset(req->iv, 0, ivsize);
+			len = 0;
+			ivsize = req->cryptlen;
+
+		}
+
+		scatterwalk_map_and_copy(req->iv, req->dst, len, ivsize, 0);
 	}
 
 	skcipher_request_complete(req, err);
@@ -755,17 +764,26 @@ static int cc_cipher_decrypt(struct skcipher_request *req)
 	struct cipher_req_ctx *req_ctx = skcipher_request_ctx(req);
 	unsigned int ivsize = crypto_skcipher_ivsize(sk_tfm);
 	gfp_t flags = cc_gfp_flags(&req->base);
+	unsigned int len;
 
 	/*
 	 * Allocate and save the last IV sized bytes of the source, which will
 	 * be lost in case of in-place decryption and might be needed for CTS.
 	 */
-	req_ctx->backup_info = kmalloc(ivsize, flags);
+	req_ctx->backup_info = kzalloc(ivsize, flags);
 	if (!req_ctx->backup_info)
 		return -ENOMEM;
 
-	scatterwalk_map_and_copy(req_ctx->backup_info, req->src,
-				 (req->cryptlen - ivsize), ivsize, 0);
+
+	if (req->cryptlen > ivsize) {
+		len = req->cryptlen - ivsize;
+	} else {
+		len = 0;
+		ivsize = req->cryptlen;
+	}
+
+	scatterwalk_map_and_copy(req_ctx->backup_info, req->src, len, ivsize,
+				 0);
 	req_ctx->is_giv = false;
 
 	return cc_cipher_process(req, DRV_CRYPTO_DIRECTION_DECRYPT);
-- 
2.7.4
