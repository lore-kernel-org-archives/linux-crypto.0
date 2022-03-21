Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3DFC433FE
	for <linux-crypto@archiver.kernel.org>; Mon, 21 Mar 2022 20:09:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353120AbiCUUKg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 21 Mar 2022 16:10:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353041AbiCUUJw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 21 Mar 2022 16:09:52 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E643182AE3
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:08:05 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id r13so7178987wrr.9
        for <linux-crypto@vger.kernel.org>; Mon, 21 Mar 2022 13:08:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ALP0rhmdyOFskfZyrCUywCyi9ACOSmK3EYQ8ApiRER4=;
        b=PgoKWs6BqTd0YVwXlKBTcyBVNt7mdUfOIGxdK2fjBUMqsY8QYZujGa40w7xZBZA/yp
         esIJw6J9JSeWIhA+U6x2mYwng+KEadRC1WZHfCqjm0WL/XS3cQcbxVphfXFhjW7U03L4
         SNF/O75AKTknPDP2nfoWBmQEH5lTIMm9DWh1VCa4ZX7nP/eynUi5fmB0QP30fkDj7k5Z
         sAtqVOVA9VEEw36jbB62quDplN0EFDiUtJ9Una41golcgA5MfXd7pzSuAvzbkakLaeaf
         SE/tp7FpbXGtBq8Vd2tcXJI8tzVejLR3DGCuOlBj9FPXxChNf47ychi8mDpXDCqNpLEZ
         /Olg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ALP0rhmdyOFskfZyrCUywCyi9ACOSmK3EYQ8ApiRER4=;
        b=1PaH9ZMF2+/4QykA/n5YCb+6bgShKyGrSv1alKslK/Wnaq1StdRVeOUHf9fapqB5Rg
         WSAlFSr0Zk0iZdqKE3fRek3GW9dJBVhIKHVTgtENW9pF7sDAmsFaGhdG6Ct5yB22HO5O
         OxQ1QVieDfjvowwhTH3Sj9pb9eLDbpIsM2mJ4wZX5WVWht5aVd0i5B9U6ejRzovQlPLk
         1tGq2mEZrFeax0sRT0FWBFyYIfFo+iUesygUQiM7q16WdipW0q0DY2ieset9JdSJ46E9
         YPm4VLlyaI5bZxmagghmJHXCYjGLWsz98KTrIccErny9yhmqLqymilbFnzuocmLyyh1L
         63TQ==
X-Gm-Message-State: AOAM5334sNQHGY/Il0ZScvDn3gwJN5C3UYeSIWD1gFgovu+Vi7fTAgyo
        YPZQbf5FyXa5bZl699R6vbfHqQ==
X-Google-Smtp-Source: ABdhPJzDjnGj7IJraPSCtEXEfN9Mb8TcdmAUQ8cWd4O9rEnCAZpJ5de3D55tdtOi3oK+SbIlHh7IFg==
X-Received: by 2002:adf:8128:0:b0:203:e32d:4d03 with SMTP id 37-20020adf8128000000b00203e32d4d03mr19172030wrm.540.1647893284321;
        Mon, 21 Mar 2022 13:08:04 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id i14-20020a0560001ace00b00203da1fa749sm24426988wry.72.2022.03.21.13.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 13:08:04 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org, sboyd@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 19/26] arm64: dts: rockchip: add rk3328 crypto node
Date:   Mon, 21 Mar 2022 20:07:32 +0000
Message-Id: <20220321200739.3572792-20-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220321200739.3572792-1-clabbe@baylibre.com>
References: <20220321200739.3572792-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

rk3328 has a crypto IP handled by the rk3288 crypto driver so adds a
node for it.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index b822533dc7f1..e83e0bf7e517 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -1007,6 +1007,16 @@ gic: interrupt-controller@ff811000 {
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
+	};
+
 	pinctrl: pinctrl {
 		compatible = "rockchip,rk3328-pinctrl";
 		rockchip,grf = <&grf>;
-- 
2.34.1

