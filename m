Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FDBCE7A81
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Sep 2023 11:12:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjIYLNB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Sep 2023 07:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbjIYLM6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2023 07:12:58 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68495E8;
        Mon, 25 Sep 2023 04:12:51 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 46e09a7af769-6bc9353be9bso974987a34.1;
        Mon, 25 Sep 2023 04:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695640370; x=1696245170; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7779TWAzQdCFg3sBHiH/lxzmOF6yFRQwZqbCa/Jr48I=;
        b=cs+VNAgRDiz9696PUqKQzIGgGhHM3m5sOoEIF3AAsnvYm/sZqGVSDs+cWLE+BPHuAj
         de4ElPkFlOV2gC5VgCB4yZYdRQCuFfD4rNRvTOTo5dsTWt/wfAhFXQjAKUmEiTXo7LJE
         5HplIpMDGJSH4EvHgM/W12ZJGu7fi91lZLw7gLK7v6syS3XY6t+iwv1dVIMNE1jiDMgQ
         FSi3SiFs7Y98B+pVJD1oc/X+uWcnRejYrYVmndVpX7UN+a2VV20ird7DY9C9nDde/kub
         /eLMFYud2+faKwD5B0jxUVZOvG2xAzF/ZEenZnzgrWnpYr2n24soD5cCoZlIFxqNMTsi
         99RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695640370; x=1696245170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7779TWAzQdCFg3sBHiH/lxzmOF6yFRQwZqbCa/Jr48I=;
        b=K5Kh1HmR7jUTKNoJ9FsF38StYwrkaEziT6ftEtl6AE6nlZgGynSUmsJkPGOcYK97KA
         Ast/aQnShfjlUK9NaZS+6KgpTCKDkYKiOd3SaFceobBc8gOFxaXC4DUoOfUJXabUSPlR
         WnkVno8Evc1g/RSwjPfFpK2efHO/PbsI87WVv1OvAgc0L6StHl1qKKlJL9ppO8Iinyo2
         wsU0LfYBKJeSCAhQ8nFVnCqDIUjiII8ItHTmMAUR0ozqOivkHrCNPq04wDYCxyTF48kk
         s9rYS4UO4vbsQPadll9ZqCpeU6iApGubyBx8PBvJuD/HOJSHZx3wtmDudTBE0btuJh1y
         XN0g==
X-Gm-Message-State: AOJu0YxA1dz9MUw6nj4KBzZEpmJfNes3bnpfeSI8iTG6ejTsl/VvlBBE
        Z8j/HBLnwDHc+XC6vqm0Cek=
X-Google-Smtp-Source: AGHT+IH7F9o1LW72CyEZBq9XJcMXAzd5P+wiSfKoXk4H0ssUpyPybPQ2ZNMEb1q8Kd88fZwmYmfxlQ==
X-Received: by 2002:a05:6359:d26:b0:143:6977:22c5 with SMTP id gp38-20020a0563590d2600b00143697722c5mr3938262rwb.1.1695640370545;
        Mon, 25 Sep 2023 04:12:50 -0700 (PDT)
Received: from fabio-Precision-3551.. ([2804:14c:485:4b61:fbad:220b:bad3:838c])
        by smtp.gmail.com with ESMTPSA id 131-20020a630289000000b00528db73ed70sm7832772pgc.3.2023.09.25.04.12.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 04:12:49 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 3/3] dt-bindings: crypto: fsl-imx-sahara: Fix the number of irqs
Date:   Mon, 25 Sep 2023 08:12:20 -0300
Message-Id: <20230925111220.924090-3-festevam@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230925111220.924090-1-festevam@gmail.com>
References: <20230925111220.924090-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

i.MX27 has only one Sahara interrupt. i.MX53 has two.

Describe this difference.

Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
Changes since v1:
- Placed the if block before additionalProperties. (Krzysztof)
- Remove extra minItems = 1. (Krzysztof)

 .../bindings/crypto/fsl-imx-sahara.yaml       | 22 ++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
index 9dbfc15510a8..41df80bcdcd9 100644
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
@@ -38,6 +41,23 @@ required:
   - clocks
   - clock-names
 
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
+          maxItems: 1
+
 additionalProperties: false
 
 examples:
-- 
2.34.1

