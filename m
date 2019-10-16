Return-Path: <SRS0=0DWe=YJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02335FA3728
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 13:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C6FF021928
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Oct 2019 13:34:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vfOKhkD/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405435AbfJPNeA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Oct 2019 09:34:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38661 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405422AbfJPNeA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Oct 2019 09:34:00 -0400
Received: by mail-wr1-f65.google.com with SMTP id y18so18651958wrn.5;
        Wed, 16 Oct 2019 06:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dpe0zCbR3c1VkH/n1U/vOC6ekNORqcDkTSfYoQ4laf4=;
        b=vfOKhkD/B4LEg6089Khw6AZt10guS5PRPkM3bMi0lgUqnTMUx0pI1R8LsienxZEMm2
         E05kaPmoQtQvR2H7jKVnidLwW3Vejkt1ELE9yb6dTGA2vAXYEYNry0LWvHFcAA0NMpOv
         k9G0Md+1zn8hR7VVE4Uz7lwin5Z9FyvKKqdFUOnLGNqjbls1aQdFZSeEunuMxh26BU81
         QtFKBERwt2fYrJOFrRPVY3TP6wi6aJ4kvsqpXHpYY4+AV4mzKPJkNxdtZSnIoibCMRuB
         E5ylZ26gQET4N1EgAmHkHImIdXAjm+dZYd0rRiSNOvxBD/pevTw0thJR010OqXlc0IAd
         tDtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dpe0zCbR3c1VkH/n1U/vOC6ekNORqcDkTSfYoQ4laf4=;
        b=Gs5rQOZNvDDaxWPHN1bf00MJnr/soXR0S6uvw7Ed5VjOUDB4ZXQKo4gb9nuc1YkWHZ
         awZ1J9EaulnseL+ia7ePpLtWRqpHs3g3hI6ORLwr+zHZgR81m6FSmDILEtOug1Llqeec
         k2nnnvQBZ+9mZd/N3O5phjYHvF30wiAVDHbSz7rQxyJlqcWlzHOR95nZzecZ+hYZ0VO+
         JFlqloyw1wG7DVB/QHjqAGSMuZX9EOFwmSGRyK908BSbkYqmyJkgefhez+puq1PNqQ8V
         ipUL9EReZuVJSV8BvG24QqVLGirTYDhgBPAY0yvvI9sjN3A25mfZwkWV8L3poAG7UBWH
         yxEw==
X-Gm-Message-State: APjAAAW/7DjDzuMnIJwGGARNdb+ogjdisiHu+erzA8jnUHA8omImknLu
        6IVVoAIYe9mXBV7bhLisbC0=
X-Google-Smtp-Source: APXvYqxz+OWi0tp3OSsbB23tWAXSlMcqgwlRvvpcPVUGZGYuP9JlM3ADHjooxy1QYXOvh/7QHnqaEQ==
X-Received: by 2002:a5d:5011:: with SMTP id e17mr2790378wrt.160.1571232835526;
        Wed, 16 Oct 2019 06:33:55 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id h17sm3139998wme.6.2019.10.16.06.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 06:33:54 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 4/4] ARM: dts: sun9i: a80: Add Security System node
Date:   Wed, 16 Oct 2019 15:33:45 +0200
Message-Id: <20191016133345.9076-5-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191016133345.9076-1-clabbe.montjoie@gmail.com>
References: <20191016133345.9076-1-clabbe.montjoie@gmail.com>
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

