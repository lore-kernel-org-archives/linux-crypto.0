Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76626E7542D
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Oct 2023 07:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjJCHKe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Oct 2023 03:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbjJCHKd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2023 03:10:33 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4D1B4
        for <linux-crypto@vger.kernel.org>; Tue,  3 Oct 2023 00:10:29 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-4053c6f0db8so5516045e9.3
        for <linux-crypto@vger.kernel.org>; Tue, 03 Oct 2023 00:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696317028; x=1696921828; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bWSoJPhCIlN0cC4i2L0NWdvzE2l13BuJshGU4nRAwjo=;
        b=QLsmYww4Qg3ptWMRpcL6sdk6DBNGBGvZa7L/xuX//J0OdjwjHHB+W/qqvNtSoUvKk4
         LZMyedpltPTHDK46VWU9qKk7iPc64f/NpEbOtAEjn/bYx94toRKMygM3R0AdSzjt4du7
         lD2jqVe/7iRv9bhINz3HRUpra132+eIpe5vozguMaxXc8CnthnMDzPb+btTpMD4jNVyn
         /yNUmnijOwcQXl/md5/NZQ/cT+sFbc405323iQxD1LZxI/Trfvt52Wd4zJsxkrGAhhmK
         p/Ix1N9gv08sx7u9i/BjpEeo5uuxM48Sxp3AU4rkYFcBXTq2mkRggqT9Odl8fKYdG8MU
         +i6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696317028; x=1696921828;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bWSoJPhCIlN0cC4i2L0NWdvzE2l13BuJshGU4nRAwjo=;
        b=j0YJxfofJ9herxugU7xU+CG+43x5sZsOOIwEzp1BOldEXdxHb6EmATrGj6P3TpFjB8
         KquCVvWZTZ6pg+ijbYQK3ugyrtKAux43X4d1MPbVt1a6JzmSZoQFIP6ma1NvKAZxjqiv
         2wH0pt48z5t4FMjmmFealvtFTZmehnzrgA6/KhAXO2X8fEZ9510iRZ36NRRrc7eIUR3m
         42CIA/XKioW6TX8GEUPimfMfpjG/UZSejuVHeQrBtsV9odnQKAGDL2tyjq0KMsm2Ymgq
         Ftxul7UH7EkIdjipcQZKryHMxTiVYqvDsAyJgfNrCtnpfpHv/AQmmLKPr+36kHhiKyCH
         h79g==
X-Gm-Message-State: AOJu0YyJsDF5QevESXAEXCp4Ky6q/UDQEk/1QrTpKfaDWYDSBs/+uX++
        N5Okk0z95+zNrrNwEmddio5UqkeI6zlHeZATgAlkW7tp
X-Google-Smtp-Source: AGHT+IGi+6RqGcb+4ZRpRhh6xCxxmKzBvdEFVYnmyjGFav/kxPiBX/fbrHwOPunT0Gyn3vVA2KU2Aw==
X-Received: by 2002:a05:600c:2303:b0:405:dbe2:df10 with SMTP id 3-20020a05600c230300b00405dbe2df10mr11472017wmo.35.1696317027775;
        Tue, 03 Oct 2023 00:10:27 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id k2-20020a05600c1c8200b004065d72ab19sm8746652wms.0.2023.10.03.00.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Oct 2023 00:10:27 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Tue, 03 Oct 2023 09:10:19 +0200
Subject: [PATCH v4 1/5] dt-bindings: crypto: qcom,prng: document that RNG
 on SM8450 is a TRNG
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231003-topic-sm8550-rng-v4-1-255e4d0ba08e@linaro.org>
References: <20231003-topic-sm8550-rng-v4-0-255e4d0ba08e@linaro.org>
In-Reply-To: <20231003-topic-sm8550-rng-v4-0-255e4d0ba08e@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Om Prakash Singh <quic_omprsing@quicinc.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1743;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=8CwyDjTKBT82oN5QeEf44nn7stnpG4wjL1jNGz85BlQ=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBlG75fnBvRRVRmH6ri56CNjn4g9zIjD1YBZR8zzUKs
 BCJ5GDWJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZRu+XwAKCRB33NvayMhJ0WkvD/
 0XVBX3vNDxd0zFxw8kZ4Zp6w9qMu8h2j3ZsJtXBqefv4yQ3oKtndrJoqRlfqgD6hfj03u0IRwjbkwC
 YzwGOVAf2UqSwUgx1CynzxHUYDYwZc+OCBDAHbfRaBUiDhmPXjgVdI9v8xouMk7BK5KaGiMspjQ07B
 NUtmJMTdYlqUfizUlyfQLmLaqkGXSwyMqy7GxTbibx/d9ug/3j2SBEKJ5Cr/Q5DuR2StXh8jh7lLNV
 z/y9D/Y5z3PKYltC11W+Q94XXB64ZXcLH8+3ZctIXDflCdP2XvFd9+x+jhxbuwOpn4a4wBUK01fqFl
 rSCRB/CPq6AXtsxdeef53kDt4AFR8OB+G89oPn4HCA7oZX/Fb8G8Jl/iIm1T1uyBrqfQCLt1EQew0k
 M3lAHdkb7LwuhACRzfFsD897dLN3CjVL22Z12cgxzLfJXNHm01/eypnizTg2Y1qcMjSE6+sdRIgkkN
 nM8PC1hwd2/DlLOEtlq1alnIXJjqWXRcghW6kUE7SghUb1a4jfxiiMwyeSGfStb6IZaVHZ39TEw3wX
 AVbJkXYHls2S1nH+fri2LlbYSEnBGShAnQg0jPnuzVLLgUrUo0qeyiYkeMpR5OnaqSv5+hYsoize1r
 GpukhE83FsjPNgpHRBM6+03pNbmfo1riWH1M6zaQUtQeAacRPgqmLRNYsujg==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It has been reported at [1] the RNG HW on SM8450 is in fact a True Random
Number Generator and no more Pseudo, document this by adding
a new qcom,trng and the corresponding SoC specific sm8450 compatible.

[1] https://lore.kernel.org/all/20230818161720.3644424-1-quic_omprsing@quicinc.com/

Suggested-by: Om Prakash Singh <quic_omprsing@quicinc.com>
Suggested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Om Prakash Singh <quic_omprsing@quicinc.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../devicetree/bindings/crypto/qcom,prng.yaml      | 25 +++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index bb42f4588b40..04ddcc0f7165 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -11,9 +11,14 @@ maintainers:
 
 properties:
   compatible:
-    enum:
-      - qcom,prng  # 8916 etc.
-      - qcom,prng-ee  # 8996 and later using EE
+    oneOf:
+      - enum:
+          - qcom,prng  # 8916 etc.
+          - qcom,prng-ee  # 8996 and later using EE
+      - items:
+          - enum:
+              - qcom,sm8450-trng
+          - const: qcom,trng
 
   reg:
     maxItems: 1
@@ -28,8 +33,18 @@ properties:
 required:
   - compatible
   - reg
-  - clocks
-  - clock-names
+
+allOf:
+  - if:
+      not:
+        properties:
+          compatible:
+            contains:
+              const: qcom,trng
+    then:
+      required:
+        - clocks
+        - clock-names
 
 additionalProperties: false
 

-- 
2.34.1

