Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68282C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 10:57:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5546E610A1
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Oct 2021 10:57:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhJMK7l (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Oct 2021 06:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231825AbhJMK65 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Oct 2021 06:58:57 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410B0C0613E5
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:56:32 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id t15so2070258pfl.13
        for <linux-crypto@vger.kernel.org>; Wed, 13 Oct 2021 03:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yng5eTw4n0HbKQV0Xcv/zVYYMU50wsVq8rLsKT3wyb8=;
        b=szAdfCtZjTXtVtUeM38ldIve5EF5/0Br7s8W9cXxA9prF7ZYrNeqv8KbrhJPl0wM1o
         gU5pe2tTYCljGIJIf2d6lDfa8pYlMCM3WwHPA0McScpbpHJMLI/cne7dylw83Q5brGiv
         Liqx0mwINVuSCL+UM0cunoJgEackJehBKyGEs4czcLlSkn9lwfBAAuY2LkenjkpEha5o
         xsEdKmkLs/vzHhVPRvvjYR7yWUvBBN8vEEZ6lPYZoZwwWFzFtmzKsSdQ5Q++auOH4/wj
         3nlH7ULPuPiAKzy0LLxS0CHvWfYTM5lfmC1AlM6J42a1a7m9eCIeqBpT8bGNirAMb+SH
         AHrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yng5eTw4n0HbKQV0Xcv/zVYYMU50wsVq8rLsKT3wyb8=;
        b=HuhF1HY5DFhWycxEzvr0aNgBMKoQH/XVuVjTdwDwVbLXON5Gyo7Z3lXUMq+Dq7FBiH
         9zTcC4XM8qPwiD5Rf1MNHSOH3hDgSCgmT9fJVfDxoYTtzSpyBBWqQpskr2dEkj3Pkf42
         PMk8yIw5UTjGkromUsthvgEuSJgEhO8RU8emKQ+PaAH5VDoVG16q1fUJb8scsXsSiBM8
         viutD2HrPoRbocvUvfhXuH9EF80qN44XodBQcJYXSTDrAlzlPRd26PIrk6z6v5MAqGB6
         yRvXcz7uSi82oYBHM4sKOxcjRKY8Op3gGWf9srUrZ/lEX32N1Q42FNfVNfsupOxCGgPi
         8t2w==
X-Gm-Message-State: AOAM531RupDtydujCHnPvZHVIzT/O1KaQafY+EDYbBtHgfSyKnWayXvZ
        h4yWJjSVDD76mg8nW/tl/9cTcw==
X-Google-Smtp-Source: ABdhPJwYqosT/5ArpzWpSNWo3I/WZjXdW4f7C8zC1FkxtUmdTuVDdpIyEmleWaacjSPv08d4vT6Fog==
X-Received: by 2002:aa7:81c7:0:b0:44c:517f:a759 with SMTP id c7-20020aa781c7000000b0044c517fa759mr36699311pfn.3.1634122592461;
        Wed, 13 Oct 2021 03:56:32 -0700 (PDT)
Received: from localhost.name ([122.161.48.68])
        by smtp.gmail.com with ESMTPSA id b13sm6155351pjl.15.2021.10.13.03.56.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:56:32 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, herbert@gondor.apana.org.au,
        davem@davemloft.net, Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH v4 08/20] dt-bindings: qcom-qce: Add 'interconnects' and move 'clocks' to optional properties
Date:   Wed, 13 Oct 2021 16:25:29 +0530
Message-Id: <20211013105541.68045-9-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
References: <20211013105541.68045-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add 'interconnects' and 'interconnect-names' as optional properties
to the device-tree binding documentation for qcom crypto IP.

These properties describe the interconnect path between crypto and main
memory and the interconnect type respectively.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.yaml | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
index b7ae873dc943..954f762090f3 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.yaml
@@ -32,6 +32,14 @@ properties:
       - const: bus
       - const: core
 
+  interconnects:
+    maxItems: 1
+    description: |
+      Interconnect path between qce crypto and main memory.
+
+  interconnect-names:
+    const: memory
+
   dmas:
     items:
       - description: DMA specifiers for tx dma channel.
@@ -45,8 +53,6 @@ properties:
 required:
   - compatible
   - reg
-  - clocks
-  - clock-names
   - dmas
   - dma-names
 
-- 
2.31.1

