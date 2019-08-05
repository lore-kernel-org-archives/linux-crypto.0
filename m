Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EA9BC0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B8A52054F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:01:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wdbtv22K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729482AbfHERBl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:01:41 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38244 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728871AbfHERBk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:01:40 -0400
Received: by mail-wr1-f67.google.com with SMTP id g17so85135994wrr.5
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PGua0WZIt91UEgeBUrdKZnsCkK+MXLAWZjIqwFsnjF4=;
        b=wdbtv22KbeZBxZoKdr9HCc1T4iV7TtabLPlVtd9NuzdQTNsrbnpSzZyUfz10PchUgE
         v1bhneT37HR+ItLZVXLpv61YLUpat4dKmUjxbaMdiNTsSA05yxOi3odA7Xy7h4IGpCpL
         nXopI1SPPJtWucbwMoLS5KvBJw/oYpViAvj2uEV4DAqLtB5IE0oKYVo6Bayf6LwPVnE1
         3c+0gl/wRQtnDzPxJTy0LCcJuwCODM3pTFH6tahmSUttWRP0arKjGHhhJK/8o7DqEcvf
         Bnd1s6kyzlZj+XH17YA58eyPKDh9Dt3Pe+M8PPxj0hhnkl+NJefhSgHmCK7n0yYqjjC2
         +Ikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PGua0WZIt91UEgeBUrdKZnsCkK+MXLAWZjIqwFsnjF4=;
        b=I0iB3lmf4KoHGhAo4uOAIGGuM9AvrR7sJrWxoTrN2GrLUg8zXEAbBw3hWgdIvyy2oE
         Dj7/yNfmjxQQmG6L0e2HWz+G9yDO1EolBRZesNmZ1fF/kh1xSozGaTxvMkH2pHIYoDGt
         UOvl1XDPpL8m+OLQpFvEWLSabIqMktsPt2uv6813gKlOagazDr5am0gmyUMl0oGPihaG
         89Rg+v2DNREohG5SINpZnM2r76K9RwOtOvkhfoyh7n8Zp0cBgfjjcK7e8LxrXsSq1jvk
         kOT7KrweWPIquuHTirs9ce20Rhwa3mfzHlctCMeIyC0nuadObUpu65vmUr30aehbuo2I
         b+/Q==
X-Gm-Message-State: APjAAAXnHGOWObf/QqMQ+96e9rxzwV20Gq8hul+nmxjdoI3anKxZJNa/
        AO9QysID1MDMJ5/HmPWiSeTAS0YhQZ6fgg==
X-Google-Smtp-Source: APXvYqx5zJt2qnFv2/Jhtc1n7PSd+Ndn49QjBhPPa5PAO+lFIbDoJdYyNt918dXXtybhbiVV5cGnVQ==
X-Received: by 2002:a5d:65c5:: with SMTP id e5mr25461123wrw.266.1565024498098;
        Mon, 05 Aug 2019 10:01:38 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.01.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:01:37 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 10/30] crypto: ccree/des - switch to new verification routines
Date:   Mon,  5 Aug 2019 20:00:17 +0300
Message-Id: <20190805170037.31330-11-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
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
index ce302adc76c7..8174ff1d93d6 100644
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
@@ -648,7 +648,6 @@ static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
 			       unsigned int keylen)
 {
 	struct crypto_authenc_keys keys;
-	u32 flags;
 	int err;
 
 	err = crypto_authenc_extractkeys(&keys, key, keylen);
@@ -659,14 +658,8 @@ static int cc_des3_aead_setkey(struct crypto_aead *aead, const u8 *key,
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
2.17.1

