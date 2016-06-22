From: Tero Kristo <t-kristo@ti.com>
Subject: [PATCHv2 01/27] crypto: omap-sham: use runtime_pm autosuspend for clock handling
Date: Wed, 22 Jun 2016 16:23:34 +0300
Message-ID: <1466601840-18486-2-git-send-email-t-kristo@ti.com>
References: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <linux-arm-kernel@lists.infradead.org>
To: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<tony@atomide.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <lokeshvutla@ti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:57892 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959AbcFVNY4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jun 2016 09:24:56 -0400
In-Reply-To: <1466601840-18486-1-git-send-email-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Calling runtime PM API for every block causes serious performance hit to
crypto operations that are done on a long buffer. As crypto is performed
on a page boundary, encrypting large buffers can cause a series of crypto
operations divided by page. The runtime PM API is also called those many
times.

Convert the driver to use runtime_pm autosuspend instead, with a default
timeout value of 1 second. This results in upto ~50% speedup.

Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 drivers/crypto/omap-sham.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 6eefaa2..8831613 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -100,6 +100,8 @@
 
 #define DEFAULT_TIMEOUT_INTERVAL	HZ
 
+#define DEFAULT_AUTOSUSPEND_DELAY	1000
+
 /* mostly device flags */
 #define FLAGS_BUSY		0
 #define FLAGS_FINAL		1
@@ -999,7 +1001,8 @@ static void omap_sham_finish_req(struct ahash_request *req, int err)
 	dd->flags &= ~(BIT(FLAGS_BUSY) | BIT(FLAGS_FINAL) | BIT(FLAGS_CPU) |
 			BIT(FLAGS_DMA_READY) | BIT(FLAGS_OUTPUT_READY));
 
-	pm_runtime_put(dd->dev);
+	pm_runtime_mark_last_busy(dd->dev);
+	pm_runtime_put_autosuspend(dd->dev);
 
 	if (req->base.complete)
 		req->base.complete(&req->base, err);
@@ -1946,6 +1949,9 @@ static int omap_sham_probe(struct platform_device *pdev)
 
 	dd->flags |= dd->pdata->flags;
 
+	pm_runtime_use_autosuspend(dev);
+	pm_runtime_set_autosuspend_delay(dev, DEFAULT_AUTOSUSPEND_DELAY);
+
 	pm_runtime_enable(dev);
 	pm_runtime_irq_safe(dev);
 
-- 
1.9.1
