Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D28C43217
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 21:12:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245218AbiCBVNb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245217AbiCBVMi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 16:12:38 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86C0EDEA1D
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 13:11:36 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id j17so4804048wrc.0
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 13:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yU7CqFvzpVzQFrP6rEr/Bhzc6ZJQDR+Dmhlj5y/OH6I=;
        b=TMtERDMNk0h49/DuSa3frpY0if0OvMgZ0PREwCrp1rvaLH3NAWecqH7EbcJiRNCXOU
         RgEzeLPbWEcp4lG4ZnM57udFNbTd+0IPsH3XxqsbMUWS3YK2k+o8zMcMFUH4ne9Eoz3U
         sGdy9FihjYCkwn6UC+xI6AdwIE1hQyljtN4cAkKQgjki9qoGOaNh8vkRN1Tajd8BAhP2
         dXy0LjokoRjBz6odSQJsFIUEOdKUwtf94XEoH3fJ/+JJnq0ze6fkZ78H4pjSteSt51a0
         /taWhgW61sNbOpia8hPuN8yqXQrp4YPBT0Zph5ymjRPA/FMK11fUyu//Sfq9B1+bsgns
         O75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yU7CqFvzpVzQFrP6rEr/Bhzc6ZJQDR+Dmhlj5y/OH6I=;
        b=I1kMR6wKzKEdyyFROlaNJXnNmNt1FFGYntBnbgjoy6HxmQX+z8pot8sh8nnAiZm+75
         NNJlENMBFqH6feuq37GYRAOFQhFMDWYFUGvOB9dVTMA9qg+0UjbSG48DoaWw9uQzMjPG
         ijFeaxcCDsydtK04KAO2Q91P8KyEBcudxTgMaYl+AYojBpw4Z9omeh5nRDBM7OYWFvyT
         Mmb5Y/OowXWwEe0LrhRhIbcUv0P4ScQci16eJCVCfFhxqIB6IXtzcoIlIrObhQK6ampo
         QCvLamSlDFp/y7+nd3SJHjrvne94DB2icmXKFE31JO+/z8WqPNJU2mPEYvYAQ1nwbTlk
         kPPg==
X-Gm-Message-State: AOAM5318vP/R1e0iEb8Fx2lxmQT2qyRnUuKExldhDs2V+UbqYlaA22qQ
        xuPigpNK1zJJOogVHZoZO8vqJQ==
X-Google-Smtp-Source: ABdhPJxFTOh58gQ2ndNAUkR0yVFJwyeB7NYgvg3saDQPoU8XkYmSDEmJ7uSqfjrhka3jzj9BoGoUAQ==
X-Received: by 2002:a05:6000:18a4:b0:1ef:f017:98f0 with SMTP id b4-20020a05600018a400b001eff01798f0mr10184765wri.39.1646255495146;
        Wed, 02 Mar 2022 13:11:35 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z5-20020a05600c0a0500b0037fa93193a8sm145776wmp.44.2022.03.02.13.11.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:11:34 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, john@metanate.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 16/18] arm64: dts: rockchip: add rk3328 crypto node
Date:   Wed,  2 Mar 2022 21:11:11 +0000
Message-Id: <20220302211113.4003816-17-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302211113.4003816-1-clabbe@baylibre.com>
References: <20220302211113.4003816-1-clabbe@baylibre.com>
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
index b822533dc7f1..1cff94e6ee10 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -1007,6 +1007,17 @@ gic: interrupt-controller@ff811000 {
 		      (GIC_CPU_MASK_SIMPLE(4) | IRQ_TYPE_LEVEL_HIGH)>;
 	};
 
+	crypto: crypto@ff060000 {
+		compatible = "rockchip,rk3288-crypto";
+		reg = <0x0 0xff060000 0x0 0x4000>;
+		interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&cru HCLK_CRYPTO_MST>, <&cru HCLK_CRYPTO_SLV>,
+			 <&cru SCLK_CRYPTO>;
+		clock-names = "aclk", "hclk", "sclk";
+		resets = <&cru SRST_CRYPTO>;
+		reset-names = "crypto-rst";
+	};
+
 	pinctrl: pinctrl {
 		compatible = "rockchip,rk3328-pinctrl";
 		rockchip,grf = <&grf>;
-- 
2.34.1

