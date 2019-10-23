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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557CACA9EBD
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B58720663
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U66CqiY4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407349AbfJWUFa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:05:30 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43005 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407338AbfJWUF3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:05:29 -0400
Received: by mail-wr1-f66.google.com with SMTP id r1so13657590wrs.9;
        Wed, 23 Oct 2019 13:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LcPRSweYpxW+Ru1oGSa20C29+Rhu7RNAj0ZxbDdCTI=;
        b=U66CqiY4+lFNvwG903V5JZTA1ctJodLAwwNzXswZ6B2C1OIJetWoDLLz2fCLY+enHt
         tEQGsyVyHxrvDRAzotOg1hArtf+PmvY/UELd1/J5G0NWQ1VPHZyJvgpyPHSyNrsKvVpB
         urILbX7Vy6HtUiuunGEETFxBfVKMTY0tL7JtCg/R5ahcVdopNaVtj+tWyHOnU+9+sVl2
         p3qb6uj6kEZonvYAklSXjKjldqKxEjLrwmbVzYGI2mlsgqOXlpklbfv96U0HZkDvnKY0
         rTSRd8apocs3dlPXkGzZppqkC1k4Bx9VLaWgxMWB+AFc79sieDKZqkYLNtcmxCaEpAWC
         CWLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LcPRSweYpxW+Ru1oGSa20C29+Rhu7RNAj0ZxbDdCTI=;
        b=dlAxwfLrHDwSjIqWRGcxQn4b69WoEdk9EusTEQIyOTu5LG7J1Ns7c+Jnv6REbVJ2OJ
         U22vyWu7gbMenAlGZopwl2oXtGc/vFBaVD5WEIQtK8JFXgagxgX7IeZppVylozL06UH2
         rB1jFl5FJE0dBr0swpw/aYh1xsqAhc5VT1EVm0G14uNWCC4GTDWZaM5zCbyvA8RbhiJX
         lNJZ5G+gm2bII262N9eNvlC2golb3c9+uf1RmeDTEeV03AttsTKYFnuVS0PkD/NwUvV0
         f9q6q5QZoHssmKSHfo8PoAjQmAk4UglBOAlp8FLzxoGgisIAPBINL8R6JjBjTPDEtRtX
         AAeA==
X-Gm-Message-State: APjAAAX1RJ/oUQQleK0vTLHB8HTlIiosExDldXNIf0lSs208UEDYHbQ5
        XtRj+ZuHJ6LTc+9vYLuZTu4=
X-Google-Smtp-Source: APXvYqwSUE+wT0DiHwVIQFVSrgj5ZeqVoTs9O015OyrwbsSY6BqMFBb+buqr/i0CXn1e08nzq4W6SQ==
X-Received: by 2002:adf:828c:: with SMTP id 12mr446863wrc.40.1571861126143;
        Wed, 23 Oct 2019 13:05:26 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id b5sm177555wmj.18.2019.10.23.13.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:05:25 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v6 05/11] ARM: dts: sun8i: H3: Add Crypto Engine node
Date:   Wed, 23 Oct 2019 22:05:07 +0200
Message-Id: <20191023200513.22630-6-clabbe.montjoie@gmail.com>
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

This patch enables the Crypto Engine on the Allwinner H3 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-h3.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index e37c30e811d3..78356db14fbb 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -153,6 +153,15 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-h3-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+		};
+
 		mali: gpu@1c40000 {
 			compatible = "allwinner,sun8i-h3-mali", "arm,mali-400";
 			reg = <0x01c40000 0x10000>;
-- 
2.21.0

