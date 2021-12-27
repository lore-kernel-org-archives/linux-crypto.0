Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD29C433EF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Dec 2021 18:33:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhL0SdT (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Dec 2021 13:33:19 -0500
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:45492
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231748AbhL0SdP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Dec 2021 13:33:15 -0500
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2AF493F1EE
        for <linux-crypto@vger.kernel.org>; Mon, 27 Dec 2021 18:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1640629994;
        bh=i54sREsIiziNBvMfagruvxn2qixoZveyXs+MJUzMCDQ=;
        h=From:To:Subject:Date:Message-Id:MIME-Version;
        b=Ea18Fp0D5YA6f2t67keaW8IfqaQJRHBelugvQfo+DlEzIluWgmnKqdXUkArxTv0dy
         jW2B2LMc0/3uqLQs9EJit5BOSSfMf5fyf7KD5fpz/n6JLRqoYLSGs/qk5IzzWgRGDW
         BtA4wNE2BnBlBdgo/CySgF6aF+fqLQGqBur5HCJBkzzUHGZmrRUvACnMO5/tcznVYX
         0R9guPWh1Cud8WgdG/uJpVD4gji23OqQW4Qe3jyp99iaFcEXU9I1l4hwxKWgj9wN4x
         bRc67U0kNAkxWhJO/1EFcqCzOBAMTtHD4vxAsk9hwjDILYFlc6XyK1S+JU4s/sWtjI
         r/AMdSwul7NIw==
Received: by mail-ed1-f69.google.com with SMTP id z10-20020a05640235ca00b003f8efab3342so4458768edc.2
        for <linux-crypto@vger.kernel.org>; Mon, 27 Dec 2021 10:33:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i54sREsIiziNBvMfagruvxn2qixoZveyXs+MJUzMCDQ=;
        b=5Xc9q2r1yn0vi2Z0finDsNMOKZin+vr8AT7aOzoG97bLbJgysEqrt8CComoJ/FQa2c
         rE/EyGfOxfoC4aAr1M25Apjnm+82XdZGH77XDp71Fd1zdrHpy/HMvJfsH2iChcbqynwn
         5Ng6UDg8oh2QLMD+YAjMPVRpyoI/0LhhlSqsxAsaV0LyZayWaGKsFTccNct5msC65IyX
         6VxthXf1M77n8+KK5UZpME8UwB4MLYX2sy3j+6p4Y6Z/I1lO+rsZ9g3PBcCcrSxThrM5
         +EQsHv0md5vWiEVlWcvLMOcvyXRDnSuZgohGQURky/XXwDTz3rQ8UTRqftedkIPg+DMg
         XBdA==
X-Gm-Message-State: AOAM530OlEGWmTLgLC2Bq4ZbVlxVld6A77b99cJz2Mltsk9yRA5u2/AO
        CaS7b4Jq9GYz+1wJNxDweDqe9vKh/6BmvW8rjjLkA/KnJJhqjQNjzwow+MKrnfJDnCzdmRiSiz5
        sThRMtmPH10dMWP8sbE74DcTmz5N8CeTTSBUewIRw5A==
X-Received: by 2002:a05:6512:139e:: with SMTP id p30mr16310392lfa.492.1640629976400;
        Mon, 27 Dec 2021 10:32:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxAZ3WEqusbAy4q7yWvfndZFSCKKy0G3HTKCX5F7Y7Ex31eIeYUwjTgsdfidX3vvAEfthquPg==
X-Received: by 2002:a05:6512:139e:: with SMTP id p30mr16310362lfa.492.1640629976089;
        Mon, 27 Dec 2021 10:32:56 -0800 (PST)
Received: from krzk-bin.lan (89-77-68-124.dynamic.chello.pl. [89.77.68.124])
        by smtp.gmail.com with ESMTPSA id o12sm1299622ljc.5.2021.12.27.10.32.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Dec 2021 10:32:55 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rob Herring <robh+dt@kernel.org>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Khuong Dinh <khuong@os.amperecomputing.com>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Tony Lindgren <tony@atomide.com>, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, openbmc@lists.ozlabs.org
Subject: [PATCH 1/8] dt-bindings: rng: apm,x-gene-rng: convert APM RNG to dtschema
Date:   Mon, 27 Dec 2021 19:32:44 +0100
Message-Id: <20211227183251.132525-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Convert the APM X-Gene RNG bindings to DT schema.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 .../devicetree/bindings/rng/apm,rng.txt       | 17 -------
 .../bindings/rng/apm,x-gene-rng.yaml          | 47 +++++++++++++++++++
 2 files changed, 47 insertions(+), 17 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/rng/apm,rng.txt
 create mode 100644 Documentation/devicetree/bindings/rng/apm,x-gene-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/apm,rng.txt b/Documentation/devicetree/bindings/rng/apm,rng.txt
deleted file mode 100644
index 4dde4b06cdd9..000000000000
--- a/Documentation/devicetree/bindings/rng/apm,rng.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-APM X-Gene SoC random number generator.
-
-Required properties:
-
-- compatible  : should be "apm,xgene-rng"
-- reg         : specifies base physical address and size of the registers map
-- clocks      : phandle to clock-controller plus clock-specifier pair
-- interrupts  : specify the fault interrupt for the RNG device
-
-Example:
-
-	rng: rng@10520000 {
-		compatible = "apm,xgene-rng";
-		reg = <0x0 0x10520000 0x0 0x100>;
-		interrupts =   <0x0 0x41 0x4>;
-		clocks = <&rngpkaclk 0>;
-	};
diff --git a/Documentation/devicetree/bindings/rng/apm,x-gene-rng.yaml b/Documentation/devicetree/bindings/rng/apm,x-gene-rng.yaml
new file mode 100644
index 000000000000..02be143cc829
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/apm,x-gene-rng.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/apm,x-gene-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: APM X-Gene SoC Random Number Generator
+
+maintainers:
+  - Khuong Dinh <khuong@os.amperecomputing.com>
+
+properties:
+  compatible:
+    const: apm,xgene-rng
+
+  clocks:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - clocks
+  - interrupts
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    soc {
+        #address-cells = <2>;
+        #size-cells = <2>;
+
+        rng@10520000 {
+            compatible = "apm,xgene-rng";
+            reg = <0x0 0x10520000 0x0 0x100>;
+            interrupts = <GIC_SPI 65 IRQ_TYPE_LEVEL_HIGH>;
+            clocks = <&rngpkaclk 0>;
+        };
+    };
-- 
2.32.0

