Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3836DFA372B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 13:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E15021A49
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 13:34:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BIg43a4P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405447AbfJPNeI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 09:34:08 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34824 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405403AbfJPNd4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 09:33:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id y21so2810515wmi.0;
        Wed, 16 Oct 2019 06:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EVcGe0jhVemfS4F9ZaDSPVCJM3kLwDEzlwrCz/1Vhro=;
        b=BIg43a4PhnBN6aknYztJwMUcTY0MIAypkizEN//oN9dYCn9Fx6o5uPghISks+nlsiu
         iE9DOdnWOfzw95aUaB5vapQZO80vx49X6l6WLFhQzzo32sUYrutfl4b3xGaL+tbsAgt4
         c97yMteO5mTKnQbKtSqGkCnt1luJ4QtJrEbCx8uyxAUISzAT/P2CK9mP75qZtZZUqeuk
         94Mrm1MF8ac8ZC3XOMOZaeXaF9UjYAIuTkoRpKsa3O1c1b0+VJCch0E3Q5HkDXoOJslO
         RID3HC3Q/LqApR514VY+AQv564qkiUmq+JLCqib4mQXe+YbVvRPh9ppdOw+7TrZ7tZ3I
         neVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EVcGe0jhVemfS4F9ZaDSPVCJM3kLwDEzlwrCz/1Vhro=;
        b=UhpTTosO4tlEzewpHFGxM4HMWIpxSA9p41bY1438pN+0kVRWj2pfQwAgzt0OgDzr0w
         URWS2P8HTEhQuRAeGYHgF7mY9z/suVPxph4ODDPBDKgp6R5Uw3+eGfLNVj2i9G5DY4Ou
         A3nztedv6kh/rs/TneFlxonoZoFjpqDi/Nqur2z6sck1CcGJQvF5PSvmr7rPY6AXi292
         v94XP5GQSa7BSGtQt7mzffjHdY81Jl2UvSS7y9/YRuqOjnGbQrA1U5aPpMw3/mBi+7am
         dVQ0X42X4Uk/U2LfG/Kyt9dK8bnpLROq63L1qgKR7eEJlQqd0Yw5eJ5jVlK9oIoPDmaC
         05qw==
X-Gm-Message-State: APjAAAVN0BYzgysrqI2XjfoUVVi1c75v6tLP0u+l1SUx7Wjh4CJEX6oz
        SqG4kQMO+mxD7gBuKb5ugcg=
X-Google-Smtp-Source: APXvYqwGL6jmkbSgelGmHpLhCjNcVPYnOVsZM87fvj53cE9tOmTuLcQx6uR26uBy9cXoYbg1C35K1A==
X-Received: by 2002:a05:600c:1088:: with SMTP id e8mr3526355wmd.27.1571232834229;
        Wed, 16 Oct 2019 06:33:54 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id h17sm3139998wme.6.2019.10.16.06.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 06:33:53 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 3/4] ARM: dts: sun8i: a83t: Add Security System node
Date:   Wed, 16 Oct 2019 15:33:44 +0200
Message-Id: <20191016133345.9076-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016133345.9076-1-clabbe.montjoie@gmail.com>
References: <20191016133345.9076-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Security System is a hardware cryptographic accelerator that support
AES/MD5/SHA1/DES/3DES/PRNG/RSA algorithms.
It could be found on Allwinner SoC A80 and A83T

This patch add it on the Allwinner A83T SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-a83t.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
index 74bb053cf23c..0a6e9d92277c 100644
--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -583,6 +583,16 @@
 			reg = <0x1c14000 0x400>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-a83t-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&ccu RST_BUS_SS>;
+			reset-names = "bus";
+			clocks = <&ccu CLK_BUS_SS>, <&ccu CLK_SS>;
+			clock-names = "bus", "mod";
+		};
+
 		usb_otg: usb@1c19000 {
 			compatible = "allwinner,sun8i-a83t-musb",
 				     "allwinner,sun8i-a33-musb";
-- 
2.21.0

