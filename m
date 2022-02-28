Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 239FEC433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 19:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbiB1Tul (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiB1TuV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 14:50:21 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7027EF7BD
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:48:42 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id k29-20020a05600c1c9d00b003817fdc0f00so92531wms.4
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:48:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n0XDEkVzi02ucM2UrKM/vf81RC1FXZtbtWIn7AE/m+k=;
        b=Dg/YhTchN/dzit9dPs906M4E2c8W9YbYDdJDkUr+sgVevUcFyxD1MKfKC4NCejyEV3
         4uooanL4NNVwCzcV0SMou47PR33uiMQn0iqzquGP8ILqcc/7MU0lAHcAl7U1qkAr9qpJ
         SlqOFUJLzEBZ9XD28j/6CndjNKuVW422jLD3SbyONOO4fQafuu7NYo9xNXGz/R9HjWmO
         RIEGNQVlAfpbMe8Ak/5lZAMLzj0ddUiKlni1mDB8z6/yvOPsBSuoB+6udugXRuGDm1R3
         kpL7K1PNtOpgxJvF/8DJ4aq7Gkg5MU6NmxkxgaI6OnnZ7TeMU5jFkn7Un7SyZRFwhbSo
         68Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n0XDEkVzi02ucM2UrKM/vf81RC1FXZtbtWIn7AE/m+k=;
        b=upZnqiawZ/A7uZr6F7bFXaUN8eGtMLIkufcavUND6DWqPFfEbO9Q15n7E/ugvO3vXi
         jQZTL+WWO9kl37dNOHqCihjQtXMnC/lEF60v7dDFHIoVwCjB8A1HCCuayc9qxflM6p5m
         oKbCwU2iBifyit68XA9eFTUkxC2HInzzyES8BdLgm+Ak/vRde5X92m83aQN8OFwWkkpH
         OCw5GY/rJ/aYz+Jx6cV2NsxWAN+xH5uYFLgkUFJgIVdi+ixG4p52xmcmtXBFsurlAnLF
         3uUceP8xTu1LIifaD85NvCb0OgWXtUmNhoAQ7wGODGcATx8VoPc7YFByWk68ZL1F9+Ke
         e2nw==
X-Gm-Message-State: AOAM531oZzAaIKe+oYlSRpo/n+Zy8gr4XJS9YAS1HioJk48H7POVtfSA
        IXbrgiIIZtdkYnGSdi9hCNMgvtPHxE6g8A==
X-Google-Smtp-Source: ABdhPJwkZpmQZMj24miJa4rIAkZ9zDJCidU+xH/RIv5ZF56eOWbqUySS6AbKxsXIgvWROOl6Z6N/1A==
X-Received: by 2002:a05:600c:198f:b0:380:fa8f:be22 with SMTP id t15-20020a05600c198f00b00380fa8fbe22mr14268130wmq.43.1646077252461;
        Mon, 28 Feb 2022 11:40:52 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v25-20020a05600c215900b0038117f41728sm274143wml.43.2022.02.28.11.40.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 11:40:52 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 12/16] ARM: dts: rk3288: crypto do not need dma clock
Date:   Mon, 28 Feb 2022 19:40:33 +0000
Message-Id: <20220228194037.1600509-13-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228194037.1600509-1-clabbe@baylibre.com>
References: <20220228194037.1600509-1-clabbe@baylibre.com>
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

