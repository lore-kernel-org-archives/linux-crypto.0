Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2CB0C4332F
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Nov 2022 22:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233576AbiKSWMo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 19 Nov 2022 17:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbiKSWMn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 19 Nov 2022 17:12:43 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426A115805
        for <linux-crypto@vger.kernel.org>; Sat, 19 Nov 2022 14:12:42 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id j16so13568948lfe.12
        for <linux-crypto@vger.kernel.org>; Sat, 19 Nov 2022 14:12:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jZkwUGyeGgLpD7/abMkmVR6RIxjNUyy5XUkE4m7mSEI=;
        b=TQG76VVzCrE6jw2YN1c8BaP66oklivB3/nG6CKm4jPuxtNLKSc7+NVm6kvve9rhyCa
         wey7z33kLAsDP0UpYXzwbPXrmtEhM8cmaGGTTL/1ekcuWU+LcZX3i2RTsBbXg17r4fZd
         oFHvQE9nOsWywrJejrCNTsxLOkl6YdkjRTATH2HwJOSEYajPhmAL16rgC/FPqfTYXfRE
         OCfHrhp9H6wjxe5aqiQlgh/1PB7j/6TmQ0q8uP4AStAukwrbFUFzN1NFSMqUlGsb+ttT
         mcr1YGtAuO0F70hMi1vJcFliKgJr8eC+SmxRvxsP6NRpAMgrX8txjB7HB86l81Lo78Nu
         IIlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZkwUGyeGgLpD7/abMkmVR6RIxjNUyy5XUkE4m7mSEI=;
        b=tH4Q/GAMo0UbU7DuSVVgFuBuu8u9X7xzsi0JQl8BrTVTX5zQGSJpr9KDffxVDYgzqb
         6bbLBidlWiKHyGjASpsok9jpEVjluF+wZBUWrcPgrh7Fc4KdMpJ1edtV5UrbfGjSADYz
         GMHhIlCEhNHO2fq1K8n58X1+LsCv5X00w6KvRqhBbJWWBqWCKvbF3i5/YwEBRTGNZWjN
         LNoZ6y1u3XWDgfPX4rQjKvakiRNlUXWnkBVFla7jMuu68DK/wLM7e20raUtz7BGUXKAp
         hyFVMhcwoQVqWfu1YBUkLIRbO2Qq+VpEBrvh+6HmNgiQV/WmrHdG9IgtgYsSOMuw6nIK
         Wvnw==
X-Gm-Message-State: ANoB5pnIFsKwrPdRqnP5TVdJhPnyD3yEyiiIKB8WqOC5ad4geprSZsOy
        OzCFsqiya9TfCqZMOf/BDuu6axWKqoWKug==
X-Google-Smtp-Source: AA0mqf7UUr17t+1zuZd9i2FLTtICOAQdWTqbSE9qMiIErIqFrFCMkU0cgT7OAWvb88tu8sYtVn6nXQ==
X-Received: by 2002:ac2:47fc:0:b0:4a2:2f31:12bf with SMTP id b28-20020ac247fc000000b004a22f3112bfmr4400296lfp.550.1668895961509;
        Sat, 19 Nov 2022 14:12:41 -0800 (PST)
Received: from Fecusia.lan (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id u3-20020a05651220c300b00496d3e6b131sm1234254lfr.234.2022.11.19.14.12.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 14:12:40 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     phone-devel@vger.kernel.org, Stefan Hansson <newbyte@disroot.org>,
        Lionel Debieve <lionel.debieve@foss.st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH v1 1/4] dt-bindings: crypto: Let STM32 define Ux500 CRYP
Date:   Sat, 19 Nov 2022 23:12:16 +0100
Message-Id: <20221119221219.1232541-2-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221119221219.1232541-1-linus.walleij@linaro.org>
References: <20221119221219.1232541-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds device tree bindings for the Ux500 CRYP block
as a compatible in the STM32 CRYP bindings.

The Ux500 CRYP binding has been used for ages in the kernel
device tree for Ux500 but was never documented, so fill in
the gap by making it a sibling of the STM32 CRYP block,
which is what it is.

The relationship to the existing STM32 CRYP block is pretty
obvious when looking at the register map, and I have written
patches to reuse the STM32 CRYP driver on the Ux500.

The two properties added are DMA channels and power domain.
Power domains are a generic SoC feature and the STM32 variant
also has DMA channels.

Cc: devicetree@vger.kernel.org
Cc: Lionel Debieve <lionel.debieve@foss.st.com>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
This was previously sent out as an open question but
nothing happened, now I send it as part of the STM32
bindings, in a series making the Linux STM32 driver
use the STM32 driver.
---
 .../bindings/crypto/st,stm32-cryp.yaml        | 32 +++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
index ed23bf94a8e0..69614ab51f81 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-cryp.yaml
@@ -6,12 +6,18 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: STMicroelectronics STM32 CRYP bindings
 
+description: The STM32 CRYP block is built on the CRYP block found in
+  the STn8820 SoC introduced in 2007, and subsequently used in the U8500
+  SoC in 2010.
+
 maintainers:
   - Lionel Debieve <lionel.debieve@foss.st.com>
 
 properties:
   compatible:
     enum:
+      - st,stn8820-cryp
+      - stericsson,ux500-cryp
       - st,stm32f756-cryp
       - st,stm32mp1-cryp
 
@@ -27,6 +33,19 @@ properties:
   resets:
     maxItems: 1
 
+  dmas:
+    items:
+      - description: mem2cryp DMA channel
+      - description: cryp2mem DMA channel
+
+  dma-names:
+    items:
+      - const: mem2cryp
+      - const: cryp2mem
+
+  power-domains:
+    maxItems: 1
+
 required:
   - compatible
   - reg
@@ -48,4 +67,17 @@ examples:
       resets = <&rcc CRYP1_R>;
     };
 
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/reset/stericsson,db8500-prcc-reset.h>
+    #include <dt-bindings/arm/ux500_pm_domains.h>
+    cryp@a03cb000 {
+      compatible = "stericsson,ux500-cryp";
+      reg = <0xa03cb000 0x1000>;
+      interrupts = <GIC_SPI 15 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&prcc_pclk 6 2>;
+      power-domains = <&pm_domains DOMAIN_VAPE>;
+    };
+
 ...
-- 
2.38.1

