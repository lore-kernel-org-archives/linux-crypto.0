Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDECBC433B4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 02:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB06361057
	for <linux-crypto@archiver.kernel.org>; Fri, 21 May 2021 02:20:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbhEUCVt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 May 2021 22:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbhEUCVs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 May 2021 22:21:48 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65F2C061763
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 19:20:25 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id y12so14293122qtx.11
        for <linux-crypto@vger.kernel.org>; Thu, 20 May 2021 19:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BntUTk2lgUaVRx3XfqIWsYNjn7+mAoD2nScSXE9jiwA=;
        b=T4RGJuz5B5MhypwYcf1R0iOdPjScW8Xk/y6359xcpiwRkX/TwSQUdEsQeFyS895GMC
         UF63zqkWlWh2QN20BoegqBJuX/kyFbpTbUOzBr0Sfp2IuVKL6Jtz2kEu4sNPSTPpSWtm
         dFGyDidqbBtfMTu2Djc2ZVASUDCjFZH08wPPFVVHh2jNhuv3VGjOTSZJFpVJkSnliZ5M
         iPNxymcUpZVGQRwqwe9OQ37+0We3DuwOX6m+HOz+dtTQMUN5Rm4zZ0WMMLuZ/lkVpq91
         sNQeMBvVBDZRYJ77QsAZ2w0oJ/IEmj/SS5Lw69y/SBN3HVEgdc3w6b38hvOVSKWXodp9
         k1fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BntUTk2lgUaVRx3XfqIWsYNjn7+mAoD2nScSXE9jiwA=;
        b=ZkZ90ZiH71n14q6bmQqgLmUc9syY+QVdNvsdYA8WEA58gzNXL84nehxo5d3gXics8/
         bU7+yIH2m4v7JVoyi/Ax+7xhMDFZWGa/c9dRURkvvGk/QR4YxQA/TQtmmRPfdd/BoJSD
         t13LLL/u578BWYYKERYNH3cA6I/FR+dZJLDHTBh8bVEcZ4L/UdFAOZ15kL2XuTlxw6S0
         YHm6/9xjuaG3/2YJTVzFAGThRW19QSrnl/2/rZwF8zizKCPfs0Umhc+K/Kd9acJafxWO
         Nqp9luHFw3zZEriKorgXlA9TYsdRaem2WuMjacPvAyHM5wYQsx3/n78Nv1pbeP/CCdPV
         EyfQ==
X-Gm-Message-State: AOAM532r4XsYH1HCYtmgqem9ohYKPvT8dICsyB8E7bnKmiKAwPRZtNSp
        oUKzLx0TVuL5qFfKOtG9PiYfnw==
X-Google-Smtp-Source: ABdhPJy+XPBwr+htW+iK1t8MG66Z2iLE9lfu88KpTDT0EkLxC8cZgvFdKVYsLWgGrc0ILOxUw/KtiA==
X-Received: by 2002:ac8:5bc2:: with SMTP id b2mr8646967qtb.220.1621563624783;
        Thu, 20 May 2021 19:20:24 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id f12sm3496691qtj.26.2021.05.20.19.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 19:20:24 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: [PATCH] crypto: qce: skcipher: Fix incorrect sg count for dma transfers
Date:   Thu, 20 May 2021 22:20:23 -0400
Message-Id: <20210521022023.1237148-1-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use the sg count returned by dma_map_sg to call into
dmaengine_prep_slave_sg rather than using the original sg count. dma_map_sg
can merge consecutive sglist entries, thus making the original sg count
wrong. This is a fix for memory coruption issues observed while testing
encryption/decryption of large messages using libkcapi framework.

Patch has been tested further by running full suite of tcrypt.ko tests
including fuzz tests.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/skcipher.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index c0a0d8c4fce1..259418479227 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -72,7 +72,7 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 	struct scatterlist *sg;
 	bool diff_dst;
 	gfp_t gfp;
-	int ret;
+	int dst_nents, src_nents, ret;
 
 	rctx->iv = req->iv;
 	rctx->ivsize = crypto_skcipher_ivsize(skcipher);
@@ -123,21 +123,22 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 	sg_mark_end(sg);
 	rctx->dst_sg = rctx->dst_tbl.sgl;
 
-	ret = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
-	if (ret < 0)
+	dst_nents = dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
+	if (dst_nents < 0)
 		goto error_free;
 
 	if (diff_dst) {
-		ret = dma_map_sg(qce->dev, req->src, rctx->src_nents, dir_src);
-		if (ret < 0)
+		src_nents = dma_map_sg(qce->dev, req->src, rctx->src_nents, dir_src);
+		if (src_nents < 0)
 			goto error_unmap_dst;
 		rctx->src_sg = req->src;
 	} else {
 		rctx->src_sg = rctx->dst_sg;
+		src_nents = dst_nents - 1;
 	}
 
-	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, rctx->src_nents,
-			       rctx->dst_sg, rctx->dst_nents,
+	ret = qce_dma_prep_sgs(&qce->dma, rctx->src_sg, src_nents,
+			       rctx->dst_sg, dst_nents,
 			       qce_skcipher_done, async_req);
 	if (ret)
 		goto error_unmap_src;
-- 
2.25.1

