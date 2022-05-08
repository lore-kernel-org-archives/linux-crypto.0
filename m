Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 918E6C43217
	for <linux-crypto@archiver.kernel.org>; Sun,  8 May 2022 19:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbiEHTWf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 8 May 2022 15:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237799AbiEHTEh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 May 2022 15:04:37 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEFF3D52
        for <linux-crypto@vger.kernel.org>; Sun,  8 May 2022 12:00:33 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id i5so16691512wrc.13
        for <linux-crypto@vger.kernel.org>; Sun, 08 May 2022 12:00:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QXNec13rQxx7mczo0Bb45Dl1W4/rRz+jQsRU4AeJnZM=;
        b=wUr00ZVSqJpz+TyFKEJpVL8SSj99SWOx9rBv/+AadNhGy7IgbkLHzAVN3kbxtYswNz
         5qrRS+RtbXGOkyzCO8qd6u+DzNXbqjZ87DXKCwIVDmbo+EWAJL0DsTNqYH1/uwPs+iOZ
         ajChSXEeTaJ1ogyzzIEumF7KNK1vwHTDFdbjvGS0Tbrx1yB1G4dofkhpftaveMv43QIA
         ItmpiorZ+4dpwR1KJFmI/QOXWoPBiqw2kbR9ioAB8v6XAil76TnJOtNqS2LdHQ3V9c7B
         511Btxxc7s2EQ5xe5D18btxiaHH2POZKJyx/NAz2yJc1hVDeZnJyP84NWN5AfxHNaUTb
         SkpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QXNec13rQxx7mczo0Bb45Dl1W4/rRz+jQsRU4AeJnZM=;
        b=spYTvlwx1Se8SepLSBp51kmzMX9A8gIrNiZy9+7nHO6IcmJIkqFgS27wZo94Fq9pg1
         S9kMfYSF5FuUtEIY2uUgw9uozjvxan7Ig0kUvdsZbSlOD8yvNOPQRvQ01EkNzAFbA5IV
         p5nY1F/dA1jOAhoqVO7jYhJr7w65V/W64Xg9YZPmsBMHt2nRhfkZBKXWiJ6vHRz0EvQU
         OyE7qhtBzthVs21R4mFZo3SCE9qNyQg2ftkymdmGygJaPBRzsSyjIrn/kPMHcGIN9Ug9
         aO2WqXpNeFkDwUjDLqKzN8hB1v/uOMnrDqpN2WU0/gdrOloF54gBrr3F3QldFQE4cV6s
         Lk3g==
X-Gm-Message-State: AOAM530m7YKg38LOyF3uxMYkurfB4eYXveSFo9wv4fjTacafSKBdVhz1
        pClU1mxIZ5I2c4GaFcOlU58f+Q==
X-Google-Smtp-Source: ABdhPJw5/UtIGu2Yl12LM79WcJ9WSawC8kvSOoNJwfXQAFHnRUIB1UugWPZEeX61eLTAcOF9ZKNTGQ==
X-Received: by 2002:a5d:6f01:0:b0:20c:660c:7c60 with SMTP id ay1-20020a5d6f01000000b0020c660c7c60mr10958778wrb.340.1652036433590;
        Sun, 08 May 2022 12:00:33 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id n16-20020a05600c3b9000b00394699f803dsm10552348wms.46.2022.05.08.12.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 May 2022 12:00:33 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, ardb@kernel.org, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v7 27/33] arm64: dts: rockchip: add rk3328 crypto node
Date:   Sun,  8 May 2022 18:59:51 +0000
Message-Id: <20220508185957.3629088-28-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220508185957.3629088-1-clabbe@baylibre.com>
References: <20220508185957.3629088-1-clabbe@baylibre.com>
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

