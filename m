Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D51C32757
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3B2D218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:02:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dYD58Uvi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730867AbfHOJCU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:02:20 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39266 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730213AbfHOJCT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:02:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id i63so678112wmg.4
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:02:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6OhjbF2M4HRdeN0EH1XAkAXt0Z8G30cJBFEK1XTbAV0=;
        b=dYD58UviyQoaqUX0Ufh5LH392urYuVBmdfTxlfeu4vZIhEPoJieDnCAHjViHnMA96Q
         1LFZ+a9mTb30FunM54tEir8xdwB6AxzpZrS0YuF1wZNyQAuYvlUYbOwvXy5nMS1hdxNW
         gek5jdntD6WcQbQgLS0TfLeP2sA6YH7ModgaZ9y/BWS3YxiWUq65wQ2R9XkOgXPidsGX
         F4/3shClIptKCYbkurnxGkGxgpufK04bT+UHDkqfOAGfaPncGJHOBEZTaoJT7Pm1+NJB
         gZm5OPLJMuKDRlxU/qaBQfXHPOQDlvU/pmKRJ0rHoXqJgDq2NBmtsbojCvxDjIKC7oEy
         iWRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6OhjbF2M4HRdeN0EH1XAkAXt0Z8G30cJBFEK1XTbAV0=;
        b=BKYTSyF/bP3A5SwIRUbJS98j/qlnBif7nUnTWmIFYcXe7PxRANQ3Q1rxQkDiYMe+Of
         YprmIcE8sXEeEitBZiJ6hCMPa6sOoopgUHXvnWFINpQNiICHJ7Ps6SEoHajUY6HxMd6o
         SGPxqfHVizrGOx8BewNOB9si22HkmvSdrUURJliyPLHWtGHA+QakyEaPjeYc2MOzu5t3
         pYc7l9et5yjrwYaEG9XS9P9ztGPtRLCZnb467WVIaHebJe2QUFqubFnQzex+TAtjncbS
         6gxEuRP2Hubb/fm1AI+OKtEc8IAcI++Ns5oNeoMDAterZCfBCaFFGJFUGnFAncA4WXJp
         B0og==
X-Gm-Message-State: APjAAAUMPpnD0p3a9G0Z2ghfSawGC33EeAfuUesgi/LEMosXF6wgytR7
        U3uOAo7g9Lcy5nfxX8vOMBEU0FWG6gILJzt6
X-Google-Smtp-Source: APXvYqwKMbbd07RBfAVJQ/h0iRUkL6f24jCHfnnZULS5lQkNqHtk2f37sXjYZqRRFlk0aI/Em/PmoA==
X-Received: by 2002:a7b:c157:: with SMTP id z23mr1699974wmi.104.1565859737719;
        Thu, 15 Aug 2019 02:02:17 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.02.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:02:17 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 29/30] crypto: des - remove now unused __des3_ede_setkey()
Date:   Thu, 15 Aug 2019 12:01:11 +0300
Message-Id: <20190815090112.9377-30-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
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
index e021a321f584..6e13a4a29ecb 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -51,19 +51,6 @@ static void crypto_des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
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
index 2c864a4e6707..7812b4331ae4 100644
--- a/include/crypto/des.h
+++ b/include/crypto/des.h
@@ -54,7 +54,4 @@ int des_expand_key(struct des_ctx *ctx, const u8 *key, unsigned int keylen);
 int des3_ede_expand_key(struct des3_ede_ctx *ctx, const u8 *key,
 			unsigned int keylen);
 
-extern int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
-			     unsigned int keylen);
-
 #endif /* __CRYPTO_DES_H */
-- 
2.17.1

