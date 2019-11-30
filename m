Return-Path: <SRS0=Bt+4=ZW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBD98C43215
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Nov 2019 22:52:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 915582082E
	for <linux-crypto@archiver.kernel.org>; Sat, 30 Nov 2019 22:52:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YiL4AirM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727416AbfK3WwK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 30 Nov 2019 17:52:10 -0500
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37441 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727025AbfK3WwK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 30 Nov 2019 17:52:10 -0500
Received: by mail-yw1-f67.google.com with SMTP id 4so11964526ywx.4;
        Sat, 30 Nov 2019 14:52:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w0VTjeAbtSqemOM43UsO8Hem8cE/aNSTS/UBVqjVywc=;
        b=YiL4AirMTqr6aGYwyZ/Lh+rb4JR2HtOA76xqsjBh8p9VTZB4W1DziDewVMuiAdJkjJ
         OkKzSzIx8F3HkzmEmJYvl2eIeguK0Z28QHhdjUlB4/ko7cASISyWnqSPn2PRjM4wUiVU
         bZhKc33ydp+uW+wz4pNucl/F8ZuhVVGEhjUkpugcy0hOiFL4mahvEYfpU9ORvevutFpF
         nOVNslyAnLBqF4YrSu5k5/Ye0bz/LSDnG0tDZhNc3+ldghQGwgs0vPnOONowz8uAGkfh
         71xCP/NHJ/aB6UP27pGXaCSZZpgOUlGIcmvSJefbCI6hVG8JpAJ9Cukhkbds5TeVFzQG
         QNDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w0VTjeAbtSqemOM43UsO8Hem8cE/aNSTS/UBVqjVywc=;
        b=LeHd1MDncI3+E/uOslMWWwfKakrDvY3S7sG+aA9hER/0rEPZb9Z+/+WpulJjl+/8Cg
         OGHzLcrij8e7E/+9og+mTR/C9ONQq4/7gWPnkYWI/fmyYU7bT0LvEeULlzj+9mk0nkD5
         37W+r7GSjr11fzxbDkA/zJf3XicsZi4MRBHHoO18lLe2JiyJKNuMYGjbFLU17DwXChLA
         bkYa8+hQzTpHhU5VKhaIIGJ7kcrD0hxdtSsiac9dR6aWf7iy+T5KhDXoo+3p1+PI9cml
         sIDXU3Y8+u302YCd6yIcSfEmC8v8mbj4KoV8L5D+f2oCueuPuYdDsrxI699UYylI6Hud
         7A8A==
X-Gm-Message-State: APjAAAVuQoVM5YepJs8SHEMPJrslXLIdt1eDE3+GqpwWNWwPt40vEMka
        A18f8+Nh9aSE/83/UujIhK3L9/4xdAo=
X-Google-Smtp-Source: APXvYqwOR+XG0CXmcrTJVDU+HgRLkfmiEtFTdynP+cuDkyMBswz+hQZfRPCieMZsYMBTfVB3g06P8Q==
X-Received: by 2002:a81:53c2:: with SMTP id h185mr16235156ywb.113.1575154327481;
        Sat, 30 Nov 2019 14:52:07 -0800 (PST)
Received: from localhost.localdomain (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id y9sm2028163ywc.19.2019.11.30.14.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Nov 2019 14:52:06 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Adam Ford <aford173@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] arm64: dts: imx8mm: Add Crypto CAAM support
Date:   Sat, 30 Nov 2019 16:51:52 -0600
Message-Id: <20191130225153.30111-2-aford173@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191130225153.30111-1-aford173@gmail.com>
References: <20191130225153.30111-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The i.MX8M Mini supports the same crypto engine as what is in
the i.MX8MQ, but it is not currently present in the device tree,
because it may be resricted by security features.

This patch places in into the device tree and marks it as disabled,
but anyone not restricting the CAAM with secure mode functions
can mark it as enabled.

Signed-off-by: Adam Ford <aford173@gmail.com>

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 2ed1a3537f05..68c7c1adeb60 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -723,6 +723,37 @@
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

