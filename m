Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98B13CA9EBB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EF2F21928
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tsIat0Pt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407362AbfJWUFc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:05:32 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51081 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407347AbfJWUFb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:05:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id q13so285418wmj.0;
        Wed, 23 Oct 2019 13:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sqDLE8eOD/jzuEBYGSJJdfRbfHzmSxgCPCd3m6sI5BM=;
        b=tsIat0PtYMzoaRXAbHNswipgHePXIEf+lasJhy3OOouU5mO+Ga3jYHl6h58jX1eoc5
         i0QzCsw2HjI3m7KzimnttZo4pRMU9dd8FYXb7hOg/pkafULQC9Na2qcLMCGftIbCKmgj
         eFTTGDphdvClIaULuHcN9XmyoGadqhrCsOByzbGRTaSmKL5cyo3J/IWeCIj+sld+wgj9
         zHfcSSApN0TuxKAX1GbuA6ziHX8SMPqt2ZxZdUTpfGEuWq5U3TKAIs1c5tlxV6iBeahL
         Xaa4CHdAE6N4nLwEV2IGc4woC7Jc9m7essZb0hYKwPA4Altg2daouplymEyFdhAbeRXs
         SZfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sqDLE8eOD/jzuEBYGSJJdfRbfHzmSxgCPCd3m6sI5BM=;
        b=W9Ka024TwyUu7PrmS+c+/r6UWQDdYOe39wAosnYvsdhRSfVo0HQMUmSd09WPN9FeDk
         Tfp4KGhPwMOs8uWydX61Rwrgikx4j7u5tmx7RtxlWA/B4ipfcs3uY1inqhmhdE3DQ9d4
         6oac+fyzgcVHld/IPqt6ScQBinE135z5zf8ZBTQaOhMhL8iet6wtwltYSIp+0i8fxH+d
         KlHJIq0SPIZmTGl6CM7VCQOUl8rwwLpVtXbNME3VfOMJ4JNZGIKOOVi+LRthetqp85IQ
         RATS6KBKH+B/8fbhX540YijzNDAq8vTlBsVI6AqLjhRNW2JSjXkTvH/Aei2kElCZDrHE
         DsyA==
X-Gm-Message-State: APjAAAWDvpant3J6O1ddGvKUwXehGEV0dBxKplIFyGSFAfZKodpALXWa
        ireYWDDhEMYE2INMs3qwres=
X-Google-Smtp-Source: APXvYqwaZdkK3aFXO5FFDfTfzQdT9wrOBX3zxe6K/YcD8KqslRVP1eHe6lTMhnBHFTZxM3T4SF0/nw==
X-Received: by 2002:a1c:544e:: with SMTP id p14mr1440486wmi.17.1571861127405;
        Wed, 23 Oct 2019 13:05:27 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id b5sm177555wmj.18.2019.10.23.13.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:05:26 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v6 06/11] ARM64: dts: allwinner: sun50i: Add Crypto Engine node on A64
Date:   Wed, 23 Oct 2019 22:05:08 +0200
Message-Id: <20191023200513.22630-7-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
References: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic accelerator that supports
many algorithms.
It could be found on most Allwinner SoCs.

This patch enables the Crypto Engine on the Allwinner A64 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 70f4cce6be43..0287d8458675 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -478,6 +478,15 @@
 			reg = <0x1c14000 0x400>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun50i-a64-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+		};
+
 		usb_otg: usb@1c19000 {
 			compatible = "allwinner,sun8i-a33-musb";
 			reg = <0x01c19000 0x0400>;
-- 
2.21.0

