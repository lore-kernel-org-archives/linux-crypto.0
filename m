Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32B4EC43460
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 13:25:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 068F961207
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 13:25:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbhDQNZi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 09:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236305AbhDQNZc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 09:25:32 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D73C06175F
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 06:25:06 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id z15so14813668qtj.7
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 06:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VcMAQ1EGbeesv8V+7yaxgvD6ypjuKCvSWavQ5LbGTMA=;
        b=HJklx3NmN3v5pM8kGfdNbm5n0eFqnc10Glfghb83pTbDpCrMYdPfZz4u4Bv2vHH83U
         VMDX1shkqN4rrDBBmHtap2Cqyv2nTXbd4Lg5fEBujY+6YExQHpoEFXtc1z6FA2rsd5js
         BQEjaQLOfkVpRyt5/v5p+yWUCgSw575N9FmQ5BtsB1qxb3rQHn8zvh4UUWTfTLUoGbz6
         itIj34CECkk0qnPmcoYGn8dnrxxXauKMaJ3wu0SY9OYlqKmWCIf3U54S13EIDvtDsjUL
         /5bof0+dO8U3AAsui0BDUKVVXdANhKngxPfGKPOcPO0I8iqTXHRAwHMdTS43BeF4uvgm
         b5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VcMAQ1EGbeesv8V+7yaxgvD6ypjuKCvSWavQ5LbGTMA=;
        b=lvF33HGFYle9GFdqygE0tsh/AkJm1WJ4Bdn5+PqiaguyDyv0OZJ38opay0y8USwK1g
         gBE7EqPL81cBbYUAE4J7jJV739YeRmYXdIJxPg6SxleC5c0+D8r6iP6ect7SUNIq6OUA
         nWRRQQTLS0gXxjZ3OEHf3h6a3FCQjrEu2e+XCaNmKqSEYLd2QF7B7YagoQ8722hPvYnT
         Wv3Re+3BE2yN6MkWH4vUTrQzP7Ln0sc5AbeoPqInWN0VN4Q9MWu0kpJzG5+sYVuimBjq
         q1yraTx+qu/eN7C5+Pf4ZWek//aGOEkNPAnGqJhVy/+bVDKe2cd2UoGuYnCACTmZ+t6S
         KunQ==
X-Gm-Message-State: AOAM531QAe3UVjb47Pxy1x6JhioBiVU7dTMtPRcVgtvraj9SuK0pnpDb
        5J43ji4uq9Fgu2YyCG1wWF1inA==
X-Google-Smtp-Source: ABdhPJx3FdLlhpGerzeCsNZOVNq0P81zG6Q0EqRRgjQRfNuHkBtZCwi8z8rJg8QXx94c9+y7tjHyPQ==
X-Received: by 2002:ac8:4411:: with SMTP id j17mr3793443qtn.109.1618665905302;
        Sat, 17 Apr 2021 06:25:05 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id o25sm1988327qtl.37.2021.04.17.06.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 06:25:04 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v2 1/7] crypto: qce: common: Add MAC failed error checking
Date:   Sat, 17 Apr 2021 09:24:57 -0400
Message-Id: <20210417132503.1401128-2-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210417132503.1401128-1-thara.gopinath@linaro.org>
References: <20210417132503.1401128-1-thara.gopinath@linaro.org>
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

v1->v2:
	- Split the error checking for -ENXIO and -EBADMSG into if-else clause
	  so that the code is more readable as per Bjorn's review comment.

 drivers/crypto/qce/common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index dceb9579d87a..dd76175d5c62 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -419,6 +419,8 @@ int qce_check_status(struct qce_device *qce, u32 *status)
 	 */
 	if (*status & STATUS_ERRORS || !(*status & BIT(OPERATION_DONE_SHIFT)))
 		ret = -ENXIO;
+	else if (*status & BIT(MAC_FAILED_SHIFT))
+		ret = -EBADMSG;
 
 	return ret;
 }
-- 
2.25.1

