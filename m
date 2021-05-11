Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA63C433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 13:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6727D613CD
	for <linux-crypto@archiver.kernel.org>; Tue, 11 May 2021 13:29:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231401AbhEKNay (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 May 2021 09:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhEKNaw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 May 2021 09:30:52 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6868C06174A
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 06:29:43 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id c3so28645970lfs.7
        for <linux-crypto@vger.kernel.org>; Tue, 11 May 2021 06:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FFYr3Xo1ppCbhfOBPELbi7/g/WpT3C+kHa8n/mlqcNc=;
        b=xqyvcHJ3/7tk/3+p2H6mz7mGJYVGdp6Lwz1loHB0CDVOFJlyMuVPJ0XIX7zcqu4T0M
         ZNcQQT4Wx5RLT59t+TY6MjUlZKGMCB/JaJcLiEJ7LxntOuWHkTo6YkGZ4l9trrZlCIV/
         LzdCb1dBjuvyaVkHrzUDSEDMR31jRLi+zdfjO3ae+63VSw6Q1EJTmPU1beqjfkWf/Xhs
         XEq2zZib3MmsD2WjTVXgWL2Rmzus2nqmPUkmzurLX1PfKiXqipUqKkE71HP/fNrI1KMQ
         DyKvib95bsgPUnjaig8+UJ2bm+P7MlqqqSlLwTxJAVT+V3EdicAGqzd7r/Xf/usdh7wC
         Bulg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FFYr3Xo1ppCbhfOBPELbi7/g/WpT3C+kHa8n/mlqcNc=;
        b=UCZn10lUCwXZ+O46plQfQeuSxpqo2lC3HpcfU7nXiK5bSVB57jzjS8d8RXKc2i5TrD
         4WjRfYzeHMhLgZRD8i0+OxgVOhs9kPwdPJlMMlBRPCKBoKD9mvUhYedBB9d7gWBnaGhG
         5/JT9qvgyArm47io1LjWHJz3JEp5IBIMfHG3ubc/Z4mpUc83kh8MfjguS3Yuah+vAXo9
         Ykd6Y/qy3tFwmEs33y3ktPewONu0M60fSK95UOc0Nv4fzpsf4VcMYc+M6lwQA0VlLiH7
         2grbSufjsw9RYtTVGu3K7wCwa+SQWHkzw/B/Ggy3bT7b890HgW7WT9XpeIgUtQZza7Gt
         bSPQ==
X-Gm-Message-State: AOAM530C1lZ65M26V7DkHH5va2BnvnF5Dlmh9LZsU0IcSgiO5KInyhOK
        MxlyHWH66sOHqytGgpUg6dFWlw==
X-Google-Smtp-Source: ABdhPJzFq6lZIyzeqJ0O+rx0RF9ZTO8L/DRul5UAuP4Z7uMSuZCun9S0iVdArkWaQQCmOFreo+ZHzQ==
X-Received: by 2002:a05:6512:3056:: with SMTP id b22mr20331716lfb.526.1620739782260;
        Tue, 11 May 2021 06:29:42 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id m4sm3699740ljc.20.2021.05.11.06.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 06:29:42 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Deepak Saxena <dsaxena@plexity.net>
Cc:     linux-crypto@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org
Subject: [PATCH 4/5] hw_random: ixp4xx: Add DT bindings
Date:   Tue, 11 May 2021 15:29:27 +0200
Message-Id: <20210511132928.814697-4-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210511132928.814697-1-linus.walleij@linaro.org>
References: <20210511132928.814697-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This adds device tree bindings for the simple random number
generator found in the IXP46x SoCs.

Cc: Deepak Saxena <dsaxena@plexity.net>
Cc: devicetree@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
The idea is to apply this through the ARM SoC tree along
with other IXP4xx refactorings.
Please tell me if you prefer another solution.
---
 .../bindings/rng/intel,ixp46x-rng.yaml        | 36 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 37 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml

diff --git a/Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml b/Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml
new file mode 100644
index 000000000000..61963fa9347e
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/intel,ixp46x-rng.yaml
@@ -0,0 +1,36 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/rng/intel,ixp46x-rng.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Intel IXP46x RNG bindings
+
+description: |
+  The Intel IXP46x has a random number generator at a fixed physical
+  location in memory. Each read is guaranteed to provide a unique
+  32 bit random number.
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+properties:
+  compatible:
+    const: intel,ixp46x-rng
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    rng@70002100 {
+      compatible = "intel,ixp46x-rng";
+      reg = <0x70002100 4>;
+    };
+
diff --git a/MAINTAINERS b/MAINTAINERS
index bd7aff0c120f..cc4bb4e75f04 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9248,6 +9248,7 @@ F:	include/linux/soc/ixp4xx/qmgr.h
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 M:	Deepak Saxena <dsaxena@plexity.net>
 S:	Maintained
+F:	Documentation/devicetree/bindings/display/intel,ixp46x-rng.yaml
 F:	drivers/char/hw_random/ixp4xx-rng.c
 
 INTEL KEEM BAY DRM DRIVER
-- 
2.30.2

