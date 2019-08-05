Return-Path: <SRS0=2Ix1=WB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B60C0650F
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:00:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BDCE2147A
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Aug 2019 17:00:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m6Yb3zCN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbfHERA6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Aug 2019 13:00:58 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:55457 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfHERA5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Aug 2019 13:00:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id a15so75447277wmj.5
        for <linux-crypto@vger.kernel.org>; Mon, 05 Aug 2019 10:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hSDBYKF708e7z4RH+WD+TNa+d9tldjOVBDmu19DDFN8=;
        b=m6Yb3zCNoVTrTSaM6L9mYp1v08xefp+vqvxrs//Ue6rmrU6JrZAB8DwQT4Ml2f1rA2
         a67K/MvM/VyZWwmJ/HzxWaYhxodMc25uLwe/Jfmn6Jajvub/XjorxjoSkJpCs3SdpXCX
         qaJrgC9zC1h4VDlNl8MV+HxBOJfsBuYaCWizcWcAgghyjhmqlW/dl4QSOPvfM3uNHtwl
         J+n71fwrz6lWy6cZHZnMbu2tsfBxgVQDDTL07/DbUKbagGIAeogjr/ZQ1J0fQPscjxbH
         gLZkLnyIdRg+Go6SNI5Qbq3vQFK0pjMfunOzcn7fxIIAo/16bRzihmbBiPX2A6+k0kuu
         Vntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hSDBYKF708e7z4RH+WD+TNa+d9tldjOVBDmu19DDFN8=;
        b=ChPp7RFg80BKiDxrwBidG2/ccrJVESzoYL1wOKqKqZGsJfEWWMRegTLB+ssUVhe6g4
         OqwuE+GKEpBD+ERFM2Cnb/PA4GfsJ/yp7sNHm4rsd1jAQXMM0Sf+oRKXjPiXpvSgcLAo
         ml2igfa52hN5T4dSbdnq2epXXje+3jU9hFsDAJ1cVyBJzqggrnAtWblyBmkOgj324hOr
         btIeiqwm0MR+7b1MwG30J74uR1/eWBOA/U3IYWXcsdRhet8/ogMxXMC8C0lYhh1Rvbzo
         WrA8bbfgf7fe6Kb7Pqn2vSWN5VyuzgFYM/Tn6PHLbLumuixPiOF8ANiKLqySSMUI6CCt
         p2sQ==
X-Gm-Message-State: APjAAAWU2H38GMoq9sz3m+xMsBaNd8Bu32NRPdwLwyQwTgWSKsOb+kHL
        OERcROpfcstcAa9eYOmGkZLR6D+fuytj+w==
X-Google-Smtp-Source: APXvYqy28n0Q+MCAWzOHm2eBVBqaxUmR0uFGgVtX5lcxqLHBGGStewS4h4F/PhBLvlU6vooqKKoHWA==
X-Received: by 2002:a1c:4d05:: with SMTP id o5mr19268112wmh.63.1565024454701;
        Mon, 05 Aug 2019 10:00:54 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id j9sm95669383wrn.81.2019.08.05.10.00.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:00:54 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v4 01/30] crypto: des/3des_ede - add new helpers to verify keys
Date:   Mon,  5 Aug 2019 20:00:08 +0300
Message-Id: <20190805170037.31330-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
References: <20190805170037.31330-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The recently added helper routine to perform key strength validation
of triple DES keys is slightly inadequate, since it comes in two versions,
neither of which are highly useful for anything other than skciphers (and
many drivers still use the older blkcipher interfaces).

So let's add a new helper and, considering that this is a helper function
that is only intended to be used by crypto code itself, put it in a new
des.h header under crypto/internal.

While at it, implement a similar helper for single DES, so that we can
start replacing the pattern of calling des_ekey() into a temp buffer
that occurs in many drivers in drivers/crypto.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/des_generic.c          | 13 ---
 include/crypto/internal/des.h | 95 ++++++++++++++++++++
 2 files changed, 95 insertions(+), 13 deletions(-)

diff --git a/crypto/des_generic.c b/crypto/des_generic.c
index dc085514408a..c4d8ecda4ddf 100644
--- a/crypto/des_generic.c
+++ b/crypto/des_generic.c
@@ -841,19 +841,6 @@ static void des_decrypt(struct crypto_tfm *tfm, u8 *dst, const u8 *src)
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
index 000000000000..aad576bad8ad
--- /dev/null
+++ b/include/crypto/internal/des.h
@@ -0,0 +1,95 @@
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
2.17.1

