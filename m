Return-Path: <SRS0=MAzA=AM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303D1C433DF
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 08:06:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0982C2073E
	for <linux-crypto@archiver.kernel.org>; Wed,  1 Jul 2020 08:06:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Sn78cx/4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbgGAIGe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 1 Jul 2020 04:06:34 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:44274 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728812AbgGAIGP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Jul 2020 04:06:15 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 06186AjD081356;
        Wed, 1 Jul 2020 03:06:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1593590770;
        bh=urWL+xGplHTB4efaGJSK4KzijW6kDqyDz5lf+3XyQyg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Sn78cx/4JlqOurI8S9/afkSISt9sgKo2Am4h0Z890GpM9JvXVW8jKfPs46ywAIHet
         WpVsfhtRTkUqR4ploWaIXxpykdUr11X3rMmrQCCrBSA1HZXFppXZVaPuXqoZtOoNmp
         09ZgER0U9ACfHcBoNdQwEuu4Ymd1SVSe989BCKzY=
Received: from DLEE102.ent.ti.com (dlee102.ent.ti.com [157.170.170.32])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 06186AVR003591
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 1 Jul 2020 03:06:10 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE102.ent.ti.com
 (157.170.170.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 1 Jul
 2020 03:06:10 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 1 Jul 2020 03:06:10 -0500
Received: from sokoban.bb.dnainternet.fi (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 06185wUi078048;
        Wed, 1 Jul 2020 03:06:09 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     <j-keerthy@ti.com>
Subject: [PATCHv5 6/7] arm64: dts: ti: k3-am6: Add crypto accelarator node
Date:   Wed, 1 Jul 2020 11:05:52 +0300
Message-ID: <20200701080553.22604-7-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200701080553.22604-1-t-kristo@ti.com>
References: <20200701080553.22604-1-t-kristo@ti.com>
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
