Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7872EC04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 08:03:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5784D206BB
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 08:03:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFFIDK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 04:03:10 -0400
Received: from inva021.nxp.com ([92.121.34.21]:54246 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfFFIDK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 04:03:10 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 0E911200A0C;
        Thu,  6 Jun 2019 10:03:08 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 016FC200A13;
        Thu,  6 Jun 2019 10:03:08 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 5069B205C7;
        Thu,  6 Jun 2019 10:03:07 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>
Cc:     Aymen Sghaier <aymen.sghaier@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        linux-crypto@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: dts: imx7ulp: add crypto support
Date:   Thu,  6 Jun 2019 11:02:55 +0300
Message-Id: <20190606080255.25504-1-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

Add crypto node in device tree for CAAM support.

Noteworthy is that on 7ulp the interrupt line is shared
between the two job rings.

Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Franck LENORMAND <franck.lenormand@nxp.com>
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---

I've just realized that this patch should be merged through the crypto tree,
else bisectability could be affected due to cryptodev-2.6
commit 385cfc84a5a8 ("crypto: caam - disable some clock checks for iMX7ULP")
( https://patchwork.kernel.org/patch/10970017/ )
which should come first.

 arch/arm/boot/dts/imx7ulp.dtsi | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/imx7ulp.dtsi b/arch/arm/boot/dts/imx7ulp.dtsi
index d6b711011cba..e20483714be5 100644
--- a/arch/arm/boot/dts/imx7ulp.dtsi
+++ b/arch/arm/boot/dts/imx7ulp.dtsi
@@ -100,6 +100,29 @@
 		reg = <0x40000000 0x800000>;
 		ranges;
 
+		crypto: crypto@40240000 {
+			compatible = "fsl,sec-v4.0";
+			#address-cells = <1>;
+			#size-cells = <1>;
+			reg = <0x40240000 0x10000>;
+			ranges = <0 0x40240000 0x10000>;
+			clocks = <&pcc2 IMX7ULP_CLK_CAAM>,
+				 <&scg1 IMX7ULP_CLK_NIC1_BUS_DIV>;
+			clock-names = "aclk", "ipg";
+
+			sec_jr0: jr0@1000 {
+				compatible = "fsl,sec-v4.0-job-ring";
+				reg = <0x1000 0x1000>;
+				interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
+			};
+
+			sec_jr1: jr1@2000 {
+				compatible = "fsl,sec-v4.0-job-ring";
+				reg = <0x2000 0x1000>;
+				interrupts = <GIC_SPI 54 IRQ_TYPE_LEVEL_HIGH>;
+			};
+		};
+
 		lpuart4: serial@402d0000 {
 			compatible = "fsl,imx7ulp-lpuart";
 			reg = <0x402d0000 0x1000>;
-- 
2.17.1

