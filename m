Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E8D8C433E6
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:50:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32D6D64FAB
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Feb 2021 21:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhBDVuW (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Feb 2021 16:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhBDVpY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Feb 2021 16:45:24 -0500
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E6C2C0617A7
        for <linux-crypto@vger.kernel.org>; Thu,  4 Feb 2021 13:44:05 -0800 (PST)
Received: by mail-qk1-x735.google.com with SMTP id d85so4929002qkg.5
        for <linux-crypto@vger.kernel.org>; Thu, 04 Feb 2021 13:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JO1AHf4uhYw2ez6Ve3o7chTARaAb1KHfpJckn1suQ+U=;
        b=L5atl3u2FShWrNk0KPUgQBmlVFI8trZLK+DuEcZWP0P1LwPq9Kl5pxeU3pyfzKh6kN
         oD4oYBetvwTOIHy2Tnt+aBmJvlseHBkH6HctukpVUSZoH/MgiQ2PyT0r8aTx7/5FZrs/
         6LQUB2yFXjZ8IAIZGw2cScLTy1OwvS+k2kf0/zlttN00+XG22VEZJimpa4hbif8BFfzJ
         FDt2mY3WTUsmO7HeJ15MKySQOlocbwcsNxJDYoLbn7fnH9FdeNoFMoK1Pgt0KpU0OXGK
         ZJeVHEgjmCr5XIiJDlLQJ5i8V0AKbu98wSIUXpCOR6QvsdSTxY90F5JtaO9CjwQUGuzL
         ZCmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JO1AHf4uhYw2ez6Ve3o7chTARaAb1KHfpJckn1suQ+U=;
        b=YfttwysJS0QJR2nBgvh/Es5SfMl7LpS0IWfrhIK0V5xGTeER1BHDIQm7bzLqkrAzcU
         kMKsgmdJhdGxYO9jlxNTGir/raQKq57SwvZ3cSMJGXiuMkEuptYLaXpCLrwbuo/3Ba9Z
         vrVajrKZ/r0+hfWODK/MO7iSSgj7xFZRs+DtVnk2TeS6AavfM+1pCOH6m5JPid0Orj06
         VFQHcmPQHt7qUnEQktiyUlxe4iVNT7ympAwI4FauxDwTv53L3FYaT+R3rZoaPQQ09cv3
         FoFZLYCQUkfLdXaqq00F16I3dHhknWxUSloztH10mMBrDwKLpVzEaZMzO91UYzG5prYy
         I04w==
X-Gm-Message-State: AOAM533Y1KdtSg9avDYvZxwH2Abma1yT0AAF2cacOTKhrQhhGf4alwVE
        Dn0bEn8d4lPVWUs5jNWffZLoUg==
X-Google-Smtp-Source: ABdhPJwIHZywZI303E3pWw3kSBlHV4QnzG54HsWGTIi0sA/+BDHynMZ0HB9vH0454zjtUuYMHsKhXg==
X-Received: by 2002:a37:8dc7:: with SMTP id p190mr1247597qkd.308.1612475044406;
        Thu, 04 Feb 2021 13:44:04 -0800 (PST)
Received: from pop-os.fios-router.home (pool-71-163-245-5.washdc.fios.verizon.net. [71.163.245.5])
        by smtp.googlemail.com with ESMTPSA id h185sm6353858qkd.122.2021.02.04.13.44.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 13:44:03 -0800 (PST)
From:   Thara Gopinath <thara.gopinath@linaro.org>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        bjorn.andersson@linaro.org
Cc:     ebiggers@google.com, ardb@kernel.org, sivaprak@codeaurora.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 04/11] crypto: qce: skcipher: Return unsupported if any three keys are same for DES3 algorithms
Date:   Thu,  4 Feb 2021 16:43:52 -0500
Message-Id: <20210204214359.1993065-5-thara.gopinath@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210204214359.1993065-1-thara.gopinath@linaro.org>
References: <20210204214359.1993065-1-thara.gopinath@linaro.org>
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

