Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8555C43613
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98E5E2084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fJbwQOIc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfFVAcR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:32:17 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40315 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726262AbfFVAcR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:32:17 -0400
Received: by mail-wm1-f67.google.com with SMTP id v19so8077159wmj.5
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d98uZ13bv3wjIuUwQ08LpTEfRPRoso0kw20Awag4Gho=;
        b=fJbwQOIczyZUwpncHeLMRfNzg2PHy+uX6H06nCYAftifkCnZh6mEEOur+6VSyB/e8X
         M5G1m2D8Iixpa1oWcByzZFIXCmjSbCuTbMbVQ5FM0J20X+J3LTS4uT39lE8kSgxN60NN
         7Ohud6SyOSrVcuaYL5Tnx034lpzIE7afA1qAQQcIQJOhRcvD/cRLcm5eT9aCx66X8Kw0
         /nfv2z4PxJV2wYtOF+rKEbIgf6brgUQy6Tvsv0LNQ/brYRlfTRW5ruW3ZcQVCNpu0req
         hLvi2tM1O6FJ8uZFO+NaW9yUTZbZzD9MlQA9UMWlgUpJKCYHcTou9+N7SCph7PSsI63Z
         UQkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d98uZ13bv3wjIuUwQ08LpTEfRPRoso0kw20Awag4Gho=;
        b=XAjEJWJlA/lNHIIjVLTIDo3HRqcldhjwJl2T9kW4yhYpmW8kB9npUJqTx1hfUpw/gg
         oGfz47OaTWHiw0OTPJLIopmRcKXd1dVEyTLoZDHD7wLi3VL3Y0PBTalX65AfO3stt4jp
         +yZrIKVLRrX0M2RcFZAGOnMLsaiB93lE69F4Ngf3CR19A9SYYVZXaIc9SaizPKWc/fUM
         3pCtNkIa+FMpiszsWm1fT0MQtUfV2QDH1gXA2m5YMiQSyWGkJTzQgmoREHpvCXyYNCHP
         dzPQ2eK3nHrnNSecJIMs4gjMKqVIQE+Supm4fSrjo+9gvuNZUaN9F3V1krhwVrNnMi7s
         PGiQ==
X-Gm-Message-State: APjAAAVoYtWbghLQuxHS9rW8tYVNhU0c+MPZAUBgvpQdR64+An4DbsQr
        yQeZppjM/ahlXs52vkbXp7ZI1cvVDyipT7IX
X-Google-Smtp-Source: APXvYqwSQ25myBnEKqbjIy3LRmzixy0sO6OxJDspSVSFSBgSKhP6w3PZEhl/Uk7pELhZ4R5RLKKFQA==
X-Received: by 2002:a05:600c:2182:: with SMTP id e2mr5580949wme.104.1561163535032;
        Fri, 21 Jun 2019 17:32:15 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.32.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:32:14 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 29/30] crypto: des - remove now unused __des3_ede_setkey()
Date:   Sat, 22 Jun 2019 02:31:11 +0200
Message-Id: <20190622003112.31033-30-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/des_generic.c | 13 -------------
 include/crypto/des.h |  3 ---
 2 files changed, 16 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index fd0a92a471d4..6360b14a2367 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -58,19 +58,6 @@ static void crypto_des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	des_decrypt(dctx, dst, src);
 }
 
-int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
-		      unsigned int keylen)
-{
-	int err;
-
-	des_ekey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
-	dkey(expkey, key); expkey += DES_EXPKEY_WORDS; key += DES_KEY_SIZE;
-	des_ekey(expkey, key);
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__des3_ede_setkey);
-
 static int des3_ede_setkey(struct crypto_tfm *tfm, const u8 *key,
 			   unsigned int keylen)
 {
diff --git a/include/crypto/des.h b/include/crypto/des.h
index 2c9cc198b214..c3e2cd772128 100644
--- a/include/crypto/des.h
+++ b/include/crypto/des.h
@@ -35,7 +35,4 @@ int des_expand_key(struct des_ctx *ctx, const u8 *key, unsigned int keylen);
 int des3_ede_expand_key(struct des3_ede_ctx *ctx, const u8 *key,
 			unsigned int keylen);
 
-extern int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
-			     unsigned int keylen);
-
 #endif /* __CRYPTO_DES_H */
-- 
2.20.1

