Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F8F9C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:23:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245349AbiDYU06 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245372AbiDYU0Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:26:16 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C69913137C
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:04 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id k36-20020a05600c1ca400b00393f18c8fc5so253845wms.4
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7MLyGA4WUDMi+Qf8y5tCaEOv26U6HFRODkGLHS/fFC8=;
        b=1DGhKkAlmKMj8VjnV3ep4FYXi7E1a5hXQPg4RCAOuYNXy5SdyEQnKSSbw6+ApsWwBv
         C5cYpKhEabT21nYudVPxZEmxpBPHGcdq4QIFXhS4Oor7QWGDt6WuXmBRzTJWz3jSJfcr
         +xMIrsGPlzHVgEh5KL4hYmmmXn/RGBfaKr98GkiMLXI6MlGTQnsQtnmnBHbPyUOyy1bj
         zdg1f8KDja2Lowt4UoTqs1On1ic1XDcb6B2MarKSebXtATBssNXRMfQNgQ5rNjuACKs0
         UGbF+bxuprQwjv7uPWkVNX5KMg9TQjw0/UZf1GUpPy8QB5ZSSZzDVTPK2Y7twFlr/5F/
         ZYRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7MLyGA4WUDMi+Qf8y5tCaEOv26U6HFRODkGLHS/fFC8=;
        b=ijMsZIy10eHFh+XqdzLxmAey3HKVrTehfCZSzsDA5osZdYaF7eggbRD/35F/03JG7V
         Aj00FiK+enNXr3Bc9K7BAIBbQB/4N/POFP1VeZRLzO5AEqVQIN5MkhCNxVCRdH492jEz
         voCFUMrvDtkuHsazP83aOXislpX+XRDNm++mYa1yqqX40QF3Pdotv9+DjZe8YN8zYcxI
         iSzr6mISv5daO5gIqPv3cfaDHkmy/c0aRUpOMPj2mlikQTN4D4udZhsMgg+8rstH9uQx
         DNvX41nCRugrtl3miZtUCe4LpIymn6o5bSW4NncdvEVghbHRY0brC+gxBbNKFc/a14Ru
         gq8Q==
X-Gm-Message-State: AOAM533mdU6YALfp+tWZbVau8UMTbb3bKTbNW98TJJXUX+8XvmUrfjj6
        5ZkO2UwJ2EHQ4ifEQukbdNy1cA==
X-Google-Smtp-Source: ABdhPJxtGcvDjSJow9NUiLdDEYv7ckDaPYq/azkLYCavmxyFb1xlL8kzUOm+RLN0ln3aPeHhQ7pADA==
X-Received: by 2002:a05:600c:4e4a:b0:392:88e1:74a7 with SMTP id e10-20020a05600c4e4a00b0039288e174a7mr27460256wmq.174.1650918113681;
        Mon, 25 Apr 2022 13:21:53 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:53 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 27/33] arm64: dts: rockchip: add rk3328 crypto node
Date:   Mon, 25 Apr 2022 20:21:13 +0000
Message-Id: <20220425202119.3566743-28-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
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
index b822533dc7f1..c23fa985e66d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -1007,6 +1007,17 @@ gic: interrupt-controller@ff811000 {
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

