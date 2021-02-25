Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D365C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 425E864F03
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbhBYS2f (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232984AbhBYS2V (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Feb 2021 13:28:21 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40EA5C06178C
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:21 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id o34so4790368qtd.11
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sVEXsmQpwU6APdK8kMYl/K7qANFQ0+6DyJKL9jqKzxg=;
        b=pUKHfj47wizhy5IKgaDEE9DOxykWVRArBU0jimsKgvTtAq4HZ8sjKs9NwVFbL/s92t
         4Nr3JYprNegQd1uWE/kwkTJCHngwKymAFYdzLul5x5dzQbqrAUMAbt5be43Kbr/tJ9sc
         vo5Ack0QH4Ug9sg9PQPuWPSj+G3Ji2E2MAP0QlMf4D51oO8lkPkBMNsCm1FSV/Rl+8vg
         bez5E3hCp7Rr+/LbE5wi2f8IdLLB2TQ0xrODABXh4S7L8zTjSlKrya2AJ4rai+py0dkN
         AZxhYrY486Zcx+iGvEBsxCzpvUNIktaZwI4FUTgWS34AVaKFZD5547yx748VaTSubSnZ
         eRCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sVEXsmQpwU6APdK8kMYl/K7qANFQ0+6DyJKL9jqKzxg=;
        b=MhjPjUn7dbcxIDMDa6iTTVHjZcvg1U3aFaijCGccXgvsSArHWBMovkdiBIh78VzlfZ
         fvk37bzRhCeGamyxyD1FHcTa4XI1P0oHXYCtHfSpWOfK8NhL4O5BOF1aTRma9apozgG9
         NmbobPmtqhqqVF4D7XXNDHUEpMOWgdZ/Le8iUK+iZF7B1SnOTQgvt1AD/xRID16lKxO5
         VsbMXIZLJxkov5CFSjsL+u3WzQ+vk4SQkWppj5OGZxe5bhZI9jKKScQCbvHAT2o/XS6s
         IWqGweuO4eg1YBANuQJIaDUTNUQNEAohm1KNqDWyM90N+4v83EXzMksHK7xQycQtGhwN
         4DEg==
X-Gm-Message-State: AOAM530Wno3lC2Urs5/DQVNaP2YmTdzfOsrJpLMzpnVaIy/CwTH7708A
        Y2A6WCN8F/ZyS20YzY1kMGR5jA==
X-Google-Smtp-Source: ABdhPJzl4Vrq/QRbkBM4FomjeaphxU5sXbCQxtJYd9CPvIIO0XxkpZELdyspJ/O3yLnyZ0s+vxSlsQ==
X-Received: by 2002:a05:622a:248:: with SMTP id c8mr3597978qtx.122.1614277639012;
        Thu, 25 Feb 2021 10:27:19 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id l65sm4519678qkf.113.2021.02.25.10.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 10:27:18 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] crypto: qce: common: Make result dump optional
Date:   Thu, 25 Feb 2021 13:27:11 -0500
Message-Id: <20210225182716.1402449-3-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225182716.1402449-1-thara.gopinath@linaro.org>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
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

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/common.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 7c3cb483749e..2485aa371d83 100644
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

