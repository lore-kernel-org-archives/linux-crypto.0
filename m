Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1636BC06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4DFF21850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vxqnv0i6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbfGBTmW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:22 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44673 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbfGBTmW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:22 -0400
Received: by mail-lj1-f195.google.com with SMTP id k18so18151455ljc.11
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U0sLNlYCVozO8actpiST83AyF3eeiGkgBZDkGubqHmw=;
        b=Vxqnv0i6HLhhHtnZqH5SYpNKc3mpt0B/YWNZRJtJaF19W4MOYixSmL4gdgiXw1bE9V
         kNIFupb2ENlK83FmFFd8pPO35y/Sq8SlB8P/aXBE0Dp4lybGvuNgTAHcjQExaMOYTF7m
         iH9lsos06HGhzyb3DEvUa0bhiy91ba/d+yQbPDoZwlX+dmzNpPGurYCch3bo7FvEB/VF
         Sjl0vpnLejbE1VYZ/vn2rDEl/Bmr7lJFOe/bvXVqqwiOs91ttH53CLP20qJosoHqwLTM
         fJYI4ZZkk6CGh54jH93s5Zutv6AS+uN8bqG1J9VegnRaIO3pH+SFVgS6gr8JfA8A6Xn1
         Y5qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=U0sLNlYCVozO8actpiST83AyF3eeiGkgBZDkGubqHmw=;
        b=M8MlfFMAVgQVRqpDl9wBFZi23SA5U3PRFOsh7r1Ltsh5JfSTNwHaQ9osPNZ39fKZVg
         c77wI8IbdzUvGCxWMHbcdNWyIZN23ezL+30D3QxYMTOWqiLif1OKqcFBx+EW6HqDBdjc
         AA7l9Vd9JbUsmM3PN15Xg/yz7FNyunjJji03mXwNdR/GycfJ9pGkXbOIEhi1n0bahJHa
         yeLZfEIqYf5XyPI11Mx4aqNcJ2AKk+vLCaNbrSNUyf3GA6CiYQJvnxYdpK6VzWWfHmBT
         KlG+ZKZMThNNLSMo8UBDH1CB6BLZaYirBphAKwx/jgT3j03R91y5emaIHzZxc7N7IYCU
         bWxQ==
X-Gm-Message-State: APjAAAVcOcXp4alfa4HExUfJS4EmkAVnYlObssnsUXtTeJpjZDDiBBJb
        v53C2drzYm83p8DY7YiiJC0VxgkKl3mTTKmr
X-Google-Smtp-Source: APXvYqwaULJXPcjPtbMNHDPLTi1295IbG3GPVR3reqwofSakbAjIIoUzKEqqwTz8A8pLVBifH/vcEQ==
X-Received: by 2002:a2e:8e90:: with SMTP id z16mr18658353ljk.4.1562096539979;
        Tue, 02 Jul 2019 12:42:19 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.18
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:19 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 07/32] crypto: padlock/aes - switch to library version of key expansion routine
Date:   Tue,  2 Jul 2019 21:41:25 +0200
Message-Id: <20190702194150.10405-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
References: <20190702194150.10405-1-ard.biesheuvel@linaro.org>
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
2.17.1

