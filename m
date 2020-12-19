Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA186C3526F
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 03:32:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8576423BB5
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 03:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgLSDcB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 22:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgLSDbv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 22:31:51 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D58C0611CF
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 19:30:36 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id c14so2921755qtn.0
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 19:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vm+9qcF9rEIBSxmXyE4c8CtzzHn6VqYs01p3AiQrvhM=;
        b=WmRig25OaCsRJ99xFfK78CHrKjJIOl6awPj8EWWovr/HiqgKw+BM3VA4F781QEXA6N
         zKJpgC6gCIZv4Y0IU/w6pCQ75INjpeNX5+QwGFMiaxcbU8HdoCxteLafRGMa+Dl8B3E3
         LzCUo4k0ZhFn2FeAl0CLQKk5kTtpCoWxaksrQ8PELgRYyWKMa3UhMWEgF7cte9kBEJil
         lTlz74K9NhUUN8/vfKPEEy9b+mkCfINIOqMXkPN2GSthb542YqC/jrO2NJ7YtuIzQgCU
         auJi3hknIu4lhzEOkAV/gomLjCsHALqjbCkYEUSwDGJrOm4vFh6j0PUSINi1TdYbD3y6
         FTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vm+9qcF9rEIBSxmXyE4c8CtzzHn6VqYs01p3AiQrvhM=;
        b=HcnA99iCZBYiv2YMCKPXQgAhUCUza1RCmQ7HHNzHS8IKmEdeIYK0vdmn9/xLUfOVHM
         ruJokolTpDsz5cWxJzc9a1Q/I88kb6XdflC/5uoBq3pi89Gvtukn0FqWWCBcmtCTBcKw
         3wfFuXiqs5lnXMbb8dM1X2CiwkMYjS5W/JcmZa+I7BDedCw4DWt2bpH1gZQrfMaOhYSy
         GtbtWCG73Py7djvemQbJhszFRgx++wv8AiVwFTa5U+Petz4MQlu3hIuMycqUzePKcfGj
         93oO6JH8d06oIQ6h/bGlBYPH2o23NlFanv/ALnub3Hgey5g1LqUwmuycm1QClLjM5h5v
         XxbA==
X-Gm-Message-State: AOAM5323yWgLRstHlMq/cMtK49ytx/z/t6WolHZiaHPdrDLigE6+Bt7g
        ATzYpbDPCEDmmDRDPpQcXcVeKA==
X-Google-Smtp-Source: ABdhPJz53RSzEvan2x1REnQTGXw5GqqYIS5EeqHMfwvsXVoVSFZedLDA5vXpQ9YRZI3u4OnYjfMmHw==
X-Received: by 2002:ac8:6f77:: with SMTP id u23mr7328806qtv.118.1608348635518;
        Fri, 18 Dec 2020 19:30:35 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id y16sm4376045qki.132.2020.12.18.19.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 19:30:34 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] drivers: crypto: qce: Remove totallen and offset in qce_start
Date:   Fri, 18 Dec 2020 22:30:27 -0500
Message-Id: <20201219033027.3066042-7-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201219033027.3066042-1-thara.gopinath@linaro.org>
References: <20201219033027.3066042-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

totallen is used to get the size of the data to be transformed.
This is also available via nbytes or cryptlen in the qce_sha_reqctx
and qce_cipher_ctx. Similarly offset convey nothing for the supported
encryption and authentication transformations and is always 0.
Remove these two redundant parameters in qce_start.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/common.c   | 17 +++++++----------
 drivers/crypto/qce/common.h   |  3 +--
 drivers/crypto/qce/sha.c      |  2 +-
 drivers/crypto/qce/skcipher.c |  2 +-
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 7ae0b779563f..e292d8453ef6 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -139,8 +139,7 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size)
 	return cfg;
 }
 
