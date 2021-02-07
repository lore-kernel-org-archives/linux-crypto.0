Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96837C433E6
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:41:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7110264E4E
	for <linux-crypto@archiver.kernel.org>; Sun,  7 Feb 2021 14:41:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbhBGOlP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 7 Feb 2021 09:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbhBGOlL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 7 Feb 2021 09:41:11 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697D8C061794
        for <linux-crypto@vger.kernel.org>; Sun,  7 Feb 2021 06:39:52 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id o193so2404828qke.11
        for <linux-crypto@vger.kernel.org>; Sun, 07 Feb 2021 06:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JO1AHf4uhYw2ez6Ve3o7chTARaAb1KHfpJckn1suQ+U=;
        b=lhxu4kBqKdBzeGuBV04S9k+Q7UatH4gOcWyETDNOIumzGqSrnfMDfX/2zGLr4o3YnB
         CY4JOFt0FUG8W6iCFTHLlPyF7WERXEuusCIixIwpUqGIsb2FjniEjtY+W1kwUz+/9n+k
         4RAuVvpb3tkwZBTe3F01MdSqMYo7PEU7bh5Xvo9/kJynW54s5ddAkkjysk4AKB1QyIdC
         PBHxOV5fTxE1BRfPEirROMf7jSp0Clj3tuma/TFEKVL5TdpSLWSZqQFwjfpIyD2/+Jef
         yfTk+UtrQEQEYeP97c9YBgKLNJCdfMPdl9N/ztIVnEbH9l28R3uXSCUV8niAHEYyhpd5
         eJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JO1AHf4uhYw2ez6Ve3o7chTARaAb1KHfpJckn1suQ+U=;
        b=tv18ab1AnDbQpok9AQh+uTYTRQBY5eNWs+rRL2aqfhvy5YcC5vsPFjtP3+sQcHRtxk
         xdaaWcSnHL/jXBVj/E4pSF5j9KTnXlRmldJ4pyiGR7catyD9QYzJZ6SVPCD4EkQV8PVZ
         NBGRCYrU9gvtkhZh9aI4uMzESHDkLh4sZYBzoqOUpZRcCTKGU5LxTa+ko//VoeaHQZYx
         9xNQ/Dx5CZEY8PSGOAOTLjyxnklVWD2yJ/WbnDyWnQKqAKg/iM7gs9dMnKb7ywHmKk08
         HGG/ER/yPGKvqi020fIgQjqw6KLjKMWJofRXT6HHpf+qMaSdO0eyJHMxAJmROLReeu4v
         AQ6g==
X-Gm-Message-State: AOAM530VHCzzggEVk4qn8kdBPX+NVh0VCuqSMS7E/B129EYKFYqbVIeG
        BYpPO/qmBUzre9gm71/zCUJjvg==
X-Google-Smtp-Source: ABdhPJx0PlS7z6FA62l+CkV47J/KLM3umlSEv4slMJ9qZwthbGUew4ek3GHajoMKsLOQrWXTluYafA==
X-Received: by 2002:a05:620a:e03:: with SMTP id y3mr13093718qkm.467.1612708791684;
        Sun, 07 Feb 2021 06:39:51 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id c81sm13941493qkb.88.2021.02.07.06.39.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 06:39:51 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 04/11] crypto: qce: skcipher: Return unsupported if any three keys are same for DES3 algorithms
Date:   Sun,  7 Feb 2021 09:39:39 -0500
Message-Id: <20210207143946.2099859-5-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210207143946.2099859-1-thara.gopinath@linaro.org>
References: <20210207143946.2099859-1-thara.gopinath@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Return unsupported if any three keys are same for DES3 algorithms
since CE does not support this and the operation causes the engine to
hang.

Signed-off-by: Thara Gopinath <thara.gopinath@linaro.org>
---
 drivers/crypto/qce/skcipher.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 12955dcd53dd..de1f37ed4ee6 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -221,12 +221,27 @@ static int qce_des3_setkey(struct crypto_skcipher *ablk, const u8 *key,
 			   unsigned int keylen)
 {
 	struct qce_cipher_ctx *ctx = crypto_skcipher_ctx(ablk);
+	u32 _key[6];
 	int err;
 
 	err = verify_skcipher_des3_key(ablk, key);
 	if (err)
 		return err;
 
+	/*
+	 * The crypto engine does not support any two keys
+	 * being the same for triple des algorithms. The
+	 * verify_skcipher_des3_key does not check for all the
+	 * below conditions. Return -ENOKEY in case any two keys
+	 * are the same. Revisit to see if a fallback cipher
+	 * is needed to handle this condition.
+	 */
+	memcpy(_key, key, DES3_EDE_KEY_SIZE);
+	if (!((_key[0] ^ _key[2]) | (_key[1] ^ _key[3])) |
+	    !((_key[2] ^ _key[4]) | (_key[3] ^ _key[5])) |
+	    !((_key[0] ^ _key[4]) | (_key[1] ^ _key[5])))
+		return -ENOKEY;
+
 	ctx->enc_keylen = keylen;
 	memcpy(ctx->enc_key, key, keylen);
 	return 0;
-- 
2.25.1

