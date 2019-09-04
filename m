Return-Path: <SRS0=oAbn=W7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA7BC3A5A8
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 18:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6149320882
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Sep 2019 18:27:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JAH4mrnP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732142AbfIDS1L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Sep 2019 14:27:11 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:32830 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387670AbfIDR4m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Sep 2019 13:56:42 -0400
Received: by mail-pf1-f196.google.com with SMTP id q10so8662119pfl.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 Sep 2019 10:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=kzUvJ4x+cBUYsW/Z5UZs0WRC1GlvmsgHO4UKe0rgIe8=;
        b=JAH4mrnPzvo2U8nPir/dh5Olg3utEpstjsa8f+a0TUCRfTkHD3xPywAlnd//2vRuYR
         tW1EuQCIGcYRPlUIlCUGe6t9OocMN675aBPUKMZ91OPf/BtfHBPYGvr3mNiMK6DuWNto
         XXL3WNNmOI4zQ0H2ka2bZHWxT2wViIZGru12TzzG9XdflUUjO2bPurEM7zmoUT/IeBgK
         0IPQnDBA7oikZvoBtGlssugHo//G09BJmCwQdIx74IHFLJ+Dlf09FKvy5iC3cOCz1Dff
         azUEyO83h5BEavDxR/RGbzey0Q731Zmnrudxz9+c5lIPQEX+UoWzZX5yzV8ao2w/7VXw
         sf/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kzUvJ4x+cBUYsW/Z5UZs0WRC1GlvmsgHO4UKe0rgIe8=;
        b=Ra+oolCXvGbSDKkI5ee6vgFIsauOOU9iEYnB2WRrgawvCR59yoCU/OEMazayeQvJY4
         /EO0wrBUjqYoibTQ4mu+eWGhoEPmB2fNUQXKhtYMhb9ZZeoi7Sx/EEtmEue41toRCmh8
         oSze1aqGaIr1UiA7G2QJHGNtm2N0RvFCPfwTi3Bo9YJVT2y2GPV8WFzFY2ck0hg71ULm
         tXQ42VTKZznbZwTg3pGbJIx+j803I8A1nxpDht+aGqGOpAdNCKxm+9S4ytR3sglIIE5x
         6oVSGrDiLecQmHM73h8+ZX7QUi345god/QiKYPzrFJkjrkAa4oHChXACX7dX5ghndtbP
         AHxQ==
X-Gm-Message-State: APjAAAVFgDjsgyIjDOUMc1OwbniiZLZG/WfAFiS27eUJsDCxGHRXr3OP
        A3aIIG9J83wSpD7CqPIOWuom3LH36s9XiPSk
X-Google-Smtp-Source: APXvYqznlD3nnLZ+T02vwRaqYXDd6T7mgD5ATFFuEBb6cDWGGSLVVlRBQmGyXRWMdgsurnC62EG/aQ==
X-Received: by 2002:a17:90a:ba96:: with SMTP id t22mr6411962pjr.104.1567619801071;
        Wed, 04 Sep 2019 10:56:41 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id ce7sm2924900pjb.16.2019.09.04.10.56.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 10:56:40 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] crypto: x86/aes-ni - use AES library instead of single-use AES cipher
Date:   Wed,  4 Sep 2019 10:56:32 -0700
Message-Id: <20190904175632.5546-1-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The RFC4106 key derivation code instantiates an AES cipher transform
to encrypt only a single block before it is freed again. Switch to
the new AES library which is more suitable for such use cases.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/aesni-intel_glue.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index bf12bb71cecc..3e707e81afdb 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -628,26 +628,21 @@ static int xts_decrypt(struct skcipher_request *req)
 static int
 rfc4106_set_hash_subkey(u8 *hash_subkey, const u8 *key, unsigned int key_len)
 {
-	struct crypto_cipher *tfm;
+	struct crypto_aes_ctx ctx;
 	int ret;
 
-	tfm = crypto_alloc_cipher("aes", 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	ret = crypto_cipher_setkey(tfm, key, key_len);
+	ret = aes_expandkey(&ctx, key, key_len);
 	if (ret)
-		goto out_free_cipher;
+		return ret;
 
 	/* Clear the data in the hash sub key container to zero.*/
 	/* We want to cipher all zeros to create the hash sub key. */
 	memset(hash_subkey, 0, RFC4106_HASH_SUBKEY_SIZE);
 
-	crypto_cipher_encrypt_one(tfm, hash_subkey, hash_subkey);
+	aes_encrypt(&ctx, hash_subkey, hash_subkey);
 
-out_free_cipher:
-	crypto_free_cipher(tfm);
-	return ret;
+	memzero_explicit(&ctx, sizeof(ctx));
+	return 0;
 }
 
 static int common_rfc4106_set_key(struct crypto_aead *aead, const u8 *key,
-- 
2.17.1

