From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 07/27] crypto: omap-sham: implement context export/import APIs
Date: Wed, 22 Jun 2016 16:23:40 +0300
Message-ID: <1466601840-18486-8-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:36745 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbcFVNZL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:11 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Context export/import are now required for ahash algorithms due to
required support in algif_hash. Implement these for OMAP SHA driver,
saving and restoring the internal state of the driver.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 40 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 38 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 84a0027..683f825 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1325,6 +1325,35 @@ static void omap_sham_cra_exit(struct crypto_tfm *tfm)
 	}
 }
 
+static int omap_sham_export(struct ahash_request *req, void *out)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
+	struct omap_sham_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct omap_sham_hmac_ctx *bctx = ctx->base;
+
+	memcpy(out, rctx, sizeof(*rctx) + BUFLEN);
+	memcpy(out + sizeof(*rctx) + BUFLEN, ctx, sizeof(*ctx));
+	memcpy(out + sizeof(*rctx) + BUFLEN + sizeof(*ctx), bctx,
+	       sizeof(*bctx));
+
+	return 0;
+}
+
+static int omap_sham_import(struct ahash_request *req, const void *in)
+{
+	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
+	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
+	struct omap_sham_ctx *ctx = crypto_ahash_ctx(tfm);
+	struct omap_sham_hmac_ctx *bctx = ctx->base;
+
+	memcpy(rctx, in, sizeof(*rctx) + BUFLEN);
+	memcpy(ctx, in + sizeof(*rctx) + BUFLEN, sizeof(*ctx));
+	memcpy(bctx, in + sizeof(*rctx) + BUFLEN + sizeof(*ctx), sizeof(*bctx));
+
+	return 0;
+}
+
 static struct ahash_alg algs_sha1_md5[] = {
 {
 	.init		= omap_sham_init,
@@ -1979,8 +2008,15 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 	for (i = 0; i < dd->pdata->algs_info_size; i++) {
 		for (j = 0; j < dd->pdata->algs_info[i].size; j++) {
-			err = crypto_register_ahash(
-					&dd->pdata->algs_info[i].algs_list[j]);
+			struct ahash_alg *alg;
+
+			alg = &dd->pdata->algs_info[i].algs_list[j];
+			alg->export = omap_sham_export;
+			alg->import = omap_sham_import;
+			alg->halg.statesize = sizeof(struct omap_sham_reqctx) +
+				sizeof(struct omap_sham_ctx) +
+				sizeof(struct omap_sham_hmac_ctx) + BUFLEN;
+			err = crypto_register_ahash(alg);
 			if (err)
 				goto err_algs;
 
-- 
1.9.1
