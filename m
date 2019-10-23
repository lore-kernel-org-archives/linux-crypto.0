Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9B5CA9EBD
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 248C121928
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 20:05:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AuWzuW+A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733137AbfJWUFu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 16:05:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43172 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405443AbfJWUFb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 16:05:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so18212110wrr.10;
        Wed, 23 Oct 2019 13:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BlSNEKakkPz3qSacpRbF5fymVNSJO3OQiWGq/ZKj+yQ=;
        b=AuWzuW+AYZImfZjow+rRGRgANqzxjgatKAUOk+Fli9w1R5po/O0rM1MeeDL5QzfvX+
         ibph7gyBzHehtYoC6CJQIDXI9PkWyDkP/QqlFkGAk4VYSO6dZ/JgoxYlVef/lBD0pOOt
         8+oVhFlVop0jjj2xQ15hw7c5UNK3Sk1Q38oy0I4YVKhf3uq1UVLAoCp2S42Q+3DwgbN4
         bvNGp9cGZ659TbJo7aoxHYecZ8tb5lBgSdMiIwxtQX2Ku58wpxMVfupz3cFqjHGoFfvF
         n0Jt3cQqP17n1kk2+7tNeVDHJnJhvrKJg37V33baV4RAJ05Uwy3XKcACpXB8zhUFANrM
         0RZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BlSNEKakkPz3qSacpRbF5fymVNSJO3OQiWGq/ZKj+yQ=;
        b=j9Fl0pd0MaWf2k1xrLrPYzdlGtuDSPA411yHA8d4pDYxKgSBze+nfIZIdNrjguFdAE
         DKHTyry7INAlJWMRxHPOkPh35gB/kFAswQJ4G008MGu/1EAkTRVgZFL0QU4FvUZN3lIq
         eiZ3L3wctsv5LZTosq3SHHAY0rdl10eW8goXp5mf315CYJSEcozsbkmlR6NNmxlfjsvD
         v2BFV2yFB1eJmtwDNRbQ4J6BzNnLH2wZIfvZrJWl6k48yPKjvfCz6HwLi6R7182wn+l/
         8y1+yLSstt7qTRuuIlhkjU4rNvYVc0wZCQuxdl/FvX76eV2WR8Ud1lJxWIM2fonTq7GS
         pTxw==
X-Gm-Message-State: APjAAAVBT38Jn4zOn5eVayfZA8JkE/dlU+1TvLGjoLfzgXbNGNGbZTPs
        YjWm+I7na6FBplzkUwmojf8=
X-Google-Smtp-Source: APXvYqwLysC/MtENiSF/dJeLC/uB17rc5+AT6O4lC1VhVMGyAdQ07ZFNS7iWoKPM4JwdZspWKhhvdQ==
X-Received: by 2002:adf:f447:: with SMTP id f7mr422943wrp.210.1571861128757;
        Wed, 23 Oct 2019 13:05:28 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id b5sm177555wmj.18.2019.10.23.13.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 13:05:28 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v6 07/11] ARM64: dts: allwinner: sun50i: Add crypto engine node on H5
Date:   Wed, 23 Oct 2019 22:05:09 +0200
Message-Id: <20191023200513.22630-8-clabbe.montjoie@gmail.com>
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

