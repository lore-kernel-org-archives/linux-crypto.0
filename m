Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2A3EECAAD8
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Sep 2022 11:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiITLl3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Sep 2022 07:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230124AbiITLlV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Sep 2022 07:41:21 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D5871BEB
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 04:41:13 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s90-20020a17090a2f6300b00203a685a1aaso2206158pjd.1
        for <linux-crypto@vger.kernel.org>; Tue, 20 Sep 2022 04:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Ow7jg7iL4OBsAsTVBpxDnjt3oRi+Efs0B5EUHKrVg58=;
        b=u4imFhzk0rcWxWia/6Eb8RWqVZp7FRaBXwhvqBSQsj+wnFAfG3Eq2VnrbHowHbUXGT
         vnXztbOcsy5EdsL+f0nZioHCAJ7pOiVp5GEvXrplkKWhmVlNEdcdNRZvPoj4iRpQDHj6
         7Geb76bWw+eM0+XLX95FguUPnXZEeREBwbkzS0MQmzG3wuGoEaar0/bQuApnhqhSnS9X
         7p+PqCIjIVmGjlVCM84bG++O6eFlKmJBmFikj9lILL8sY7GHVQTDBJTQDrOKGJCI6EuY
         zg18mxx87PYZv9jtCyEm7KZs2ClUc50CCsU08RPpfE6jooYU4mpySVXwpyu5mkSmuoZM
         ujrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Ow7jg7iL4OBsAsTVBpxDnjt3oRi+Efs0B5EUHKrVg58=;
        b=2sOPWfO91EyUssnGVlonnAj5Hhj7te/f2MlUeXIgxLlOUDG56Kip1w6PTEImvFBNCP
         HDhxmEPDs0jzYpDhxEThFvj6JxbLoaEA6woK10PBp5pWWg9qCuf3UzAhvmiBl+LFA7fq
         eH1qvzBvXmiyenOTikp5PUzeCrqN4TZ2v00MA3jW9x+cXh1PuLRKuWH0XpAKpxhNY0m1
         mpGwO/NZKZupFgBiMRmP7UxfdsoALgd3Q+9iZiAiRJ2H6ZoH6lkKXlpctC6+IinvriGh
         lDu4C0ou0QSS2wgFS8+BoeXeUsO+T6drf8NcZWcVD+e4uIas6jS4lmszjm3ju5aMUvwU
         gwfA==
X-Gm-Message-State: ACrzQf02AGWHqkeg7cTp/na1nxpIdPkRJ1aJtXtNEbyuwjQWMaIddv83
        i85ZZ1dBrMLcV5E6fb/vxTzpBJ1mBvFe2Q==
X-Google-Smtp-Source: AMsMyM71JT1mEhC7wdZI3cGQS2uyvkFvIR5GXCiEuGs3YyQ/VsR//PE6NxgcG9fopZr8UvuyDFiJHQ==
X-Received: by 2002:a17:90b:4b11:b0:202:998b:71b1 with SMTP id lx17-20020a17090b4b1100b00202998b71b1mr3536363pjb.208.1663674072459;
        Tue, 20 Sep 2022 04:41:12 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c61:6535:ca5f:67d1:670d:e188])
        by smtp.gmail.com with ESMTPSA id p30-20020a63741e000000b00434e57bfc6csm1348793pgc.56.2022.09.20.04.41.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 04:41:11 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, herbert@gondor.apana.org.au,
        linux-kernel@vger.kernel.org, robh+dt@kernel.org,
        linux-arm-msm@vger.kernel.org, thara.gopinath@gmail.com,
        robh@kernel.org, krzysztof.kozlowski@linaro.org,
        andersson@kernel.org, bhupesh.sharma@linaro.org,
        bhupesh.linux@gmail.com, davem@davemloft.net,
        Jordan Crouse <jorcrous@amazon.com>
Subject: [PATCH v7 2/9] dt-bindings: qcom-qce: Add 'interconnects' and 'interconnect-names'
Date:   Tue, 20 Sep 2022 17:10:44 +0530
Message-Id: <20220920114051.1116441-3-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
References: <20220920114051.1116441-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add 'interconnects' and 'interconnect-names' as optional properties
to the device-tree binding documentation for Qualcomm crypto IP.

These properties describe the interconnect path between crypto and main
memory and the interconnect type respectively.

Cc: Bjorn Andersson <andersson@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 8df47e8513b8..94f96ebc5dac 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -32,6 +32,14 @@ properties:
       - const: bus
       - const: core
 
+  interconnects:
+    maxItems: 1
+    description:
+      Interconnect path between qce crypto and main memory.
+
+  interconnect-names:
+    const: memory
+
   dmas:
     items:
       - description: DMA specifiers for rx dma channel.
-- 
2.37.1

