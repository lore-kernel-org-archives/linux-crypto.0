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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54CAEECE587
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 33285222C3
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Oct 2019 18:49:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sG1wbLrh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729653AbfJLStI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Oct 2019 14:49:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45687 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729629AbfJLStH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Oct 2019 14:49:07 -0400
Received: by mail-wr1-f67.google.com with SMTP id r5so15207481wrm.12;
        Sat, 12 Oct 2019 11:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1LcPRSweYpxW+Ru1oGSa20C29+Rhu7RNAj0ZxbDdCTI=;
        b=sG1wbLrhfCmPA9sMp4UCnejNy1F05pyeZ+FsGWDdu+dLe3xTQzlyObBhxWS1Yr89kR
         NfoN+YkwGRs/WWpBrJEcQP3KrXjd119hfJdpa0D6jz0O9trrzkUHyApu0h9Oxh/aYCdB
         QWDL9I+1JjZsUjNQhzsqoQCRNrxY/hqlS8RoWQ2moY0jYeiKcE6Uuum13hjbybI1ULDB
         1Jf5nFypsNrJvzdE9gRCEcyTs8NTqBY8mvrQ18opZlE3ZSKBjRmL9HshMrBQYiDTw6UB
         q7okSL84TMKnErWrjN/7QY4kKil59uvVn62vgdHrczXTEzDb6/DiwprY3vokbQWkquIo
         aEzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1LcPRSweYpxW+Ru1oGSa20C29+Rhu7RNAj0ZxbDdCTI=;
        b=aeq3UPEF9Og+Q+H0o5fazQbXW+bN8V6ry5XTLGa4JFBbESGXmxbAblLqt6iFmFsdjk
         M9lsQwO75E8YvaK+2NxDD/5HdrvCq9qYzGuLH9aqTD4CQA0IPgf+uzYe9OkrCPRjuG6F
         a4EdVfXIB3r3F20PJEAnBYwp9PJli/wvGwbwvr+MuHn7y8mZUs9JoX5zgVVLjyBleYdc
         HSop4zxLDAGoix329SHdGBypCR858Oo155uPR6QGhAsDzN5hDc2HLWD9KVFN60hgKUhv
         q2M+dwbCLDfBuPktPrLJ3HDsJTYc+tTGQcQ5ukVXyUqa1mTDQCyVUWxywmiwZpiUupr2
         2Oyw==
X-Gm-Message-State: APjAAAVCE2i802AgHwux4sswo9RKrSU3t+gXN2mElMvfseyHJfmSLFJb
        ZNdN7J/FqB+b1XLV5H95E/U=
X-Google-Smtp-Source: APXvYqwtrLKWcv3YDlXD+KaX9hjHoMmKua998ejNZOkPLNyFnaF5p1rq+zrAWNsTTVRXnoZpLuo4PA==
X-Received: by 2002:a5d:43c2:: with SMTP id v2mr13103667wrr.153.1570906143880;
        Sat, 12 Oct 2019 11:49:03 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id a13sm33670580wrf.73.2019.10.12.11.49.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:49:03 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, mripard@kernel.org, robh+dt@kernel.org,
        wens@csie.org, will@kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH v4 05/11] ARM: dts: sun8i: H3: Add Crypto Engine node
Date:   Sat, 12 Oct 2019 20:48:46 +0200
Message-Id: <20191012184852.28329-6-clabbe.montjoie@gmail.com>
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

This patch enables the Crypto Engine on the Allwinner H3 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm/boot/dts/sun8i-h3.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/sun8i-h3.dtsi b/arch/arm/boot/dts/sun8i-h3.dtsi
index e37c30e811d3..78356db14fbb 100644
--- a/arch/arm/boot/dts/sun8i-h3.dtsi
+++ b/arch/arm/boot/dts/sun8i-h3.dtsi
@@ -153,6 +153,15 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1c15000 {
+			compatible = "allwinner,sun8i-h3-crypto";
+			reg = <0x01c15000 0x1000>;
+			interrupts = <GIC_SPI 94 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>;
+			clock-names = "bus", "mod";
+			resets = <&ccu RST_BUS_CE>;
+		};
+
 		mali: gpu@1c40000 {
 			compatible = "allwinner,sun8i-h3-mali", "arm,mali-400";
 			reg = <0x01c40000 0x10000>;
-- 
2.21.0

