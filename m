From: Iaroslav Gridin <voker57@gmail.com>
Subject: [PATCH 2/4] crypto: qce: Avoid repeat hash finalization
Date: Tue, 30 Aug 2016 18:53:51 +0300
Message-ID: <20160830155353.19500-3-voker57@gmail.com>
References: <20160830155353.19500-1-voker57@gmail.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, andy.gross@linaro.org,
        david.brown@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-soc@vger.kernel.org, Voker57 <voker57@gmail.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <20160830155353.19500-1-voker57@gmail.com>
Sender: linux-arm-msm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Voker57 <voker57@gmail.com>

Calling QCE finalization when hash have already been finalized causes
a lockup. Avoid it by introducing finalized flag.
Signed-off-by: Iaroslav Gridin <voker57@gmail.com>
---
 drivers/crypto/qce/sha.c | 6 ++++++
 drivers/crypto/qce/sha.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index a124bb9..a068d39 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -139,6 +139,7 @@ static int qce_ahash_init(struct ahash_request *req)
 	rctx->first_blk = true;
 	rctx->last_blk = false;
 	rctx->flags = tmpl->alg_flags;
+	rctx->finalized = false;
 	memcpy(rctx->digest, std_iv, sizeof(rctx->digest));
 
 	return 0;
@@ -314,7 +315,12 @@ static int qce_ahash_final(struct ahash_request *req)
 	if (!rctx->buflen)
 		return 0;
 
+	/* If hash is already been finalized, don't do anything */
+	if (rctx->finalized)
+		return 0;
+
 	rctx->last_blk = true;
+	rctx->finalized = true;
 
 	rctx->src_orig = req->src;
 	rctx->nbytes_orig = req->nbytes;
diff --git a/drivers/crypto/qce/sha.h b/drivers/crypto/qce/sha.h
index 236bb5e9..b24568f 100644
--- a/drivers/crypto/qce/sha.h
+++ b/drivers/crypto/qce/sha.h
@@ -59,6 +59,7 @@ struct qce_sha_reqctx {
 	u64 count;
 	bool first_blk;
 	bool last_blk;
+	bool finalized;
 	struct scatterlist sg[2];
 	u8 *authkey;
 	unsigned int authklen;
-- 
2.9.3
