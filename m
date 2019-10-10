Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4163C4360C
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A9D220659
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HI5JYbO/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfJJSYi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 14:24:38 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33919 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfJJSYB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 14:24:01 -0400
Received: by mail-wm1-f68.google.com with SMTP id y135so7716797wmc.1;
        Thu, 10 Oct 2019 11:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gDfhtZCLPDiZh+UMPgLmWJp3cqUK6R/GqJrZEV/WY7A=;
        b=HI5JYbO/+oZvLigOOYZezrKnK2wJFmO0mHsbk13fKijaG3qdFAaIy1TsftNv21OH/N
         OIMx019JiO3prdIC14IbegQokiWc4CCJ9v1bBZ4S8naddle7FrqwrkYvlHP/1U40vh9z
         OwdGudcVfrS+CqvK/qAo6+vVfbeNDVta4hL0rGwnKPMTWjzKxvBZaqMY6VTM8rDKR9o6
         ifj82BC91rW1kt2iQI/osiH7aPtseWFRDklGVUZMBkk4eA4Bbi4ctEY6WfWwumA+/hkw
         YgT3VnkisKTK4FExdA7JnwUX8K57ZGzJ75VUfSfM5QxTCl0fZaYb4UsoyEgGfRGwoxhV
         eJ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gDfhtZCLPDiZh+UMPgLmWJp3cqUK6R/GqJrZEV/WY7A=;
        b=X/a1yRkHc4Txm5Vw6QZsKXXBxIf+fEx5YyolwMS4q3i4PXMdIJfsf+XvxY8HWCMN1a
         hH9ob9jnXs2reaNRtksrY+FfTQ+9dEDSXzx4Xk+RLLcRTO5o33o6WENxkRTbS5ma7JoR
         yZRqO+oBmDNYPhZDFL5sjLcV81Dzs12m5PUY0akoqjUYT44Snf3ZnoUnbjKvlUGSPy7B
         RVd7Hox5mRnKqzQxADB+UIIHXUVfd3lwYJBPf4KYgoa7nfIB8tyW1eDS6UoIhX5vzi+i
         Z+gWU3XUgmyI21pgSoQMKHgV4hAFPWF79VJwaAxTjG6k658Al9rStD/vnQwxFrGZRtSL
         pc2g==
X-Gm-Message-State: APjAAAULbodwqK5pZqAZ/cjHRr/uCAa3SKRYLn7c3jGEUWK1YX11SNnE
        L3nYETugFqfGSOu0WrTUyLU=
X-Google-Smtp-Source: APXvYqzeZD0H1oDK7XStvFyndivwViMv2OhtPKWW65Oxrr3rQ6RL+LdyP7zHHPxkZS+5ICVwKvG2hg==
X-Received: by 2002:a05:600c:2549:: with SMTP id e9mr8090591wma.74.1570731839866;
        Thu, 10 Oct 2019 11:23:59 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y186sm11367664wmb.41.2019.10.10.11.23.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 11:23:59 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 05/11] ARM: dts: sun8i: H3: Add Crypto Engine node
Date:   Thu, 10 Oct 2019 20:23:22 +0200
Message-Id: <20191010182328.15826-6-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
References: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
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
 arch/arm/boot/dts/sun8i-h3.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index e37c30e811d3..046a32540b73 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -153,6 +153,16 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-h3-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "bus";
+		};
+
 		mali: gpu@1c40000 {
 			compatible = "allwinner,sun8i-h3-mali", "arm,mali-400";
 			reg = <0x01c40000 0x10000>;
-- 
2.21.0

