Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9497C77B6F
	for <linux-crypto@archiver.kernel.org>; Fri, 31 Mar 2023 16:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjCaQpw (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 31 Mar 2023 12:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbjCaQpP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 31 Mar 2023 12:45:15 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6537F1BF7C
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:44:00 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q102so21008793pjq.3
        for <linux-crypto@vger.kernel.org>; Fri, 31 Mar 2023 09:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680281037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ns2jPDGRWz/czfPYAkU0ANfXA6YC0owDF4gxQpajwV0=;
        b=aiimWe8pF/BriYtPf0PKn2U8465iFm5sNDYnZtgWj5CHvNm9VwbTArsIug5gxQlP2Z
         zrOvSMF/ptx4zOWzyWFjhYBBelyoVbcuPSXKJDcvVJBIkCwTc93woeMh/2IJDI747rDY
         CgzzdnLMZTIfli/q7zcINzyqmQw0eYwPFMxGeHlKfibPQCD9Jf2O8/Skgdg31EvJcEQA
         w1DhYtK2FdKnhkdIYIrP5rJIGrmXrjgxT7oQkr397823VjrmFDUEE2zhzgOLd5nvttcx
         gP/8GfSDhZRnXrNtQuXUIS+k4sL5WFxgURnXeERKDoIbyXQy+Q6eyZ3UKQNibkjGxVxv
         WrnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680281037;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ns2jPDGRWz/czfPYAkU0ANfXA6YC0owDF4gxQpajwV0=;
        b=qGFFpG6yIytdX6/xPh0CThKZkbNgEvDqYUpgDGHc8oiED1FuWtwcK+5eJRzonT4kkK
         ZROU9FVgrE/DRflFjA37rThAwfOnk0ast3jNbPGJU+iKRcpX1mCUDTMmDmml7jIhSY/y
         /2ABztH1x8pBS5sQ0y93hSMV23mjZYhpxsXyO5QL+RGFUirj7eaMw8u+DDJqIkRinoqv
         JotSsHgV8i1GAeIj+cjtyAvb+HAeMs6dUem6gz9/vR4x1BSyCViNZlNVumKgfyU/FlJe
         cdBPgZnCJ2mLiETbX5eYEbInP9dMY0e8S0BYjnFuUNuywoWq12mrqyUnEqBpGst5X53Y
         ++fQ==
X-Gm-Message-State: AAQBX9d+PwGFLeC1ZH4clk+FmvA7L5/vU1aH87A/aKMhdBd50BbSUfr4
        PIwbJZlxk2GaHwt/1fFKQo3/IiCCT9QXPU0i7vo=
X-Google-Smtp-Source: AKy350YBHz2GwuQS2tjXBT1r2+lcPRvkfPSLqAp9Kv6j/d4fJ/dNHxbGwE54Xnj5FtXfG3O9h4F+RQ==
X-Received: by 2002:a17:90b:1bd1:b0:23d:3fbe:2f7 with SMTP id oa17-20020a17090b1bd100b0023d3fbe02f7mr30224030pjb.20.1680281037447;
        Fri, 31 Mar 2023 09:43:57 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:1c5e:53ce:1f39:30a5:d20f:f205])
        by smtp.gmail.com with ESMTPSA id x13-20020a170902b40d00b0019b089bc8d7sm1798767plr.78.2023.03.31.09.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 09:43:57 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v4 05/11] dt-bindings: qcom-qce: Fix compatible combinations for SM8150 and IPQ4019 SoCs
Date:   Fri, 31 Mar 2023 22:13:17 +0530
Message-Id: <20230331164323.729093-6-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
References: <20230331164323.729093-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently the compatible list available in 'qce' dt-bindings does not
support SM8150 and IPQ4019 SoCs directly which may lead to potential
'dtbs_check' error(s).

Fix the same.

Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index e375bd981300..90ddf98a6df9 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -24,6 +24,12 @@ properties:
         deprecated: true
         description: Kept only for ABI backward compatibility
 
+      - items:
+          - enum:
+              - qcom,ipq4019-qce
+              - qcom,sm8150-qce
+          - const: qcom,qce
+
       - items:
           - enum:
               - qcom,ipq6018-qce
-- 
2.38.1

