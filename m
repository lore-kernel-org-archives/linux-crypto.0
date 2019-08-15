Return-Path: <SRS0=pRBs=WL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25B05C31E40
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E70C0218A6
	for <linux-crypto@archiver.kernel.org>; Thu, 15 Aug 2019 09:01:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZBzs54Jx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730781AbfHOJB3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 15 Aug 2019 05:01:29 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37603 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730775AbfHOJB3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Aug 2019 05:01:29 -0400
Received: by mail-wm1-f68.google.com with SMTP id z23so681722wmf.2
        for <linux-crypto@vger.kernel.org>; Thu, 15 Aug 2019 02:01:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3e2r3FOBL6j9iIvv8ejDaqbpez9yR+KjkK0z8y6sTy4=;
        b=ZBzs54JxjasIE9zXkcHOSaxoSJtCfjasy9gTPfsbnUhNZ09AVgBcFEcpyEdGK55eTa
         DZbdcesQ5BY0S2ClFh87V435c2qBOYN2cZJI62iZxgC+bztejgShWAKviwsz2PpoHltC
         vYM/kU81U1TeE5FDmXMYKGsmsmlH9qMjyQgYoFsE2JAHLKswValBXAqVWIUI7+WWLFKx
         sifztdmq30Jw1b6Fcb4ac6Y7tr943srTqE69nsJCgvY0hGvCUPT92kyPSbD6RQfFjbEG
         c/9N5WkvgYdWlpFyI+iiZgzacEk8LFN1ZiltzBCPBV3PdwSTcoE2L9r8Y/bKUDgVlL1l
         smQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3e2r3FOBL6j9iIvv8ejDaqbpez9yR+KjkK0z8y6sTy4=;
        b=il8T5kJKEzSpQsJvU99e4jZ2v7erIN+cLvyAyDTIUEiYCXEzujoL9Ah8dC3ZhXncVT
         30OmujU1Pqh4fW+5O68OkQz595s/p3XS7mGwIY7RSMNIHSHBnjUzf4fh2a/YY0voJtLQ
         TFDgtcWFYXHWyVmcAlBeBorOo00nM6bi+SMrAdeTODTh35vjtPhLfsxX9b60t7yWEXX+
         BpGYmuWg08l46XnyWhLCCHBRpegCkcGEcn6YeQ7s78/7vc7gWnliNyM9xhqrDj+3Klpb
         OO1laK8QzgmjEIytBAj/WOGX5pwKB4vi0K+aBu5eLP5z+hT8NwACJ3DmbCWeWxvZExUx
         TOJQ==
X-Gm-Message-State: APjAAAU2E2jbO9uTazmChEoL3X86MJ0hLwE6rrvjCZu+Ti+NCsFPVumE
        DfqLoRf7avTt6AcQAsS+3tHZJ+em6sQRyVxu
X-Google-Smtp-Source: APXvYqyrCypr4I+DpjxqM5fRVk30LBctPb49Ir8rFkAvVMHMOSHViwKrdhSZmgF0IIDvOgKW1DH8ww==
X-Received: by 2002:a7b:ca54:: with SMTP id m20mr704720wml.102.1565859685962;
        Thu, 15 Aug 2019 02:01:25 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:f1b5:e68c:5f7f:79e7])
        by smtp.gmail.com with ESMTPSA id x20sm3857533wrg.10.2019.08.15.02.01.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 02:01:25 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 01/30] crypto: des/3des_ede - add new helpers to verify keys
Date:   Thu, 15 Aug 2019 12:00:43 +0300
Message-Id: <20190815090112.9377-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
References: <20190815090112.9377-1-ard.biesheuvel@linaro.org>
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
 crypto/des_generic.c          |  13 --
 include/crypto/internal/des.h | 141 ++++++++++++++++++++
 2 files changed, 141 insertions(+), 13 deletions(-)

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
index 000000000000..f5d2e696522e
--- /dev/null
+++ b/include/crypto/internal/des.h
@@ -0,0 +1,141 @@
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
+#include <crypto/aead.h>
+#include <crypto/skcipher.h>
+
+/**
+ * crypto_des_verify_key - Check whether a DES key is weak
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
+ * crypto_des3_ede_verify_key - Check whether a DES3-EDE key is weak
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
+static inline int verify_skcipher_des_key(struct crypto_skcipher *tfm,
+					  const u8 *key)
+{
+	return crypto_des_verify_key(crypto_skcipher_tfm(tfm), key);
+}
+
+static inline int verify_skcipher_des3_key(struct crypto_skcipher *tfm,
+					   const u8 *key)
+{
+	return crypto_des3_ede_verify_key(crypto_skcipher_tfm(tfm), key);
+}
+
+static inline int verify_ablkcipher_des_key(struct crypto_ablkcipher *tfm,
+					    const u8 *key)
+{
+	return crypto_des_verify_key(crypto_ablkcipher_tfm(tfm), key);
+}
+
+static inline int verify_ablkcipher_des3_key(struct crypto_ablkcipher *tfm,
+					     const u8 *key)
+{
+	return crypto_des3_ede_verify_key(crypto_ablkcipher_tfm(tfm), key);
+}
+
+static inline int verify_aead_des_key(struct crypto_aead *tfm, const u8 *key,
+				      int keylen)
+{
+	if (keylen != DES_KEY_SIZE) {
+		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	return crypto_des_verify_key(crypto_aead_tfm(tfm), key);
+}
+
+static inline int verify_aead_des3_key(struct crypto_aead *tfm, const u8 *key,
+				       int keylen)
+{
+	if (keylen != DES3_EDE_KEY_SIZE) {
+		crypto_aead_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	return crypto_des3_ede_verify_key(crypto_aead_tfm(tfm), key);
+}
+
+#endif /* __CRYPTO_INTERNAL_DES_H */
-- 
2.17.1

