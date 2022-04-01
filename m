Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B996C433EF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347005AbiDAUVi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352311AbiDAUVU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:21:20 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7757273816
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:34 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id r83-20020a1c4456000000b0038ccb70e239so404757wma.3
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VA7lZMI09hkOCb1t1NHcSXDJ/Ud3y9Ws6eCmnd6/DnA=;
        b=60OrDdyHjp9nw+P2Yzcqqx/E/Pf+kRyXjdFpsyRPOyvM6np5kSCIQc5xQApkaVXTiJ
         /VCbx5f9uVjXCF0l8q84Jmztm6ft5y2Sl1mV7i6eg9MfD3VnM8I6aYjn+K4IdglVHoWz
         Vukn604MC0kR9iOZr8PJn701uyNYGY5v/AoVtCcem0cMc05HVEKkBNbLhhIMZy/HM8CW
         BSh0Pn/EMal7uQpN94+YQHP55CTevQ0EWTIUGwUE7lM7So8uWKheD/9gosk27ScdYxom
         OXpXRuwutGvJPJxvuFRdlKLDBT92QezXn1w0HVh6+FR6v/b8f5lEPbWgh2Bw8X8Ujc42
         QRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VA7lZMI09hkOCb1t1NHcSXDJ/Ud3y9Ws6eCmnd6/DnA=;
        b=QWXMbDQN09pfyBq4K5cGblArDsZBby8+bVCwMmq5ABcLby7h4uEVB1/WWMGd2XUBqt
         tlGcQBQoH0QpzOEpWa9csqY/zEXZ0hmFPgwllRl90HiYczJOkdXF9Jf+z0m8omO1mAb2
         XmGy2/WQS4lKmxXQT8SqWXPTeA0E9r+GBHhGsoxpnenLiTVOlUh0O3vvdP2/Up/1jIBj
         7og/n65iUUsroGwNs1FI+5okA6OSJe307U6Lhvh1srwbyiCJadaeyNK5bBzyuMpnFHT2
         DUGSNVWaTTPjM1QC7XcO9MAt/kZWkAkFEXXhPpGnxsYtB94uDacVinnksJmB+HaIDrc3
         pmnQ==
X-Gm-Message-State: AOAM532dMMuOXJgoJ/GvSwJbAoAeFdTl3UK4R5WsD9D7j3F1aYbhbtfe
        /gcdj4FoAtmTPUkox1DSMfUljg==
X-Google-Smtp-Source: ABdhPJw3yPQvgsyzsSWukxXTGlj1tGCN0xmAmlFqgEF+EK3zw6qbwSFpfb6GYMFhvcLr45hmF5BUtg==
X-Received: by 2002:a05:600c:154b:b0:38c:ca19:357d with SMTP id f11-20020a05600c154b00b0038cca19357dmr10443719wmg.51.1648844312844;
        Fri, 01 Apr 2022 13:18:32 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:32 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 30/33] ARM: dts: rk3288: crypto does not need reset-names anymore
Date:   Fri,  1 Apr 2022 20:18:01 +0000
Message-Id: <20220401201804.2867154-31-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401201804.2867154-1-clabbe@baylibre.com>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

reset-names are not necessary anymore for the crypto node.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm/boot/dts/rk3288.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 26b9bbe310af..50f0890b3f6e 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -979,7 +979,6 @@ crypto: crypto@ff8a0000 {
 			 <&cru SCLK_CRYPTO>, <&cru ACLK_DMAC1>;
 		clock-names = "aclk", "hclk", "sclk", "apb_pclk";
 		resets = <&cru SRST_CRYPTO>;
-		reset-names = "crypto-rst";
 	};
 
 	iep_mmu: iommu@ff900800 {
-- 
2.35.1

