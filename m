From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 10/27] crypto: omap-aes: Add support for multiple cores
Date: Wed, 22 Jun 2016 16:23:43 +0300
Message-ID: <1466601840-18486-11-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50593 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbcFVNZW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:22 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lokesh Vutla <lokeshvutla@ti.com>

Some SoCs like omap4/omap5/dra7 contain multiple AES crypto accelerator
cores. Adapt the driver to support this. The driver picks the last used
device from a list of AES devices.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
[t-kristo@ti.com: forward ported to 4.7 kernel]
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-aes.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index cf53d3f..f710602 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -319,20 +319,12 @@ static void omap_aes_dma_stop(struct omap_aes_dev *dd)
 
 static struct omap_aes_dev *omap_aes_find_dev(struct omap_aes_ctx *ctx)
 {
-	struct omap_aes_dev *dd = NULL, *tmp;
+	struct omap_aes_dev *dd;
 
 	spin_lock_bh(&list_lock);
-	if (!ctx->dd) {
-		list_for_each_entry(tmp, &dev_list, list) {
-			/* FIXME: take fist available aes core */
-			dd = tmp;
-			break;
-		}
-		ctx->dd = dd;
-	} else {
-		/* already found before */
-		dd = ctx->dd;
-	}
+	dd = list_first_entry(&dev_list, struct omap_aes_dev, list);
+	list_move_tail(&dd->list, &dev_list);
+	ctx->dd = dd;
 	spin_unlock_bh(&list_lock);
 
 	return dd;
@@ -600,7 +592,7 @@ static int omap_aes_prepare_req(struct crypto_engine *engine,
 {
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
-	struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
+	struct omap_aes_dev *dd = ctx->dd;
 	struct omap_aes_reqctx *rctx;
 	int len;
 
@@ -644,7 +636,7 @@ static int omap_aes_crypt_req(struct crypto_engine *engine,
 {
 	struct omap_aes_ctx *ctx = crypto_ablkcipher_ctx(
 			crypto_ablkcipher_reqtfm(req));
-	struct omap_aes_dev *dd = omap_aes_find_dev(ctx);
+	struct omap_aes_dev *dd = ctx->dd;
 
 	if (!dd)
 		return -ENODEV;
-- 
1.9.1
