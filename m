Return-Path: <SRS0=Oe9a=X2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299E6ECE587
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 007C32190F
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NSzQeSer"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfJASmB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:42:01 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45946 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbfJASl6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 14:41:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so16713513wrm.12;
        Tue, 01 Oct 2019 11:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3uq19lbLKTH7ULR+B4YPbGht8xy9goJU2ZUfKOHR3wQ=;
        b=NSzQeSer4vnSEkVbCTPNiopU9iCEDjshU9Pk3d3lgXHtQ/q9dkbVaIdEQwOOU01b5A
         qtGJubL3DC5GGKNA4fEmdobaynyTVwbhHeXo1cNSDHV+3nl/J4aA8pIt/obMKHbRl59x
         9q+V28cQjDmzhltMzLLPepfh0hULxmYvG/ljZx/RsbB1m5pMoWly7i60mQiOiAcHi50c
         V+c/Z+Ixy5hTC0O0yxuxciMP3Mlj2j2thjGZccW7GhDhNyyur23V1f6nufbCsmxk1483
         2HEPKkZmRpRgvPrVkdMB1dg6J45fvT27kbF12jN0/IOjuUEL0KDOvXanNHJAHg4Ft4TA
         yTdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3uq19lbLKTH7ULR+B4YPbGht8xy9goJU2ZUfKOHR3wQ=;
        b=cViAXKElZrlWebn+6KlPD2b6bva7NfNH8N6acIiSBLu1MJLEPkYanHjpJ1vdxepWbr
         RtY3nmeWJkXTJor7kmYlYweqREKpYpvkeVlX0gLY/LlE3/M4bD6Qi8s3rKYOiJctpvPO
         mK+1Ik0GshohaJ2NGLpbu7/Cl6xwShCjhfLHZQpk/9n+zUjly4x/TN+UYLMOa8ARcQPv
         j3e5fbYrMFdDt4UknKLaJ5ABnyD9rPXz+ZM3webhn4ZYLU+ECLsBcPVznyXf9wwX9r1P
         kEXkcW54dXsrAoz9hpoggkGBElvP5uLSR6pjeVroMYA87FSrPYJn9u1Ra/NvbbEdH2IU
         cFyw==
X-Gm-Message-State: APjAAAUzZpDIggyroOit515F3TNUPlCsRoB3aYgGJDUfwGzP7Vf7x5mr
        eFmbbRd6AKEJe6TvIuJlCn4=
X-Google-Smtp-Source: APXvYqw5DtaeOTom50F4g2+RllhYAoQlDrhsjYJqz11Rf7j20PRRU7AcKZKoZcWY54Msno5tG8bulw==
X-Received: by 2002:a5d:618a:: with SMTP id j10mr18178611wru.168.1569955316364;
        Tue, 01 Oct 2019 11:41:56 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n8sm6788987wma.7.2019.10.01.11.41.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:41:55 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 06/11] ARM64: dts: allwinner: sun50i: Add Crypto Engine node on A64
Date:   Tue,  1 Oct 2019 20:41:36 +0200
Message-Id: <20191001184141.27956-7-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic accelerator that supports
many algorithms.
It could be found on most Allwinner SoCs.

This patch enables the Crypto Engine on the Allwinner A64 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 69128a6dfc46..9701d4280f6d 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -487,6 +487,16 @@
 			reg = <0x1c14000 0x400>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun50i-a64-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "bus";
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+		};
+
 		usb_otg: usb@1c19000 {
 			compatible = "allwinner,sun8i-a33-musb";
 			reg = <0x01c19000 0x0400>;
-- 
2.21.0

