Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43225C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 15:28:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14CF020679
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 15:28:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uPAKdeb/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731228AbfKTP2o (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 10:28:44 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37838 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730428AbfKTP2m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 10:28:42 -0500
Received: by mail-wr1-f66.google.com with SMTP id t1so295405wrv.4;
        Wed, 20 Nov 2019 07:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tB1mv0iagpasqt+ubXAygnT8VXICt+ouOxxy8t0xYvs=;
        b=uPAKdeb/DWgZDZtC6f1PbTauQGenxGV5fSTMcND1isct3YzemSRgAdB0N7jA5+V38h
         FhBHk3Tnhh1VFhkdWaArFcpR/RZrp2LZLBOhqIc1g/lXD+Tk7Coz5alp6WrhjPinO6eW
         pzCkQBNl8uLpO9zS9oy6XSZPEPhPIlLZPOp4Sy7/kglTXhqpjsDLnyAiny1bQR/2T5LA
         +/IzB2HPY4qOPar2lXMazEgUOads0pzUss8YpdjjM5sr43uAhV1olQeOBd5GG4md35KA
         cu6Q0iEhewBs7u+M7oNmof+HM42XkgLLmaZ510VC79sVkXbnoBxi+ALe6DxCqKGlgEtK
         yjyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tB1mv0iagpasqt+ubXAygnT8VXICt+ouOxxy8t0xYvs=;
        b=TYxane9cgFA9kUcCJQ2X5vsS8ngfgZQsRkv8+LQ8vTTeDWUvGnGVGTkAhWFlB6x+TF
         aQEwee4g0o7V1enoqwXIKLgOtObCxE4SvKq4P41D23L7pz0nQvxEFirMP4+dBrXZp9AR
         XIYssFuuWXIvgmYXkdKPUGbDe5bGp70iIMH4u0PUOut5Ru+Qpy8sBXYkM96zmks2zmdb
         qzgg8ayBOVfiH582B+3rgBZgxsCvPtGyic3U7v0BtAwp+0XwKf9aLZoh65Mf/k7IueKo
         GfphFx8z+cDQRAFCUjwcBGJqNKNShs2oV7h7tEgZCUyn0IFDz+1sMkGEmo66C1DxbPOr
         jXvQ==
X-Gm-Message-State: APjAAAVIrUTFJiT91u9pGAEjznWblIANvJM/4YhlSiwGKGMjQ9dRxP5J
        ManGIeVoIBEQZMGFAcfVEfQ=
X-Google-Smtp-Source: APXvYqzRCrNiWv3WJ4S0PHDL3ahCsxIQu72pLjaCVPEGuCu8yR5dYNXuP35CTbFHByY0P1rBekgHEg==
X-Received: by 2002:a5d:6cb0:: with SMTP id a16mr4316101wra.194.1574263719888;
        Wed, 20 Nov 2019 07:28:39 -0800 (PST)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id w4sm31797881wrs.1.2019.11.20.07.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 07:28:39 -0800 (PST)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 2/3] ARM: dts: sun8i: a33: add the new SS compatible
Date:   Wed, 20 Nov 2019 16:28:32 +0100
Message-Id: <20191120152833.20443-3-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191120152833.20443-1-clabbe.montjoie@gmail.com>
References: <20191120152833.20443-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the new A33 SS compatible to the crypto node.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-a33.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-a33.dtsi b/arch/arm/boot/dts/sun8i-a33.dtsi
index 1532a0e59af4..a2c37adacf77 100644
--- a/arch/arm/boot/dts/sun8i-a33.dtsi
+++ b/arch/arm/boot/dts/sun8i-a33.dtsi
@@ -215,7 +215,7 @@
 		};
 
 		crypto: crypto-engine@1c15000 {
-			compatible = "allwinner,sun4i-a10-crypto";
+			compatible = "allwinner,sun8i-a33-crypto";
 			reg = <0x01c15000 0x1000>;
 			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
 			clocks = <&ccu CLK_BUS_SS>, <&ccu CLK_SS>;
-- 
2.23.0

