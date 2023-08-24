Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7721DEE4993
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Aug 2023 11:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241019AbjHXLd4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241016AbjHXLdf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Aug 2023 07:33:35 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A511988
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 04:33:33 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-31c615eb6feso2185704f8f.3
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 04:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692876812; x=1693481612;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/zLEugS9nGy8m343fO+U0oktU9vdXHi5A6uYZtgbj+Y=;
        b=fhauLR6cP3+CaAuEJnRjyJfMlCl4+50UKz/iA0gvrRkgNkM9rw+8iG9nAS8AsMyi5U
         kXqQ/2GnzP/pWSc4nX9jJ6vRoLbvjnf8P3ZumSRobZrMTlr8wa9MCBP0Kki7XoHDy+K9
         RZocciL8warIawbdtxiu9JfxwOOQ5df5pDdJzU6/iE5oq2hgC6KNl13pRP8Ef04brkK9
         JlvgWEEcpMZ9v9bT4McT32ROUdPVNRux60VVGfcBzbckEF8AgKZwZzVfyzM2YNgz1E/V
         5ugCy9WJOZu+ghxfCFyoh4NZE/DL6WBhdXZRcgp7xbS9b0PnPq8D5gy6wKJb/oxwtfNN
         tNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692876812; x=1693481612;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/zLEugS9nGy8m343fO+U0oktU9vdXHi5A6uYZtgbj+Y=;
        b=HASqJ2ITBHRnRDLocFeIRZmKHkw7X8mgv/+MTzHYjUh8GR9vLHCmB2qctoAvexcBud
         pFJWI05lOU7d0xrRRSmvFK4hfnZ8vhDTfmGdOoqME4vUQ3Hs88vTGeaIHMkhzqo/yg0g
         Kecw8vTWwa+tlwtdd/00KOzBex8oMKPscNv6ToBwSKheUOULTC5dlF7DdtLchly8vGqb
         SScbpdNfn/NFgesEUqJ3TxXD0xX2HsfNa4JNMZ/0WUGEmjQ+3aJ06pYOl0keSaykr/9M
         rttw+JlNRw6LPuwP/LgWCec+JEXuP/SvE6Md6g6kRLtZ9ci98bG4a1McCo9Jv3xJ39q0
         Bc9w==
X-Gm-Message-State: AOJu0Ywkduf4FLzpbdjmsElYKeq1Zqx6MYakrNPPvkvsBCgYRNlXqxka
        CDFtlxp11NSJe0sS1Bc43zkQR9biLIeYTO6iE0WjK1cr
X-Google-Smtp-Source: AGHT+IHdlm0pCfUXTMAW+oEg9e7tbMyzzy0UWxKgoF3H5LcX/OgEvj1myD84qVb5w71QFmaFqVNffw==
X-Received: by 2002:adf:e94a:0:b0:317:5e55:f06f with SMTP id m10-20020adfe94a000000b003175e55f06fmr10450881wrn.10.1692876811806;
        Thu, 24 Aug 2023 04:33:31 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d65cb000000b003179d7ed4f3sm22063938wrw.12.2023.08.24.04.33.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 04:33:31 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Thu, 24 Aug 2023 13:33:20 +0200
Subject: [PATCH v2 1/7] Revert "dt-bindings: crypto: qcom,prng: Add SM8450"
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20230824-topic-sm8550-rng-v2-1-dfcafbb16a3e@linaro.org>
References: <20230824-topic-sm8550-rng-v2-0-dfcafbb16a3e@linaro.org>
In-Reply-To: <20230824-topic-sm8550-rng-v2-0-dfcafbb16a3e@linaro.org>
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
        =?utf-8?q?=EF=BF=BCOm_Prakash_Singh?= <quic_omprsing@quicinc.com>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1711;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=EODyGQ1y4duRBKRaBi61Aed2m4X+YZ+nDCkWqRCBxew=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBk50AGSFzrid752MpfRtb3lHjKyf4Ta9G7nvQzQdid
 3MRCwfSJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZOdABgAKCRB33NvayMhJ0VgOD/
 9P0ms5HF+aOhh/gDWf3V9BdcjWLxs/tDgwdDtVi/MDurRIhY6+VScAV4nGpxqdp9rQgL6fQOyivbxS
 tbWrCKRLnb01osuBQay4YyJfQxOCKOkNS+Ry3ZR1Yj9+xF2cPyZ+2hi5T/eRn1ySxrRusi8BSUe4vO
 EMNCIr6iGuE4n4KcuntigfNl3kH76Fk+BFnHX+m2A+MxEpNt7cYQ7dS1Ek2ewsQHVHshXl9IzKxlw6
 32M707vrQ2Lfg/AEnLdhZcMkkBpqAwW2lgHILUuAQ+5gN5W2DPAXM0Iyc1daMMIT28z7AJjJsAig4T
 05PoCpfqux0pO/ChkaAeNczl33Y5P1zq5lFU7cO/0PDdbMHklEXyA8zmg1f3ZQLCpbKMHgi7HRQtq7
 ChaLaCPA7RRoxn9f0DZOW51T0WSU5Nh2PJOstiZDNH+70QW/xcb+n8mVBcTlqEf0ab96xG1qpWUYDr
 rbkkQ5igM+FyTmPpBUzR6OOMVMXAgIEHGjOeGwYD7tv1fLBIph4TbssgPq80lNDTle9l2+OVJTSVw1
 B1T1etoayWtHirTySHuX5Wf5XRiBjlTq42w2txnKlR0F8eXnBMEmij0sQ3W5M0qwQ+2yo1Csa3nJv6
 mgjRQuOFdeLP4UP106FkcK1amv5XFD+aUuKgBBM0NioUfOaWy5FSDJnEjWpQ==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This reverts commit b9296bb41275 ("dt-bindings: crypto: qcom,prng: Add SM8450"),
since the RNG HW on the SM8450 SoC is in fact a True Random Number Generator,
a more appropriate compatible should be instead as reported at [1].

[1] https://lore.kernel.org/all/20230818161720.3644424-1-quic_omprsing@quicinc.com/

Suggested-by: ￼Om Prakash Singh <quic_omprsing@quicinc.com>
Suggested-by: ￼Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .../devicetree/bindings/crypto/qcom,prng.yaml      | 24 +++++-----------------
 1 file changed, 5 insertions(+), 19 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 36b0ebd9a44b..bb42f4588b40 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -11,13 +11,9 @@ maintainers:
 
 properties:
   compatible:
-    oneOf:
-      - enum:
-          - qcom,prng  # 8916 etc.
-          - qcom,prng-ee  # 8996 and later using EE
-      - items:
-          - const: qcom,sm8450-prng-ee
-          - const: qcom,prng-ee
+    enum:
+      - qcom,prng  # 8916 etc.
+      - qcom,prng-ee  # 8996 and later using EE
 
   reg:
     maxItems: 1
@@ -32,18 +28,8 @@ properties:
 required:
   - compatible
   - reg
-
-allOf:
-  - if:
-      not:
-        properties:
-          compatible:
-            contains:
-              const: qcom,sm8450-prng-ee
-    then:
-      required:
-        - clocks
-        - clock-names
+  - clocks
+  - clock-names
 
 additionalProperties: false
 

-- 
2.34.1

