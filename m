Return-Path: <SRS0=Hyrp=2W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13CF5C2D0DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 17:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6021207E0
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jan 2020 17:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=amarulasolutions.com header.i=@amarulasolutions.com header.b="H3sNLMfJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgAARuR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jan 2020 12:50:17 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:52198 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727234AbgAARuP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jan 2020 12:50:15 -0500
Received: by mail-wm1-f66.google.com with SMTP id d73so3908063wmd.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Jan 2020 09:50:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=12nPZoYm5B9O7/gN39AnPaKov7Kvb+XDvIXAHahnWys=;
        b=H3sNLMfJYn4R9zMIiXkpZ3A7/6KfGkNQ70mnqEN648stOCgYDViADXf0NZu+KNUsIG
         qXNFEm8YZ1TL8C2VIdUsljDE//Fudcw63RR1r4UDapnpeHwRLUIlG519IueS5L1GOUtk
         lpxxIBJN8eQL+NigCBLgtSumUzQEpipSX9UuI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=12nPZoYm5B9O7/gN39AnPaKov7Kvb+XDvIXAHahnWys=;
        b=NGt+YlArP7kj1dhUja288jtlAbhnxZ90mCpHO1PdSuNNWwJzykqyxlUzNtzmHkjl8k
         u9JrwRskeRQKmCTOge4dEfXF8w9mp99qofrUGH8rgmvBhPF59uFIUS5mq7Wq7aDWMcNi
         B6U2uNDoGBbMhaa6dwqH/0vslsFcx7Dr63Yza8p+PY375WX+Q/Y4qDi2766/Hyyi8doR
         mNKfCVcLI3wdXXwB7DHqTsWbHmauW2MUXAYFZNFpiwSWydzjklT27rk3+YtEpp3G7oGv
         M+1Oi1QgP6TWS8bVu3YThehecojNTg5Go3Du849pEZIs3BcZc7cFKrXw1+UbgY5WjMNy
         /O+w==
X-Gm-Message-State: APjAAAU/Gj4ElPT0/bZG3zTbNilCpkDZr6pQQaRqm6mTTF7neoadAbRQ
        6+wCrAXDoww8uU304hGnX+6aXQ==
X-Google-Smtp-Source: APXvYqwcPN+/qIwHkLsDYh4D9zpy2hKTq1vCs5L7oZr5hU2Vk65Fa/hXgcdbiqJcMmVYFV4CyHk7OA==
X-Received: by 2002:a05:600c:248:: with SMTP id 8mr10708929wmj.175.1577901012933;
        Wed, 01 Jan 2020 09:50:12 -0800 (PST)
Received: from panicking.lan (93-46-124-24.ip107.fastwebnet.it. [93.46.124.24])
        by smtp.gmail.com with ESMTPSA id r15sm6025085wmh.21.2020.01.01.09.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 09:50:12 -0800 (PST)
From:   Michael Trimarchi <michael@amarulasolutions.com>
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-amarula@amarulasolutions.com,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: [PATCH 1/2] arm64: dts: imx8mm: Add CAAM node
Date:   Wed,  1 Jan 2020 18:50:10 +0100
Message-Id: <20200101175011.1875-1-michael@amarulasolutions.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add node for CAAM - Cryptographic Acceleration and Assurance Module.

Signed-off-by: Michael Trimarchi <michael@amarulasolutions.com>
---
 arch/arm64/boot/dts/freescale/imx8mm.dtsi | 31 +++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 7360dc0685eb..428a8b43086e 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -667,6 +667,37 @@
 				status = "disabled";
 			};
 
+			crypto: crypto@30900000 {
+				compatible = "fsl,sec-v4.0";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				reg = <0x30900000 0x40000>;
+				ranges = <0 0x30900000 0x40000>;
+				interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk IMX8MM_CLK_AHB>,
+					 <&clk IMX8MM_CLK_IPG_ROOT>;
+				clock-names = "aclk", "ipg";
+				status = "disabled";
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
 				compatible = "fsl,imx8mm-i2c", "fsl,imx21-i2c";
 				#address-cells = <1>;
-- 
2.17.1

