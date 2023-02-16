Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE005C64ED9
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 13:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbjBPNOx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 08:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjBPNOr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 08:14:47 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9245357D
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:40 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id m10so1901366ljp.3
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zPdqAVNJI8VFw+E8thVrlhFODN9g8GlhI24Q34QDNM=;
        b=y5BEO/ONkb5MwWokeg2ixF7sVm74K8NdDpHUNvuye7j13vwSvxXbb6EZ+VplvE4vKm
         62FlwTnwXrP5yxGqjQsKpvPA5vMTtBxJ3C6O5XdpS6vQzoRp75v8hjJ+3lJJQZKVUXOd
         u/E74cyQ6HsB31ZKm6HEJQCbhqkwthALMXpJwRP6muUpgR0qpCpVwuBpxfjBttP2bWIM
         lHQasttT8WUtb6tpAR+2iptYDHs+GmynbCz+mlOKOhD326pxyTAGQLSzjpQbVggo+Jui
         5aB2g0UyeBuSW9oEngnHF16HsSzwJzhgHCwO21ERy290QNuKXpS6teNLQqo9F37Vnq6p
         tm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+zPdqAVNJI8VFw+E8thVrlhFODN9g8GlhI24Q34QDNM=;
        b=0Z908QH2CCuv4pkFe/lBi3tvH40dZnRSzli+EKAvVEhes7bebK19xcBl47V0TRRjfu
         AcHgd/EAsNVS/hOJeBgiY7l1P6KubI09YxuiPR25ThL5lpk4axARJYRvAWpzmdZr7FQs
         zIFlCUjAIrrOtN1YqgM9S9zMwE17gGNse4Rum9YfNvA6xLsfSolKXt/28hqq9boec7hC
         W1F7PJgEQCTOQrn5PdCG4FI6QdGS7+u4p72tNskv3vMtmLBdhGeVAhX1Bf12y8zwhBIN
         l7SyCcGeSBjJ0JkFJzhnobqVSNkhGxAgbw3Ykqho4bv+69q2gr4FjZ3wz1QysJZIpsb5
         zp4w==
X-Gm-Message-State: AO0yUKUIhXJ+gxJD568/u6IKpRUjoc5wm9CagijX4BepIpuKOSkMu4cV
        gmBpGVLNSpdKEeWBa30jADuBaA==
X-Google-Smtp-Source: AK7set8ZD2nrT/xUH4AunB52A4EKSovBjpMT2n2LZ2xqm8L7E561RyIQSfWQgPMzm2OVCAITKBA8kQ==
X-Received: by 2002:a2e:3001:0:b0:294:3775:df9 with SMTP id w1-20020a2e3001000000b0029437750df9mr1638639ljw.0.1676553279028;
        Thu, 16 Feb 2023 05:14:39 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id j8-20020a2e8248000000b00293500280e5sm194345ljh.111.2023.02.16.05.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:14:38 -0800 (PST)
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
Subject: [PATCH v10 04/10] dt-bindings: qcom-qce: Add 'iommus' to optional properties
Date:   Thu, 16 Feb 2023 15:14:24 +0200
Message-Id: <20230216131430.3107308-5-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
References: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
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

