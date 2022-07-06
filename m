Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFDBCCA482
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Jul 2022 09:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiGFJHq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Jul 2022 05:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiGFJGU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Jul 2022 05:06:20 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E94B24F38
        for <linux-crypto@vger.kernel.org>; Wed,  6 Jul 2022 02:05:02 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id c131-20020a1c3589000000b003a19b2bce36so5597228wma.4
        for <linux-crypto@vger.kernel.org>; Wed, 06 Jul 2022 02:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rj/Na2p2CdSqeZMTsRP9N7r+JNYd47iwYks0u+hdyhY=;
        b=mKtq9ve1yeoQVoxcX9vU8Kzc4lD26BfGnICxDQSTU+FaPGF//iOE0yhM54oCSAigK9
         nw9+9IBaikZ7fIBfJL5/xRtLdv6VunAaQ1NIogOf9pia8Ily3Ben5QVis32InM4k/D5T
         AfSj67218HVN2+GtVGePlqM0jgo2354uQNXUsMyuZAioIP9MGKGscKVmvyklsbm3pcON
         /aKvGA8XIweKLAH1x5YWdI/17e9p+Wtui1phg0hDbSSYqdPcnc4L6WRBNE+otZiCFUvK
         JXdJofacBazG0blo5TNTGr+Z/z30kJwYylSc0JUYrIBbnTaLTKIAVKYdnWsrhvS09EC+
         G5kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rj/Na2p2CdSqeZMTsRP9N7r+JNYd47iwYks0u+hdyhY=;
        b=bAR/KpQAaF3yklupYJaSjNJkZF7cEW/B7HhMPOLYr7ps4lsvtV89idcoMg4wFAALg+
         LXWrA8V31OEBOB/XMx3wpz6zd2RFSHqyw7oNxeSIMZTm6HcDFyoTaIRlSPmR59P/+gt5
         1o8JSs+WziwB13fDNpf+HHkUbXNRr3FCjcJ3k88wenHAysBrr99GUJqLbav+O6Ww/jE1
         ysX1xr7cTkpbvyXOm/hUvp3uQXkzXaKIInLKGrGUDrW9S9YHSZ8dm3KuN7PqnXoQOIoW
         kY+hePzZVtXhurH27l1ZQo1ztYYWqMBYO5Mj2WGF4z34C09ALvJwPr928UZZC0QkeBD1
         uCnA==
X-Gm-Message-State: AJIora/P6ElaUYQPjsTc6vQhodj9zp79n3fVLEhzLaB1ocKyFgGALLoB
        nrP/jf8hXaAnPoIbLOOGr6j4Jw==
X-Google-Smtp-Source: AGRyM1sAnoPrBg6uJutH5ajAxHTIlpAdgFxVpIOIcQSoVgdpXp9s7DoczGILgzfePMiGZltE3rbq0A==
X-Received: by 2002:a05:600c:a18d:b0:3a0:2c9a:b3de with SMTP id id13-20020a05600ca18d00b003a02c9ab3demr40212216wmb.147.1657098302032;
        Wed, 06 Jul 2022 02:05:02 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v11-20020adfe28b000000b0021d6ef34b2asm5230223wri.51.2022.07.06.02.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 02:05:01 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        p.zabel@pengutronix.de, robh+dt@kernel.org, sboyd@kernel.org
Cc:     linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        john@metanate.com, didi.debian@cknow.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v8 28/33] arm64: dts: rockchip: rk3399: add crypto node
Date:   Wed,  6 Jul 2022 09:04:07 +0000
Message-Id: <20220706090412.806101-29-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220706090412.806101-1-clabbe@baylibre.com>
References: <20220706090412.806101-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rk3399 has a crypto IP handled by the rk3288 crypto driver so adds a
node for it.

Tested-by Diederik de Haas <didi.debian@cknow.org>
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 9d5b0e8c9cca..8e5aa1ca62d1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -582,6 +582,26 @@ saradc: saradc@ff100000 {
 		status = "disabled";
 	};
 
+	crypto0: crypto@ff8b0000 {
+		compatible = "rockchip,rk3399-crypto";
+		reg = <0x0 0xff8b0000 0x0 0x4000>;
+		interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH 0>;
+		clocks = <&cru HCLK_M_CRYPTO0>, <&cru HCLK_S_CRYPTO0>, <&cru SCLK_CRYPTO0>;
+		clock-names = "hclk_master", "hclk_slave", "sclk";
+		resets = <&cru SRST_CRYPTO0>, <&cru SRST_CRYPTO0_S>, <&cru SRST_CRYPTO0_M>;
+		reset-names = "rst_master", "rst_slave", "crypto-rst";
+	};
+
+	crypto1: crypto@ff8b8000 {
+		compatible = "rockchip,rk3399-crypto";
+		reg = <0x0 0xff8b8000 0x0 0x4000>;
+		interrupts = <GIC_SPI 135 IRQ_TYPE_LEVEL_HIGH 0>;
+		clocks = <&cru HCLK_M_CRYPTO1>, <&cru HCLK_S_CRYPTO1>, <&cru SCLK_CRYPTO1>;
+		clock-names = "hclk_master", "hclk_slave", "sclk";
+		resets = <&cru SRST_CRYPTO1>, <&cru SRST_CRYPTO1_S>, <&cru SRST_CRYPTO1_M>;
+		reset-names = "rst_master", "rst_slave", "crypto-rst";
+	};
+
 	i2c1: i2c@ff110000 {
 		compatible = "rockchip,rk3399-i2c";
 		reg = <0x0 0xff110000 0x0 0x1000>;
-- 
2.35.1

