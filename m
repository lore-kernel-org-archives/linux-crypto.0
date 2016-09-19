From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 1/8] crypto: omap-sham: add context export/import stubs
Date: Mon, 19 Sep 2016 18:22:12 +0300
Message-ID: <1474298539-23897-2-git-send-email-t-kristo@ti.com>
References: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:51595 "EHLO bear.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751257AbcISPXL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Sep 2016 11:23:11 -0400
In-Reply-To: <1474298539-23897-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Initially these just return -ENOTSUPP to indicate that they don't
really do anything yet. Some sort of implementation is required
for the driver to at least probe.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index cf9f617c..74653c9 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1340,6 +1340,16 @@ static void omap_sham_cra_exit(struct crypto_tfm *tfm)
 	}
 }
 
+static int omap_sham_export(struct ahash_request *req, void *out)
+{
+	return -ENOTSUPP;
+}
+
+static int omap_sham_import(struct ahash_request *req, const void *in)
+{
+	return -ENOTSUPP;
+}
+
 static struct ahash_alg algs_sha1_md5[] = {
 {
 	.init		= omap_sham_init,
@@ -1998,8 +2008,13 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 	for (i = 0; i < dd->pdata->algs_info_size; i++) {
 		for (j = 0; j < dd->pdata->algs_info[i].size; j++) {
-			err = crypto_register_ahash(
-					&dd->pdata->algs_info[i].algs_list[j]);
+			struct ahash_alg *alg;
+
+			alg = &dd->pdata->algs_info[i].algs_list[j];
+			alg->export = omap_sham_export;
+			alg->import = omap_sham_import;
+			alg->halg.statesize = sizeof(struct omap_sham_reqctx);
+			err = crypto_register_ahash(alg);
 			if (err)
 				goto err_algs;
 
-- 
1.9.1
