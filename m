Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B614BFA372B
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EA4720640
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DPkTAru0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392617AbfJPPBr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:01:47 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43723 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392381AbfJPPBq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 11:01:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id j18so28442501wrq.10;
        Wed, 16 Oct 2019 08:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LcPRSweYpxW+Ru1oGSa20C29+Rhu7RNAj0ZxbDdCTI=;
        b=DPkTAru0Yql5GtRWNDospNrLRWn8xyUN21TNlKMPAiwJ2Rda76JTw24YsVGFRIkMzM
         n9IEJWOYuzan0n36KWSNTEzU6wiyGDlEkxWFzUXBdbnoU5zjRT1wD1y0q7PHoVtCBtzS
         1yMNq9GPSqhrKa+Q2SOTC3T+F+9ws+fnuCJAzoRBBOtW1V2dbKWK5L8P2uUHSiNksDpq
         X/RTQ+bysHQLZawwV2drb86MMzick4gq2N9ekLy/8xNUX+LJSZuFHXw7/J/kVE9vDWpL
         aOUSXG6gGzNbq2HTC0hk0TwQmzyzdVJ5aNRISWOAMFV4DP2KEzippzg5hIPnVT9C/2T+
         a4/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LcPRSweYpxW+Ru1oGSa20C29+Rhu7RNAj0ZxbDdCTI=;
        b=KQ/lXQZSKIZvOo+fHyH34NooTvBhKhwChQNpDoA0ImfRI2/PaGQZamWYQ6iBnU7T7b
         LYhRVFnObARATH7+dyPJu2s+eFxa3gvGWvA6Zl3GRJDvvY3Kftgv7JQcjKHedP+NzX5V
         uxS468fOWWUZDd8TlPTvvGtyivkmuQlqElGOIi7+4ZxwsSnbhJp9uDnqBdgU9BMKSLnh
         UV1h0JFtkun5YHIcyeO27KBHTseeskrbTCrqH4D5YkgKEUBKk/g4V/GKkztxyv9QCGA3
         AuzsvPnaScNat5Cr+sLnV5k6ym5ZsrD3wp3+cNzKAaDc6J215zkdXKkHxXpPRU/3dQY2
         dS1g==
X-Gm-Message-State: APjAAAXXeTTIPrwXNh9G75/uKKqZzm1yh+67AJ6qPkbJXQmTuRxiQprZ
        5BW85//ljONurrrseXK99SA=
X-Google-Smtp-Source: APXvYqwd0ox1BMFOPpIf6Htg8EZBF6/wQQQQ+qNi3gquKS93kFSMNdRLgUUh8iRAye6dPiKWjrbeew==
X-Received: by 2002:a5d:4302:: with SMTP id h2mr3265040wrq.35.1571238103862;
        Wed, 16 Oct 2019 08:01:43 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r18sm3215437wme.48.2019.10.16.08.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 08:01:42 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 05/11] ARM: dts: sun8i: H3: Add Crypto Engine node
Date:   Wed, 16 Oct 2019 17:01:25 +0200
Message-Id: <20191016150131.15430-6-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
References: <20191016150131.15430-1-clabbe.montjoie@gmail.com>
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

