Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA63CE7A8A
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Sep 2023 22:31:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjIXWbd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Sep 2023 18:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbjIXWbc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Sep 2023 18:31:32 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD90DEE;
        Sun, 24 Sep 2023 15:31:25 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-273e3d8b57aso1205970a91.0;
        Sun, 24 Sep 2023 15:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695594685; x=1696199485; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BH2fpi3BgA4AHIjTpm3Zg5g6h30kc6erTrSmzdfpxUc=;
        b=eD0wrnATphDNrF9VpTj1iiOfzaVgTAJEdc6CB9exaQdEeE6mVL3Zp5j7UIhO5iJ/zB
         vxkQ9ALV7SFCRj7O7fAn3nnrrXwut6wgl8CPzB5UKlR1wd+APKXqJ/XXLu8mxknUaxHK
         D8xlq8QYOWkh1ec2L8g4tEXmFoM9MIfcipPuAHjhLALgnzaoQIfEh/FmOkoMAiWZc9Xe
         iEhO7ko2PtzKP2tLoJNY96FL8IcMIxby2Mv9Jl4nZmhpegSezxrCIacpYkIuCWLxXDPE
         CzotZKAqrS325cZ0ZyL28nW79txEf4FfoMJv/b7ikru4t88G4HwxJPSG6AHgIyANBS3A
         /odA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695594685; x=1696199485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BH2fpi3BgA4AHIjTpm3Zg5g6h30kc6erTrSmzdfpxUc=;
        b=H1uNugP7M9L1LEJtAE7xD6UdZbZk3GZslrjfcU5RGsKjFQfYxJw6Mx5hjCjnjuEbEB
         AI9a0nlYlxi1DAG11Dzvc/P9LgRLZgc/J7T1p2Xbso5c6Kv5xSHkAdpBuNAZPLicefJB
         PNJfDvwNr41+tYCJekB0lo4iEYzXDcrKX64C/Vnwk8kUsxs53qAcB6Y/qctEmNa2KusM
         IrEYWK8uYGiLWy7Zr1Zs8iB/swgceUUgdUbtM1GAQ/oGkg7Ct/tBoMgULry5gPr/558Q
         evrPVOTm/3Rfh32amBabT2nO9JmbOGqgLsQ/NQlcVjx34khWVw04ieDGYTmD6MeZL67W
         KnOA==
X-Gm-Message-State: AOJu0Yz51u1ethdzlSe5JL5gfLizRZtOOCJO6ngTYHTO/eIvjaso/g74
        A7/zTgHGJsOxRVN4g5rPCFU=
X-Google-Smtp-Source: AGHT+IGTnhwVkul1Mjqmsi7LHiFHi9OTLDffugTC+2hsPj1N3XewEXelpB0tr+lRvLiwR/PyNT6lxg==
X-Received: by 2002:a17:90a:394a:b0:263:730b:f568 with SMTP id n10-20020a17090a394a00b00263730bf568mr4483507pjf.3.1695594685130;
        Sun, 24 Sep 2023 15:31:25 -0700 (PDT)
Received: from fabio-Precision-3551.. ([2804:14c:485:4b61:ce8e:216e:1d92:cabc])
        by smtp.gmail.com with ESMTPSA id 5-20020a17090a1a4500b00274e610dbdasm9315258pjl.8.2023.09.24.15.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Sep 2023 15:31:24 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@denx.de>
Subject: [PATCH 4/4] dt-bindings: crypto: fsl-imx-sahara: Fix the number of irqs
Date:   Sun, 24 Sep 2023 19:31:04 -0300
Message-Id: <20230924223104.862169-4-festevam@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230924223104.862169-1-festevam@gmail.com>
References: <20230924223104.862169-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

i.MX27 has only one Sahara interrupt. i.MX53 has two.

Describe this difference.

Signed-off-by: Fabio Estevam <festevam@denx.de>
---
 .../bindings/crypto/fsl-imx-sahara.yaml       | 23 ++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
index 9dbfc15510a8..9d1d9c8f0955 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
@@ -19,7 +19,10 @@ properties:
     maxItems: 1
 
   interrupts:
-    maxItems: 1
+    items:
+      - description: SAHARA Interrupt for Host 0
+      - description: SAHARA Interrupt for Host 1
+    minItems: 1
 
   clocks:
     items:
@@ -40,6 +43,24 @@ required:
 
 additionalProperties: false
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - fsl,imx53-sahara
+    then:
+      properties:
+        interrupts:
+          minItems: 2
+          maxItems: 2
+    else:
+      properties:
+        interrupts:
+          minItems: 1
+          maxItems: 1
+
 examples:
   - |
     #include <dt-bindings/clock/imx27-clock.h>
-- 
2.34.1

