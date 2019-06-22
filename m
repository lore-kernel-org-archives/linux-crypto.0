Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE888C48BE3
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0D832084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BMYJq+/N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbfFVAb5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:57 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55786 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVAb4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id a15so7712190wmj.5
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Sw/4V5sz4cIIWmh9i5YRPfjfh8aZfarMIo8BE1tJa7w=;
        b=BMYJq+/N9GxpN65F8iED9JT99dekl5Go9ylqrT1O++r1GZDncutoa6nDMEicIpw7a1
         9fx9MeEOt3jd+Fd0WzzRs9FwU5brKRGEwu1Y1DLfR5gq7D9KeCPKOs/oV9SeUQJIXZjh
         1AjE00EopH8Y+JpcKdJM3g9SSB0y7ZrWdWdrR3nMnBZ45h32f3NyUcqfIlTShUvXJRme
         LO9VrvsngCefYf2XhIedQVxu0C7CgdKRtitkpjmARgw9A7oJOZ5RpFJAQxvKKx22VOmQ
         633V4nr1I2RMtoMzLWD1CIxQh4NMoHIho86SqowuB+WS9k7daQoibRYt+R8GMulRAJ0U
         sF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Sw/4V5sz4cIIWmh9i5YRPfjfh8aZfarMIo8BE1tJa7w=;
        b=k17d6Fqrc0iy7oKFhTh5+h8kvxuu275bbh7dMHHy33ynESxZ0lM4IRjSRW3Wjd/n5g
         PsTO2pgfKnB/3EUzTTfPcY7gBamB0hVq/mPTDLxr+2JOA6dhW7Bp4KsQ8+Uj/YwSLl8P
         Pe13zHmeLVv7UGR4ODjj/uEpgFlnVoux6qCeprvINh7C35Drs6Y41NQu2bXw1xN6ILf0
         sfSLAzdCyH5LT4JVOqjKPkl72uORsqzvDliJWNhoH6PFJEIwY+59dmK1E7CfgrnfsJuc
         D5Zug2nt866N0KeODLO3u2V0VhCfXIKkKkjp2YY52280LMuwu75JovRazontEfqcjUzx
         QKlA==
X-Gm-Message-State: APjAAAWtm1dRwOBE/ci4Hf8Oguby4NJ8KXQ1JAfVxSILwRThE6d4QakL
        Yt3eD6oW4X7ghLgoZKX6hU+ebZElblbfT8mR
X-Google-Smtp-Source: APXvYqwhQDKIE3T+RNW1lqZktnc6lzSmQmOKGIkJZYQkZqqd+JtNsz+ixgKjTCs28SOK5bHv7szmzw==
X-Received: by 2002:a7b:cd15:: with SMTP id f21mr5259669wmj.99.1561163514784;
        Fri, 21 Jun 2019 17:31:54 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 10/30] crypto: ccree/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:52 +0200
Message-Id: <20190622003112.31033-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccree/cc_aead.c   | 15 ++++-----------
 drivers/crypto/ccree/cc_cipher.c | 12 +++---------
 2 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 7aa4cbe19a86..254f5be1f49f 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -6,7 +6,7 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/aead.h>
 #include <crypto/authenc.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <linux/rtnetlink.h>
 #include "cc_driver.h"
 #include "cc_buffer_mgr.h"
@@ -663,23 +663,16 @@ static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			       unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
 	if (unlikely(err))
 		goto badkey;
 
-	err = -EINVAL;
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
-
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey,
+					 keys.enckeylen);
+	if (unlikely(err))
 		goto out;
-	}
 
 	err = cc_aead_setkey(aead, key, keylen);
 
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 5b58226ea24d..e4dcfbfef446 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -412,15 +412,9 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 	 */
 	if (ctx_p->flow_mode == S_DIN_to_DES) {
 		u32 tmp[DES3_EDE_EXPKEY_WORDS];
-		if (keylen == DES3_EDE_KEY_SIZE &&
-		    __des3_ede_setkey(tmp, &tfm->crt_flags, key,
-				      DES3_EDE_KEY_SIZE)) {
-			dev_dbg(dev, "weak 3DES key");
-			return -EINVAL;
-		} else if (!des_ekey(tmp, key) &&
-			   (crypto_tfm_get_flags(tfm) &
-			    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		if ((keylen == DES3_EDE_KEY_SIZE &&
+		     des3_ede_verify_key(tfm, key, keylen)) ||
+		    des_verify_key(tfm, key, keylen)) {
 			dev_dbg(dev, "weak DES key");
 			return -EINVAL;
 		}
-- 
2.20.1

