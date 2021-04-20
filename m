Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 821BCC433B4
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Apr 2021 03:36:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5048C61090
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Apr 2021 03:36:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhDTDgi (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Apr 2021 23:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbhDTDgh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Apr 2021 23:36:37 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5477C06138A
        for <linux-crypto@vger.kernel.org>; Mon, 19 Apr 2021 20:36:05 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id z15so19719508qtj.7
        for <linux-crypto@vger.kernel.org>; Mon, 19 Apr 2021 20:36:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T6+zvlvsLjNp5pODzoq20iFMKbJBEBGuZQctRXwxLzk=;
        b=pNVEqhlK3G5r1t9ZbVhVyTsSkjWwpKmkaqqnPdEt574Q98uODBUM4eRh28yHIOpMx3
         HKg/paiyZUU3nLBhWYWlTJM014w1Bjg9dWLaPUBgtQaJHsgcE4mi78omwnMvohX704Nf
         OpFbtAgbJiXYcL9GUOgpmoyWKrxtNN1IX0iB3voK8Bml9IDTHiJnweP4XddOSRXZMvuH
         OvQhA+h5NRmrYdLOBWAmxnXPh/aZ7a2/5tqGqJm3r7DwVO9zyaiR7Tm86iKliuDTcRC5
         fbO0K9r3neWTl7X+DsyYChdvxr8S3YL9UJTX1+lrjD/crPGq5xP1I9l+YGUNq3PCqcJ1
         /+ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T6+zvlvsLjNp5pODzoq20iFMKbJBEBGuZQctRXwxLzk=;
        b=B/Zyk/ZlgOVESI3PzCL/RrpqcxKcHq17T1iTZ0xyfZRvwAt25k210T2AP7UzIvLsHd
         RkrB7I7/47Rh8XUA7+8dP6Lw9I9Nzh/A2jeDlw9my6mYTyh9pfEyvc8Eg1daYUDtBBgq
         am67gYBJQrp8nHk3Z2mkSnYSy/Pz8BcsIt2S+UZrvGQobAuDJHPnfSQs9X3B+usTlQa5
         uJrDsdJd8d3RG+nMs0l5cLg4r6bT18e6YZj6i1eu/uNqM9y3zzn0Gxv9QjDtL91jZ6t1
         K44O3Y5vLXTeWeP/rNomGV2fHRcR069ipiM9uvyQ0uR4xFL9i9ofY3NiFDCkXws3VBCl
         W1Xg==
X-Gm-Message-State: AOAM531XmkXyCM10xHJWwrQKlKyS8WCXDAS8twQrGy/Poh8CtdeGgKTG
        Cwjh+MJGY8KGN8OOXOh0expt9g==
X-Google-Smtp-Source: ABdhPJxACoL4owQfv4aGWhhvZ7IAcpyiFm2fO3Q8fhVoOgfqwFjc7aCJ5+pqr6BzfLxpJmvMqCZXsg==
X-Received: by 2002:ac8:5ad5:: with SMTP id d21mr15067440qtd.198.1618889765198;
        Mon, 19 Apr 2021 20:36:05 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id b8sm3562643qka.117.2021.04.19.20.36.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Apr 2021 20:36:04 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v3 2/7] crypto: qce: common: Make result dump optional
Date:   Mon, 19 Apr 2021 23:35:57 -0400
Message-Id: <20210420033602.1729947-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210420033602.1729947-1-thara.gopinath@linaro.org>
References: <20210420033602.1729947-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Qualcomm crypto engine allows for IV registers and status register
to be concatenated to the output. This option is enabled by setting the
RESULTS_DUMP field in GOPROC  register. This is useful for most of the
algorithms to either retrieve status of operation or in case of
authentication algorithms to retrieve the mac. But for ccm
algorithms, the mac is part of the output stream and not retrieved
from the IV registers, thus needing a separate buffer to retrieve it.
Make enabling RESULTS_DUMP field optional so that algorithms can choose
whether or not to enable the option.
Note that in this patch, the enabled algorithms always choose
RESULTS_DUMP to be enabled. But later with the introduction of ccm
algorithms, this changes.

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/common.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index dd76175d5c62..7b5bc5a6ae81 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -88,9 +88,12 @@ static void qce_setup_config(struct qce_device *qce)
 	qce_write(qce, REG_CONFIG, config);
 }
 
-static inline void qce_crypto_go(struct qce_device *qce)
+static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
 {
-	qce_write(qce, REG_GOPROC, BIT(GO_SHIFT) | BIT(RESULTS_DUMP_SHIFT));
+	if (result_dump)
+		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT) | BIT(RESULTS_DUMP_SHIFT));
+	else
+		qce_write(qce, REG_GOPROC, BIT(GO_SHIFT));
 }
 
 #ifdef CONFIG_CRYPTO_DEV_QCE_SHA
@@ -219,7 +222,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 	config = qce_config_reg(qce, 1);
 	qce_write(qce, REG_CONFIG, config);
 
-	qce_crypto_go(qce);
+	qce_crypto_go(qce, true);
 
 	return 0;
 }
@@ -380,7 +383,7 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
 	config = qce_config_reg(qce, 1);
 	qce_write(qce, REG_CONFIG, config);
 
-	qce_crypto_go(qce);
+	qce_crypto_go(qce, true);
 
 	return 0;
 }
-- 
2.25.1

