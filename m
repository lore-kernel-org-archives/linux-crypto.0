Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57595C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F1932086D
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 12:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ubqKQ+FD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfF0MDb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:03:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37983 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbfF0MDa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 08:03:30 -0400
Received: by mail-wm1-f68.google.com with SMTP id s15so5395985wmj.3
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 05:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d6Ad4sF3J0KuAM2WiwWhIDJxHqK9C/INPTZTWpUiWwE=;
        b=ubqKQ+FDUwuRQCqth9NGF5DYW8EDnnD81kksG95rwoXctsIrvVdFgHa4pKwIE4d3mO
         1F7TD5kB75Q07PtOJKhc18f9OhlHxt1vURb2rJvM/WFIsuntanaP/2/5y0A1ob55UEYk
         ReT4ChZFY96G2kMa87941xub+l0yW1DtMp99qwidbEOPx2rA2lqq5ijTz9TUAZ7mXLG7
         dHfPIng4aM/aEF+/vdbNF/H/txmGq8H4t1SQKhm22g3CLnQBiwCCLzVGNX+XTrIp194g
         AlEtyZhIL4GF05zSXg7Zv0C6odEu2VyuKXmKMiiWC+H2i5QdSAyjL1DKrHXcX9+Ky2aE
         qK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d6Ad4sF3J0KuAM2WiwWhIDJxHqK9C/INPTZTWpUiWwE=;
        b=kC4t9ehopzbzJ9WciBLnDH4aWNxciuPUlZc+JM4GQVDcq+keQ3/5Yi+6CqCNk4WMan
         GnWCpI4j9y97m80mNFwmL6WpGtNPF08MNxl/kJoedaX1z+AEwnXTYUVIhlpKRhUc1IMC
         H6MdQHYdK/JR0LSNKown2AizLpmIURrvVDcQNJf4974qUmSaVBU9E/yZH6/n/9pqX0O7
         PuSW5KYuZxJPiVJMDnDgc221snsQku/u44yydPAq4cL4qDTWl+mIOtPAmBkAKh/u1BLX
         jHBdhS/pZY1K3bwmha8nAzwOrfqCB5Hf3zXq0sUp09UXpM5oXFfZrK8YBEceCTJAYVKY
         RXoA==
X-Gm-Message-State: APjAAAXE0aVUiS9ODOyYooKMCu7Zt0C+Oq9OCZiHf7kj8hDrffc6w3tK
        QOMUn7+XwpqBK71wJYh4DWTlJEfLXrCHww==
X-Google-Smtp-Source: APXvYqxJPp02nSPah4xWhiAyHIWUvkr4eVNCkEIzjd++xJA8gCETCEZBf/mZ1ukCdz6PLQ1kK5OCJw==
X-Received: by 2002:a1c:6a0e:: with SMTP id f14mr461945wmc.154.1561637006901;
        Thu, 27 Jun 2019 05:03:26 -0700 (PDT)
Received: from localhost.localdomain (laubervilliers-657-1-83-120.w92-154.abo.wanadoo.fr. [92.154.90.120])
        by smtp.gmail.com with ESMTPSA id z126sm7732431wmb.32.2019.06.27.05.03.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 05:03:26 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        horia.geanta@nxp.com, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 01/30] crypto: des/3des_ede - add new helpers to verify key length
Date:   Thu, 27 Jun 2019 14:02:45 +0200
Message-Id: <20190627120314.7197-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
References: <20190627120314.7197-1-ard.biesheuvel@linaro.org>
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

