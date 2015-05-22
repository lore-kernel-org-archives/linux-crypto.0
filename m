From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 07/16] crypto: marvell/CESA: add SHA256 support
Date: Fri, 22 May 2015 15:33:53 +0200
Message-ID: <1432301642-11470-8-git-send-email-boris.brezillon@free-electrons.com>
References: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:47254 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757378AbbEVNeP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 May 2015 09:34:15 -0400
In-Reply-To: <1432301642-11470-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Arnaud Ebalard <arno@natisbad.org>

Add support for SHA256 operations.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c |   2 +
 drivers/crypto/marvell/cesa.h |   2 +
 drivers/crypto/marvell/hash.c | 129 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 133 insertions(+)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 092304a..55fa6e8 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -176,8 +176,10 @@ static struct crypto_alg *armada_370_cipher_algs[] = {
 static struct ahash_alg *armada_370_ahash_algs[] = {
 	&mv_md5_alg,
 	&mv_sha1_alg,
+	&mv_sha256_alg,
 	&mv_ahmac_md5_alg,
 	&mv_ahmac_sha1_alg,
+	&mv_ahmac_sha256_alg,
 };
 
 static const struct mv_cesa_caps armada_370_caps = {
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index 23c4603..497746b 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -789,8 +789,10 @@ int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
 
 extern struct ahash_alg mv_md5_alg;
 extern struct ahash_alg mv_sha1_alg;
+extern struct ahash_alg mv_sha256_alg;
 extern struct ahash_alg mv_ahmac_md5_alg;
 extern struct ahash_alg mv_ahmac_sha1_alg;
+extern struct ahash_alg mv_ahmac_sha256_alg;
 
 extern struct crypto_alg mv_cesa_ecb_des_alg;
 extern struct crypto_alg mv_cesa_cbc_des_alg;
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index 644c97d..890607b 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -917,6 +917,67 @@ struct ahash_alg mv_sha1_alg = {
 	}
 };
 
+static int mv_cesa_sha256_init(struct ahash_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_SHA256);
+
+	mv_cesa_ahash_init(req, &tmpl);
+
+	return 0;
+}
+
+static int mv_cesa_sha256_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_sha256_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+static int mv_cesa_sha256_export(struct ahash_request *req, void *out)
+{
+	struct sha256_state *out_state = out;
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int ds = crypto_ahash_digestsize(ahash);
+
+	out_state->count = creq->len;
+	memcpy(out_state->state, creq->state, ds);
+	memset(out_state->buf, 0, sizeof(out_state->buf));
+	if (creq->cache)
+		memcpy(out_state->buf, creq->cache, creq->cache_ptr);
+
+	return 0;
+}
+
+struct ahash_alg mv_sha256_alg = {
+	.init = mv_cesa_sha256_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_sha256_digest,
+	.export = mv_cesa_sha256_export,
+	.halg = {
+		.digestsize = SHA256_DIGEST_SIZE,
+		.base = {
+			.cra_name = "sha256",
+			.cra_driver_name = "mv-sha256",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SHA256_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
+			.cra_init = mv_cesa_ahash_cra_init,
+			.cra_module = THIS_MODULE,
+		 }
+	}
+};
+
 struct mv_cesa_ahash_result {
 	struct completion completion;
 	int error;
@@ -1218,3 +1279,71 @@ struct ahash_alg mv_ahmac_sha1_alg = {
 		 }
 	}
 };
+
+static int mv_cesa_ahmac_sha256_setkey(struct crypto_ahash *tfm, const u8 *key,
+				       unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct sha256_state istate, ostate;
+	int ret, i;
+
+	ret = mv_cesa_ahmac_setkey("mv-sha256", key, keylen, &istate, &ostate);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(istate.state); i++)
+		ctx->iv[i] = be32_to_cpu(istate.state[i]);
+
+	for (i = 0; i < ARRAY_SIZE(ostate.state); i++)
+		ctx->iv[i + 8] = be32_to_cpu(ostate.state[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha256_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_SHA256);
+	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
+
+	mv_cesa_ahash_init(req, &tmpl);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_sha256_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_ahmac_sha256_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_sha256_alg = {
+	.init = mv_cesa_ahmac_sha256_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_ahmac_sha256_digest,
+	.setkey = mv_cesa_ahmac_sha256_setkey,
+	.halg = {
+		.digestsize = SHA256_DIGEST_SIZE,
+		.statesize = sizeof(struct sha256_state),
+		.base = {
+			.cra_name = "hmac(sha256)",
+			.cra_driver_name = "mv-hmac-sha256",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = SHA256_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_module = THIS_MODULE,
+		 }
+	}
+};
-- 
1.9.1
