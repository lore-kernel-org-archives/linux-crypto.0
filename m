From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 08/14] crypto: marvell/CESA: add MD5 support
Date: Thu, 11 Jun 2015 19:36:34 +0200
Message-ID: <1434044206-10459-16-git-send-email-boris.brezillon@free-electrons.com>
References: <1434044206-10459-1-git-send-email-boris.brezillon@free-electrons.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
	Arnaud Ebalard <arno@natisbad.org>,
	Tawfik Bayouk <tawfik@marvell.com>,
	Lior Amsalem <alior@marvell.com>,
	Nadav Haklai <nadavh@marvell.com>,
	Eran Ben-Avi <benavi@marvell.com>,
	Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
	Gregory CLEMENT <gregory.clement@free-electrons.com>,
	Jason Cooper <jason@lakedaemon.net>,
	Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	"Imre Kaloz" <kaloz@openwrt.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from down.free-electrons.com ([37.187.137.238]:58940 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932734AbbFKRhM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Jun 2015 13:37:12 -0400
In-Reply-To: <1434044206-10459-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Arnaud Ebalard <arno@natisbad.org>

Add support for MD5 operations.

Signed-off-by: Arnaud Ebalard <arno@natisbad.org>
Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 drivers/crypto/marvell/cesa.c |   2 +
 drivers/crypto/marvell/cesa.h |   2 +
 drivers/crypto/marvell/hash.c | 170 +++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 172 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/marvell/cesa.c b/drivers/crypto/marvell/cesa.c
index b9f4d26..b9da0df 100644
--- a/drivers/crypto/marvell/cesa.c
+++ b/drivers/crypto/marvell/cesa.c
@@ -174,7 +174,9 @@ static struct crypto_alg *armada_370_cipher_algs[] = {
 };
 
 static struct ahash_alg *armada_370_ahash_algs[] = {
+	&mv_md5_alg,
 	&mv_sha1_alg,
+	&mv_ahmac_md5_alg,
 	&mv_ahmac_sha1_alg,
 };
 
diff --git a/drivers/crypto/marvell/cesa.h b/drivers/crypto/marvell/cesa.h
index d886280..23c4603 100644
--- a/drivers/crypto/marvell/cesa.h
+++ b/drivers/crypto/marvell/cesa.h
@@ -787,7 +787,9 @@ int mv_cesa_dma_add_op_transfers(struct mv_cesa_tdma_chain *chain,
 
 /* Algorithm definitions */
 
+extern struct ahash_alg mv_md5_alg;
 extern struct ahash_alg mv_sha1_alg;
+extern struct ahash_alg mv_ahmac_md5_alg;
 extern struct ahash_alg mv_ahmac_sha1_alg;
 
 extern struct crypto_alg mv_cesa_ecb_des_alg;
diff --git a/drivers/crypto/marvell/hash.c b/drivers/crypto/marvell/hash.c
index f9c6d47..63fa493 100644
--- a/drivers/crypto/marvell/hash.c
+++ b/drivers/crypto/marvell/hash.c
@@ -12,6 +12,7 @@
  * by the Free Software Foundation.
  */
 
+#include <crypto/md5.h>
 #include <crypto/sha.h>
 
 #include "cesa.h"
@@ -346,8 +347,16 @@ static int mv_cesa_ahash_process(struct crypto_async_request *req, u32 status)
 				   ahashreq->nbytes - creq->cache_ptr);
 
 	if (creq->last_req) {
-		for (i = 0; i < digsize / 4; i++)
-			creq->state[i] = cpu_to_be32(creq->state[i]);
+		for (i = 0; i < digsize / 4; i++) {
+			/*
+			 * Hardware provides MD5 digest in a different
+			 * endianness than SHA-1 and SHA-256 ones.
+			 */
+			if (digsize == MD5_DIGEST_SIZE)
+				creq->state[i] = cpu_to_le32(creq->state[i]);
+			else
+				creq->state[i] = cpu_to_be32(creq->state[i]);
+		}
 
 		memcpy(ahashreq->result, creq->state, digsize);
 	}
@@ -786,6 +795,95 @@ static int mv_cesa_ahash_finup(struct ahash_request *req)
 	return ret;
 }
 
