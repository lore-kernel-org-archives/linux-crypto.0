Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 643DDC4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C85E20665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QiTQFAHx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbfF1Jfu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:50 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:35528 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbfF1Jfu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:50 -0400
Received: by mail-wm1-f65.google.com with SMTP id c6so8334316wml.0
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V8kUdKzOHm3U3Q+L+CiRSbO6vCtGHpWxywiKx8gNh1M=;
        b=QiTQFAHxcbq1Jf6P3yCPbX1D8MunbEeJw+mMRhmdbvgzRtX6LTlIuaKkZ8A2+jWFaO
         OeNX9UiE4C3Kn3fbw6GNUPp82yX7MQrNz69lTLFP/U/VsxDVPlxssuXBp9A9GKD+T8Bm
         BzI9BURPYNXp/x76dppCJiOylkilL8SnNyiu6e1fC1lhW1hXQJTPY63nVDqaT12vd/ie
         NJkAyHlU2wS7Tdeyz8M8cutHVkHvVHM5wvt8/9cibkKn/MDQHnbZBix1eyppC/whSgVI
         pdLQLjjGDW+/lIJqj5gLmtuEJYiomM0YS541upNs+jZ0XBC7TqRSMx1Kg16ekdy93O71
         stEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V8kUdKzOHm3U3Q+L+CiRSbO6vCtGHpWxywiKx8gNh1M=;
        b=BPKGpPtqRTSHR9+kmq2sSF5jhZId/h/bOE8pXwMLikVEIcjxxFlz9OZI5yPbx6JEf1
         yFsCqkFxZ8gk7w9XtbXsV5w623GVLTqVAyOXvZnRhDhr/Sd55KT9S1hsYkFVTzGA/n9z
         1oHFldbIOAJXbfZnAtnFgkCGzxjZs+55Ms7ReHkM8Riu62n1ZZG8Ww2nHIDx1W0wu7QQ
         iLhwbWRft5Rpev5yaS7vdXIVlyRTReakRcFGO+rjBCr6mHftsxnPwPakQQQf+hvuQEbA
         BXQVPc8GsO9bSYVvq4uYqCJAAJBsfdtveZpUz3TDBEJiTyYKW4H25PHGWxtlaa3tul67
         nctg==
X-Gm-Message-State: APjAAAUZrOAvmhmivAGT+ZSr8klY0+yhry7H95ENDAFb5X9pLS7tS0D4
        TRLqmLt0Hh/g/yD0MfXl30lNZQy9cnWlIQ==
X-Google-Smtp-Source: APXvYqzlKLjOoGfGqyNmX6J8PNMrsK2fCcPUoLGymu3FxfayPzQYFidl/bqJsUr9c8SWevCBk6tmNg==
X-Received: by 2002:a1c:c706:: with SMTP id x6mr6466087wmf.162.1561714548326;
        Fri, 28 Jun 2019 02:35:48 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 09/30] crypto: ccp/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:08 +0200
Message-Id: <20190628093529.12281-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccp/ccp-crypto-des3.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-des3.c b/drivers/crypto/ccp/ccp-crypto-des3.c
index 91482ffcac59..23e6dfba2abb 100644
--- a/drivers/crypto/ccp/ccp-crypto-des3.c
+++ b/drivers/crypto/ccp/ccp-crypto-des3.c
@@ -17,7 +17,7 @@
 #include <linux/crypto.h>
 #include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include "ccp-crypto.h"
 
@@ -42,11 +42,10 @@ static int ccp_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 	struct ccp_ctx *ctx = crypto_tfm_ctx(crypto_ablkcipher_tfm(tfm));
 	struct ccp_crypto_ablkcipher_alg *alg =
 		ccp_crypto_ablkcipher_alg(crypto_ablkcipher_tfm(tfm));
-	u32 *flags = &tfm->base.crt_flags;
 	int err;
 
-	err = __des3_verify_key(flags, key);
-	if (unlikely(err))
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key);
+	if (err)
 		return err;
 
 	/* It's not clear that there is any support for a keysize of 112.
-- 
2.20.1

