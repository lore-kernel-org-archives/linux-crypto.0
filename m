Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E30EE49AF
	for <linux-crypto@archiver.kernel.org>; Tue, 22 Aug 2023 14:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235415AbjHVONg (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 22 Aug 2023 10:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236143AbjHVOMh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2023 10:12:37 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23F8E40
        for <linux-crypto@vger.kernel.org>; Tue, 22 Aug 2023 07:12:12 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3fbd33a57b6so43124455e9.2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Aug 2023 07:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692713490; x=1693318290;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6NuUj1e2uioZdzoL4ZpIuuQFQzc060pGZCFyiXZsTBk=;
        b=hmSFDXgPYiCb848Iaf4vm5HOea1e8nhq5wDEuKLvVOungPI8MXc9KqMdGCX3Khhn+e
         gh752v0OR8OeKkxcBlJvNHARNRuFUETCNPURpjk3o4TPFt+csn8kCEin3QtUHOQ7uM8H
         fDrLb/yxS1X6wp4sZw/pPEQQxbbUmK5mTyGFGf0N1cgBX8WWLBwt1yWzVujCTAvqo/b0
         JpRBw7i45by4LDSYGg9SqVUk8edq6ZtfXMGulaQPPZ84i6IjgDbHEz8Scs65AOf/yC23
         MJyQEA4kTwLd4Gr3CYLSt3wRjQJwZPg9/DbhDOLHVcKBbaQzWkutSwCzuC1x/TTa2P1z
         WMTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692713490; x=1693318290;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6NuUj1e2uioZdzoL4ZpIuuQFQzc060pGZCFyiXZsTBk=;
        b=hvcjZ/qoD3BPAGmTILyiX/FJuxW3n/1YjzQx6/fIueR3fBvaHO+3pSp9d6lk80jFTq
         u9bje3H9My04L+9IQFBpWK8ZH3n6bT5lJp9gLDUGOHqsih89CN8rtJ+jEnjR5sYeiwq9
         MTQYdhsOAMrSvYb1hgUaWOnpT4WrJt44RRgKtHeukrkEfRayn6z+Hdqgxzim71l9sQme
         0pJaETKQJ8WQgn5pidS5xfaIHdGaoeEi4tOoWuKewbembqz4NmxTZ36wM1tZJ4RcgMzy
         2678oID4hqDAcBh4Fq5840iUxH6ThEJslkHNWZMDEPyZBMD0g3+Gfc5JMCP4wBA1gNYk
         lnmQ==
X-Gm-Message-State: AOJu0YwY4rrfLkHjzXNXD9nI1wQyCDlOaenqN5Vjcl99hx7GyTIOQf07
        /3yTWAwZtcBHOIRQgjhhHoqFIA==
X-Google-Smtp-Source: AGHT+IHSy+c6X29/B+uc0h5uygx4Wzt9QiBQiMCP9XwGS7qAxnnPDr1NIbD4u82IyvMT2VjNAwDAQg==
X-Received: by 2002:a1c:7705:0:b0:3fe:f99:1ba with SMTP id t5-20020a1c7705000000b003fe0f9901bamr7743291wmi.2.1692713489933;
        Tue, 22 Aug 2023 07:11:29 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id m9-20020a05600c280900b003fe539b83f2sm19587753wmb.42.2023.08.22.07.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 07:11:29 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Tue, 22 Aug 2023 16:11:24 +0200
Subject: [PATCH 1/2] dt-bindings: crypto: qcom,prng: document SM8550
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230822-topic-sm8550-rng-v1-1-8e10055165d1@linaro.org>
References: <20230822-topic-sm8550-rng-v1-0-8e10055165d1@linaro.org>
In-Reply-To: <20230822-topic-sm8550-rng-v1-0-8e10055165d1@linaro.org>
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
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1240;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=GUYupVDxA6Ws4wGq8QNEeRAKEiaPalNqjgPA42KveaA=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBk5MIPwNRw8LDa2gdB9oBZJxUTJGSl4EtlFfKxpH1O
 EndIqleJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZOTCDwAKCRB33NvayMhJ0eZUD/
 9V+26Wr887xbDjhgG5nDAeMB/FACgZL+/702uRsC5Emz9Hk1q+05LP6cwoEZhUT4m+y6ne3ZMliwYo
 pjgaVeXfKSBlrh0FZfatza7xRKIeD+nOTdFqfph7zPaK8UJV/hh2TW+ppVepEB12iFWZ0pWPvD8R2B
 O+6H8AZd416BFMrbrlqi94YrIx72w16Pgm0V52/mhFVYWgTKR3+J7AYuXSZTSMUzKzQZ8Zf+v9WYtI
 yhY4tEyM4bhxEwzISr4YtDgnMQWpzyoeHireX4p1y1wSJPxEX+pFi/mHpw/7hD/7Z5SrzEhhUDklH2
 j1JKqxPWiFRAgQBOg30vebfOaF3eSCo8ryyQZ75OsKm9RrAbPRkryvtr+V5VMuMcAJX1Os35v0XnDy
 mkYbDVsBnmoQUJqeAKjtlh9X5JlaoN2w//Mv6I4jKd2jOe5vK6UQZiksF5wIQH8+dl36dPZfJm2cve
 POyIHHOHB1G+bHyHy/p4NUk0vDRnWzswVIFKYFka7em+zn8lclW8alDuDtxTZeQrGguXFTB+bdjiOC
 C053Sm8qVZrrc6fsQjqPGICSMHHLOKx88P8YpH+Et9IEpe0gGnbcR+6qN69AH6Fe1rEy9fXHmNWvpZ
 yNiwgnr3XQSiIC/p/W+LkdOFU/fsqoQnv9Lo3wcmtU3vVrWE8tCEcEXGI1WA==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Document SM8550 compatible for Pseudo Random Generator,
like SM8450 doesn't require clocks setup done by the secure
firmware.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 36b0ebd9a44b..60fc9f261b83 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -16,7 +16,9 @@ properties:
           - qcom,prng  # 8916 etc.
           - qcom,prng-ee  # 8996 and later using EE
       - items:
-          - const: qcom,sm8450-prng-ee
+          - enum:
+              - qcom,sm8450-prng-ee
+              - qcom,sm8550-prng-ee
           - const: qcom,prng-ee
 
   reg:
@@ -39,7 +41,9 @@ allOf:
         properties:
           compatible:
             contains:
-              const: qcom,sm8450-prng-ee
+              enum:
+                - qcom,sm8450-prng-ee
+                - qcom,sm8550-prng-ee
     then:
       required:
         - clocks

-- 
2.34.1

