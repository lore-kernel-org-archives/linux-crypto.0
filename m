Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D31FDC4360C
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF5A42087E
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FRWMocFY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729643AbfJLStH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 14:49:07 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45687 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729626AbfJLStG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 14:49:06 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so15207521wrm.12;
        Sat, 12 Oct 2019 11:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sqDLE8eOD/jzuEBYGSJJdfRbfHzmSxgCPCd3m6sI5BM=;
        b=FRWMocFYj6kFju55yAqo/swB7F1SHMMCVeC4WgHKb72ywUIeJM37QEWpv3UPxjs+3M
         dzTYtk5cbZbDAqvJ0G/7eEuPIjk+BiDAcbS6MfKmz1QGS90SPAWmH5tL8/R+huKbzNq1
         BC36+hXCFzmTEFL4mLunKknwJEXgxKaHDPJ7ju6k+jZvuJII+vfn/SqUC1ZqCQglZmG6
         XNDkR9oq1y83ThHKmLYocZiIzgwb1lW6wpeU0qYeuFSHWVtc+BqxYK1jS2oKvUjzlu6R
         4wrDmn61lqmPOun2nbH60rAdrFAQNs5bGfAmruqPwm7eKQ0lVKl+ZhO2vCrlmas4V6rK
         7gqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sqDLE8eOD/jzuEBYGSJJdfRbfHzmSxgCPCd3m6sI5BM=;
        b=sE6v2tCG1dHXp2+rZsk9ZYfZBnDuJ9tNU/6I5Y/0HqStF8niXBsWVb5S2hia15cVCh
         09llUNQ+9wK5+hMonjymBo7xfHrVLDm8XLv9zKBfR9gkRLZndZ5wylm8HRnTFLVeI8co
         zjoNY+VlBErvMpYuRxGsyo70IGa73BkHwzxjvQbK80u7HAD3Z8F39Pjm73i6BnxdLyQY
         ZRwu2dxRV+CFpAH81QF1YH8rVBxvpWjfBTdb64JnXs+27aZ16GZsYsccR8Hbd7ak6Ih6
         xF9SKHyDH7n6hmmhj5ka5z8DH3uDHs0H6Qbujeo2v0G+rtL79fAKAWhi4P3mq5hgW47s
         X//A==
X-Gm-Message-State: APjAAAUCp3R+T5Uw6tr0CTjX2WY0pJb0j3B2FKfqgynbSgzcbhgYV4kb
        PlHtA5Vm+mx2L79gEduaLSs=
X-Google-Smtp-Source: APXvYqxOlaS/CpVCGcylTHA6rWuO7yxu6b5Fe+63OMY0v/jTG/iqJ3LKbPwvu/3C6QJeF2ZhgFoWsg==
X-Received: by 2002:adf:df81:: with SMTP id z1mr18921965wrl.367.1570906145208;
        Sat, 12 Oct 2019 11:49:05 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a13sm33670580wrf.73.2019.10.12.11.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:49:04 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 06/11] ARM64: dts: allwinner: sun50i: Add Crypto Engine node on A64
Date:   Sat, 12 Oct 2019 20:48:47 +0200
Message-Id: <20191012184852.28329-7-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
References: <20191012184852.28329-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic accelerator that supports
many algorithms.
It could be found on most Allwinner SoCs.

This patch enables the Crypto Engine on the Allwinner A64 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
index 70f4cce6be43..0287d8458675 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a64.dtsi
@@ -478,6 +478,15 @@
 			reg = <0x1c14000 0x400>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun50i-a64-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+		};
+
 		usb_otg: usb@1c19000 {
 			compatible = "allwinner,sun8i-a33-musb";
 			reg = <0x01c19000 0x0400>;
-- 
2.21.0

