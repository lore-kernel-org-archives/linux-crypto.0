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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDBDC47E49
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:10:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6C3221A4C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:10:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EB5jMS0H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389786AbfJWUKj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:10:39 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34785 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391316AbfJWUK0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:10:26 -0400
Received: by mail-wr1-f68.google.com with SMTP id t16so18324417wrr.1;
        Wed, 23 Oct 2019 13:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EVcGe0jhVemfS4F9ZaDSPVCJM3kLwDEzlwrCz/1Vhro=;
        b=EB5jMS0HCXV/O9fqfDaEVsb4bq3hdr5B049ewpRUOWDfnPe1UTPTnZUwyhiswHn7GT
         cfQLb/7CnZMg/o2EVAyVlgxw1O5G84mHnkVpnQ4juU9KsIYHtcLDb1HrYx3VyqYd6Br6
         DC7DDFFTD2cISFn4jEX4w7Pf1QjLJBSFE5nL2KKBPxptObUusMmf/b5z4/1n6nG7wQRZ
         D7EmtQJ8fzzvQxKdyFF98sJHcnxE2L3FK6swZaTrI4CoGh8B1LFnmnX//Kdq0SHie+rR
         JAUeruRD9POjKOJVv2tuk5xiTbK+kGZevL3LVzw8VLVNrGs+N7jalEtxe8t7HPI6j+3f
         DT+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EVcGe0jhVemfS4F9ZaDSPVCJM3kLwDEzlwrCz/1Vhro=;
        b=DK85Pss/18L+vpuThHw4Fi1fTW8Ua5Yd1KgfJiOxa2aW3arw9ztnfLpUus5GpQfFEH
         wvTzKy3UJCe0hmUzBFrT+THatPgWoh9ArS0jFQWCz/AO54+yXww1/205t6T7IK+ybZL3
         iFQy0+20zvvXFfMsIo523YGA1ezZIDqanOOf4VJvHbEZOriY4m2ywbDegyOzeZUf5/tB
         3ESbYXnfgwglz8fdfyHK9XECG6snBIhSs0smrpXrKkDKZFM+59H94tOYTxO+8Ds60k5f
         o9dB/XsyDpXQgKilphb+sPC5ZcZuhzCeJux/ldIsCwABBl2w6pMO3TjPOkafqVvRly13
         od+Q==
X-Gm-Message-State: APjAAAXbuzuakanApnUAZpcwDcP+/gR+4YNbYITg1xvNkl3UYsunc6Da
        /hFh3qqbL+s4MXJotwIL8lQ=
X-Google-Smtp-Source: APXvYqxXRr01gLUky9ikT60t1Fi0fbsD4kiaOTYDWZyPb3tFWAxn+F8I6U2dAgQddtCWq57qxr0MjQ==
X-Received: by 2002:a5d:4285:: with SMTP id k5mr434899wrq.344.1571861424257;
        Wed, 23 Oct 2019 13:10:24 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id h17sm277261wmb.33.2019.10.23.13.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:10:23 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 3/4] ARM: dts: sun8i: a83t: Add Security System node
Date:   Wed, 23 Oct 2019 22:10:15 +0200
Message-Id: <20191023201016.26195-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023201016.26195-1-clabbe.montjoie@gmail.com>
References: <20191023201016.26195-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Security System is a hardware cryptographic accelerator that support
AES/MD5/SHA1/DES/3DES/PRNG/RSA algorithms.
It could be found on Allwinner SoC A80 and A83T

This patch add it on the Allwinner A83T SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-a83t.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
index 74bb053cf23c..0a6e9d92277c 100644
--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -583,6 +583,16 @@
 			reg = <0x1c14000 0x400>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-a83t-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&ccu RST_BUS_SS>;
+			reset-names = "bus";
+			clocks = <&ccu CLK_BUS_SS>, <&ccu CLK_SS>;
+			clock-names = "bus", "mod";
+		};
+
 		usb_otg: usb@1c19000 {
 			compatible = "allwinner,sun8i-a83t-musb",
 				     "allwinner,sun8i-a33-musb";
-- 
2.21.0

