Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D40CC83F1C
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Aug 2023 08:06:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjH1IGB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 28 Aug 2023 04:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjH1IF1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 28 Aug 2023 04:05:27 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C4C19A
        for <linux-crypto@vger.kernel.org>; Mon, 28 Aug 2023 01:05:18 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-400a087b0bfso27142445e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 28 Aug 2023 01:05:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693209916; x=1693814716;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jcJHgFgYDewzQeLfgbs/yTVfroArC4TDUHuKO6mgULQ=;
        b=SNji06kuB79F6g/2I+gI1f7jVJ8GH344XmqKZSS0ul+d1dzA4T3MSNbQFL8mmCwCzl
         lMDrrYSSCjgH6Ie4xP4eKZcnYkPuUMgGGeV2OMg7+bXcouQ8Fi/dF5AKQWHSTZcIE8iW
         VgxzW5etDfe4gujUQsPWbYCioC7D1/Q9PLE8f+05928h1iQTP9gQ7MXztjuVhk8VTgLp
         kKurEwaHnA2xmqtoKRhWU9XH8rDwRJ6KFqx56NBgFWKdwHF7PSQgIEOxOLhT/uCnJx/l
         pZd19FJcFuMyYL88/1nT7RyaXEbTfwmevTXXgYXYPkptLlx0TesfD2EXPrucKuRR48ZL
         ZOvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693209916; x=1693814716;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jcJHgFgYDewzQeLfgbs/yTVfroArC4TDUHuKO6mgULQ=;
        b=JHVYGEsopnwESQtn/JqioA/YvxivODUQDJhGlKn3CUVoJLKJc68cHcQuagyT4TNLpU
         aFy7w8vj/xdczGk1Mv+2LkK7holQIqfvGIEaQNTB2NO7YBFAa+T6eyQtULNnov7UwYte
         8KU13E46MxVShUGUhmhEUGq7E4ehPeumorjO9N3VPhVvRhTxvYxO/rvSPs1HySc0kxbT
         gNGKiKqSX8HdUdQCViR5WqLbMbXdlEgbnSNt0CV8bau7DHn2DGN9fEMgKo4/qOiz3ueh
         vxNw7DpzV6mlpTVrWb2CtSz/Sc/CHzc6D9Jgr0cMJZ+tvaV42rLJWFtDVsw0wa/Vbq0W
         6HGA==
X-Gm-Message-State: AOJu0YyM3HzRj+47bmd/JUVmuiaJ+MD581kMJXVBgpU03eSSB7k/1skj
        e1F+ecCHTbdglxRkdIbF6OQhcA==
X-Google-Smtp-Source: AGHT+IHCt/KBwhBQ3cRI9ZoVaRqCQH/srZduwESxXqKbw05/f2F5tKqn1mWsuhuR8IizllsDWudxiA==
X-Received: by 2002:a05:600c:22c2:b0:401:8225:14ee with SMTP id 2-20020a05600c22c200b00401822514eemr8201975wmg.41.1693209916631;
        Mon, 28 Aug 2023 01:05:16 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id z16-20020a1c4c10000000b003fa96fe2bd9sm13067035wmf.22.2023.08.28.01.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Aug 2023 01:05:16 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Mon, 28 Aug 2023 10:04:37 +0200
Subject: [PATCH v3 2/6] dt-bindings: crypto: qcom,prng: document that RNG
 on SM8450 is a TRNG
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230828-topic-sm8550-rng-v3-2-7a0678ca7988@linaro.org>
References: <20230828-topic-sm8550-rng-v3-0-7a0678ca7988@linaro.org>
In-Reply-To: <20230828-topic-sm8550-rng-v3-0-7a0678ca7988@linaro.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1726;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=oyHHvoyjVGzfw+imVp+8l3wkxtuE13JPRUzRZMaaQgg=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBk7FU3j9zdwg/R70J1QLWQN8EWkqHnWnsleTE/ZJCh
 eLzrRH2JAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZOxVNwAKCRB33NvayMhJ0Tg4EA
 DOsj2snQpFxhVjM32ZfVuHL643ms3DLSayg6tFbs1v6TI80qo81rCSks9MrjCCq7J/GNIeC/90usH/
 mm10M5I0McfbvJugqVuHVCSEnpfQe7Jp1deWyWx9vr7Dp+e4TdRmDYj2fC/0zllKcn1lo1bp9ekkGo
 fYYKaDfcj1ZZBe+fYFUSUY4v2+yJDO9IZ3ocToxlWyUbpr9jv+oYttlp7v7PWeKQQNmMoBAsytINYN
 qB4KJK9fdeKUjb2MhGGFXfFYFXOqw8rRQBUW8JlRz7RBxrhnoNt+8nnJXsxckgGEu5rsCO4qq4CX9U
 oaO2IwNx12GUWvpT7JuBon+lT8ssSfEY0e8ez4egyTlDjUVyKWM9E+BlC4+L13hvW3hJ1PZBweYw8t
 kTfQc3yEtxgNJX3lw6ovwFjcyK2blcz1W8haadWr8ieZUKoZ2yZ483BVVWnwXc2+BifR6+uou0o4DR
 v10WbPkRDuladaYzQ0kJ1sKoYZOPlWfVokcC0vjPC6k04DZcWiTDI7u2/k3+t8oTUOm1N9YuFMdYn0
 sggiBPFOD1a+xN5ZbBtDFdwrIKziPx6rvWEb42t0HtbJg5KbTdQW1pKQGLgZANwnbOyDrmsgl9CHhZ
 yGgjiZhgbsEsiTPmZeKavgcNNGobXwIfpZ6HdyIk4nkz7UQyS7X/WjJIhg9Q==
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
 .../devicetree/bindings/crypto/qcom,prng.yaml      | 24 +++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index bb42f4588b40..4245c9e424a3 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -11,9 +11,13 @@ maintainers:
 
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
+          - const: qcom,sm8450-trng
+          - const: qcom,trng
 
   reg:
     maxItems: 1
@@ -28,8 +32,18 @@ properties:
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

