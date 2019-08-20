Return-Path: <SRS0=8F2V=WQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755B8C3A589
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:25:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 453F422DA7
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Aug 2019 20:25:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2j0eVEw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbfHTUZQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Aug 2019 16:25:16 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34680 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731034AbfHTUYl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Aug 2019 16:24:41 -0400
Received: by mail-pg1-f193.google.com with SMTP id n9so3861924pgc.1;
        Tue, 20 Aug 2019 13:24:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ft8Npgk0V4h9gCTebElLh/LI6ukT30/vubgsZx1GmhY=;
        b=d2j0eVEwUkOjKehYUVYShyqYad1M0D+4rOI3N9h5ZQWYNTGJ7OZBjElGiWp+z+ivdW
         WfwgkwPA7xPs4pdQtkOiKwNd/h7LrZDfZ4Swg4ncl0VqoeqaCUT0Zr6R8tmjffHCkH3b
         VUg4VAJWysSQGm8TGZS0BUewta/ZKLUd8zprzQoWKrR76Ns32JLQEkjILg1MMltVqWdm
         1YvM6PHbiWyQy4oUOHFKKX1jnIzvWHdPxw0aioi2df4pXcb8YhwVEatBfBQUkDrh6Ebo
         Lt55mSzDwnKuB2b1/ifvYhaBBk9fno9cU0aMcULpjG6ohZfl/x+0jfsyA/ERWEFwdsLR
         hxbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ft8Npgk0V4h9gCTebElLh/LI6ukT30/vubgsZx1GmhY=;
        b=f2h/yl3RPIGPgIMd03RAIIs2HZqVoEnUlcfox6L4Iz8H2Zcfu3pP5HEeqiV2DL+dl8
         wfrGgt0F2WpuH+Fv9ULv+N93Sa7ShnFDhct0Kmp4PHUfPSrFkWlgFxzBRZGvJrZ+rpQI
         Y//RdE0A+ntOxJLWauI1R9uJTv1A5nscYOGtryhx1Z1QKhhE/d+H/URbQ7DjaNNeu7bl
         YWlR/azO52YKy3AEqrDG3wAS+PkDKGxvrNscFeXKnpw30JNSh6ZOTAAMsNX8I2GOsNvO
         uUlBLv9C8NpmoxQ7poM/u7hjyEu8vZY76teezmcNzfDbb+gLHV3rnCPBvp52zRopeQGT
         sw/g==
X-Gm-Message-State: APjAAAXyC33ZH2JfVvSlEhN697yjL+XWjvB3fCWsu1hXeHGgzQk6Vg59
        OeqfRKHxdIib0+gsSDPbPGHVbeopMeY=
X-Google-Smtp-Source: APXvYqz5LaptY3v8E8pw3wBFDoIcNq4pLkDihisOWtEG8qhQrDhJ14BYb3A4if0r5f4CwzdlbPovPw==
X-Received: by 2002:a62:4e09:: with SMTP id c9mr33083657pfb.130.1566332680533;
        Tue, 20 Aug 2019 13:24:40 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id k3sm36149846pfg.23.2019.08.20.13.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 13:24:39 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v8 16/16] arm64: dts: imx8mq: Add CAAM node
Date:   Tue, 20 Aug 2019 13:24:02 -0700
Message-Id: <20190820202402.24951-17-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190820202402.24951-1-andrew.smirnov@gmail.com>
References: <20190820202402.24951-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add node for CAAM - Cryptographic Acceleration and Assurance Module.

Signed-off-by: Horia Geantă <horia.geanta@nxp.com>
Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Spencer <christopher.spencer@sea.co.uk>
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm64/boot/dts/freescale/imx8mq.dtsi | 30 +++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index d09b808eff87..752d5a61878c 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -728,6 +728,36 @@
 				status = "disabled";
 			};
 
+			crypto: crypto@30900000 {
+				compatible = "fsl,sec-v4.0";
+				#address-cells = <1>;
+				#size-cells = <1>;
+				reg = <0x30900000 0x40000>;
+				ranges = <0 0x30900000 0x40000>;
+				interrupts = <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
+				clocks = <&clk IMX8MQ_CLK_AHB>,
+					 <&clk IMX8MQ_CLK_IPG_ROOT>;
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
 				compatible = "fsl,imx8mq-i2c", "fsl,imx21-i2c";
 				reg = <0x30a20000 0x10000>;
-- 
2.21.0

