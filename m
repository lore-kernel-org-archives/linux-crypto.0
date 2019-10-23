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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D9EECA9EBE
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:10:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7223E20650
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:10:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iYHQNJHm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391530AbfJWUK2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:10:28 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45802 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391332AbfJWUK1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:10:27 -0400
Received: by mail-wr1-f68.google.com with SMTP id q13so18491642wrs.12;
        Wed, 23 Oct 2019 13:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dpe0zCbR3c1VkH/n1U/vOC6ekNORqcDkTSfYoQ4laf4=;
        b=iYHQNJHmQbhRm4umf4o2ihYkcxoZoiFdeHMW6g10R+LYk5ClYI4rP3GaTktcJuUIHs
         HQxSdartm1UsLMWKhma8Fk31En2dOM4r2stHvB3TA3irwopFfnmnJgBlfRzzTghStD2s
         GEEHGXA872OvJ1TKQGRg2cPB6BTvcxXH1bO/eoTHqiGOhdX8rBj91SV3fjkggIM5BcqC
         1nSU9YcIIHbmiRPK6g9Ow7QzAra7eBFzUePfQEgLpZ1XMk9KleGi4Qspt84bWr2ayqVV
         g74jQvyQLno/hsohQwudKYKam9vDmUnAZ3u+qGslOtIYgygjF0A+6Oef1qTS2U+tU3Fu
         6/gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dpe0zCbR3c1VkH/n1U/vOC6ekNORqcDkTSfYoQ4laf4=;
        b=JsqEu1OkOViFVOPSddnXhaVFrxrM5795x42E6cedm4ZLhiObQ2nr/MdrOFGOEMJpxf
         aVok/lw2BgMPVCK7j5umZxpHY9tf6NszxVpsIoCi63KJ281gTR72r54IaJMMOgUwwHN0
         dZ7eBjFp27ExZ0rgRAk31fIDy6QbUVh3mjAQWNgogzAqBW+4kKik6e2pIqUgvI1gKuR4
         UmUD0b6OjSuG+Laru1SW7TkslDhsm5vlKF7rOaoPdXC4QS8gCMAh1RJ01cPphJZDopIX
         veevbdhLni1clV2fuaEytfYWOfxCMysXSnp2ghq3lhNTDbzQ1QLhE7403HWd4yBQJMZ/
         cvAg==
X-Gm-Message-State: APjAAAVoHKsLOGDDTN7aNcMtMQjiMUUpAE2ivztBq+nP373hgxhYuRNJ
        guSXbMl04rc+wsvagROmFqI=
X-Google-Smtp-Source: APXvYqz68Wn9kNMfnDrY2c9bI9xvs8OblM3ux7zEgB84kOYTwNMVTM+UoHgwIP1ztIVFRF33kYRzyw==
X-Received: by 2002:a5d:4d46:: with SMTP id a6mr480347wru.196.1571861425413;
        Wed, 23 Oct 2019 13:10:25 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id h17sm277261wmb.33.2019.10.23.13.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:10:24 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 4/4] ARM: dts: sun9i: a80: Add Security System node
Date:   Wed, 23 Oct 2019 22:10:16 +0200
Message-Id: <20191023201016.26195-5-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191023201016.26195-1-clabbe.montjoie@gmail.com>
References: <20191023201016.26195-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patchs the node for sun8i-ss which is availlable on the A80.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun9i-a80.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun9i-a80.dtsi b/arch/arm/boot/dts/sun9i-a80.dtsi
index b9b6fb00be28..d7498a1a158e 100644
--- a/arch/arm/boot/dts/sun9i-a80.dtsi
+++ b/arch/arm/boot/dts/sun9i-a80.dtsi
@@ -457,6 +457,16 @@
 			reg = <0x01700000 0x100>;
 		};
 
+		crypto: crypto@1c02000 {
+			compatible = "allwinner,sun9i-a80-crypto";
+			reg = <0x01c02000 0x1000>;
+			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&ccu RST_BUS_SS>;
+			reset-names = "bus";
+			clocks = <&ccu CLK_BUS_SS>, <&ccu CLK_SS>;
+			clock-names = "bus", "mod";
+		};
+
 		mmc0: mmc@1c0f000 {
 			compatible = "allwinner,sun9i-a80-mmc";
 			reg = <0x01c0f000 0x1000>;
-- 
2.21.0

