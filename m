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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4798AC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 20:24:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 189B365285
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 20:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhCHUYB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 15:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhCHUX3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 15:23:29 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 696C2C06174A;
        Mon,  8 Mar 2021 12:23:29 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id e2so160928pld.9;
        Mon, 08 Mar 2021 12:23:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NY+SRxkmVFnQhXa7tDDd1xj2d9pbYJvTZogTeGI38/4=;
        b=OGWygv78UnGPpMx0di7jB7JLVcLaoBI+VaVZIuCCuI6iZe/O+IE+fQNIKBE/OgM6Y0
         vuVUcgA2zkZYMJqz/dT6SCqJyoTd6raQNPc/oOWwhpRz5aeAvmjuEuSKbt2688ZmljEn
         u4v2aggbGTUaqpAvYiA+IMRgeKQeLTyULsGjzrRc1tWt2IydQoT8H7DyItq3XN9O9CFm
         uc40ojE9Gf2Q8hRSGw//na8rZ7XE+W672AvaZlta0zTZ/LabRr1Z3Cvea48Emld6ko2z
         TUS+eaD4mKhf0374ICtj16c94BvtI/wArscpfGAIy4fEhMckAzmJZZfQYTugPWEj9CHf
         BQww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NY+SRxkmVFnQhXa7tDDd1xj2d9pbYJvTZogTeGI38/4=;
        b=QDpVC7JfSmQAKFBIc7DoU21XzajDCbtNJAc44b/eENgpOeDdkuFLGBWVwaRV0XtZwA
         +czPy04RKqJI7jyIpdgPjCmdDvt/1cQzHXSmAgAyMocjKt/0HrjF0tlbowFcbG2gPaQ0
         WmJdFr1Bysrxrrkuv/DqNP5/Dy8exUeQhZG32mE2Gpm1deQPFZfA4vMLyvH8JGVv86bK
         a2dMEZq8NKTVObUjFLeG9tfbdFeH7/soIaGo5ITlog88cA4C3Ml26dvhE7ZPwYXHPFew
         4IsUbw2wEHjb07+XMsJr1hYf2mBkT/pMJY+iSC2iRzCKhd6UdJMA12SJePnehm1g0fo8
         y8qQ==
X-Gm-Message-State: AOAM5302TwtDtiA/ZscXOPnfzRQ7dqXkqJxyhZOT2Uy4Hg3F62NEeCpz
        HXYyqwkC8aIncRxNuBUWLBw=
X-Google-Smtp-Source: ABdhPJxVCHTU+csg234gcJuLoIgHO5FpwwLb8mEX9lZtWL4nxesdT2BiORohPt8imT3j9wd7k4msCQ==
X-Received: by 2002:a17:90a:e542:: with SMTP id ei2mr664000pjb.134.1615235009060;
        Mon, 08 Mar 2021 12:23:29 -0800 (PST)
Received: from varodek.localdomain ([223.233.103.31])
        by smtp.gmail.com with ESMTPSA id m3sm10262962pgk.47.2021.03.08.12.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 12:23:28 -0800 (PST)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Kishon Vijay Abraham <kishon@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Gowtham Tammana <g-tammana@ti.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Vaibhav Gupta <v_gupta@ti.com>
Subject: [PATCH v1 1/3] dt-bindings: crypto: ti,sa2ul: Add new compatible for AM64
Date:   Tue,  9 Mar 2021 01:50:03 +0530
Message-Id: <20210308202005.243228-2-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210308202005.243228-1-vaibhavgupta40@gmail.com>
References: <20210308202005.243228-1-vaibhavgupta40@gmail.com>
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
 .../devicetree/bindings/crypto/ti,sa2ul.yaml  | 40 +++++++++++++++----
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
index 1d48ac712b23..6eb9acd564c2 100644
--- a/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
+++ b/Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml
@@ -14,6 +14,7 @@ properties:
     enum:
       - ti,j721e-sa2ul
       - ti,am654-sa2ul
+      - ti,am64-sa2ul
 
   reg:
     maxItems: 1
@@ -45,19 +46,44 @@ properties:
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
     description:
       Child RNG node for SA2UL
 
-required:
-  - compatible
-  - reg
-  - power-domains
-  - dmas
-  - dma-names
-  - dma-coherent
+if:
+  properties:
+    compatible:
+      const: ti,am64-sa2ul
+then:
+  required:
+    - compatible
+    - reg
+    - power-domains
+    - dmas
+    - dma-names
+
+else:
+  required:
+    - compatible
+    - reg
+    - power-domains
+    - dmas
+    - dma-names
+    - dma-coherent
 
 additionalProperties: false
 
-- 
2.30.1

