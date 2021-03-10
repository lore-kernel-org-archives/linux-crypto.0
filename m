Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053C0C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 05:26:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF4A664FF6
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Mar 2021 05:26:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbhCJF0T (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Mar 2021 00:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbhCJFZv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Mar 2021 00:25:51 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0B95C061760
        for <linux-crypto@vger.kernel.org>; Tue,  9 Mar 2021 21:25:50 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id g4so10619687pgj.0
        for <linux-crypto@vger.kernel.org>; Tue, 09 Mar 2021 21:25:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rCnpcLpuqTdHmtaa7vEu9Tx55M7Ej3EbyXNq00c5adU=;
        b=sJR0eTnWGvsWHfKsGs1GxG5L1cwoqOeg3Yd0ioLF14Xa3dmshqNyd1Gl4BzpsteYUz
         DHpLTFAWqi5QMX8fFbywmvPnSZBQtkuHyoyvXfxDn0/JLUjpY6vYxSyHcrE7RqqfC804
         4WgBcuXlgH9BPCmvnFp8UKsJRVJLQQezriFNkQvo9y+Z+Zthu2nsTVZJeE9WNj8g6jA9
         cELC7WpcQnuQJFdOIm3iD8rOdfsdx46CY7iRF3/2Mee6KJyUU5S+fPq4MHxJk0eT2TDO
         lhJvDD6/zSv5yBOXG/fI4ppo/D0ryDRleseOhCQuueTh3ASNP/xDxukS+M77Mnbxb5No
         IAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rCnpcLpuqTdHmtaa7vEu9Tx55M7Ej3EbyXNq00c5adU=;
        b=cKLvy3nUl5fhXYTwD0urxT7nrUNHMjZsAwjuTSBvRurqJVFiltw/ULsMBsWkgxCBKA
         nLkmpjhC75WaaZPU5hGkbbYrma25Lbf7a62mHjEMyM1SC3MkHyxXgV5CA9yoqSFZbJ03
         bsoCbqrruCd9VIYdERMM3uzk2KowNvpCc64uUvRo6AcTMstF0N6bEUUzbBDkvEorYBSN
         w+At+lpkztB+wzPMWNgz8epvVIfnruCl+Ko0BrnhzcXvnjSK8NffWynAgNeHGo9xDoUC
         Pc56ujV+C1hdjL52/mah+VBR53g7NYr5vuuRecgmiDVsns9h6WJBjl1cMGvxlopmPgwz
         AoSg==
X-Gm-Message-State: AOAM531V9ypEQUhohszLm7t+XvxoErCnWKeoN5zWRLxDo4ovxC3XVyhu
        ytVAa8MI0PIpfR3XbvRWhucgIw==
X-Google-Smtp-Source: ABdhPJzmRPeOWu16uPBVPML5utQZj0PB0c1OsJTfAdIhHMoFqp1dfNL6o3ViJOXYPndUKRT5BvtY4Q==
X-Received: by 2002:a65:6a44:: with SMTP id o4mr1313921pgu.312.1615353950393;
        Tue, 09 Mar 2021 21:25:50 -0800 (PST)
Received: from localhost.localdomain ([2402:3a80:9f4:a436:21bd:7573:25c0:73a0])
        by smtp.gmail.com with ESMTPSA id g7sm13915224pgb.10.2021.03.09.21.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 21:25:50 -0800 (PST)
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
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhupesh.linux@gmail.com
Subject: [PATCH 4/8] dt-bindings/clock: qcom: sm8250: Add gcc clocks for sm8250 crypto block
Date:   Wed, 10 Mar 2021 10:54:59 +0530
Message-Id: <20210310052503.3618486-5-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210310052503.3618486-1-bhupesh.sharma@linaro.org>
References: <20210310052503.3618486-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch adds the global clock controller (gcc) clocks required
by the sm8250 crypto block to function to the dt-binding header file
(namely: GCC_CE1_AHB_CLK, GCC_CE1_AXI_CLK and GCC_CE1_CLK).

Cc: Thara Gopinath <thara.gopinath@linaro.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Andy Gross <agross@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David S. Miller <davem@davemloft.net>
Cc: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>
Cc: linux-clk@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: bhupesh.linux@gmail.com
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 include/dt-bindings/clock/qcom,gcc-sm8250.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/dt-bindings/clock/qcom,gcc-sm8250.h b/include/dt-bindings/clock/qcom,gcc-sm8250.h
index 7b7abe327e37..6c58320238c4 100644
--- a/include/dt-bindings/clock/qcom,gcc-sm8250.h
+++ b/include/dt-bindings/clock/qcom,gcc-sm8250.h
@@ -207,6 +207,9 @@
 #define GCC_VIDEO_AXI0_CLK					197
 #define GCC_VIDEO_AXI1_CLK					198
 #define GCC_VIDEO_XO_CLK					199
+#define GCC_CE1_AHB_CLK						200
+#define GCC_CE1_AXI_CLK						201
+#define GCC_CE1_CLK						202
 
 /* GCC resets */
 #define GCC_GPU_BCR						0
-- 
2.29.2

