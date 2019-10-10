Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87A3C10F14
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0FBA21920
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QD/aYw94"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfJJSYF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 14:24:05 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43186 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfJJSYE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 14:24:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id j18so9043593wrq.10;
        Thu, 10 Oct 2019 11:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eFc0TnCiV39kO57Nf4fDfCRzWyhpgpmUwtiQu+sgq4c=;
        b=QD/aYw94NN50dr3SkQZk39lkA1R6HaVNO9ts2BoKVuEyXjCc5JDlaf/G2JLf49Ftxy
         YMwnp9f9ww1kkZrxyyjuE+YmqXpruZZrxuGyAsG5QGfP+He29tqq0/86lqkHMBBf3NB5
         RGNbfx+elt3Ih+HFGtp8Bowi0d9m42nz5PcqV3J7Tv/bvG0rbrOpMZrUVVeXh+rTYlji
         df0jFwhxxiuQqW2IDIHhAmuCEOIWtQseF6rOPtXYzey0ohvMNC9z6ICRaYMJcI5kV/Ro
         yuA3joShoS9OYZ3RCit6SAxa6pYp1MG5OnljH20RrLz1//jCdKKOmqq8U6LNfJ2nInr5
         T84g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eFc0TnCiV39kO57Nf4fDfCRzWyhpgpmUwtiQu+sgq4c=;
        b=AGEnC/5/e/PRUAbluz9Irx9IdlFoKyj6Gm1EYOM1ngmk8x0XjrfT2O8M12yAg11sjb
         k2U/O3SJ0y7H8V/eU4gaoGW/D3/bkPHKqi7GvlNonAAI2UhXYAfDTt8DBBB1hVTyQKqN
         4rh0BW1iVbR/HimO5ub/2czdW2ZbxDfiHTIAGaVHmlRj60/J9lPswKg0wuuPiSG89lXX
         TngHb9McdthtsI3H1wARhXAOrrtIJiKHCVePgc4q/0baGNcbvXWtleDaUFKS2LebBhFo
         B4DoEatYSmQhGAzpx5JflrR4vzSXdC+YH0jKckSK83x/c0jusj1Gj1+aIEbghsAussL7
         m+0A==
X-Gm-Message-State: APjAAAWViWccqZ66CghAMkCM9+P1WK/9I+3kHllucAg41iyopUjMuIv0
        X84hFAEtL2xDILAC89ffhqs=
X-Google-Smtp-Source: APXvYqwyzjQcMH1nDbxHHzVakeW/SPThMO2JRlkBJmeSqdWeh0kAxIStHqWAB4eDL7mGeVBDNEsRFw==
X-Received: by 2002:adf:8385:: with SMTP id 5mr9934134wre.267.1570731842613;
        Thu, 10 Oct 2019 11:24:02 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y186sm11367664wmb.41.2019.10.10.11.24.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 11:24:02 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 07/11] ARM64: dts: allwinner: sun50i: Add crypto engine node on H5
Date:   Thu, 10 Oct 2019 20:23:24 +0200
Message-Id: <20191010182328.15826-8-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
References: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic accelerator that supports
many algorithms.
It could be found on most Allwinner SoCs.

This patch enables the Crypto Engine on the Allwinner H5 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
index f002a496d7cb..14cf29539aab 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
@@ -127,6 +127,16 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun50i-h5-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "bus";
+		};
+
 		mali: gpu@1e80000 {
 			compatible = "allwinner,sun50i-h5-mali", "arm,mali-450";
 			reg = <0x01e80000 0x30000>;
-- 
2.21.0

