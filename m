Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5AEFEDEC7D
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Sep 2023 15:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjIMPfo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Sep 2023 11:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjIMPfm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Sep 2023 11:35:42 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B4093
        for <linux-crypto@vger.kernel.org>; Wed, 13 Sep 2023 08:35:37 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-401b3ea0656so73679745e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 13 Sep 2023 08:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694619336; x=1695224136; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IqhDGN0q1K8XUZqE/r9ClfBnQGg9OFu7r8WfZswLLwk=;
        b=Nd/ji+w6Uejw67NqZe1tD+fMWa/1Fke6CRX5J0j01X0fAKZO0MT188A3QvSWlYAoiN
         Bcms5g/W4xnYinPUZs246Gb4qPt8c1ybmmen90fQF/ojCJ2T+m67OfqCFUfy6/BHWFXM
         Iqc02xiQHMYQ+nXYxKM3p2DOA+dGx3OfsJzXmbhtR1hEl+muEuXwy+azHqj4UNjtegVl
         /ECKbs1GNQ2pN8YkG6agczIqwtAhWHnTL1pQBrmVGiteskyNUjy93Y5JgAn4fimfm5Ro
         NzHPCJXhFxLmnXho2xilvDchj/nJaZQl5WhwExrV58kzemWfrYscn4Ub1Fk4kXVxZN0h
         HWTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694619336; x=1695224136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IqhDGN0q1K8XUZqE/r9ClfBnQGg9OFu7r8WfZswLLwk=;
        b=sMhiP1fd+Layj+jIwjoCwitVUIrOZUkoVLjL/a77ycAOxKywtfT8cPhhTgGgN2u2Oc
         PQEOI9ZbDwMkU3GEXmmDY4sP87YFy/K7gFfvH6lg/t4mTDBg/FL1BGR+CnvaX3bL+/j+
         6zfE6RVOFJr8bhLDzMbE1u4kuoK6jdnYkAxYA2U7C83qv00lYuZdE0Mas4BzxNW/MYHx
         e0wOcSsbHR79Uy7zGPyNWwSkGtD6mC8VD1D91yxMvb+prRqdXLak23site2O1RPB4tqD
         4OQKeK5QV2A4FVXPA1G1vhgWw9wqCDS74joNPMVveo/IKe857lDg6fgtjAC9ull7i16q
         uDHw==
X-Gm-Message-State: AOJu0Yy/mmKOzi55z1HTSkgux8FO4g9DgewZrQnawD9vSOfgzeZQJEXF
        IZAA6xfkHeokV3Qn94J+idEiBw==
X-Google-Smtp-Source: AGHT+IEcxLrH+tnCBz0k0JsdV60yzkYS5v2M+TY2eCeNR9XmfWCK8lMQcqp+jXnOF22JfEoEY3riwA==
X-Received: by 2002:adf:f8cb:0:b0:314:3b1f:8ea2 with SMTP id f11-20020adff8cb000000b003143b1f8ea2mr2526999wrq.6.1694619336162;
        Wed, 13 Sep 2023 08:35:36 -0700 (PDT)
Received: from brgl-uxlite.home ([2a01:cb1d:334:ac00:3b50:bca5:a754:7463])
        by smtp.gmail.com with ESMTPSA id e11-20020adffc4b000000b0031f65cdd271sm15750315wrs.100.2023.09.13.08.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Sep 2023 08:35:35 -0700 (PDT)
From:   Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Conor Dooley <conor+dt@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: [PATCH 1/2] dt-bindings: crypto: ice: document the sa8775p inline crypto engine
Date:   Wed, 13 Sep 2023 17:35:28 +0200
Message-Id: <20230913153529.32777-1-bartosz.golaszewski@linaro.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add the compatible string for QCom ICE on sa8775p SoCs.

Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
---
 .../devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml    | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
index 7da9aa82d837..ca4f7d1cefaa 100644
--- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
@@ -13,6 +13,7 @@ properties:
   compatible:
     items:
       - enum:
+          - qcom,sa8775p-inline-crypto-engine
           - qcom,sm8450-inline-crypto-engine
           - qcom,sm8550-inline-crypto-engine
       - const: qcom,inline-crypto-engine
-- 
2.39.2

