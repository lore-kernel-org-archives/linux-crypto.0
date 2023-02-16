Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15E16C636CC
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Feb 2023 13:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbjBPNPH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Feb 2023 08:15:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjBPNOs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Feb 2023 08:14:48 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BB6D54556
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:42 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id b16so1860565ljr.11
        for <linux-crypto@vger.kernel.org>; Thu, 16 Feb 2023 05:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676553281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81Eg8IFjCVRuU9rYgFIp5x0cgMeqnSHlx3m8knRv6/g=;
        b=Dwkmgshdo6NzKIYZes8ApnQa+Yh1D0umcOevdVwQ7QQezENzIV6yVpvzs7slYPya/v
         WfUsnc+08rvvXuY3qct8anKuGTI+SS7ObuUdC+RkfMtaQBhBFR+wU1WkoA/oXE3fdTkx
         yC2k5HtLReboBqrliRdOUu4oTZ1VMwPfuR1ZbBy73PkNJZZOfVrwA1b2VyxyqP0kgqV7
         1u49LbSwdf0iSQJs9lrA/w7yeB21SVms6/3R7laJnWXnlyrvte8FgKBIeoDbRMQaalrZ
         3Cn+DuIZg4ZwgtbxkVvqjK6rx3yCUjvS30d9Sfj7UR3KZmOs/+zW3NBoyzPR6dZgjd9H
         LQQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676553281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=81Eg8IFjCVRuU9rYgFIp5x0cgMeqnSHlx3m8knRv6/g=;
        b=pmbnkyL08uFFf8qPiwiokqPmrNZc6VmqBbTPs+hlcp+MWmPMxf4ecNuSR7tJYOQ57P
         IkQW+e5oPWbdUD0KynXxiT/e77zS8+4RTtaIeBZUHTeb4Gi6X6v+U/Wg7ThqztSfWrFV
         BJL17IY/NGbz+ztxcR0CP9r2pOQ37uVCZx1jnPj8FEmbxLseIAqYPPqJwO9NVg8thwiH
         u6n+4Sie55qYbxT99zZb6+9ZKqdjYkGKykiWWgQFDfVTFjIlscoxHuGUJ8VFa15ZVEON
         2bC0dKnpdF83WyOrJ3oqODMfpo+9PhVUBUv7FwsgbMY3nB4+HKXAURs7QYWB+Mjr5Hjs
         U/jQ==
X-Gm-Message-State: AO0yUKUwfsGLqroqFC2WCbOEVyuOVWalQq5JUaOJoelS0CCX+OkLkOjB
        8aDVuhVUt0oIP8fJjTHM5pQW8w==
X-Google-Smtp-Source: AK7set/bpqqHcPlTy+9xkFaKoeR/nYQwgkIIJ6ZDZrF1A1xSJuzRRAtH6c7adEGBMN/Hib7G9GSlqw==
X-Received: by 2002:a05:651c:b0c:b0:290:69a9:76ba with SMTP id b12-20020a05651c0b0c00b0029069a976bamr2094642ljr.1.1676553281672;
        Thu, 16 Feb 2023 05:14:41 -0800 (PST)
Received: from localhost.localdomain (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id j8-20020a2e8248000000b00293500280e5sm194345ljh.111.2023.02.16.05.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Feb 2023 05:14:41 -0800 (PST)
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
        linux-crypto@vger.kernel.org,
        Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH v10 06/10] dt-bindings: qcom-qce: document optional clocks and clock-names properties
Date:   Thu, 16 Feb 2023 15:14:26 +0200
Message-Id: <20230216131430.3107308-7-vladimir.zapolskiy@linaro.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
References: <20230216131430.3107308-1-vladimir.zapolskiy@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On newer Qualcomm SoCs the crypto engine clocks are enabled by default
by security firmware. To drop clocks and clock-names from the list of
required properties use 'qcom,sm8150-qce' compatible name.

The change is based on Neil Armstrong's observation and an original change.

Cc: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
---
 .../devicetree/bindings/crypto/qcom-qce.yaml    | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index 84f57f44bb71..e375bd981300 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -81,11 +81,24 @@ properties:
       - const: rx
       - const: tx
 
+allOf:
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - qcom,crypto-v5.1
+              - qcom,crypto-v5.4
+              - qcom,ipq4019-qce
+
+    then:
+      required:
+        - clocks
+        - clock-names
+
 required:
   - compatible
   - reg
-  - clocks
-  - clock-names
   - dmas
   - dma-names
 
-- 
2.33.0

