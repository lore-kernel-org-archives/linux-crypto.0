Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D565AC7619A
	for <linux-crypto@archiver.kernel.org>; Sun,  2 Apr 2023 10:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230504AbjDBKIR (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 2 Apr 2023 06:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbjDBKIB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 2 Apr 2023 06:08:01 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D2901BF79
        for <linux-crypto@vger.kernel.org>; Sun,  2 Apr 2023 03:07:43 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id ix20so25406521plb.3
        for <linux-crypto@vger.kernel.org>; Sun, 02 Apr 2023 03:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680430062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ns2jPDGRWz/czfPYAkU0ANfXA6YC0owDF4gxQpajwV0=;
        b=xfXgK3qPqZv33ZCRsFAI/dxIgHUBk9UciMyK4AAaL6NGWvIdyrYKpTCVICXpcDv9o3
         baL8j22lLNyKQiPAy+yANoGY8BSSTtOY8827aoXHZyDiIzA08bSoa3+xWVPMzbnuGNkr
         M14F19AzW3sgpDsoaORTkJIFRAHZmI/QXKC91ohoH4UHGY0sqW6Pdk3FjHsBBloLTuls
         eKya/6fDGno2nm+k6HyZJuZ7A8YMiIXRbQcah0U6oZPrRPVbqRq+ZKXhvkP9T4veU1Ji
         Rthu7TQnhnmXEsfeNEVcKaNQBoRcm5F/S5iTOJ6MgjxmjUb8D6PWVJqLrHUo/BM9NEdz
         RbIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680430062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ns2jPDGRWz/czfPYAkU0ANfXA6YC0owDF4gxQpajwV0=;
        b=A75T09lqKhU7qzYHEJDflnVl0IgGe/MJepL3DobJriCLA0qO0kS2eluwWX4I1DxKzf
         kcqLLolp2ijH9Kl0TpK6HEs4lFtCboPMAVhAa15FE7aI4rpeVZzrWIEmuSfN2zeP/7Qd
         b9ptuPEjb50aQXWZoSx61y4EZ+aa6Q3PreauVwdXdgmpRHHg5mQY+R0x8r54UPfw77kj
         LEwwGfZ3A40xhaTgtdQzBrNAGZj67HdjQ9guI4Q/FNlyIBrVxeY0pMe2we7eJBZY3EIe
         UTPaNV7V5UTfTRExBJov27wfHWMkxA4mTGDKoYbfBBTw15hV/yhjibTGFfJ1YKMQmb5X
         V3vg==
X-Gm-Message-State: AO0yUKWo7xoyQ3JSSAcVUAoOxnEwesnk0QV9fJI0TH6sTgu4RypPXiU1
        bq8XwdIQTonXlm3Pt6H41xzdIw==
X-Google-Smtp-Source: AK7set8/k+S1+Gow66T1mn6KMnnFC34t1zsT+r597uKySIZ9JC0a1EiCunte3PoH8IdvJ/jWFfAs9A==
X-Received: by 2002:a05:6a20:4ca8:b0:db:7382:cdd4 with SMTP id fq40-20020a056a204ca800b000db7382cdd4mr27445442pzb.6.1680430062097;
        Sun, 02 Apr 2023 03:07:42 -0700 (PDT)
Received: from localhost.localdomain ([223.233.66.184])
        by smtp.gmail.com with ESMTPSA id a26-20020a62bd1a000000b0062dba4e4706sm4788739pff.191.2023.04.02.03.07.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Apr 2023 03:07:41 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org
Cc:     agross@kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org, andersson@kernel.org,
        bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        krzysztof.kozlowski@linaro.org, robh+dt@kernel.org,
        konrad.dybcio@linaro.org, vladimir.zapolskiy@linaro.org,
        rfoss@kernel.org, neil.armstrong@linaro.org
Subject: [PATCH v5 05/11] dt-bindings: qcom-qce: Fix compatible combinations for SM8150 and IPQ4019 SoCs
Date:   Sun,  2 Apr 2023 15:35:03 +0530
Message-Id: <20230402100509.1154220-6-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
References: <20230402100509.1154220-1-bhupesh.sharma@linaro.org>
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

