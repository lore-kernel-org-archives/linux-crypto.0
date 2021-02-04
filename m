Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30C23C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:46:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1A1C64F8C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:46:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhBDVpu (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:45:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbhBDVpo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:45:44 -0500
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E20C06121F
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:08 -0800 (PST)
Received: by mail-qv1-xf34.google.com with SMTP id j13so2487382qvu.10
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KOavuKeXCTpivEkIf3Cid67Tg4gQisaxPtYIjIwqF5A=;
        b=NPi6B5Gezo05TbeR+EcOfPoFg/pw7If1e3RInE7Jmrx4CxNsD8bfMF70v2XvWJTMWF
         JMv+lw8DZ6u6tPwSEdPRh+mgTva4Tz7vB49GetLQghyY6LUZoV7oeT9XsO2GVVf0g6Ig
         re1ksST7JCk0boamf4+FYG/3s/prT/QPwcYqNtk6XZNdVW374eID8nDWrVsEGYBBGZEC
         lBftR+NzInUVKNBtsjRzSjIRPdQyA9mSX0XnjISpYzkQm4iWdFR/XWYCSYjWjE1TnJWf
         fWfL+fGS2wVcPuMNYbZdBIJfnqYclnHEf/ieLqfiqTyZIBiMYKMfnj4JvZdicJERanT/
         4irA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KOavuKeXCTpivEkIf3Cid67Tg4gQisaxPtYIjIwqF5A=;
        b=YNqQ5Wq/2ThMWaY6UxFP5Pzm2tUYpylDfZjxEePGlkrPTraLewX8ttnn5KmQdMTWmL
         gTG2szS23Bz4NIm7edBeXc5cpm0bb3BBNHZVg+bjC1Kthwvpaln50Bso0qnzoU13qGEb
         2iUBYMy1PjfQGQXU7WVjMGDzFbUWacDVuaY2mMhTAjczdsr3ZJSU3Sj0RfXwl7y2RhgC
         PyP/Y6Fv0roAlvXwsznaqD3A2KAzSedlkyB1ZgJzrGtjBoFHtdEPRS88HoBG4Ym5ko/t
         skVXQrJx9GTPUoG1RnMzqka9mmsNXQE5nKaQ9OzDBRpiWYBrrOy/GVoFgvGmHsFcjGkq
         +6nA==
X-Gm-Message-State: AOAM532Mcp0M4ModOE+Dr5fcJdRNVt5PwZxkbS5TBPJ2OppaFUg2SIvT
        DSN2rTahvFGK99HZZNMKHHYndA==
X-Google-Smtp-Source: ABdhPJy4yOC70z/WGlQc9RvAOE/AxDXPqeHNVhvg6ghkDag/ePq5+z0yabq1ZG1Fn0K6R2w2zo2zNw==
X-Received: by 2002:a05:6214:949:: with SMTP id dn9mr1319029qvb.35.1612475048140;
        Thu, 04 Feb 2021 13:44:08 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id h185sm6353858qkd.122.2021.02.04.13.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:44:07 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 08/11] crypto: qce: skcipher: Improve the conditions for requesting AES fallback cipher
Date:   Thu,  4 Feb 2021 16:43:56 -0500
Message-Id: <20210204214359.1993065-9-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204214359.1993065-1-thara.gopinath@linaro.org>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
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

