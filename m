Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDDEEC433ED
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1192613EA
	for <linux-crypto@archiver.kernel.org>; Wed,  5 May 2021 21:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234356AbhEEVkm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 5 May 2021 17:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbhEEVkZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 5 May 2021 17:40:25 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA040C06134C
        for <linux-crypto@vger.kernel.org>; Wed,  5 May 2021 14:39:16 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k19so3091071pfu.5
        for <linux-crypto@vger.kernel.org>; Wed, 05 May 2021 14:39:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1sSf0qLJyLVYx1RDRkbOVw7ymMGOYYyNpXZ6BpinJ5I=;
        b=vEajL1EbcQ06XtvJ1SFAVyQg9rt87G7DnGNRmGmmwhV05ov7JKp/MGTvqT92eSrLdM
         qyberW4utabHgRDGWO631F6nZ0SEZKv7KF3Yd/QDYIeMEVBNJ01qpFMKdr8ENCT7BJWr
         r+5X6hyAWC3tDk+GZHLuNRyuo95TBxi3QboWSx0F0XEkUkjd7tRG0g1L0H+kJRobhi/B
         G5pxnV3loZcfLVGecyrCAHU2Aapi0lIXPzxZhPpSLlGuQJRI5k0jOviph5WhWjhsQpGu
         oQIU+a3l32fuiVZwwSZUZUEK7d8ib6vZcCQFqV5LgmwDcOwF+iOBpQ9NNdPH4Ocx3ojK
         rF1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1sSf0qLJyLVYx1RDRkbOVw7ymMGOYYyNpXZ6BpinJ5I=;
        b=p6jJTeg2KuOb0KXe6pwsakDS2WYSeP1/BoAHqejbE53PKwbCskDrlBx+kdHgP5T/a8
         s3Bu5a8FlYfCEg7ofPa2tpQLwTiv7wnivhzsOUt6QmTHf4gsGsGZDbqpJVAWj3+nba4E
         yAYLLSlr8Us9tSSjUna8W2wzTraqdi0BtLZsFdVRhy+9tm45Rvv53kjRi14mhsPfb1sJ
         lVymkesPDbaF0iD4nqYQ4a8yW3ncDjsG5pSKvPyMPFpSMJwMN3PFH8Cc0EBAwu6cSXQV
         vcW67NeK2iijQg8GD+6H9RCHfoh/hjsegjomgpqJcLsFkiV2ly+epUQ77cPci2Aj5Z1T
         GtVA==
X-Gm-Message-State: AOAM532R/YQ0Bd5Tc2mA5tTyZg/wZK5PpF8qGYowxO0iBa/xj/5DFk8s
        CcGE1kV01i5NjCrzS9dq2KvCTQ==
X-Google-Smtp-Source: ABdhPJw9/Qn/hjK7cYMjvGVZbkNf5lDvmamHWH1NqGTZaV28vRdoj48SBaVMt5+w6bIgqBIAxHT33g==
X-Received: by 2002:a63:e405:: with SMTP id a5mr891379pgi.89.1620250756407;
        Wed, 05 May 2021 14:39:16 -0700 (PDT)
Received: from localhost.localdomain.name ([223.235.141.68])
        by smtp.gmail.com with ESMTPSA id z26sm167031pfq.86.2021.05.05.14.39.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 14:39:16 -0700 (PDT)
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
Subject: [PATCH v2 12/17] crypto: qce: Print a failure msg in case probe() fails
Date:   Thu,  6 May 2021 03:07:26 +0530
Message-Id: <20210505213731.538612-13-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
References: <20210505213731.538612-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Print a failure message (dev_err) in case the qcom qce crypto
driver probe() fails.

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
 drivers/crypto/qce/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index 293d0bfe3aab..bae08fdfc44f 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -301,6 +301,8 @@ static int qce_crypto_probe(struct platform_device *pdev)
 	icc_set_bw(qce->mem_path, 0, 0);
 err_mem_path_put:
 	icc_put(qce->mem_path);
+
+	dev_err(dev, "%s failed : %d\n", __func__, ret);
 	return ret;
 }
 
-- 
2.30.2

