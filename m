Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17984C83017
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:52:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADF5E246E0
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Nov 2020 15:52:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X2CLndD6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgKSPwx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Nov 2020 10:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728924AbgKSPwl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Nov 2020 10:52:41 -0500
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312F8C0613CF
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:41 -0800 (PST)
Received: by mail-qk1-x744.google.com with SMTP id d28so5720287qka.11
        for <linux-crypto@vger.kernel.org>; Thu, 19 Nov 2020 07:52:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4eYZ8BtJ+Xv96s0vkBJN4bKwPI1mGpKSPj/atTPTao=;
        b=X2CLndD6x4dO4Y8ww/vjWOI2kjcDiGOnEue+rJYwfeW/8WYoST1Vap22OCgDFC3xjg
         IzQAsiROeT7WX47nc/cJida59ADdsovdlPvUj+nBmphV6LEUEVBb5pGMTKrT3zE/q4uR
         F/ht3F6Aw7D8dryDdAVxYpwP6Zkvf680g47LLROF/o/o0stekOh0OZp5i0ebMRzmhKc7
         jbdQBNTkYsUAtf5HT5mvOmhJMR27P771vcfiGXagX0YZATIeHO4Z60vxO8rGV1/ccYvK
         qj6I1MCoBohQrYd1JzslnVrT0p7g+UPcZ74j5ag3oiGTQXUzfQpRzHeqfgIxAcSLICff
         hdPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4eYZ8BtJ+Xv96s0vkBJN4bKwPI1mGpKSPj/atTPTao=;
        b=bMQtB9tCATrEHeW5kSY0eCGR4WxrzBUuOrRkE9WUwe9YZj0A9HBwWjZ9hRTgCGJuDC
         /0AAEMmvlDO6kJA0Cf603EH/yH0TvLa4yqsLosbV++pJYpCjVGMhHxayLkTWp/O9aDrv
         p3YpIjgrqJb5MbYkEi//bIzssSWljflKIPk8jUirrwikPHqwNMaYfpklyyGZqSNefG+y
         lpLIDPxknhQbduac/bRR5E2/OJlxDcYZ5CmqtmqeyeNlDA+QIsrj7EtETs5IwjjTo8va
         cfgjiJKSf0OSD/gH1sZHwSUco8AwOisLaJSBnczxt4wtEJvl8Hdg8DQCFa9YHzxWmOLx
         4iPw==
X-Gm-Message-State: AOAM5325B8mVbqzOmCrCjrgHU98VZ4K60KPRRt8PH8xJfJ2nqPI3yRuH
        S9Kghvd7jEbxCJHqADYR4Pv4MQ==
X-Google-Smtp-Source: ABdhPJz7szSCWmAcq2earjWNlZVZJgPNsWShDopwk6UN17GSGSj07ZyEDiGS/UuVYTVdcx34nGO4mA==
X-Received: by 2002:a05:620a:5f6:: with SMTP id z22mr11361053qkg.211.1605801160386;
        Thu, 19 Nov 2020 07:52:40 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id g70sm127290qke.8.2020.11.19.07.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 07:52:39 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     agross@kernel.org, bjorn.andersson@linaro.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        robh+dt@kernel.org, sboyd@kernel.org, mturquette@baylibre.com
Cc:     linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org
Subject: [Patch v2 4/6] drivers: crypto: qce: Fix SHA result buffer corruption issues.
Date:   Thu, 19 Nov 2020 10:52:31 -0500
Message-Id: <20201119155233.3974286-5-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119155233.3974286-1-thara.gopinath@linaro.org>
References: <20201119155233.3974286-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Partial hash was being copied into the final result buffer without the
entire message block processed. Depending on how the end user processes
this result buffer, errors vary from result buffer corruption to result
buffer poisoing. Fix this issue by ensuring that only the final hash value
is copied into the result buffer.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/sha.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 87be96a0b0bb..61c418c12345 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -48,7 +48,7 @@ static void qce_ahash_done(void *data)
 	dma_unmap_sg(qce->dev, &rctx->result_sg, 1, DMA_FROM_DEVICE);
 
 	memcpy(rctx->digest, result->auth_iv, digestsize);
-	if (req->result)
+	if (req->result && rctx->last_blk)
 		memcpy(req->result, result->auth_iv, digestsize);
 
 	rctx->byte_count[0] = cpu_to_be32(result->auth_byte_count[0]);
-- 
2.25.1

