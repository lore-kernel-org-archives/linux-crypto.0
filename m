Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8076C5DF60
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADC732245A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 12:53:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="VaPfpgUz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfKHMxV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:53:21 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:47391 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726445AbfKHMxU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 07:53:20 -0500
Received: from pps.filterd (m0046037.ppops.net [127.0.0.1])
        by mx07-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA8CqEI6015196;
        Fri, 8 Nov 2019 13:52:49 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=STMicroelectronics;
 bh=7H2L6p4aMQZbG5XB4uxu8UBuL7eVs48hwy7HAKSmpAI=;
 b=VaPfpgUzleU4vIJLQLhDtt8Ru6nOJFUlWfMyb4whxfGjnJowJF9m5pcIE9wcTmdEgJu3
 VQCrNFlcxjheF5fi1WPMzY9hYErFA8IGHVpVMYT0OYPLIw3bIMFHVm0blhgvhZpWj6Zs
 fQ3io09Zee3s7wMCZub1Zdu8D2qSJekfkH9oOcI50VxPrnXSvZi/q4TNBuIIjmyeRSWW
 tuwZ8b5RvYm9gdxKsOwWHpOxOFiUqqGw5XdF2KEE7m0jHnwbUfwJfYlo9N+2VmoRz4fm
 aOm3cJEbLf92QCps+1peqCCSrTDS71nVWzgTW6Gt0edq0vOb1X9ofQlNxODIluzEegjD 4A== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx07-00178001.pphosted.com with ESMTP id 2w41ve3m4m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 13:52:49 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 3E89F100039;
        Fri,  8 Nov 2019 13:52:49 +0100 (CET)
Received: from Webmail-eu.st.com (Safex1hubcas21.st.com [10.75.90.44])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 2EB8A2B6A0F;
        Fri,  8 Nov 2019 13:52:49 +0100 (CET)
Received: from SAFEX1HUBCAS24.st.com (10.75.90.95) by SAFEX1HUBCAS21.st.com
 (10.75.90.44) with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 8 Nov 2019
 13:52:49 +0100
Received: from localhost (10.201.20.122) by webmail-ga.st.com (10.75.90.48)
 with Microsoft SMTP Server (TLS) id 14.3.439.0; Fri, 8 Nov 2019 13:52:48
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
Subject: [PATCH] dt-bindings: crypto: Convert stm32 CRYP bindings to json-schema
Date:   Fri, 8 Nov 2019 13:52:43 +0100
Message-ID: <20191108125244.23001-2-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20191108125244.23001-1-benjamin.gaignard@st.com>
References: <20191108125244.23001-1-benjamin.gaignard@st.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.201.20.122]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_03:2019-11-08,2019-11-08 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the STM32 CRYP binding to DT schema format using json-schema

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
---
 .../devicetree/bindings/crypto/st,stm32-cryp.txt   | 19 --------
 .../devicetree/bindings/crypto/st,stm32-cryp.yaml  | 51 ++++++++++++++++++++++
 2 files changed, 51 insertions(+), 19 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
deleted file mode 100644
index 970487fa40b8..000000000000
--- a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.txt
+++ /dev/null
@@ -1,19 +0,0 @@
-* STMicroelectronics STM32 CRYP
-
-Required properties:
-- compatible: Should be "st,stm32f756-cryp".
-- reg: The address and length of the peripheral registers space
-- clocks: The input clock of the CRYP instance
-- interrupts: The CRYP interrupt
-
-Optional properties:
-- resets: The input reset of the CRYP instance
-
-Example:
-crypto@50060000 {
-	compatible = "st,stm32f756-cryp";
-	reg = <0x50060000 0x400>;
-	interrupts = <79>;
-	clocks = <&rcc 0 STM32F7_AHB2_CLOCK(CRYP)>;
-	resets = <&rcc STM32F7_AHB2_RESET(CRYP)>;
-};
diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
new file mode 100644
index 000000000000..a4574552502a
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
@@ -0,0 +1,51 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/st,stm32-cryp.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: STMicroelectronics STM32 CRYP bindings
+
+maintainers:
+  - Lionel Debieve <lionel.debieve@st.com>
+
+properties:
+  compatible:
+    enum:
+      - st,stm32f756-cryp
+      - st,stm32mp1-cryp
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - interrupts
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/stm32mp1-clks.h>
+    #include <dt-bindings/reset/stm32mp1-resets.h>
+    cryp@54001000 {
+      compatible = "st,stm32mp1-cryp";
+      reg = <0x54001000 0x400>;
+      interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&rcc CRYP1>;
+      resets = <&rcc CRYP1_R>;
+    };
+
+...
-- 
2.15.0

