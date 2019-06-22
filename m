Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E449C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F88C2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E9VJbkQ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbfFVAbt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54731 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbfFVAbt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so7702855wme.4
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y03artuFEw1EqgZMcNtCu7Lvsp6XqRl3BVBaQjdCwrw=;
        b=E9VJbkQ6xAG/NjVVA1nLQOt315Kl4uapklC6sIQZrozQdCDaLTDbHy3nNWLNPuJJuk
         1dX2vTEiGICvC1aITRkRuuFVvy8pmx3fvuX9+1oRRwO9smRJhewPY1oT3+MAY7a4DQP2
         MLPfb+nC+CsBXJDDchHVru6eRZyZor6pqGHUGf20Uih4eoHVRkwnJjIAnOCE8iU7KwVq
         rvWA4eviazv6TzykNSpsGS0GzITEPG5bYIe53jssdJNZIRn6bf5t7vEZS8MsxSYO8TNJ
         srw4O+zfmxKpc6bnGYz0qQBu6BPpluizw4EFcM5Tpf8kuNuRnU+eJEdxdSlKfGnJoHEr
         FwLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y03artuFEw1EqgZMcNtCu7Lvsp6XqRl3BVBaQjdCwrw=;
        b=V2+b1YhCUTaDaRmQE837TcSoPmp9Lfo9OmkG3prutGW0wCngoJyR9+uF3q2TD17Y0j
         NXamJNDFb4y8yBVKeINJAvNMyRpj5S5HCu4uUh+bf/5XvImVkLT3LXmQeRmniDYaYF5K
         LYawHFLcolyFDwvDOZua3zT5qVEyAay62DebgGuw+T9srd9N1LxKepR4jHe/DL41j2r7
         qTMGLCWYzqarZ4o9B4tNyt0TXTyznjyCjUM17rzQx9hsSelCZvO29puki46TAu1R8TKc
         kkWTNOzgTKOg74kuloYDGJbYl+33mTAV7ZaJ83yxodfviakLoO3vReEuzNj0N4t+6ZlR
         rwFg==
X-Gm-Message-State: APjAAAVUnCJHxFRwOG60zFWA/GEX6pVuuneECsVILmFxNRnvFDppYMgO
        SN6sGsLxwVys/lRp/4ZJAVhnCenJpNl/LsB0
X-Google-Smtp-Source: APXvYqzGFfqlF2rPnadaE2wrnZaxaIz+MEXa72nFobgt7UFuII7OQNS7n4yoJuoIgnPyiVA159ktBA==
X-Received: by 2002:a7b:c766:: with SMTP id x6mr5827061wmk.40.1561163507378;
        Fri, 21 Jun 2019 17:31:47 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:46 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 03/30] crypto: sparc/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:45 +0200
Message-Id: <20190622003112.31033-4-ard.biesheuvel@linaro.org>
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
 arch/sparc/crypto/des_glue.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/crypto/des_glue.c b/arch/sparc/crypto/des_glue.c
index 453a4cf5492a..d0e3929359a1 100644
--- a/arch/sparc/crypto/des_glue.c
+++ b/arch/sparc/crypto/des_glue.c
@@ -11,7 +11,7 @@
 #include <linux/mm.h>
 #include <linux/types.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 
 #include <asm/fpumacro.h>
 #include <asm/pstate.h>
@@ -44,19 +44,15 @@ static int des_set_key(struct crypto_tfm *tfm, const u8 *key,
 		       unsigned int keylen)
 {
 	struct des_sparc64_ctx *dctx = crypto_tfm_ctx(tfm);
-	u32 *flags = &tfm->crt_flags;
-	u32 tmp[DES_EXPKEY_WORDS];
-	int ret;
+	int err;
 
 	/* Even though we have special instructions for key expansion,
-	 * we call des_ekey() so that we don't have to write our own
+	 * we call des_verify_key() so that we don't have to write our own
 	 * weak key detection code.
 	 */
-	ret = des_ekey(tmp, key);
-	if (unlikely(ret == 0) && (*flags & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		*flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = des_verify_key(tfm, key, keylen);
+	if (unlikely(err))
+		return err;
 
 	des_sparc64_key_expand((const u32 *) key, &dctx->encrypt_expkey[0]);
 	encrypt_to_decrypt(&dctx->decrypt_expkey[0], &dctx->encrypt_expkey[0]);
@@ -207,7 +203,7 @@ static int des3_ede_set_key(struct crypto_tfm *tfm, const u8 *key,
 	u64 k3[DES_EXPKEY_WORDS / 2];
 	int err;
 
-	err = __des3_verify_key(flags, key);
+	err = crypto_des3_ede_verify_key(tfm, key, keylen);
 	if (unlikely(err))
 		return err;
 
-- 
2.20.1

