From: Will Thomas <will.thomas@imgtec.com>
Subject: [PATCH 5/6] crypto: img-hash - Add support for export and import
Date: Mon, 11 Jul 2016 10:33:35 +0100
Message-ID: <1468229616-3888-6-git-send-email-will.thomas@imgtec.com>
References: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: James Hartley <james.hartley@imgtec.com>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:1812 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758185AbcGKJeQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jul 2016 05:34:16 -0400
Received: from HHMAIL01.hh.imgtec.org (unknown [10.100.10.19])
	by Forcepoint Email with ESMTPS id 0789595BC7ABC
	for <linux-crypto@vger.kernel.org>; Mon, 11 Jul 2016 10:34:10 +0100 (IST)
In-Reply-To: <1468229616-3888-1-git-send-email-will.thomas@imgtec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: James Hartley <james.hartley@imgtec.com>

Currently the img-hash accelerator does not probe
successfully due to a change in the checks made during
registration with the crypto framework. This is due to
import and export functions not being defined. Correct
this.

Signed-off-by: James Hartley <james.hartley@imgtec.com>
Reviewed-by: Will Thomas <will.thomas@imgtec.com>
---
 drivers/crypto/img-hash.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index ed4408a..c2fdc35 100644
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
@@ -714,9 +740,12 @@ static struct ahash_alg img_algs[] = {
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
@@ -737,9 +766,12 @@ static struct ahash_alg img_algs[] = {
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
@@ -760,9 +792,12 @@ static struct ahash_alg img_algs[] = {
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
@@ -783,9 +818,12 @@ static struct ahash_alg img_algs[] = {
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
-- 
2.1.4
