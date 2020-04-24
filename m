Return-Path: <SRS0=W4lJ=6I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABEEFC54FCB
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 16:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CFC920728
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Apr 2020 16:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="PKStFdgl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgDXQpH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Apr 2020 12:45:07 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:36514 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbgDXQpG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Apr 2020 12:45:06 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03OGj0Y6125934;
        Fri, 24 Apr 2020 11:45:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587746700;
        bh=5OyXkewc+Kn9FLREBcSoDlBcSAoQbLaJSLz2ZT75tfg=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=PKStFdgl/MTkS/xuu7FaM1xD4lEELLfZKJgn6lxspiKyf5T+RYuttz1DITAHM5/i4
         ZahY/S/nOq4Gspl5leNxr6Mc8V1Hw9XZo1XYQ6DvGetZikS4Gzl28iy0+Pd02wtkCc
         GWq0PeVcOrFE8hPjEuyxIy4OHeal3ttjyfS2D1TE=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03OGj021044847;
        Fri, 24 Apr 2020 11:45:00 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 24
 Apr 2020 11:45:00 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 24 Apr 2020 11:45:00 -0500
Received: from sokoban.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03OGinTB033554;
        Fri, 24 Apr 2020 11:44:59 -0500
From:   Tero Kristo <t-kristo@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>
CC:     Keerthy <j-keerthy@ti.com>
Subject: [PATCHv2 6/7] arm64: dts: ti: k3-am6: Add crypto accelarator node
Date:   Fri, 24 Apr 2020 19:44:29 +0300
Message-ID: <20200424164430.3288-7-t-kristo@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200424164430.3288-1-t-kristo@ti.com>
References: <20200424164430.3288-1-t-kristo@ti.com>
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
index 11887c72f23a..4602ca8e2392 100644
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
