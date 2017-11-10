From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 1/2] crypto: caam - save Era in driver's private data
Date: Fri, 10 Nov 2017 16:33:48 +0200
Message-ID: <20171110143349.8394-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-cys01nam02on0055.outbound.protection.outlook.com ([104.47.37.55]:35424
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752023AbdKJOeT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Nov 2017 09:34:19 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Save Era in driver's private data for further usage,
like deciding whether an erratum applies or a feature is available
based on its value.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/crypto/caam/ctrl.c   | 4 +++-
 drivers/crypto/caam/intern.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 027e121c6f70..75d280cb2dc0 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -611,6 +611,8 @@ static int caam_probe(struct platform_device *pdev)
 		goto iounmap_ctrl;
 	}
 
+	ctrlpriv->era = caam_get_era();
+
 	ret = of_platform_populate(nprop, caam_match, NULL, dev);
 	if (ret) {
 		dev_err(dev, "JR platform devices creation error\n");
@@ -742,7 +744,7 @@ static int caam_probe(struct platform_device *pdev)
 
 	/* Report "alive" for developer to see */
 	dev_info(dev, "device ID = 0x%016llx (Era %d)\n", caam_id,
-		 caam_get_era());
+		 ctrlpriv->era);
 	dev_info(dev, "job rings = %d, qi = %d, dpaa2 = %s\n",
 		 ctrlpriv->total_jobrs, ctrlpriv->qi_present,
 		 caam_dpaa2 ? "yes" : "no");
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index a52361258d3a..55aab74e7b5c 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -83,6 +83,7 @@ struct caam_drv_private {
 	u8 qi_present;		/* Nonzero if QI present in device */
 	int secvio_irq;		/* Security violation interrupt number */
 	int virt_en;		/* Virtualization enabled in CAAM */
+	int era;		/* CAAM Era (internal HW revision) */
 
 #define	RNG4_MAX_HANDLES 2
 	/* RNG4 block */
-- 
2.12.0.264.gd6db3f216544
