Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDCAFC432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 10:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 922302073C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 10:24:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="GKqHP3GV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727220AbfKOKYw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 05:24:52 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:9318 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727036AbfKOKYw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Nov 2019 05:24:52 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFAMjp8021368;
        Fri, 15 Nov 2019 11:24:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=G7/vNr2mUj/ypwdiuuuBONQIOgMUSkIYzFbYwlty4cU=;
 b=GKqHP3GVDgRYkuv35dVhv4BNGRDvGWOmYbXWI2H3I323pftfCkIoJVDlZiEvbJlI4ReG
 C1q4xiLL6PgT/CA4ZjB193k2Qi8q6DyGw1taDBjMf+1QY80dtKUl8LeT+6gS/f2yo2at
 Od2cZ2fk+VHrjIHpkCgtHeoQM2gGRJp3SqEPfmrCq6HDKftO6AXzCuapbU/wlZjRYkp7
 IfozdDyaXaGpSKoStDjuAja5CwCeHpkhugQZRxQWHRvbIKOdUHNZSq7jrZ1+voChFejF
 a5g0ZcI7ST5eLcn+E7AlGpiksNjhMHzhY3DvVL6U5ZcM3yXW6w8SKBqA4TinqABaTS1g qQ== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w7psfkjbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Nov 2019 11:24:30 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id 7829A10002A;
        Fri, 15 Nov 2019 11:24:29 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id 5FF582B2558;
        Fri, 15 Nov 2019 11:24:29 +0100 (CET)
Received: from localhost (10.75.127.50) by SFHDAG3NODE3.st.com (10.75.127.9)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri, 15 Nov 2019 11:24:28
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
Subject: [PATCH v2] dt-bindings: crypto: Convert stm32 HASH bindings to json-schema
Date:   Fri, 15 Nov 2019 11:24:27 +0100
Message-ID: <20191115102427.31224-1-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.50]
X-ClientProxiedBy: SFHDAG7NODE2.st.com (10.75.127.20) To SFHDAG3NODE3.st.com
 (10.75.127.9)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_02:2019-11-15,2019-11-15 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the STM32 HASH binding to DT schema format using json-schema

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
---
version 2:
- add type ref, min, max and default values for dma-maxburst property

 .../devicetree/bindings/crypto/st,stm32-hash.txt   | 30 ----------
 .../devicetree/bindings/crypto/st,stm32-hash.yaml  | 69 ++++++++++++++++++++++
 2 files changed, 69 insertions(+), 30 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-hash.txt
 create mode 100644 Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.txt b/Documentation/devicetree/bindings/crypto/st,stm32-hash.txt
deleted file mode 100644
index 04fc246f02f7..000000000000
--- a/Documentation/devicetree/bindings/crypto/st,stm32-hash.txt
+++ /dev/null
@@ -1,30 +0,0 @@
-* STMicroelectronics STM32 HASH
-
-Required properties:
-- compatible: Should contain entries for this and backward compatible
-  HASH versions:
-  - "st,stm32f456-hash" for stm32 F456.
-  - "st,stm32f756-hash" for stm32 F756.
-- reg: The address and length of the peripheral registers space
-- interrupts: the interrupt specifier for the HASH
-- clocks: The input clock of the HASH instance
-
-Optional properties:
-- resets: The input reset of the HASH instance
-- dmas: DMA specifiers for the HASH. See the DMA client binding,
-	 Documentation/devicetree/bindings/dma/dma.txt
-- dma-names: DMA request name. Should be "in" if a dma is present.
-- dma-maxburst: Set number of maximum dma burst supported
-
-Example:
-
-hash1: hash@50060400 {
-	compatible = "st,stm32f756-hash";
-	reg = <0x50060400 0x400>;
-	interrupts = <80>;
-	clocks = <&rcc 0 STM32F7_AHB2_CLOCK(HASH)>;
-	resets = <&rcc STM32F7_AHB2_RESET(HASH)>;
-	dmas = <&dma2 7 2 0x400 0x0>;
-	dma-names = "in";
-	dma-maxburst = <0>;
-};
diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
new file mode 100644
index 000000000000..57ae1c0b6d18
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
@@ -0,0 +1,69 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/st,stm32-hash.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: STMicroelectronics STM32 HASH bindings
+
+maintainers:
+  - Lionel Debieve <lionel.debieve@st.com>
+
+properties:
+  compatible:
+    enum:
+      - st,stm32f456-hash
+      - st,stm32f756-hash
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
+  dmas:
+    maxItems: 1
+
+  dma-names:
+    items:
+      - const: in
+
+  dma-maxburst:
+    description: Set number of maximum dma burst supported
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/uint32
+      - minimum: 0
+      - maximum: 2
+      - default: 0
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
+    hash@54002000 {
+      compatible = "st,stm32f756-hash";
+      reg = <0x54002000 0x400>;
+      interrupts = <GIC_SPI 80 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&rcc HASH1>;
+      resets = <&rcc HASH1_R>;
+      dmas = <&mdma1 31 0x10 0x1000A02 0x0 0x0>;
+      dma-names = "in";
+      dma-maxburst = <2>;
+    };
+
+...
-- 
2.15.0

