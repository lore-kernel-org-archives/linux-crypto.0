Return-Path: <SRS0=9dQ/=YS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62F66CA9EBD
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 18:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3801C21E6F
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Oct 2019 18:51:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TTLBq6Nz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727741AbfJYSvs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Oct 2019 14:51:48 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40573 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbfJYSvi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Oct 2019 14:51:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id w9so3037172wmm.5;
        Fri, 25 Oct 2019 11:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KGIesSOkGwApOOGAHM3QK9LBzsdCUeL5VgZ/hmT4hUE=;
        b=TTLBq6NzJND6uythkPOsimx2qWJ7DMULExibFcNOgQWbcW69NIJNz/Zd5EAUfhoS6B
         E2z/IT4ilfKnetfuBDXXmmIoSvjqWeWo/1OSrV9PvPQA8wh+0YKJZ8vutfc8AxE4fD1t
         rqtKB8EshoYKYPUGt9p6i0gQl2FYA5R6jukLSfiFQnDgPYjAMLOLF+1YBseLOP1Wkp0i
         BEv7DgUrz7wqhn6MsGgZ5pY85pc88tujKIDxtoM7SFuVBxkl5jQpdkD2OKE8dV72JuUg
         4MZq2szS214OMD19ifPgd2SeQgdRnBsCaGO/cIHYs+YlX/sjVN5tRCMHnkMfq84WdHGY
         tAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KGIesSOkGwApOOGAHM3QK9LBzsdCUeL5VgZ/hmT4hUE=;
        b=fcEqa/tofXY1MhFW3cM0/oSyZSJU1278VPzeNYKVfybQi5HvAic5K61r6ljnHeuRya
         zv6A4QsnEZmM4aFabxMLjyM+T28hPVoeMKqG+sw/lZzKGIxlF/XSkZZIt6lA8XRkSTa/
         6SxMzTb4b2McvY33ylVuwc48GcWMUazYAjGj3IIvFoEh05Cum/nPjSmkKfPcAXamgb/O
         YN9VPgMppnVDhnG0KRwKNOLtdSCwwdX29gh0tcKccgLglp5M2LiHT6yge/PT4e3qGhvZ
         AqYBgO1fMQN29EEtQy7euBP0BQMnmKEEYx1NfhCbq4f3rjZKqNj7SvErEXWtsq5MADgs
         GqPA==
X-Gm-Message-State: APjAAAUG/KdG3TxU9UoY9O3VQ07CXLnRBwYo4NXwTCOP6h3MFhAPBnpJ
        5pAm24Dd2JHvAoAvY8D3cAg=
X-Google-Smtp-Source: APXvYqxDRsHU/WrPkh4yTXfAT1FOirDWF/0Tj/sFEhqwQGBDLAVkLi7VgtoybQ85lECKmR5+LYyBeQ==
X-Received: by 2002:a7b:ce84:: with SMTP id q4mr4528137wmj.36.1572029496587;
        Fri, 25 Oct 2019 11:51:36 -0700 (PDT)
Received: from Red.localdomain (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id l22sm4821683wrb.45.2019.10.25.11.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 11:51:36 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, p.zabel@pengutronix.de,
        robh+dt@kernel.org, wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 3/4] ARM: dts: sun8i: a83t: Add Security System node
Date:   Fri, 25 Oct 2019 20:51:27 +0200
Message-Id: <20191025185128.24068-4-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
References: <20191025185128.24068-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Security System is a hardware cryptographic accelerator that support
AES/MD5/SHA1/DES/3DES/PRNG/RSA algorithms.
It could be found on Allwinner SoC A80 and A83T

This patch adds it on the Allwinner A83T SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-a83t.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-a83t.dtsi b/arch/arm/boot/dts/sun8i-a83t.dtsi
index 74bb053cf23c..53c38deb8a08 100644
--- a/arch/arm/boot/dts/sun8i-a83t.dtsi
+++ b/arch/arm/boot/dts/sun8i-a83t.dtsi
@@ -583,6 +583,15 @@
 			reg = <0x1c14000 0x400>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-a83t-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+			resets = <&ccu RST_BUS_SS>;
+			clocks = <&ccu CLK_BUS_SS>, <&ccu CLK_SS>;
+			clock-names = "bus", "mod";
+		};
+
 		usb_otg: usb@1c19000 {
 			compatible = "allwinner,sun8i-a83t-musb",
 				     "allwinner,sun8i-a33-musb";
-- 
2.21.0

