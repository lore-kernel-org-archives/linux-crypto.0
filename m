From: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Subject: [PATCH v5 09/14] crypto: marvell/CESA: add SHA256 support
Date: Tue, 16 Jun 2015 11:59:03 +0200
Message-ID: <1434448748-10828-10-git-send-email-boris.brezillon@free-electrons.com>
References: <1434448748-10828-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>,
	Tawfik Bayouk <tawfik-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Lior Amsalem <alior-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Nadav Haklai <nadavh-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Eran Ben-Avi <benavi-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>,
	Thomas Petazzoni <thomas.petazzoni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Gregory CLEMENT <gregory.clement-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Jason Cooper <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>,
	Sebastian Hesselbarth <sebastian.hesselbarth-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Andrew Lunn <andrew-g2DYL2Zd6BY@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>,
	Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>,
	Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>,
	"Imre Kaloz" <kaloz-p3rKhJxN3npAfugRpC6u6w@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434448748-10828-1-git-send-email-boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

From: Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>

Add support for SHA256 operations.

Signed-off-by: Arnaud Ebalard <arno-LkuqDEemtHBg9hUCZPvPmw@public.gmane.org>
Signed-off-by: Boris Brezillon <boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>
---
 drivers/crypto/marvell/cesa.c |   2 +
 drivers/crypto/marvell/cesa.h |   2 +
 drivers/crypto/marvell/hash.c | 159 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 163 insertions(+)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index 047c1c0..9c43cd7e 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -180,8 +180,10 @@ static struct crypto_alg *armada_370_cipher_algs[] = {
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
index 2a7e21a..a328938 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -776,8 +776,10 @@ int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
 
 extern struct ahash_alg mv_md5_alg;
 extern struct ahash_alg mv_sha1_alg;
+extern struct ahash_alg mv_sha256_alg;
 extern struct ahash_alg mv_ahmac_md5_alg;
 extern struct ahash_alg mv_ahmac_sha1_alg;
+extern struct ahash_alg mv_ahmac_sha256_alg;
 
 extern struct crypto_alg mv_cesa_ecb_des_alg;
 extern struct crypto_alg mv_cesa_cbc_des_alg;
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index d8555c5..73d3f6f 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -975,6 +975,95 @@ struct ahash_alg mv_sha1_alg = {
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
+static int mv_cesa_sha256_import(struct ahash_request *req, const void *in)
+{
+	const struct sha256_state *in_state = in;
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int digsize = crypto_ahash_digestsize(ahash);
+	unsigned int cache_ptr;
+	int ret;
+
+	creq->len = in_state->count;
+	memcpy(creq->state, in_state->state, digsize);
+	creq->cache_ptr = 0;
+
+	cache_ptr = creq->len % SHA256_BLOCK_SIZE;
+	if (!cache_ptr)
+		return 0;
+
+	ret = mv_cesa_ahash_alloc_cache(req);
+	if (ret)
+		return ret;
+
+	memcpy(creq->cache, in_state->buf, cache_ptr);
+	creq->cache_ptr = cache_ptr;
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
+	.import = mv_cesa_sha256_import,
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
@@ -1280,3 +1369,73 @@ struct ahash_alg mv_ahmac_sha1_alg = {
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
+	.export = mv_cesa_sha256_export,
+	.import = mv_cesa_sha256_import,
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

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
