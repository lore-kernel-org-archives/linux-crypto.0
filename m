Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099B5C433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Apr 2022 20:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245333AbiDYU04 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Apr 2022 16:26:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245370AbiDYU0Q (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Apr 2022 16:26:16 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D7C131CED
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:05 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id n32-20020a05600c3ba000b00393ea7192faso258874wms.2
        for <linux-crypto@vger.kernel.org>; Mon, 25 Apr 2022 13:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=X4PiWPA2z+YwiPjwmkViEPpFlveGzLMoVQh4AfeqXKE=;
        b=Qg1O2zSUnx2ygBmjovdhwaM7vW9gnnEAw3GRJ4lBZwTX75TRGOMiYJoySJqWBipp5Z
         MKRamTDF25d2ASVhsQfG6tCR145SE+548nJHkJEx00FuqVJ10ylltJiEC7iUcH6v2CH/
         Zqsq954ZLyfe0fdH/cRuRjSewsNcETaEpjPllFdahMmuz8CxAI8GnXMgZxXbGnCllBxj
         f682bYJHmquE0I4aBl1kSwmhL1kroEK2+dvoaDJTD/m6VRrv0irtflo4QWekYEBQCkW5
         GA/CfL04y+lo/FK5okHXfXu/V9ivmpTnTrUtYaWOzCD95+LxvB04QO/vG4gonFiYvcfX
         xHrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X4PiWPA2z+YwiPjwmkViEPpFlveGzLMoVQh4AfeqXKE=;
        b=1eEENEYbiFbDA5mDlGs9aO72UKru0rWFD10GHdhuuLgfD+Fu8VZhtDpeuANKcQ9xS6
         hUvwc6obhR7UUzUSiBueC9MiN+qml5qScTCsZBjWE3e/RNQ6aaMBi9dszEuFiA2NHIkJ
         +crdnF4PxEzujvW9Suaojzgkjyfc+eUFt7H+q61jOJCbAjB2KdXZTj1dySeE/iN3tqxX
         kXYupw5bvI2iQF+4wztmvZRuzsClLcG08VMZsljp41JgaBGYm6LMK/KVTFztAnYr8CLI
         /sJ82UI9mx0RGFTcrWsY5BbeMHqheIBKAce6d/+cSet7J94WR0JsrPFjEhtR4VtSB01d
         7iAQ==
X-Gm-Message-State: AOAM530gYFbpYhb0HBvjNOtQzdnmq/s8HEYSiRIZ5lK5TmbSququUMpk
        +Paq/c0/e8F8eMp6BIaPu6mIeA==
X-Google-Smtp-Source: ABdhPJzrD0nES3DLaCfKsbFatbnjfGfnZ61YdcgcPshkhinZzFOeQEiHBkt/Y/5AVAXrlqcsVjOwXQ==
X-Received: by 2002:a7b:c403:0:b0:38e:7c57:9af7 with SMTP id k3-20020a7bc403000000b0038e7c579af7mr17529379wmi.144.1650918114629;
        Mon, 25 Apr 2022 13:21:54 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id p3-20020a5d59a3000000b0020a9132d1fbsm11101003wrr.37.2022.04.25.13.21.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 13:21:54 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v6 28/33] arm64: dts: rockchip: rk3399: add crypto node
Date:   Mon, 25 Apr 2022 20:21:14 +0000
Message-Id: <20220425202119.3566743-29-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220425202119.3566743-1-clabbe@baylibre.com>
References: <20220425202119.3566743-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The rk3399 has a crypto IP handled by the rk3288 crypto driver so adds a
node for it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index a90beec50f6a..b9b16008813e 100644
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

