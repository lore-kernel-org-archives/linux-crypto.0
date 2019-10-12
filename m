Return-Path: <SRS0=sxdd=YF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D1BDC4CECE
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4774A2087E
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SA7/NNFe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbfJLStd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 14:49:33 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35202 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728688AbfJLStI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 14:49:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id v8so15257164wrt.2;
        Sat, 12 Oct 2019 11:49:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BlSNEKakkPz3qSacpRbF5fymVNSJO3OQiWGq/ZKj+yQ=;
        b=SA7/NNFeQ98FEGXx1+uVXTnACJz8MTst5089OK206YuwU6jlcpacc5B9z4UOuyyNGw
         ke71/7POGluofgAfCHwJhIrCk3Nin4mRz+PEjsU+uTKiqE3vnMJT+CS7IiBrUrbxNcwJ
         16wlIFHjEPuIKXMa6jct1K47TC+wUDgLzpZ2OxvpscHTmj4oJTPE0q7T4QlnfScmLrH/
         RHuoyRksoDzbj6rhULw77apsYHcBmmm1cnnDIBpEoloI26ulj2PHZOqISdZbCQ8+cGV9
         ViTaIJ9vRXkg/KxI6kNNebgSAmGrLYKBEdQtpWW7uqMar2Op/2p7YnN2AKKHkqOPnh64
         MbiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BlSNEKakkPz3qSacpRbF5fymVNSJO3OQiWGq/ZKj+yQ=;
        b=IWs533N4GCd2zebhA3jDa3t7OZRJxjB8HhjIU9kllsWNtdosbQknuxZDgSq0UtCOfO
         uk2xhx0aXjNvtOSVP19REVNkmF+hXE6i4vZRBxXYzNnVaXXFkUW5/SzepklXfHwt7rde
         i6btc7OaQ12mRchMK0NoYjrDInFQ12tpOQO/HWme9MWI6U5RU8zsWyvccmuGNSyn6bv/
         TcPl5cCmlVC3s4EGCKjVp8B+xU0AfoKphJ89mKhYS72c8svtcs+/yCLsuTrYmz2dFpie
         v6CCZxGjsY5/GM5muuJlE3PYMpYps4WoKLejdgjNn+wQvDMgu4a8Dlpktrw3Uxh0EK0J
         MEpg==
X-Gm-Message-State: APjAAAUhxzKKb5ySLdNc9sf5MINUW4g/eM/DIBeWUGDQhimQS412xB0F
        RtlHPetPhF9pNYOwzFJScn8=
X-Google-Smtp-Source: APXvYqxfCjt/RqeTgVtsWQpkZ0VRN2BvNX4AuzG6Hw4yEBb6II3Qtz4jIguKLO25SuRfFbZlsuxFZA==
X-Received: by 2002:adf:ff82:: with SMTP id j2mr19206783wrr.356.1570906146460;
        Sat, 12 Oct 2019 11:49:06 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a13sm33670580wrf.73.2019.10.12.11.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:49:05 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 07/11] ARM64: dts: allwinner: sun50i: Add crypto engine node on H5
Date:   Sat, 12 Oct 2019 20:48:48 +0200
Message-Id: <20191012184852.28329-8-clabbe.montjoie@gmail.com>
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

