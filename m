Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BBAC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E12B42054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:02:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LENfMPKn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbfHERCC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:02:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:38295 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729780AbfHERCC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:02:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id g17so85137151wrr.5
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=W3vNwIhXLNgACliJVrtBW/D/smBMFzEqLx93l3SRBW8=;
        b=LENfMPKnLiGaYd4uovNDK8IU6dHZqoS1OXh9EqeQDSFX2BozB0USGjFjVeohaxgP0y
         664koh/5D5iIESznW2xnaAEBPJ05O7M6C3XLZFfMG2VeWE4lXfnkwLFegdhU0xTATdrx
         TzKZOpanLBQcc33HZpVZetTCws1KsQ/FE4MV2nJNSlFs4I8gArIJARMNj8O8jnFaF5L8
         n2SUwzk5eokZEfzo8kOcA9RbsqVOXP+tfzktJXZ6yUn/+8yyDXWTUYPBQB9VqSQ919bm
         VGzT1d7irRZLjVdAO+gxYslWjA+k+PLJRvf36WA4aGq77m8vzbz51P0lLLWjeR6nUzQj
         ymcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=W3vNwIhXLNgACliJVrtBW/D/smBMFzEqLx93l3SRBW8=;
        b=EpNMo2+nVY0AH5FN2Ztgi4Zz+i0KDPb9k88N8A9SKFCuYj2nWx13XyP7M39zqHTWus
         O1zN1uZjJgd2kEkECdj+zg8ywxTf7glesJvdB8v91qFU+EFnVE827wuxUkDVva3vLXbU
         aC1QyxWGrwYr3IVsTwe1H0IYz88jtu+MLLv6clXgHNDN8gVIvfHQFNs1Pt+M/xQxPNOT
         0iJsXx6yZEosNHlJLdznj1U+DVCY9oa+D+wmYZTzfqcuzmxwMMVvxt8t0W68UeCLYxuq
         CmFtAsIYNRngwcabN8oQnefnXF1FMPR/d29qV3MX+IbQoKJxvxqw0FKs7dj3Jy4Jfaqq
         lx7A==
X-Gm-Message-State: APjAAAVo+Hy1uSHbVN67HctE7S6U/vito0sDAGI70VlwhQ2m2tuksfLB
        qinCBbTY9lHgBR+onnaFMSuqIk6Snxc+Ww==
X-Google-Smtp-Source: APXvYqxhbP+VbO8uA1YK3qhOeVZGIyBBMbH2wywZbAytKNrM3esSOxwW904vH5n6YBUIZ9Fr6Cv4+w==
X-Received: by 2002:a05:6000:42:: with SMTP id k2mr41127827wrx.80.1565024520249;
        Mon, 05 Aug 2019 10:02:00 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 18/30] crypto: picoxcell/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:25 +0300
Message-Id: <20190805170037.31330-19-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/picoxcell_crypto.c | 21 +++++++-------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index b985cb85c9bc..c43c0b183f02 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -6,7 +6,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/md5.h>
 #include <crypto/sha.h>
 #include <crypto/internal/skcipher.h>
@@ -738,14 +738,11 @@ static int spacc_des_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 {
 	struct crypto_tfm *tfm = crypto_ablkcipher_tfm(cipher);
 	struct spacc_ablk_ctx *ctx = crypto_tfm_ctx(tfm);
-	u32 tmp[DES_EXPKEY_WORDS];
+	int err;
 
-	if (unlikely(!des_ekey(tmp, key)) &&
-	    (crypto_ablkcipher_get_flags(cipher) &
-	     CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-		tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
-		return -EINVAL;
-	}
+	err = crypto_des_verify_key(tfm, key);
+	if (err)
+		return err;
 
 	memcpy(ctx->key, key, len);
 	ctx->key_len = len;
@@ -761,15 +758,11 @@ static int spacc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			     unsigned int len)
 {
 	struct spacc_ablk_ctx *ctx = crypto_ablkcipher_ctx(cipher);
-	u32 flags;
 	int err;
 
-	flags = crypto_ablkcipher_get_flags(cipher);
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (err)
 		return err;
-	}
 
 	memcpy(ctx->key, key, len);
 	ctx->key_len = len;
-- 
2.17.1