-static int qce_setup_regs_ahash(struct crypto_async_request *async_req,
-				u32 totallen, u32 offset)
+static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 {
 	struct ahash_request *req = ahash_request_cast(async_req);
 	struct crypto_ahash *ahash = __crypto_ahash_cast(async_req->tfm);
@@ -305,8 +304,7 @@ static void qce_xtskey(struct qce_device *qce, const u8 *enckey,
 	qce_write(qce, REG_ENCR_XTS_DU_SIZE, cryptlen);
 }
 
-static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
-				     u32 totallen, u32 offset)
+static int qce_setup_regs_skcipher(struct crypto_async_request *async_req)
 {
 	struct skcipher_request *req = skcipher_request_cast(async_req);
 	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
@@ -366,7 +364,7 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
 
 	qce_write(qce, REG_ENCR_SEG_CFG, encr_cfg);
 	qce_write(qce, REG_ENCR_SEG_SIZE, rctx->cryptlen);
-	qce_write(qce, REG_ENCR_SEG_START, offset & 0xffff);
+	qce_write(qce, REG_ENCR_SEG_START, 0);
 
 	if (IS_CTR(flags)) {
 		qce_write(qce, REG_CNTR_MASK, ~0);
@@ -375,7 +373,7 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
 		qce_write(qce, REG_CNTR_MASK2, ~0);
 	}
 
-	qce_write(qce, REG_SEG_SIZE, totallen);
+	qce_write(qce, REG_SEG_SIZE, rctx->cryptlen);
 
 	/* get little endianness */
 	config = qce_config_reg(qce, 1);
@@ -387,17 +385,16 @@ static int qce_setup_regs_skcipher(struct crypto_async_request *async_req,
 }
 #endif
 
-int qce_start(struct crypto_async_request *async_req, u32 type, u32 totallen,
-	      u32 offset)
+int qce_start(struct crypto_async_request *async_req, u32 type)
 {
 	switch (type) {
 #ifdef CONFIG_CRYPTO_DEV_QCE_SKCIPHER
 	case CRYPTO_ALG_TYPE_SKCIPHER:
-		return qce_setup_regs_skcipher(async_req, totallen, offset);
+		return qce_setup_regs_skcipher(async_req);
 #endif
 #ifdef CONFIG_CRYPTO_DEV_QCE_SHA
 	case CRYPTO_ALG_TYPE_AHASH:
-		return qce_setup_regs_ahash(async_req, totallen, offset);
+		return qce_setup_regs_ahash(async_req);
 #endif
 	default:
 		return -EINVAL;
diff --git a/drivers/crypto/qce/common.h b/drivers/crypto/qce/common.h
index 85ba16418a04..3bc244bcca2d 100644
--- a/drivers/crypto/qce/common.h
+++ b/drivers/crypto/qce/common.h
@@ -94,7 +94,6 @@ struct qce_alg_template {
 void qce_cpu_to_be32p_array(__be32 *dst, const u8 *src, unsigned int len);
 int qce_check_status(struct qce_device *qce, u32 *status);
 void qce_get_version(struct qce_device *qce, u32 *major, u32 *minor, u32 *step);
-int qce_start(struct crypto_async_request *async_req, u32 type, u32 totallen,
-	      u32 offset);
+int qce_start(struct crypto_async_request *async_req, u32 type);
 
 #endif /* _COMMON_H_ */
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index 02d89267a806..141cfe14574d 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -107,7 +107,7 @@ static int qce_ahash_async_req_handle(struct crypto_async_request *async_req)
 
 	qce_dma_issue_pending(&qce->dma);
 
-	ret = qce_start(async_req, tmpl->crypto_alg_type, 0, 0);
+	ret = qce_start(async_req, tmpl->crypto_alg_type);
 	if (ret)
 		goto error_terminate;
 
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 936bfb7c769b..2f327640b4de 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -143,7 +143,7 @@ qce_skcipher_async_req_handle(struct crypto_async_request *async_req)
 
 	qce_dma_issue_pending(&qce->dma);
 
-	ret = qce_start(async_req, tmpl->crypto_alg_type, req->cryptlen, 0);
+	ret = qce_start(async_req, tmpl->crypto_alg_type);
 	if (ret)
 		goto error_terminate;
 
-- 
2.25.1

