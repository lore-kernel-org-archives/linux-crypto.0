Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99A4C636D3
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 18:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjBHSiv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 13:38:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230516AbjBHSiX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 13:38:23 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1107128217
        for <linux-crypto@vger.kernel.org>; Wed,  8 Feb 2023 10:38:17 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id l12so12839895edb.0
        for <linux-crypto@vger.kernel.org>; Wed, 08 Feb 2023 10:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zPdqAVNJI8VFw+E8thVrlhFODN9g8GlhI24Q34QDNM=;
        b=HI4z87JqBld+gUs2a2PvNMpTJ/5MAeMGcTipkWGogzA/iJcJzDtU1obNS0NUQunzfu
         yd8UKzz8vkydQ6naOErd3IxVWPW/QSFPxiFvAD7N4OnKdpWAzFrElcDFSxB3HW94FqLH
         +Mw/9aLaJLy3ifUFj062rz8HoEWRKb8nfgOXeUBAhc+cPD7WCPugnRNjJ64PNDIfg4iE
         kztsvbSZhu2G3CSKQsjjhYb1U52K2vk27T/w2eBpie7hvN0uuei0Si4R2teRfSchLYgI
         rAKGapT6ha0aZLYxxYgjY4wS3C1uMoTzfz2Zz4MWaDuo6VfG5aQ6mQ2CF6bSrP9DIlIr
         M+5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+zPdqAVNJI8VFw+E8thVrlhFODN9g8GlhI24Q34QDNM=;
        b=gbbTH9RFykbQIt86B6s47Euo4HGCidNWqdnWek/CaNQgEbE6XP8UxZ7TowbrViPQKK
         nqZHQpUsgfbkxQES5KlW7kL8BfH0tRjgY/1170cmwJ7RRma33ScBqG+zfkcU4HM3CuEB
         IKe4OUbbk7iLpNxG7MHR1/2LlOXOPP7scf7Zum0QmTW1KR+k8u7sJ8WOk07TtnvHd7tu
         dxcN7dG3YE4nWe/iHT+CwTD06kedi3LndKftooVxXgJCJHkgrJCLySGSd0/JnetCfqfN
         1cd2qCJTYYH+yZYFSvnomClb1sTTuVwJEUIDEetgeJqZJIfaNNBehx/zQf1lOW30FuMI
         WN/Q==
X-Gm-Message-State: AO0yUKX6Zr+5PQUzZKgcgf3t6uIACnB/ImNUmVghYRV1wRh2vJ54gR6/
        VT/u43bcPfX9XR17193reIaaHg==
X-Google-Smtp-Source: AK7set9tBOEiCi89P2IOJBPO/W87zgEQ+HJNix4V7CJ0RB4CZTX8X6K9mQ0n1eahyZwrqWFbsc4xzw==
X-Received: by 2002:a05:6402:51d2:b0:4a2:64d7:16bc with SMTP id r18-20020a05640251d200b004a264d716bcmr9494598edd.4.1675881495668;
        Wed, 08 Feb 2023 10:38:15 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id d22-20020a50cd56000000b004aaa8e65d0esm5179663edj.84.2023.02.08.10.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:38:15 -0800 (PST)
From:   Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Andy Gross <agross@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, Rob Herring <robh@kernel.org>,
        Jordan Crouse <jorcrous@amazon.com>
Subject: [PATCH v9 04/14] dt-bindings: qcom-qce: Add 'iommus' to optional properties
Date:   Wed,  8 Feb 2023 20:37:45 +0200
Message-Id: <20230208183755.2907771-5-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Add the missing optional property - 'iommus' to the
device-tree binding documentation for qcom-qce crypto IP.

This property describes the phandle(s) to apps_smmu node with sid mask.

Cc: Bjorn Andersson <andersson@kernel.org>
Reviewed-by: Rob Herring <robh@kernel.org>
Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 94f96ebc5dac..4e00e7925fed 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -32,6 +32,12 @@ properties:
       - const: bus
       - const: core
 
+  iommus:
+    minItems: 1
+    maxItems: 8
+    description:
+      phandle to apps_smmu node with sid mask.
+
   interconnects:
     maxItems: 1
     description:
@@ -72,4 +78,8 @@ examples:
         clock-names = "iface", "bus", "core";
         dmas = <&cryptobam 2>, <&cryptobam 3>;
         dma-names = "rx", "tx";
+        iommus = <&apps_smmu 0x584 0x0011>,
+                 <&apps_smmu 0x586 0x0011>,
+                 <&apps_smmu 0x594 0x0011>,
+                 <&apps_smmu 0x596 0x0011>;
     };
-- 
2.33.0

