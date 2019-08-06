Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22854C31E40
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 08:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAD992054F
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 08:02:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KO+jyoMY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732160AbfHFICt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 04:02:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40962 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732122AbfHFICt (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 04:02:49 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so83657236wrm.8
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 01:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qm6JmV3kYksXWkeHC8pJWnKVfNR1ILujwNkPpqX8u58=;
        b=KO+jyoMY9ilq+waDLre4wpNqq5bKuzook/vdC1KlJZH8sM8Xr0/2PXSLIkBEXb88+G
         /FNvoKUgUdmlI2Dkh9Ppgs/BFXyxmZBEjb5ySCKUc9nqoUIAPKtwR/xdPXPnaY5/LqHZ
         +RWkYDUar7b5P3zL+bZxI2YOdjZggxbk0T6Q7AYB85IPrZo+/JCl9xvNy/uc598h9tyO
         4v1/GeZMfKP3rZyAuNuIODNX4HPPuHkyp2TpFmGXCaAi9y6wqmqs9EHEP/Odu4slwf8P
         p1I24ENa85XU5QBYPWtQhQWo/FitJ3sz8EQriWOkImaQpKRM16C/XczKEjk7G6DbMUJu
         pvAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qm6JmV3kYksXWkeHC8pJWnKVfNR1ILujwNkPpqX8u58=;
        b=SCP6YnW22rllWfiFFtXSjIBMy2CLTi1qWm2mKMzxLF1cDKC8ZW0fnBV+GOMs58KY2Z
         AfUtUwGHmPVLhB7ao5t3+uUAwUu4PnZR7YAjb8OgJMPePyzRvg9pLxdwA7qGVTNlZBQz
         7vM+oOdAYx116GZs3p+sBc0Ue90mQ4uCtMilSQHi3O4niPkpWIOdAijItDsbO+AG1Dgd
         drR/XsiyDAgwRisaJ9XQVT94Vtv3M3ZKbqjqUaE3dabzF/9PffK2JNWRA3tqLiNZUykE
         ySczIsi9s/Pv6HeKPOhTQYNgZGO/8T5588n0y1O892eFXtTdqNTJUEvDup9gqKpkeZZv
         GYuQ==
X-Gm-Message-State: APjAAAWBlfci3lQhJFHewgPxNcFsbptqBbqHH6tKWA6Bwej4bMcQAL5X
        X3rw4ETa9DZGHkF4nnqE57KJBtekhXFeiw==
X-Google-Smtp-Source: APXvYqxvem5JSqcJp5XyUjQpuY8Cpg9l/gyW5f2rVkfXFaOHymWoTrTuKPXcaq6FvQ7q9I+mBD5nKQ==
X-Received: by 2002:a5d:5507:: with SMTP id b7mr3023744wrv.35.1565078566677;
        Tue, 06 Aug 2019 01:02:46 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id g12sm123785475wrv.9.2019.08.06.01.02.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 01:02:46 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com, gmazyland@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 2/2] md/dm-crypt - switch to AES library for EBOIV
Date:   Tue,  6 Aug 2019 11:02:34 +0300
Message-Id: <20190806080234.27998-3-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
References: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The EBOIV IV mode reuses the same AES encryption key that is used for
encrypting the data, and uses it to perform a single block encryption
of the byte offset to produce the IV.

Since table-based AES is known to be susceptible to known-plaintext
attacks on the key, and given that the same key is used to encrypt
the byte offset (which is known to an attacker), we should be
careful not to permit arbitrary instantiations where the allocated
AES cipher is provided by aes-generic or other table-based drivers
that are known to be time variant and thus susceptible to this kind
of attack.

Instead, let's switch to the new AES library, which has a D-cache
footprint that is only 1/32th of the generic AES driver, and which
contains some mitigations to reduce the timing variance even further.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/dm-crypt.c | 33 ++++++--------------
 1 file changed, 9 insertions(+), 24 deletions(-)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index a5e8d5bc1581..4650ab4b9415 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -27,6 +27,7 @@
 #include <linux/ctype.h>
 #include <asm/page.h>
 #include <asm/unaligned.h>
+#include <crypto/aes.h>
 #include <crypto/hash.h>
 #include <crypto/md5.h>
 #include <crypto/algapi.h>
@@ -121,7 +122,7 @@ struct iv_tcw_private {
 };
 
 struct iv_eboiv_private {
-	struct crypto_cipher *tfm;
+	struct crypto_aes_ctx aes_ctx;
 };
 
 /*
@@ -851,16 +852,12 @@ static void crypt_iv_eboiv_dtr(struct crypt_config *cc)
 {
 	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
 
-	crypto_free_cipher(eboiv->tfm);
-	eboiv->tfm = NULL;
+	memset(eboiv, 0, sizeof(*eboiv));
 }
 
 static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 			    const char *opts)
 {
-	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
-	struct crypto_cipher *tfm;
-
 	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags) ||
 	    strcmp("cbc(aes)",
 	           crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc))))) {
@@ -868,20 +865,6 @@ static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
-	if (IS_ERR(tfm)) {
-		ti->error = "Error allocating crypto tfm for EBOIV";
-		return PTR_ERR(tfm);
-	}
-
-	if (crypto_cipher_blocksize(tfm) != cc->iv_size) {
-		ti->error = "Block size of EBOIV cipher does "
-			    "not match IV size of block cipher";
-		crypto_free_cipher(tfm);
-		return -EINVAL;
-	}
-
-	eboiv->tfm = tfm;
 	return 0;
 }
 
@@ -890,7 +873,7 @@ static int crypt_iv_eboiv_init(struct crypt_config *cc)
 	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
 	int err;
 
-	err = crypto_cipher_setkey(eboiv->tfm, cc->key, cc->key_size);
+	err = aes_expandkey(&eboiv->aes_ctx, cc->key, cc->key_size);
 	if (err)
 		return err;
 
@@ -899,8 +882,10 @@ static int crypt_iv_eboiv_init(struct crypt_config *cc)
 
 static int crypt_iv_eboiv_wipe(struct crypt_config *cc)
 {
-	/* Called after cc->key is set to random key in crypt_wipe() */
-	return crypt_iv_eboiv_init(cc);
+	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
+
+	memset(eboiv, 0, sizeof(*eboiv));
+	return 0;
 }
 
 static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
@@ -910,7 +895,7 @@ static int crypt_iv_eboiv_gen(struct crypt_config *cc, u8 *iv,
 
 	memset(iv, 0, cc->iv_size);
 	*(__le64 *)iv = cpu_to_le64(dmreq->iv_sector * cc->sector_size);
-	crypto_cipher_encrypt_one(eboiv->tfm, iv, iv);
+	aes_encrypt(&eboiv->aes_ctx, iv, iv);
 
 	return 0;
 }
-- 
2.17.1

