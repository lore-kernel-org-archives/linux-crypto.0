Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCB3AC31E46
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 16:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C13E2082C
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 16:20:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SjEjVx4Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730837AbfFLQUK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 12 Jun 2019 12:20:10 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37098 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730289AbfFLQUI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 12 Jun 2019 12:20:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id 22so7182576wmg.2
        for <linux-crypto@vger.kernel.org>; Wed, 12 Jun 2019 09:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NsVVAoh4ycTfhIVgfTwtZHIgoe8z7I00wgM8parRZuE=;
        b=SjEjVx4Z0LrOq2S+1/alZudgs652C6+QkuK6c6QUb2MyQA1smUQZx4HJkkgdArXZyj
         +R00SzlJxWjK4dn2C2RdPWjZv2pN+BlZKQHTLRE2TUrRjrJUkUs5tHHdEEsGOmRZFUtG
         xa7miGbQZVDJJKlVYCOgSz/z0Y3obPpuppNh6PkQV1T5vrOxn3EF56/ktzopfdDPQZGK
         T1XXScdReyiMLPvKFUw525k9wQzwPHy2IQ73NmSDG+jqtgA5yMjyOwciFpUoazqCrYFy
         NwUMUaW6n/bSuz6E/Sw69uhSFlh3Rxk1hSrLC9LcOf//KunjIX4Bhfu5LcBQ42D9vg44
         lyog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NsVVAoh4ycTfhIVgfTwtZHIgoe8z7I00wgM8parRZuE=;
        b=RDcH8zvbs/e2d6DD8IylAfsRUAEgffNdX2xmPAKMlEfCheImG6uWrvbwNp4vNxLA2a
         bxEyvHaLHzmOAPsmnvJBWRPS78ptcJZJNmG+u/xisybB9LcGFvD8CYLzhb/zzM2UUFW0
         B5uceaVk2oE137wBvmHyBOkmKoZEKRNggtEkEluySYYXh0cIBf/30AsqrCsEwW5gC5P6
         Lbi024kWuhgHdIPCKAJ1ICLZxuFqw6lvjGnhKi8fhZmdvCTH6AZwP4oNmWYIDbylmvw3
         rx+av9tOx8FBODs8syhIaztsenxcmL1dBf8skKL3CsPM7YQrzvN40GOumRibZKnlDtJi
         yOYg==
X-Gm-Message-State: APjAAAWoGgh6i/mih3Zdpeg89ws+aHXt0GtyB2LTsDWAr66uZa5VVjno
        blXlnzsmvc18aZuguYciBs5z7UspPPhVEg==
X-Google-Smtp-Source: APXvYqySlpCStlOPb5ywJmeMRfam18eX0jtb6psdB3j/QgSXPUvO52rHQXE07vOl9Wyhre2EJNW6SA==
X-Received: by 2002:a1c:544d:: with SMTP id p13mr42072wmi.78.1560356405686;
        Wed, 12 Jun 2019 09:20:05 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:353a:f33a:a393:3ada])
        by smtp.gmail.com with ESMTPSA id c16sm70172wrr.53.2019.06.12.09.20.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 09:20:05 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v5 1/7] crypto: arc4 - refactor arc4 core code into separate library
Date:   Wed, 12 Jun 2019 18:19:53 +0200
Message-Id: <20190612161959.30478-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
References: <20190612161959.30478-1-ard.biesheuvel@linaro.org>
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
 lib/crypto/arc4.c     | 74 ++++++++++++++++++++
 7 files changed, 95 insertions(+), 60 deletions(-)

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
index 000000000000..c2020f19c652
--- /dev/null
+++ b/lib/crypto/arc4.c
@@ -0,0 +1,74 @@
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
+
+MODULE_LICENSE("GPL");
-- 
2.20.1

