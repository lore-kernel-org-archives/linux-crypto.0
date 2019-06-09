Return-Path: <SRS0=Xb3v=UI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAE23C28EBD
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Jun 2019 11:55:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 94DB220673
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Jun 2019 11:55:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JJyggX2S"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728379AbfFILzS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Jun 2019 07:55:18 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32876 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728294AbfFILzR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Jun 2019 07:55:17 -0400
Received: by mail-wm1-f66.google.com with SMTP id h19so7102774wme.0
        for <linux-crypto@vger.kernel.org>; Sun, 09 Jun 2019 04:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VGIc7WT0Dz8Jie4kHfTOvssLHE5sfm2ocpHIuRMXKd4=;
        b=JJyggX2SeiGxsibPlXLVv3c9R/55U5nFlO9gZxiBlsRraTJLjGvq5W642s3K2YI3r/
         r4XeoB6pzQhwh7NoL50eUm7IhBmEBNTMJ5006QWLYSPN8FAXFipv3M9w/oFDSweae7KF
         Ghjygzv2bpk9TYD0fF/7awiEbFom5y5cWsXbRyZNV1SJ82hIB1Rq7Z6RNC1kVd3vwyR+
         5ZYkuRRWkJc+XplgLpDnjJaWyaI1YMzoXtnWAmb/Pjf8eY2X1yjlTOjS8ziH1/qsF2/R
         fg9t5ZPGiz7t0bWx/xR9hEBp6bj/trAwtUZ2mdMNiLPfJpJOTZXid/IZX1Ruf7kdg39y
         rILA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VGIc7WT0Dz8Jie4kHfTOvssLHE5sfm2ocpHIuRMXKd4=;
        b=TQNQ0GpLwIm1ph+q0aSRf6220ZtQnwafuYFg8QOG5ahOIOfsHnmMg9kE7bWnoVpiDZ
         WiLm5+oaqiQEeGL41ZVEDq0+2lf2qpCo8vZmD1P9ZHHW0d0X8WY98VGOmxqtfznOk1hC
         pD8GV0r3xqfeDdWsM7v/n5UYNN6LoBha+pW7iOoUmlErQJ15mcGe8Cewgr2TwEKY9cUZ
         /Zk2fsAzNGkk6AOjrlgypsaq588hCRndoI/fWsHSVPeErBm0okfKitixZp8hW2fUjnay
         O2Zi/HyzGMOXT8grPzKmJ1d8/NHB93zL5K3V1DBdlZHhC15l5JlJHcUodoSveGJiHkHI
         JC0g==
X-Gm-Message-State: APjAAAULemZVJqr1jYZTsODm6Husqz06G4N6e3DS+dlrLfkuvuesACNB
        vd3676afL8tOXru574ln5lK1DXSjVA14ng==
X-Google-Smtp-Source: APXvYqx9DLNQ1Os9c5nmXaNHooNeThub/lNsJfNvtectK7gKjH1OxL7c//dCPHxzN6NA3IZtvJxe/w==
X-Received: by 2002:a05:600c:21c6:: with SMTP id x6mr10033450wmj.102.1560081314173;
        Sun, 09 Jun 2019 04:55:14 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:5129:23cd:5870:89d4])
        by smtp.gmail.com with ESMTPSA id r5sm14954317wrg.10.2019.06.09.04.55.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 04:55:13 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 1/7] crypto: arc4 - refactor arc4 core code into separate library
Date:   Sun,  9 Jun 2019 13:55:03 +0200
Message-Id: <20190609115509.26260-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
References: <20190609115509.26260-1-ard.biesheuvel@linaro.org>
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
 crypto/arc4.c         | 74 +++-----------------
 include/crypto/arc4.h | 13 ++++
 lib/Makefile          |  2 +-
 lib/crypto/Makefile   |  3 +
 lib/crypto/libarc4.c  | 74 ++++++++++++++++++++
 7 files changed, 104 insertions(+), 67 deletions(-)

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
index 3d056e7da65f..310e2a5de59d 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1230,9 +1230,13 @@ config CRYPTO_ANUBIS
 	  <https://www.cosic.esat.kuleuven.be/nessie/reports/>
 	  <http://www.larc.usp.br/~pbarreto/AnubisPage.html>
 
+config CRYPTO_LIB_ARC4
+	bool
+
 config CRYPTO_ARC4
 	tristate "ARC4 cipher algorithm"
 	select CRYPTO_BLKCIPHER
+	select CRYPTO_LIB_ARC4
 	help
 	  ARC4 cipher algorithm.
 
