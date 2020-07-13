Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8905AC433E6
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 08:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 658FB2067D
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 08:34:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Sgl1vUj9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgGMIe4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:34:56 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:57454 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbgGMIez (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 04:34:55 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06D8YlDd033399;
        Mon, 13 Jul 2020 03:34:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1594629287;
        bh=urWL+xGplHTB4efaGJSK4KzijW6kDqyDz5lf+3XyQyg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Sgl1vUj9dfK0UTvbeNbj2klBGadtFo2XmobLxmz68IYmSSlSTy1SUujeMe1+u67rN
         Eh6Pp/CsYFwAknzRaXPEzTxPFALcn5t4izCkOXqyVKdHawfWX2iC/J1x2zi7dYs2rF
         0ba36HyJKvBU2xNTPbOqyPc9Kyeahf0VwWsHx1AM=
Received: from DLEE107.ent.ti.com (dlee107.ent.ti.com [157.170.170.37])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06D8YlBW040833
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jul 2020 03:34:47 -0500
Received: from DLEE106.ent.ti.com (157.170.170.36) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 13
 Jul 2020 03:34:46 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 13 Jul 2020 03:34:46 -0500
Received: from sokoban.bb.dnainternet.fi (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06D8YYi8032127;
        Mon, 13 Jul 2020 03:34:45 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <j-keerthy@ti.com>, <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv6 6/7] arm64: dts: ti: k3-am6: Add crypto accelarator node
Date:   Mon, 13 Jul 2020 11:34:26 +0300
Message-ID: <20200713083427.30117-7-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713083427.30117-1-t-kristo@ti.com>
References: <20200713083427.30117-1-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Keerthy <j-keerthy@ti.com>

Add crypto accelarator node for supporting hardware crypto algorithms,
including SHA1, SHA256, SHA512, AES, 3DES, and AEAD suites.

Signed-off-by: Keerthy <j-keerthy@ti.com>
[t-kristo@ti.com: Modifications based on introduction of yaml binding]
Signed-off-by: Tero Kristo <t-kristo@ti.com>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 61815228e230..4615f2009a35 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -112,6 +112,28 @@
 		power-domains = <&k3_pds 148 TI_SCI_PD_EXCLUSIVE>;
 	};
 
+	crypto: crypto@4E00000 {
+		compatible = "ti,am654-sa2ul";
+		reg = <0x0 0x4E00000 0x0 0x1200>;
+		power-domains = <&k3_pds 136 TI_SCI_PD_EXCLUSIVE>;
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges = <0x0 0x04E00000 0x00 0x04E00000 0x0 0x30000>;
+		status = "okay";
+
+		dmas = <&main_udmap 0xc000>, <&main_udmap 0x4000>,
+				<&main_udmap 0x4001>;
+		dma-names = "tx", "rx1", "rx2";
+		dma-coherent;
+
+		rng: rng@4e10000 {
+			compatible = "inside-secure,safexcel-eip76";
+			reg = <0x0 0x4e10000 0x0 0x7d>;
+			interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
+			clocks = <&k3_clks 136 1>;
+		};
+	};
+
 	main_pmx0: pinmux@11c000 {
 		compatible = "pinctrl-single";
 		reg = <0x0 0x11c000 0x0 0x2e4>;
-- 
2.17.1

--
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki. Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki
