Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5386C05027
	for <linux-crypto@archiver.kernel.org>; Wed,  8 Feb 2023 18:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230516AbjBHSiw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 8 Feb 2023 13:38:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230509AbjBHSiX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Feb 2023 13:38:23 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E7239ECB
        for <linux-crypto@vger.kernel.org>; Wed,  8 Feb 2023 10:38:15 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id fi26so21724984edb.7
        for <linux-crypto@vger.kernel.org>; Wed, 08 Feb 2023 10:38:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/cQTcEdA6/1Tvp2AynCxy/uYQRIV6AL4re0IqB5Qt5w=;
        b=rc/8MVg8sUg/kg2/NFEYlA+GnNeMHqBZ1RQaHwFK+RaYrD1V4tYxKHZh6anZAZ6TAy
         hr032aC4PQcVOQgo30eG8Lg1TpDuFqsVP7o+bK+upuk1C9YNfubPVf5GG5mRKnhw3tlZ
         LqREcc7ydj8GpCbQJwSXGSuQoqCmzRMurK9qYEm9MhMnF+ORuf2JfHHD1PQeA+vTJPf1
         7IC1Y/uFR+mt1H5uKwh2xLCgFed88Kafi5viL6UzvMdtyoxtQhkFdUNvltEUVfIIZBNm
         PCPbM3yyLzYC/+xNdQqg2llDSVfHImF0ol/bO2hflKhiDyLjgPzATPgjuv40IwdUbk/m
         v+tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/cQTcEdA6/1Tvp2AynCxy/uYQRIV6AL4re0IqB5Qt5w=;
        b=Yx4U56K/cXu9gIdgXHygk3PgZCIrtjbHC8SZ0msBN0jSVBPUNGL1RLkoM9Rd5G9MKX
         PUvI6/tANa4SlZKW5vyEnPHPV9sBPXhaT/BKdWpFivwWvLrA49xsR2jVsP7Fe7IT+nV5
         KiYiTsEK1XnIiN/TNsZyobpKQU1Z+SW0MHALTPsLFSlm42eGgdJOnYbcBF7tNnA0QE4e
         a95TgtN2bgWq3tjhR3E8H3+7xMeKQgA+8VWCF4btfjNuuosGyW5mvLM/NGaw1kiryTil
         XHCKQJKq0H/5DCx3Tsa1Np7xqCCuj+d9gnlqiVntWsfyP1r8Ib+1dg9yCDCYPMByGVlF
         1vBw==
X-Gm-Message-State: AO0yUKX0hC3KXKDlZU3qUlUcfmaPAiUczqDwX8Ck2Y0ivMqWKSgj7YjO
        CPwixb9yFeW8CO2COImZPZt6YQ==
X-Google-Smtp-Source: AK7set8Zc/vEW+CFSnoFThjz5WHAQEOEOVHuHzI/XtugIhVfdZXj1JLXRnsQI9CPT5xZ578ks4P+sw==
X-Received: by 2002:a05:6402:5205:b0:4aa:a248:a15c with SMTP id s5-20020a056402520500b004aaa248a15cmr10482536edd.1.1675881493776;
        Wed, 08 Feb 2023 10:38:13 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id d22-20020a50cd56000000b004aaa8e65d0esm5179663edj.84.2023.02.08.10.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:38:13 -0800 (PST)
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
Subject: [PATCH v9 03/14] dt-bindings: qcom-qce: Add 'interconnects' and 'interconnect-names'
Date:   Wed,  8 Feb 2023 20:37:44 +0200
Message-Id: <20230208183755.2907771-4-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
References: <20230208183755.2907771-1-vladimir.zapolskiy@linaro.org>
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

