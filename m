Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F169C433ED
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 15:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D131961453
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 15:07:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240761AbhD2PIM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Apr 2021 11:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240646AbhD2PIC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Apr 2021 11:08:02 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EF86C06134B
        for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2021 08:07:15 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id o12so1690633qtx.8
        for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2021 08:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wHIdoU8gmuAA7x+QZ3612OOOxooCO7GWN9KlzMj4N6o=;
        b=Eo/0W8k3MDkCy/5T8LYxOiJ5zzg//aKA86ek1qmqe6/Qx3qbvqYEXvUfnDGpUj04rM
         D66xFlNx0QVzc/PjY9hkywdCUc/5HhB6ULrEHhUcItF3GlgE2hpvFvDWGZBENhAxXmqT
         9o0Ht774VeqIOxWGjXzDJ1VYWlc9Yhp1H6O+X8uaujkYpjBxSYcv+OTLVmaZR1atP57z
         KXbLXoHZ8SS8DRvm8tRbzFc5r4pzgi1Dfw88lrWIoPddngPnOhNb9tg9q570LMekBkub
         EqYhQG79TxzGcpVn9lfwecXn088EMtbLAUT+HNosabN84WvTEH009DO2tmwA0KsQ5g6S
         JvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wHIdoU8gmuAA7x+QZ3612OOOxooCO7GWN9KlzMj4N6o=;
        b=FjjqgcdEk71EtC5EuysSr5P7fQrReDDpgPt2ppQ9P8I2+gTnItUaLFXwG1XCv0aTNW
         ULndHhg9fkXpnPx4bRcoCgra7byHtfUChnJ4mLnMeDA4Fbh73zrYnk2T3x980phrCjID
         TDtygg5qCdgoAtV7qbRwxuSIcU2totlTY6W0FXPFulmqPmBqW6+hxQYF1f2Rrcx8GVA4
         pGMp97GgMIJ5wUx7QcW3TSZuQ/v90wU8Qu29TszLgx9i7ePf5rNdEoxd/HFknEqWKnbP
         b86ATWOjmGeCKkHy9NH/pSgxeM2HeYWtauy0y0ZXgF47KeRLgsP01su+pQb50Z0IlEBZ
         draQ==
X-Gm-Message-State: AOAM532zJSgD+9bmBlhR4xvY+cJKqF2tY3NtCkVfC7CuaXsiLmX19E/h
        TlGDBAZ+SUKph8qfb//adb4zNw==
X-Google-Smtp-Source: ABdhPJwrcvP8FyhjF0NE9iu4zMhaBmjY6UPCC5gumK1K0uSbay1hsQu4okNW2++2dDRibdJ1ODuQJQ==
X-Received: by 2002:ac8:4e52:: with SMTP id e18mr32024005qtw.297.1619708834201;
        Thu, 29 Apr 2021 08:07:14 -0700 (PDT)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id j191sm2223822qke.131.2021.04.29.08.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 08:07:13 -0700 (PDT)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [Patch v4 5/7] crypto: qce: common: Clean up qce_auth_cfg
Date:   Thu, 29 Apr 2021 11:07:05 -0400
Message-Id: <20210429150707.3168383-6-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210429150707.3168383-1-thara.gopinath@linaro.org>
References: <20210429150707.3168383-1-thara.gopinath@linaro.org>
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

