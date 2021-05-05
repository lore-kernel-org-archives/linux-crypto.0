Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01815C43470
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8D63613EA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234379AbhEEVlB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 17:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbhEEVkm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 17:40:42 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF66FC06138C
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 14:39:36 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id z16so2857687pga.1
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 14:39:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pEJvk1zZudo0cXLtIrFaUbh6obXgvIjn1HyujLXL5g8=;
        b=drxD5dEZDc2p/dj0Qmi1fQTn6Q3YHavDpdKXgJUF1gIWA3iewBUPcmJbfbJBKSwaGt
         YH+4AdQaQnY2k/Z8ldO9jkr99qr6IL7vtp28/+8df4h2qFM9ZoatOqRL+MzI1ykgKkIo
         +f9+n1tgHrJEe0tvSp/+c/BERGe0Oh1G28PEi8xlUvQJ9u2VnaXQiYMbU2apD1o865pg
         YP934Pl+KNRAS8tiDpIDF0KHwTQJ5S2plGlxuLr6dwmSJoXrYM9a/TQI+Ti65qWIr4nM
         ompxuzVLD2EPYntRS8CjQV+B+Yx5TV4QT4pI14FKtWXOL94pTnalF3e3TYNBLCZnR2YC
         TkWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pEJvk1zZudo0cXLtIrFaUbh6obXgvIjn1HyujLXL5g8=;
        b=Fr8jyygrXdBMk3/+qGz+d3RVQLEyB/CXSPJeti+zfDM2/zVwHQPX2z4vmiO+qJ3YeX
         l0Db/6SNjlS4NB+YBskci8usrFJRvkNS2wOh9kb1S6zPOZL2Rpk6UMPxP8bEgrgWX/hn
         JzdQnIjtgT1q9QkScZeUduJqiftzTY4CxGCL+SnDErUNfbxPUZewzXeTZJCKrCHCGl+N
         AkJ7F30Cdsk96cZLhUWoYbKZGsPY6RyFT7RJqJGf11rEhtLor2u0Tiqbofd1e+cNhXyS
         hqhY9XsA0uZbMmx3maOLnbgLgNoy6fPYx0tNqNt99nYwxo6qcK/LFS1ZVCCP7txzWyvd
         fE5A==
X-Gm-Message-State: AOAM5303Q7qr2CW/O09rAFVvqPzEi/H2wyZ3suPEPNqxGtt0yLr0r7lb
        TH7qbI+BEW8yN0GWzmwNH5X+Qw==
X-Google-Smtp-Source: ABdhPJzZGmtSzWKxV6S/rcvlS9LRf33OH03vUVvmpCPZ2boGDz1MHax4REK9um6246B8XG2VFNm1wg==
X-Received: by 2002:a05:6a00:ad6:b029:28c:c28d:d3c5 with SMTP id c22-20020a056a000ad6b029028cc28dd3c5mr1105527pfl.54.1620250776482;
        Wed, 05 May 2021 14:39:36 -0700 (PDT)
Received: from localhost.localdomain.name ([223.235.141.68])
        by smtp.gmail.com with ESMTPSA id z26sm167031pfq.86.2021.05.05.14.39.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:39:36 -0700 (PDT)
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
Subject: [PATCH v2 15/17] crypto: qce: Defer probing if BAM dma is not yet initialized
Date:   Thu,  6 May 2021 03:07:29 +0530
Message-Id: <20210505213731.538612-16-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
References: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Since the Qualcomm qce crypto driver needs the BAM dma driver to be
setup first (to allow crypto operations), it makes sense to defer
the qce crypto driver probing in case the BAM dma driver is not yet
probed.

This fixes the qce probe failure issues when both qce and BMA dma
are compiled as static part of the kernel.

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
 drivers/crypto/qce/core.c  | 4 ++++
 drivers/dma/qcom/bam_dma.c | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 9a7d7ef94687..3e742e9911fa 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -15,6 +15,7 @@
 #include <linux/types.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/hash.h>
+#include <soc/qcom/bam_dma.h>
 
 #include "core.h"
 #include "cipher.h"
@@ -201,6 +202,9 @@ static int qce_crypto_probe(struct platform_device *pdev)
 			of_match_device(qce_crypto_of_match, &pdev->dev);
 	int ret;
 
+	/* qce driver requires BAM dma driver to be setup first */
+	if (!bam_is_probed())
+		return -EPROBE_DEFER;
 
 	qce = devm_kzalloc(dev, sizeof(*qce), GFP_KERNEL);
 	if (!qce)
diff --git a/drivers/dma/qcom/bam_dma.c b/drivers/dma/qcom/bam_dma.c
index 2bc3b7c7ee5a..c854fcc82dbf 100644
--- a/drivers/dma/qcom/bam_dma.c
+++ b/drivers/dma/qcom/bam_dma.c
@@ -935,6 +935,12 @@ static void bam_channel_init(struct bam_device *bdev, struct bam_chan *bchan,
 	INIT_LIST_HEAD(&bchan->desc_list);
 }
 
+bool bam_is_probed(void)
+{
+	return bam_probed;
+}
+EXPORT_SYMBOL_GPL(bam_is_probed);
+
 static const struct of_device_id bam_of_match[] = {
 	{ .compatible = "qcom,bam-v1.3.0", .data = &bam_v1_3_reg_info },
 	{ .compatible = "qcom,bam-v1.4.0", .data = &bam_v1_4_reg_info },
@@ -1084,6 +1090,7 @@ static int bam_dma_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_unregister_dma;
 
+	bam_probed = true;
 	if (!bdev->bamclk) {
 		pm_runtime_disable(&pdev->dev);
 		return 0;
-- 
2.30.2

