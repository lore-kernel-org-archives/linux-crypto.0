Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B215C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:28:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35F3F64E6C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhBYS2W (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:28:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbhBYS2B (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Feb 2021 13:28:01 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8129AC061788
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:20 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id s15so4837137qtq.0
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iTjTmQs8FYf7whYqEO4Ey2Ll+wNPA9ydSS+PI2wxbPs=;
        b=LQs/7wSi5ayT1xC3drFlgo5hTOQxq4lCUpUfFb+Gtgzmy5L0AibS0IH4ahRWb/YAEc
         /SJoertEMDV5n6fNkek2XzsV2cwY2UM2Lbl1soJrlYOF9oHZn64foAUH3qKRkjz5dhQt
         0jv1zMLV7an/HY4sBvW/G8cuvZ583Fsz/4Qbvqf5D8rquvabFaULkSwYS/d+0+1W/mH7
         sXmJrYsUWc33rqK0d15VdAmHu9MD9Ivcc4w8rGZgOpY7a/8Mx5xC4jE06CP7vnlzS+Ze
         yYdtTsWmuMpWk3ntdoXOgAV1urtkPLd6vAgWA9rjsFd7tbNdHm1jt9xRxY+gy1R5mG+f
         m3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iTjTmQs8FYf7whYqEO4Ey2Ll+wNPA9ydSS+PI2wxbPs=;
        b=pR+JABaPuTSmpkFJ/074AP11md5HE9cUUWIaiM3RMBzsU4IEmAjpYP4DW9cbt5R9w1
         HpjKqQgljQZ2b30Vcfh8Du3s5m73Cex78weC2gTU2VlU3/q0gbxTstKSn2Z9+ZVEyQ6E
         QNwuTHgUp9xHKOEzQJqFVOpBQjfVtl9RjXxQ/JmmKQ/n4NiO2VOszQEGJWs4s9rdsnJv
         pwyG+pfZXoDY3BQATOKsH7Bg7ptGhiO/99Ik3FZk53SZYuLIxQNposHk6mmX/4VYdl/L
         ouhH4HX0dGOBU2dJMiUo8q17SSg1rXv+x3LhsajXo34wORVcuDizgA/9LvvA1Iaga1MY
         iLNQ==
X-Gm-Message-State: AOAM530l41HIaOVaT/hGNj/2FfnZZM854xHqg3u8CLXr2ck114LByb9S
        Dmp+WZUI67mknHk7FcWJFqylDw==
X-Google-Smtp-Source: ABdhPJyQJjXZZ5cwzDHIlznxiqFJzrPtgWFiI3nerx5wly5TlY6YgvpDC4565MqcifGjpcpas9IauA==
X-Received: by 2002:ac8:3902:: with SMTP id s2mr3780784qtb.26.1614277638261;
        Thu, 25 Feb 2021 10:27:18 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id l65sm4519678qkf.113.2021.02.25.10.27.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 10:27:17 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] crypto: qce: common: Add MAC failed error checking
Date:   Thu, 25 Feb 2021 13:27:10 -0500
Message-Id: <20210225182716.1402449-2-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225182716.1402449-1-thara.gopinath@linaro.org>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

MAC_FAILED gets set in the status register if authenthication fails
for ccm algorithms(during decryption). Add support to catch and flag
this error.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/common.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index dceb9579d87a..7c3cb483749e 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -403,7 +403,8 @@ int qce_start(struct crypto_async_request *async_req, u32 type)
 }
 
 #define STATUS_ERRORS	\
-		(BIT(SW_ERR_SHIFT) | BIT(AXI_ERR_SHIFT) | BIT(HSD_ERR_SHIFT))
+		(BIT(SW_ERR_SHIFT) | BIT(AXI_ERR_SHIFT) |	\
+		 BIT(HSD_ERR_SHIFT) | BIT(MAC_FAILED_SHIFT))
 
 int qce_check_status(struct qce_device *qce, u32 *status)
 {
@@ -417,8 +418,12 @@ int qce_check_status(struct qce_device *qce, u32 *status)
 	 * use result_status from result dump the result_status needs to be byte
 	 * swapped, since we set the device to little endian.
 	 */
-	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE_SHIFT)))
-		ret = -ENXIO;
+	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE_SHIFT))) {
+		if (*status & BIT(MAC_FAILED_SHIFT))
+			ret = -EBADMSG;
+		else
+			ret = -ENXIO;
+	}
 
 	return ret;
 }
-- 
2.25.1

