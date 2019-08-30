Return-Path: <SRS0=VSoq=W2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D564BC3A59B
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 21:01:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A5AB223429
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Aug 2019 21:01:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VlV7OCds"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfH3VBz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Aug 2019 17:01:55 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36098 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727991AbfH3VBz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Aug 2019 17:01:55 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so4128226pgm.3;
        Fri, 30 Aug 2019 14:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9HWgbMIqRserk4twrMsOkgXr9R1mUbhAHHKsL/aOnKI=;
        b=VlV7OCdsjLM+wpxDQO2Ki5ulx8r2y9In1A8QiMj/bphFBjCi6YohJe4YAw7c4lZRsD
         nO7TrJeZ1h2eO7+1TRb2KUEUIoskX8q4evdFUQbiC9l8+C88IZxS1+bVCCiAXext0VyL
         YNuIUMFFv0LbI6LZL3A9ul+858LAB9m/UZGKC7enDHIclEwb6tbO872Bk/XYM4kZ0kfB
         PlRLy1654G/vU2tkc/StrIYRXFWl2QyCOoE3tM/vRjdM/RtZJHcwF9c8+ZzdhW1Xyp6n
         mJQaKy0abZ51fLyPSJuxU3kXdbysnQ3ZjQQZe04KlxEE5e8zY/P98/KRTzaehnc15pOW
         4Yww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9HWgbMIqRserk4twrMsOkgXr9R1mUbhAHHKsL/aOnKI=;
        b=TuOP9lUjW4mJv6Pe9I+3Cvt1FIGjQuspk3XaX8Wq7qDgA5tEPeSuqYHSpDgmvPb4A1
         WogKvrhKPXO78OsMDf9ERaykL7bb2aQTFqR5Ew4Ntad7x8zrNxXsqeDmMU/RjSqa65/c
         6fkGQH+eMxtslF0H66IGNL+gPbK9a/vPhxT7dKxcBovPxLfhyrV8+EOyCClCHkm7eZeH
         0WelLAL9yUO8q760h6Sla6J0mqs+XBh1ABtayiKDmyLid7B5MrCIO5IwERKsFQ03ggB4
         l01ygPnva59/P49OTRDnv8y+7Ws2IZ7spcyU3v/ai8QkIpA8w0jKRx0Doj2chxAD0Fn7
         IhSg==
X-Gm-Message-State: APjAAAWSu+9CpFnL1Wgg0L1D14m7Uk6LPnvDlM7M9MZ2Xs3qlFDlQ0rF
        Zwk2YxwF+IM5Hs49wctYvsw=
X-Google-Smtp-Source: APXvYqxmYdyiEHAwhEfe49D9XpVmFYBRI7a3/7LC/SEYCOBepCEDYPjhOeSD7Up2X2PJwOHkWa9Lfw==
X-Received: by 2002:a63:4c5a:: with SMTP id m26mr14237469pgl.270.1567198913959;
        Fri, 30 Aug 2019 14:01:53 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id fa14sm5732456pjb.12.2019.08.30.14.01.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2019 14:01:53 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Shawn Guo <shawnguo@kernel.org>
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: dts: imx8mq: Add CAAM node
Date:   Fri, 30 Aug 2019 14:01:39 -0700
Message-Id: <20190830210139.7028-1-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
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
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---

Shawn:

Just a bit of a context: as per this thread
https://lore.kernel.org/linux-crypto/20190830131547.GA27480@gondor.apana.org.au/
I am hoping I can get and Ack from you for this patch, so it can go
via cryptodev tree.

Thanks,
Andrey Smirnov

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

