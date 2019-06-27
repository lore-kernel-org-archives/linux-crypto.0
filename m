Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 599F6C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30691208CB
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iNyT9wsz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfF0MDl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38981 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726734AbfF0MDi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:38 -0400
Received: by mail-wm1-f65.google.com with SMTP id z23so5412611wma.4
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bm6gxVeRS4kLY3SOsRGZrbNXMPbJj65KkESLS1B6pM0=;
        b=iNyT9wszUH7E0/vIO9JSmmoeE2OJImcnnsfMErA+jjBFD1g8zMboiSwWXBxCHVHVGI
         LUWK9e7VDUZeBpdWRYJoMqTvf4OdW3qyWck/CB4UI9DK+Mk8Ua8sRMf3y4yROQ+/MnCs
         81onjmbASe68efkzssbGLk48kAy1iy8BSw88Y91rQRYfGvbxLQaWyxNpTkJx3aiIc/L7
         vUVpYpCh7idrXypRxYLlWxnrl0DoziCZUi+D5eiZ3cPpTO5MByVjUUDFkmQkaWsVolT4
         39D7wSKQzd4pSvN91m9AY8xiXXjp9ZJI290R5uXryY0PWzIngO3trDVqi9lyJsMrPRJP
         nfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bm6gxVeRS4kLY3SOsRGZrbNXMPbJj65KkESLS1B6pM0=;
        b=RpR/qriYjsJ+pSohhOVzDtUvibKP86Aqfb0nc+83vLDknGXDxFzOJj7R/eH7+oU4+h
         30lv/TgZJquIk2Fg56lvoHRGRBBECEWjwsM/zMJ6T606rldTKVJ9aYJxy1oIZuYcWPaM
         QzxhTc1m39/611hGagFs5VDju6vUKZMJxri3uKW7qWt8bFfdRpDktFgDx8O/zJ6QsIGa
         y3YTw51ehH+BSOLWjl4tonPHxiPyhJfFvWepslBBQooHwKDDLOjMDN45SOIiPcJe11BA
         dWdAO68QyyOoi1aGoLkkrrs5qaehfk/HAvVmic2NEnQTimAVo7U+WJyX95JnCbT8UyzM
         Y6eQ==
X-Gm-Message-State: APjAAAVTVMGVAsUPMNASMzEbnC1vK8cu74i8NQCxVVACsVPSQi9MIhGI
        28UjaO1yhPPlVNDw0NZt1PjdV7vlvqzYUg==
X-Google-Smtp-Source: APXvYqzatmb3trNAqp0PmupjBp/LpPS44royoHiAq/QwiNCdITeEXYZ2NixVCWfB8W+ZFLCcGsT6EQ==
X-Received: by 2002:a7b:c347:: with SMTP id l7mr2909276wmj.163.1561637017011;
        Thu, 27 Jun 2019 05:03:37 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.36
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:36 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 10/30] crypto: ccree/des - switch to new verification routines
Date:   Thu, 27 Jun 2019 14:02:54 +0200
Message-Id: <20190627120314.7197-11-ard.biesheuvel@linaro.org>
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
 drivers/crypto/ccree/cc_aead.c   | 10 +++-------
 drivers/crypto/ccree/cc_cipher.c | 15 ++++-----------
 2 files changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/crypto/ccree/cc_aead.c b/drivers/crypto/ccree/cc_aead.c
index 7aa4cbe19a86..44c621030adc 100644
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
@@ -674,12 +673,9 @@ static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 	if (keys.enckeylen != DES3_EDE_KEY_SIZE)
 		goto badkey;
 
-	flags = crypto_aead_get_flags(aead);
-	err = __des3_verify_key(&flags, keys.enckey);
-	if (unlikely(err)) {
-		crypto_aead_set_flags(aead, flags);
+	err = crypto_des3_ede_verify_key(crypto_aead_tfm(aead), keys.enckey);
+	if (unlikely(err))
 		goto out;
-	}
 
 	err = cc_aead_setkey(aead, key, keylen);
 
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

