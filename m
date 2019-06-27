Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2E6C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0402F2086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uLHuagjD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbfF0K2B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39891 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfF0K2A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:00 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so1917535wrt.6
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QMunKwfP+ecJeJsjLgotGX9cYxNfDTWVUzGiozUxkpA=;
        b=uLHuagjDQQCYBBnoMEamxGqV4L4MCtbHGa83HxXpNaJVcUgZEpyvA/9DfVcmy95RKl
         onsUCiWAVXeD/O9pB7EWYxkwoja8E5JbzKdmkpea44TZ9GjvS8U3bD559XIAFXnnhGJ8
         JQwckJYgoMFq4K1uxkE4RvYShHHMDglwCvpqUGiCKeKn+F0zBRIybLLcjXdr3tFcxgp4
         pGI3N/truUTGhQP+3PnOcNc4xy7FdRywzMQifzuSeNSNTDlauRO64F2fvQkoYhGwGPgD
         oAx4/THjaLTeJ176idpaP2bo5DdA1xYiehkLPfONRMDBEFz4GXJn6v6RtgkHnUfNs2fF
         rFaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QMunKwfP+ecJeJsjLgotGX9cYxNfDTWVUzGiozUxkpA=;
        b=HQTsUxUEp1x0tax1AnPjQv9a+zRExKWrMtRSbgOO71iRvlhoGTk6gQB/bYAwf+oFia
         t0pOb5JM6CvLUww1uhZYpGFUs9L7pv3BAZXU+zhJrxRJNkvz9vI+X7Zdf/29igxuKtaH
         Nv4bHsoKStHxLNw8JfoX20qVDt17kz5CWsd0My6gMTrAZ5QeN9T2wLKMut+0KW3nsYOa
         17AexzlXDsXrSZLNKVcmetBmSiLRUQ+K5rlnOxdtH8IWTia7MHLCc1pefxkQyVQ6muoM
         J0b8lFQJ3YmCxYLIWzHXWK67opN5XnNuCPk2OFQmEpZhnMt4ump54KVh9J08avNiWLVa
         5sfw==
X-Gm-Message-State: APjAAAVC+YqCr9XFq3UcYV7FWbSraSelS3WVy2U+HEGw4qa/UbKzSMTa
        zoUk5wcXljHFVgpAOl9qqfzpvxm4sd0=
X-Google-Smtp-Source: APXvYqz872rAdK5TeKQX4Fnh4MSVw0xKW5wv19z/yNwqheKY0yfhIaFEwEDM7Y8vWp89dKpg6VYq6g==
X-Received: by 2002:a05:6000:11c2:: with SMTP id i2mr2723893wrx.199.1561631278266;
        Thu, 27 Jun 2019 03:27:58 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.27.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:27:57 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 07/32] crypto: padlock/aes - switch to library version of key expansion routine
Date:   Thu, 27 Jun 2019 12:26:22 +0200
Message-Id: <20190627102647.2992-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to the new AES library that also provides an implementation of
the AES key expansion routine. This removes the dependency on the
generic AES cipher, allowing it to be omitted entirely in the future.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/Kconfig       | 2 +-
 drivers/crypto/padlock-aes.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 67af688d7d84..3fca5f7e38f0 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -26,7 +26,7 @@ config CRYPTO_DEV_PADLOCK_AES
 	tristate "PadLock driver for AES algorithm"
 	depends on CRYPTO_DEV_PADLOCK
 	select CRYPTO_BLKCIPHER
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	help
 	  Use VIA PadLock for AES algorithm.
 
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 854539512c35..af90138eddb7 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -144,7 +144,7 @@ static int aes_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 	ctx->cword.encrypt.keygen = 1;
 	ctx->cword.decrypt.keygen = 1;
 
-	if (crypto_aes_expand_key(&gen_aes, in_key, key_len)) {
+	if (aes_expandkey(&gen_aes, in_key, key_len)) {
 		*flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
 		return -EINVAL;
 	}
-- 
2.20.1