diff --git a/crypto/arc4.c b/crypto/arc4.c
index a2120e06bf84..7f80623aa66a 100644
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
-	struct arc4_ctx *ctx = crypto_tfm_ctx(tfm);
-	int i, j = 0, k = 0;
-
-	ctx->x = 1;
-	ctx->y = 0;
-
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
+	struct crypto_arc4_ctx *ctx = crypto_tfm_ctx(tfm);
 
-	return 0;
+	return crypto_arc4_set_key(ctx, in_key, key_len);
 }
 
 static int arc4_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
@@ -48,60 +27,23 @@ static int arc4_set_key_skcipher(struct crypto_skcipher *tfm, const u8 *in_key,
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
-	arc4_crypt(crypto_tfm_ctx(tfm), out, in, 1);
+	crypto_arc4_crypt(crypto_tfm_ctx(tfm), out, in, 1);
 }
 
 static int ecb_arc4_crypt(struct skcipher_request *req)
 {
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
-	struct arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
+	struct crypto_arc4_ctx *ctx = crypto_skcipher_ctx(tfm);
 	struct skcipher_walk walk;
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
 
 	while (walk.nbytes > 0) {
-		arc4_crypt(ctx, walk.dst.virt.addr, walk.src.virt.addr,
-			   walk.nbytes);
+		crypto_arc4_crypt(ctx, walk.dst.virt.addr, walk.src.virt.addr,
+				  walk.nbytes);
 		err = skcipher_walk_done(&walk, 0);
 	}
 
@@ -112,7 +54,7 @@ static struct crypto_alg arc4_cipher = {
 	.cra_name		=	"arc4",
 	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
 	.cra_blocksize		=	ARC4_BLOCK_SIZE,
-	.cra_ctxsize		=	sizeof(struct arc4_ctx),
+	.cra_ctxsize		=	sizeof(struct crypto_arc4_ctx),
 	.cra_module		=	THIS_MODULE,
 	.cra_u			=	{
 		.cipher = {
@@ -129,7 +71,7 @@ static struct skcipher_alg arc4_skcipher = {
 	.base.cra_name		=	"ecb(arc4)",
 	.base.cra_priority	=	100,
 	.base.cra_blocksize	=	ARC4_BLOCK_SIZE,
-	.base.cra_ctxsize	=	sizeof(struct arc4_ctx),
+	.base.cra_ctxsize	=	sizeof(struct crypto_arc4_ctx),
 	.base.cra_module	=	THIS_MODULE,
 	.min_keysize		=	ARC4_MIN_KEY_SIZE,
 	.max_keysize		=	ARC4_MAX_KEY_SIZE,
diff --git a/include/crypto/arc4.h b/include/crypto/arc4.h
index 5b2c24ab0139..62ac95ec6860 100644
--- a/include/crypto/arc4.h
+++ b/include/crypto/arc4.h
@@ -6,8 +6,21 @@
 #ifndef _CRYPTO_ARC4_H
 #define _CRYPTO_ARC4_H
 
+#include <linux/types.h>
+
 #define ARC4_MIN_KEY_SIZE	1
 #define ARC4_MAX_KEY_SIZE	256
 #define ARC4_BLOCK_SIZE		1
 
+struct crypto_arc4_ctx {
+	u32 S[256];
+	u32 x, y;
+};
+
+int crypto_arc4_set_key(struct crypto_arc4_ctx *ctx, const u8 *in_key,
+			unsigned int key_len);
+
+void crypto_arc4_crypt(struct crypto_arc4_ctx *ctx, u8 *out, const u8 *in,
+		       unsigned int len);
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
index 000000000000..e375d150a547
--- /dev/null
+++ b/lib/crypto/Makefile
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0
+
+obj-$(CONFIG_CRYPTO_LIB_ARC4) += libarc4.o
diff --git a/lib/crypto/libarc4.c b/lib/crypto/libarc4.c
new file mode 100644
index 000000000000..b828af2cc03b
--- /dev/null
+++ b/lib/crypto/libarc4.c
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
+int crypto_arc4_set_key(struct crypto_arc4_ctx *ctx, const u8 *in_key,
+			unsigned int key_len)
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
+EXPORT_SYMBOL(crypto_arc4_set_key);
+
+void crypto_arc4_crypt(struct crypto_arc4_ctx *ctx, u8 *out, const u8 *in,
+		       unsigned int len)
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
+EXPORT_SYMBOL(crypto_arc4_crypt);
-- 
2.20.1

