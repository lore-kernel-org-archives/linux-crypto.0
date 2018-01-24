From: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Subject: [RESEND PATCH 5/6] crypto: caam: add logic to detect when running under TrustZone
Date: Wed, 24 Jan 2018 14:50:34 +0000
Message-ID: <1516805435-15034-6-git-send-email-pure.logic@nexus-software.ie>
References: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: fabio.estevam@nxp.com, peng.fan@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        lukas.auer@aisec.fraunhofer.de, rui.silva@linaro.org,
        ryan.harkin@linaro.org,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
To: horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1516805435-15034-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This patch introduces logic to ascertain if the CAAM is running in
TrustZone mode or not. When running in TrustZone mode the first page of the
CAAM will read-back all zero for each register. This means for a register
such as the MCR - if we detect an all zero register - we can run a simple
test to try to toggle a bit inside of that register.

If the MCR is non-zero we already know we are in a non TrustZone mode.

If we read zero in the MCR but can successfully toggle a bit inside of the
MCR we know we are in a non TrustZone mode. So we set the bit back to zero
and continue.

If we read zero and cannot toggle a bit in the MCR we have successfully
detected TrustZone mode.

Once TrustZone is active the range of functions we can perform on CAAM is
limited; however the CAAM is still usable provided a previous stage in the
boot process initialized the block correctly.

Separate patches will handle the case of determining if the block is usable
when ctrlpriv->trustzone is true.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
Cc: "Horia Geantă" <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Fabio Estevam <fabio.estevam@nxp.com>
Cc: Peng Fan <peng.fan@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Lukas Auer <lukas.auer@aisec.fraunhofer.de>
---
 drivers/crypto/caam/ctrl.c   | 21 +++++++++++++++++++++
 drivers/crypto/caam/intern.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 0a1e96b..7fd3bfc 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -571,6 +571,27 @@ static int caam_probe(struct platform_device *pdev)
 			       MCFGR_LONG_PTR : 0));
 
 	/*
+	 * Detect if we are in TrustZone mode by trying to set MCFGR_LARGE_BURST
+	 * In the first instance if TrustZone is active the MCR will read
+	 * all-zero so if we read non-zero we know we can skip further checks.
+	 * However its possible MCR is zero in non-TrustZone mode so if
+	 * ctrl->mcr == 0 try to flip MCFGR_LARGE_BURST. If we cannot set the
+	 * bit when MCR is zero we've detected TrustZone mode and then we know
+	 * the first page of the CAAM is not accessible to Linux else flip
+	 * MCFGR_LARGE_BURST back to off.
+	 */
+	if (!rd_reg32(&ctrl->mcr)) {
+		clrsetbits_32(&ctrl->mcr, 0, MCFGR_LARGE_BURST);
+		if (!rd_reg32(&ctrl->mcr))
+			ctrlpriv->trust_zone = true;
+		else
+			clrsetbits_32(&ctrl->mcr, MCFGR_LARGE_BURST, 0);
+
+		if (ctrlpriv->trust_zone)
+			dev_info(dev, "TrustZone mode detected\n");
+	}
+
+	/*
 	 *  Read the Compile Time paramters and SCFGR to determine
 	 * if Virtualization is enabled for this platform
 	 */
diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 91f1107..6ff382b 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -84,6 +84,7 @@ struct caam_drv_private {
 	u8 qi_present;		/* Nonzero if QI present in device */
 	int secvio_irq;		/* Security violation interrupt number */
 	int virt_en;		/* Virtualization enabled in CAAM */
+	bool trust_zone;	/* TrustZone mode detected */
 
 #define	RNG4_MAX_HANDLES 2
 	/* RNG4 block */
-- 
2.7.4
