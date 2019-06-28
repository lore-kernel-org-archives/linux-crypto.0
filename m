Return-Path: <SRS0=Fqdl=U3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6D5C4321A
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE2AF20665
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jun 2019 09:35:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MfQZJHZg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfF1Jfn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jun 2019 05:35:43 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:55294 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbfF1Jfm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jun 2019 05:35:42 -0400
Received: by mail-wm1-f66.google.com with SMTP id g135so8407183wme.4
        for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2019 02:35:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6Ad4sF3J0KuAM2WiwWhIDJxHqK9C/INPTZTWpUiWwE=;
        b=MfQZJHZgSFSJlEPSo4vhyo+HOPH3N0XJyJU3gZ5EvaR6mUDuJOcCvoH5Xihxa4igur
         IjQyHHPBVP3YEXmtos9R9j0w0WaT9xaq60c6PHWfdHwZ0sMDR2BBHZIVDTi8cbQwULiZ
         nCdgeA67OM6wkEOKit/VhgS+FP0JY4VTHINR9dDvEc53Z5aExahVX45G/PggQvT37JOP
         qUTyvi7Nd/kfw1Np7LJdhDSQxWo7rjhWy0+ruTMtObEBAhhtZgIpEllojyKfFi+ywecx
         yAXw2CjVs7f5p7VNkPNNLfAztk4pPVJb65Fg9Vj3kCLxmegmQRg8hD/sfxvZaCfPa2/u
         OZ+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6Ad4sF3J0KuAM2WiwWhIDJxHqK9C/INPTZTWpUiWwE=;
        b=bsz1JbOatm89proVP4aHJ77uTBVkPtLcRistXtI4XlD8ggb2aCQzllvqKgvlsuBhYI
         GURUdougrCr9R9lhNERw6VZ1kGGDqDhBBfWAZNfIYl3ZNwPV3xxieUlnStxBW6AYyJkq
         QqqfRGqgXJUItbVZ10WOwuy0uaEYMnHeS6NEM/QKRkQSGVPv2EWQQ6uiLGE4bxomTb9u
         Ypv5iZoNoCf1SpdJsptldNtj+kiMGUeFEUqqCc/vOwTAiaWZ5b3JUFLBxbZflp7IFu0F
         4R8KBqXHd4bkfBYVAyLFFfoc8vzK+82AnVZMLVccTmyk51dgD2xmkEdP75goWUZuD8OY
         9iow==
X-Gm-Message-State: APjAAAUQ5nOozU6TB+RgIYrWOxaQhVUwPTJDtB66dgPk5adgRlPquH1d
        Fc4bLIC/YSGS7FX6HHYLHBZ3co3ro11GdA==
X-Google-Smtp-Source: APXvYqzHVtn1XvZFmDkP+rS1q0JKpe6bFxNsCkoDaS2d3gtv1tsJYeE/CO+GWBtS90G3zxYbRe18Kw==
X-Received: by 2002:a7b:cbc6:: with SMTP id n6mr6884977wmi.14.1561714539278;
        Fri, 28 Jun 2019 02:35:39 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id m24sm1709910wmi.39.2019.06.28.02.35.38
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 28 Jun 2019 02:35:38 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 01/30] crypto: des/3des_ede - add new helpers to verify key length
Date:   Fri, 28 Jun 2019 11:35:00 +0200
Message-Id: <20190628093529.12281-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
References: <20190628093529.12281-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The recently added helper routines to perform key strength validation
of 3ede_keys is slightly inadequate, since it doesn't check the key
length, and it comes in two versions, neither of which are highly
useful for anything other than skciphers (and many users still use the
older blkcipher interfaces).

So let's add a new helper and, considering that this is a helper function
that is only intended to be used by crypto code itself, put it in a new
des.h header under crypto/internal.

While at it, implement a similar helper for single DES, so that we can
replace the pattern of calling des_ekey() into a temp buffer that occurs
in many drivers in drivers/crypto.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/des_generic.c          | 13 ---
 include/crypto/internal/des.h | 96 ++++++++++++++++++++
 2 files changed, 96 insertions(+), 13 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index d7a88b4fa611..c94a303da4dd 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -846,19 +846,6 @@ static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
 	d[1] = cpu_to_le32(L);
 }
 
