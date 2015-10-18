From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 03/18] crypto: marvell: add flag to determine algorithm
 endianness
Date: Sun, 18 Oct 2015 17:23:40 +0100
Message-ID: <E1ZnqkG-0005WH-TE@rmk-PC.arm.linux.org.uk>
References: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45202 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbbJRQXv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:23:51 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Rather than determining whether we're using a MD5 hash by looking at
the digest size, switch to a cleaner solution using a per-request flag
initialised by the method type.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/cesa.h |  1 +
 drivers/crypto/marvell/hash.c | 17 +++++++++--------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index e19302c9dec9..5d5b66ea2ceb 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -612,6 +612,7 @@ struct mv_cesa_ahash_req {
 	u64 len;
 	int src_nents;
 	bool last_req;
+	bool algo_le;
 	u32 state[8];
 };
 
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index f59faabcd34f..aa12274608ab 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -351,7 +351,7 @@ static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
 		 * Hardware's MD5 digest is in little endian format, but
 		 * SHA in big endian format
 		 */
-		if (digsize == MD5_DIGEST_SIZE) {
+		if (creq->algo_le) {
 			__le32 *result = (void *)ahashreq->result;
 
 			for (i = 0; i < digsize / 4; i++)
@@ -407,7 +407,7 @@ static const struct mv_cesa_req_ops mv_cesa_ahash_req_ops = {
 };
 
 static int mv_cesa_ahash_init(struct ahash_request *req,
-			      struct mv_cesa_op_ctx *tmpl)
+			      struct mv_cesa_op_ctx *tmpl, bool algo_le)
 {
 	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
 
@@ -421,6 +421,7 @@ static int mv_cesa_ahash_init(struct ahash_request *req,
 	mv_cesa_set_mac_op_frag_len(tmpl, 0);
 	creq->op_tmpl = *tmpl;
 	creq->len = 0;
+	creq->algo_le = algo_le;
 
 	return 0;
 }
@@ -861,7 +862,7 @@ static int mv_cesa_md5_init(struct ahash_request *req)
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
 
-	mv_cesa_ahash_init(req, &tmpl);
+	mv_cesa_ahash_init(req, &tmpl, true);
 
 	return 0;
 }
@@ -924,7 +925,7 @@ static int mv_cesa_sha1_init(struct ahash_request *req)
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA1);
 
-	mv_cesa_ahash_init(req, &tmpl);
+	mv_cesa_ahash_init(req, &tmpl, false);
 
 	return 0;
 }
@@ -987,7 +988,7 @@ static int mv_cesa_sha256_init(struct ahash_request *req)
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA256);
 
-	mv_cesa_ahash_init(req, &tmpl);
+	mv_cesa_ahash_init(req, &tmpl, false);
 
 	return 0;
 }
@@ -1218,7 +1219,7 @@ static int mv_cesa_ahmac_md5_init(struct ahash_request *req)
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_MD5);
 	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
 
-	mv_cesa_ahash_init(req, &tmpl);
+	mv_cesa_ahash_init(req, &tmpl, true);
 
 	return 0;
 }
@@ -1288,7 +1289,7 @@ static int mv_cesa_ahmac_sha1_init(struct ahash_request *req)
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA1);
 	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
 
-	mv_cesa_ahash_init(req, &tmpl);
+	mv_cesa_ahash_init(req, &tmpl, false);
 
 	return 0;
 }
@@ -1378,7 +1379,7 @@ static int mv_cesa_ahmac_sha256_init(struct ahash_request *req)
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA256);
 	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
 
-	mv_cesa_ahash_init(req, &tmpl);
+	mv_cesa_ahash_init(req, &tmpl, false);
 
 	return 0;
 }
-- 
2.1.0
