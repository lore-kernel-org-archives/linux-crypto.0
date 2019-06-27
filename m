Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7070EC48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48B7F2086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kNHW3hqr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfF0MDo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:44 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43631 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726798AbfF0MDn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so2235827wru.10
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nrs4B81hCM9/q01U+UWQiaDxCfGgsj9EqtgRRqSeyuA=;
        b=kNHW3hqrFhAgO6KQp6qVROcqY+QRGLDp8O9vZdpQrsbW+4kdXs9ha0nTT74ZR8CKMM
         qZKoJHcRcQ6KQKUf2u+E4nFSg6wXZwjIgxFKL2hH3r+U1/ol4xPijth//D4F5itXLv/+
         PsfBnFurbsaElezKrdSNiAsrCzTxg1dneIRCP+tOOkUYvp+TugVEMkdrhHrRVOJmI6pV
         2JrdI+lnoFdBHalq7VexnvAlSgHazj9k+M7wH4EG94MIpbCkV77x+tPifJ+FDnkeWd7H
         nXUPaEE+xZ66MjtkbSAZuR/BpOta7xd+jQsz1XUZgfrbA2x3driw5h0s05r3+HGK4uvZ
         QFag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nrs4B81hCM9/q01U+UWQiaDxCfGgsj9EqtgRRqSeyuA=;
        b=rzRr8m3h2nC9Oqb2wXfNYlVoXIXGfgBPaoDo+i0q5agfsZVCZsLxlWMHy64hdzqzC5
         BSdbShkaG5g33MRzaBQbWjxWjAjypgJc8ca6ntPASDTftyLGOP/Yd3oftxkPtXarH2je
         WzP6oVEXgp4uEGBAw8CpvpHpv1NJPhwgnwlfs/M0ZgMk2h0v/WuoJxfpj1BriJg87i8c
         u/R7UA3h1ZyybtKP4jSEgCFw7FVX5D4ToF8iOplbhulS0Wh0BCDtxRLcz2HYOvVY5YBj
         BDTZYNG9zndLbps16W/AMPyCk/FugzIu/D/veV0REb+SBQFNOBvo1ktOXR1m5NEp/Y+f
         2ClQ==
X-Gm-Message-State: APjAAAX5rHjIWgxTVopeVbaKiyiCnI6HuYAXSOBCco7K3ifpch5RbL50
        jl1Re/gach/0lrmraFbB/lCTwSG5JPuNpQ==
X-Google-Smtp-Source: APXvYqx0ks0dH/tZzykT1AnpwtHLqSEd2nD4WtijCjav35+xtw4qLIqTqb03XluJP97sg8s9u5U/gg==
X-Received: by 2002:a5d:4302:: with SMTP id h2mr2730993wrq.137.1561637021834;
        Thu, 27 Jun 2019 05:03:41 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.40
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:41 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 14/30] crypto: ixp4xx/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:58 +0200
Message-Id: <20190627120314.7197-15-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ixp4xx_crypto.c | 21 ++++++++------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index 3f40be34ac95..f7642e3848b8 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -21,7 +21,7 @@
 #include <linux/module.h>
 
 #include <crypto/ctr.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/aes.h>
 #include <crypto/hmac.h>
 #include <crypto/sha.h>
@@ -760,10 +760,7 @@ static int setup_cipher(struct crypto_tfm *tfm, int encrypt,
 		}
 		cipher_cfg |= keylen_cfg;
 	} else {
-		u32 tmp[DES_EXPKEY_WORDS];
-		if (des_ekey(tmp, key) == 0) {
-			*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		}
+		crypto_des_verify_key(tfm, key, key_len);
 	}
 	/* write cfg word to cryptinfo */
 	*(u32*)cinfo = cpu_to_be32(cipher_cfg);
@@ -855,12 +852,11 @@ static int ablk_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 static int ablk_des3_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
 			    unsigned int key_len)
 {
-	u32 flags = crypto_ablkcipher_get_flags(tfm);
 	int err;
 
-	err = __des3_verify_key(&flags, key);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key);
 	if (unlikely(err))
-		crypto_ablkcipher_set_flags(tfm, flags);
+		return err;
 
 	return ablk_setkey(tfm, key, key_len);
 }
@@ -1185,7 +1181,6 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 			    unsigned int keylen)
 {
 	struct ixp_ctx *ctx = crypto_aead_ctx(tfm);
-	u32 flags = CRYPTO_TFM_RES_BAD_KEY_LEN;
 	struct crypto_authenc_keys keys;
 	int err;
 
@@ -1197,11 +1192,12 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	if (keys.authkeylen > sizeof(ctx->authkey))
 		goto badkey;
 
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
+	if (keys.enckeylen != DES3_EDE_KEY_SIZE) {
+		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		goto badkey;
+	}
 
-	flags = crypto_aead_get_flags(tfm);
-	err = __des3_verify_key(&flags, keys.enckey);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), keys.enckey);
 	if (unlikely(err))
 		goto badkey;
 
@@ -1213,7 +1209,6 @@ static int des3_aead_setkey(struct crypto_aead *tfm, const u8 *key,
 	memzero_explicit(&keys, sizeof(keys));
 	return aead_setup(tfm, crypto_aead_authsize(tfm));
 badkey:
-	crypto_aead_set_flags(tfm, flags);
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
 }
-- 
2.20.1

