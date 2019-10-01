Return-Path: <SRS0=Oe9a=X2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D341FC352AA
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA33921855
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qEyQZYZy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbfJASmW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:42:22 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37639 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbfJASmB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 14:42:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id i1so16771166wro.4;
        Tue, 01 Oct 2019 11:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gZZhSHrWVeMsgcZ1DNWdqejRZp5+6jKQtXPgaV4ea4U=;
        b=qEyQZYZyIjF+lLElfRTkIBpuwmvIl0oEdlMqmL+SywepsvSp14oTYYh544PWow0LoS
         Rf21kH7sBUbzDYbWnStY1d5yYCBpUZUkCj43OHCdbKf89oF4/xDfkeAMFvE4+3LV7NEk
         3qguTeGN1fxdOB8L0o6JebjJkUCVIaAXFn4bKCB79ZUGDaiHMw4m3AiJAEgcihptGIMs
         nzCY4MlDXWXTodNPVfmZBAbbjgObWdrhRmbErlfIllyKH4+MYep+ekTx1qHa5/hmaLWe
         uBBmLSAsZPozRc/2JldDw4jjy9ZlpAYVgCXgRW1SYsm2Lhi6Ns6WU4KerJb+0X6InKYy
         qm5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gZZhSHrWVeMsgcZ1DNWdqejRZp5+6jKQtXPgaV4ea4U=;
        b=cPLdxb0q7GRp62+rARhSyYp63twgYQvNdvP7seKKt0A0jsrE+oCOurV0IlaLWRwmKM
         OixklAmGjtUYyc5e/RNPkuc+w7rR9f7LuGLRyn9oHFNBvnCR+QZIgWnwhV9QBURtUor1
         EgiVC1WJmT2c8MPhOFCmSs1zqDEHsiJoCpqgFnqyYxbQeD/wA5k1pOlRPC8bT+AovQD9
         ReBWPBUc0+rvdouxIh0LciQcQn2Eix2x8X5vY99QNrKVH6apPS+MWcTRvOd0lxZsdmwY
         Rmza+Y9bs8XJo0yxrw+0kOQoemw661kFX9Uq1S++r2CoHB8m2Ec9qejo0pIVBx027EHy
         CM3g==
X-Gm-Message-State: APjAAAX6bwbmQ/wOw5seHKJSg6k7MQceZs3BsAhrz6uYjXiDF8ZJ+U18
        D1jHdxKcRRVXdWWowI10teA=
X-Google-Smtp-Source: APXvYqybn2IX5mvp+PPcExvF4EUI1AnHHE9tXo68fCXeU2b/e1T1Xp/7huN0mrK8DdiS9UTUhN6ewg==
X-Received: by 2002:adf:e951:: with SMTP id m17mr18678899wrn.154.1569955318987;
        Tue, 01 Oct 2019 11:41:58 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n8sm6788987wma.7.2019.10.01.11.41.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:41:58 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 08/11] ARM64: dts: allwinner: sun50i: Add Crypto Engine node on H6
Date:   Tue,  1 Oct 2019 20:41:38 +0200
Message-Id: <20191001184141.27956-9-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic accelerator that supports
many algorithms.

This patch enables the Crypto Engine on the Allwinner H6 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 4020a1aafa3e..0d26901d42ca 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -149,6 +149,16 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1904000 {
+			compatible = "allwinner,sun50i-h6-crypto";
+			reg = <0x01904000 0x1000>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>, <&ccu CLK_MBUS_CE>;
+			clock-names = "bus", "mod", "ram";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "bus";
+			interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		syscon: syscon@3000000 {
 			compatible = "allwinner,sun50i-h6-system-control",
 				     "allwinner,sun50i-a64-system-control";
-- 
2.21.0

