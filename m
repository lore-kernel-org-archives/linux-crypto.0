From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH v2 5/7] crypto: img-hash - Add support for export and import
Date: Fri, 5 Aug 2016 14:00:18 +0100
Message-ID: <1470402020-10774-6-git-send-email-will.thomas@imgtec.com>
References: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-crypto@vger.kernel.org>,
	James Hartley <james.hartley@imgtec.com>,
	Will Thomas <will.thomas@imgtec.com>
To: <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:12224 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759702AbcHENIP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Aug 2016 09:08:15 -0400
In-Reply-To: <1470402020-10774-1-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: James Hartley <james.hartley@imgtec.com>

Currently the img-hash accelerator does not probe
successfully due to a change in the checks made during
registration with the crypto framework. This is due to
import and export functions not being defined. Correct
this.

Signed-off-by: James Hartley <james.hartley@imgtec.com>
Signed-off-by: Will Thomas <will.thomas@imgtec.com>
---
 drivers/crypto/img-hash.c | 69 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 63 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 2622c01..fd4cd51 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -590,6 +590,32 @@ static int img_hash_finup(struct ahash_request *req)
 	return crypto_ahash_finup(&rctx->fallback_req);
 }
 
+static int img_hash_import(struct ahash_request *req, const void *in)
+{
+	struct img_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct img_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
+	rctx->fallback_req.base.flags = req->base.flags
+		& CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	return crypto_ahash_import(&rctx->fallback_req, in);
+}
+
+static int img_hash_export(struct ahash_request *req, void *out)
+{
+	struct img_hash_request_ctx *rctx = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct img_hash_ctx *ctx = crypto_ahash_ctx(tfm);
+
+	ahash_request_set_tfm(&rctx->fallback_req, ctx->fallback);
+	rctx->fallback_req.base.flags = req->base.flags
+		& CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	return crypto_ahash_export(&rctx->fallback_req, out);
+}
+
 static int img_hash_digest(struct ahash_request *req)
 {
 	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
@@ -646,10 +672,9 @@ static int img_hash_digest(struct ahash_request *req)
 	return err;
 }
 
-static int img_hash_cra_init(struct crypto_tfm *tfm)
+static int img_hash_cra_init(struct crypto_tfm *tfm, const char *alg_name)
 {
 	struct img_hash_ctx *ctx = crypto_tfm_ctx(tfm);
-	const char *alg_name = crypto_tfm_alg_name(tfm);
 	int err = -ENOMEM;
 
 	ctx->fallback = crypto_alloc_ahash(alg_name, 0,
@@ -669,6 +694,26 @@ err:
 	return err;
 }
 
+static int img_hash_cra_md5_init(struct crypto_tfm *tfm)
+{
+	return img_hash_cra_init(tfm, "md5-generic");
+}
+
+static int img_hash_cra_sha1_init(struct crypto_tfm *tfm)
+{
+	return img_hash_cra_init(tfm, "sha1-generic");
+}
+
+static int img_hash_cra_sha224_init(struct crypto_tfm *tfm)
+{
+	return img_hash_cra_init(tfm, "sha224-generic");
+}
+
+static int img_hash_cra_sha256_init(struct crypto_tfm *tfm)
+{
+	return img_hash_cra_init(tfm, "sha256-generic");
+}
+
 static void img_hash_cra_exit(struct crypto_tfm *tfm)
 {
 	struct img_hash_ctx *tctx = crypto_tfm_ctx(tfm);
@@ -714,9 +759,12 @@ static struct ahash_alg img_algs[] = {
 		.update = img_hash_update,
 		.final = img_hash_final,
 		.finup = img_hash_finup,
+		.export = img_hash_export,
+		.import = img_hash_import,
 		.digest = img_hash_digest,
 		.halg = {
 			.digestsize = MD5_DIGEST_SIZE,
+			.statesize = sizeof(struct md5_state),
 			.base = {
 				.cra_name = "md5",
 				.cra_driver_name = "img-md5",
@@ -726,7 +774,7 @@ static struct ahash_alg img_algs[] = {
 				CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct img_hash_ctx),
-				.cra_init = img_hash_cra_init,
+				.cra_init = img_hash_cra_md5_init,
 				.cra_exit = img_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
@@ -737,9 +785,12 @@ static struct ahash_alg img_algs[] = {
 		.update = img_hash_update,
 		.final = img_hash_final,
 		.finup = img_hash_finup,
+		.export = img_hash_export,
+		.import = img_hash_import,
 		.digest = img_hash_digest,
 		.halg = {
 			.digestsize = SHA1_DIGEST_SIZE,
+			.statesize = sizeof(struct sha1_state),
 			.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "img-sha1",
@@ -749,7 +800,7 @@ static struct ahash_alg img_algs[] = {
 				CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct img_hash_ctx),
-				.cra_init = img_hash_cra_init,
+				.cra_init = img_hash_cra_sha1_init,
 				.cra_exit = img_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
@@ -760,9 +811,12 @@ static struct ahash_alg img_algs[] = {
 		.update = img_hash_update,
 		.final = img_hash_final,
 		.finup = img_hash_finup,
+		.export = img_hash_export,
+		.import = img_hash_import,
 		.digest = img_hash_digest,
 		.halg = {
 			.digestsize = SHA224_DIGEST_SIZE,
+			.statesize = sizeof(struct sha256_state),
 			.base = {
 				.cra_name = "sha224",
 				.cra_driver_name = "img-sha224",
@@ -772,7 +826,7 @@ static struct ahash_alg img_algs[] = {
 				CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct img_hash_ctx),
-				.cra_init = img_hash_cra_init,
+				.cra_init = img_hash_cra_sha224_init,
 				.cra_exit = img_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
@@ -783,9 +837,12 @@ static struct ahash_alg img_algs[] = {
 		.update = img_hash_update,
 		.final = img_hash_final,
 		.finup = img_hash_finup,
+		.export = img_hash_export,
+		.import = img_hash_import,
 		.digest = img_hash_digest,
 		.halg = {
 			.digestsize = SHA256_DIGEST_SIZE,
+			.statesize = sizeof(struct sha256_state),
 			.base = {
 				.cra_name = "sha256",
 				.cra_driver_name = "img-sha256",
@@ -795,7 +852,7 @@ static struct ahash_alg img_algs[] = {
 				CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct img_hash_ctx),
-				.cra_init = img_hash_cra_init,
+				.cra_init = img_hash_cra_sha256_init,
 				.cra_exit = img_hash_cra_exit,
 				.cra_module = THIS_MODULE,
 			}
-- 
2.1.4
