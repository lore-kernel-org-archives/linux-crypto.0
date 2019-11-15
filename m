Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E4D6C43141
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 10:09:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48D112073A
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 10:09:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=st.com header.i=@st.com header.b="eExy1s42"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfKOKJ2 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 05:09:28 -0500
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:3826 "EHLO
        mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727004AbfKOKJ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Nov 2019 05:09:28 -0500
Received: from pps.filterd (m0046660.ppops.net [127.0.0.1])
        by mx08-00178001.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAFA71fq002107;
        Fri, 15 Nov 2019 11:09:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=st.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=STMicroelectronics;
 bh=lAUGW0y2CHBDpVTA3h5ClqMlUAZUqXjeRxzgtQy+rpU=;
 b=eExy1s42e1KDNtXfaE58U+ydiOXEL0+L9ooNaeQ5q1pmb8eWTclk/YHwAbi7HNB3Wlhw
 gJZToY++Da9GOsq6Sfv66K6GYlNhyDtZFrDmtYqx4yZra330admzcM6xSAONAfSugBN0
 SBTaiRQDJNJeZHliLORIbL0p04KliNeqk6Ep7cGguXyNXngvFgwP3k16WzixLOWYTTKg
 +doo/WdM0EAay0pCGaUQvWKbeSy1z7+bcMzKXnJWhMw7dumRWuKOnm6UxpT3tLOUwu1H
 av3EUzSBxXjvZl+ByeDbvk4qaroputh+rfBtp4oM6O3KOTHuOiXznw9R4b9iw+Y8zMqg Vw== 
Received: from beta.dmz-eu.st.com (beta.dmz-eu.st.com [164.129.1.35])
        by mx08-00178001.pphosted.com with ESMTP id 2w7psfkfqc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 15 Nov 2019 11:09:05 +0100
Received: from euls16034.sgp.st.com (euls16034.sgp.st.com [10.75.44.20])
        by beta.dmz-eu.st.com (STMicroelectronics) with ESMTP id D27AC10003A;
        Fri, 15 Nov 2019 11:09:03 +0100 (CET)
Received: from Webmail-eu.st.com (sfhdag3node3.st.com [10.75.127.9])
        by euls16034.sgp.st.com (STMicroelectronics) with ESMTP id BC76B2B2520;
        Fri, 15 Nov 2019 11:09:03 +0100 (CET)
Received: from localhost (10.75.127.49) by SFHDAG3NODE3.st.com (10.75.127.9)
 with Microsoft SMTP Server (TLS) id 15.0.1347.2; Fri, 15 Nov 2019 11:09:03
 +0100
From:   Benjamin Gaignard <benjamin.gaignard@st.com>
To:     <mpm@selenic.com>, <herbert@gondor.apana.org.au>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>,
        <alexandre.torgue@st.com>, <lionel.debieve@st.com>
CC:     <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>
Subject: [PATCH] dt-bindings: rng: Convert stm32 RNG bindings to json-schema
Date:   Fri, 15 Nov 2019 11:08:54 +0100
Message-ID: <20191115100854.17938-1-benjamin.gaignard@st.com>
X-Mailer: git-send-email 2.15.0
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.75.127.49]
X-ClientProxiedBy: SFHDAG2NODE1.st.com (10.75.127.4) To SFHDAG3NODE3.st.com
 (10.75.127.9)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-15_02:2019-11-15,2019-11-15 signatures=0
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the STM32 RNG binding to DT schema format using json-schema
Remove interrupt from the json-schema because it is not used by the driver.

Signed-off-by: Benjamin Gaignard <benjamin.gaignard@st.com>
---
 .../devicetree/bindings/rng/st,stm32-rng.txt       | 25 -----------
 .../devicetree/bindings/rng/st,stm32-rng.yaml      | 48 ++++++++++++++++++++++
 2 files changed, 48 insertions(+), 25 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/st,stm32-rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/st,stm32-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.txt b/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
deleted file mode 100644
index 1dfa7d51e006..000000000000
--- a/Documentation/devicetree/bindings/rng/st,stm32-rng.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-STMicroelectronics STM32 HW RNG
-===============================
-
-The STM32 hardware random number generator is a simple fixed purpose IP and
-is fully separated from other crypto functions.
-
-Required properties:
-
-- compatible : Should be "st,stm32-rng"
-- reg : Should be register base and length as documented in the datasheet
-- interrupts : The designated IRQ line for the RNG
-- clocks : The clock needed to enable the RNG
-
-Optional properties:
-- resets : The reset to properly start RNG
-- clock-error-detect : Enable the clock detection management
-
-Example:
-
-	rng: rng@50060800 {
-		compatible = "st,stm32-rng";
-		reg = <0x50060800 0x400>;
-		interrupts = <80>;
-		clocks = <&rcc 0 38>;
-	};
diff --git a/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
new file mode 100644
index 000000000000..82bb2e97e889
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/st,stm32-rng.yaml
@@ -0,0 +1,48 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/st,stm32-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: STMicroelectronics STM32 RNG bindings
+
+description: |
+  The STM32 hardware random number generator is a simple fixed purpose
+  IP and is fully separated from other crypto functions.
+
+maintainers:
+  - Lionel Debieve <lionel.debieve@st.com>
+
+properties:
+  compatible:
+    const: st,stm32-rng
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+  clock-error-detect:
+    description: If set enable the clock detection management
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
+    rng@54003000 {
+      compatible = "st,stm32-rng";
+      reg = <0x54003000 0x400>;
+      clocks = <&rcc RNG1_K>;
+    };
+
+...
-- 
2.15.0

