Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 807D1CE7A81
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Sep 2023 11:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229537AbjIYLM6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Sep 2023 07:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjIYLM5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Sep 2023 07:12:57 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77EDEE;
        Mon, 25 Sep 2023 04:12:47 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-79fab2caf70so28366339f.1;
        Mon, 25 Sep 2023 04:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695640367; x=1696245167; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xCqerfCc4AP3+BzhaJLjuWZRNSUdYSAiu9gWle70v2Q=;
        b=C/05FtRckKaxFw/ZjpHhrHoNVhVZZqQ1nqhsdG9UosKV0rLMTXc9jyuJ60fVZHZAfU
         RfrfpINck3+am9+Dacwm8uJhek4YjMfgCv+4aHOXX9MEGg3GO32vxYdyOHMXBoXmiaFR
         MXCOKqNbH5mAqpL0YY2wS7VLiKzHCe6ALjAtOwJdJftGUKBZbeSXItiOTBDQHiN85fDb
         wBNfA4IpGvTJ8X9bQjyHYOXG6UKurBZNxwqvFsfpvwTNGNRzB7qP+uzoW2CC/gA4no1S
         ahwX6j0aQFs3KyYiviQL3qP/3fUeGo98uyOYnNWl76OBt1EKWYKL3m6LYGCnrh6vPjmG
         sN9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695640367; x=1696245167;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xCqerfCc4AP3+BzhaJLjuWZRNSUdYSAiu9gWle70v2Q=;
        b=YJPGY42zz8leT0VQhgnEcjBUdTJSEFqB9Z2kuvCvHA/PPexAnZXVyHjUFd6DmdGXP8
         fhZRsfZnHpzF4RmgBYAIaOqKuTGUEqqkuE9zzadu0mwpdYbyNXCFDjSpX0la5r4ZhWq6
         xeTRvDV1zoG3mEvIoP5hqC3PE/aW+6A0aKdPqvP0oBPgCZq0XzbzOGSxj0Xa2SJMVMMi
         zqHrTLBkxKKv5xl+5YE9dCfJIa89vm8JDV5xtQHhU3mTH6H9YCNl1m9PZfIfz9ovsi5e
         PoZ5G3yak3cLM56HPOhY/3DLZyUCdrftI3NYMc3rmJelsZ7c36cn3NodsIB+R/QXGq4D
         1xyg==
X-Gm-Message-State: AOJu0Yw8A0+j44O5KQEH1TSBZX7Im7COJ0m0V9FyX0sTjD7WUSvByl41
        452XJzqRxjXSz27MuB4GlSa2lIhQBS4=
X-Google-Smtp-Source: AGHT+IEQnQhELepoCHRPjBr07Qbm9SqGjVs+6L6GrptFiQ4xKeTjooEeb+yOnGeBbjNPGAdnoBaW7g==
X-Received: by 2002:a92:d40e:0:b0:34f:a4f0:4fc4 with SMTP id q14-20020a92d40e000000b0034fa4f04fc4mr5898947ilm.2.1695640366963;
        Mon, 25 Sep 2023 04:12:46 -0700 (PDT)
Received: from fabio-Precision-3551.. ([2804:14c:485:4b61:fbad:220b:bad3:838c])
        by smtp.gmail.com with ESMTPSA id 131-20020a630289000000b00528db73ed70sm7832772pgc.3.2023.09.25.04.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Sep 2023 04:12:46 -0700 (PDT)
From:   Fabio Estevam <festevam@gmail.com>
To:     herbert@gondor.apana.org.au
Cc:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        conor+dt@kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, Fabio Estevam <festevam@denx.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v2 2/3] dt-bindings: crypto: fsl-imx-sahara: Document the clocks
Date:   Mon, 25 Sep 2023 08:12:19 -0300
Message-Id: <20230925111220.924090-2-festevam@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230925111220.924090-1-festevam@gmail.com>
References: <20230925111220.924090-1-festevam@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Fabio Estevam <festevam@denx.de>

Describe the clocks (ipg and ahb) needed by Sahara block to operate.

Signed-off-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
Changes since v1:
- Simplify the commit log. (Krzysztof)

 .../bindings/crypto/fsl-imx-sahara.yaml         | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
index bad82491cd6a..9dbfc15510a8 100644
--- a/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
+++ b/Documentation/devicetree/bindings/crypto/fsl-imx-sahara.yaml
@@ -21,17 +21,34 @@ properties:
   interrupts:
     maxItems: 1
 
+  clocks:
+    items:
+      - description: Sahara IPG clock
+      - description: Sahara AHB clock
+
+  clock-names:
+    items:
+      - const: ipg
+      - const: ahb
+
 required:
   - compatible
   - reg
   - interrupts
+  - clocks
+  - clock-names
 
 additionalProperties: false
 
 examples:
   - |
+    #include <dt-bindings/clock/imx27-clock.h>
+
     crypto@10025000 {
         compatible = "fsl,imx27-sahara";
         reg = <0x10025000 0x800>;
         interrupts = <75>;
+        clocks = <&clks IMX27_CLK_SAHARA_IPG_GATE>,
+                 <&clks IMX27_CLK_SAHARA_AHB_GATE>;
+        clock-names = "ipg", "ahb";
     };
-- 
2.34.1

