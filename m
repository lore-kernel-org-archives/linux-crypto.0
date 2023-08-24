Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1E0CEE49BC
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Aug 2023 11:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241027AbjHXLeA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241040AbjHXLdk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Aug 2023 07:33:40 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0460419AC
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 04:33:38 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3fef4b063a7so32806495e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 24 Aug 2023 04:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692876816; x=1693481616;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ijL9XhwjGXgvTsziQU1R0Sp8EVefJrVWDew+ILjeQSQ=;
        b=iMJdQlCNmWcU3CD97Rf6JU8z5W97p8+IqbrQlDhM13RINBrFpC56uJWD20HHCWbiT7
         VEBPJB0v1vMaWVWhWSOe9i2oEtgZp9wDUpeICcOi7bAukZAWh6ReQZ8wzxdogFpTEIk4
         lv+qvKyd/GK8Fu1NEm4U1QbD1q6wr9l6wioRtNl7it2hCVltRVUtWLXQ3IdFr4g3n2Pm
         tk0c+37iqGy28JYQOPGbHLU61Um3Ouz5W6hAbIUdlIQrCkS4K6f4C9vn2fQ1AA/d7tZD
         mqmMAIsOpwhx2JYguIal7FxLaI3rmjYiw0QsqILibFSAoPYmpZO7/l/IpojJyR7kRQKK
         iJFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692876816; x=1693481616;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ijL9XhwjGXgvTsziQU1R0Sp8EVefJrVWDew+ILjeQSQ=;
        b=PwuIhummhZqGbthiGobXigon0RL6tNAVaM9D5zaVSeCP9BTPYyk1k+YFQk0VfjAozf
         xUNyFRSMajs2WVHwmbmf54B7V5GuXXuc/+sPN+H/8086QPZZJ852F1WwLoyScfMvSHl5
         0bTr4Nu7tv4xvmXJfNdxYw+rkGfPKo+6h7dH1RY4FUg8fI2trEX4FBBqxVuPTZYGV1XT
         OONz+SvrKhVlRp6pWGmJkubHysc0eUAA2Qe0JjVSiNkW8Wqq/sXoQCum0qX4Vr6QIEZ4
         XpW7tD/54AW0t/M8MGfHPkw7nVUR1vX+E0FQsxt3BaXIIh/81aI8HvxoY9ji5Osv6SxY
         50oQ==
X-Gm-Message-State: AOJu0YyHUPS1FzOyfHhK9hHOQZY2NeZvwWXq5LG+WrfyeP7fZLHMfAxk
        iDR+XMJxjBSUh1i0c0KVpfQnEp3M8PpBfTKtjzBT8cVz
X-Google-Smtp-Source: AGHT+IGG8oNcZ7PNzYH79eqZ9d04xNwDLH2FikclwMSWDu0S2fyqA6VpVAlcFGLik7H8W8dly+XjdA==
X-Received: by 2002:adf:e601:0:b0:31a:ea9a:b602 with SMTP id p1-20020adfe601000000b0031aea9ab602mr11098109wrm.1.1692876816537;
        Thu, 24 Aug 2023 04:33:36 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:8261:5fff:fe11:bdda])
        by smtp.gmail.com with ESMTPSA id e11-20020a5d65cb000000b003179d7ed4f3sm22063938wrw.12.2023.08.24.04.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 04:33:36 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Thu, 24 Aug 2023 13:33:24 +0200
Subject: [PATCH v2 5/7] dt-bindings: crypto: qcom,prng: document SM8550
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230824-topic-sm8550-rng-v2-5-dfcafbb16a3e@linaro.org>
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
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=870;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=ICXotOUiTdh5yjHcK9RlGWMhy0USQET7mt90sU485TY=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBk50AIud6LxUXIggA7N47tLDhf4/3Qgaw3POkNWrrb
 PEfr69OJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZOdACAAKCRB33NvayMhJ0fI7EA
 CsYFJIthQE/UJ3/C+CL06/Y+7Xg4P0ykAaPXPvxSYmA6hREwCcGNREB/udwl69waRFAG/hHnLKYb2Z
 Cr2UTTBTBGFUCLs+hvYbgXhhkVYRW8L+SvEnlDjy79P030fyK4H1yZ3i8QWv7S+oiapiX9vyyZQihY
 5aych1befV9pXMZO9zflpHL2Hd6lIzebocakACS9atnldHkVJBrN47stdAhlRkrbIcvIDtUYNvRh5X
 NMF57oBl31Sj6JiMXLGJws26j9nou0iw5ASjyHRIH7IKzFiN3Sr4DdYFlWi0T6z7kXBiHT1s4SfEf6
 fpOfoMivg3vkSpIn9frvRNvkxvl7uMKIMh9bPoFAXAxXQTR5fxV5MzDv0kjRGtEYsN1Xk6jF7iBS3D
 BxRz5iHHHRrdNp/u5jZzjY8cSu8HQJTST+PHYHOSgLrFbH4i8ZeI0MSfPTo881EZ1xCCIqlZ2UCTlK
 FiMnY/D7Zx60aGD0fgZ4V9X+MxfCwt+hQKgdV3s8z1LA9sB90lHxKc8H6i7wxIHleFXElNnID44F48
 ejr4WNampBZABp1T1PrptIbFEKbYl6q2fAndj3Bk0dgGUmwI+8p8cCewJZytqO+PYF7iZ8xSKfQGwc
 glAJOn4f+xoL937fGnbgFA/eofRU7zBbTD4qV2wTZM9jC/MKResTiD9BaR5A==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Document SM8550 compatible for the True Random Number Generator.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
index 4245c9e424a3..633993f801c6 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
@@ -16,7 +16,9 @@ properties:
           - qcom,prng  # 8916 etc.
           - qcom,prng-ee  # 8996 and later using EE
       - items:
-          - const: qcom,sm8450-trng
+          - enum:
+              - qcom,sm8450-trng
+              - qcom,sm8550-trng
           - const: qcom,trng
 
   reg:

-- 
2.34.1

