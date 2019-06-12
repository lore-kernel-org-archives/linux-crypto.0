Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E2A1C31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05A4420684
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 12:48:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L4vm5I00"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439224AbfFLMs6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 08:48:58 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45956 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409162AbfFLMs6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 08:48:58 -0400
Received: by mail-wr1-f67.google.com with SMTP id f9so16737687wre.12
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 05:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1JPW+Khv2z/aWoRuZihhCURcfSA9tf7hrRP493vIL8U=;
        b=L4vm5I00wk/ySgVsbGUIEtgHpepAypN9jVidRQ0lAW894f729XPrQ0KYdwsDyrslWT
         ncRcENt6WFZV7F+xqgrkMGCPqc7lGdRyzr8KXfatIm2TYMo0rHtSS0+Hkf/tOBC19zQ4
         GZzHWR6pX8J2xJ6MdwaRyP3nJI8X8xJHhg8tnDal5qR8RjrXMsIFrsQ6TKEQnKhAEoht
         P0zp+nBE1+pTkNhHMxJyICEKBQ5TkTwSeV4oI1eg4bnJE1cpVNx/BWJTSdxgsbhtlZxE
         tAiuorRRi+S00qNTUOX9smGdKAeq09GawFffIHn2lVO6eqSqhclKZBvx1PSVDtRsoYsE
         nt7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1JPW+Khv2z/aWoRuZihhCURcfSA9tf7hrRP493vIL8U=;
        b=kE7KyRNPorsUT+VXuZr/3XxvFrL2O0Tw8cu5r92aoY59jm+r5JHOBCrCaYh0IJNmiB
         uePHFIumV80kLP28dz5HOurGP21fFjGWmouWKgxg4/W/EdkQEnIOQadEw8BhCbf17GSH
         xcZ85GmSQucs6OQLer/nnKzj2zPw7yEkCQtcu+bIC/R6DE+cQMAFwu/vWUXpx7gtFb6C
         LsYUwrr2nlZkQcztW5D4ptbOn0/RJnOPf6gSn+P4yuUl6k6SDHqS5hGbM8NVvI6RMVou
         tIzGMsCTSaSL1x1pr+lBtQ28ovnyWGzfXE4u/Oh1adJVqYwvJj+OnQBJnEFJkRxH7vbp
         MeYA==
X-Gm-Message-State: APjAAAUur7QdbFLvWSKuoTVq3n9YhEZe3NKDG5+zNWCWjQpMCR55EAgH
        5db+ZUS4JpSbD/Hr5iK907ZZJWVnHgEhoA==
X-Google-Smtp-Source: APXvYqxgs2MtoxT26g2L9AGHoiQRgpePHpQuHHJdWV15RyUPCdlFTu8TgeU3u3GiYw5lC70m6rnr8g==
X-Received: by 2002:a05:6000:1285:: with SMTP id f5mr13986859wrx.85.1560343735715;
        Wed, 12 Jun 2019 05:48:55 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id s8sm28505480wra.55.2019.06.12.05.48.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 05:48:55 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 08/20] crypto: cesa/aes - switch to library version of key expansion routine
Date:   Wed, 12 Jun 2019 14:48:26 +0200
Message-Id: <20190612124838.2492-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
References: <20190612124838.2492-1-ard.biesheuvel@linaro.org>
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
 drivers/crypto/Kconfig          | 2 +-
 drivers/crypto/marvell/cipher.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index b7557eb69409..539592e1d6f1 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -214,7 +214,7 @@ config CRYPTO_CRC32_S390
 config CRYPTO_DEV_MARVELL_CESA
 	tristate "Marvell's Cryptographic Engine driver"
 	depends on PLAT_ORION || ARCH_MVEBU
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	select CRYPTO_DES
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_HASH
diff --git a/drivers/crypto/marvell/cipher.c b/drivers/crypto/marvell/cipher.c
index 2fd936b19c6d..debe7d9f00ae 100644
--- a/drivers/crypto/marvell/cipher.c
+++ b/drivers/crypto/marvell/cipher.c
@@ -257,7 +257,7 @@ static int mv_cesa_aes_setkey(struct crypto_skcipher *cipher, const u8 *key,
 	int ret;
 	int i;
 
-	ret = crypto_aes_expand_key(&ctx->aes, key, len);
+	ret = aes_expandkey(&ctx->aes, key, len);
 	if (ret) {
 		crypto_skcipher_set_flags(cipher, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return ret;
-- 
2.20.1

