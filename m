Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A085CC433FF
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 748222054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NFTi5Ft8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbfHERB0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:26 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39240 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbfHERBZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:25 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so63356959wmc.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d/q+PwBQn82PwNRadEPbRZlT98TrFpoVZO1F6BU3qYI=;
        b=NFTi5Ft8w1d17W5i86cJTf0YRanGNjWsoNOMmVrybgokPa+SItmv6eq2nCPL124cKQ
         3gTnlpdPjlgvoDE1xCg2mCUdEAZSTN9XPlnvjWd5+CTWIDfi1BdztBRWNVkssUJ2fgvk
         bPS6idypXkSrTtZg5oRzCGUVzp6B8EOo6G4ZJn2IK4T3GpYbbhWN9KvTEGS9amD+M6Lc
         9x9B3llP3bOzJF2zhK0EFfzUjxC9zH44+JiL9mlMbDhK0vhRyWlUrdRDPpFTw0WW9h6G
         xgI+ZqFN88XF1zz5R9V26adZ8KwkI8yCPkgAO0f+2REPzNEFgMiLIyCzqB0nCh5S/j+B
         npMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=d/q+PwBQn82PwNRadEPbRZlT98TrFpoVZO1F6BU3qYI=;
        b=mRPrsv9xrGe5yDoyamvnepgfvKSxVFdFte+UU5wpNrs+raLuA9StqFZTyY6+quPDmF
         VxHAmRxzwJ4FRnhT5cSD9weMRje0oMF8tBA32JzWUBJv9z/SdpVUm1wTbqAbT94yLaqM
         rAe0Cp3N7ZEy2LwB+qw9Z3NY5qGFjCtZhPoyzmShqKJXfp3ZXgsAyBAR5yQJkOZgCZCt
         lpuG7f5XHH9oGFKi3ux+ZLpdd0KLG8G+3ahssXyahXtxGaNm/LTLyc8mrA/bykKkWJV3
         6Keg78P0lzcXTJ/oHvGre0wn6G+UBoyXY8hFyXfYe5YJty1IaWtalqL4JkMGI1Pnk+D5
         7jAQ==
X-Gm-Message-State: APjAAAUWxr0bqXLY9EPWXpg4MrR338L6f+7LVQjnvtl8b2iSXqJrr4Jc
        FDxPMo1qA9RXdBiqZPopa0RqlnJetrSqwg==
X-Google-Smtp-Source: APXvYqxeuFXl01zbErUTU5Z8oog1vsvXTvXoLCC4D3HxaWwQCbwdQ4ORohD2gUBYvaT7ghV+DDMXzw==
X-Received: by 2002:a1c:5f87:: with SMTP id t129mr20675862wmb.150.1565024482968;
        Mon, 05 Aug 2019 10:01:22 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:22 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 07/30] crypto: cpt/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:14 +0300
Message-Id: <20190805170037.31330-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/cavium/cpt/cptvf_algs.c | 26 ++++----------------
 1 file changed, 5 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index ff3cb1f8f2b6..aa349d95cc2c 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -7,7 +7,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/xts.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
@@ -322,31 +322,15 @@ static int cvm_cfb_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int cvm_cbc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
-	u32 flags = crypto_ablkcipher_get_flags(cipher);
-	int err;
-
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
-		return err;
-	}
-
-	return cvm_setkey(cipher, key, keylen, DES3_CBC);
+	return crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key) ?:
+	       cvm_setkey(cipher, key, keylen, DES3_CBC);
 }
 
 static int cvm_ecb_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
-	u32 flags = crypto_ablkcipher_get_flags(cipher);
-	int err;
-
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
-		return err;
-	}
-
-	return cvm_setkey(cipher, key, keylen, DES3_ECB);
+	return crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key) ?:
+	       cvm_setkey(cipher, key, keylen, DES3_ECB);
 }
 
 static int cvm_enc_dec_init(struct crypto_tfm *tfm)
-- 
2.17.1

