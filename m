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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFF6C352AA
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C921F21855
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZGVoaQA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfJASmW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:42:22 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46343 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbfJASmB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 14:42:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so16718448wrv.13;
        Tue, 01 Oct 2019 11:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AE8l+XRMu1sgkl2Oy/fFtmiZlnFZOea3H9nl7n7sx/w=;
        b=dZGVoaQA65ACdRAYWhu+1Xw/6V2dJNORC94PgsqCbn9mSou5fkbF3DTRF/S+ViuVBf
         brZ+C1r6l5dNcudiP9HUWpzGaNkDj1WKb+ZVgygsustay5u0I7RJgJvpB69Qj6pnF14q
         yI40IetVyDwgS2lydWxz3NLubVhsycKQBNDhpDTVLMr0k9KeQSqnCN8IyrPvY7wXBgAT
         nBTMRm+cT6z25P+5hCtYUtw5MfKB5FfqzLUsk5SntHQ/yQ9tbhjS9ftZtRAHgX9/2An2
         Icd9384WOreyeGOaWltflmV2OVTP8JV0tpcqOEZ7dhKQC1u5qurqzULDh8/2teFdD9i5
         GEfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AE8l+XRMu1sgkl2Oy/fFtmiZlnFZOea3H9nl7n7sx/w=;
        b=DFZj3Bi0fo6yB/AhUO3shGVrUtsTPDYFS6OH17GkkdlW50uzDUQJ4h0ORBXmhPD2EP
         zIKiKJks5vwA+50Zfg0O9SHWg65TVlASpw0q/SnVkKOamBFejiM1mjoFBLqdZfRoBYl2
         6Abfl9IQAS1mXvq3AgIeUxOtVhp1XmgfmCTCZ6nKCg4GTHit+aEZITe4DYuL6ep+FS8o
         7dFCq/Meed4Yet8qCivkSmiigZOjkC/Omx5QNoGWwGNRnXQVZp0bE1aT0v34IVB8l5rE
         W7tMLz5LMs9fbS9+eGbvLOn4U9Te5WdDa9TxtUcmrhn1OI9184zMeeaYBjMlhC5/aco+
         VECA==
X-Gm-Message-State: APjAAAUoNcJ6WuwmVQZWwvgKi7zBo81AL+k76Q8/q7KWCS9nvzuDYsns
        kN0Kh3QJFZPWNcuCnvMPtfQ=
X-Google-Smtp-Source: APXvYqxDm2SDCiSBhrALXCHZc5QOsLfBxMwxfZBJHkpp2DnDuLU6/K882gSaAsZjpqW0zvLHgpIPug==
X-Received: by 2002:a5d:52cd:: with SMTP id r13mr18241988wrv.376.1569955317656;
        Tue, 01 Oct 2019 11:41:57 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n8sm6788987wma.7.2019.10.01.11.41.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:41:57 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 07/11] ARM64: dts: allwinner: sun50i: Add crypto engine node on H5
Date:   Tue,  1 Oct 2019 20:41:37 +0200
Message-Id: <20191001184141.27956-8-clabbe.montjoie@gmail.com>
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
It could be found on most Allwinner SoCs.

This patch enables the Crypto Engine on the Allwinner H5 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
index f002a496d7cb..362f78e9122e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h5.dtsi
@@ -127,6 +127,17 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun50i-h5-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ce_ns";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "bus";
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+		};
+
 		mali: gpu@1e80000 {
 			compatible = "allwinner,sun50i-h5-mali", "arm,mali-450";
 			reg = <0x01e80000 0x30000>;
-- 
2.21.0

