Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAAFFC433E6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A12FF64D5D
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhBCOfm (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233014AbhBCOfN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 09:35:13 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DDBC061352
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 06:33:18 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id n8so9286707qtp.5
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 06:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KOavuKeXCTpivEkIf3Cid67Tg4gQisaxPtYIjIwqF5A=;
        b=tjXUrpvU7pHWfvrvXYj/S15x4BbX3W+mjPb6BS8ryOz/85daM47ObxCtHodeYCxQrs
         5H2IowtHfDUNpKVD9BWvigJOS4NTjFhJ3PnNxCZhvwcWHbRkVGHHI/DRpNZD2yKnHZjP
         5E3hngtmLEV8rcf4BdcUFJUUAGzj3yrCo5aBDdkj9BRSVHsZdZzABtBeidTjwio/YfeI
         jcdBUdhQNK0gv+EIiSCAHEblbtKVrIjPmeiX5FVLCAflU/5FQKb/4hSuCa/XIpEi7gWP
         VfGo8MOKtpiWBoKL0NOG8tV4nXEP0IO/HM+ODDmAgp7JZgvKrIVhyROilTzfwTulVxgo
         +2Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KOavuKeXCTpivEkIf3Cid67Tg4gQisaxPtYIjIwqF5A=;
        b=ebLB6RF4Fg8uk8wynZDvS/b9CrTVEd2puT/MTEsEY6pyhDOK6Za9WZZpD4i/zyVcTr
         wMLWEh0Ny6JN/3gRwT4HH2HP+XeoREKWxtW5YJQpuwZ3WlqW39YLq0XhAec2zA9S32E6
         53jGCt+g3pkANOJS0/fJNot4C74Y40KzNJvVlG5Zz5ckWoWpbLriL1nJudnZ7AXj96o1
         6df+DV1lzmTNSkTJwAeKgThDcFO9isgpJqkZYYAIAMWxsFvOURpdHkCCj/7izLsQ+MSk
         rwM2X/SCarHeQb8G4cKnWnSJmD/+hsnWsgN9WB672LBUACD3xK9WcwbaTo9JNGvXOqZl
         k/kA==
X-Gm-Message-State: AOAM533PXLog0jGJ7i2esfcNlajql0LORiQKNrjPOZKMkXQPJO1/h/iZ
        kzhyrgo2N2AW/V/X9Cru0i18KdWgZbTxUw==
X-Google-Smtp-Source: ABdhPJya8VcEXlABKEPBA544rBPRKObiaVqJx5U86UGjhsGhwW8JWAWTlsLJOCbvohVfEmmm2+Xmtw==
X-Received: by 2002:ac8:5a0e:: with SMTP id n14mr2670962qta.370.1612362797856;
        Wed, 03 Feb 2021 06:33:17 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id v15sm1775433qkv.36.2021.02.03.06.33.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:33:17 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 08/11] crypto: qce: skcipher: Improve the conditions for requesting AES fallback cipher
Date:   Wed,  3 Feb 2021 09:33:04 -0500
Message-Id: <20210203143307.1351563-9-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203143307.1351563-1-thara.gopinath@linaro.org>
References: <20210203143307.1351563-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The following are the conditions for requesting AES fallback cipher.
	-  AES-192
	- AES-XTS request with len <= 512 byte (Allow messages of length
	  less than 512 bytes for all other AES encryption algorithms other
	  than AES XTS)
	- AES-XTS request with len > QCE_SECTOR_SIZE and is not a multiple
	  of it

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/skcipher.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 10e85b1fc0fd..8599250946b7 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -277,14 +277,19 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 		if (!IS_ALIGNED(req->cryptlen, blocksize))
 			return -EINVAL;
 
-	/* qce is hanging when AES-XTS request len > QCE_SECTOR_SIZE and
-	 * is not a multiple of it; pass such requests to the fallback
+	/*
+	 * Conditions for requesting a fallback cipher
+	 * AES-192 (not supported by crypto engine (CE))
+	 * AES-XTS request with len <= 512 byte (not recommended to use CE)
+	 * AES-XTS request with len > QCE_SECTOR_SIZE and
+	 * is not a multiple of it.(Revisit this condition to check if it is
+	 * needed in all versions of CE)
 	 */
 	if (IS_AES(rctx->flags) &&
-	    (((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
-	      req->cryptlen <= aes_sw_max_len) ||
-	     (IS_XTS(rctx->flags) && req->cryptlen > QCE_SECTOR_SIZE &&
-	      req->cryptlen % QCE_SECTOR_SIZE))) {
+	    ((keylen != AES_KEYSIZE_128 && keylen != AES_KEYSIZE_256) ||
+	    (IS_XTS(rctx->flags) && ((req->cryptlen <= aes_sw_max_len) ||
+	    (req->cryptlen > QCE_SECTOR_SIZE &&
+	    req->cryptlen % QCE_SECTOR_SIZE))))) {
 		skcipher_request_set_tfm(&rctx->fallback_req, ctx->fallback);
 		skcipher_request_set_callback(&rctx->fallback_req,
 					      req->base.flags,
-- 
2.25.1

