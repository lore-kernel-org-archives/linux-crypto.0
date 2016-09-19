From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 7/8] crypto: omap-sham: add support for export/import
Date: Mon, 19 Sep 2016 18:22:18 +0300
Message-ID: <1474298539-23897-8-git-send-email-t-kristo@ti.com>
References: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:41256 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752043AbcISPXe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2016 11:23:34 -0400
In-Reply-To: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Now that the driver has been converted to use scatterlists for data
handling, add proper implementation for the export/import stubs also.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 412559e..8eefd79 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1418,12 +1418,21 @@ static void omap_sham_cra_exit(struct crypto_tfm *tfm)
 
 static int omap_sham_export(struct ahash_request *req, void *out)
 {
-	return -ENOTSUPP;
+	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
+
+	memcpy(out, rctx, sizeof(*rctx) + rctx->bufcnt);
+
+	return 0;
 }
 
 static int omap_sham_import(struct ahash_request *req, const void *in)
 {
-	return -ENOTSUPP;
+	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
+	const struct omap_sham_reqctx *ctx_in = in;
+
+	memcpy(rctx, in, sizeof(*rctx) + ctx_in->bufcnt);
+
+	return 0;
 }
 
 static struct ahash_alg algs_sha1_md5[] = {
@@ -2083,7 +2092,8 @@ static int omap_sham_probe(struct platform_device *pdev)
 			alg = &dd->pdata->algs_info[i].algs_list[j];
 			alg->export = omap_sham_export;
 			alg->import = omap_sham_import;
-			alg->halg.statesize = sizeof(struct omap_sham_reqctx);
+			alg->halg.statesize = sizeof(struct omap_sham_reqctx) +
+					      BUFLEN;
 			err = crypto_register_ahash(alg);
 			if (err)
 				goto err_algs;
-- 
1.9.1
