Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61A0C43461
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 14:39:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AF7D611C2
	for <linux-crypto@archiver.kernel.org>; Wed, 19 May 2021 14:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354417AbhESOkj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 May 2021 10:40:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354430AbhESOk2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 May 2021 10:40:28 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16A6C061352
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2021 07:38:32 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id x18so5743452pfi.9
        for <linux-crypto@vger.kernel.org>; Wed, 19 May 2021 07:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9/tRHikibb3VDcl2hDfDt+wuIOHwmbk3mgz2i/PihKw=;
        b=u7a89WZVIzdktaGkwWnlPlSmIYDzJGnbfm2CzHxBCMEXDIfmNMOp1L93vDZcA3DCeY
         g8Bpv1A/OuH0LefeJglan+PMxiZvB3+FXyoqBTYIIVZRAgQMTyhi8kLEmyUBubi2OdOl
         litNXvhurgiw0cbCTNxEUyGwmhW44MEJ1MC+CXylJpcsWhkv/E8CceaHzap3LI2NMtSq
         qcyT6r3qbHwIDIR0djgRhem08/+U14EkkuTYd+ilqHqwvQrSCfI+ITg5319w+fs6O40U
         kmO7/QsI7o0lWCYTJsn/gVTXbZZAL/Z6xy0h3HSyznfKI4MRanSyAHxeZGsHUs1k/IiD
         hOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9/tRHikibb3VDcl2hDfDt+wuIOHwmbk3mgz2i/PihKw=;
        b=ghY9Jq8XLowyanw/G/OYRCXDDFo184vfiBguNUgAHnSeqaUPIeuF0CdOgPal92lTgX
         riGKRjdPiexZdGmg3aTifg6v2/lpJfISe942HTzquyxkNKsrOLBrnDlXI8MsQLpRm8pc
         j0r7HKER9VyygrLCUSlD0/P+eIDEPxX6WSrJ+4IS30WCjeJmanRTQhl+hxAJuJZCLM+1
         dkSBYHwnrQNNCPfbZffgJQtXXmPz1DEA8Zwu5DK42ulU/zmhpJei6+wiZR5yHB3cgdH4
         yFBhGQQEPHx1oXIQFs3CAiGFTbfJAsf4rzWeE8gdpyQZo4HjxhCaHZZmd4AJTl6tn7X8
         SaEg==
X-Gm-Message-State: AOAM530c0EQ6dLyFhG7jCHClQKt78Ddo9oeWCJcB0DBOXxLTgFA+E+Yh
        Mp8WG/FgJ+R9+nygedSVT9WXpg==
X-Google-Smtp-Source: ABdhPJwATRlheQTYTLSdGD+kSlPUqq4AspzaBlyRyYQdhQsx6Na2MFDmsbjDiYvm50TCzRC4mqShDw==
X-Received: by 2002:a63:6486:: with SMTP id y128mr11051673pgb.414.1621435112516;
        Wed, 19 May 2021 07:38:32 -0700 (PDT)
Received: from localhost.localdomain.name ([122.177.135.250])
        by smtp.gmail.com with ESMTPSA id o24sm9239515pgl.55.2021.05.19.07.38.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 May 2021 07:38:32 -0700 (PDT)
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
Subject: [PATCH v3 10/17] dma: qcom: bam_dma: Add support to initialize interconnect path
Date:   Wed, 19 May 2021 20:06:53 +0530
Message-Id: <20210519143700.27392-11-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519143700.27392-1-bhupesh.sharma@linaro.org>
References: <20210519143700.27392-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Thara Gopinath <thara.gopinath@linaro.org>

BAM dma engine associated with certain hardware blocks could require
relevant interconnect pieces be initialized prior to the dma engine
initialization. For e.g. crypto bam dma engine on sm8250. Such requirement
is passed on to the bam dma driver from dt via the "interconnects"
property.  Add support in bam_dma driver to check whether the interconnect
path is accessible/enabled prior to attempting driver intializations.

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
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
[ bhupesh.sharma@linaro.org: Make header file inclusion alphabetical and use devm_of_icc_get() ]
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/dma/qcom/bam_dma.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index c8a77b428b52..4b03415b8183 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -26,6 +26,7 @@
 #include <linux/kernel.h>
 #include <linux/io.h>
 #include <linux/init.h>
+#include <linux/interconnect.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/interrupt.h>
@@ -392,6 +393,7 @@ struct bam_device {
 	const struct reg_offset_data *layout;
 
 	struct clk *bamclk;
+	struct icc_path *mem_path;
 	int irq;
 
 	/* dma start transaction tasklet */
@@ -1284,6 +1286,14 @@ static int bam_dma_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	/* Ensure that interconnects are initialized */
+	bdev->mem_path = devm_of_icc_get(bdev->dev, "memory");
+	if (IS_ERR(bdev->mem_path)) {
+		ret = PTR_ERR(bdev->mem_path);
+		dev_err(bdev->dev, "failed to acquire icc path %d\n", ret);
+		goto err_disable_clk;
+	}
+
 	ret = bam_init(bdev);
 	if (ret)
 		goto err_disable_clk;
-- 
2.31.1

