From: =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
Subject: [PATCH 2/7] soc/qman: add dedicated channel ID for CAAM
Date: Fri, 17 Mar 2017 12:05:57 +0200
Message-ID: <20170317100602.2837-3-horia.geanta@nxp.com>
References: <20170317100602.2837-1-horia.geanta@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Dan Douglass <dan.douglass@nxp.com>,
        Alexandru Porosanu <alexandru.porosanu@nxp.com>,
        Vakul Garg <vakul.garg@nxp.com>,
        Cristian Stoica <cristian.stoica@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        Scott Wood <oss@buserror.net>, Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn3nam01on0085.outbound.protection.outlook.com ([104.47.33.85]:38480
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751042AbdCQKGh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 06:06:37 -0400
In-Reply-To: <20170317100602.2837-1-horia.geanta@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add and export the ID of the channel serviced by the
CAAM (Cryptographic Acceleration and Assurance Module) DCP.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 drivers/soc/fsl/qbman/qman_ccsr.c | 6 +++++-
 include/soc/fsl/qman.h            | 3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/fsl/qbman/qman_ccsr.c b/drivers/soc/fsl/qbman/qman_ccsr.c
index f4e6e70de259..90bc40c48675 100644
--- a/drivers/soc/fsl/qbman/qman_ccsr.c
+++ b/drivers/soc/fsl/qbman/qman_ccsr.c
@@ -34,6 +34,8 @@ u16 qman_ip_rev;
 EXPORT_SYMBOL(qman_ip_rev);
 u16 qm_channel_pool1 = QMAN_CHANNEL_POOL1;
 EXPORT_SYMBOL(qm_channel_pool1);
+u16 qm_channel_caam = QMAN_CHANNEL_CAAM;
+EXPORT_SYMBOL(qm_channel_caam);
 
 /* Register offsets */
 #define REG_QCSP_LIO_CFG(n)	(0x0000 + ((n) * 0x10))
@@ -720,8 +722,10 @@ static int fsl_qman_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	if ((qman_ip_rev & 0xff00) >= QMAN_REV30)
+	if ((qman_ip_rev & 0xff00) >= QMAN_REV30) {
 		qm_channel_pool1 = QMAN_CHANNEL_POOL1_REV3;
+		qm_channel_caam = QMAN_CHANNEL_CAAM_REV3;
+	}
 
 	ret = zero_priv_mem(dev, node, fqd_a, fqd_sz);
 	WARN_ON(ret);
diff --git a/include/soc/fsl/qman.h b/include/soc/fsl/qman.h
index 4de1ffcc8982..10b549783ec5 100644
--- a/include/soc/fsl/qman.h
+++ b/include/soc/fsl/qman.h
@@ -36,8 +36,11 @@
 /* Hardware constants */
 #define QM_CHANNEL_SWPORTAL0 0
 #define QMAN_CHANNEL_POOL1 0x21
+#define QMAN_CHANNEL_CAAM 0x80
 #define QMAN_CHANNEL_POOL1_REV3 0x401
+#define QMAN_CHANNEL_CAAM_REV3 0x840
 extern u16 qm_channel_pool1;
+extern u16 qm_channel_caam;
 
 /* Portal processing (interrupt) sources */
 #define QM_PIRQ_CSCI	0x00100000	/* Congestion State Change */
-- 
2.12.0.264.gd6db3f216544
