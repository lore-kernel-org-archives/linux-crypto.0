Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACDE0FA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 866CF218DE
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dO4olJtv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392460AbfJPPBo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:01:44 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39110 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392382AbfJPPBo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 11:01:44 -0400
Received: by mail-wr1-f68.google.com with SMTP id r3so28483194wrj.6;
        Wed, 16 Oct 2019 08:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GJDCD24q8FHHhxNDtUAkpzQYbJaDZYgAmYeaRlxpr/w=;
        b=dO4olJtvxy5WdTAk6CiGSGZ/doWOUCerRa2ngeO0GD37wFEQBYSjsutuPLDVbqT8mO
         Y6IMoGamFUFHX0sMTqJ4QBoJ56ZYmIPvod5t6RiUfjmLhmn+8xP19XUrKbPWKO6JCkT/
         nHW5ii8489KCW+AgpKSIdQSVKlZlsV5JoibBzTOk8oIA98Q5ApEEh1nO47aFvAg9GLdl
         2/KQBpSsJJ0OnjbxDkwEFoXlx2MhB3wzSpVAJJGKzPCJ7F05keQFXpB0ci03+puGuENc
         yvhd9mLDRE/0SZbaTCcPzjsABsHYIIotHozMjkDoM1UygnHvkRASDdbmA7FnpySj9QA9
         +PHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GJDCD24q8FHHhxNDtUAkpzQYbJaDZYgAmYeaRlxpr/w=;
        b=ipwk3DATjJxV8Cry5r8wi2B5X2L8pSV04TPrEXC7b1J9YhypjydBKupxKAysvzcwsf
         kJnI2yya5OFaOXsCv3Q4Do1zPiN0fSPb8NkhNZvmMHyTEScSF0c1IHRXnpyMmj66DPzr
         PhhujBZFNhn1p2Dill32+n27zvHeitWkgwRobHYM/dmBaOcHJONDBFgT+4wqlCheCmuR
         V9H69RpR8dMN631ZbPuPsYwrulI7guFuRp9ZdGBtaeUEK5W8dUkmdGvrPYNNScLqJZSv
         SOdPFwsb4PAYPiUcE7yurKHTfbe78j3Xr2/Jb0IvVHPThyW/UeoE33k2J3mRyR70UE8Z
         C4DQ==
X-Gm-Message-State: APjAAAX5PFPwyoR1rEzOiFfYS3bHUJIoA5V/MJWdQvZ8hxSNEcDMwP3M
        gEWaPlLT4SNEu/mXtk3Xnq8=
X-Google-Smtp-Source: APXvYqxajNGwg9e2D3RfLPK/tRVSjQI6X1jb4DR8hLkyw9AlkbnFzdfh7YT0cugXZNRH+p27aat98g==
X-Received: by 2002:a5d:4685:: with SMTP id u5mr3277509wrq.264.1571238101466;
        Wed, 16 Oct 2019 08:01:41 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r18sm3215437wme.48.2019.10.16.08.01.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 08:01:40 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 04/11] ARM: dts: sun8i: R40: add crypto engine node
Date:   Wed, 16 Oct 2019 17:01:24 +0200
Message-Id: <20191016150131.15430-5-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
References: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic offloader that supports
many algorithms.
It could be found on most Allwinner SoCs.

This patch enables the Crypto Engine on the Allwinner R40 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-r40.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-r40.dtsi b/arch/arm/boot/dts/sun8i-r40.dtsi
index c9c2688db66d..421dfbbfd7ee 100644
--- a/arch/arm/boot/dts/sun8i-r40.dtsi
+++ b/arch/arm/boot/dts/sun8i-r40.dtsi
@@ -266,6 +266,15 @@
 			#phy-cells = <1>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-r40-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+		};
+
 		ehci1: usb@1c19000 {
 			compatible = "allwinner,sun8i-r40-ehci", "generic-ehci";
 			reg = <0x01c19000 0x100>;
-- 
2.21.0

