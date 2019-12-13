Return-Path: <SRS0=mgHx=2D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C22EC76197
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C159B246C0
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Dec 2019 20:38:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bw41ej1m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728052AbfLMPjY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 13 Dec 2019 10:39:24 -0500
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35774 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728040AbfLMPjX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Dec 2019 10:39:23 -0500
Received: by mail-yw1-f66.google.com with SMTP id i190so12448ywc.2;
        Fri, 13 Dec 2019 07:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zAVLyHI55RYFQfABy0CQiTV5qxIf3ilADCMSzbRJCnM=;
        b=bw41ej1m7qXmEL/RA/Zpn70Z9LvnYU1XkNBiR8nDGpD9rGdBw5AaKbgRzT+4WIoXnx
         GgOFePNa7to/03NkjusJ3b+dsq/CUeKC9Nk+6Qn3Csyg+UXiq642pzTAYcdLcEvXOMYB
         70itpJPQWDiPW3x7i+0jGNg4wmLrBAJPd017LZpkmaOyUQDVuRBmsEJzd91QPzUXy9i/
         WtCSjAo5M+DGkRTXhsMPiD6BaYWy5UV47OXokef+D9oL1LigiMVSgsdbNOc5qXM+RJbE
         KrcVNtljQDVPV8X7iFA+TG+0I21dE7/06p+KigtJRQn1TPCMfOaYnjUJnQJzP+qYligO
         9kVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zAVLyHI55RYFQfABy0CQiTV5qxIf3ilADCMSzbRJCnM=;
        b=X0ChqglmR5yqVfgaYDh+xA+9bfvskokgm+tX3+OZ3uuKksBaRX+IUXBDTZnlJar5RK
         ALijnYmgySk7g09B1cdU9Pl4qup2RpCb18pwJRs1t3xbYbKY2OgpN3GYoQFtvHhOM0uv
         L1mCwqZizelrphLO6V+jqkmxIFHywOSvi1SZBsJVzW5Nl1DhZboIhk6bKgM/bZk6GuVy
         siNWdCX/hEfLtQjuDKWCSyhmLKtkXhWz5sERKJZWeMLE4s55mVzFsvT8W395r8lMskpb
         GU6BKyFUGP+F3RZv9Broa+8RvdnTxGpdz0CXFQUb6dvr3DPVuYLNVWk6ZmmGTTDjGW61
         yFvQ==
X-Gm-Message-State: APjAAAVlnDNYnyREBcDhVevzycenFxvElFtxMoR67x3OFcZYx1N7zi8N
        XUNIgVVWNAmKUP95OdXPTaM=
X-Google-Smtp-Source: APXvYqxEJIIyofm5M0Sh4DQ1LyuKviJI7SgF5u+5c4dQaIsYOJppbZ+0Ko1f0dmxBRWmYpBnkZ+uLQ==
X-Received: by 2002:a25:c242:: with SMTP id s63mr9067337ybf.19.1576251562471;
        Fri, 13 Dec 2019 07:39:22 -0800 (PST)
Received: from localhost.localdomain (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id i17sm4300474ywg.66.2019.12.13.07.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 07:39:21 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     horia.geanta@nxp.com, Adam Ford <aford173@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH V2 2/3] arm64: dts: imx8mm: Add Crypto CAAM support
Date:   Fri, 13 Dec 2019 09:39:09 -0600
Message-Id: <20191213153910.11235-2-aford173@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191213153910.11235-1-aford173@gmail.com>
References: <20191213153910.11235-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The i.MX8M Mini supports the same crypto engine as what is in
the i.MX8MQ, but it is not currently present in the device tree.

This patch places in into the device tree.

Signed-off-by: Adam Ford <aford173@gmail.com>
---
V2:  Don't disable it by default

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 860cddec9632..1f0178078572 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -726,6 +726,36 @@
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
+
+				sec_jr0: jr@1000 {
+					compatible = "fsl,sec-v4.0-job-ring";
+					reg = <0x1000 0x1000>;
+					interrupts = <GIC_SPI 105 IRQ_TYPE_LEVEL_HIGH>;
+				};
+
+				sec_jr1: jr@2000 {
+					compatible = "fsl,sec-v4.0-job-ring";
+					reg = <0x2000 0x1000>;
+					interrupts = <GIC_SPI 106 IRQ_TYPE_LEVEL_HIGH>;
+				};
+
+				sec_jr2: jr@3000 {
+					compatible = "fsl,sec-v4.0-job-ring";
+					reg = <0x3000 0x1000>;
+					interrupts = <GIC_SPI 114 IRQ_TYPE_LEVEL_HIGH>;
+				};
+			};
+
 			i2c1: i2c@30a20000 {
 				compatible = "fsl,imx8mm-i2c", "fsl,imx21-i2c";
 				#address-cells = <1>;
-- 
2.20.1

