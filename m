Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 681A6C433DB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:46:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2348F64E7B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:46:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbhBDVqM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhBDVp1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:45:27 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BC4C061356
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:06 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id es14so2507326qvb.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Uh3JollLTG+dAe2nrFPwv+L2m02OQeUEuYSFXryNKA=;
        b=jWvRhrxq+HtoVbJ25dNRu4xY6VYR7oLRLfdcUcDb3o6gS7Y9vSJzF128Jsn+iZp069
         q2JeXO3v22fmSx2/3k3hUmSS9uqWtZwLlWmQVmLfe6JdRSmRjy3h38i9Zk6q+kO0nRS5
         Hx/cTtDxXQBa/I3Okgtk/xYpbKWtUwL5jMSnwp3SQUrCsMWo4e783xGbbaQiPZ9Z58VR
         AcCu0GNvHBOqpFb4xc4hHfccp2cedZY7CUcQFEv71eyKmRZE6TxfsRWRNkW2CPX+JZAm
         L7SyL/xhd8rnw8vZtBFhFObWhJ7+vFBI3lkgzBez1/X2pb0EpzKYr89Yoks7r5bB0xFK
         0sZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Uh3JollLTG+dAe2nrFPwv+L2m02OQeUEuYSFXryNKA=;
        b=N3qfD//D9QUkNzLIhhqGlX1KLyNluNteBqVGj9ZtnENQzYgkQppScsOUXTF3re3AyZ
         b/O/QR2ML+mNPQzlScoZDC9WvPy6SnlkEBDmnrvGj9b4G0qaiiqRw/ILE8WgUEvGfaq7
         4cjhryDMh+H7BdkbKx3cs6aT+D6vw/iViQrtrbQRm6aMqb4O9Uv4vco5fQOYN0G/N1vf
         /jBewBt7B7CTF6pI/dUyfTYceIxyyX3J6H89tWC08tCH6j3iTH/RKHa9+5NNp/is7Wzs
         feh0don9Ze16sH+5FFjOl5Z7qqs+I3ko/V0e/v31T0CIgo/6tgg7euUfnPrHSlr7YRT7
         ljlw==
X-Gm-Message-State: AOAM5315DkWBFKtJOq49mC25DMD0d5iXA3NnyPzknja1iKnO3Q9qj3KI
        OYG9LGcQrx76l2HXifHwWOGg3A==
X-Google-Smtp-Source: ABdhPJwFnleRuZpSk7iDPWk0gesGQ3eIaN0XEEIqiVUB9TX09uPEQ7gwk6c/AtTAFDksrbTF3k84UA==
X-Received: by 2002:a05:6214:324:: with SMTP id j4mr1547471qvu.53.1612475046183;
        Thu, 04 Feb 2021 13:44:06 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id h185sm6353858qkd.122.2021.02.04.13.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:44:05 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 06/11] crypto: qce: skcipher: Return error for non-blocksize data(ECB/CBC algorithms)
Date:   Thu,  4 Feb 2021 16:43:54 -0500
Message-Id: <20210204214359.1993065-7-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204214359.1993065-1-thara.gopinath@linaro.org>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

ECB/CBC encryption/decryption requires the data to be blocksize aligned.
Crypto engine hangs on non-block sized operations for these algorithms.
Return invalid data if data size is not blocksize aligned for these
algorithms.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/skcipher.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 331b3c3a5b59..28bea9584c33 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -254,6 +254,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	struct qce_alg_template *tmpl = to_cipher_tmpl(tfm);
+	unsigned int blocksize = crypto_skcipher_blocksize(tfm);
 	int keylen;
 	int ret;
 
@@ -265,6 +266,17 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	if (!req->cryptlen)
 		return -EOPNOTSUPP;
 
+	/*
+	 * ECB and CBC algorithms require message lengths to be
+	 * multiples of block size.
+	 * TODO: The spec says AES CBC mode for certain versions
+	 * of crypto engine can handle partial blocks as well.
+	 * Test and enable such messages.
+	 */
+	if (IS_ECB(rctx->flags) || IS_CBC(rctx->flags))
+		if (!IS_ALIGNED(req->cryptlen, blocksize))
+			return -EINVAL;
+
 	/* qce is hanging when AES-XTS request len > QCE_SECTOR_SIZE and
 	 * is not a multiple of it; pass such requests to the fallback
 	 */
-- 
2.25.1

