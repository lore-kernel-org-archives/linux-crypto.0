Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F0DC433E9
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EADC464F8C
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Feb 2021 14:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233017AbhBCOfO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Feb 2021 09:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhBCOec (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Feb 2021 09:34:32 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494A1C061794
        for <linux-crypto@vger.kernel.org>; Wed,  3 Feb 2021 06:33:14 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id l23so17612508qtq.13
        for <linux-crypto@vger.kernel.org>; Wed, 03 Feb 2021 06:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JO1AHf4uhYw2ez6Ve3o7chTARaAb1KHfpJckn1suQ+U=;
        b=kPOqAcmA58UbfVRbvNMjoHECsWtumzrZSpGgU3OVn6nAv7G3Mcwpo0l+v0TDHgHAWq
         h/3BO0P+bxsfqZkNmnHmGmweFpyD4vjIrWXBtUm7k7AZWH3gqle4hZH7MoFG5pTyunyd
         al4uvKnxvyQXsFTivJR+zaQLomfR3lHculQ3m+SZ82wQ+/3ByuMFJPmZyteIH8SA7AHy
         FHd7dsnE3YZt0ujmgRYVqUWrb5wxGhhzhK/QMteP1fmmAXyzpj3HOS4t9SnecMr2eClR
         u5zFvvjB2wpsidS+sXwejCau6hQUlEB7wv476PurAmJeBu9dFpwkd+6NOElZMQINjU3Y
         gQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JO1AHf4uhYw2ez6Ve3o7chTARaAb1KHfpJckn1suQ+U=;
        b=LRDbUigYUb57bjvRvOBcVMeDp+kgoC8tvjaE3mC695vdPWH8Zcdmra0BE3jQQGo9w5
         e6Gtp5DL0s7APkgI1KSFH1HH+YZr7cqWN8bxwddEEPX5kOFnhm0BFHEXUCmWhFt8EXWQ
         whr7r3NHfyX4AZeh6eOzFRVKbziLUV+IBiz4o2sOTBtLTnzdFQyJYfhuKk0G+tD9CW/h
         76+9Vy93kofelGdo1/U+UFAAAwRMYaEnO7Hf2xmpvvTG4rhteASiWDzW6r9nomFTJMES
         c/Wemx6PJvBmtaUura5zB56GB+fOFAOMPEfkGnvJACKC8tEISl/6A9Wh3Zz+z+ovNxfE
         Uv3w==
X-Gm-Message-State: AOAM532US95fXIoSnpWWdvj6Fbx1pbWXUhxaSIoA5B7hIiPJpUP3TR8A
        0vG+2Bzu3+B403PmTyk0UthlrA==
X-Google-Smtp-Source: ABdhPJxtOWKbS+W5o/JKiraXu7Xo+EcVQF8n4Vcsj40OX80zveoxx4nTOiSOQwF0BtimNdzuYcnN9Q==
X-Received: by 2002:a05:622a:1d4:: with SMTP id t20mr2577064qtw.281.1612362793478;
        Wed, 03 Feb 2021 06:33:13 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id v15sm1775433qkv.36.2021.02.03.06.33.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 06:33:12 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/11] crypto: qce: skcipher: Return unsupported if any three keys are same for DES3 algorithms
Date:   Wed,  3 Feb 2021 09:33:00 -0500
Message-Id: <20210203143307.1351563-5-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210203143307.1351563-1-thara.gopinath@linaro.org>
References: <20210203143307.1351563-1-thara.gopinath@linaro.org>
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

