Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B3DC433FE
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Apr 2022 20:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352094AbiDAUVy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Apr 2022 16:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352335AbiDAUVW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Apr 2022 16:21:22 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407B9F4F
        for <linux-crypto@vger.kernel.org>; Fri,  1 Apr 2022 13:18:35 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id a1so5765046wrh.10
        for <linux-crypto@vger.kernel.org>; Fri, 01 Apr 2022 13:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qnu62bJemS/jWg8J4I3N48ZBUGfR4KO6Vf9cdKvDqZI=;
        b=8TVf6qwBl0uHvhrV68CLdsiGsrTE4EUegwd1ikdA6z/qhYMFiO6FC/yl0QH0cUg+mS
         7aHD98hPOgUw0yGHMUPePkVSMeX/Pv822pWJN5/Q/nof2wZApIO0w/1YDrGxkXd077Ki
         AGAYeB9kJbKYwOR1ixFoqpKkgH8UEETuZwtA+O14p7ER+XBV84HDnsgNBp+jjokLu4B/
         plJkkZ/pLYKyYhNYSoUWqk6x5x2QOQmI/U5Hg2UjwMSgkWLRHDRhQzXoxa+WkYh3xJ6T
         4cIu8c4NI4pPTDGg9AiHr0lGuN/onYesvoW3VQwf5wnHBsgpUE6VcWNCIZcG4bn5HeIW
         UJ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qnu62bJemS/jWg8J4I3N48ZBUGfR4KO6Vf9cdKvDqZI=;
        b=zxwV7egZ/ceVTBth1Jg9gx/0zsMzjc4q7aX8jq4ISYp/dDGDEnBxT7nsNS0OsJLbN5
         VK3+V16yj3eyYHal8Sgk2XDUO3hVA3WE9I0NR/qHcwnq6MiodCUFOWMBg2g8fNRTH+YS
         PIa7SU0am/nTTTSzZC+P/CRkcOGxl0qRIUMP7bHFvD72nbNMD2SM3dg3BmZyHEK0U9l+
         GDDYKNgViC+dYEOwn91eA0UtbRY5XKKiqORDlrg80BglzR29ITD6NgI6lEZzFrwSdMU8
         1tkiaSooTux68VfEosktTWIBOV+3fVM0xEjLCAoLBX/509zRGVMQ8t4X67XUR2tluSKP
         UcLg==
X-Gm-Message-State: AOAM531bnfVVpkZxNOw0N1zn4Zpw6OVPnkLFzJFBf7H6nyLIe3HfYtG2
        PwPIUPFv//Wyemayv1jVk49aAw==
X-Google-Smtp-Source: ABdhPJyzMnqRZxBp1VScKUGrqBnHjZLNhiPrB1uY3/f7ItRkGi4AfEMDThcmsWoiphNLREoBcSKQJQ==
X-Received: by 2002:a5d:64e7:0:b0:205:8b74:8db7 with SMTP id g7-20020a5d64e7000000b002058b748db7mr8794143wri.34.1648844314215;
        Fri, 01 Apr 2022 13:18:34 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id j16-20020a05600c191000b0038ca3500494sm17823838wmq.27.2022.04.01.13.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Apr 2022 13:18:33 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v4 32/33] arm64: dts: rockchip: rk3399: add crypto node
Date:   Fri,  1 Apr 2022 20:18:03 +0000
Message-Id: <20220401201804.2867154-33-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220401201804.2867154-1-clabbe@baylibre.com>
References: <20220401201804.2867154-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rk3399 has a crypto IP handled by the rk3288 crypto driver so adds a
node for it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 88f26d89eea1..2f355de14fce 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -573,6 +573,24 @@ saradc: saradc@ff100000 {
 		status = "disabled";
 	};
 
+	crypto0: crypto@ff8b0000 {
+		compatible = "rockchip,rk3399-crypto0";
+		reg = <0x0 0xff8b0000 0x0 0x4000>;
+		interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH 0>;
+		clocks = <&cru HCLK_M_CRYPTO0>, <&cru HCLK_S_CRYPTO0>, <&cru SCLK_CRYPTO0>;
+		clock-names = "hclk_master", "hclk_slave", "sclk";
+		resets = <&cru SRST_CRYPTO0>, <&cru SRST_CRYPTO0_S>, <&cru SRST_CRYPTO0_M>;
+	};
+
+	crypto1: crypto@ff8b8000 {
+		compatible = "rockchip,rk3399-crypto1";
+		reg = <0x0 0xff8b8000 0x0 0x4000>;
+		interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH 0>;
+		clocks = <&cru HCLK_M_CRYPTO1>, <&cru HCLK_S_CRYPTO1>, <&cru SCLK_CRYPTO1>;
+		clock-names = "hclk_master", "hclk_slave", "sclk";
+		resets = <&cru SRST_CRYPTO1>, <&cru SRST_CRYPTO1_S>, <&cru SRST_CRYPTO1_M>;
+	};
+
 	i2c1: i2c@ff110000 {
 		compatible = "rockchip,rk3399-i2c";
 		reg = <0x0 0xff110000 0x0 0x1000>;
-- 
2.35.1

