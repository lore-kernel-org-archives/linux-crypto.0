Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFF32C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:17:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0A1611AD
	for <linux-crypto@archiver.kernel.org>; Tue, 18 May 2021 15:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345073AbhERPS1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 May 2021 11:18:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343775AbhERPS0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 May 2021 11:18:26 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66747C061756
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:17:08 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id u5-20020a7bc0450000b02901480e40338bso1758815wmc.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 May 2021 08:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oX2FWDTJXKAkYaew6nQcQrC7zAKbVD+lv92TvcmNFrs=;
        b=FzN3TN6lUQ0CZnk8VoKGL3Nd9p2PPppuRvfFJCdBcggeukhU6liuHsbWTv2hm490pJ
         g97vd6kptQAmKuEl8jPE5ddwXaBDqUOzNBVQs+h63I2Tr/5+4zUZVJoS8XthPlWI+Ppr
         bTYvcm8EuJIUUPGCa/5lssyQ9CIfN4SP6n7i1Hw0xp2MRIu5S7NpZ5pfImhbvs+f8u+q
         9BOz1SXJlsr+3MnWhBJjJY/zk0gZBB7Ze3+4kvHkfiB/27rqXyftQX0WADjQG5kAbvb6
         j6AYUU8y4NIeunYBA7rD1ISXzMA6r8d3qxdfaCsXHnbqxlHEx1doPmoNVuC5Vv6kT5h/
         lkVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oX2FWDTJXKAkYaew6nQcQrC7zAKbVD+lv92TvcmNFrs=;
        b=gPUl/9MeGZbKVRHT2idhEE+qyh8JeGTbIKvcNBi0yGVHfouOyeSwcnw1Q8g5ALpOu5
         7XaavakBlIZTB92LFN/0yIAdctiNU2hwAqTFd6iYZXXLke7cfeF9PugaKh9gyoT3Irdg
         sl938fHn4dM8zNcr3bZOYRr3OVgTqFjkJG5b6JsD605IPzTseHcc8+K0sBV3+cacP6pM
         um9njdhKom0kFoJDkV0g8BiymMf0OwwQxJx+cJAJ2qJV5TBCprlE3B/dDPgYrfEd3i/1
         /M3kneqTWaGqpvWLeTS57xLkiRxIwW8/DQkg73vDmqiyO0u/GO3Idwy5FK0b2D3iKS6t
         /f0w==
X-Gm-Message-State: AOAM531u4hBaRbDjXRAxHjGH83lH/VomklwzvJ1oTitzuIZDDdk7szm7
        n0pK3A0IR5bfFoji+QmMBqvn/Q==
X-Google-Smtp-Source: ABdhPJzXKIud3JJqMCfPxm2yOmdpLJSBdlJQjGno3UxJaXzzecxXcLBep8AX44s6aMVxnWlTPwy1Uw==
X-Received: by 2002:a05:600c:4f0f:: with SMTP id l15mr5497276wmq.143.1621351027095;
        Tue, 18 May 2021 08:17:07 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-658-1-213-31.w90-63.abo.wanadoo.fr. [90.63.244.31])
        by smtp.googlemail.com with ESMTPSA id z9sm18005808wmi.17.2021.05.18.08.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 08:17:06 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linus.walleij@linaro.org, linux@armlinux.org.uk,
        robh+dt@kernel.org, ulli.kroll@googlemail.com
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH 1/5] db-dinding: crypto: Add DT bindings documentation for sl3516-ce
Date:   Tue, 18 May 2021 15:16:51 +0000
Message-Id: <20210518151655.125153-2-clabbe@baylibre.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210518151655.125153-1-clabbe@baylibre.com>
References: <20210518151655.125153-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds documentation for Device-Tree bindings for the
SL3516-ce cryptographic offloader driver.
Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 .../crypto/cortina,sl3516-crypto.yaml         | 50 +++++++++++++++++++
 1 file changed, 50 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/crypto/cortina,sl3516-crypto.yaml

diff --git a/Documentation/devicetree/bindings/crypto/cortina,sl3516-crypto.yaml b/Documentation/devicetree/bindings/crypto/cortina,sl3516-crypto.yaml
new file mode 100644
index 000000000000..8330b16a07e8
--- /dev/null
+++ b/Documentation/devicetree/bindings/crypto/cortina,sl3516-crypto.yaml
@@ -0,0 +1,50 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/crypto/cortina,sl3516-crypto.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: SL3516 cryptographic offloader driver
+
+maintainers:
+  - Corentin Labbe <clabbe@baylibre.com>
+
+properties:
+  compatible:
+    enum:
+      - cortina,sl3516-crypto
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+
+  resets:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - resets
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/clock/cortina,gemini-clock.h>
+    #include <dt-bindings/reset/cortina,gemini-reset.h>
+
+    crypto@62000000 {
+        compatible = "cortina,sl3516-crypto";
+        reg = <0x62000000 0x10000>;
+        interrupts = <7 IRQ_TYPE_EDGE_RISING>;
+        resets = <&syscon GEMINI_RESET_SECURITY>;
+        clocks = <&syscon GEMINI_CLK_GATE_SECURITY>;
+    };
-- 
2.26.3

