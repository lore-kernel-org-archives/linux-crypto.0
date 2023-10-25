Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C94C0032E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 07:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjJYH2a (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 03:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbjJYH23 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 03:28:29 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E15DE
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 00:28:26 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-4083f613272so44979505e9.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 00:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698218905; x=1698823705; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=JJ2oRpaoJhce9I8GPs6HN/A2iLP6BscGnxopX3PgLBM=;
        b=RMfAAfulNGvcxjip3liXEbYW6VGMPpYhK0i00RfK4zZCK2Kxo1E8L5r007nG+t43Ig
         ZaP9QFFJ3BGlfXEEmA28ckUpebTbOvdwYb77rWLgIYywx26DaM+6hiYP+gI6LOHf7oK3
         kYBR/ynzHFeZqoPrywRXIBgKrRn/Y37dsaGEj9LspbRdXhh0KdQGAdShtVfu+dMLnH6J
         JJGNy8wIxtbut+BErM0XWn8E3OfOz3Hw/xfGN8NhzGzmJdSntLoPTTVXKOte6o8APvtF
         KyVetCh5wcLze81nvSBmwnfaYs6dQgvkGHkxe7Xk7l5Z5uhwYQkzf4o8kyVdJ/RcayXr
         em7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698218905; x=1698823705;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JJ2oRpaoJhce9I8GPs6HN/A2iLP6BscGnxopX3PgLBM=;
        b=WGLmRRc6B2A2DOSHqbeYatw2q0Fype1/JBBbk78GBn//3VP4F5jgU1nXizXXuGj7Tj
         UAlrjHEC/4zLVpzNzC5UXdYnIW3UXiLtitIeQBsGQT0cX1rIoBA0KZWRJyPHUDABzQLl
         R79OB31Ak/WA4Cj9LeoIbp6dQkR+F8VIqz2/+deemVGagvgPJeJOEJOBH4erxT3dlK/k
         noKrD1twSY7GHW134wy8Us25tqOGqAzxd3lx8DE41/Bp+jotVMuEMu1AXH9Vx5PwPQSo
         0TmvhKrgffb5jbsxMcdA5PlRATQa6Rdyrt/ibWsE79Qvwy1CXPMF9uR/RVL7QjAwqhbV
         /9Mg==
X-Gm-Message-State: AOJu0Yy/rM5A8Olzgwl87vMgLyA2L1OPlqycgDzsn/pm1nEC9zuhrwJu
        Qj7sIHqvecSBgvcXURqzbT0e4Q==
X-Google-Smtp-Source: AGHT+IFor3h+dAr5oQsSJ1vHc/MU2j9muM4tBS5eoWssbySl5NgMcsBNmIBjd7BJk1YIpCgKCjIEkg==
X-Received: by 2002:a05:600c:198a:b0:3fb:a0fc:1ba1 with SMTP id t10-20020a05600c198a00b003fba0fc1ba1mr11964689wmq.35.1698218904902;
        Wed, 25 Oct 2023 00:28:24 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id r9-20020a05600c320900b0040644e699a0sm18495839wmp.45.2023.10.25.00.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 00:28:24 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Wed, 25 Oct 2023 09:28:22 +0200
Subject: [PATCH] dt-bindings: crypto: qcom-qce: document the SM8650 crypto
 engine
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231025-topic-sm8650-upstream-bindings-qce-v1-1-7e30dba20dbf@linaro.org>
X-B4-Tracking: v=1; b=H4sIAJXDOGUC/x3NMQ6DMAxA0asgz7WUUBGqXqXqYBwXPBDSGBAS4
 u6NOr7l/xNMiorBszmhyK6mS6rwtwZ4ojQKaqyG1rV373zAdcnKaPMjdA63bGsRmnHQFDWNhl8
 W5EDSS6SOB4IaykU+evwnr/d1/QCZifSUdAAAAA==
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1154;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=BOUjaS/EmVt+3/Odcqx3EdTXwZy8c1+gLrnQRALTOxs=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBlOMOXdANPwSzrGljuoM1hjjOOdVulE+eo81QTVr/y
 j+OOf0iJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZTjDlwAKCRB33NvayMhJ0WqgEA
 CTcnEC2yItqtgysd1O56cU5W92ZUXW86INCYQjp3ThOJ3nLtWb5K2hvzXSBW4ubWFln70So8vEh5LF
 hgZZB3TdAnmNb7NPrSoaCd3U4VpKLEwZwq7VYqMjQFxcONA5s+N1vWw1EM72aml8JRYDAAeFzJJx1c
 vzszHpHFTDRiWP3co7c8NLlSU0WBYemhNCQ+ozyQ9wZU78pVI0Pp2KNE9F3c1D5Zf1Q4XOUJ6LOnq8
 5DmD+pPCnhRKniKxuxPgQ79jJUKJcZvd91B0ICIfvRLke4Skaut7WcBhbN7VHhx+99OXB/rcTVZiS7
 qIBx+l62bWffXp+9lhX+DrOD+3kIRwUvNPQYEl+e+182m53WXwCCgtorWdGXEPISNDAT81evKq983o
 iLkycqxxu3vIPu+Tm2iRvIfSG1PSBrboziwCCZMMANDi8/GVXC2hei9yhSKvIm9YbnzIgYsQtEN6pO
 oF9oCXN/5FL4GOkLZumbu95Np5U1roLXe0796nVvUQJ8Wlb/dXoZ6N0cbx60XiOnGF+i0cjnlbMrKF
 ozKO9GjtX21GBKIo6rWy7X4lBU9GdyISFSFH8rDZp8akS6tUVLHaLzMG+gjd/euckYDPUzbEF5eGLw
 3yV/L+me0mhqnA5imKcj2KN7BFleyf3XTg8u8ipK2TsjFr1uprZjispQgpuw==
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Document the crypto engine on the SM8650 Platform.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
For convenience, a regularly refreshed linux-next based git tree containing
all the SM8650 related work is available at:
https://git.codelinaro.org/neil.armstrong/linux/-/tree/topic/sm85650/upstream/integ
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 8e665d910e6e..eeb8a956d7cb 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -48,6 +48,7 @@ properties:
               - qcom,sm8350-qce
               - qcom,sm8450-qce
               - qcom,sm8550-qce
+              - qcom,sm8650-qce
           - const: qcom,sm8150-qce
           - const: qcom,qce
 

---
base-commit: fe1998aa935b44ef873193c0772c43bce74f17dc
change-id: 20231016-topic-sm8650-upstream-bindings-qce-c6ae7eda5cba

Best regards,
-- 
Neil Armstrong <neil.armstrong@linaro.org>

