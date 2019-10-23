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
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF649CA9EBB
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8448E20663
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s8w8MapV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405512AbfJWUF1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:05:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:53329 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405443AbfJWUF0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:05:26 -0400
Received: by mail-wm1-f68.google.com with SMTP id i13so270079wmd.3;
        Wed, 23 Oct 2019 13:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GJDCD24q8FHHhxNDtUAkpzQYbJaDZYgAmYeaRlxpr/w=;
        b=s8w8MapV69e3JsWasZOEMLauPJUZ8ZSM+v9jnGTDDI31XjLwQOwKBrePOfFPYh4Cvv
         OwmVFPMOd6BpDQI62gWj3a2hHruR4h89ss00zC84daPgX24frMWhE4RgFb6zIf1Qq3kR
         aiomojMuYZ77H3Lb6G9HRuzPqBPiIln1Wi3arN9PBsSiHdkh7f9wYV0oYa10suiqvD+Y
         swmGbGi0XDkN8pcoKy165+2CQxRrb2so3NrTdfQVJ4rFwdPfZdoBx0mJkdCZKdM2DMjW
         iVf0PGfCXNjSCO7hE5rk+qH/VyXVC/OBftun22MFEDRbycKIqyDb8W8ohbCOGcjMaBCp
         T6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GJDCD24q8FHHhxNDtUAkpzQYbJaDZYgAmYeaRlxpr/w=;
        b=U2Gd7yqDr+OGL3QNovNEJbyqv0rYVdun7IW7vBEU28YebPulG6ESPMgg6sIXU/Zvmd
         7tDuMg5yHGWRXVk4tOItGSeOLaQoVnOb/nTdD8ZRYajE4mNUEsvOtWe60TEqhbIwltwr
         4oOcTfYnTjGuLqpW61ghRzyoXF8idxc5r6R9lZIdDB9b26cluSKFkVlrEMw9OEu9U41B
         VVeUFTca/nRG+rQOpqh54AhURbmjsDp3V9FFM7utYrZG/8BHR3X4ltiO9/xh99XIU2rj
         ksf8LYT0eP/nj5sMINjqTDziZ+Mg1JdA0OTw9DG4EarrGCPwPqtBqzNq8yGEjwqD/NT3
         lxmg==
X-Gm-Message-State: APjAAAUP86eJZGAPLpbqeQCb7g8QmgMvTE3IlNxQeJ/aPjAinLg+vc3G
        Y0v6sEiRAhrEbdlnQOhrP3s=
X-Google-Smtp-Source: APXvYqxifD0MWUorcByZal/Q4NJtrT54ymEOxMv/k+um0yY0z376Cq0+AbYZswrg3oCBLKHyUhAC2Q==
X-Received: by 2002:a1c:f210:: with SMTP id s16mr1372636wmc.24.1571861124415;
        Wed, 23 Oct 2019 13:05:24 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id b5sm177555wmj.18.2019.10.23.13.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:05:23 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v6 04/11] ARM: dts: sun8i: R40: add crypto engine node
Date:   Wed, 23 Oct 2019 22:05:06 +0200
Message-Id: <20191023200513.22630-5-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
References: <20191023200513.22630-1-clabbe.montjoie@gmail.com>
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

