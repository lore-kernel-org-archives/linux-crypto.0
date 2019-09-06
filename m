Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4A8C00307
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D787C208C3
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZhrFxoH/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395388AbfIFSqN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 14:46:13 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40341 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395376AbfIFSqM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 14:46:12 -0400
Received: by mail-wr1-f65.google.com with SMTP id w13so7597887wru.7;
        Fri, 06 Sep 2019 11:46:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6gfPZRpIljPhV4Y76bqDwXphABtlmbrLYPaesl3pjCI=;
        b=ZhrFxoH/Go/p9mDemMia8OkzNhnhOPc3pjz+NcsRC2j4y/b2FxlHEx4JI6pFQy0591
         5dKC6539twpYGEEBLEixpHsXoY3A9qmMkHplxGPCYrps8CgvQNI0OwcF8f9GdHF72+HS
         4yDE06GGnbURNVBeChjpzi5N+D6lFsH4LobskCrGZ2NTTEXsELEuxBBeGPI5Um6IWuc/
         YCbM76t3XLK0cDZcGgRKd2h1JxU038SSQKQBuJAceVR+tTAAvsXVfkRIczqqGy5HptOu
         7RaTRWVYWuewASFlg3+W/7rRkSmk2Y5TcmjmddP2D3iO3Cl+H0S+GLhQYHWHAdPtn9lD
         G4wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6gfPZRpIljPhV4Y76bqDwXphABtlmbrLYPaesl3pjCI=;
        b=msZj72w29CyeVmvABNQscxSJzsbXL2ZrS9DUR3jPiGtO4i/cDHljuimgntOJNsUcIj
         PIuJNW4XyNTWp+vkl04cqJ/IMHXZ6Tqvqg84Bemt5acw/dhz0qCdKhhb04ohBNAjzipa
         9xQbb1FKgBBikwl+5rVGmX7Fcu6BcVd0VInik+Nbls46hcPa2boTCESOe9oQH60sbqIh
         4B6B+w/DCT9HFoLK4oTXIIGOCfrmFmNnDv2f2mdf9PXp/NdamVBYxEFa/JvnOon1dGqX
         TR8D5OKFOm8BpiDyUbwAUNqNSaxdJ23/r8pQnr7wjY0/zTW4Xo4auQFJPHU6hs37himh
         eC1g==
X-Gm-Message-State: APjAAAUXiRDC9zeNHm/suCRBvyRYg2qLeptvjl5x7k8m8gN10Gzui3Yi
        qsThtuWQc73GFMGc2gFu6P6G1Dr8
X-Google-Smtp-Source: APXvYqw3NjoNTVeM2qHMyiFQjvaRW2FdN8p50r5ozVUMwrqRJxmmaB+S5AyuSL/MHK/u6B6fQEleuA==
X-Received: by 2002:adf:e30e:: with SMTP id b14mr8399491wrj.168.1567795570676;
        Fri, 06 Sep 2019 11:46:10 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id j1sm8677577wrg.24.2019.09.06.11.46.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 11:46:10 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, mripard@kernel.org,
        robh+dt@kernel.org, wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 5/9] ARM: dts: sun8i: h3: Add Crypto Engine node
Date:   Fri,  6 Sep 2019 20:45:47 +0200
Message-Id: <20190906184551.17858-6-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic accelerator that supports
many algorithms.
It could be found on most Allwinner SoCs.

This patch enables the Crypto Engine on the Allwinner H3 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-h3.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index e37c30e811d3..873abe1b279b 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -153,6 +153,17 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-h3-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ce_ns";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "ahb";
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "ahb", "mod";
+		};
+
 		mali: gpu@1c40000 {
 			compatible = "allwinner,sun8i-h3-mali", "arm,mali-400";
 			reg = <0x01c40000 0x10000>;
-- 
2.21.0

