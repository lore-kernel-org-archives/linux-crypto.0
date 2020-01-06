Return-Path: <SRS0=95aS=23=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAB8DC3F68F
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 20:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E56E20731
	for <linux-crypto@archiver.kernel.org>; Mon,  6 Jan 2020 20:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgAFUCD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 Jan 2020 15:02:03 -0500
Received: from inva020.nxp.com ([92.121.34.13]:45932 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726657AbgAFUCD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 Jan 2020 15:02:03 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 563561A0E3F;
        Mon,  6 Jan 2020 21:02:01 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 469CA1A0E3C;
        Mon,  6 Jan 2020 21:02:01 +0100 (CET)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 89CDB203CC;
        Mon,  6 Jan 2020 21:02:00 +0100 (CET)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] arm64: dts: imx8mn: add crypto node
Date:   Mon,  6 Jan 2020 22:01:54 +0200
Message-Id: <20200106200154.30643-2-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200106200154.30643-1-horia.geanta@nxp.com>
References: <20200106200154.30643-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add node for CAAM - Cryptographic Acceleration and Assurance Module.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8mn.dtsi | 30 +++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index cce65b9a861f..c3fec19f4f05 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -537,6 +537,36 @@
 				status = "disabled";
 			};
 
+			crypto: crypto@30900000 {
+				compatible = "fsl,sec-v4.0";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				reg = <0x30900000 0x40000>;
+				ranges = <0 0x30900000 0x40000>;
+				interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk IMX8MN_CLK_AHB>,
+					 <&clk IMX8MN_CLK_IPG_ROOT>;
+				clock-names = "aclk", "ipg";
+
+				sec_jr0: jr0@1000 {
+					 compatible = "fsl,sec-v4.0-job-ring";
+					 reg = <0x1000 0x1000>;
+					 interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
+				};
+
+				sec_jr1: jr1@2000 {
+					 compatible = "fsl,sec-v4.0-job-ring";
+					 reg = <0x2000 0x1000>;
+					 interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
+				};
+
+				sec_jr2: jr2@3000 {
+					 compatible = "fsl,sec-v4.0-job-ring";
+					 reg = <0x3000 0x1000>;
+					 interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+				};
+			};
+
 			i2c1: i2c@30a20000 {
 				compatible = "fsl,imx8mn-i2c", "fsl,imx21-i2c";
 				#address-cells = <1>;
-- 
2.17.1

