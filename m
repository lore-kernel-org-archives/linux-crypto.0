Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F20ABC43462
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 15:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0AB761441
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 15:07:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240732AbhD2PII (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:08:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240094AbhD2PIC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Apr 2021 11:08:02 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F88C061343
        for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2021 08:07:12 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id u20so35292765qku.10
        for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2021 08:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T6+zvlvsLjNp5pODzoq20iFMKbJBEBGuZQctRXwxLzk=;
        b=glK9FcBE0j5Ax9Uuc6EfaVUy8G9GYCHnrfW74UTMCR4OCina+tEct4HWAWiCCiv94D
         DaOhtz8R11T+enhrXvGKm2GGNh94WvYIXDcPJwk77nU8fF+wN93KTDtqBaB6ikxGhNuw
         UhDlQVNJ1DPYGCT4iZfTd8YT3dwc5kusPJxBVpi9lKm0y8iOSWg6dnAUhsmQ6/joz5XK
         CfTXnntShdJRpjqvTgEfGZiNwtGTfoU7XD7MVSsIu5c9IbxGXEM0k51FSJzFNOH1NPcJ
         dI1C7niPHqXal+We/gW3Qd/R/Ni/jND1CzX0Dpw2MJFY2sdrfS/X5lQWWBjm18Qm6Rlu
         /E3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T6+zvlvsLjNp5pODzoq20iFMKbJBEBGuZQctRXwxLzk=;
        b=BpE66FTNakEPGfBvycflol50GSoJg4Mrz9oi+ZaUtEJ7PtHLpR61VOVLhTA5Gv9BDk
         F6rxfy5LBGhP0zLJ78vpoX+0bFlCXWrM7xsH16Hsuybqrx5FcJunt0onqUoLnXM/NUaT
         Aak9Xwip/UtGjm6YT6aBQMC3OpRVxuG8wiwBP3S/kVC6twNFBMYqF4KWGHN+DxZCL2fU
         mayx6zgyJxcyd2MLYhj9eROZBkAzkiVWxY5+pS2KMZ5vqB7LljLh+BQqTJVWg2cDmA0C
         mCplWdv3EDbAwGqU3p9oSvYzNr+hjBA4U9eHV0MSEU6sGp1VVPdkdv8qIWpxRPCAD+qh
         bGfg==
X-Gm-Message-State: AOAM530MfhYm4wDicQSy/vpuV1d4TsykltYIkTEKYiTyRdAIDp7QGv7a
        t3H66i2VDfmwANNr71ZweGn3nA==
X-Google-Smtp-Source: ABdhPJwxacRbIaxPzMZaY1d7VqYQu8REjin3e2Sa4q7+2cs4rs5Bs1TW+ycgvvvEOx6ZpnX7qmHPFQ==
X-Received: by 2002:a37:aec6:: with SMTP id x189mr117866qke.348.1619708831240;
        Thu, 29 Apr 2021 08:07:11 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id j191sm2223822qke.131.2021.04.29.08.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 08:07:10 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v4 2/7] crypto: qce: common: Make result dump optional
Date:   Thu, 29 Apr 2021 11:07:02 -0400
Message-Id: <20210429150707.3168383-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210429150707.3168383-1-thara.gopinath@linaro.org>
References: <20210429150707.3168383-1-thara.gopinath@linaro.org>
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

