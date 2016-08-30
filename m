From: Iaroslav Gridin <voker57@gmail.com>
Subject: [PATCH 4/4] crypto: qce: If total text size is zero, return pre-computed digest
Date: Tue, 30 Aug 2016 18:53:53 +0300
Message-ID: <20160830155353.19500-5-voker57@gmail.com>
References: <20160830155353.19500-1-voker57@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.gross@linaro.org,
        david.brown@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, Voker57 <voker57@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36069 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757085AbcH3PyZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Aug 2016 11:54:25 -0400
In-Reply-To: <20160830155353.19500-1-voker57@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Voker57 <voker57@gmail.com>

If total data amount to hash is zero, we cannot submit it to QCE,
since it locks up on zero-sized updates. So, return pre-computed
SHA256/SHA1 hash.
Signed-off-by: Iaroslav Gridin <voker57@gmail.com>
---
 drivers/crypto/qce/sha.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index f199f28..c627b5d 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -80,6 +80,7 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 	struct qce_sha_ctx *ctx = crypto_tfm_ctx(async_req->tfm);
 	struct qce_alg_template *tmpl = to_ahash_tmpl(async_req->tfm);
 	struct qce_device *qce = tmpl->qce;
+	unsigned int digestsize = crypto_ahash_digestsize(crypto_ahash_reqtfm(req));
 	unsigned long flags = rctx->flags;
 	int ret;
 
@@ -91,6 +92,29 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 		rctx->authklen = AES_KEYSIZE_128;
 	}
 
+	if (!req->nbytes) {
+		/* Only way that can happen is if total size of digest is zero
+		 * So since QCE gets stuck on zero-sized texts, we return
+		 * pre-calculated hash
+		 */
+		if (digestsize == SHA1_DIGEST_SIZE) {
+			memcpy(rctx->digest,
+			       "\xda\x39\xa3\xee\x5e\x6b\x4b\x0d\x32\x55\xbf\xef\x95\x60\x18\x90\xaf\xd8\x07\x09",
+			       SHA1_DIGEST_SIZE);
+		} else if (digestsize == SHA256_DIGEST_SIZE) {
+			memcpy(rctx->digest,
+			       "\xe3\xb0\xc4\x42\x98\xfc\x1c\x14\x9a\xfb\xf4\xc8\x99\x6f\xb9\x24\x27\xae\x41\xe4\x64\x9b\x93\x4c\xa4\x95\x99\x1b\x78\x52\xb8\x55",
+			       SHA256_DIGEST_SIZE);
+		} else {
+			qce->async_req_done(tmpl->qce, -EINVAL);
+			return -EINVAL;
+		}
+		if (req->result)
+		memcpy(req->result, rctx->digest, digestsize);
+		qce->async_req_done(tmpl->qce, 0);
+		return 0;
+	}
+
 	rctx->src_nents = sg_nents_for_len(req->src, req->nbytes);
 	if (rctx->src_nents < 0) {
 		dev_err(qce->dev, "Invalid numbers of src SG.\n");
@@ -322,9 +346,6 @@ static int qce_ahash_final(struct ahash_request *req)
 	struct qce_alg_template *tmpl = to_ahash_tmpl(req->base.tfm);
 	struct qce_device *qce = tmpl->qce;
 
-	if (!rctx->buflen)
-		return 0;
-
 	/* If hash is already been finalized, don't do anything */
 	if (rctx->finalized)
 		return 0;
-- 
2.9.3
