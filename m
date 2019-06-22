Return-Path: <SRS0=RljO=UV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B93CC4646C
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF9552084E
	for <linux-crypto@archiver.kernel.org>; Sat, 22 Jun 2019 00:31:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hPtWiFqZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfFVAbs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Jun 2019 20:31:48 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36721 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfFVAbs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jun 2019 20:31:48 -0400
Received: by mail-wm1-f66.google.com with SMTP id u8so8098089wmm.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2019 17:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kkamP1fTsfSENUMZmFXujGUoa+8ty2j1dMRC+wXtb0U=;
        b=hPtWiFqZXGVYo3YUVh5+crVE8BnnIiS3BL3+tfUr1fJk/aDnpwuw/v9scIAi01cf49
         oUMDxiJi3Nto0ORhSV0zSlojIG8cMQy2697RWypNA6sI6UF6kz9ic9ibrIHB78gxpCII
         +/j8W9T2V9zwCb7YHXZRodNt9r7P+ewvkpP8+5EqWBuhMZqLPYqcGJsJT1iuxzs9Z36D
         fdVdtN0hsuIE7focXoUi2gVN2nyzlv/cMn5Tuz1FQTxpWeADbfCb6Q72klD1ursf/lZv
         6PdDldXyuJsNqYTIdriE8hwxloFWDFlH/jBbbcKF9F75Ww78L+Zfd8MMsM6v8x4wnLNH
         hdXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kkamP1fTsfSENUMZmFXujGUoa+8ty2j1dMRC+wXtb0U=;
        b=k0UyCdBZuVZnPrnmLRyzlpZY2WQKQh2PrlxUOCEPgWqtpqM3ArHKzn0oiC0DGMOBUI
         dyLLe7/S+w1yDkafnnGba7IXul2F8TKGfRyOHjuxKc3W858Nz1jp65Sdmjfpr41UcTVN
         JAvEh86DpWcluUP8ErGdYvlA0hWv3x1TTBcq3RLsa8AjJbQHfa3JjQYG0+L3JFzYq/Vv
         M+hjLbFfqg1k/N9E1G++jNb6UCLo2FeBN/IjHn7u0GeHVkNCB8VEOHaeA1y3ygFfwRpY
         QLiFJLwJIMePwieXJd6ipeTL8YdQBMcp3jU0VwURgAkFNBYwcVE1H6NjWAPJlfFNhkYc
         X5ew==
X-Gm-Message-State: APjAAAXjnTqhFhYdEW5ha1b704od5avjREup1qGFeefkwyjizXIBeLrI
        9X/1xitmHDjDYty4Lo+GbRCDWxYb5+UHJBxt
X-Google-Smtp-Source: APXvYqw5XIuRluHnfA60GW7jd2Y3QzMFfT2IYWCETdmQjVmJ8j8AieGdt9/BA3C67HNlSRKdGuvpPA==
X-Received: by 2002:a7b:c842:: with SMTP id c2mr5646707wml.28.1561163505145;
        Fri, 21 Jun 2019 17:31:45 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:99d4:1ff0:ed6:dfbb])
        by smtp.gmail.com with ESMTPSA id v18sm4792019wrd.51.2019.06.21.17.31.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:31:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@google.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 01/30] crypto: des/3des_ede - add new helpers to verify key length
Date:   Sat, 22 Jun 2019 02:30:43 +0200
Message-Id: <20190622003112.31033-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
References: <20190622003112.31033-1-ard.biesheuvel@linaro.org>
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
 include/crypto/internal/des.h | 85 ++++++++++++++++++++
 2 files changed, 85 insertions(+), 13 deletions(-)

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
index 000000000000..e33b32c496cd
--- /dev/null
+++ b/include/crypto/internal/des.h
@@ -0,0 +1,85 @@
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
+static inline int crypto_des_verify_key(struct crypto_tfm *tfm, const u8 *key,
+					unsigned int key_len)
+{
+	u32 tmp[DES_EXPKEY_WORDS];
+	int err = -EINVAL;
+
+	if (key_len != DES_KEY_SIZE) {
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+
+	if (!des_ekey(tmp, key) &&
+	    (fips_enabled || (crypto_tfm_get_flags(tfm) &
+			      CRYPTO_TFM_REQ_FORBID_WEAK_KEYS)))
+		goto bad;
+
+	err = 0;
+out:
+	memzero_explicit(tmp, sizeof(tmp));
+	return err;
+
+bad:
+	crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_WEAK_KEY);
+	goto out;
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
+static inline int crypto_des3_ede_verify_key(struct crypto_tfm *tfm,
+					     const u8 *key,
+					     unsigned int key_len)
+{
+	int err = -EINVAL;
+	u32 K[6];
+
+	if (key_len != DES3_EDE_KEY_SIZE) {
+		crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
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

