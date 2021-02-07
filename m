Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E168C433DB
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43F8864E50
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhBGOlS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 09:41:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhBGOlM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 09:41:12 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 124A9C0617AA
        for <linux-crypto@vger.kernel.org>; Sun,  7 Feb 2021 06:39:54 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id v206so277886qkb.3
        for <linux-crypto@vger.kernel.org>; Sun, 07 Feb 2021 06:39:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DZiqftGjZZeqxnGuzUfAaT6stfdHVGYnoCL8kLsn0Ng=;
        b=HV2LKtCSh+i1BvBIs4cdUJkJ7QqIfp3lQD/DvNQHYyBC+hrpMdTYljRJiXIIcUyos5
         K4LzMW38DczfHw5ppQpwECuSmoxypC+Tm1blEz3JnUaIkBZgUG3SvSCUcf/ZofzjHPex
         p7BYKI+7aArG29y6+g/GzRStkTLmuO2ZedWLsTKKvigu5zj2tkOolNiorSmuu7Tx8aF7
         MbaMBDUh5R4EBNV2FMHBk1qImlb5ula8JpFnEKog46j9PCQd0lDwXvMUaXlYLeuzYg8r
         ky7ZzvOyJ56M956kGCf69h8iVMZjaJ61OwJbvKaTB0CFA6weUM5ilBd3dwOek7/6LF4c
         Jdgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DZiqftGjZZeqxnGuzUfAaT6stfdHVGYnoCL8kLsn0Ng=;
        b=Gz/C9qdmv67y6PYoFOUk8I7E5dOHPSkYN13GL4qzwmpXuH8EEkwLu36EDADtKgGLQU
         b6G7uRvLtvO0Dx8Ocg9qG0tP7RnVmqonJDmo1zSyOOg7dsbE76Pe3sut4gv+FGnE7ADC
         HfRBzj5vNhWuJrdT1XC8rVxRJmxSB9Z+ktiqpCQJk/BPD8gQ5b4xa9d2Xzcthwr/RdOB
         G9ZpyblVm/cyXEEGViNxuvDxefQAHeelWZJprjDpMAJHPkOP0NVWRV8W2KsaCWIavKQZ
         736oS5znyDTriTziVAdSNVGil6YTiMHHVv55mGeSTdgqlG6nepNSlQzovMtojHIRHVme
         H3sw==
X-Gm-Message-State: AOAM531FYCajEVwIK7P1vNMVGVJn+u1KT6KKTQB+XY3ZFEcTjoSGH9Gf
        QPj1jsa66omjpkhivgYMYCY3Mg==
X-Google-Smtp-Source: ABdhPJx2s2EoII5A0YjyhT3DLNdDEe2ZR+4vcfIY+5nPVvfh3kIJdeqcVV3GQSKkW+oS/fU3HPVZ2w==
X-Received: by 2002:a37:6f06:: with SMTP id k6mr12929201qkc.458.1612708793337;
        Sun, 07 Feb 2021 06:39:53 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c81sm13941493qkb.88.2021.02.07.06.39.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 06:39:52 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 06/11] crypto: qce: skcipher: Return error for non-blocksize data(ECB/CBC algorithms)
Date:   Sun,  7 Feb 2021 09:39:41 -0500
Message-Id: <20210207143946.2099859-7-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207143946.2099859-1-thara.gopinath@linaro.org>
References: <20210207143946.2099859-1-thara.gopinath@linaro.org>
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
index 96af40c2c8f3..d24d96ed5be9 100644
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

