Return-Path: <SRS0=BYd+=T7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DDCC28CC3
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 11:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9888267FE
	for <linux-crypto@archiver.kernel.org>; Fri, 31 May 2019 11:06:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727151AbfEaLGl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 May 2019 07:06:41 -0400
Received: from inva020.nxp.com ([92.121.34.13]:34838 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726280AbfEaLGl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 May 2019 07:06:41 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 63B9F1A085A;
        Fri, 31 May 2019 13:06:39 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 57CA51A0199;
        Fri, 31 May 2019 13:06:39 +0200 (CEST)
Received: from fsr-ub1864-104.ea.freescale.net (fsr-ub1864-104.ea.freescale.net [10.171.82.77])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id EF5DE205D8;
        Fri, 31 May 2019 13:06:38 +0200 (CEST)
From:   Iuliana Prodan <iuliana.prodan@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-imx <linux-imx@nxp.com>
Subject: [PATCH] crypto: caam - disable some clock checks for iMX7ULP
Date:   Fri, 31 May 2019 14:06:34 +0300
Message-Id: <20190531110634.2967-1-iuliana.prodan@nxp.com>
X-Mailer: git-send-email 2.17.1
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Disabled the check and set of 'mem' and 'emi_slow'
clocks, since these are not available for iMX7ULP.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
---
 drivers/crypto/caam/ctrl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index bbde6efce8af..5d197e879899 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -540,7 +540,8 @@ static int caam_probe(struct platform_device *pdev)
 	ctrlpriv->caam_ipg = clk;
 
 	if (!of_machine_is_compatible("fsl,imx7d") &&
-	    !of_machine_is_compatible("fsl,imx7s")) {
+	    !of_machine_is_compatible("fsl,imx7s") &&
+	    !of_machine_is_compatible("fsl,imx7ulp")) {
 		clk = caam_drv_identify_clk(&pdev->dev, "mem");
 		if (IS_ERR(clk)) {
 			ret = PTR_ERR(clk);
@@ -562,7 +563,8 @@ static int caam_probe(struct platform_device *pdev)
 
 	if (!of_machine_is_compatible("fsl,imx6ul") &&
 	    !of_machine_is_compatible("fsl,imx7d") &&
-	    !of_machine_is_compatible("fsl,imx7s")) {
+	    !of_machine_is_compatible("fsl,imx7s") &&
+	    !of_machine_is_compatible("fsl,imx7ulp")) {
 		clk = caam_drv_identify_clk(&pdev->dev, "emi_slow");
 		if (IS_ERR(clk)) {
 			ret = PTR_ERR(clk);
-- 
2.17.1

