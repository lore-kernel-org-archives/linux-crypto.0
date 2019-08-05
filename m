Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 033CEC32754
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB77C2075B
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="obbR8EMZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbfHERCh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46569 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729914AbfHERCg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:36 -0400
Received: by mail-wr1-f66.google.com with SMTP id z1so85138707wru.13
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BotHPKD3g+g+mUZQ/dtkowLHJlOQtGFVF7+kbySZOcU=;
        b=obbR8EMZnX9a6vmvwBmSWBGnOOKN1dVJCGQ4ifjqJajW1phHKR4LOZA7JiismaEyz1
         92MA1noE3SpLmLqwHS+E8ytPal+A7ID2yxssz1aVbouVCJociz2IC2UjHm9LWmXRPa3w
         Hm7tykA2xhBRF0S47SN17wyZkAm4T/K37yPOYSSvw4WqVSxhmFLRkM+JsJqdQl+/3YhK
         Mn9L4PyKH6b1yy5y8JCaeDkmLTnQ20EVo/MVul9dFlCn/ikynHw3tZJP32EEtooszfvt
         C6gFPdorWwsmgVV5YdiTm8YZWOoI2Bt5uGyyXVdgj6Ib6ZMmkinGlwN82GVXs1E0hpfx
         joGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BotHPKD3g+g+mUZQ/dtkowLHJlOQtGFVF7+kbySZOcU=;
        b=R1aU3qUEMIS2c2vd6oi9qfLySa7XEnPxV4YGCrM6NWKPO4TthCXXGlUjZSU045f7i3
         8QBzjIus6jcoWheXfFMNEQtPGzt3VZOUYssdBvfiL5z4vWvshGPtCnjxQB7wFwXt2Dov
         MvXtkeOl4QxgQAgOLOmYGFKTScVi4Fl8Crfc4Gz4xeoZB6EZWBf0ArAaxpq8rBWj2qAV
         Vxjs47KxpXD4MU7tqr0fYNi2H53kL4AXW8sTjHLtReRN/3Gospfo0QPesRLSgzOhiB2s
         7KWmXQ6BQqV8AkUB8fKJtf1aytl9gJ7nrStm6onh8ITmPdhjsp3nq3N7sukvKTa6/rUk
         IdYw==
X-Gm-Message-State: APjAAAVREYYHCh+t+8YgA7yIqFe8WaxyK/OP3J0qEsKu2by+0llKxTet
        HlohGBxSad4JcEcdxd4oy2D2gBKywXBVhw==
X-Google-Smtp-Source: APXvYqz0Baj6RzjYC3ThTptCo4X5kmfC782hm31L+uQpdBH/78XDaCY/tLbK4i1w3JiVq0bmiP4eFw==
X-Received: by 2002:adf:8364:: with SMTP id 91mr161963813wrd.13.1565024554417;
        Mon, 05 Aug 2019 10:02:34 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.02.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:02:33 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 30/30] fs: cifs: move from the crypto cipher API to the new DES library interface
Date:   Mon,  5 Aug 2019 20:00:37 +0300
Message-Id: <20190805170037.31330-31-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Some legacy code in the CIFS driver uses single DES to calculate
some password hash, and uses the crypto cipher API to do so. Given
that there is no point in invoking an accelerated cipher for doing
56-bit symmetric encryption on a single 8-byte block of input, the
flexibility of the crypto cipher API does not add much value here,
and so we're much better off using a library call into the generic
C implementation.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 fs/cifs/Kconfig      |  2 +-
 fs/cifs/cifsfs.c     |  1 -
 fs/cifs/smbencrypt.c | 18 +++++++++---------
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/fs/cifs/Kconfig b/fs/cifs/Kconfig
index b16219e5dac9..350bc3061656 100644
--- a/fs/cifs/Kconfig
+++ b/fs/cifs/Kconfig
@@ -16,7 +16,7 @@ config CIFS
 	select CRYPTO_GCM
 	select CRYPTO_ECB
 	select CRYPTO_AES
-	select CRYPTO_DES
+	select CRYPTO_LIB_DES
 	select KEYS
 	help
 	  This is the client VFS module for the SMB3 family of NAS protocols,
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 3289b566463f..4e2f74894e9b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1601,7 +1601,6 @@ MODULE_DESCRIPTION
 	("VFS to access SMB3 servers e.g. Samba, Macs, Azure and Windows (and "
 	"also older servers complying with the SNIA CIFS Specification)");
 MODULE_VERSION(CIFS_VERSION);
-MODULE_SOFTDEP("pre: des");
 MODULE_SOFTDEP("pre: ecb");
 MODULE_SOFTDEP("pre: hmac");
 MODULE_SOFTDEP("pre: md4");
diff --git a/fs/cifs/smbencrypt.c b/fs/cifs/smbencrypt.c
index 2b6d87bfdf8e..39a938443e3e 100644
--- a/fs/cifs/smbencrypt.c
+++ b/fs/cifs/smbencrypt.c
@@ -11,13 +11,14 @@
 
 */
 
-#include <linux/crypto.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/fips.h>
 #include <linux/fs.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/random.h>
+#include <crypto/des.h>
 #include "cifs_fs_sb.h"
 #include "cifs_unicode.h"
 #include "cifspdu.h"
@@ -58,19 +59,18 @@ static int
 smbhash(unsigned char *out, const unsigned char *in, unsigned char *key)
 {
 	unsigned char key2[8];
-	struct crypto_cipher *tfm_des;
+	struct des_ctx ctx;
 
 	str_to_key(key, key2);
 
-	tfm_des = crypto_alloc_cipher("des", 0, 0);
-	if (IS_ERR(tfm_des)) {
-		cifs_dbg(VFS, "could not allocate des crypto API\n");
-		return PTR_ERR(tfm_des);
+	if (fips_enabled) {
+		cifs_dbg(VFS, "FIPS compliance enabled: DES not permitted\n");
+		return -ENOENT;
 	}
 
-	crypto_cipher_setkey(tfm_des, key2, 8);
-	crypto_cipher_encrypt_one(tfm_des, out, in);
-	crypto_free_cipher(tfm_des);
+	des_expand_key(&ctx, key2, DES_KEY_SIZE);
+	des_encrypt(&ctx, out, in);
+	memzero_explicit(&ctx, sizeof(ctx));
 
 	return 0;
 }
-- 
2.17.1

