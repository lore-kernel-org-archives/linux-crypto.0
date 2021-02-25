Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CFE4C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6A9D64E6C
	for <linux-crypto@archiver.kernel.org>; Thu, 25 Feb 2021 18:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhBYS3i (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 25 Feb 2021 13:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233329AbhBYS3A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 25 Feb 2021 13:29:00 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5DDC0617AB
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:24 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id b3so4796207qtj.10
        for <linux-crypto@vger.kernel.org>; Thu, 25 Feb 2021 10:27:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GAQ7mJYjum/vJpvXxz96AjXoLhaENBWrKzXJpZF6Wpc=;
        b=Xm9ESYbMwNOE9d/S9JmjWwMQHdzA3z/nIxKsXy8gYGkLDEspN18hoo9Gg+YLcR7F5I
         9RTdXgBd+E1pV26DsDLCd0Y+Iad5pbS/lOktAImnzW1/rihvkwAWN8NBUu7BYevRSIdk
         5rUES/n/jujaK1YKrTTrDtmfXS5KM+Xdz4Gc5HUrB5OK7RAaVtiSKn27rcmFgcjOJsP+
         Z9Fd15Mh3XcCcgsl+ReyQ4VlmqbuvItEMQwxRixASWUQJEI2VOe0khPyGpqL7bQB7xby
         cxy49D6ejeI4lft6DCZEGc1c8DMZ8CW5C1VXgOlMXBwS8iKXf8cB8g2AGp8TNoroaVXv
         UJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GAQ7mJYjum/vJpvXxz96AjXoLhaENBWrKzXJpZF6Wpc=;
        b=UXhqSjCy83WB3RPd4R4TEoO5B6aJZSA3wYXK4WfTKvA8b0jivrMCZtAj8J3iHGBZ1a
         51kWWSNa3hjA/IckZ2bqfk7f24Ha4DW5woTAXFeQbeECAMR0uAoqOBAiCYsxmW3bixfV
         2dlkfQA1Sw6jf068Hf8SIDTc5x5dXuJR6Fmu+tMtFBKCZRUPv4AXcYMrQzeR1LXN/Dn+
         hKfMGQuVZIlPwauKI5FpcLjCTy5alF688Frt7eveg8DcurD9t2n5UIUCEtr22UAr0jo2
         2Yl0a+pa4zEIRYuwjehOwOSubOUiKSzI8bWGZqDUJx8JJl5HyKl9ZqiRzXXhIYOvCdtW
         3OXw==
X-Gm-Message-State: AOAM5337C7k/UZWT7/uwN2wg9rlvyNFxy3/R0X7sE+bE+nRLTHcASFEs
        +glw/H4VSMwx0d0xw4f2N7eIvg==
X-Google-Smtp-Source: ABdhPJw2SSTy64tUoAgaghU1OpMCJ6pdO42iTlQ95MbLnZjpvIcfQbD0Bi1vwt/WdBjRa4g8YsCM8g==
X-Received: by 2002:ac8:45d3:: with SMTP id e19mr3686016qto.232.1614277641834;
        Thu, 25 Feb 2021 10:27:21 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id l65sm4519678qkf.113.2021.02.25.10.27.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 10:27:21 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] crypto: qce: common: Clean up qce_auth_cfg
Date:   Thu, 25 Feb 2021 13:27:14 -0500
Message-Id: <20210225182716.1402449-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210225182716.1402449-1-thara.gopinath@linaro.org>
References: <20210225182716.1402449-1-thara.gopinath@linaro.org>
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
index 2485aa371d83..05a71c5ecf61 100644
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

