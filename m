Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BD7AC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 018A220656
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hIZgrMA7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfF0MDg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:36 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38972 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726682AbfF0MDf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:35 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so5412457wma.4
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lw7IfSvEuxhbx4Wlk78c29jrNjDUKTz/yRyE8QUP9h8=;
        b=hIZgrMA7BCMMKtpmuYsbI4pxMZK4jLiRMFaOsWlaBl3bxtr+MMkwryGKgwWyiYGltn
         VunsnzuNPRfjBRTey19Tzu+Idekf0dpmj2muspqLAiOwquqwzy7bhubQ1rvqXEZ1gw88
         nG44Aih10JdebfWd6EMPY4zpnXeW9d8CAI65rPo+X5Vqlk0WEPl7KvjvY6WGRBp1SUlS
         haPswalJLeWGfqVj7n0Q3iPB7jSWDYW39wu74RA9rWa4iUP7cy9RTN2X0iG4giAjksQj
         N5IYmiPXF/fr9c2jZjoPEhj+1O63CDcrsRs0dbK7nizm0ivrM4nDKdz+SntoRWVbEwPC
         voJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lw7IfSvEuxhbx4Wlk78c29jrNjDUKTz/yRyE8QUP9h8=;
        b=YzEueKrmme2wQ32QexzyrwEmdXfDb0ghNa9akN1FuSiBPiptSGla2v1bnAj3nUQv1s
         np4U6YotCQXbAtP1jYkHaW8v7Pnl+WG1EjYHVbxq0D/FaRxpd3+fXo81LMQdK73VG6AC
         ERpUN1RRov68ti8OVwlsLohFonB7009bbvXDk7/w83FAu+U+9wX1FzBlStNyHmvxNKGj
         YOIxLsUtZqZmQHD0EtdDRGLcCNMKU8Prz5ECwfX2zhJLTqfFElihtkUl4N6vlEGP9UpQ
         xHA9v8OZRw+6aZnoxHTuXsbfY5yj/dxn+CXYe/u6XNqZU0YK2JWylu7CUackJN0OOIMr
         u/Ow==
X-Gm-Message-State: APjAAAWDZXs1IJHWJlTzPoJj2ESlTGwBwo0S8bwX+XJ0DgggYt75sbeB
        WChmyTlQYaIrojx7Oat1tn9/UiHl0+/zWQ==
X-Google-Smtp-Source: APXvYqxc02ifsSB8IsXXDCo1nfz7MVDtxOt3r6M1BxMIGcbHkl4jr3bR6fEQJnWtKHq7REe6n4ypFQ==
X-Received: by 2002:a7b:c148:: with SMTP id z8mr3078275wmi.142.1561637013653;
        Thu, 27 Jun 2019 05:03:33 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.32
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:32 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 07/30] crypto: cpt/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:51 +0200
Message-Id: <20190627120314.7197-8-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/cavium/cpt/cptvf_algs.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/crypto/cavium/cpt/cptvf_algs.c b/drivers/crypto/cavium/cpt/cptvf_algs.c
index f6b0c9df12ed..f9b0ac792d6d 100644
--- a/drivers/crypto/cavium/cpt/cptvf_algs.c
+++ b/drivers/crypto/cavium/cpt/cptvf_algs.c
@@ -10,7 +10,7 @@
 #include <crypto/aes.h>
 #include <crypto/algapi.h>
 #include <crypto/authenc.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/xts.h>
 #include <linux/crypto.h>
 #include <linux/err.h>
@@ -325,14 +325,11 @@ static int cvm_cfb_aes_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int cvm_cbc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
-	u32 flags = crypto_ablkcipher_get_flags(cipher);
 	int err;
 
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
 		return err;
-	}
 
 	return cvm_setkey(cipher, key, keylen, DES3_CBC);
 }
@@ -340,14 +337,11 @@ static int cvm_cbc_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 static int cvm_ecb_des3_setkey(struct crypto_ablkcipher *cipher, const u8 *key,
 			       u32 keylen)
 {
-	u32 flags = crypto_ablkcipher_get_flags(cipher);
 	int err;
 
-	err = __des3_verify_key(&flags, key);
-	if (unlikely(err)) {
-		crypto_ablkcipher_set_flags(cipher, flags);
+	err = crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(cipher), key);
+	if (unlikely(err))
 		return err;
-	}
 
 	return cvm_setkey(cipher, key, keylen, DES3_ECB);
 }
-- 
2.20.1

