Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C091C433DB
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:05:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18A6064E4D
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Feb 2021 20:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbhBKUFI (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Feb 2021 15:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhBKUDF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Feb 2021 15:03:05 -0500
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84B49C0617A9
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:36 -0800 (PST)
Received: by mail-qk1-x729.google.com with SMTP id w19so6064992qki.13
        for <linux-crypto@vger.kernel.org>; Thu, 11 Feb 2021 12:01:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YQw1QuSS5oaizNhzVqE2AsZ3JEvDzAP/RbpFDDieAO4=;
        b=elxvkxijIo5vM1d01jehM7Zocli7jXl4HHZG/sZjNMJgPZ5LJyofQWYcHuMde1I/OR
         tOryM5IAtZIQQ6EOCGjoC0dtjeVvxyT2L06Sx29SvB+/CUKZNMGKaGTz4YyFbSeM4xGE
         bOoEkE5moR10oJi0cJP3Nlk5iwsqCXT0mc6O3WiR1I6hib2MLVk24ecLg7jtSPIMfwvY
         aOr3dUrRbuXA6D0nEdLncYFbf4JkEd+azicP7JdWkYCxpQKUnYsnGTRSYQ6XvWiVgTHO
         SsePqoYsJ8XHMrOvUhDX5VllRl70bdotzaIfJ2v6tJv9O91rS8o5gnOsnMNW4a80u4sl
         6aUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YQw1QuSS5oaizNhzVqE2AsZ3JEvDzAP/RbpFDDieAO4=;
        b=drnu+D85mauabfLkwAo3hTQqe/GnsseMQfrC301sqVCirpblDaystaD7HRzQcgCEKo
         ht9p9WKNvM0v4YPaNU5p/kPEltDRmmPOrAgvsAnjXPROkwBU8RiI11D2BqE7s1TAPPT4
         ul341KtYZY0dsmPFRvkMhxuDdT/4UVHvfiv/KdKYUoQCJMMKTv8L3BrzeahRmuI5s8fE
         yudZSr6yZ89Ybtt9qRhSiduV4JCRUsCDyvjmU94wBfNQkaaeWuZLd03O4xE+ZDOYdJKc
         56vZNXWo/gQpAfIVA3oFlM5aHSw4Y4jHZWptfLI6QrVznFtQ6sfY+Kio7OnOlpz5gZ0E
         tE0A==
X-Gm-Message-State: AOAM532IHvSWYrwNc93dGtY0ZcDVRAD+3N1ZI2s5B6KqjBiwmPm8mvn6
        l8dL8NY5m27vt4S2oQDjbOgYoA==
X-Google-Smtp-Source: ABdhPJwqV8TTmTDV/MNPHbMNaxvX97vyW5TwjdtKpAPfmXXejoK4X9Nm/uFxEipPKycpsB+ztsLf9w==
X-Received: by 2002:ae9:eb95:: with SMTP id b143mr10182741qkg.442.1613073695803;
        Thu, 11 Feb 2021 12:01:35 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id 17sm4496243qtu.23.2021.02.11.12.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 12:01:35 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 06/11] crypto: qce: skcipher: Return error for non-blocksize data(ECB/CBC algorithms)
Date:   Thu, 11 Feb 2021 15:01:23 -0500
Message-Id: <20210211200128.2886388-7-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211200128.2886388-1-thara.gopinath@linaro.org>
References: <20210211200128.2886388-1-thara.gopinath@linaro.org>
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

v5->v6:
	- Remove the wrong TODO which implied that AES CBC can do partial
	  block sizes when it is actually CTS mode that can as pointed
	  out by Eric Biggers.

 drivers/crypto/qce/skcipher.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 6b3dc3a9797c..c2f0469ffb22 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -254,6 +254,7 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct qce_cipher_reqctx *rctx = skcipher_request_ctx(req);
 	struct qce_alg_template *tmpl = to_cipher_tmpl(tfm);
+	unsigned int blocksize = crypto_skcipher_blocksize(tfm);
 	int keylen;
 	int ret;
 
@@ -265,6 +266,14 @@ static int qce_skcipher_crypt(struct skcipher_request *req, int encrypt)
 	if (!req->cryptlen)
 		return 0;
 
+	/*
+	 * ECB and CBC algorithms require message lengths to be
+	 * multiples of block size.
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

