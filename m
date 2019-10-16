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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E7DDFA372A
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3449E20640
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 15:02:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GkCbdZxZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393082AbfJPPCP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 11:02:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50728 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388424AbfJPPBt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 11:01:49 -0400
Received: by mail-wm1-f66.google.com with SMTP id 5so3313821wmg.0;
        Wed, 16 Oct 2019 08:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BlSNEKakkPz3qSacpRbF5fymVNSJO3OQiWGq/ZKj+yQ=;
        b=GkCbdZxZSlrSuU1lMZlxTCRgfOho3FeWP9Qb8VexJMxSLiNn5QjHzSDGN78YTYZ6sY
         HKcjigC+gPZxcNGwA+C9HVpZNGqNRCIMCliHH6+LLpJo/rYCco8kbNNcxtKNclmJCNxu
         fUf3b1rOa5YFScI5y3mJyeStfmJbnwLf1KI3rznvtXKk6YpImbYcjFzIYeLQT88OVbjh
         50Zmmg9bqWdU5PesiUkB+cQmqKOpb4PZ0VAV2BfqcJ9QC14Nbh0RaZYXqcoeQlIswlDI
         fLh6Xsp8MlT7CWp0QWf9W2nfQP35hri/lFKjBDEY/3WM0nYcvgdZEeM7DfEa1s9BPBfG
         //0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BlSNEKakkPz3qSacpRbF5fymVNSJO3OQiWGq/ZKj+yQ=;
        b=dCxLFPbLZVl+X/AHILEnw6DU/6ZpYgsUihGIyu8LyHeWL+SZc/dch/FEOFs0Xblzd7
         C7iyRdP4WX7iYJ1R2PWUVMnmADcP2qnwe21o/NpF/EiZsL2h4+lpijmwAntbJLAnIyKZ
         CeVV4DJHANH532lvZc+icwKuLB8Fs6YyYPLrEc0VLOdvuEuOg91V7CC/IcAukOK/6Srf
         p5ZC0f6c+wvLi+W54zYzUE8h5r7vturNY+w0ra5yPVdcLhIx+QIznmL1/KhAHuJMizqc
         getLXGWzJxAazhI5aFjfdFXan5OtPFY9PDMz8wUtXsVez2JAO3xjIovwCjynbHZR3E9L
         cDFA==
X-Gm-Message-State: APjAAAWnaL8yZ5odTiKd/SNmnWqU156dQ/vE0LfxmBHoQ2Xkr3wuPCDk
        DRbEcJMe1pCNf5nM08HL2C4=
X-Google-Smtp-Source: APXvYqyue6RFZDMQ83zyZKJMte1ssg/sfGhwzL3H+VaAWeAsF0+fICPVm1OXG4lzzdoLXx3jmhHPPA==
X-Received: by 2002:a05:600c:2185:: with SMTP id e5mr3908701wme.78.1571238107027;
        Wed, 16 Oct 2019 08:01:47 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id r18sm3215437wme.48.2019.10.16.08.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 08:01:46 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v5 07/11] ARM64: dts: allwinner: sun50i: Add crypto engine node on H5
Date:   Wed, 16 Oct 2019 17:01:27 +0200
Message-Id: <20191016150131.15430-8-clabbe.montjoie@gmail.com>
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

This patch enables the Crypto Engine on the Allwinner H5 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
index f002a496d7cb..e92c4de5bf3b 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
@@ -127,6 +127,15 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun50i-h5-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+		};
+
 		mali: gpu@1e80000 {
 			compatible = "allwinner,sun50i-h5-mali", "arm,mali-450";
 			reg = <0x01e80000 0x30000>;
-- 
2.21.0

