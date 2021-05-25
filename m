Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7AF2C47084
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 08:50:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8E3D6117A
	for <linux-crypto@archiver.kernel.org>; Tue, 25 May 2021 08:50:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhEYIwX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 25 May 2021 04:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhEYIwW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 May 2021 04:52:22 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766B3C061756
        for <linux-crypto@vger.kernel.org>; Tue, 25 May 2021 01:50:51 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id f30so7843999lfj.1
        for <linux-crypto@vger.kernel.org>; Tue, 25 May 2021 01:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DbMMPA0d0ePjL1VjuJjy136dZpAizIfUqGIRbEJxoo0=;
        b=zqrRIKYtlMguwPWrm3z54icYn31Nsn5WscKIpzMdrwBIJcRuPGa5o2gagNBbmHvw+d
         voASIjNCQJHXb4apy14uEbKiRTl3hfryQqGugFodJY3m+sqVxmDggz67No+jOWqmWRn5
         kQC3LsZed1S808ULKqGZ5U5CtZyJ8PpNYdR1m7ias305HgxciAmrL61VJt2YxBvrBowo
         cq+5VOPjLVxX7vU4f5STTkp4zdgYUzUSS3elA4E7RAETMtXVqhgjiuzWlZsJy4XW+Ch5
         /7/Xmt1wGUE4uBOuOwPnjjxrdyFEpaRmyPZLFFbbBQ7obK7DR8hiRJszZj5IWYRUXpev
         6DbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DbMMPA0d0ePjL1VjuJjy136dZpAizIfUqGIRbEJxoo0=;
        b=iE+jCcq6CpgToSQ0wwWlH+FKB+mKbMQ53JMdIsHBVSf/Zs40/02q+8Anh+UJEdtER7
         qUDFP6ZLWL8lx746fsYRUrHVoNDRnQOb1+YSCjiugoY8bUDfmZIH5Jb7xpVLYfOZTirX
         VWqS59pN+eduYJrALDG0aQkelsOJN8vhruiBbJFnpAUwJMGxK3aSgLhOyVZ/G9jcJcnN
         3bbWFHJCA0kiPfPX3W5vgFCxez5NC4PjyKhsFl2T3WwzATY/JIYKux19AcXTFasTgVUi
         AxnIhbPNegVOPUwhNvf4EcPuM8LLNS220tECORwo5JsndIrDcEfyrqNuSfVdPYUgeEcR
         i0CA==
X-Gm-Message-State: AOAM533ZwWzs9AkvG7/W5E5cWQDMKHsnOGi017EVPfWQ8O/Y3us+NCg+
        8qT2ClAVcXcJw0H+3oawiwShy3PU0Rztxg==
X-Google-Smtp-Source: ABdhPJz9IL+6q/8U9cVuB4alnjr4oa8kaEbdVcly1/pVJUn7P+NP6sGMO32znz4y19OyiaYX1DmbLg==
X-Received: by 2002:a19:7c2:: with SMTP id 185mr13422620lfh.561.1621932649539;
        Tue, 25 May 2021 01:50:49 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id s17sm2139991ljo.117.2021.05.25.01.50.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 01:50:49 -0700 (PDT)
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
Subject: [PATCH 2/3 v4] crypto: ixp4xx: Add DT bindings
Date:   Tue, 25 May 2021 10:48:46 +0200
Message-Id: <20210525084846.1114575-1-linus.walleij@linaro.org>
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
ChangeLog v3->v4:
- Revert back to the phandle to the NPE with the instance
  in the cell as in v1. Use intel,npe-handle just like
  the ethernet driver does.
- Drop the other changes related to using an u32 or reg
  and revert back to v1.
- Keep the other useful stuff from v2 and v3.
ChangeLog v2->v3:
- Use the reg property to set the NPE instance number for
  the crypto engine.
- Add address-cells and size-cells to the NPE bindings
  consequently.
- Use a patternProperty to match the cryto engine child
  "crypto@N".
- Define as crypto@2 in the example.
- Describe the usage of the queue instance cell for the
  queue manager phandles.
ChangeLog v1->v2:
- Drop the phandle to self, just add an NPE instance number
  instead.
- Add the crypto node to the NPE binding.
- Move the example over to the NPE binding where it appears
  in context.
---
 .../bindings/crypto/intel,ixp4xx-crypto.yaml  | 47 +++++++++++++++++++
 ...ntel,ixp4xx-network-processing-engine.yaml | 22 +++++++--
 2 files changed, 65 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
new file mode 100644
index 000000000000..9c53c27bd20a
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/intel,ixp4xx-crypto.yaml
@@ -0,0 +1,47 @@
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
+  intel,npe-handle:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the NPE this crypto engine is using, the cell
+      describing the NPE instance to be used.
+
+  queue-rx:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    maxItems: 1
+    description: phandle to the RX queue on the NPE, the cell describing
+      the queue instance to be used.
+
+  queue-txready:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    maxItems: 1
+    description: phandle to the TX READY queue on the NPE, the cell describing
+      the queue instance to be used.
+
+required:
+  - compatible
+  - intel,npe-handle
+  - queue-rx
+  - queue-txready
+
+additionalProperties: false
diff --git a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
index 1bd2870c3a9c..c435c9f369a4 100644
--- a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
+++ b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
@@ -26,9 +26,16 @@ properties:
 
   reg:
     items:
-      - description: NPE0 register range
-      - description: NPE1 register range
-      - description: NPE2 register range
+      - description: NPE0 (NPE-A) register range
+      - description: NPE1 (NPE-B) register range
+      - description: NPE2 (NPE-C) register range
+
+  crypto:
+    $ref: /schemas/crypto/intel,ixp4xx-crypto.yaml#
+    type: object
+    description: Optional node for the embedded crypto engine, the node
+      should be named with the instance number of the NPE engine used for
+      the crypto engine.
 
 required:
   - compatible
@@ -38,8 +45,15 @@ additionalProperties: false
 
 examples:
   - |
-    npe@c8006000 {
+    npe: npe@c8006000 {
          compatible = "intel,ixp4xx-network-processing-engine";
          reg = <0xc8006000 0x1000>, <0xc8007000 0x1000>, <0xc8008000 0x1000>;
+
+         crypto {
+             compatible = "intel,ixp4xx-crypto";
+             intel,npe-handle = <&npe 2>;
+             queue-rx = <&qmgr 30>;
+             queue-txready = <&qmgr 29>;
+         };
     };
 ...
-- 
2.31.1

