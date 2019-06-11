Return-Path: <SRS0=vn8P=UK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8F4C31E44
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D142820872
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jun 2019 23:09:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sEUwrC6t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407943AbfFKXJs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 19:09:48 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:51630 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405298AbfFKXJs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 19:09:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id 207so4615514wma.1
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2019 16:09:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=stBj9R470eTrFxTy8rUh9qMz0b4KHQ3ldsc1vJio+Ns=;
        b=sEUwrC6tHnbBL9+crAN77U9UrNWzyrKbg4jxXQ4RuWZyPSjKDTpwtSBRs1Cq3XveHK
         8y93bE+7e7pIJpw3owo9Eqx6lb6W1Iwp/OyKZ0QuMT37C9dc7bwz/FpRyBHf5LNYQJUI
         qGVQkjnWj5GSulGXQaGi2x3P9tZbjzHe4BGw22MxxSWcIIhQ+e8By5kDhcfxjJkGuWFK
         SYYJLtBHfKd3I5YnpNAD3wMVnUMtbU4coNQddR9I8RsKNfnIpi2LTtEVCCY6npOyNieY
         SCRt7Tg6MLsyfcVpaMNttvR7o2ATtlZgTm+kigz07EpD8mK6/7s3nvFy+hl+jJwEhHVZ
         AyEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=stBj9R470eTrFxTy8rUh9qMz0b4KHQ3ldsc1vJio+Ns=;
        b=X2McYUYVZ6emWvC6l5aWu8uMelMnXrtULOKarOil3aX08plziyXBDrv89CqtIJ1SBN
         LC6w53o0o4qOX3zLU8WGUtOonBOK3MDZUSy2IIkhBdYvXp8JGoUZQS6+lpCLmVDNaQMv
         MGmxkfGydoNZg1vE/l2h1NDsJWzRRl+lIp081KiqNvmW1hRE8xonVyk6XsTj4dxGO91/
         cczr6mPXPMRsVTU9SHnORj9l10ig35tbQt3E57djoilmLBv+BW6hZcP3W/MQAllNPbNh
         QYn2X0Y0BYLB4cJ0CmpgJNvfZ2cKhGv5pNY/uezBntVOJAczarkg2mgcb8S9npe0ih3d
         3YBg==
X-Gm-Message-State: APjAAAVYCylDxz+/kUiajoa1S7PK5vYe1tiDAJSEuzvtu8Zv1tIFy2vq
        DnC95YZQjVVixK5iElDQpMY354/jy/bWnNm7
X-Google-Smtp-Source: APXvYqwIGi6U6jFNaom+wwjARCJ2DNpxGwwHM1hR3LKRLnBT7HeYRxzDctvLjXMmsHCuQuEZTCfEqQ==
X-Received: by 2002:a1c:ef10:: with SMTP id n16mr17637860wmh.134.1560294585049;
        Tue, 11 Jun 2019 16:09:45 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:24bb:7f31:25fe:43a7])
        by smtp.gmail.com with ESMTPSA id g11sm10827813wrq.89.2019.06.11.16.09.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Jun 2019 16:09:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v4 1/7] crypto: arc4 - refactor arc4 core code into separate library
Date:   Wed, 12 Jun 2019 01:09:32 +0200
Message-Id: <20190611230938.19265-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
References: <20190611230938.19265-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Refactor the core rc4 handling so we can move most users to a library
interface, permitting us to drop the cipher interface entirely in a
future patch. This is part of an effort to simplify the crypto API
and improve its robustness against incorrect use.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 MAINTAINERS           |  1 +
 crypto/Kconfig        |  4 ++
 crypto/arc4.c         | 60 +---------------
 include/crypto/arc4.h | 10 +++
 lib/Makefile          |  2 +-
 lib/crypto/Makefile   |  4 ++
 lib/crypto/arc4.c     | 72 ++++++++++++++++++++
 7 files changed, 93 insertions(+), 60 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 57f496cff999..112f21066141 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4241,6 +4241,7 @@ F:	crypto/
 F:	drivers/crypto/
 F:	include/crypto/
 F:	include/linux/crypto*
+F:	lib/crypto/
 
 CRYPTOGRAPHIC RANDOM NUMBER GENERATOR
 M:	Neil Horman <nhorman@tuxdriver.com>
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 3d056e7da65f..5114b35ef3b4 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1230,9 +1230,13 @@ config CRYPTO_ANUBIS
 	  <https://www.cosic.esat.kuleuven.be/nessie/reports/>
 	  <http://www.larc.usp.br/~pbarreto/AnubisPage.html>
 
+config CRYPTO_LIB_ARC4
+	tristate
+
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_LIB_ARC4
 	help
 	  ARC4 cipher algorithm.
 
diff --git a/crypto/arc4.c b/crypto/arc4.c
index a2120e06bf84..6974dba1b7b9 100644
--- a/crypto/arc4.c
+++ b/crypto/arc4.c
@@ -13,33 +13,12 @@
 #include <linux/init.h>
 #include <linux/module.h>
 
