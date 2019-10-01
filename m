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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4A01ECE587
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89B0A21D82
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O1xmlx6C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfJASmc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:42:32 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35638 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbfJASl4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 14:41:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id v8so16786546wrt.2;
        Tue, 01 Oct 2019 11:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N64UCPhRuRaa6HAihdDNhQwAdS9v1yZICEy8f66AWK8=;
        b=O1xmlx6C9EC5XBbxeoVyiJrS3gGf4f1W/RN3tQijnQjE2kuLHnZmgZrp4GyCFlBdnS
         K9YbKIvSMj947VSwn+gLwunCBZPhpP2GHeAlMViF0UqcwR0XWCYi3N5R06Nv46Ue6JHR
         GnwbW+f7VMgFs6Ybai2Q5VYSd5juCmJD4lq7F+3iG1J/ouDRnjPHDNGrubtu0WwU7Lkm
         8lc6fS+GhY5WrLL5e4Ot4PDOCgFD4Zc980Z4i7nM8R4zY8P82vp+MMC+HxBNTQz3ysHL
         GTCBT1avmdW2sfSgI1tX+zb12tLPwJ8pnaXzx1YQXAYEormP2goCYcwadRuZptinhUfD
         +Tpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N64UCPhRuRaa6HAihdDNhQwAdS9v1yZICEy8f66AWK8=;
        b=ig6aUB4MblzEYBMfhLvrcFjAhQ8GCWHIvtJEvAtgztQltKhjXtJ0zzE1W3x1Kuuw4L
         tuI2kVoA4QHMCy1g4JDuYWdx1OyHFS+3BLGdAebnNIgwQVREqopfWwyJnXZ5yn0lmqeh
         Hr0QyqNtL/8wZjJ5n2t5yYZFeQUKgIV8ProRu8apFGV7FWBVuf3oRcN03Xc3UvACey+i
         Ist6E9EbkZTDfK8qZie4Zw7Kb/sdMxVLwXE1iryhGQ+sTZ/Y0PU7/iNpI7hkSLYbj87E
         nCwc0uyasnebN3L1yWvdDsdo1LobGRAIz0yt6ONt7oXX73NFTIlJ/mlHpKboTke0bsCD
         neug==
X-Gm-Message-State: APjAAAUtgnWLDtZHwcGcJRepPOOKZiGA31OxkHtYOLCJvbb3Aj/PRDHE
        tAulYvI8/8NqzGnU1NOUigg=
X-Google-Smtp-Source: APXvYqwCAdWn4qYRUxI8Stf7vpraZaX/Lp7SJyicaKIlgZSgnjPijNSfN13cYxo7ZID8gKwUhGUCgA==
X-Received: by 2002:a5d:40d2:: with SMTP id b18mr18262783wrq.4.1569955313682;
        Tue, 01 Oct 2019 11:41:53 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n8sm6788987wma.7.2019.10.01.11.41.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:41:53 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 04/11] ARM: dts: sun8i: R40: add crypto engine node
Date:   Tue,  1 Oct 2019 20:41:34 +0200
Message-Id: <20191001184141.27956-5-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
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
 arch/arm/boot/dts/sun8i-r40.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-r40.dtsi b/arch/arm/boot/dts/sun8i-r40.dtsi
index bde068111b85..1fc3297a55ec 100644
--- a/arch/arm/boot/dts/sun8i-r40.dtsi
+++ b/arch/arm/boot/dts/sun8i-r40.dtsi
@@ -266,6 +266,16 @@
 			#phy-cells = <1>;
 		};
 
+		crypto: crypto-engine@1c15000 {
+			compatible = "allwinner,sun8i-r40-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "bus";
+		};
+
 		ehci1: usb@1c19000 {
 			compatible = "allwinner,sun8i-r40-ehci", "generic-ehci";
 			reg = <0x01c19000 0x100>;
-- 
2.21.0

