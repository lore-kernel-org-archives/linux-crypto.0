Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF92BC433ED
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 22:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86DEA613BD
	for <linux-crypto@archiver.kernel.org>; Thu, 20 May 2021 22:32:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbhETWdt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 18:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbhETWdt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 18:33:49 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFACDC061761
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 15:32:26 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id e11so21675684ljn.13
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 15:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=majFJUgE6kbtYjouc7u3aeKZBiY0X2qXxJpyVqBgA4I=;
        b=XnpflCukL3R8O7gOwis5wc0/1nMU+hWZZD/NxnL5PK9KubcLSaxNlLa6ludwyULWKU
         +vofbgqXilPhT8p5D7380JWthBPiUSIonE/sPEY4TEHJLTWYf4miV7b79WgrORtoj6y5
         w6WF7Nie7BRZBhtZv5V1Yqa+Iva/DT1D+INgcy9+yECEI8/965ED+t91hx66ocib8qUY
         hip3V/kf+An7ywyS2DEUasoGzJrYOVgGGUY4G6Dv7cybkpoNudYOgvbMLo/tNKUAWLwR
         G7mzQbciqu0jJcRpPcY3Rsr7ci8xihgA3CjapxKTFwMugd7xlWPTxddiVyJtDopdJ0hP
         nc8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=majFJUgE6kbtYjouc7u3aeKZBiY0X2qXxJpyVqBgA4I=;
        b=Q60dvejaFvrWsZZCAHlFjByyarq23Id1yGn0QeaNpWq8TEsHymBPw/qG6PDranY88l
         T7KZ/s1+sE4Q3FKvOh/0tRY3qVLNF6aSHbRlfQ/hTnbgI4+RSrY/QHRsJrhT2dShnyoo
         1WKOmAPrZAFJTHAknG3lxIAXPAsafYXO1JmmT9B5T+V+7IlnL30YcJEs5lEtsiSmcirF
         3qk65ON+VmQ9tv6LBuUdd+p8B7WIZJ7mj8JkuwrmSpbz5zkKxCg5uphFoUxxayI3meqX
         ZD8xX/JgncFG4tpV4ZbnG0aPU0qhXqAgVNKXzHFkRFP0JzdDHo23Fml+8gbddlHhtv5p
         mhMA==
X-Gm-Message-State: AOAM533qQfLRVoVi1qZzaR/XjD4z8hTvXfe3ZdRK/+C2KyueIBlXHh/w
        62TivHvUpdSOvgjfK+VAZvdUiK3pz20NnQ==
X-Google-Smtp-Source: ABdhPJySxea32IryZZXKK44bywgabA7MVFR3Z6YYXVM/KzLOwd96DOIKwwjHb+k4xis1eFqfutSUQA==
X-Received: by 2002:a2e:8ec5:: with SMTP id e5mr4661883ljl.325.1621549945045;
        Thu, 20 May 2021 15:32:25 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id v1sm419601lfg.141.2021.05.20.15.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 15:32:24 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Corentin Labbe <clabbe@baylibre.com>
Cc:     linux-arm-kernel@lists.infradead.org,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 2/3 v2] crypto: ixp4xx: Add DT bindings
Date:   Fri, 21 May 2021 00:30:20 +0200
Message-Id: <20210520223020.731925-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds device tree bindings for the ixp4xx crypto engine.

Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Drop the phandle to self, just add an NPE instance number
  instead.
- Add the crypto node to the NPE binding.
- Move the example over to the NPE binding where it appears
  in context.
---
 .../bindings/crypto/intel,ixp4xx-crypto.yaml  | 46 +++++++++++++++++++
 ...ntel,ixp4xx-network-processing-engine.yaml | 13 +++++-
 2 files changed, 58 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
new file mode 100644
index 000000000000..79e9d23be1f4
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2018 Linaro Ltd.
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/crypto/intel,ixp4xx-crypto.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Intel IXP4xx cryptographic engine
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+description: |
+  The Intel IXP4xx cryptographic engine makes use of the IXP4xx NPE
+  (Network Processing Engine). Since it is not a device on its own
+  it is defined as a subnode of the NPE, if crypto support is
+  available on the platform.
+
+properties:
+  compatible:
+    const: intel,ixp4xx-crypto
+
+  intel,npe:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 0
+    maximum: 3
+    description: phandle to the NPE this ethernet instance is using
+      and the instance to use in the second cell
+
+  queue-rx:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    maxItems: 1
+    description: phandle to the RX queue on the NPE
+
+  queue-txready:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    maxItems: 1
+    description: phandle to the TX READY queue on the NPE
+
+required:
+  - compatible
+  - intel,npe
+  - queue-rx
+  - queue-txready
+
+additionalProperties: false
diff --git a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
index 1bd2870c3a9c..add46ae6c461 100644
--- a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
+++ b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
@@ -30,6 +30,10 @@ properties:
       - description: NPE1 register range
       - description: NPE2 register range
 
+  crypto:
+    type: object
+    description: optional node for the embedded crypto engine
+
 required:
   - compatible
   - reg
@@ -38,8 +42,15 @@ additionalProperties: false
 
 examples:
   - |
-    npe@c8006000 {
+    npe: npe@c8006000 {
          compatible = "intel,ixp4xx-network-processing-engine";
          reg = <0xc8006000 0x1000>, <0xc8007000 0x1000>, <0xc8008000 0x1000>;
+
+         crypto {
+             compatible = "intel,ixp4xx-crypto";
+             intel,npe = <2>;
+             queue-rx = <&qmgr 30>;
+             queue-txready = <&qmgr 29>;
+         };
     };
 ...
-- 
2.31.1

