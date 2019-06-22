Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B690C48BE8
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3153520657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="HRL4wYu2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbfFVTeu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:50 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53471 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbfFVTeu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:50 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so9147968wmj.3
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QMunKwfP+ecJeJsjLgotGX9cYxNfDTWVUzGiozUxkpA=;
        b=HRL4wYu2j3ZC8ztFcw5jusvcO70KmvcLgz/loyCoCvT4/QqUZ2KGzp4oEzGr6zSvQP
         z9uBHfwDsrks9peolBIaZ3LI7xvxLkZW8NK+vEhm5HXBiLD05vCph9smlQ1zLtrSmFLi
         GZNqkbrPsxSj1r1XFjIZe+0OyMC/eiPbT0DzXSwYLMFi+NcoB+arPCwqUhgaIIl3j/IY
         TY2Q17mbD/wxjM7wJfxfOx2+fC8gahXqf6TMdvlDjXmih9XU/jI427uc6o0TQjwuRZch
         wgy0iieM62PaOoZX++/M92IbZ53JtpBrwUBMeqB+bMygBWuRip3zZdJH/ZbQDgsnMt9H
         anYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QMunKwfP+ecJeJsjLgotGX9cYxNfDTWVUzGiozUxkpA=;
        b=lxXPpdAxpSPGjm8Il1VUqUTD9sHEBDmRgsPan42HnEeIwytr98TpQ907nP0TPuLlvW
         Ra46grIWj733jPv5HkBLwW/vUR+29Sbp7Mkmd+Y3wW/zrI/6hrmf6bKG25OY4zrcMLOA
         1EZFmwY7H2MM0+LmnaoZjf59J1bEDtLiuS1QseAPNrEIkaTVzVBPxE6XpIgFdoW9pWXR
         0X0THwk2yrqjFusjP86RkPygyzji9zpWFdSlh22w46I5J1UGX1kxGndsq9RC1MvY6Jxj
         0iDp+APt0NVqePR7Y/x+9sfNPxyx4+oIBpfNPnIBNiptHiYrwnZdut6Fu6gPXT6tKN1S
         L3TA==
X-Gm-Message-State: APjAAAUa1ZEP6dqHSqKQtuV0pme7AefJJ+WhWALZDR6XAkjWogOnGtqG
        ge0DKQM24p3A+wwXqgfOuBHOTCBzPxz4yMei
X-Google-Smtp-Source: APXvYqxcDE7tvsqOJWWduMtHNknhY1vQqoT3HjIqlWqg00mnWVUb88cbORSiaTv7EB+TG0+p8iIVug==
X-Received: by 2002:a05:600c:28d:: with SMTP id 13mr8899720wmk.5.1561232087743;
        Sat, 22 Jun 2019 12:34:47 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:47 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 07/26] crypto: padlock/aes - switch to library version of key expansion routine
Date:   Sat, 22 Jun 2019 21:34:08 +0200
Message-Id: <20190622193427.20336-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
References: <20190622193427.20336-1-ard.biesheuvel@linaro.org>
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

