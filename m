From: Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Subject: [PATCH 2/7] crypto: add blkcipher implementation of ARC4
Date: Sat,  3 Apr 2010 09:49:24 +0200
Message-ID: <1270280969-11357-3-git-send-email-sebastian@breakpoint.cc>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>,
	<linux-ppp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1270280969-11357-1-git-send-email-sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

This is a pure blkcipher implementation of ARC4. The internal state is
saved within an IV which is supplied by the user. The goal is that the
cipher does not change its internal state now, only the iv changes during
encryption.

Cc: <linux-ppp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
---
 crypto/Kconfig   |   13 +++++
 crypto/Makefile  |    1 +
 crypto/arc4blk.c |  150 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 crypto/testmgr.h |    3 +-
 4 files changed, 166 insertions(+), 1 deletions(-)
 create mode 100644 crypto/arc4blk.c

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
+ * Jon Oberheide <jon-uA3EsQDo7Y3NLxjTenLetw@public.gmane.org>
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
+MODULE_AUTHOR("Jon Oberheide <jon-uA3EsQDo7Y3NLxjTenLetw@public.gmane.org>");
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
-- 
1.6.6

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
