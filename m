Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF83AC0032E
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Oct 2023 07:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbjJYH0e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Oct 2023 03:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232777AbjJYH0c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Oct 2023 03:26:32 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6250E5
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 00:26:29 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-32dc9ff4a8fso3581362f8f.1
        for <linux-crypto@vger.kernel.org>; Wed, 25 Oct 2023 00:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698218788; x=1698823588; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hFZGMkXUg4RTKKDxNnBfB5PKNPaqSYkfEF3TgYKEoFE=;
        b=PxR5KsL5G6sQqeZs/iXOJFgyShru7+b9idlmaBNMMMJNFze37Rcu7CnK5ohBGcmPvH
         cWBvr9aLTBZCpqE0gHEaxdG/IlLhd1aJzpKdckikDOjd/jM4bJNc+kfmFlkiSR4hG6Iz
         srdNSSSf4g6hHUfg+PyXwv0dUwfUygfpQpRUhlFUTN593VwpWiSHDJEb+ZRmpxymgH0J
         6vfRZzWKP3/9TnlJRvmzmdh0wQF5XG8PGHv9LGSqeyG8vZ+Bd3ueLf+aUcvl+tA7upFu
         GznmadL0WCsJ8CKLS0PXvFqnK07QhM/kY38B1zAE/YFokQbdL7W7VB30z9DwqwulrGP7
         NjMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698218788; x=1698823588;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hFZGMkXUg4RTKKDxNnBfB5PKNPaqSYkfEF3TgYKEoFE=;
        b=s0QcF+tPeagkviL1TFbnUmrP0f0WiI1IHFNwI52V/qcMAZmyXN3hrzePgL5f2iyqxF
         f//8cQP/LSLhkONwTNPr+6hC8ojX4H8xo3o0WGglbVfkyWjYKukoOe+SKQAhY+9mLm0x
         Bb+x+acjblBdmjQT7ySSyyCv94ta/ydsKW+VyOfcSBDBsMsWYXNxzsxAez1ieHIP5tYh
         sL97Yf+7WSqOfad1rYwBH2Qhz10OR/nFuo6koD76wt7bKuRYMddastF7BPXqujGIFIKz
         jfb1j2XNZvoqVRupeMZIbPMYWSMS2OTqKImqezIUBTR8hUC/3qUiSzBiDi/fCXXSK/cC
         C1mA==
X-Gm-Message-State: AOJu0YzhYVJ7yPorj5t7k5nnl1Ji5f0t/ndo5wTXR/iyBw0tkH0KwBm4
        AAtOy1PjMIHTQRcLYYLfjF/sFLQ6Qd+29EW3DgMzsjCI
X-Google-Smtp-Source: AGHT+IHRO7nOAEgsVsc+r3HSZhiKCm6mKMemwUFkJ3Wjf1yZADR53GIsH6Je5vQup/knzzVMXTQ6ew==
X-Received: by 2002:adf:f711:0:b0:32c:eeee:d438 with SMTP id r17-20020adff711000000b0032ceeeed438mr10859100wrp.54.1698218788026;
        Wed, 25 Oct 2023 00:26:28 -0700 (PDT)
Received: from arrakeen.starnux.net ([2a01:e0a:982:cbb0:52eb:f6ff:feb3:451a])
        by smtp.gmail.com with ESMTPSA id o7-20020a056000010700b003232d122dbfsm11387445wrx.66.2023.10.25.00.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Oct 2023 00:26:27 -0700 (PDT)
From:   Neil Armstrong <neil.armstrong@linaro.org>
Date:   Wed, 25 Oct 2023 09:26:26 +0200
Subject: [PATCH] dt-bindings: crypto: qcom,inline-crypto-engine: document
 the SM8650 ICE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231025-topic-sm8650-upstream-bindings-ice-v1-1-6b2bc14e71db@linaro.org>
X-B4-Tracking: v=1; b=H4sIACHDOGUC/x3NQQ6CMBBG4auQWTtJSy2IVyEusEzxX1CaDhoTw
 t1tXH6b9w5SKRCle3NQkQ8UW6qwl4bCa0qLMOZqak3rrLEd71tGYF1vnTf8zroXmVZ+Is1IizK
 CcPR9HHrnrt4NVEO5SMT3Pxkf5/kDJ0uqSXQAAAA=
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
X-Mailer: b4 0.12.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1290;
 i=neil.armstrong@linaro.org; h=from:subject:message-id;
 bh=TfbZhtTr6JCUE3rn7VVswLJ81woB8n7GnmkkjwpPq38=;
 b=owEBbAKT/ZANAwAKAXfc29rIyEnRAcsmYgBlOMMi2B1aswsPGCUOxirWk8lM3fVELV8H80Qpdy74
 26hgTHCJAjIEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCZTjDIgAKCRB33NvayMhJ0ZqvD/
 jr8mzxxVZY0DZIeJ55L1ONGiHuVDZlK41w46fiq5TtOw2kLtEpArHHRBp3iLg4qTC0BVxM2+2bDVjt
 FYRUuGJLLfIBirxrzbAgxjjBucsNZGbWwpoU3qBUwDizKPkOoXAH15Ys29g9FnLfqx09CTjpzjbKhH
 krkG6Ptn1zwjovWLRVJwqG5w5TWoHCE86480oudQqAh5mR9WZiuC1V1tb5xgbn9VkyoS0RNlzg+xSf
 4UJoVismpHV5Gub+GAjDv/lgNgJvf0r9n5u6V146sn0V3BS2u1RoFrcmjv2+sARt9W/Q89uyP1lHfk
 2Ne597Ne/UXJE7T2AIzi2vtq0dBjTFhEcE8awvX6By1gPhshliu1FW8jLC/kIw+QjppRNk+w9minU9
 fRu2gu9fBXE8jIcqJVl1egN+Z8SQjr/LzuQH3dElhAUJCQk0FhfvRXx/3itc+b775MrLUCKZV1rYrp
 z06PvgENLGUn2IsoUC5avwco5Lq6k+dG0Z/wWKfc42mNxxKf1zzOzotA6Vbf5XtHEpQv0xABP3+Lc9
 bgYyVI4hcB9o+EIUsdNj28VncgAyhPb1yg+/EVL6sRJ1FIAhmWzgCXukwLnLMfAaj8hyErj5Eqdpmd
 AMMfkcxyvYfS3N+tiUbJQbEQFVVQBMWfNhvyjJrRMYb8nGKghMTtFyDyPX
X-Developer-Key: i=neil.armstrong@linaro.org; a=openpgp;
 fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Document the Inline Crypto Engine (ICE) on the SM8650 Platform.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
For convenience, a regularly refreshed linux-next based git tree containing
all the SM8650 related work is available at:
https://git.codelinaro.org/neil.armstrong/linux/-/tree/topic/sm85650/upstream/integ
---
 Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index ca4f7d1cefaa..09e43157cc71 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -16,6 +16,7 @@ properties:
           - qcom,sa8775p-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine
+          - qcom,sm8650-inline-crypto-engine
       - const: qcom,inline-crypto-engine
 
   reg:

---
base-commit: fe1998aa935b44ef873193c0772c43bce74f17dc
change-id: 20231016-topic-sm8650-upstream-bindings-ice-f57f97334539

Best regards,
-- 
Neil Armstrong <neil.armstrong@linaro.org>

