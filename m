Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B52C64EC4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 13:15:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbjBPNOw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 08:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230028AbjBPNOl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 08:14:41 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E255356C
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:39 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id g14so1869965ljh.10
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676553277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/cQTcEdA6/1Tvp2AynCxy/uYQRIV6AL4re0IqB5Qt5w=;
        b=WmHCiNh1iOAGvg0WxMM6/09R1KCZOunBt55vRYlh0THdC+EEcwtAZrCFydLjYWzAqV
         q+jUdR8UQQacgj7YhjbMOaKLu9MjXh8BSMVsUl28k2xwQL0RjitNnZ01vsDVPA6Eb5gd
         7o3fbI1YDpLObiv3GXDN7WPFTULmeBzv8EzsrVrfnyobbH3TS1olRauACGoTPgwfLKqB
         wffsdlJEmYwNZMk39zOEdS77i9Md9o79LU80EKMOurXIU2XNOJvBB1rRqAW06MsHdaIf
         qvvHGnQ7EhsCF6UCyYPIe68twPwgFuRCNxHsexfOTYXvu1YV6v23zbMKf5ItztUR1rQj
         HXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676553277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/cQTcEdA6/1Tvp2AynCxy/uYQRIV6AL4re0IqB5Qt5w=;
        b=zL2iJ89TPZPgTAxUSBc1QRzJ59+MZAE3vIcq+tik50AMSSFFptizJ30D3l7FzIdjz8
         RcxLLxSHDOYPAIiZuyyp6KTsdcal8aSXKe3t6uX5pBe/jwlWCrTYdTqoX6rWQXap+vV+
         TF7XldhbnX/G72aF9vaWIIw6rPx5WrbAx36ypFoqpWIaECilkmXgQ/t0nlohVyO8OZDW
         SNBuE/b4QywqgcEWsWVXGS2DDH3QjjZQuF6R88gUSFTlVaKC/ECWhsc74hdVNd3jr7LD
         iDF6ExH5CkyDD8pYOvpl/1AGJNJt1pPUptqqvzd8n4nD/HYciKYkN/+C135nsg9p1dPX
         NWPg==
X-Gm-Message-State: AO0yUKU6DibNyhX1W+IOSOaGTdYfoMXeEQ2B1rCHl1gNMXn4+JwZOu7S
        nToITO6MiT5/4v5syyKhHzoCXA==
X-Google-Smtp-Source: AK7set+OX9qZ5I3ZoqUDUICHns/n6P882LYTlqlnCMY04ZjXaBimoEsaLOpZ+WCEG25hZQrjdGcEiQ==
X-Received: by 2002:a05:651c:2115:b0:292:b368:3483 with SMTP id a21-20020a05651c211500b00292b3683483mr1824607ljq.1.1676553277636;
        Thu, 16 Feb 2023 05:14:37 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id j8-20020a2e8248000000b00293500280e5sm194345ljh.111.2023.02.16.05.14.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:14:37 -0800 (PST)
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
Subject: [PATCH v10 03/10] dt-bindings: qcom-qce: Add 'interconnects' and 'interconnect-names'
Date:   Thu, 16 Feb 2023 15:14:23 +0200
Message-Id: <20230216131430.3107308-4-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
References: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Bhupesh Sharma <bhupesh.sharma@linaro.org>

Add 'interconnects' and 'interconnect-names' as optional properties
to the device-tree binding documentation for Qualcomm crypto IP.

These properties describe the interconnect path between crypto and main
memory and the interconnect type respectively.

Cc: Bjorn Andersson <andersson@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Tested-by: Jordan Crouse <jorcrous@amazon.com>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
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
2.33.0