-/*
- * RFC2451:
- *
- *   For DES-EDE3, there is no known need to reject weak or
- *   complementation keys.  Any weakness is obviated by the use of
- *   multiple keys.
- *
- *   However, if the first two or last two independent 64-bit keys are
- *   equal (k1 == k2 or k2 == k3), then the DES3 operation is simply the
- *   same as DES.  Implementers MUST reject keys that exhibit this
- *   property.
- *
- */
 int __des3_ede_setkey(u32 *expkey, u32 *flags, const u8 *key,
 		      unsigned int keylen)
 {
diff --git a/include/crypto/internal/des.h b/include/crypto/internal/des.h
new file mode 100644
index 000000000000..53dffa0667ca
--- /dev/null
+++ b/include/crypto/internal/des.h
@@ -0,0 +1,96 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * DES & Triple DES EDE key verification helpers
+ */
+
+#ifndef __CRYPTO_INTERNAL_DES_H
+#define __CRYPTO_INTERNAL_DES_H
+
+#include <linux/crypto.h>
+#include <linux/fips.h>
+#include <crypto/des.h>
+
+/**
+ * crypto_des_verify_key - Check whether a DES is weak
+ * @tfm: the crypto algo
+ * @key: the key buffer
+ *
+ * Returns -EINVAL if the key is weak and the crypto TFM does not permit weak
+ * keys. Otherwise, 0 is returned.
+ *
+ * It is the job of the caller to ensure that the size of the key equals
+ * DES_KEY_SIZE.
+ */
+static inline int crypto_des_verify_key(struct crypto_tfm *tfm, const u8 *key)
+{
+	u32 tmp[DES_EXPKEY_WORDS];
+	int err = 0;
+
+	if (!(crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_FORBID_WEAK_KEYS))
+		return 0;
+
+	if (!des_ekey(tmp, key)) {
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
+		err = -EINVAL;
+	}
+
+	err = 0;
+	memzero_explicit(tmp, sizeof(tmp));
+	return err;
+}
+
+/*
+ * RFC2451:
+ *
+ *   For DES-EDE3, there is no known need to reject weak or
+ *   complementation keys.  Any weakness is obviated by the use of
+ *   multiple keys.
+ *
+ *   However, if the first two or last two independent 64-bit keys are
+ *   equal (k1 == k2 or k2 == k3), then the DES3 operation is simply the
+ *   same as DES.  Implementers MUST reject keys that exhibit this
+ *   property.
+ *
+ */
+
+/**
+ * crypto_des3_ede_verify_key - Check whether a DES3-EDE is weak
+ * @tfm: the crypto algo
+ * @key: the key buffer
+ *
+ * Returns -EINVAL if the key is weak and the crypto TFM does not permit weak
+ * keys or when running in FIPS mode. Otherwise, 0 is returned. Note that some
+ * keys are rejected in FIPS mode even if weak keys are permitted by the TFM
+ * flags.
+ *
+ * It is the job of the caller to ensure that the size of the key equals
+ * DES3_EDE_KEY_SIZE.
+ */
+static inline int crypto_des3_ede_verify_key(struct crypto_tfm *tfm,
+					     const u8 *key)
+{
+	int err = -EINVAL;
+	u32 K[6];
+
+	memcpy(K, key, DES3_EDE_KEY_SIZE);
+
+	if ((!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
+	     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
+	    (fips_enabled || (crypto_tfm_get_flags(tfm) &
+		              CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)))
+		goto bad;
+
+	if ((!((K[0] ^ K[4]) | (K[1] ^ K[5]))) && fips_enabled)
+		goto bad;
+
+	err = 0;
+out:
+	memzero_explicit(K, DES3_EDE_KEY_SIZE);
+	return err;
+
+bad:
+	crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
+	goto out;
+}
+
+#endif /* __CRYPTO_INTERNAL_DES_H */
-- 
2.20.1

