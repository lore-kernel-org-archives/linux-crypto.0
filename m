Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 983AEC433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60A3164E50
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhBGOmd (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 09:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbhBGOlx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 09:41:53 -0500
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E11C06121D
        for <linux-crypto@vger.kernel.org>; Sun,  7 Feb 2021 06:39:56 -0800 (PST)
Received: by mail-qv1-xf29.google.com with SMTP id p12so941221qvv.5
        for <linux-crypto@vger.kernel.org>; Sun, 07 Feb 2021 06:39:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tYyfVG373bOpf6eoJSEUDGRo4VSC1owsiW4MHt1XZKU=;
        b=O3zpXEieJu8dijkZH819LMHZyBYAVRE+NoWQvj51zMmfUVeZXlEv+jr5AMevaUmQeS
         S+KcJhHtZh3AT78cURRekswY85PKUJqn6JsxPDubcd3I0rR3AB7zIM40FQTGqZ2lMUe3
         Y+1DU4arwyLiYDsAcdP1i0Mv9NIns1NefG1RK1qI2jyP2TMxvEpegwzUMqai0t+kSV6u
         fWgRV05gzK9jMK7wJahDjZQlooHi+A//yi/m0vX0DcO2rXtd05gJdnnirrkqp5Jza6FL
         iHMxn+S4i2GwdNHh86QuG/Thi2PRGHycm01oLUoz89BrUI+YEyp9qpZ9J/5wW/EHS0g2
         GQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tYyfVG373bOpf6eoJSEUDGRo4VSC1owsiW4MHt1XZKU=;
        b=rYRMSV4zhzr+yVn6MafZ8CbggYTKAvhEKP3GS9HKfyH+jYBDpYD9qC0mV/wpaAoiIA
         YzFk7xYqMihWim8k8tguLC/RiSr9sYntYNWKBFTpv/srpQKkne+4hjACag7pkUuU0tuk
         YHw+Q9eE/6LO1CkIaZxi2zwh3F7kLQcMeEG6Wq2WtfFlK1WFodm8dRpZbgpt4VcQ/Cb0
         O8PZt4cdFhhQbKu2fjTsdZZkjx/pKDk6w/PA9Ui07U70yI7wodxtK47XDgAg22OQa489
         5hoqdxFrc+lhCPbG6B3NUItQYidaJzEUBr21TTzBnmokzb7caoDy1YMbcqcqQhXrRvQh
         S3jw==
X-Gm-Message-State: AOAM532hNY/SZ9zivMk+U8LfQOEfjQST3f2+/yr2MzaAubPswZG0sJ/a
        uIbwa0VIoInxPmHprDbBropKTg==
X-Google-Smtp-Source: ABdhPJxLviqfQVDEJM157AAA3ddG+c2jzrFkLrTsy8bJjwx+E3o+5wskSsL97cd75A3wHzAUAjNb8w==
X-Received: by 2002:a05:6214:522:: with SMTP id x2mr12733825qvw.13.1612708795396;
        Sun, 07 Feb 2021 06:39:55 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c81sm13941493qkb.88.2021.02.07.06.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 06:39:54 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 08/11] crypto: qce: skcipher: Improve the conditions for requesting AES fallback cipher
Date:   Sun,  7 Feb 2021 09:39:43 -0500
Message-Id: <20210207143946.2099859-9-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207143946.2099859-1-thara.gopinath@linaro.org>
References: <20210207143946.2099859-1-thara.gopinath@linaro.org>
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
index 64f661d7335f..66a226d1205e 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -274,14 +274,19 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
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

