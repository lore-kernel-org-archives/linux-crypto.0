Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08ACDC31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D3EB3218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uGAWG73A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbfHOJBs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39216 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730793AbfHOJBs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id i63so676743wmg.4
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gMw1TSRrolAnfbeQ/pAAvmgP6ZTYCAswbG5wAAMeaMQ=;
        b=uGAWG73AY2khDOPO4pabFiwxsoz4Oo/oJENgw3mZgUg0b3WCor7L9hof8k286AEA9j
         zo13vQ65/X2UIclncpj8BPOSSYQGHL0+8giCf5QWdZfKhWH6jSKSzTQ6GskQvMqJmhGw
         ahgjK2rj9d3BSD2L2B9y4+IY66iO5D/3cbNV3m4BVOhwdiIRNy1O2bjb1GAmKod9Z9IP
         wrDgiwIG7AuFMWUGGyEUPHbhbTtOEWHzJ+l5+E1scQ/32hJirOtlFKTdstWg2vxBUDf6
         0aBa39gBdHzaIdMwe3DXJiCc3VFzPrAQP602f5ToqZ8pfth1EVRDhoUvoaEGlffBMR9y
         pIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gMw1TSRrolAnfbeQ/pAAvmgP6ZTYCAswbG5wAAMeaMQ=;
        b=sSGKAe+zbFus7zmgNjucL0vlT4IdYAy8VRoajxJclAqtpkjtvg2QuPciQWaz2TS7Kh
         aHQ9Wnhnug5GifKPpOd4oyhwTUVdZhgl4ltpjUiE/nS5ii3q4kQZJ7heOw6bhVWVTN4z
         WaxkOuCkj0hm+IzxrPV/x2AGuDTmxbSy056uCfGKD8zEvewS92sez8dpmHtTNX9/QIyy
         +d6nb3/q/6SPpaSCyscgWqN644Z5RjiTS/fPWS/PfIRBN6VSvq2h/skvF0j6Ptz8UQNZ
         nIZalpzbRErYR2eFnM9vKzG96hvR8vl8idsTrUeclDpwla2WhCSm7JHjWOgio6Iwko1u
         3pQg==
X-Gm-Message-State: APjAAAWviQj/jgfwOA5nrjP2LCrnmoeO5G5o3F90Qv/PBci2dLJB68An
        VPqL5JEkWteTt/+5a0K5dk9JY80UcRLrCaXp
X-Google-Smtp-Source: APXvYqz7M88jCKgyTmKSC/+d0HAE7Ob4JH9z6fWTqytBJP5ZbksxVD6Eq4DOp//K4itGpvYVDgv3lg==
X-Received: by 2002:a05:600c:114e:: with SMTP id z14mr1593976wmz.161.1565859705931;
        Thu, 15 Aug 2019 02:01:45 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:45 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 12/30] crypto: hisilicon/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:54 +0300
Message-Id: <20190815090112.9377-13-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/hisilicon/sec/sec_algs.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_algs.c b/drivers/crypto/hisilicon/sec/sec_algs.c
index 02768af0dccd..e0508ea160f1 100644
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
+	return verify_skcipher_des_key(tfm, key) ?:
+	       sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_ECB_64);
 }
 
 static int sec_alg_skcipher_setkey_des_cbc(struct crypto_skcipher *tfm,
 					   const u8 *key, unsigned int keylen)
 {
-	if (keylen != DES_KEY_SIZE)
-		return -EINVAL;
-
-	return sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_CBC_64);
+	return verify_skcipher_des_key(tfm, key) ?:
+	       sec_alg_skcipher_setkey(tfm, key, keylen, SEC_C_DES_CBC_64);
 }
 
 static int sec_alg_skcipher_setkey_3des_ecb(struct crypto_skcipher *tfm,
 					    const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(tfm, key)) ?:
+	return verify_skcipher_des3_key(tfm, key) ?:
 	       sec_alg_skcipher_setkey(tfm, key, keylen,
 				       SEC_C_3DES_ECB_192_3KEY);
 }
@@ -373,7 +369,7 @@ static int sec_alg_skcipher_setkey_3des_ecb(struct crypto_skcipher *tfm,
 static int sec_alg_skcipher_setkey_3des_cbc(struct crypto_skcipher *tfm,
 					    const u8 *key, unsigned int keylen)
 {
-	return unlikely(des3_verify_key(tfm, key)) ?:
+	return verify_skcipher_des3_key(tfm, key) ?:
 	       sec_alg_skcipher_setkey(tfm, key, keylen,
 				       SEC_C_3DES_CBC_192_3KEY);
 }
-- 
2.17.1

