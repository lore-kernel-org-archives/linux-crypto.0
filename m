Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14E91C43142
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC5A264F6C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235384AbhCDAHM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:07:12 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:60740 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1842732AbhCCILK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Mar 2021 03:11:10 -0500
X-UUID: 068f4a0470aa42498db92df92c488324-20210303
X-UUID: 068f4a0470aa42498db92df92c488324-20210303
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <vic.wu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1551120669; Wed, 03 Mar 2021 16:10:19 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs08n1.mediatek.inc (172.21.101.55) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Wed, 3 Mar 2021 16:10:12 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 3 Mar 2021 16:10:12 +0800
From:   Vic Wu <vic.wu@mediatek.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     "David S . Miller" <davem@davemloft.net>,
        Ryder Lee <ryder.lee@mediatek.com>,
        <linux-crypto@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Vic Wu <vic.wu@mediatek.com>
Subject: [PATCH] crypto: mediatek - remove obsolete documentation
Date:   Wed, 3 Mar 2021 16:09:23 +0800
Message-ID: <20210303080923.16761-1-vic.wu@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The crypto mediatek driver has been replaced by the inside-secure driver now.
Remove DT bindings documentation and update crypto engine nodes to the mt7623.dtsi files.

Signed-off-by: Vic Wu <vic.wu@mediatek.com>
Acked-by: Ryder Lee <ryder.lee@mediatek.com>
---
 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt       | 25 -------------------
 arch/arm/boot/dts/mt7623.dtsi                 |  8 +++---
 2 files changed, 3 insertions(+), 30 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/mediatek-crypto.txt

diff --git a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt b/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
deleted file mode 100644
index 450da3661cad..000000000000
--- a/Documentation/devicetree/bindings/crypto/mediatek-crypto.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-MediaTek cryptographic accelerators
-
-Required properties:
-- compatible: Should be "mediatek,eip97-crypto"
-- reg: Address and length of the register set for the device
-- interrupts: Should contain the five crypto engines interrupts in numeric
-	order. These are global system and four descriptor rings.
-- clocks: the clock used by the core
-- clock-names: Must contain "cryp".
-- power-domains: Must contain a reference to the PM domain.
-
-
-Example:
-	crypto: crypto@1b240000 {
-		compatible = "mediatek,eip97-crypto";
-		reg = <0 0x1b240000 0 0x20000>;
-		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_SPI 83 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_SPI 84 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_SPI 91 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_SPI 97 IRQ_TYPE_LEVEL_LOW>;
-		clocks = <&ethsys CLK_ETHSYS_CRYPTO>;
-		clock-names = "cryp";
-		power-domains = <&scpsys MT2701_POWER_DOMAIN_ETH>;
-	};
diff --git a/arch/arm/boot/dts/mt7623.dtsi b/arch/arm/boot/dts/mt7623.dtsi
index aea6809500d7..25e3f3b04123 100644
--- a/arch/arm/boot/dts/mt7623.dtsi
+++ b/arch/arm/boot/dts/mt7623.dtsi
@@ -949,16 +949,14 @@
 	};
 
 	crypto: crypto@1b240000 {
-		compatible = "mediatek,eip97-crypto";
+		compatible = "inside-secure,safexcel-eip97";
 		reg = <0 0x1b240000 0 0x20000>;
 		interrupts = <GIC_SPI 82 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_SPI 83 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_SPI 84 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_SPI 91 IRQ_TYPE_LEVEL_LOW>,
-			     <GIC_SPI 97 IRQ_TYPE_LEVEL_LOW>;
+			     <GIC_SPI 91 IRQ_TYPE_LEVEL_LOW>;
+		interrupt-names = "ring0", "ring1", "ring2", "ring3";
 		clocks = <&ethsys CLK_ETHSYS_CRYPTO>;
-		clock-names = "cryp";
-		power-domains = <&scpsys MT2701_POWER_DOMAIN_ETH>;
 		status = "disabled";
 	};
 
-- 
2.18.0

