Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B44FFC47096
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 15:11:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B11E61375
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Jun 2021 15:11:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbhFAPN1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Jun 2021 11:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234386AbhFAPNY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Jun 2021 11:13:24 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BCCC06174A
        for <linux-crypto@vger.kernel.org>; Tue,  1 Jun 2021 08:11:42 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id c3so14708507wrp.8
        for <linux-crypto@vger.kernel.org>; Tue, 01 Jun 2021 08:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=AAkZStHUHr+LanZ27s/ZUoFUcbytaKBTOQXLG7XH/4I=;
        b=RWncbEcmn3mqcF6u5yjSus3WxbbyJ6khmAPMX6Al6kb3ECT5TXhC/X7YF8FPnq8auL
         ctTEcvmULvuDe5mqoars2IBLKgNUJNxHdbM8UDvmOecYLKcvqv+iLa3t31R+0bmAKiFC
         eAfqLMAGGDsmzF6nHQRJnzof7X6u5dseMXI21rx1oYyazPZXBmdF7g1gY7Ni3mabCJEG
         cPq5815amKDKV3j6i2/DaZH3oN90phBCQk6CYp7skuWuTrByR+R8rVh8hTorQX1o+4oz
         A586OgQW61mX0GXaq6StD7VuQGHr0TIvkKcLvFJWk4swFvzH69Hs8nKYU9m3vfHq4VUH
         Kx8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AAkZStHUHr+LanZ27s/ZUoFUcbytaKBTOQXLG7XH/4I=;
        b=uDjpP9+xXLGe/zvLziDjKfHImQw9hKURBV7Ypf1p0ssaZgegN8sdUp4jndcNqIO3Lh
         Ah1+V9v4OMWGz6JKu7UP1UA8JYwhe80oCmYdrIhvdj4ZhvlipCv69fvjQsPjnVrJpyGu
         LTJzKdW/Sdi5hn4dDROlqOOtAOmnRvoG38WQ1GTftY6Qm7JzcuqP9o82U6Eulxii1GDc
         J7dW0Wtt0tl8nVGRgz0s8Ad/9RfF7S03Etbg8jK8uXkbL4jR6HMrmsP9wDOfNPTS++BT
         WThGiYhuSUzVKK6JYTbFtg0Y79Gqr0cozJDNg/tTwU+muHzshY3Mc+G+CYntN+ZAjfKj
         6SQw==
X-Gm-Message-State: AOAM533Vdl6ZRygfgLXByhUD7AuyKmrJcYj8eGJgPjPbsSWbdsznqeXn
        fNHYS1tXYNjrUsL2nXlHtnksCA==
X-Google-Smtp-Source: ABdhPJzMheEFiKxpaEA/PNjLhjQDNi9mDAKEwFl57f+/HGrLbrvNtbQa3BkO+LBrTJNrYseVueRQqg==
X-Received: by 2002:adf:e7d0:: with SMTP id e16mr12477968wrn.202.1622560301169;
        Tue, 01 Jun 2021 08:11:41 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id f20sm22344163wmh.41.2021.06.01.08.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 08:11:40 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v2 3/5] ARM: dts: gemini: add crypto node
Date:   Tue,  1 Jun 2021 15:11:30 +0000
Message-Id: <20210601151132.1893443-4-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210601151132.1893443-1-clabbe@baylibre.com>
References: <20210601151132.1893443-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The SL3516 SoC has a crypto offloader IP.
This patch adds it on the gemini SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 arch/arm/boot/dts/gemini.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/gemini.dtsi b/arch/arm/boot/dts/gemini.dtsi
index 6e043869d495..cf4b081c13d9 100644
--- a/arch/arm/boot/dts/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini.dtsi
@@ -356,6 +356,14 @@ gmac1: ethernet-port@1 {
 			};
 		};
 
+		crypto: crypto@62000000 {
+			compatible = "cortina,sl3516-crypto";
+			reg = <0x62000000 0x10000>;
+			interrupts = <7 IRQ_TYPE_EDGE_RISING>;
+			resets = <&syscon GEMINI_RESET_SECURITY>;
+			clocks = <&syscon GEMINI_CLK_GATE_SECURITY>;
+		};
+
 		ide0: ide@63000000 {
 			compatible = "cortina,gemini-pata", "faraday,ftide010";
 			reg = <0x63000000 0x1000>;
-- 
2.31.1

