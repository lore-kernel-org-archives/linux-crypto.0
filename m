From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCH 04/13] crypto: omap-des - use runtime_pm autosuspend for clock handling
Date: Wed, 24 May 2017 10:35:25 +0300
Message-ID: <1495611334-15039-5-git-send-email-t-kristo@ti.com>
References: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-omap@vger.kernel.org>
To: <herbert@gondor.apana.org.au>, <lokeshvutla@ti.com>,
        <davem@davemloft.net>, <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lelnx193.ext.ti.com ([198.47.27.77]:51574 "EHLO
        lelnx193.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966618AbdEXHgF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 May 2017 03:36:05 -0400
In-Reply-To: <1495611334-15039-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Convert the driver to use autosuspend for runtime_pm. This boosts the
performance, and optimizes the power consumption for the driver. By
default, the timeout value for autosuspend is set to one second.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-des.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 0d68f77..3783dcf 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -78,6 +78,8 @@
 #define FLAGS_INIT		BIT(4)
 #define FLAGS_BUSY		BIT(6)
 
+#define DEFAULT_AUTOSUSPEND_DELAY	1000
+
 struct omap_des_ctx {
 	struct omap_des_dev *dd;
 
@@ -506,8 +508,10 @@ static void omap_des_finish_req(struct omap_des_dev *dd, int err)
 
 	pr_debug("err: %d\n", err);
 
-	pm_runtime_put(dd->dev);
 	crypto_finalize_cipher_request(dd->engine, req, err);
+
+	pm_runtime_mark_last_busy(dd->dev);
+	pm_runtime_put_autosuspend(dd->dev);
 }
 
 static int omap_des_crypt_dma_stop(struct omap_des_dev *dd)
@@ -1044,8 +1048,10 @@ static int omap_des_probe(struct platform_device *pdev)
 	}
 	dd->phys_base = res->start;
 
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, DEFAULT_AUTOSUSPEND_DELAY);
+
 	pm_runtime_enable(dev);
-	pm_runtime_irq_safe(dev);
 	err = pm_runtime_get_sync(dev);
 	if (err < 0) {
 		pm_runtime_put_noidle(dev);
-- 
1.9.1
