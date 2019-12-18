Return-Path: <SRS0=NTKo=2I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBF3FC2D0CD
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 13:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3AA0218AC
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Dec 2019 13:06:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gAtIS8Y4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbfLRNGc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Dec 2019 08:06:32 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:33274 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfLRNGb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Dec 2019 08:06:31 -0500
Received: by mail-yb1-f196.google.com with SMTP id n66so708463ybg.0;
        Wed, 18 Dec 2019 05:06:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u7mxG5yAwNcZ8Cq1r7PPlmVBfCoyrOeHrNys7o6+Upg=;
        b=gAtIS8Y40e2CtCol5C3ukspjDFRT53f8NQhU8u8alkLhXE+ez5VdZHRuadEUjYHKHe
         rK9QHYE1vhmRuMP090hZ4WVIf4ufpzGOlPOF/WSWZ8DCEm1EJ+gJJ0v6QgyMmNaqk/Ug
         lScZRUMllfrRTJLQgHziR6DaVqVqSVdbkhnU742Wm4LPhliy3NMGvm1zhTxo26P2CYDK
         Jf8ckgX9dnss2E56V4pBDBhrnQkJZYC/W7N3aFVaY0VDYY/BlQYRMjSbXTJ/UV7xeM27
         8gpb1jaRUoe/6KHOfMrQ0KvItWucHwBv/Yo6dO+JpOE/OiD2HGFGnhfHWIhmSM/+CTJt
         VpAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u7mxG5yAwNcZ8Cq1r7PPlmVBfCoyrOeHrNys7o6+Upg=;
        b=DNl+cdKISTt9QGrB6nCtfzWo/3URtzsNaJ7jtOmtB76qxbuTGvaUJidOymUIxPLDpF
         3rkbhTe5JvxINm+2ENjUFB0Auwg2KYvcNPeAxATCwVHj+zaA25Aq0npE4r10LndKhFC8
         NKte7kEcVSpT5sRjzhSlqH3buAB3H9WNkez9bXyt9Y9YAj/yNWxyFgvnOiKHoDsSYqwv
         tMJvQM8LY18MPpuCq0Qlk/bh88ADywXOW8uFXQgI8epFQseGIQwrO8JK5eu8g5lSA6CC
         JL7r6Z37BN3loC3dAfkgOGeAtUXntye/OsYA8yGv6uKez1/sI0s8OUbsw1OoALsrr5Kc
         F1Hg==
X-Gm-Message-State: APjAAAUQ3ceNCQl1l/IvnlZre6QsDS+2Z3fdW86pQZEA3j0CJQbMGMuz
        aU37a7q/MZzj1wtMTTK8u4ju2t5JfEo=
X-Google-Smtp-Source: APXvYqz95pC6V0l8GBRfWqEiASGWI8aAKkIuqVpJZnPm3TZNYHLJeElu5fGmJrutxOzi6ru9Cj9WVA==
X-Received: by 2002:a25:7557:: with SMTP id q84mr1755022ybc.76.1576674390127;
        Wed, 18 Dec 2019 05:06:30 -0800 (PST)
Received: from localhost.localdomain (c-73-37-219-234.hsd1.mn.comcast.net. [73.37.219.234])
        by smtp.gmail.com with ESMTPSA id r64sm909603ywg.84.2019.12.18.05.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 05:06:29 -0800 (PST)
From:   Adam Ford <aford173@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Adam Ford <aford173@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
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
Subject: [PATCH V3 2/3] arm64: dts: imx8mm: Add Crypto CAAM support
Date:   Wed, 18 Dec 2019 07:06:15 -0600
Message-Id: <20191218130616.13860-2-aford173@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218130616.13860-1-aford173@gmail.com>
References: <20191218130616.13860-1-aford173@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The i.MX8M Mini supports the same crypto engine as what is in
the i.MX8MQ, but it is not currently present in the device tree.

This patch places it into the device tree.

Signed-off-by: Adam Ford <aford173@gmail.com>
Reviewed-by: Horia Geantă <horia.geanta@nxp.com>
---
V3:  Fix typo in commit message.  no code changes
V2:  Don't disable it by default

diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 6edbdfe2d0d7..cbe80a3f048c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -641,6 +641,36 @@
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

