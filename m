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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95196ECE58A
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FCCD21924
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Oct 2019 18:42:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EC5x3JwI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfJASmc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:42:32 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45945 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726602AbfJASl5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Oct 2019 14:41:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id r5so16713445wrm.12;
        Tue, 01 Oct 2019 11:41:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xi1PY45A9Lda1Y/IC4dXlxysdfAnSBFMqs5iPhi/26s=;
        b=EC5x3JwIylYQhvAu+JOamaLobk+oW0aExLC799Z4z9fPyYJ89gDZcisO9TRmBbVBp+
         lI5Z7V6JScNpSW299UlXWnqWlz6F9bKr2r/n+I2K/WS439+NUIath3JX28iqz+gVU0CF
         7kaNoALlmdHAxkEpYeGIjYQlTmPSmAmRERSpUGlZwTmLFWvC+ygvBuP1ueVBdU2+Bgny
         mRPFoNrfDF9ddT1Rpzdw6TtGD1GFaI/tqK32mb6o/DOnxSV+KnoW9YzZsAJlR3XZAL4v
         /o8DqYg3q7PUDpOyEauSFQTt6IvqR0Mi96MUSSi/pcsvjgW+JsaSikrHcqyrdVrU9SMZ
         pL5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xi1PY45A9Lda1Y/IC4dXlxysdfAnSBFMqs5iPhi/26s=;
        b=t+tz38zSs5E9G8ckxAU3Zpy3cyPIXYNMKOuvGtdqBh3GKOsLj/WzaVya1Vz62qKrWX
         AFQd184wglGF6ZSF5SlcKz5ue54gLCt2Wms7JuOaCE6ReuFxmBs7F4TOgfa8m7RFgare
         TwaFJnhqPrC2bHhiYRTL9nz9NIM+V0aoYM/7IkXZL0YrBbPRWx6+U/ejR5D3Gon4X47V
         KK1wD+1Kxb2cBgh4v6rfRpu52dU8zOYnzt1cBPpIJTdPhTnZd1ACH0Dud9pNieI5+CzZ
         OC/gfcm7JQX1RaZ49V8rgpl4WybHRTXW/yTGCQ7j7ACl0qPCdu9CqDBaRwftg2xN3Gtg
         Rn0Q==
X-Gm-Message-State: APjAAAU3LsodZo/i95BtwdGcVZJy70iSeyMHb1YuDR/Qcb/RUi2SD28z
        sa385YcZU7DPWlNS1HtahLw=
X-Google-Smtp-Source: APXvYqxY9Qp528krfwvGQD1zr1FhtrsC61+CpRlyWYj7vK188LT443AuVK7BAKzKWr+dGgHXn1T8ug==
X-Received: by 2002:adf:e9c5:: with SMTP id l5mr18834973wrn.40.1569955314989;
        Tue, 01 Oct 2019 11:41:54 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id n8sm6788987wma.7.2019.10.01.11.41.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 01 Oct 2019 11:41:54 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v2 05/11] ARM: dts: sun8i: H3: Add Crypto Engine node
Date:   Tue,  1 Oct 2019 20:41:35 +0200
Message-Id: <20191001184141.27956-6-clabbe.montjoie@gmail.com>
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

This patch enables the Crypto Engine on the Allwinner H3 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-h3.dtsi | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index e37c30e811d3..778a23a794c9 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -153,6 +153,17 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-h3-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "ce_ns";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "bus";
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+		};
+
 		mali: gpu@1c40000 {
 			compatible = "allwinner,sun8i-h3-mali", "arm,mali-400";
 			reg = <0x01c40000 0x10000>;
-- 
2.21.0

