From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 09/27] crypto: omap-aes - Fix enabling clocks
Date: Wed, 22 Jun 2016 16:23:42 +0300
Message-ID: <1466601840-18486-10-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:41138 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300AbcFVNZV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:25:21 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Lokesh Vutla <lokeshvutla@ti.com>

Enable clocks for all cores before starting session.
Driver has to pic the aes core dynamically based on the queue length.

Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
---
 drivers/crypto/omap-aes.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 8178632..cf53d3f 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -760,18 +760,13 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
 	struct omap_aes_dev *dd = NULL;
 	int err;
 
-	/* Find AES device, currently picks the first device */
-	spin_lock_bh(&list_lock);
 	list_for_each_entry(dd, &dev_list, list) {
-		break;
-	}
-	spin_unlock_bh(&list_lock);
-
-	err = pm_runtime_get_sync(dd->dev);
-	if (err < 0) {
-		dev_err(dd->dev, "%s: failed to get_sync(%d)\n",
-			__func__, err);
-		return err;
+		err = pm_runtime_get_sync(dd->dev);
+		if (err < 0) {
+			dev_err(dd->dev, "%s: failed to get_sync(%d)\n",
+				__func__, err);
+			return err;
+		}
 	}
 
 	tfm->crt_ablkcipher.reqsize = sizeof(struct omap_aes_reqctx);
@@ -783,14 +778,10 @@ static void omap_aes_cra_exit(struct crypto_tfm *tfm)
 {
 	struct omap_aes_dev *dd = NULL;
 
-	/* Find AES device, currently picks the first device */
-	spin_lock_bh(&list_lock);
 	list_for_each_entry(dd, &dev_list, list) {
-		break;
+		pm_runtime_put_sync(dd->dev);
 	}
-	spin_unlock_bh(&list_lock);
 
-	pm_runtime_put_sync(dd->dev);
 }
 
 /* ********************** ALGS ************************************ */
-- 
1.9.1
