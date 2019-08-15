Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C02C433FF
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6A5C218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zxx4WGbI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730760AbfHOJBp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:45 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44440 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726120AbfHOJBp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:45 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so1562952wrf.11
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hjScT+0+NYfp5aidkWeFYVYHJ6rSMaKSveRxE97FOLw=;
        b=zxx4WGbIdT6+v94U7dIhYd9lERYrChqa0Wfpl6qPST7cp34Zu/yL/MjXIbJrhGPWAz
         MM0Eqs5Ym1JnKJQMl0fnaHgsT4JNRfq3aXD1K0XEq9zBxzeR2Yk6vFLdXJtC5N7NzeQF
         /LCgUNf5i9LCyMWmPkcaugC+P39z+9js3RM/9tNHTEg3iMZn505zrSGVOHB2mXOIdkiP
         NGoZJF4IA5tZ5U/kkXmXLNTtXua8c3iYp+Ej0PseOBQ0PH88jhL3V6Zw+6p03TViP169
         jboiUO55vJ/8QL6IQ0e0QcFy2dprJSlecXys6PLgp8+7RCvPSw6kB8lHnwrMCWmPnSil
         rfXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hjScT+0+NYfp5aidkWeFYVYHJ6rSMaKSveRxE97FOLw=;
        b=Uunwbc3L+mzrVsvVsvm1W7w6nGXdy+r3h1jgs1lbSKnDP+2fGGwONJSf46zo3q2O3e
         EXsDgA1zO0H/M26ySFmYzn8sIaZQDbjh+k5ok7IqdDXW8mWQcjfl3LoX6IVjcbRJf4l4
         eOjT7T1RAOYiRsob8i6gibGqJHsaIQKibRm3LKzbTus2QU/GdApk9HzoleEh0I0UkhU/
         tzUvfjIl3aYuf4VXABFy1YxlHHRxe5dQ+B0+CMPT7PulrTe4sXnHy4yoog4sfPURUr4Y
         YgCQ5sPeN3uxoXGR5Rsz5/OAPnk6finiit2mViLhuFq0xlFzBLkrKgrU7dlzccfSCjAk
         I9VA==
X-Gm-Message-State: APjAAAW9d2bqQNgo5kX6d5fzqEcpC1Tx2KB1DHZpo6PLOfRxQdmpR2Pm
        7QZptonn84FEKnAO41ClWMHQD0O413M4e6SX
X-Google-Smtp-Source: APXvYqwKiOLNIj4soyrxMB8qKpZCSFmZwndnWVzUOuc0nT35sDMrdObmds2NagEyF0KytxL1abfH9g==
X-Received: by 2002:adf:e504:: with SMTP id j4mr4157939wrm.222.1565859702930;
        Thu, 15 Aug 2019 02:01:42 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:42 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 10/30] crypto: ccree/des - switch to new verification routines
Date:   Thu, 15 Aug 2019 12:00:52 +0300
Message-Id: <20190815090112.9377-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/ccree/cc_aead.c   | 24 ++++----------------
 drivers/crypto/ccree/cc_cipher.c | 15 ++++--------
 2 files changed, 8 insertions(+), 31 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index a9779a212b18..d3e8faa03f15 100644
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
@@ -649,33 +649,17 @@ static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			       unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
 	if (unlikely(err))
-		goto badkey;
-
-	err = -EINVAL;
-	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
-		goto badkey;
+		return err;
 
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
-		goto out;
-	}
+	err = verify_aead_des3_key(aead, keys.enckey, keys.enckeylen) ?:
+	      cc_aead_setkey(aead, key, keylen);
 
-	err = cc_aead_setkey(aead, key, keylen);
-
-out:
 	memzero_explicit(&keys, sizeof(keys));
 	return err;
-
-badkey:
-	crypto_aead_set_flags(aead, CRYPTO_TFM_RES_BAD_KEY_LEN);
-	goto out;
 }
 
 static int cc_rfc4309_ccm_setkey(struct crypto_aead *tfm, const u8 *key,
diff --git a/drivers/crypto/ccree/cc_cipher.c b/drivers/crypto/ccree/cc_cipher.c
index 5b58226ea24d..c7ec20e90fc0 100644
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
+		     verify_skcipher_des3_key(sktfm, key)) ||
+		    verify_skcipher_des_key(sktfm, key)) {
 			dev_dbg(dev, "weak DES key");
 			return -EINVAL;
 		}
-- 
2.17.1

