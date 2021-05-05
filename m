Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4C4FC433ED
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:38:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1364613EB
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:38:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbhEEVji (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 17:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234076AbhEEVjf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 17:39:35 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02EAC06174A
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 14:38:37 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id v191so3056075pfc.8
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 14:38:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Hn7TfYIdfqD0Oz8Zkvw4koFjDOZwR1ktbKdET4xonRI=;
        b=kg1P1d40yTtEG4b3W3pZCw8Z/F3EGVZYk24xAubD+8ctiTWheYqABJrrsBfj7b8QNC
         VLMdYpk/Xq2C+BmQjZZoV5XT+RYkwAnJ0DoGA7kTRFOdSNXPB9+N2BswsCHYzxmyvC1y
         iKVV9h5oh9MmQjOh9Qow75M3NqetBTOo7XvvITALJY3Gu4QBXVG/cuxvnQTFqYtdxRjr
         +LnMZDvo2ragoamp23py2/wnW/1gCtaW+DpgUGttqzDklozot8WODqF6lMjEFrF6rgo4
         nqsOtBrWDGy+6Qi7f/4Pv2kqBQpIn0I6ZwV1j8ifAyE/nAYjhwac3inN1P7Od66lpBma
         k9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Hn7TfYIdfqD0Oz8Zkvw4koFjDOZwR1ktbKdET4xonRI=;
        b=NbKVWEy2bnjiqj9u8+xUOJznTrruX937iKpxL3GDe8tr74LWmVtMUB30jO1pEdAQFr
         IgyyLgBE+pmMoxf6Z7WG4kuCqNkZ6wtdipWt7KifyiLjSASfB6RaE64HanL8oq75Rmfi
         dL1WvSZK5lQzxDxJCX/BJ5/R8N1gxl1sJGcpWX972+vbodbhgM/blvQmZdAjdH01Xyxj
         XkYeo1q2pn9zNpup2ywgjIi4FYvSwodLqIbv7r6/UKb8BpWdguEl3sSgxyPGRR0zcmUp
         y6lPyaLYcJZ6JRHWLbKMeaYulHN9G3xRrITEOXUKw/FZ1riCea9AcHJXzK4VXjvx4wrb
         kR/w==
X-Gm-Message-State: AOAM530hcEuMjyQv/snHvy1udf4ZrLRcAVI6W5KBkzz18SthuCHTe2jP
        T/znqtM9PDH4biVPwwBdWFcRAg==
X-Google-Smtp-Source: ABdhPJxkph90MEwZINVgDmvXeuVMnLzlhhibn3dL5GYQ3RA2vgrMKUt4MMM7ty3BO5rfnnZpSNin+w==
X-Received: by 2002:a63:4c55:: with SMTP id m21mr923423pgl.251.1620250717194;
        Wed, 05 May 2021 14:38:37 -0700 (PDT)
Received: from localhost.localdomain.name ([223.235.141.68])
        by smtp.gmail.com with ESMTPSA id z26sm167031pfq.86.2021.05.05.14.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:38:36 -0700 (PDT)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Stephen Boyd <sboyd@kernel.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Vinod Koul <vkoul@kernel.org>, dmaengine@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Subject: [PATCH v2 06/17] dt-bindings: crypto : Add new compatible strings for qcom-qce
Date:   Thu,  6 May 2021 03:07:20 +0530
Message-Id: <20210505213731.538612-7-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
References: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Newer qcom chips support newer versions of the qce crypto IP, so add
soc specific compatible strings for qcom-qce instead of using crypto
IP version specific ones.

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: Vinod Koul <vkoul@kernel.org>
Cc: dmaengine@vger.kernel.org
Cc: linux-clk@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: bhupesh.linux@gmail.com
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 Documentation/devicetree/bindings/crypto/qcom-qce.txt | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/crypto/qcom-qce.txt b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
index 3f70cee1a491..814fe3c577fb 100644
--- a/Documentation/devicetree/bindings/crypto/qcom-qce.txt
+++ b/Documentation/devicetree/bindings/crypto/qcom-qce.txt
@@ -2,7 +2,12 @@ Qualcomm crypto engine driver
 
 Required properties:
 
-- compatible  : should be "qcom,crypto-v5.1"
+- compatible  : Supported versions are:
+		- "qcom,ipq6018-qce", for ipq6018
+		- "qcom,sdm845-qce", for sdm845
+		- "qcom,sm8150-qce", for sm8150
+		- "qcom,sm8250-qce", for sm8250
+		- "qcom,sm8350-qce", for sm8350
 - reg         : specifies base physical address and size of the registers map
 - dmas        : DMA specifiers for tx and rx dma channels. For more see
                 Documentation/devicetree/bindings/dma/dma.txt
-- 
2.30.2

