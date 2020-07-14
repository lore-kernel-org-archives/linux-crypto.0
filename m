Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB41C433F2
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 12:40:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2B13224D3
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 12:40:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgGNMjk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 08:39:40 -0400
Received: from inva021.nxp.com ([92.121.34.21]:52006 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727772AbgGNMjh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 08:39:37 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id BB6F6201005;
        Tue, 14 Jul 2020 14:39:35 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id AEA44201001;
        Tue, 14 Jul 2020 14:39:35 +0200 (CEST)
Received: from fsr-ub1864-014.ea.freescale.net (fsr-ub1864-014.ea.freescale.net [10.171.95.219])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id E9CF7205A4;
        Tue, 14 Jul 2020 14:39:34 +0200 (CEST)
From:   =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>
To:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/5] ARM: dts: imx6sl: fix rng node
Date:   Tue, 14 Jul 2020 15:39:17 +0300
Message-Id: <20200714123920.23711-3-horia.geanta@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714123920.23711-1-horia.geanta@nxp.com>
References: <20200714123920.23711-1-horia.geanta@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

rng DT node was added without a compatible string.

i.MX driver for RNGC (drivers/char/hw_random/imx-rngc.c) also claims
support for RNGB, and is currently used for i.MX25.

Let's use this driver also for RNGB block in i.MX6SL.

Fixes: e29fe21cff96 ("ARM: dts: add device tree source for imx6sl SoC")
Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
---
 arch/arm/boot/dts/imx6sl.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6sl.dtsi b/arch/arm/boot/dts/imx6sl.dtsi
index 1c7180f28539..91a8c54d5e11 100644
--- a/arch/arm/boot/dts/imx6sl.dtsi
+++ b/arch/arm/boot/dts/imx6sl.dtsi
@@ -939,8 +939,10 @@
 			};
 
 			rngb: rngb@21b4000 {
+				compatible = "fsl,imx6sl-rngb", "fsl,imx25-rngb";
 				reg = <0x021b4000 0x4000>;
 				interrupts = <0 5 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clks IMX6SL_CLK_DUMMY>;
 			};
 
 			weim: weim@21b8000 {
-- 
2.17.1

