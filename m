Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18052C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC42520835
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:39:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfCVNjo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:39:44 -0400
Received: from inva021.nxp.com ([92.121.34.21]:42234 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728119AbfCVNjo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 09:39:44 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 908E220010A;
        Fri, 22 Mar 2019 14:39:41 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 83BD8200081;
        Fri, 22 Mar 2019 14:39:41 +0100 (CET)
Received: from lorenz.ea.freescale.net (lorenz.ea.freescale.net [10.171.71.5])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 284B2205F3;
        Fri, 22 Mar 2019 14:39:41 +0100 (CET)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam - limit AXI pipeline to a depth of 1
Date:   Fri, 22 Mar 2019 15:39:28 +0200
Message-Id: <1553261968-5766-1-git-send-email-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.1.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some i.MX6 devices (imx6D, imx6Q, imx6DL, imx6S, imx6DP and imx6DQ) have
an issue wherein AXI bus transactions may not occur in the correct order.
This isn't a problem running single descriptors, but can be if running
multiple concurrent descriptors. Reworking the CAAM driver to throttle
to single requests is impractical, so this patch limits the AXI pipeline
to a depth of one (from a default of 4) to preclude this situation from
occurring.
This patch applies to known affected platforms.

Signed-off-by: Radu Solea <radu.solea@nxp.com>
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 858bdc9..e2ba3d2 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -468,6 +468,24 @@ static int caam_get_era(struct caam_ctrl __iomem *ctrl)
 		return caam_get_era_from_hw(ctrl);
 }
 
+/*
+ * ERRATA: imx6 devices (imx6D, imx6Q, imx6DL, imx6S, imx6DP and imx6DQ)
+ * have an issue wherein AXI bus transactions may not occur in the correct
+ * order. This isn't a problem running single descriptors, but can be if
+ * running multiple concurrent descriptors. Reworking the driver to throttle
+ * to single requests is impractical, thus the workaround is to limit the AXI
+ * pipeline to a depth of 1 (from it's default of 4) to preclude this situation
+ * from occurring.
+ */
+static void handle_imx6_err005766(u32 *mcr)
+{
+	if (of_machine_is_compatible("fsl,imx6q") ||
+	    of_machine_is_compatible("fsl,imx6dl") ||
+	    of_machine_is_compatible("fsl,imx6qp"))
+		clrsetbits_32(mcr, MCFGR_AXIPIPE_MASK,
+			      1 << MCFGR_AXIPIPE_SHIFT);
+}
+
 static const struct of_device_id caam_match[] = {
 	{
 		.compatible = "fsl,sec-v4.0",
@@ -640,6 +658,8 @@ static int caam_probe(struct platform_device *pdev)
 			      (sizeof(dma_addr_t) == sizeof(u64) ?
 			       MCFGR_LONG_PTR : 0));
 
+	handle_imx6_err005766(&ctrl->mcr);
+
 	/*
 	 *  Read the Compile Time paramters and SCFGR to determine
 	 * if Virtualization is enabled for this platform
-- 
2.1.0

