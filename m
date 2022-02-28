Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93BDAC4332F
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Feb 2022 19:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiB1TwX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Feb 2022 14:52:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiB1TwL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Feb 2022 14:52:11 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91CA10216D
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:51:00 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id q17so19121118edd.4
        for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2022 11:51:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Fkd5OgGZAYlE36QCfyuNvc5GmV+0MnZ1bSpfiAbg2cw=;
        b=JK0UxR8SULpByCcRzm2G2mLhbOG4xykXXoKOo615/erEm1wh4/Qdb0nI8qoCuj5IOg
         //zF3/xkExio5t4u7h0JGuVVrnPtro4rEjHcpnPlqQ3sb3Wdb5IGn0KY7d36oGFwvC3h
         jDOhMMfRC2DM+2qNxD0QocF8h1l/Iq70da74KrYxQiebHZWyI26VjHggnD8Sxi2o+D3F
         SMqlyIUrP1Hel5wlXVZbUKjj+As3G6ijk0spi8B6Ev/z7gsxhCkBFHetSHY4V9NqZZhd
         HiX6lYxpOua7x+1F1IsBo+kRVRMBXo3hUdq9qumD7B2axdycN6VMATakoOO06PvXb+eW
         1b2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Fkd5OgGZAYlE36QCfyuNvc5GmV+0MnZ1bSpfiAbg2cw=;
        b=p0Fy+jOecg/cDaZGQLo/tUaFsDijXZ4L/L+mkgZcFyAVMHJ30ofNuMpWh1YQY+8tFA
         tr6Z82a4AYM4j85FmJV+bMTmQg+Q5MkRRGhvFT9dycBCGKx/bLKfRCPzpfUUoAVqlHCb
         MWAirYOTbQ/zfC6n/1bsWKFemmlOds6bFzqiQbQA+EpPH07sssLDZxXWDO3gwsXKkf0y
         xLc39fjUaiv/GSbql9NDSBBEbyK5c6YOpVArx43Y+E7KUxx07LodHtS9Jm/slnlBSh2A
         eKFNNmuXIZxTsLZHMP2FunwByyXGDj+L90/PZ5E2LTd3m5iPkHUWrp7UlFyaCmRtNHqn
         54MA==
X-Gm-Message-State: AOAM530Ds+Bscj5dTkGB6jGv8rV0Hq5f3AHYUciToVEnvQtKQNcWDTe/
        2A4SVgI4AcqCngzDsqY6a4XLEktWwsRGKA==
X-Google-Smtp-Source: ABdhPJzC8b6GL7WHeAsFebTLadlGbKT2RHM3vC7SGbZuhx23oAACfoFrTCtSq4XVrdzPXpQC6LKoxA==
X-Received: by 2002:a5d:6f0f:0:b0:1ef:f983:3887 with SMTP id ay15-20020a5d6f0f000000b001eff9833887mr2058062wrb.526.1646077254609;
        Mon, 28 Feb 2022 11:40:54 -0800 (PST)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id v25-20020a05600c215900b0038117f41728sm274143wml.43.2022.02.28.11.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 11:40:54 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au,
        krzysztof.kozlowski@canonical.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 15/16] arm64: dts: rockchip: add rk3328 crypto node
Date:   Mon, 28 Feb 2022 19:40:36 +0000
Message-Id: <20220228194037.1600509-16-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220228194037.1600509-1-clabbe@baylibre.com>
References: <20220228194037.1600509-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

rk3328 has a crypto IP handled by the rk3288 crypto driver so adds a
node for it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index b822533dc7f1..b5b47ddc38f9 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -1007,6 +1007,18 @@ gic: interrupt-controller@ff811000 {
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
+		status = "okay";
+	};
+
 	pinctrl: pinctrl {
 		compatible = "rockchip,rk3328-pinctrl";
 		rockchip,grf = <&grf>;
-- 
2.34.1

