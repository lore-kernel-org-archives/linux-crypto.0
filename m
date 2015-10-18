From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 05/18] crypto: marvell: ensure template operation is
 initialised
Date: Sun, 18 Oct 2015 17:23:51 +0100
Message-ID: <E1ZnqkR-0005WT-5W@rmk-PC.arm.linux.org.uk>
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
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45216 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbbJRQYC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:24:02 -0400
In-Reply-To: <20151018161649.GA6651@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Ensure that the template operation is fully initialised, otherwise we
end up loading data from the kernel stack into the engines, which can
upset the hash results.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/marvell/hash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index dc2c65b52d7a..82d9e3d09331 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -864,7 +864,7 @@ static int mv_cesa_ahash_import(struct ahash_request *req, const void *hash,
 
 static int mv_cesa_md5_init(struct ahash_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
 
@@ -927,7 +927,7 @@ struct ahash_alg mv_md5_alg = {
 
 static int mv_cesa_sha1_init(struct ahash_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA1);
 
@@ -990,7 +990,7 @@ struct ahash_alg mv_sha1_alg = {
 
 static int mv_cesa_sha256_init(struct ahash_request *req)
 {
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA256);
 
@@ -1220,7 +1220,7 @@ static int mv_cesa_ahmac_cra_init(struct crypto_tfm *tfm)
 static int mv_cesa_ahmac_md5_init(struct ahash_request *req)
 {
 	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_MD5);
 	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
@@ -1290,7 +1290,7 @@ struct ahash_alg mv_ahmac_md5_alg = {
 static int mv_cesa_ahmac_sha1_init(struct ahash_request *req)
 {
 	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA1);
 	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
@@ -1380,7 +1380,7 @@ static int mv_cesa_ahmac_sha256_setkey(struct crypto_ahash *tfm, const u8 *key,
 static int mv_cesa_ahmac_sha256_init(struct ahash_request *req)
 {
 	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-	struct mv_cesa_op_ctx tmpl;
+	struct mv_cesa_op_ctx tmpl = { };
 
 	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA256);
 	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
-- 
2.1.0
