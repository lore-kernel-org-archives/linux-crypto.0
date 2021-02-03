Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1244C433DB
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9849A64F7C
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbhBCOee (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbhBCOeb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 09:34:31 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2275CC06178B
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 06:33:13 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id a19so23535452qka.2
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 06:33:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qH6pF/G1SFg+K0bTJv0NKKhaRdQW632kFeXNuGpnkfE=;
        b=aFhCdAPN/YL22McZM81VXUVWm6cZq+icW7D7mDIbkcCakVss0d3fBGjUiPMOZP5b/G
         1Ikg4/W7bCqt57vQncxOSgchloc7P/uIr+KMadW4jPQaylWz80EyIAgysn4KTB6wfqfJ
         X5HRK1chHI20yvfOlBqmlz05ztOV+9zVoBaRLu7KMGCP+gwk+nF4FFCne+4wBQh0omJn
         /dWnDpZABhLyo8WafKD9Egv7Fr44A0QR0nKT9rebhqogKSL9kNhs7HBBKRXZs0SIE7kt
         2GIwTHrcTpkeB6kiIJtO2tbLVWtBkrzpExUItfHG9i1RGmZ4R8zGJqYYZCXoO4HG1AoM
         IqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qH6pF/G1SFg+K0bTJv0NKKhaRdQW632kFeXNuGpnkfE=;
        b=epbMXBai0pZYHEGMEIG223d2uK2pjMvVaRqIGAeg0ZS3/wsRo2q/qAPUd2yT1DpHZh
         xCJ4sYHtILYmmdbX2XZ+Rwrl3jvtkdyg5sJ7smO+Bs3+0GBWnZ7YA1l7hqSlzqYbBC18
         7oa41RZoP5le+Tk3KgQ5zP1mCGD7RNwsOd9VBmqUHTuKHeuLeYVjEmJC1L2B6B8pGQCS
         33/19bDHK5BrcejLU1Zhp/tE6nLpncdMToP/YCYtgxOp0S4HkedNM4WCHd0n44JrstVy
         Fte6qukFPni1LUCBouaEnt8PEU66ZWwYLyFjLICeY6PVO248WcrtHKwAweHllzvsLk8W
         d++g==
X-Gm-Message-State: AOAM533AtI87chiQLJ1FKGBr4gckMpuakpPgjfC7u0HQW3D+afapndSL
        nI2wTMYZA2KEQiQPgt730wCZMw==
X-Google-Smtp-Source: ABdhPJwfkoa5tq06Zg4d8bC0U+IpqJTN95QX2flL12jYm0dbE6JQWr2ZEOwA9hwvcDv/qW0NiFky6Q==
X-Received: by 2002:a37:2e87:: with SMTP id u129mr2754756qkh.344.1612362792387;
        Wed, 03 Feb 2021 06:33:12 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id v15sm1775433qkv.36.2021.02.03.06.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:33:11 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 03/11] crypto: qce: skcipher: Return unsupported if key1 and key 2 are same for AES XTS algorithm
Date:   Wed,  3 Feb 2021 09:32:59 -0500
Message-Id: <20210203143307.1351563-4-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203143307.1351563-1-thara.gopinath@linaro.org>
References: <20210203143307.1351563-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Crypto engine does not support key1 = key2 for AES XTS algorithm; the
operation hangs the engines.  Return -EINVAL in case key1 and key2 are the
same.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/skcipher.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index a2d3da0ad95f..12955dcd53dd 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -167,16 +167,33 @@ static int qce_skcipher_setkey(struct crypto_skcipher *ablk, const u8 *key,
 	struct crypto_tfm *tfm = crypto_skcipher_tfm(ablk);
 	struct qce_cipher_ctx *ctx = crypto_tfm_ctx(tfm);
 	unsigned long flags = to_cipher_tmpl(ablk)->alg_flags;
+	unsigned int __keylen;
 	int ret;
 
 	if (!key || !keylen)
 		return -EINVAL;
 
-	switch (IS_XTS(flags) ? keylen >> 1 : keylen) {
+	/*
+	 * AES XTS key1 = key2 not supported by crypto engine.
+	 * Revisit to request a fallback cipher in this case.
+	 */
+	if (IS_XTS(flags)) {
+		__keylen = keylen >> 1;
+		if (!memcmp(key, key + __keylen, __keylen))
+			return -ENOKEY;
+	} else {
+		__keylen = keylen;
+	}
+
+	switch (__keylen) {
 	case AES_KEYSIZE_128:
 	case AES_KEYSIZE_256:
 		memcpy(ctx->enc_key, key, keylen);
 		break;
+	case AES_KEYSIZE_192:
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	ret = crypto_skcipher_setkey(ctx->fallback, key, keylen);
-- 
2.25.1

