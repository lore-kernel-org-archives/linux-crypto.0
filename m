From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [PATCH v2] crypto: add blkcipher implementation of ARC4
Date: Mon, 5 Apr 2010 19:04:06 +0200
Message-ID: <20100405170406.GA24215@Chamillionaire.breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
 <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc>
 <20100405084209.GA16788@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-ppp@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:56035 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755523Ab0DEREI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Apr 2010 13:04:08 -0400
Content-Disposition: inline
In-Reply-To: <20100405084209.GA16788@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a pure blkcipher implementation of ARC4. The internal state is
saved within an IV which is supplied by the user. The goal is that the
cipher does not change its internal state now, only the iv changes during
encryption.

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 crypto/Kconfig        |   13 ++++
 crypto/Makefile       |    1 +
 crypto/arc4blk.c      |  150 +++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h      |    3 +-
 include/crypto/arc4.h |   26 +++++++++
 5 files changed, 192 insertions(+), 1 deletions(-)
 create mode 100644 crypto/arc4blk.c
 create mode 100644 include/crypto/arc4.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 81c185a..be9add2 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -570,6 +570,19 @@ config CRYPTO_ARC4
 	  WEP, but it should not be for other purposes because of the
 	  weakness of the algorithm.
 
+config CRYPTO_ARC4BLK
+	tristate "ARC4 cipher algorithm (alternative implemenation)"
+	select CRYPTO_BLKCIPHER
+	help
+	  ARC4 cipher algorithm. This is an alternative ARC4 implementation which
+	  will replace the other ARC4 implementation once all in-kernel users are
+	  converted.
+
+	  ARC4 is a stream cipher using keys ranging from 8 bits to 2048
+	  bits in length.  This algorithm is required for driver-based
+	  WEP, but it should not be for other purposes because of the
+	  weakness of the algorithm.
+
 config CRYPTO_BLOWFISH
 	tristate "Blowfish cipher algorithm"
 	select CRYPTO_ALGAPI
diff --git a/crypto/Makefile b/crypto/Makefile
index 1f15112..11300e3 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -68,6 +68,7 @@ obj-$(CONFIG_CRYPTO_CAMELLIA) += camellia.o
 obj-$(CONFIG_CRYPTO_CAST5) += cast5.o
 obj-$(CONFIG_CRYPTO_CAST6) += cast6.o
 obj-$(CONFIG_CRYPTO_ARC4) += arc4cip.o
+obj-$(CONFIG_CRYPTO_ARC4BLK) += arc4blk.o
 obj-$(CONFIG_CRYPTO_TEA) += tea.o
 obj-$(CONFIG_CRYPTO_KHAZAD) += khazad.o
 obj-$(CONFIG_CRYPTO_ANUBIS) += anubis.o
