From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv3 07/11] crypto: omap-aes: use runtime_pm autosuspend for clock handling
Date: Thu, 4 Aug 2016 13:28:42 +0300
Message-ID: <1470306526-27219-8-git-send-email-t-kristo@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
	<davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <linux-omap@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50515 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbcHDKaV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 06:30:21 -0400
In-Reply-To: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Calling runtime PM API at the cra_init/exit is bad for power management
purposes, as the lifetime for a CRA can be very long. Instead, use
pm_runtime autosuspend approach for handling the device clocks. Clocks
are enabled when they are actually required, and autosuspend disables
these if they have not been used for a sufficiently long time period.
By default, the timeout value is 1 second.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-aes.c | 43 ++++++++++++++++---------------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 4ab53a6..f443042 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -85,6 +85,8 @@
 #define AES_REG_IRQ_DATA_OUT           BIT(2)
 #define DEFAULT_TIMEOUT		(5*HZ)
 
+#define DEFAULT_AUTOSUSPEND_DELAY	1000
+
 #define FLAGS_MODE_MASK		0x000f
 #define FLAGS_ENCRYPT		BIT(0)
 #define FLAGS_CBC		BIT(1)
@@ -238,11 +240,19 @@ static void omap_aes_write_n(struct omap_aes_dev *dd, u32 offset,
 
 static int omap_aes_hw_init(struct omap_aes_dev *dd)
 {
+	int err;
+
 	if (!(dd->flags & FLAGS_INIT)) {
 		dd->flags |= FLAGS_INIT;
 		dd->err = 0;
 	}
 
+	err = pm_runtime_get_sync(dd->dev);
+	if (err < 0) {
+		dev_err(dd->dev, "failed to get sync: %d\n", err);
+		return err;
+	}
+
 	return 0;
 }
 
@@ -520,6 +530,9 @@ static void omap_aes_finish_req(struct omap_aes_dev *dd, int err)
 	pr_debug("err: %d\n", err);
 
 	crypto_finalize_request(dd->engine, req, err);
+
+	pm_runtime_mark_last_busy(dd->dev);
+	pm_runtime_put_autosuspend(dd->dev);
 }
 
 static int omap_aes_crypt_dma_stop(struct omap_aes_dev *dd)
@@ -761,23 +774,6 @@ static int omap_aes_ctr_decrypt(struct ablkcipher_request *req)
 
 static int omap_aes_cra_init(struct crypto_tfm *tfm)
 {
-	struct omap_aes_dev *dd = NULL;
-	int err;
-
-	/* Find AES device, currently picks the first device */
-	spin_lock_bh(&list_lock);
-	list_for_each_entry(dd, &dev_list, list) {
-		break;
-	}
-	spin_unlock_bh(&list_lock);
-
-	err = pm_runtime_get_sync(dd->dev);
-	if (err < 0) {
-		dev_err(dd->dev, "%s: failed to get_sync(%d)\n",
-			__func__, err);
-		return err;
-	}
-
 	tfm->crt_ablkcipher.reqsize = sizeof(struct omap_aes_reqctx);
 
 	return 0;
@@ -785,16 +781,6 @@ static int omap_aes_cra_init(struct crypto_tfm *tfm)
 
 static void omap_aes_cra_exit(struct crypto_tfm *tfm)
 {
-	struct omap_aes_dev *dd = NULL;
-
-	/* Find AES device, currently picks the first device */
-	spin_lock_bh(&list_lock);
-	list_for_each_entry(dd, &dev_list, list) {
-		break;
-	}
-	spin_unlock_bh(&list_lock);
-
-	pm_runtime_put_sync(dd->dev);
 }
 
 /* ********************** ALGS ************************************ */
@@ -1140,6 +1126,9 @@ static int omap_aes_probe(struct platform_device *pdev)
 	}
 	dd->phys_base = res.start;
 
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, DEFAULT_AUTOSUSPEND_DELAY);
+
 	pm_runtime_enable(dev);
 	err = pm_runtime_get_sync(dev);
 	if (err < 0) {
-- 
1.9.1
