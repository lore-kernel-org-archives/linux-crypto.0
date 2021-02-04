Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE1EDC433E0
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6894864F8C
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:45:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbhBDVpf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230058AbhBDVpX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:45:23 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DE82C061794
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:04 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id t63so4974614qkc.1
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qH6pF/G1SFg+K0bTJv0NKKhaRdQW632kFeXNuGpnkfE=;
        b=gbKxS5e8CTLLKMrWTEmfPwRWGpzyjMOngziTQj1g2+TvAFgL9trZ4VXVFANBUJfga5
         3oDbRCy5R3qU1bE78K222fxBzdeVY/4cOtLBN/vJLGYpUlJy5hmNZ9dv03gItaiJAbWQ
         GncNJH3B6AYgpytL3qa98eL+QQaV7blX85Wau42c/ZSCf0lB4LWY66S+VtVjudz4i4Ec
         XNwDg8jTwxP6CjHfwLDvadYj4h0z7SBgCrTe6otn6oar4OWsg6nMFjSuMG0PyHRwXmTH
         JDqUmP6q0a4N6WQAmu8jXZXuTOxJpcSb3GEmPrZlVvoJz1o+oViZh0XgYbAJMa+TnGd7
         doNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qH6pF/G1SFg+K0bTJv0NKKhaRdQW632kFeXNuGpnkfE=;
        b=cPtb8hJSdkxE3nOGALnvmtv6ZgxiJaMCvJC8SmYSFmbixOMkt37Vwcq+IqV1NsDzG2
         W0shiPpFMnwuldBXI6jtc2/BFwmVk9WYYE1qouzonMpDurZkkLSX5NHhu0YWwxyJNw77
         wM07vmqj15SF06E0cd2HSbm/fHSUmdDF8/gpvilnXl8FgOGEndllpXpRpOxsu7j1A9Ao
         dmMiJwT6Kt3kKoqRhvjF9z1kWuAw++QOnMkKqUwitlfr2LYyrXNq90iGvA7N+uZZgWJf
         HaezELSIgcZ+HtDY5cQUojk76gOain7eZZFQCBEjFkDKseA3sBLDh294j54NWyptWB7Q
         UNSw==
X-Gm-Message-State: AOAM531aDdwfzQpVgblef16HVC3iu4vQdwLYicEks2Wccs/PlDO4MI9t
        PP8gi4m1Orps89VdWV5nFuyQgg==
X-Google-Smtp-Source: ABdhPJwpif6KmauoadACXD3M6+LCcawEsG7ygPh+js460WIxpn+hXK5ZL8kTgTRkp2ZMvfY2jwADrA==
X-Received: by 2002:a05:620a:544:: with SMTP id o4mr1314845qko.285.1612475043441;
        Thu, 04 Feb 2021 13:44:03 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id h185sm6353858qkd.122.2021.02.04.13.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:44:02 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 03/11] crypto: qce: skcipher: Return unsupported if key1 and key 2 are same for AES XTS algorithm
Date:   Thu,  4 Feb 2021 16:43:51 -0500
Message-Id: <20210204214359.1993065-4-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204214359.1993065-1-thara.gopinath@linaro.org>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
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