diff --git a/crypto/arc4blk.c b/crypto/arc4blk.c
new file mode 100644
index 0000000..bdf938a
--- /dev/null
+++ b/crypto/arc4blk.c
@@ -0,0 +1,150 @@
+/*
+ * Cryptographic API
+ *
+ * ARC4 Cipher Algorithm
+ *
+ * Jon Oberheide <jon@oberheide.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <crypto/algapi.h>
+#include <crypto/arc4.h>
+
+#define ARC4_MIN_KEY_SIZE	1
+#define ARC4_MAX_KEY_SIZE	256
+#define ARC4_BLOCK_SIZE		1
+
+static int arc4_set_key(struct crypto_tfm *tfm, const u8 *in_key,
+			unsigned int key_len)
+{
+	/*
+	 * ARC4 is special: The user should supply an IV as struct arc4_iv and
+	 * fill either the key or the iv.
+	 */
+	return 0;
+}
+
+static void arc4_key_to_iv(const u8 *in_key, u32 key_len, struct arc4_iv *iv)
+{
+	int i, j = 0, k = 0;
+
+	iv->iv.x = 1;
+	iv->iv.y = 0;
+
+	for (i = 0; i < 256; i++)
+		iv->iv.S[i] = i;
+
+	for (i = 0; i < 256; i++)
+	{
+		u8 a = iv->iv.S[i];
+		j = (j + in_key[k] + a) & 0xff;
+		iv->iv.S[i] = iv->iv.S[j];
+		iv->iv.S[j] = a;
+		if (++k >= key_len)
+			k = 0;
+	}
+}
+
+static void arc4_ivsetup(struct arc4_iv *iv)
+{
+	struct arc4_iv tmp_iv;
+
+	if (iv->type == ARC4_TYPE_IV)
+		return;
+
+	memcpy(&tmp_iv, iv, sizeof(tmp_iv));
+	arc4_key_to_iv(tmp_iv.key.key, tmp_iv.key.key_len, iv);
+	iv->type = ARC4_TYPE_IV;
+}
+
+static int arc4_crypt(struct blkcipher_desc *desc, struct scatterlist *dst,
+		struct scatterlist *src, unsigned int nbytes)
+{
+	struct blkcipher_walk walk;
+	struct arc4_iv *aiv;
+	u8 *S;
+	u8 x;
+	u8 y;
+	u8 a, b;
+	int ret;
+
+	blkcipher_walk_init(&walk, dst, src, nbytes);
+	ret = blkcipher_walk_virt(desc, &walk);
+	if (ret)
+		return ret;
+
+	aiv = (struct arc4_iv *)walk.iv;
+	arc4_ivsetup(aiv);
+
+	S = aiv->iv.S;
+	x = aiv->iv.x;
+	y = aiv->iv.y;
+
+	while (walk.nbytes) {
+		u8 *in = walk.src.virt.addr;
+		u8 *out = walk.dst.virt.addr;
+		u32 i;
+
+		for (i = 0; i < walk.nbytes; i++) {
+			a = S[x];
+			y = (y + a) & 0xff;
+			b = S[y];
+			S[x] = b;
+			S[y] = a;
+			x = (x + 1) & 0xff;
+			*out = *in ^ S[(a + b) & 0xff];
+
+			in++;
+			out++;
+		}
+		ret = blkcipher_walk_done(desc, &walk, 0);
+		WARN_ON(ret < 0);
+	}
+
+	aiv->iv.x = x;
+	aiv->iv.y = y;
+	return ret;
+}
+
+static struct crypto_alg arc4_alg = {
+	.cra_name		=	"arc4",
+	.cra_priority		=	100,
+	.cra_flags		=	CRYPTO_ALG_TYPE_BLKCIPHER,
+	.cra_blocksize		=	ARC4_BLOCK_SIZE,
+	.cra_ctxsize		=	0,
+	.cra_type		=	&crypto_blkcipher_type,
+	.cra_alignmask		=	3,
+	.cra_module		=	THIS_MODULE,
+	.cra_list		=	LIST_HEAD_INIT(arc4_alg.cra_list),
+	.cra_u			=	{ .blkcipher = {
+	.min_keysize		=	0,
+	.max_keysize		=	0,
+	.ivsize			=	sizeof(struct arc4_iv),
+	.setkey			=	arc4_set_key,
+	.encrypt		=	arc4_crypt,
+	.decrypt		=	arc4_crypt } }
+};
+
+static int __init arc4_init(void)
+{
+	return crypto_register_alg(&arc4_alg);
+}
+
+static void __exit arc4_exit(void)
+{
+	crypto_unregister_alg(&arc4_alg);
+}
+
+module_init(arc4_init);
+module_exit(arc4_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
+MODULE_AUTHOR("Jon Oberheide <jon@oberheide.org>");
+MODULE_ALIAS("arc4");
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index fb76517..423cf86 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -24,7 +24,8 @@
 #define MAX_TAP			8
 
 #define MAX_KEYLEN		56
-#define MAX_IVLEN		32
+/* sizeof arc4_iv */
+#define MAX_IVLEN		260
 
 struct hash_testvec {
 	/* only used with keyed hash algorithms */
diff --git a/include/crypto/arc4.h b/include/crypto/arc4.h
new file mode 100644
index 0000000..1423c92
--- /dev/null
+++ b/include/crypto/arc4.h
@@ -0,0 +1,26 @@
+#ifndef __CRYPTO_ARC4_H__
+#define __CRYPTO_ARC4_H__
+
+struct arc4_iv {
+	union {
+		struct arc4_key {
+			u8 key[256];
+			u16 key_len;
+		} key;
+		struct arc4_riv {
+			u8 S[256];
+			u8 x, y;
+		} iv;
+	};
+#define ARC4_TYPE_KEY   0
+#define ARC4_TYPE_IV    1
+	u8 type;
+};
+
+static inline void arc4_setup_iv(struct arc4_iv *iv, const u8 *key, u32 len)
+{
+	memcpy(iv->key.key, key, len);
+	iv->key.key_len = len;
+	iv->type = ARC4_TYPE_KEY;
+}
+#endif
-- 
1.7.0.3

