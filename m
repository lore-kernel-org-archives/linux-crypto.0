Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 409FFC43334
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 09:07:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiGFJHp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 05:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiGFJGT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 05:06:19 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A31424F34
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 02:05:01 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id j7so8437196wmp.2
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2022 02:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QXNec13rQxx7mczo0Bb45Dl1W4/rRz+jQsRU4AeJnZM=;
        b=2KH0c9i5pRILecSD4cAr1i5IG81/CljsGJebd4GrlEu87GGF+p4iLvgg69UypD4DGA
         l545no2gU5djMfQXCkQ13fkRA6JgbOl04rIrM6ABTL0bmmCnR1jciczP2obeGis+6VaG
         v3YHDgcdTBNvuLmF7cDwpiCUQHw2E/SyNMjbz6/BHLG0R1x71jyIulfD0jboY1YyPPIM
         k9BAZp0vE4EF8p5/Xeho4rFX51MilcYI0SEO6UF+eTxIihL0BCZ5GdVEBIFl9mZV70m0
         m3hNv+FivGSRxvIYos1Wgq1x6JMp3lx9XVdmv+NO6xxmbgGCXd+0QaoI5xzy42DkYErn
         qIqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QXNec13rQxx7mczo0Bb45Dl1W4/rRz+jQsRU4AeJnZM=;
        b=rB9axCaIblg6aJqWPt7jz1b1Up8VA5ZQX7Ypb0Vnp5FyTGEy+ENnozPgVm3cLOoHA4
         58/f2CyBItDErzoOoRQ1VFhc93D9S+4efYM4DdZJJZbVOSJmtSDIFNS2KoWVblHz7yoJ
         MJxYUc76f8LX5c9Z1FS2RD1p6s/q7MdGegiHMsNQNDbZPMmKh/SYQ/8yxSl4jOGjOUth
         8V7NorTNQ5WeX74stTJfR2yEfw6sq8cxZblWifsFrq4/lgl9rq8sDwzEJ3RStbNBZSF1
         0Y782q1T4mt4UDC4cQ/9H1ULWIiOJKAmWN9+aEfYEjgHS5pCrZhaO0FocnYUkUuhd4wB
         q6Fg==
X-Gm-Message-State: AJIora/BBFUlxjjZLAdHu3Kzx1Uq2hFAOE8jM++8ixitUIji3d+OhSG3
        7JWlnsWWOy8kP5kchr77HIqeHQ==
X-Google-Smtp-Source: AGRyM1toIJ3bBwvAdPj3WgU9vUOPQT1BAvlEHJ5810B7GsO/4J25yaE+bYN0O90J2JbxvuU5axmchw==
X-Received: by 2002:a05:600c:3788:b0:3a0:4279:5142 with SMTP id o8-20020a05600c378800b003a042795142mr38248606wmr.21.1657098301075;
        Wed, 06 Jul 2022 02:05:01 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v11-20020adfe28b000000b0021d6ef34b2asm5230223wri.51.2022.07.06.02.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 02:05:00 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        john@metanate.com, didi.debian@cknow.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v8 27/33] arm64: dts: rockchip: add rk3328 crypto node
Date:   Wed,  6 Jul 2022 09:04:06 +0000
Message-Id: <20220706090412.806101-28-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220706090412.806101-1-clabbe@baylibre.com>
References: <20220706090412.806101-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

rk3328 has a crypto IP handled by the rk3288 crypto driver so adds a
node for it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 49ae15708a0b..96a7a777bae8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -1025,6 +1025,17 @@ gic: interrupt-controller@ff811000 {
 		      (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 	};
 
+	crypto: crypto@ff060000 {
+		compatible = "rockchip,rk3328-crypto";
+		reg = <0x0 0xff060000 0x0 0x4000>;
+		interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru HCLK_CRYPTO_MST>, <&cru HCLK_CRYPTO_SLV>,
+			 <&cru SCLK_CRYPTO>;
+		clock-names = "hclk_master", "hclk_slave", "sclk";
+		resets = <&cru SRST_CRYPTO>;
+		reset-names = "crypto-rst";
+	};
+
 	pinctrl: pinctrl {
 		compatible = "rockchip,rk3328-pinctrl";
 		rockchip,grf = <&grf>;
-- 
2.35.1

