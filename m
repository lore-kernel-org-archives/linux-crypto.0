Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2944EC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F09FD2054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yZuVlaQX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbfHERBt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:49 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39283 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728871AbfHERBr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so63358038wmc.4
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=iZePgyWlwagKGC4cLYF5LyS9ZbP+9Htyh4OOtwgxfUY=;
        b=yZuVlaQXLmVsGGsrTvzOj+3iYDHS/MpO9DXST0pfKu/a8BJMF95uQJz0EQa+28t/mH
         mdtqkXqDXwwLphYrt9QGOxggqn0hHp+dbe2r0qrKBPpY9xAXlW/OemWYywo/gxRp6iTf
         anV0Ju9q0/SZ23Et50GrEJXg1JVmvJsl8w4Tx5jKHUbDAqaE/hPiLxdecWPcjNrgcCrf
         90SwuX+Qh3OG9Psn6IhmdWpuvxxeCkctCAKXmPvDaIbA+Y7lhyZz+ZX/eBCyKREFpXqM
         1Ruv3JevhsqBQOx5OkO3t7A+fsJQTjcOTx7bSRfqz92XzduwTqn1AZMwFO7kQG+NcbaW
         IwvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=iZePgyWlwagKGC4cLYF5LyS9ZbP+9Htyh4OOtwgxfUY=;
        b=dqbJCfHEtgUQF7ZBAOEgIHL6hxW/OZvi761+t536W8YJ6q8oJq3Z/QsUhMMMiOwDvi
         G6TEgQOwNnO+O+1arn7HB6yaIdHoNbvID0shrXOb7HjDcTvVfONGI3MttzGCyA60YeSD
         uVlxd0gKQ8iiUBVbqm64zJOJK9+kxdSJSLJRlH5SJ3wX2GemHp1gKMqucP5kOU6afotH
         bnLn6ssAApSusDUCMUyC9WDpj1TvcBBIKIVl8YFFbdxXpdKE+l5rZV4W8jOG6NaJRexO
         1SoznMYyJrRXoBnzOQalzKT7eptMgUwr5bbVG2RsniTazJw8xl/pvJV2JmYQM+nkf/MD
         m4lA==
X-Gm-Message-State: APjAAAWK0s7nTCLAu8avmRftjEeZPDkGOX6/ACI3hpXzjePvXGEBI9zj
        I9BqXf5xoGmNxSk9VwKsdJMctJuJwIxJ9A==
X-Google-Smtp-Source: APXvYqy3wkrM7q6Rqi5JrWYRVlXOWqxcE+l5lkFhYG+xFtNclWlZd5tdmfHS3a2D9rpVqW0EKahV+g==
X-Received: by 2002:a7b:cc0c:: with SMTP id f12mr19232885wmh.100.1565024505234;
        Mon, 05 Aug 2019 10:01:45 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 12/30] crypto: hisilicon/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:19 +0300
Message-Id: <20190805170037.31330-13-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 02768af0dccd..4a9fae297b0f 100644
--- a/drivers/crypto/hisilicon/sec/sec_algs.c
+++ b/drivers/crypto/hisilicon/sec/sec_algs.c
@@ -9,7 +9,7 @@
 
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/skcipher.h>
 #include <crypto/xts.h>
 #include <crypto/internal/skcipher.h>
@@ -347,25 +347,21 @@ static int sec_alg_skcipher_setkey_aes_xts(struct crypto_skcipher *tfm,
 static int sec_alg_skcipher_setkey_des_ecb(struct crypto_skcipher *tfm,
 					   const u8 *key, unsigned int keylen)
 {
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
-
-	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_ECB_64);
+	return crypto_des_verify_key(crypto_skcipher_tfm(tfm), key) ?:
+	       sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_ECB_64);
 }
 
 static int sec_alg_skcipher_setkey_des_cbc(struct crypto_skcipher *tfm,
 					   const u8 *key, unsigned int keylen)
 {
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
-
-	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_CBC_64);
+	return crypto_des_verify_key(crypto_skcipher_tfm(tfm), key) ?:
+	       sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_CBC_64);
 }
 
 static int sec_alg_skcipher_setkey_3des_ecb(struct crypto_skcipher *tfm,
 					    const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(tfm, key)) ?:
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key) ?:
 	       sec_alg_skcipher_setkey(tfm, key, keylen,
 				       SEC_C_3DES_ECB_192_3KEY);
 }
@@ -373,7 +369,7 @@ static int sec_alg_skcipher_setkey_3des_ecb(struct crypto_skcipher *tfm,
 static int sec_alg_skcipher_setkey_3des_cbc(struct crypto_skcipher *tfm,
 					    const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(tfm, key)) ?:
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key) ?:
 	       sec_alg_skcipher_setkey(tfm, key, keylen,
 				       SEC_C_3DES_CBC_192_3KEY);
 }
-- 
2.17.1

