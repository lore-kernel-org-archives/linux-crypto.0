Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56852C43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 302B521670
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 18:46:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oqF++9+S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436641AbfIFSqj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 6 Sep 2019 14:46:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46701 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395376AbfIFSqR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 6 Sep 2019 14:46:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id h7so7599990wrt.13;
        Fri, 06 Sep 2019 11:46:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5t3zhoR3RfkeeCxhIwf2rf3xgfwu01/OJcOf9PrEec=;
        b=oqF++9+SpbMo/KW24R+/jjUd2tj8D9lulEIyiUTjAaqRg9yH+SueSFntF23gdNjUeT
         CKRO/mKS4pkej7wwckSIO95TxZ71BMjA201QBlQFpIutN9WDYyRrdtSU1abY2rDEcSoa
         rpMmiggvRfxQcaG2tmvtxZJ9R4lbZsUFJqHUoH5CX0BR4gLTMKUh9qpo4wICvfPJdVd5
         i5AfRQ58PxxuyiXuxq+WPpyMa688V5TbGoiNu1qwLj9AstCZGnNIDckKRTfJ7cIB62kG
         33xPZ/sHi+NQ7Gn1EY6w5FzBwH1a2WmYJKohrVGuo8KFR6I8AduANY9gH8hfmG4myh3u
         9A+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5t3zhoR3RfkeeCxhIwf2rf3xgfwu01/OJcOf9PrEec=;
        b=GiGUMG/4Fc7CF7C7QTSc9JQh/hE4oNc+Bg71URckJ6RbcJFEoNwFIJ090OCQxIaHTG
         FFiL0+Ma3hu5op+S2ZwLcDL287Y7M5k/wBf0FT2AM7D1QZ9BO///D9WiBLnc9+1T9Nbs
         Y7lDtxq/FEebyMCK29LgJ3h/Zo6CyTlMoGhv1jcuaVSLwujuiqZVn8AAXVn2fkBAH/fU
         6wQ8y7FH1VGyMgm8/2vOvjMth3m0KuADOhbAoLDL3mvvkM+zq6CQ/TKNdxsNMBYo3Bpf
         lXPVoFnQGm3qDruSuHCEvTWWeiJ1GQldokJAcdI00hnPQNVBRuX+zQFJ576Q36Nkm31w
         naAw==
X-Gm-Message-State: APjAAAXltZfBAU9GQbii3ALyYez2Y6Bwmh0BsLqaxdc3MP2nx/sQ98Hl
        jhOYOq1QK5PDP4Gcu1b/DyY=
X-Google-Smtp-Source: APXvYqxd5fVSBGAObcD5kqUHTqNYg4ew2h9AYvB8irXufaBYEpdRX5dLgjHGxv2PBsEVbxFIdoGj+A==
X-Received: by 2002:a5d:4408:: with SMTP id z8mr8252982wrq.106.1567795574866;
        Fri, 06 Sep 2019 11:46:14 -0700 (PDT)
Received: from Red.localdomain ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id j1sm8677577wrg.24.2019.09.06.11.46.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 Sep 2019 11:46:14 -0700 (PDT)
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, mripard@kernel.org,
        robh+dt@kernel.org, wens@csie.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: [PATCH 8/9] ARM64: dts: allwinner: sun50i: Add Crypto Engine node on H6
Date:   Fri,  6 Sep 2019 20:45:50 +0200
Message-Id: <20190906184551.17858-9-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Crypto Engine is a hardware cryptographic accelerator that supports
many algorithms.

This patch enables the Crypto Engine on the Allwinner H6 SoC Device-tree.

Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
index 0754f01fd731..51762499ed06 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6.dtsi
@@ -149,6 +149,16 @@
 			allwinner,sram = <&ve_sram 1>;
 		};
 
+		crypto: crypto@1904000 {
+			compatible = "allwinner,sun50i-h6-crypto";
+			reg = <0x01904000 0x1000>;
+			clocks = <&ccu CLK_BUS_CE>, <&ccu CLK_CE>, <&ccu CLK_MBUS_CE>;
+			clock-names = "ahb", "mod", "mbus";
+			resets = <&ccu RST_BUS_CE>;
+			reset-names = "ahb";
+			interrupts = <GIC_SPI 87 IRQ_TYPE_LEVEL_HIGH>;
+		};
+
 		syscon: syscon@3000000 {
 			compatible = "allwinner,sun50i-h6-system-control",
 				     "allwinner,sun50i-a64-system-control";
-- 
2.21.0

