Return-Path: <SRS0=X5ob=U7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24EF5C06510
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 038C321850
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Jul 2019 19:42:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j9AdDAXF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfGBTma (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 15:42:30 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:39118 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727049AbfGBTma (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 15:42:30 -0400
Received: by mail-lf1-f66.google.com with SMTP id p24so12264678lfo.6
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 12:42:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JyLJkqgd2qHLXLovdFPdmSe6yZQW5DMw8EodB7HW1iY=;
        b=j9AdDAXFB7D5cxPfRsER1dOZWlG17/GiNQSXf3XBF91g/VaDnKGYmWABb2MhnL3+up
         9g26LDey9j755oxYSfQTG7IcGKLdkcOjFzC0AQeEmntKmc2dS1Ra4YOjm4yGJU+t/T2U
         7yahW7dCY2y+J3VHxbGBFtGQxPI0xy9ID33hgX1M660rcR5m4/W2JwsQCF85s88Wtpqv
         5pfZVEd2LEQvGPW6hmcJruCCfQ4cu4O13MxlJa9HAQPrc9C69k7pmyYkVa5/XZj6G9Du
         M6qVtj+utEQJXJPK+2d+A2CTtx0KpJ4nOBE7IeVQmQkN+t+3PPfdWKE4pmooks1TV4Hn
         C9QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JyLJkqgd2qHLXLovdFPdmSe6yZQW5DMw8EodB7HW1iY=;
        b=IqHFUJIYCqf+BolFCUmiyjuWyyvrnsHdYpsxgx6hKj0Ol3Ew//H7DpPwX5nYRYsQp5
         L5IPwn+92sSLzc3o7nRJYxVTqlQuiOduO2ywv8f2AiCCf2vCaytIdz+SmVxLFULI22oi
         sYTtjxjtGufuXdoqYN6gSzT0OFzAcIXBWmZvtsvplG/ccYGjuk3tlLkOU2BH1x2jKxja
         nuVQ61NXgbVSuwxO7u13abHNtgoll1eV6Zf7DN9B9p4pcwYOxAoWp3pCDED8IVgF54Ko
         bUwfaMcHgPYwH05cC1hOxHtCXp8IJjgSxxsfHHA2wYjd4SEMtM/otwA6GkU9AquAn5tX
         VmLQ==
X-Gm-Message-State: APjAAAWPBiujw8nWaG6fW7LNDSHVbdN10f1p1ZI1Y7qWVNrRvtN+/QNx
        SMhPzTfAff2W3fKh3hgHshXEIPGmrPMURfPx
X-Google-Smtp-Source: APXvYqxUin1YBQQfYHHkBmUP0BUlaFegtORLd4PQpMxFmo6E8zqZwblBL6cdxA08QtISbUKRt7x7sQ==
X-Received: by 2002:ac2:4ace:: with SMTP id m14mr14146722lfp.99.1562096547981;
        Tue, 02 Jul 2019 12:42:27 -0700 (PDT)
Received: from e111045-lin.arm.com (89-212-78-239.static.t-2.net. [89.212.78.239])
        by smtp.gmail.com with ESMTPSA id 24sm4475163ljs.63.2019.07.02.12.42.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 12:42:27 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 13/32] crypto: arm64/aes-neonbs - switch to library version of key expansion routine
Date:   Tue,  2 Jul 2019 21:41:31 +0200
Message-Id: <20190702194150.10405-14-ard.biesheuvel@linaro.org>
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
2.17.1

