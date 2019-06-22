Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EAFFC4646B
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4567720657
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 19:34:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tG+zChu1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfFVTe4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 22 Jun 2019 15:34:56 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34664 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726286AbfFVTe4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 22 Jun 2019 15:34:56 -0400
Received: by mail-wm1-f66.google.com with SMTP id w9so11348986wmd.1
        for <linux-crypto@vger.kernel.org>; Sat, 22 Jun 2019 12:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0+abpCskFH64uUUzWz6MrJWQeWRPxd08F5mJmqOJSaY=;
        b=tG+zChu1TY57HmPBHNOBr8ZTS5Jg27t/A8d8SsgNlYBqbOpiXe7548t9OubC0JH1Xu
         vrd0A/PhM6ADLoMzc+n3JJFJrOhQg6hB9pRiyT/2zq/LTPGTNfFfYF5rDXCyrx1UWM3W
         rBoShNAyWgIJxndSg4OARGF1XAUzH8uCn6tXROm+c64j8MlRChJLLa9OEgXcjetsWB1W
         v1nZHq/9+JCZ2cSIj0o/tgr2z6icIsEQR94XEqa5nfOAuPrTv9TfLFupxvuzUGojLddG
         I+H2VR+nmGifnSIWqm2zKr5rT9tHNvGXyD4LBeCMiX+9dY6wQBpT4Ez2G1XP29aevM7O
         ZQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0+abpCskFH64uUUzWz6MrJWQeWRPxd08F5mJmqOJSaY=;
        b=GV9pu5jDEers1HOozJ+Ck+jF3ZZAgBuT7wLg4uJebVv7VX0MyH2rG5WFBIO6QzqVJF
         rZtGY2Rd7qg4S/VBSvd0VngyBZGCkLmIyQjYqZa7XMs8Ej9bzxLsxyPj4azao0eiQAjg
         tRC43ioVmRGHaHW+zotkHe4WAVf8ci6Vkyv0FF4zmOgIFrw379MjGycmyIIbN+eB6pe4
         90rXbvNfKcK/po2tmKfTt41DMpBId15XZicMKad/A0hn+9odBGWUN5uNO65fXzrnxgNW
         vtloH9PHXAk34WnnlvBOE2JeNGsGuQutw8a8mW7TYbzpnn8GVJnTTZpNcNLH5HCPsro1
         Fcqw==
X-Gm-Message-State: APjAAAV1qVYRecuzDs64wABAOdihssSuJYH8y1otOEnKFcBrg2qheNqS
        9+BJspt+WAOsLEDhaxXoTSbbYr7ULPtvOMCC
X-Google-Smtp-Source: APXvYqx/QgvGAgXUieCsGMpTXWLd4IIVkds6OXbxsClOEvpuFhjWg9BtttO/wSh3EfZEj0dom5SvSQ==
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr6114671wmi.14.1561232093962;
        Sat, 22 Jun 2019 12:34:53 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:4bd:3f91:4ef8:ae7e])
        by smtp.gmail.com with ESMTPSA id h8sm4814494wmf.12.2019.06.22.12.34.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Jun 2019 12:34:53 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 13/26] crypto: arm64/aes-neonbs - switch to library version of key expansion routine
Date:   Sat, 22 Jun 2019 21:34:14 +0200
Message-Id: <20190622193427.20336-14-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/Kconfig           | 1 +
 arch/arm64/crypto/aes-neonbs-glue.c | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/Kconfig b/arch/arm64/crypto/Kconfig
index c6032bfb44fb..17bf5dc10aad 100644
--- a/arch/arm64/crypto/Kconfig
+++ b/arch/arm64/crypto/Kconfig
@@ -116,6 +116,7 @@ config CRYPTO_AES_ARM64_BS
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_AES_ARM64_NEON_BLK
 	select CRYPTO_AES_ARM64
+	select CRYPTO_LIB_AES
 	select CRYPTO_SIMD
 
 endif
diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 02b65d9eb947..cb8d90f795a0 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -77,7 +77,7 @@ static int aesbs_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct crypto_aes_ctx rk;
 	int err;
 
-	err = crypto_aes_expand_key(&rk, in_key, key_len);
+	err = aes_expandkey(&rk, in_key, key_len);
 	if (err)
 		return err;
 
@@ -136,7 +136,7 @@ static int aesbs_cbc_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct crypto_aes_ctx rk;
 	int err;
 
-	err = crypto_aes_expand_key(&rk, in_key, key_len);
+	err = aes_expandkey(&rk, in_key, key_len);
 	if (err)
 		return err;
 
@@ -208,7 +208,7 @@ static int aesbs_ctr_setkey_sync(struct crypto_skcipher *tfm, const u8 *in_key,
 	struct aesbs_ctr_ctx *ctx = crypto_skcipher_ctx(tfm);
 	int err;
 
-	err = crypto_aes_expand_key(&ctx->fallback, in_key, key_len);
+	err = aes_expandkey(&ctx->fallback, in_key, key_len);
 	if (err)
 		return err;
 
@@ -274,7 +274,7 @@ static int aesbs_xts_setkey(struct crypto_skcipher *tfm, const u8 *in_key,
 		return err;
 
 	key_len /= 2;
-	err = crypto_aes_expand_key(&rk, in_key + key_len, key_len);
+	err = aes_expandkey(&rk, in_key + key_len, key_len);
 	if (err)
 		return err;
 
-- 
2.20.1

