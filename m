Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A2ADC5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BC7D222C2
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:53:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="ml9RldmU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727461AbfKHMxZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:53:25 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:47387 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbfKHMxV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:53:21 -0500
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8CqEtf015193;
        Fri, 8 Nov 2019 13:52:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=KE+lhWirTk2m3IZYhF0q8UeaXDnb4X8JytcbTCweFQg=;
 b=ml9RldmUohzS3DOQN7LiKwksjb9e7e19qHNXXhUyKVDI+iGq++eIsQpfQqoAaEMXxEED
 Gfb6agcFvyhQryLEnSEBrSNFwMe8iRKVUALFpjHbxO0Q2Jp2BHVA48KhrPEVgVQDwyjB
 KED1ib3Cz2cCGbKDvzCG91V0sjhi6JyjUIWjbn7O/RZ3lVEpPclREBE4u0n7N0EduZ5f
 bKWGMT09tI2U6V/IRuEqoGBaasN2mo0OBOAw1FgStlYchABMflWa/2Dsv/kavneRKfnt
 xdqCWsa68jqbQ86DNGRea+SfwIGBRgOhv57SI6AJ6Bl/Kzp69u3Qv/Ru2gO7tq+DY/u3 Vw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2w41ve3m4n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 13:52:49 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 68FF810002A;
        Fri,  8 Nov 2019 13:52:48 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 349432B6A0D;
        Fri,  8 Nov 2019 13:52:48 +0100 (CET)
Received: from SAFEX1HUBCAS24.st.com (10.75.90.95) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 8 Nov 2019
 13:52:48 +0100
Received: from localhost (10.201.20.122) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 8 Nov 2019 13:52:46
 +0100
From:   Benjamin Gaignard <benjamin.gaignard@st.com>
To:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <alexandre.torgue@st.com>, <lionel.debieve@st.com>
CC:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH] dt-bindings: crypto: Convert stm32 CRC bindings to json-schema
Date:   Fri, 8 Nov 2019 13:52:42 +0100
Message-ID: <20191108125244.23001-1-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.20.122]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_03:2019-11-08,2019-11-08 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the STM32 CRC binding to DT schema format using json-schema

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
---
 .../devicetree/bindings/crypto/st,stm32-crc.txt    | 16 ---------
 .../devicetree/bindings/crypto/st,stm32-crc.yaml   | 38 ++++++++++++++++++++++
 2 files changed, 38 insertions(+), 16 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt b/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
deleted file mode 100644
index 3ba92a5e9b36..000000000000
--- a/Documentation/devicetree/bindings/crypto/st,stm32-crc.txt
+++ /dev/null
@@ -1,16 +0,0 @@
-* STMicroelectronics STM32 CRC
-
-Required properties:
-- compatible: Should be "st,stm32f7-crc".
-- reg: The address and length of the peripheral registers space
-- clocks: The input clock of the CRC instance
-
-Optional properties: none
-
-Example:
-
-crc: crc@40023000 {
-	compatible = "st,stm32f7-crc";
-	reg = <0x40023000 0x400>;
-	clocks = <&rcc 0 12>;
-};
diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml
new file mode 100644
index 000000000000..cee624c14f07
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-crc.yaml
@@ -0,0 +1,38 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/st,stm32-crc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: STMicroelectronics STM32 CRC bindings
+
+maintainers:
+  - Lionel Debieve <lionel.debieve@st.com>
+
+properties:
+  compatible:
+    const: st,stm32f7-crc
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/stm32mp1-clks.h>
+    crc@40023000 {
+      compatible = "st,stm32f7-crc";
+      reg = <0x40023000 0x400>;
+      clocks = <&rcc 0 12>;
+    };
+
+...
-- 
2.15.0

