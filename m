Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DD6C43460
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 13:25:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56C4D61207
	for <linux-crypto@archiver.kernel.org>; Sat, 17 Apr 2021 13:25:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhDQNZm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 17 Apr 2021 09:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236476AbhDQNZj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 17 Apr 2021 09:25:39 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA7EC061343
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 06:25:09 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id c6so22892293qtc.1
        for <linux-crypto@vger.kernel.org>; Sat, 17 Apr 2021 06:25:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wHIdoU8gmuAA7x+QZ3612OOOxooCO7GWN9KlzMj4N6o=;
        b=S17KbURCUpZNTFZRI3ov8tYohPpRByCDYTX1Rp+AYbXROoZLa+hTebxUdYlFiARuPL
         Lop0QnYOspwlcaX0Hplpwtt/ePYmWK3UUFpElioIONoTNBMivQyWEiOvnTtx72zf4Qhb
         +JNjFHqH8DQFYGUAms5scXf/t1/nI+f5042wteln6XB+vjtWrdh2lKND1lui+4zqR38T
         tla358GDDTjKtOlyQrG/Q8phisY0FSiI8zGYdOwh0Ha2uLx7DurX1WbCmE7x3bAB804N
         PmGAuFNDRHw/lUiBX4ukgu3Rc896iys2UydSnGFy3ogPJIkzo2sSsLgc9GWW0BbCFE8d
         rMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wHIdoU8gmuAA7x+QZ3612OOOxooCO7GWN9KlzMj4N6o=;
        b=mja+zthB2smaohTrS3MZcU5s+WQ8j/vU6T/0hAT9xgjt1DJH9edgM8KF4aclZapQ0i
         9Jki3WNBhOitSKdBXWDgfg/svQygesAON/g8Ho6IAipQMOHbTxwYtobrfqNAGuqpyKdR
         DLPqAu94Pe9iKbni4DQby/Voq+nIKCMkL8ONTxU+FTX+is3pgd+KejOzPT27HuV36k36
         xap9iDS4qlSFSHWqwPbr7+VnOAs1TxWGZkhk8t/3xypFRDox20Kw3jZ/Cl6gz8qIhQLf
         Ue3WMgljjnPr1WjUZ7HatR2ulXeuklFiUCF21iwYgste2JEyOmwpUwJjKw7GbqULTXZo
         pmIA==
X-Gm-Message-State: AOAM5300iVzhTFWrTZUB7nabO6SfCCNY+3ESOvzS3UvLA2T2IXgz89z8
        Xv8RbzbP4eYwjk5X4bZkkhmQag==
X-Google-Smtp-Source: ABdhPJzVL6A6xc2X3SnXKGTMVYa/7RnY+KFtSIKvmzEMA7SLS1jkWrk3lOVqP14M0vuAjkZcQd1Alg==
X-Received: by 2002:a05:622a:4d3:: with SMTP id q19mr3771354qtx.55.1618665909081;
        Sat, 17 Apr 2021 06:25:09 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id o25sm1988327qtl.37.2021.04.17.06.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Apr 2021 06:25:08 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v2 5/7] crypto: qce: common: Clean up qce_auth_cfg
Date:   Sat, 17 Apr 2021 09:25:01 -0400
Message-Id: <20210417132503.1401128-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210417132503.1401128-1-thara.gopinath@linaro.org>
References: <20210417132503.1401128-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove various redundant checks in qce_auth_cfg. Also allow qce_auth_cfg
to take auth_size as a parameter which is a required setting for ccm(aes)
algorithms

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/common.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/crypto/qce/common.c b/drivers/crypto/qce/common.c
index 7b5bc5a6ae81..7b3d6caec1b2 100644
--- a/drivers/crypto/qce/common.c
+++ b/drivers/crypto/qce/common.c
@@ -97,11 +97,11 @@ static inline void qce_crypto_go(struct qce_device *qce, bool result_dump)
 }
 
 #ifdef CONFIG_CRYPTO_DEV_QCE_SHA
-static u32 qce_auth_cfg(unsigned long flags, u32 key_size)
+static u32 qce_auth_cfg(unsigned long flags, u32 key_size, u32 auth_size)
 {
 	u32 cfg = 0;
 
-	if (IS_AES(flags) && (IS_CCM(flags) || IS_CMAC(flags)))
+	if (IS_CCM(flags) || IS_CMAC(flags))
 		cfg |= AUTH_ALG_AES << AUTH_ALG_SHIFT;
 	else
 		cfg |= AUTH_ALG_SHA << AUTH_ALG_SHIFT;
@@ -119,15 +119,16 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size)
 		cfg |= AUTH_SIZE_SHA256 << AUTH_SIZE_SHIFT;
 	else if (IS_CMAC(flags))
 		cfg |= AUTH_SIZE_ENUM_16_BYTES << AUTH_SIZE_SHIFT;
+	else if (IS_CCM(flags))
+		cfg |= (auth_size - 1) << AUTH_SIZE_SHIFT;
 
 	if (IS_SHA1(flags) || IS_SHA256(flags))
 		cfg |= AUTH_MODE_HASH << AUTH_MODE_SHIFT;
-	else if (IS_SHA1_HMAC(flags) || IS_SHA256_HMAC(flags) ||
-		 IS_CBC(flags) || IS_CTR(flags))
+	else if (IS_SHA1_HMAC(flags) || IS_SHA256_HMAC(flags))
 		cfg |= AUTH_MODE_HMAC << AUTH_MODE_SHIFT;
-	else if (IS_AES(flags) && IS_CCM(flags))
+	else if (IS_CCM(flags))
 		cfg |= AUTH_MODE_CCM << AUTH_MODE_SHIFT;
-	else if (IS_AES(flags) && IS_CMAC(flags))
+	else if (IS_CMAC(flags))
 		cfg |= AUTH_MODE_CMAC << AUTH_MODE_SHIFT;
 
 	if (IS_SHA(flags) || IS_SHA_HMAC(flags))
@@ -136,10 +137,6 @@ static u32 qce_auth_cfg(unsigned long flags, u32 key_size)
 	if (IS_CCM(flags))
 		cfg |= QCE_MAX_NONCE_WORDS << AUTH_NONCE_NUM_WORDS_SHIFT;
 
-	if (IS_CBC(flags) || IS_CTR(flags) || IS_CCM(flags) ||
-	    IS_CMAC(flags))
-		cfg |= BIT(AUTH_LAST_SHIFT) | BIT(AUTH_FIRST_SHIFT);
-
 	return cfg;
 }
 
@@ -171,7 +168,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 		qce_clear_array(qce, REG_AUTH_KEY0, 16);
 		qce_clear_array(qce, REG_AUTH_BYTECNT0, 4);
 
-		auth_cfg = qce_auth_cfg(rctx->flags, rctx->authklen);
+		auth_cfg = qce_auth_cfg(rctx->flags, rctx->authklen, digestsize);
 	}
 
 	if (IS_SHA_HMAC(rctx->flags) || IS_CMAC(rctx->flags)) {
@@ -199,7 +196,7 @@ static int qce_setup_regs_ahash(struct crypto_async_request *async_req)
 		qce_write_array(qce, REG_AUTH_BYTECNT0,
 				(u32 *)rctx->byte_count, 2);
 
-	auth_cfg = qce_auth_cfg(rctx->flags, 0);
+	auth_cfg = qce_auth_cfg(rctx->flags, 0, digestsize);
 
 	if (rctx->last_blk)
 		auth_cfg |= BIT(AUTH_LAST_SHIFT);
-- 
2.25.1