+static int mv_cesa_md5_init(struct ahash_request *req)
+{
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_MD5);
+
+	mv_cesa_ahash_init(req, &tmpl);
+
+	return 0;
+}
+
+static int mv_cesa_md5_export(struct ahash_request *req, void *out)
+{
+	struct md5_state *out_state = out;
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int digsize = crypto_ahash_digestsize(ahash);
+
+	out_state->byte_count = creq->len;
+	memcpy(out_state->hash, creq->state, digsize);
+	memset(out_state->block, 0, sizeof(out_state->block));
+	if (creq->cache)
+		memcpy(out_state->block, creq->cache, creq->cache_ptr);
+
+	return 0;
+}
+
+static int mv_cesa_md5_import(struct ahash_request *req, const void *in)
+{
+	const struct md5_state *in_state = in;
+	struct crypto_ahash *ahash = crypto_ahash_reqtfm(req);
+	struct mv_cesa_ahash_req *creq = ahash_request_ctx(req);
+	unsigned int digsize = crypto_ahash_digestsize(ahash);
+	unsigned int cache_ptr;
+	int ret;
+
+	creq->len = in_state->byte_count;
+	memcpy(creq->state, in_state->hash, digsize);
+	creq->cache_ptr = 0;
+
+	cache_ptr = creq->len % sizeof(in_state->block);
+	if (!cache_ptr)
+		return 0;
+
+	ret = mv_cesa_ahash_alloc_cache(req);
+	if (ret)
+		return ret;
+
+	memcpy(creq->cache, in_state->block, cache_ptr);
+	creq->cache_ptr = cache_ptr;
+
+	return 0;
+}
+
+static int mv_cesa_md5_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_md5_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_md5_alg = {
+	.init = mv_cesa_md5_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_md5_digest,
+	.export = mv_cesa_md5_export,
+	.import = mv_cesa_md5_import,
+	.halg = {
+		.digestsize = MD5_DIGEST_SIZE,
+		.base = {
+			.cra_name = "md5",
+			.cra_driver_name = "mv-md5",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hash_ctx),
+			.cra_init = mv_cesa_ahash_cra_init,
+			.cra_module = THIS_MODULE,
+		 }
+	}
+};
+
 static int mv_cesa_sha1_init(struct ahash_request *req)
 {
 	struct mv_cesa_op_ctx tmpl;
@@ -1041,6 +1139,74 @@ static int mv_cesa_ahmac_cra_init(struct crypto_tfm *tfm)
 	return 0;
 }
 
+static int mv_cesa_ahmac_md5_init(struct ahash_request *req)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
+	struct mv_cesa_op_ctx tmpl;
+
+	mv_cesa_set_op_cfg(&tmpl, CESA_SA_DESC_CFG_MACM_HMAC_MD5);
+	memcpy(tmpl.ctx.hash.iv, ctx->iv, sizeof(ctx->iv));
+
+	mv_cesa_ahash_init(req, &tmpl);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_md5_setkey(struct crypto_ahash *tfm, const u8 *key,
+				    unsigned int keylen)
+{
+	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(crypto_ahash_tfm(tfm));
+	struct md5_state istate, ostate;
+	int ret, i;
+
+	ret = mv_cesa_ahmac_setkey("mv-md5", key, keylen, &istate, &ostate);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < ARRAY_SIZE(istate.hash); i++)
+		ctx->iv[i] = be32_to_cpu(istate.hash[i]);
+
+	for (i = 0; i < ARRAY_SIZE(ostate.hash); i++)
+		ctx->iv[i + 8] = be32_to_cpu(ostate.hash[i]);
+
+	return 0;
+}
+
+static int mv_cesa_ahmac_md5_digest(struct ahash_request *req)
+{
+	int ret;
+
+	ret = mv_cesa_ahmac_md5_init(req);
+	if (ret)
+		return ret;
+
+	return mv_cesa_ahash_finup(req);
+}
+
+struct ahash_alg mv_ahmac_md5_alg = {
+	.init = mv_cesa_ahmac_md5_init,
+	.update = mv_cesa_ahash_update,
+	.final = mv_cesa_ahash_final,
+	.finup = mv_cesa_ahash_finup,
+	.digest = mv_cesa_ahmac_md5_digest,
+	.setkey = mv_cesa_ahmac_md5_setkey,
+	.halg = {
+		.digestsize = MD5_DIGEST_SIZE,
+		.statesize = sizeof(struct md5_state),
+		.base = {
+			.cra_name = "hmac(md5)",
+			.cra_driver_name = "mv-hmac-md5",
+			.cra_priority = 300,
+			.cra_flags = CRYPTO_ALG_ASYNC |
+				     CRYPTO_ALG_KERN_DRIVER_ONLY,
+			.cra_blocksize = MD5_HMAC_BLOCK_SIZE,
+			.cra_ctxsize = sizeof(struct mv_cesa_hmac_ctx),
+			.cra_init = mv_cesa_ahmac_cra_init,
+			.cra_module = THIS_MODULE,
+		 }
+	}
+};
+
 static int mv_cesa_ahmac_sha1_init(struct ahash_request *req)
 {
 	struct mv_cesa_hmac_ctx *ctx = crypto_tfm_ctx(req->base.tfm);
-- 
1.9.1
