Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0582C5B57A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 993AE20665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="C25sjKCh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbfF1Jfv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:51 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40975 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbfF1Jfu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:50 -0400
Received: by mail-wr1-f68.google.com with SMTP id c2so5525970wrm.8
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j6M5TRu+t5b8dNBp8eA+gJ51MqfKI7hT8cP2zMiglEs=;
        b=C25sjKChJLD27lnSwe7p7Njq81Df4LB7wH067xu6wri7NDF7YgKBiMBuSceOMlJHIP
         ziU/YXzOgSBaVrI0HNfVEvlaqnLWQLwRyhf/YmfaVqtW/h1st2/F6Ckfz5BwJydFyohm
         HKJ23SuYnNMzN/d7xBkTF1ueH8+iOiW24L+QibLngqcxwghq179vVsSqCKWVbjcDpeM3
         1JQzPUDLSIgls+oPpOPEZtTkOFjy3I4uat8y++1QOZqvShDjIz43+Z7cf+AbQQe0ghvq
         ek9hSBmlFxwwpZpXLZ34xHw/JLvsj4eD0a1Owk+2POqXFjKz8O1Xqr91tgbJB6llVepN
         9q+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j6M5TRu+t5b8dNBp8eA+gJ51MqfKI7hT8cP2zMiglEs=;
        b=MsVhss1fIWQ5jIwpQH/VrEnPNtKLTT9NssuhvM8sKSo3PBbgUOBBaSQ5IMrp5jlwb6
         daGJo112JmEw0ve+zSCTsNnCK0FpTy53A6V4D9ep4UqV1ffQTwpnQv8eMNCvnY0fJAIU
         uY7bNUnpgneey5CcS68+lrg6R91CvT3iuyng7xzJig9T0ItxyaCjpfV3p1R2wfHTKmcp
         cyPt8tOu/c0HUZqnOJykAaJ145LoExJvLfeXfD7au4pUwJqlK9FIKs3p4Y6zpREPkLhm
         lbaj1kmlrslgN8mLWArbH65rjfNr9doJRnbeiGQnCZn6SCU8WXITTPnGARmfvbHeRccx
         Uhaw==
X-Gm-Message-State: APjAAAVQJpojH3IY5Vd6XCmn5Eqto1jWCFFAJp6pfhaBl3q7mFTkf4cl
        BfsbqGp4vGPebJIwxppGE0/PsBy9GNXUKQ==
X-Google-Smtp-Source: APXvYqyYwGnXvQwk+ltk9JX6RjbOSYdeMhuVym0GJ/SP+OpIy1SwwgnIfxAZOsBuW8Lr/b+r5pPKaA==
X-Received: by 2002:adf:fb47:: with SMTP id c7mr6856983wrs.116.1561714549209;
        Fri, 28 Jun 2019 02:35:49 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:48 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 10/30] crypto: ccree/des - switch to new verification routines
Date:   Fri, 28 Jun 2019 11:35:09 +0200
Message-Id: <20190628093529.12281-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccree/cc_aead.c   | 13 +++----------
 drivers/crypto/ccree/cc_cipher.c | 15 ++++-----------
 2 files changed, 7 insertions(+), 21 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 7aa4cbe19a86..ec6aecd2781d 100644
--- a/drivers/crypto/ccree/cc_aead.c
+++ b/drivers/crypto/ccree/cc_aead.c
@@ -6,7 +6,7 @@
 #include <crypto/algapi.h>
 #include <crypto/internal/aead.h>
 #include <crypto/authenc.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <linux/rtnetlink.h>
 #include "cc_driver.h"
 #include "cc_buffer_mgr.h"
@@ -663,7 +663,6 @@ static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			       unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -674,14 +673,8 @@ static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
-		goto out;
-	}
-
-	err = cc_aead_setkey(aead, key, keylen);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey) ?:
+	      cc_aead_setkey(aead, key, keylen);
 
 out:
 	memzero_explicit(&keys, sizeof(keys));
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 5b58226ea24d..dc30f5aeca10 100644
--- a/drivers/crypto/ccree/cc_cipher.c
+++ b/drivers/crypto/ccree/cc_cipher.c
@@ -5,7 +5,7 @@
 #include <linux/module.h>
 #include <crypto/algapi.h>
 #include <crypto/internal/skcipher.h>
-#include <crypto/des.h>
+#include <crypto/internal/des.h>
 #include <crypto/xts.h>
 #include <crypto/sm4.h>
 #include <crypto/scatterwalk.h>
@@ -411,16 +411,9 @@ static int cc_cipher_setkey(struct crypto_skcipher *sktfm, const u8 *key,
 	 * HW does the expansion on its own.
 	 */
 	if (ctx_p->flow_mode == S_DIN_to_DES) {
-		u32 tmp[DES3_EDE_EXPKEY_WORDS];
-		if (keylen == DES3_EDE_KEY_SIZE &&
-		    __des3_ede_setkey(tmp, &tfm->crt_flags, key,
-				      DES3_EDE_KEY_SIZE)) {
-			dev_dbg(dev, "weak 3DES key");
-			return -EINVAL;
-		} else if (!des_ekey(tmp, key) &&
-			   (crypto_tfm_get_flags(tfm) &
-			    CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)) {
-			tfm->crt_flags |= CRYPTO_TFM_RES_WEAK_KEY;
+		if ((keylen == DES3_EDE_KEY_SIZE &&
+		     crypto_des3_ede_verify_key(tfm, key)) ||
+		    crypto_des_verify_key(tfm, key)) {
 			dev_dbg(dev, "weak DES key");
 			return -EINVAL;
 		}
-- 
2.20.1

