Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D19C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 09:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D08E613B7
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Apr 2021 09:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237696AbhDMJVP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Apr 2021 05:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238477AbhDMJVP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Apr 2021 05:21:15 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512F8C061574;
        Tue, 13 Apr 2021 02:20:55 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id e2so3573587plh.8;
        Tue, 13 Apr 2021 02:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PcVoAeyaKm71bLw3YKtI2EHhnnmMBJdeyhP0RcJzO4Y=;
        b=P/yT695PUtLSSWh7vdCU3hRz+jhpOTOJnkflqXh3eg411hBVMvpVc3joWWYiZpZQoW
         HnJ95t9WzdX5PbXYAYgVZg1bNmNfnQINNQs70eCksns3I2sOUWwfkIf43ieYPcgkRnf8
         jYZJpzk0mw/MMcIK9JF7Dq/3K8urQq4TkaiHyM+iwqz4zyrYv+M3kQv6Zn27xP1K9zBf
         A3C0lzCyS2I2DeWVqWD7n6ZS2EbQ2J18JH4euThp+z378Oiyw7iNb9q1/pNG07/ibBSl
         BfS1UoQ/hIUUO40bIyDjc9uBbWyGQIbTGRnJshM675QxNPAf5lQmb9U1ernCr1YPE5RT
         pmmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PcVoAeyaKm71bLw3YKtI2EHhnnmMBJdeyhP0RcJzO4Y=;
        b=ghJOeD2uNzAW0TxHIvfV+muwrOaOWrZwRZrCOaI5vfL2k7oMFFfg64E6mLYpx2w5rJ
         x+qS04cB5tMLo6kWntu43iKg5JOxhtcrZfPtIqyLgV4/pxgP7AoSfOWJHKl5R5TbnXXd
         Ek9VC9Mv3d3GIOTjxkpVbHeh7gToaqWgyKws3PJiGeE3ACFqEbY9teXg3y5WQdfvMEwZ
         4a7lbt/PYiQPB/VPA7e8KBX5y0atOlMzYjpTH00z9bOj8XHdmjloenTOE3BAaqFJEjAD
         Bj4E5yJWMJY3E5C7I/rGFKdBmdRGYcNizERxxyx0eQ1zcGRVrAjUsx7toVvBcoSxpaK2
         zSvA==
X-Gm-Message-State: AOAM530KOs47/b73xkn8yqMOcShF749VoGH4KqgYb+0Et5DlQERHeaUJ
        IS7uQim2j7BEubppk7TmQVE=
X-Google-Smtp-Source: ABdhPJxAiG0dwYZ1BmEH+S4cf2FeT/j4Hk6CMkdsJgZTC7b0JWb05L3kwKoRN+vkuHQi6aNt6BZ7Sw==
X-Received: by 2002:a17:903:114:b029:eb:3963:9d1a with SMTP id y20-20020a1709030114b02900eb39639d1amr452051plc.79.1618305654926;
        Tue, 13 Apr 2021 02:20:54 -0700 (PDT)
Received: from varodek.localdomain ([171.61.181.173])
        by smtp.gmail.com with ESMTPSA id x194sm13388570pfc.18.2021.04.13.02.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 02:20:54 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     vaibhavgupta40@gmail.com, Kishon Vijay Abraham <kishon@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] dt-bindings: crypto: ti,sa2ul: Add new compatible for AM64
Date:   Tue, 13 Apr 2021 14:45:57 +0530
Message-Id: <20210413091559.154169-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210413091559.154169-1-vaibhavgupta40@gmail.com>
References: <20210316220558.GA3754419@robh.at.kernel.org>
 <20210413091559.154169-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Peter Ujfalusi <peter.ujfalusi@ti.com>

Add the AM64 version of sa2ul to the compatible list.

[v_gupta@ti.com: Conditional dma-coherent requirement, clocks]
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Signed-off-by: Vaibhav Gupta <v_gupta@ti.com>
---
 .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 24 ++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
index 1d48ac712b23..a410d2cedde6 100644
--- a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
+++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
@@ -14,6 +14,7 @@ properties:
     enum:
       - ti,j721e-sa2ul
       - ti,am654-sa2ul
+      - ti,am64-sa2ul
 
   reg:
     maxItems: 1
@@ -45,6 +46,18 @@ properties:
     description:
       Address translation for the possible RNG child node for SA2UL
 
+  clocks:
+    items:
+      - description: Clock used by PKA
+      - description: Main Input Clock
+      - description: Clock used by rng
+
+  clock-names:
+    items:
+      - const: pka_in_clk
+      - const: x1_clk
+      - const: x2_clk
+
 patternProperties:
   "^rng@[a-f0-9]+$":
     type: object
@@ -57,7 +70,16 @@ required:
   - power-domains
   - dmas
   - dma-names
-  - dma-coherent
+
+if:
+  properties:
+    compatible:
+      enum:
+        - ti,j721e-sa2ul
+        - ti,am654-sa2ul
+then:
+  required:
+    - dma-coherent
 
 additionalProperties: false
 
-- 
2.31.0

