Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FEFCC5B579
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:27:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 687BB208CB
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 04:27:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="jEzNuh2h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbfF1E1f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 00:27:35 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:58018 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726240AbfF1E1f (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 00:27:35 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RRDV002933;
        Thu, 27 Jun 2019 23:27:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561696047;
        bh=Naw4jhqGjLB8jwbjXzxM4e42Xzg07p8Ordo2UvFves4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=jEzNuh2hP8N4tQSx4UAScuPT/vH3dpVQtrM9PzrHOK0FUpUt9GNitLEoG+zPMsWlJ
         ifgLE8XDIfyc3jZR8sBx2vSbK8wzFMWVROh93Xt4NeqqrXD30Q3PswVoheqmowEgRg
         FnO4504njXnu/mL0CPsDKkPLFiuIRc6sggZ8Aczk=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5S4RRKc032476
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 27 Jun 2019 23:27:27 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 27
 Jun 2019 23:27:26 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 27 Jun 2019 23:27:26 -0500
Received: from a0393675ula.india.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5S4RKPL062595;
        Thu, 27 Jun 2019 23:27:24 -0500
From:   Keerthy <j-keerthy@ti.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <t-kristo@ti.com>,
        <j-keerthy@ti.com>, <linux-crypto@vger.kernel.org>, <nm@ti.com>
Subject: [RESEND PATCH 01/10] dt-bindings: crypto: k3: Add sa2ul bindings documentation
Date:   Fri, 28 Jun 2019 09:57:36 +0530
Message-ID: <20190628042745.28455-2-j-keerthy@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190628042745.28455-1-j-keerthy@ti.com>
References: <20190628042745.28455-1-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The series adds Crypto hardware accelerator support for SA2UL.
SA2UL stands for security accelerator ultra lite.

The Security Accelerator (SA2_UL) subsystem provides hardware
cryptographic acceleration for the following use cases:
• Encryption and authentication for secure boot
• Encryption and authentication of content in applications
  requiring DRM (digital rights management) and
  content/asset protection
The device includes one instantiation of SA2_UL named SA2_UL0

SA2UL needs on tx channel and a pair of rx dma channels.

Signed-off-by: Keerthy <j-keerthy@ti.com>
---
 .../devicetree/bindings/crypto/sa2ul.txt      | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/sa2ul.txt

diff --git a/Documentation/devicetree/bindings/crypto/sa2ul.txt b/Documentation/devicetree/bindings/crypto/sa2ul.txt
new file mode 100644
index 000000000000..81cc039673b4
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/sa2ul.txt
@@ -0,0 +1,47 @@
+K3 SoC SA2UL crypto module
+
+Required properties:
+
+- compatible : Should be:
+  - "ti,sa2ul-crypto"
+- reg : Offset and length of the register set for the module
+
+- dmas: DMA specifiers for tx and rx dma. sa2ul needs one tx channel
+	and 2 rx channels. First rx channel for < 256 bytes and
+	the other one for >=256 bytes. See the DMA client binding,
+        Documentation/devicetree/bindings/dma/dma.txt
+- dma-names: DMA request names has to have one tx and 2 rx names
+	corresponding to dmas abive.
+- ti,psil-config* - UDMA PSIL native Peripheral using packet mode.
+	SA2UL must have EPIB(Extended protocal information block)
+	and PSDATA(protocol specific data) properties.
+
+Example AM654 SA2UL:
+crypto: crypto@4E00000 {
+	compatible = "ti,sa2ul-crypto";
+	reg = <0x0 0x4E00000 0x0 0x1200>;
+	ti,psil-base = <0x4000>;
+
+	dmas = <&main_udmap &crypto 0 UDMA_DIR_TX>,
+		<&main_udmap &crypto 0 UDMA_DIR_RX>,
+		<&main_udmap &crypto 1 UDMA_DIR_RX>;
+	dma-names = "tx", "rx1", "rx2";
+
+	ti,psil-config0 {
+		linux,udma-mode = <UDMA_PKT_MODE>;
+		ti,needs-epib;
+		ti,psd-size = <64>;
+	};
+
+	ti,psil-config1 {
+		linux,udma-mode = <UDMA_PKT_MODE>;
+		ti,needs-epib;
+		ti,psd-size = <64>;
+	};
+
+	ti,psil-config2 {
+		linux,udma-mode = <UDMA_PKT_MODE>;
+		ti,needs-epib;
+		ti,psd-size = <64>;
+	};
+};
-- 
2.17.1

