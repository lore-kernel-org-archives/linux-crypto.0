From: Rui Wang <rui.y.wang@intel.com>
Subject: [PATCH v2 1/4] crypto x86/sha1_mb: Fix load failure
Date: Wed, 27 Jan 2016 17:08:35 +0800
Message-ID: <1453885718-24599-2-git-send-email-rui.y.wang@intel.com>
References: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
Cc: tim.c.chen@linux.intel.com, rui.y.wang@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453885718-24599-1-git-send-email-rui.y.wang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

modprobe sha1_mb fails with the following message:

modprobe: ERROR: could not insert 'sha1_mb': No such device

It is because it needs to set its statesize and implement its
import() and export() interface.

Signed-off-by: Rui Wang <rui.y.wang@intel.com>
---
 arch/x86/crypto/sha-mb/sha1_mb.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/x86/crypto/sha-mb/sha1_mb.c b/arch/x86/crypto/sha-mb/sha1_mb.c
index a841e97..deb6e81 100644
--- a/arch/x86/crypto/sha-mb/sha1_mb.c
+++ b/arch/x86/crypto/sha-mb/sha1_mb.c
@@ -762,6 +762,42 @@ static int sha1_mb_async_digest(struct ahash_request *req)
 	return crypto_ahash_digest(mcryptd_req);
 }
 
+static int sha1_mb_async_export(struct ahash_request *req, void *out)
+{
+	struct ahash_request *mcryptd_req = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
+
+	memcpy(mcryptd_req, req, sizeof(*req));
+	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
+	return crypto_ahash_export(mcryptd_req, out);
+}
+
+static int sha1_mb_async_import(struct ahash_request *req, const void *in)
+{
+	struct ahash_request *mcryptd_req = ahash_request_ctx(req);
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct sha1_mb_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct mcryptd_ahash *mcryptd_tfm = ctx->mcryptd_tfm;
+	struct crypto_shash *child = mcryptd_ahash_child(mcryptd_tfm);
+	struct mcryptd_hash_request_ctx *rctx;
+	struct shash_desc *desc;
+	int err;
+
+	memcpy(mcryptd_req, req, sizeof(*req));
+	ahash_request_set_tfm(mcryptd_req, &mcryptd_tfm->base);
+	rctx = ahash_request_ctx(mcryptd_req);
+	desc = &rctx->desc;
+	desc->tfm = child;
+	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
+
+	err = crypto_shash_init(desc);
+	if (err)
+		return err;
+	return crypto_ahash_import(mcryptd_req, in);
+}
+
 static int sha1_mb_async_init_tfm(struct crypto_tfm *tfm)
 {
 	struct mcryptd_ahash *mcryptd_tfm;
@@ -796,8 +832,11 @@ static struct ahash_alg sha1_mb_async_alg = {
 	.final          = sha1_mb_async_final,
 	.finup          = sha1_mb_async_finup,
 	.digest         = sha1_mb_async_digest,
+	.export		= sha1_mb_async_export,
+	.import		= sha1_mb_async_import,
 	.halg = {
 		.digestsize     = SHA1_DIGEST_SIZE,
+		.statesize	= sizeof(struct sha1_hash_ctx),
 		.base = {
 			.cra_name               = "sha1",
 			.cra_driver_name        = "sha1_mb",
-- 
1.8.3.1
