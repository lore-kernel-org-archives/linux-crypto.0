Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733A1C0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46BC02054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GdZzZn/k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbfHERCA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35966 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729885AbfHERCA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so85218296wrs.3
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mk8wWsjsHAhHiLD84ZLING84UraoNcUF63sVSd0BFbI=;
        b=GdZzZn/kmB5ZSZ4TnSiqk4trK397lVrXHNt2HLMWCThh06LLATjNHeA1WcH7UtAuV6
         G1d/DgS3tJpuqKZP4PHFYZk9JymYY0Pq0PPPSP2FNZaUWcQAwOq15I/avRuXG5XuSfuo
         05fLHehXPl6hp5cKR3s6+BqNH5/joG5NjS4zvVHqLbT7erco3mufz7+wwwqiEuXMitEh
         J3p46Z4NSBsRueZ8xNSXwOzloAE+MWs2ow8VlWmObKdz+pHSC3gLNdWm3SmpAg6y5Dhe
         lukGgYQlXjM39XGc3s5x+IhIYVyHAmxJ1TsAlfXVDcen21R1xoRd4qoPeuwe4BUmsMtb
         LJXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=mk8wWsjsHAhHiLD84ZLING84UraoNcUF63sVSd0BFbI=;
        b=FpMHEDJY74Chg5QpFpqWu1WiE4YudedYLVed3+tSHnp5E412/iD/sIeJvUh/bzSP6b
         pmfYc0519kTMJ/nebeHhTkCyE7OPgqUA9wKfmNS6WS8d3j+xm6aLQkhbCg1pHoE/Knxl
         HGNUoCDl+v+/Abj2+bZMb/jMupZQYQf/mOg+0NP9hHWxwZKFmTG27OMAPJPEYXCixqvm
         VMq+zXqy6G6rnzgPxVWu3WI4BqXufh1VqDTttDLGhsHBeAXOPWo7GjeqJfRUgIDNezJb
         4jaKDSdWBo7808VJ6LuSTd+usKoJFIXVM4FvQLaSlDwk4wu6GMSi4ly9RAX3vlXd5hJZ
         r4+Q==
X-Gm-Message-State: APjAAAXhgxtooIdJppr+3PUHzKheAIDO5BxH9BRR96Ef+ptHh2apNmrR
        Ul5/sUduY6S7AbIn9ZaRcfdGgx48LnnDQA==
X-Google-Smtp-Source: APXvYqysRqBXtTWIP5KnkYtRjzull1TjhUr5f9VnANuxeoUa+aTJQr2LMw8GzJkwRWTaayoIM6YEEg==
X-Received: by 2002:a5d:6182:: with SMTP id j2mr113606511wru.275.1565024518051;
        Mon, 05 Aug 2019 10:01:58 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:57 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 17/30] crypto: omap/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:24 +0300
Message-Id: <20190805170037.31330-18-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/omap-des.c | 25 ++++++--------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/omap-des.c b/drivers/crypto/omap-des.c
index 1ee69a979677..6af0de9f03fa 100644
--- a/drivers/crypto/omap-des.c
+++ b/drivers/crypto/omap-des.c
@@ -33,7 +33,7 @@
 #include <linux/crypto.h>
 #include <linux/interrupt.h>
 #include <crypto/scatterwalk.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/algapi.h>
 #include <crypto/engine.h>
 
@@ -650,20 +650,13 @@ static int omap_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
+	int err;
 
 	pr_debug("enter, keylen: %d\n", keylen);
 
-	/* Do we need to test against weak key? */
-	if (tfm->crt_flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS) {
-		u32 tmp[DES_EXPKEY_WORDS];
-		int ret = des_ekey(tmp, key);
-
-		if (!ret) {
-			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-			return -EINVAL;
-		}
-	}
+	err = crypto_des_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
@@ -675,17 +668,13 @@ static int omap_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			   unsigned int keylen)
 {
 	struct omap_des_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 flags;
 	int err;
 
 	pr_debug("enter, keylen: %d\n", keylen);
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
 		return err;
-	}
 
 	memcpy(ctx->key, key, keylen);
 	ctx->keylen = keylen;
-- 
2.17.1

