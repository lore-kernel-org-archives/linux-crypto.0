Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4189C5B578
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBBA22063F
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:28:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="wTgnMSG1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726983AbfF1E2I (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 00:28:08 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58080 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbfF1E2C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 00:28:02 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S4Rsjg003036;
        Thu, 27 Jun 2019 23:27:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561696074;
        bh=y47Dmxqdu2axu8XFuL5chdma5kAOZBKLQnnNccav38w=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=wTgnMSG1EnCSpzKdj0L05ZF21h4ZXDMeep3xa+FESUPz/zN2EaeijIQFEI3gcJ2FV
         I74buze/0BngPIlAXc7CKxkXZ2GpHDFBPdmPi+C2ckC/W5T1dN2w1a2T/oynpEn9do
         6ngzyrV/5xkWdy+E8giwq8qVNyiEtwjD0Lu9AQ4c=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S4RsqR032679
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Jun 2019 23:27:54 -0500
Received: from DFLE104.ent.ti.com (10.64.6.25) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 27
 Jun 2019 23:27:54 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE104.ent.ti.com
 (10.64.6.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 27 Jun 2019 23:27:54 -0500
Received: from a0393675ula.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RKPU062595;
        Thu, 27 Jun 2019 23:27:51 -0500
From:   Keerthy <j-keerthy@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <j-keerthy@ti.com>, <linux-crypto@vger.kernel.org>, <nm@ti.com>
Subject: [RESEND PATCH 10/10] arm64: dts: k3-am6: Add crypto accelarator node
Date:   Fri, 28 Jun 2019 09:57:45 +0530
Message-ID: <20190628042745.28455-11-j-keerthy@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628042745.28455-1-j-keerthy@ti.com>
References: <20190628042745.28455-1-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add crypto accelarator node. Define the psil specific config
node as well. This can be used in Packet Mode alone.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi | 33 ++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
index 91ca5bfeefc2..5e4f9ec39f01 100644
--- a/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am65-main.dtsi
@@ -91,6 +91,39 @@
 		power-domains = <&k3_pds 148>;
 	};
 
+	crypto: crypto@4E00000 {
+		compatible = "ti,sa2ul-crypto";
+		label = "crypto-aes-gbe";
+		reg = <0x0 0x4E00000 0x0 0x1200>;
+
+		status = "okay";
+		ti,psil-base = <0x4000>;
+
+		/* tx: crypto_pnp-1, rx: crypto_pnp-1 */
+		dmas = <&main_udmap &crypto 0 UDMA_DIR_TX>,
+				<&main_udmap &crypto 0 UDMA_DIR_RX>,
+				<&main_udmap &crypto 1 UDMA_DIR_RX>;
+		dma-names = "tx", "rx1", "rx2";
+
+		ti,psil-config0 {
+			linux,udma-mode = <UDMA_PKT_MODE>;
+			ti,needs-epib;
+			ti,psd-size = <64>;
+		};
+
+		ti,psil-config1 {
+			linux,udma-mode = <UDMA_PKT_MODE>;
+			ti,needs-epib;
+			ti,psd-size = <64>;
+		};
+
+		ti,psil-config2 {
+			linux,udma-mode = <UDMA_PKT_MODE>;
+			ti,needs-epib;
+			ti,psd-size = <64>;
+		};
+	};
+
 	main_pmx0: pinmux@11c000 {
 		compatible = "pinctrl-single";
 		reg = <0x0 0x11c000 0x0 0x2e4>;
-- 
2.17.1

