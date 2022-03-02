Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E2D5C4332F
	for <linux-crypto@archiver.kernel.org>; Wed,  2 Mar 2022 21:12:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245196AbiCBVMm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 2 Mar 2022 16:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245197AbiCBVMf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 2 Mar 2022 16:12:35 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0C5BDD96A
        for <linux-crypto@vger.kernel.org>; Wed,  2 Mar 2022 13:11:33 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id n14so4745198wrq.7
        for <linux-crypto@vger.kernel.org>; Wed, 02 Mar 2022 13:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n0XDEkVzi02ucM2UrKM/vf81RC1FXZtbtWIn7AE/m+k=;
        b=rBXJLVQ+DzeFYZA8QhKF2AMXUPBrtWLltHifuRhmlG1JCN0jnAtk/ZA+T1Aj3l9jc9
         f85Ap4pw9ux+2MzuABx5rl8AVBc217FhrlH8mTcV0EATNHcu+KeeS6h0h4fc4Jo8MnEr
         DTL3BEq8My1dbGGyMXK8hOrhqCX0DASswJRp43ti8p5S3G7+kNV60FnN+knWcoNm0CRX
         YM9tfeXAr5smwlBF3XkILda0NE1nU7LpdVJgFYgTzaYSKU9ibEm2kMENfSizNBdcKA5x
         SJI9cahqfrk4vKuK0ZbeZTCVNeG9Pt7v71rHHMZ3H8FlXCh1hJ0q8F6fxNnj1GiKw3Jo
         U/Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n0XDEkVzi02ucM2UrKM/vf81RC1FXZtbtWIn7AE/m+k=;
        b=0LCGsEt7kCxOMgbQqnHZ6L/Eq2jHQOGKqRcAaZNIB9DkPMgzAhxfNHiBaNonXsq64l
         FF8t2JbPI8s7KuwtQSsWEJCJE0LwOB4lMQBN6HQ+u0Gv44DJoS/P84Pv0LWq2wRWp5NV
         GIewU9+bqjhpY0iANSAIoC7g+08kM14vQdKwSh4PfExPjxCPDa3Gge/E5irFd871XyP1
         zOXpaf1p2zUWYPgZbHHwx5eqhgUUOTeGrLxyjPvA/Py2jGJu3riiyzvFkpvvu0J1nDnL
         zOZ/8itHYWuckZ7W0ji6yMcIAGo7cnGxnnJ/fCSVxZG3M8Z9jICbRfJ6KvonEDW6+wv3
         h0tA==
X-Gm-Message-State: AOAM530vWRU6hHYncfgcvXgTXeZZJnLKTc0PP3JTCxh39PV+hnZQm4Z2
        5qSjwfcO2UYoqglTc0M477btuQ==
X-Google-Smtp-Source: ABdhPJw2UkcLaqCfRGtB/0mkc9AHKUIrzibjI0BySUWdgGzJYan1i7squwY2t8DH6S75mqaTK9h5mw==
X-Received: by 2002:adf:f70a:0:b0:1ee:33bf:3864 with SMTP id r10-20020adff70a000000b001ee33bf3864mr22502025wrp.4.1646255492259;
        Wed, 02 Mar 2022 13:11:32 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z5-20020a05600c0a0500b0037fa93193a8sm145776wmp.44.2022.03.02.13.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Mar 2022 13:11:31 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org, john@metanate.com,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 12/18] ARM: dts: rk3288: crypto do not need dma clock
Date:   Wed,  2 Mar 2022 21:11:07 +0000
Message-Id: <20220302211113.4003816-13-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220302211113.4003816-1-clabbe@baylibre.com>
References: <20220302211113.4003816-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The DMA clock is already enabled by DMA and so crypto does not need to
handle it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 26b9bbe310af..64be7d4a2d39 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -976,8 +976,8 @@ crypto: crypto@ff8a0000 {
 		reg = <0x0 0xff8a0000 0x0 0x4000>;
 		interrupts = <GIC_SPI 48 IRQ_TYPE_LEVEL_HIGH>;
 		clocks = <&cru ACLK_CRYPTO>, <&cru HCLK_CRYPTO>,
-			 <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
-		clock-names = "aclk", "hclk", "sclk", "apb_pclk";
+			 <&cru SCLK_CRYPTO>;
+		clock-names = "aclk", "hclk", "sclk";
 		resets = <&cru SRST_CRYPTO>;
 		reset-names = "crypto-rst";
 	};
-- 
2.34.1

