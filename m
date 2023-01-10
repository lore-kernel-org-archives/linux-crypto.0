Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB14C677F1
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Jan 2023 19:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235250AbjAJTTs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Jan 2023 14:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239772AbjAJTTh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Jan 2023 14:19:37 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6613A5329D
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:19:36 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id b3so20046489lfv.2
        for <linux-crypto@vger.kernel.org>; Tue, 10 Jan 2023 11:19:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ts8pg88W1SqtrgDHeZ4rSJsGAKw1h4BEAKukVwN8v3k=;
        b=SYtpocZKmQuNT/cicSsVXpir68fDa2z7z+EAUU6wwuQugpXbj7qS/eV7elXgrOdXzG
         y2VDDM9KRO4d3cg9VSYhTGYCBTmkB0SIUuTkQ85SjoBCBP08s9xPRvg4+KEHhPMlPAWi
         09WVmjPlfr4Q7yQ+yQYW1C0IoLAdSVC7XaxnLf17RM4UBOtBVS5ZR+ne5KYMWMVrEo1o
         oM8pQ4aZQS5lSKzCixfby8C6vO2POe8cGqKOExqjnJfV8IxeOD7t0R7WC+Hw6PKtyHhi
         LPT4U0q3q+F5Hd7xt8yfC/Ox7MIQvd4PX3BWBqId7XMaOl1aTjQPuBiDo1+kZQ1MgALY
         WjgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ts8pg88W1SqtrgDHeZ4rSJsGAKw1h4BEAKukVwN8v3k=;
        b=vsUtj4OVSSmgMi2n4AJpIghSKNvrKxQV3Up1dl68QhKQFKJAtM+eMirIVWnA6awp1C
         d8+ZPa0qD2DnQe3Gpdp7qMp/6LULaoPEd7fD9IvgmC1IhI0zTRiL83uolO2ng+rFrOff
         AiaZfWtY9+scWEa+HmkrpaDUbGSeBGk8Hnxvr3S1dWiLsyux2k1X8NNtf6whiRXCXsC7
         8VF+b74aZd5iubn34stcAyHUpN6HbY5iOhxOUubGNqG+DdeautmSNc1k4jK2mvvu3dew
         RqkYpHMV8h0QYcAt7XDQ+u5UxfTHOSCjKDpb735gfFvm8FQIh6AC6KQmXUfMWSm0SgGU
         DS3g==
X-Gm-Message-State: AFqh2kpSnBiRw1xysvpEIea3fcLv98l+7S9hQxDiG/eYXK9sRLyfxepW
        an0bdi0XMLChnJwgbKWC+dcjwGtMfEgNI1QF
X-Google-Smtp-Source: AMrXdXsu5gKMcq/XNjBnXZSELLg6daB3YeKbqTWkcPPos88PhXSEz+HeSC+wiccc3koNOZ1lhkQngw==
X-Received: by 2002:a05:6512:e9f:b0:4cb:3b24:8390 with SMTP id bi31-20020a0565120e9f00b004cb3b248390mr10706584lfb.59.1673378374793;
        Tue, 10 Jan 2023 11:19:34 -0800 (PST)
Received: from Fecusia.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id x28-20020a056512131c00b004b549ad99adsm2297725lfu.304.2023.01.10.11.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 11:19:34 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 10 Jan 2023 20:19:12 +0100
Subject: [PATCH v2 1/6] dt-bindings: crypto: Let STM32 define Ux500 HASH
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-ux500-stm32-hash-v2-1-bc443bc44ca4@linaro.org>
References: <20221227-ux500-stm32-hash-v2-0-bc443bc44ca4@linaro.org>
In-Reply-To: <20221227-ux500-stm32-hash-v2-0-bc443bc44ca4@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
X-Mailer: b4 0.11.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds device tree bindings for the Ux500 HASH block
as a compatible in the STM32 HASH bindings.

The Ux500 HASH binding has been used for ages in the kernel
device tree for Ux500 but was never documented, so fill in
the gap by making it a sibling of the STM32 HASH block,
which is what it is.

The relationship to the existing STM32 HASH block is pretty
obvious when looking at the register map, and I have written
patches to reuse the STM32 HASH driver on the Ux500.

The main difference from the outside is that the Ux500 HASH
lacks the interrupt line, so some special if-clauses are
needed to accomodate this in the binding.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Use an else construction instead of if/if not.
---
 .../devicetree/bindings/crypto/st,stm32-hash.yaml  | 23 +++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
index 4ccb335e8063..b767ec72a999 100644
--- a/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
+++ b/Documentation/devicetree/bindings/crypto/st,stm32-hash.yaml
@@ -6,12 +6,18 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 
 title: STMicroelectronics STM32 HASH
 
+description: The STM32 HASH block is built on the HASH block found in
+  the STn8820 SoC introduced in 2007, and subsequently used in the U8500
+  SoC in 2010.
+
 maintainers:
   - Lionel Debieve <lionel.debieve@foss.st.com>
 
 properties:
   compatible:
     enum:
+      - st,stn8820-hash
+      - stericsson,ux500-hash
       - st,stm32f456-hash
       - st,stm32f756-hash
 
@@ -41,11 +47,26 @@ properties:
     maximum: 2
     default: 0
 
+  power-domains:
+    maxItems: 1
+
 required:
   - compatible
   - reg
   - clocks
-  - interrupts
+
+allOf:
+  - if:
+      properties:
+        compatible:
+          items:
+            const: stericsson,ux500-hash
+    then:
+      properties:
+        interrupts: false
+    else:
+      required:
+        - interrupts
 
 additionalProperties: false
 

-- 
2.39.0
