Return-Path: <SRS0=yFEM=YD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ACA3ECE58D
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B9D2190F
	for <linux-crypto@archiver.kernel.org>; Thu, 10 Oct 2019 18:24:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jHD68LNy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfJJSYB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 10 Oct 2019 14:24:01 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35020 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfJJSYA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Oct 2019 14:24:00 -0400
Received: by mail-wm1-f66.google.com with SMTP id y21so7768603wmi.0;
        Thu, 10 Oct 2019 11:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U0bXFZtZxRLCBkdXsKMyb9zQdwkvrsk2DYrybLJs1HU=;
        b=jHD68LNyZNEqrWyossZVKYNEwMQRWa7V14HWf3oCVwLGf2T5d23iDySGUekDPskWRo
         AG4SZF6A+GZGyH2POnDZsRxkjWy0vSMefjgQMSUtJ+txlJzWBCgum3ItRm2jqPDgBfWk
         DW8BtPzpIDoxS52M//UfXT8J7aTlni+NbV8mmxSk3+oOzBl6yvi4rN1HWqtGLVK/zO6h
         A+Uo9X5QFJgnDnMTxpItX37uTJF/Sx6kGKMBNX9upCY4PzGfn0o4XqMhcjZVzL9lq1yU
         pq9Du6FRkncwH6zDtC9WBRxaoMlp3qpZ2U8NOqB9vNS45/GiT9SeCbUGjr9cT/TtIyBY
         Jzyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U0bXFZtZxRLCBkdXsKMyb9zQdwkvrsk2DYrybLJs1HU=;
        b=PGIGidjbjdWWSHPQWy8riGu08UekKt3Q6yHMjoR0e8xehX+y/mm6r8sDV1vACmiPpW
         DWe+PHsOcUqezIRQQXwruv4e9aY0+aZC0khi2b4/gL7rZYzX3IgiB3VwvryNEOnm6kEY
         p5NLgl7L6o5hjYmqCpGDZ/ooPXnLCDj+tSU0OFUmsrc2PDATwAOwHmWsZqBvgo7SbYDB
         NGvudQOmZjtycHO9GBtZX+DXFqaykTBwDY692S/swTEQ9i/qE6GeFllndTPbaVsl+65c
         5GUfT27kZMgg/xQmm1fR/EDdz5B0+jvZl099IYn6KKm4V9cnd0lMrYNtY8m3M11HeW0M
         OSWw==
X-Gm-Message-State: APjAAAXPd3lyPULIUZLx+STWX/17EvQFOItAVSPwyEL56O373K6odfmi
        VcAzxe93VnAK7CqBXFpc4ls=
X-Google-Smtp-Source: APXvYqxofRBu0ObJYQe2/ofB+iluWNmJKI+Zh7K9b7aB2BAnHbOKcNw825vEB9xlcblHSD/p5UflsA==
X-Received: by 2002:a05:600c:24c9:: with SMTP id 9mr9130050wmu.174.1570731838108;
        Thu, 10 Oct 2019 11:23:58 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id y186sm11367664wmb.41.2019.10.10.11.23.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 11:23:57 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v3 04/11] ARM: dts: sun8i: R40: add crypto engine node
Date:   Thu, 10 Oct 2019 20:23:21 +0200
Message-Id: <20191010182328.15826-5-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
References: <20191010182328.15826-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic offloader that supports
many algorithms.
It could be found on most Allwinner SoCs.

This patch enables the Crypto Engine on the Allwinner R40 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-r40.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-r40.dtsi b/arch/arm/boot/dts/sun8i-r40.dtsi
index c9c2688db66d..1da08cdb8311 100644
--- a/arch/arm/boot/dts/sun8i-r40.dtsi
+++ b/arch/arm/boot/dts/sun8i-r40.dtsi
@@ -266,6 +266,16 @@
 			#phy-cells = <1>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-r40-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "bus";
+		};
+
 		ehci1: usb@1c19000 {
 			compatible = "allwinner,sun8i-r40-ehci", "generic-ehci";
 			reg = <0x01c19000 0x100>;
-- 
2.21.0

