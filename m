Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88543C4321E
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Apr 2022 19:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238134AbiDMTO0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Apr 2022 15:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238136AbiDMTLt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Apr 2022 15:11:49 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E2D716F5
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:52 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id q20so1694331wmq.1
        for <linux-crypto@vger.kernel.org>; Wed, 13 Apr 2022 12:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7MLyGA4WUDMi+Qf8y5tCaEOv26U6HFRODkGLHS/fFC8=;
        b=0fnXMottDMHawO/G08dPtjRNELO7Z6wbMXWUyV9JBCKEbxGl1L07CPdlG/u469u6Ci
         dSYaA4Njd/hnbpaK3oWB6U3dgyhTTeMWN2izBvw70jPVaP9wDh1R0OLzzCpC+zJ3hnSu
         DkcIZIDycX4jt626uaocz4P6s0zTE0IFFFcU4SOLCz0mJVQHU1KkWvxHV66paQzR5ePE
         sgkwi6gGtR3bUFS/lcnQaJZtCOSV7gWHpQSBMw2FWB4/fxLocvman8Y8CvOD7J0lOOjr
         veu6RoNI9R3QFqF0jAO/ghChMFf9dnBdVnjEwHrgqnBs9BGXVCwud70/OlvTTJdxhAmW
         +hiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7MLyGA4WUDMi+Qf8y5tCaEOv26U6HFRODkGLHS/fFC8=;
        b=lj47SNFoSo8rGS6oDHuSyTk9S4MSM8BHXyPSefVI5jNxGhmFlMm+PAGJjapIYKgWdB
         zeCq5nQir70qtFNjZsxd9GMY3y1PfpPTgmiWoQHiFgXF4hBNcx5KSpNzwTiY/q4F4HRM
         //TYhUuj1T9iMspWxdsDSYpMidHUqOCzpTC+Co7Ydba3HhuHA7+teZTNoV8qp9w5Nnae
         aMbBAS4X2VsBHhNJnz69PqdW96XeR/+3cuQ27/FzvwwW7nzMSWRQi874KS3Cw/NaWAMq
         KQ1dU15aEE8lmjioPg3enWnTtQ701FtXVtFyeTLi5mkE3fac26gFXoOh5qZ/fHViPpOq
         qJYw==
X-Gm-Message-State: AOAM531WbVrOZ09qFhuE8tFWghEpnL3RIHaVaEMpy9mNdMRtGhJVsuIp
        qzkXwZGcJuvxRWuxZDzVat46Yw==
X-Google-Smtp-Source: ABdhPJz9DDjuscrfaJJ0xJ53yOFv+BYcHWFfJFxuo2CFhEIbsRQ6tHN5Qx+X/5f1JsOmdn8U5tUH9A==
X-Received: by 2002:a1c:f604:0:b0:38c:8ffd:dbb6 with SMTP id w4-20020a1cf604000000b0038c8ffddbb6mr154513wmc.43.1649876870996;
        Wed, 13 Apr 2022 12:07:50 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id o29-20020a05600c511d00b0038e3532b23csm3551852wms.15.2022.04.13.12.07.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 12:07:50 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v5 27/33] arm64: dts: rockchip: add rk3328 crypto node
Date:   Wed, 13 Apr 2022 19:07:07 +0000
Message-Id: <20220413190713.1427956-28-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220413190713.1427956-1-clabbe@baylibre.com>
References: <20220413190713.1427956-1-clabbe@baylibre.com>
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

