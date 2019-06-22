Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3A08C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C9BD82084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WdHjXjOg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbfFVAby (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:54 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33087 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfFVAbx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:53 -0400
Received: by mail-wr1-f66.google.com with SMTP id n9so8162046wru.0
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f5axQ0mO4kpO+K+YY2LlgHyD0t680/v3sDL49EUqAMg=;
        b=WdHjXjOgfpJ7ZYXtp7oYGvbA0VnORA1GJtFfXu1w36zP5JSHA75nPTLSXFCedaRPdz
         fzWU2syBAHAK8aSjDpBDZhCpfmAJK0MF34Klf+1hmK9D9CGIdKeEW02tID5YJUIdZ1uz
         Uk9KAUiYfhFnpDZ7fnOAJT1PZ5/jk9VebooT2t8lPcdlfJ3BsDPQO1TiKBJ5QTuxgQIG
         57Tt9FxgqjdIOujH4jGVu+XyRbZv6HygnCCzFnjHUqyC45lm7xJSlmhJTwjatBDqjHQK
         /Dc+FI4GdmtC3BQ3pzfY9v5S7c7G20DuVsI9f4UJdINGWcbcieeuYreknuqNPjmpw5kl
         a64w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f5axQ0mO4kpO+K+YY2LlgHyD0t680/v3sDL49EUqAMg=;
        b=ozWNQhCuewXWTJA2qr/F3iRJtOa4sveJKsvhyDeTY/4U6baPEsVgZggq8I5WesZbyL
         pnS9h5hf9oAUrOcKaE0MSJnZ4bWQ424yM1gOsd+Gf6TpCMoy0zLoD7OxSKNZP2qDygN/
         OMDSV2QpB+xpOJ9SXQv5onwQOwwJjqapU0ClxM1yOv2J/pfPFY/4CPLa+8Qm0RmH9+wu
         xJ3Prnyztb99jowgKEOAiv0dDbdX3d1TlWpYSzWgl2EhiA5MG3dRUpjHGOSdoybEnT14
         CPLXdsKMG0IGlAAXNsZZcF45uabDzgBAeYoM0hg5GZp0h43wvIyAPDq8nePdl+gPe44c
         B4sQ==
X-Gm-Message-State: APjAAAXcq4sPiUJ+hHAxxfH+5QLU1yORrt1zgbNDyt0Q3PvKrLZGpwVW
        ea/U5PgmL+XaQl5g0PfhloK3wbxXiTIeOCo+
X-Google-Smtp-Source: APXvYqzg7nvzkl05TCOFsO7Bi8NmMGuzvgu3mv4gumfl3ynQ2zBD/bbJRH4aTfDCpwB0kOZoDmHVVw==
X-Received: by 2002:adf:f6cb:: with SMTP id y11mr11414457wrp.245.1561163511775;
        Fri, 21 Jun 2019 17:31:51 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:51 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 07/30] crypto: cpt/des - switch to new verification routines
Date:   Sat, 22 Jun 2019 02:30:49 +0200
Message-Id: <20190622003112.31033-8-ard.biesheuvel@linaro.org>
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
 drivers/crypto/cavium/cpt/cptvf_algs.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index f6b0c9df12ed..92132f84931a 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -10,7 +10,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/xts.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
@@ -325,14 +325,12 @@ static int cvm_cfb_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int cvm_cbc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
-	u32 flags = crypto_ablkcipher_get_flags(cipher);
 	int err;
 
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key,
+					 keylen);
+	if (unlikely(err))
 		return err;
-	}
 
 	return cvm_setkey(cipher, key, keylen, DES3_CBC);
 }
@@ -340,14 +338,12 @@ static int cvm_cbc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int cvm_ecb_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
-	u32 flags = crypto_ablkcipher_get_flags(cipher);
 	int err;
 
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key,
+					 keylen);
+	if (unlikely(err))
 		return err;
-	}
 
 	return cvm_setkey(cipher, key, keylen, DES3_ECB);
 }
-- 
2.20.1