-struct arc4_ctx {
-	u32 S[256];
-	u32 x, y;
-};
-
 static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
 			unsigned int key_len)
 {
 	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
-	int i, j = 0, k = 0;
-
-	ctx->x = 1;
-	ctx->y = 0;
 
-	for (i = 0; i < 256; i++)
-		ctx->S[i] = i;
-
-	for (i = 0; i < 256; i++) {
-		u32 a = ctx->S[i];
-		j = (j + in_key[k] + a) & 0xff;
-		ctx->S[i] = ctx->S[j];
-		ctx->S[j] = a;
-		if (++k >= key_len)
-			k = 0;
-	}
-
-	return 0;
+	return arc4_setkey(ctx, in_key, key_len);
 }
 
 static int arc4_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
@@ -48,43 +27,6 @@ static int arc4_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
 	return arc4_set_key(&tfm->base, in_key, key_len);
 }
 
-static void arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in,
-		       unsigned int len)
-{
-	u32 *const S = ctx->S;
-	u32 x, y, a, b;
-	u32 ty, ta, tb;
-
-	if (len == 0)
-		return;
-
-	x = ctx->x;
-	y = ctx->y;
-
-	a = S[x];
-	y = (y + a) & 0xff;
-	b = S[y];
-
-	do {
-		S[y] = a;
-		a = (a + b) & 0xff;
-		S[x] = b;
-		x = (x + 1) & 0xff;
-		ta = S[x];
-		ty = (y + ta) & 0xff;
-		tb = S[ty];
-		*out++ = *in++ ^ S[a];
-		if (--len == 0)
-			break;
-		y = ty;
-		a = ta;
-		b = tb;
-	} while (true);
-
-	ctx->x = x;
-	ctx->y = y;
-}
-
 static void arc4_crypt_one(struct crypto_tfm *tfm, u8 *out, const u8 *in)
 {
 	arc4_crypt(crypto_tfm_ctx(tfm), out, in, 1);
diff --git a/include/crypto/arc4.h b/include/crypto/arc4.h
index 5b2c24ab0139..f3c22fe01704 100644
--- a/include/crypto/arc4.h
+++ b/include/crypto/arc4.h
@@ -6,8 +6,18 @@
 #ifndef _CRYPTO_ARC4_H
 #define _CRYPTO_ARC4_H
 
+#include <linux/types.h>
+
 #define ARC4_MIN_KEY_SIZE	1
 #define ARC4_MAX_KEY_SIZE	256
 #define ARC4_BLOCK_SIZE		1
 
+struct arc4_ctx {
+	u32 S[256];
+	u32 x, y;
+};
+
+int arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len);
+void arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int len);
+
 #endif /* _CRYPTO_ARC4_H */
diff --git a/lib/Makefile b/lib/Makefile
index fb7697031a79..d3daedf93c5a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -102,7 +102,7 @@ endif
 obj-$(CONFIG_DEBUG_INFO_REDUCED) += debug_info.o
 CFLAGS_debug_info.o += $(call cc-option, -femit-struct-debug-detailed=any)
 
-obj-y += math/
+obj-y += math/ crypto/
 
 obj-$(CONFIG_GENERIC_IOMAP) += iomap.o
 obj-$(CONFIG_GENERIC_PCI_IOMAP) += pci_iomap.o
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
new file mode 100644
index 000000000000..88195c34932d
--- /dev/null
+++ b/lib/crypto/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_CRYPTO_LIB_ARC4) += libarc4.o
+libarc4-y := arc4.o
diff --git a/lib/crypto/arc4.c b/lib/crypto/arc4.c
new file mode 100644
index 000000000000..fa589eba3d50
--- /dev/null
+++ b/lib/crypto/arc4.c
@@ -0,0 +1,72 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Cryptographic API
+ *
+ * ARC4 Cipher Algorithm
+ *
+ * Jon Oberheide <jon@oberheide.org>
+ */
+
+#include <crypto/arc4.h>
+#include <linux/module.h>
+
+int arc4_setkey(struct arc4_ctx *ctx, const u8 *in_key, unsigned int key_len)
+{
+	int i, j = 0, k = 0;
+
+	ctx->x = 1;
+	ctx->y = 0;
+
+	for (i = 0; i < 256; i++)
+		ctx->S[i] = i;
+
+	for (i = 0; i < 256; i++) {
+		u32 a = ctx->S[i];
+
+		j = (j + in_key[k] + a) & 0xff;
+		ctx->S[i] = ctx->S[j];
+		ctx->S[j] = a;
+		if (++k >= key_len)
+			k = 0;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(arc4_setkey);
+
+void arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int len)
+{
+	u32 *const S = ctx->S;
+	u32 x, y, a, b;
+	u32 ty, ta, tb;
+
+	if (len == 0)
+		return;
+
+	x = ctx->x;
+	y = ctx->y;
+
+	a = S[x];
+	y = (y + a) & 0xff;
+	b = S[y];
+
+	do {
+		S[y] = a;
+		a = (a + b) & 0xff;
+		S[x] = b;
+		x = (x + 1) & 0xff;
+		ta = S[x];
+		ty = (y + ta) & 0xff;
+		tb = S[ty];
+		*out++ = *in++ ^ S[a];
+		if (--len == 0)
+			break;
+		y = ty;
+		a = ta;
+		b = tb;
+	} while (true);
+
+	ctx->x = x;
+	ctx->y = y;
+}
+EXPORT_SYMBOL(arc4_crypt);
-- 
2.20.1

