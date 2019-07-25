Return-Path: <SRS0=g3pl=VW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EBBC41517
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 19:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5001229F9
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Jul 2019 19:43:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="jxH8gQG9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbfGYTnP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Jul 2019 15:43:15 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37410 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbfGYTnN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Jul 2019 15:43:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id f17so45728540wme.2
        for <linux-crypto@vger.kernel.org>; Thu, 25 Jul 2019 12:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fJc1atiQz5OEztuHQqSGjdoiIKBAFWAgorgVo68gaaQ=;
        b=jxH8gQG9+QwY+aN4xvMC+QDz2s4wMg21chw6VUnY+kxHdY2WvCjNGfGPBrhfBFzWED
         PqnVkdS5vFVbeJFcHbIl4afpzVwhUtRzuDyrEoleiOCY8EPfczuGBdd5zJEOqLykBeNY
         uAivAzxlDx9irmBuIlLER532F7awvAWTgiuRkWOstlaNGi28VPfD0AIaAiZLYqtC2bpS
         uwmIuM8W1TPTAVbn7HlUokavL3V8UtQ7RoYciJ5CmbASfsPgTscUXuDSOghTjyZZu1R6
         vPep7y8JFYDjYKwCIlHXGWO0SorSaNN9XjZrIqlhNr6MRD8w/bjWzjRbAfuvMLd5cNXH
         MLHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fJc1atiQz5OEztuHQqSGjdoiIKBAFWAgorgVo68gaaQ=;
        b=nLEyT23BuYQpUpt2k3VFVIO7iO1sa7fAvo6UPB4Vvb52NBq4iXUFnyuv6vUPlRbisT
         wt1ei7eoJXiFYh2VH8OVqY/sF6JiQsxM3Q9/25jodkHtLO0xdgtmYdv3hSKAyZRqMO8N
         RfZCNWRbuOX8+5I+rjewy64EBN6CIrWxheoJ6Ku/R9/ARgzAEdvxinaWyMAyFpNcJgh7
         xNKwdoK6NXa3DbO4Rn5XwIjCfdRw+YbVlOaNCi8oAdXRBC8iNbONBXNrbRQgVg+ZZEDk
         6wF5Bx7gdR8Fbj3mwENK1iWYRDLNcnxipS5i4KQR3iS4blGkI2vLE+iQMiE29kiaYw3V
         bp9w==
X-Gm-Message-State: APjAAAUGCQknpytDsHf9PjUfWrGHiKjHhdO8oI0nz6aJRf4M0ttEh6It
        LpgLJbSqT/LoGRVGFFmj9D+dHQ==
X-Google-Smtp-Source: APXvYqyQwu1nmcB4abCQ5zAFUj2iSjiM9xVcT8A6OcXmoRgvpTb6oyQWmgU37KVPZS42Kw0Z+zWV8g==
X-Received: by 2002:a1c:a7c6:: with SMTP id q189mr82252637wme.146.1564083790917;
        Thu, 25 Jul 2019 12:43:10 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id y16sm103410662wrg.85.2019.07.25.12.43.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 25 Jul 2019 12:43:10 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, baylibre-upstreaming@groups.io,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 4/4] ARM64: dts: amlogic: adds crypto hardware node
Date:   Thu, 25 Jul 2019 19:42:56 +0000
Message-Id: <1564083776-20540-5-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1564083776-20540-1-git-send-email-clabbe@baylibre.com>
References: <1564083776-20540-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds the GXL crypto hardware node for all GXL SoCs.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm64/boot/dts/amlogic/meson-gxl.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index c959456bacc6..fdcda12a7113 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -36,6 +36,17 @@
 				phys = <&usb3_phy>, <&usb2_phy0>, <&usb2_phy1>;
 			};
 		};
+
+		crypto: crypto@c883e000 {
+			compatible = "amlogic,gxl-crypto";
+			reg = <0x0 0xc883e000 0x0 0x36>;
+			interrupts = <GIC_SPI 188 IRQ_TYPE_EDGE_RISING>,
+				     <GIC_SPI 189 IRQ_TYPE_EDGE_RISING>;
+			clocks = <&clkc CLKID_BLKMV>;
+			clock-names = "blkmv";
+			status = "okay";
+		};
+
 	};
 };
 
-- 
2.21.0

