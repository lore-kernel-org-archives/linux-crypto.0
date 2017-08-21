From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 1/2] crypto: add OSCCA SM3 secure hash
Date: Mon, 21 Aug 2017 13:51:28 +0300
Message-ID: <1503312690-2770-2-git-send-email-gilad@benyossef.com>
References: <1503312690-2770-1-git-send-email-gilad@benyossef.com>
Cc: Ofir Drang <ofir.drang@arm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1503312690-2770-1-git-send-email-gilad@benyossef.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Add OSCCA SM3 secure hash (OSCCA GM/T 0004-2012 SM3)
generic hash transformation.

Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
---
 crypto/Kconfig            |  11 +++
 crypto/Makefile           |   1 +
 crypto/sm3_generic.c      | 210 ++++++++++++++++++++++++++++++++++++++++++++++
 include/crypto/sm3.h      |  40 +++++++++
 include/crypto/sm3_base.h | 117 ++++++++++++++++++++++++++
 5 files changed, 379 insertions(+)
 create mode 100644 crypto/sm3_generic.c
 create mode 100644 include/crypto/sm3.h
 create mode 100644 include/crypto/sm3_base.h

diff --git a/crypto/Kconfig b/crypto/Kconfig
index caa770e..9c9ff1c 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -859,6 +859,17 @@ config CRYPTO_SHA3
 	  References:
 	  http://keccak.noekeon.org/
 
+config CRYPTO_SM3
+	tristate "SM3 digest algorithm"
+	select CRYPTO_HASH
+	help
+	  SM3 secure hash function as defined by OSCCA GM/T 0004-2012 SM3).
+	  It is part of the Chinese Commercial Cryptography suite.
+
+	  References:
+	  http://www.oscca.gov.cn/UpFile/20101222141857786.pdf
+	  https://datatracker.ietf.org/doc/html/draft-shen-sm3-hash
+
 config CRYPTO_TGR192
 	tristate "Tiger digest algorithms"
 	select CRYPTO_HASH
diff --git a/crypto/Makefile b/crypto/Makefile
index d41f033..723b0b4 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -70,6 +70,7 @@ obj-$(CONFIG_CRYPTO_SHA1) += sha1_generic.o
 obj-$(CONFIG_CRYPTO_SHA256) += sha256_generic.o
 obj-$(CONFIG_CRYPTO_SHA512) += sha512_generic.o
 obj-$(CONFIG_CRYPTO_SHA3) += sha3_generic.o
+obj-$(CONFIG_CRYPTO_SM3) += sm3_generic.o
 obj-$(CONFIG_CRYPTO_WP512) += wp512.o
 CFLAGS_wp512.o := $(call cc-option,-fno-schedule-insns)  # https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79149
 obj-$(CONFIG_CRYPTO_TGR192) += tgr192.o
diff --git a/crypto/sm3_generic.c b/crypto/sm3_generic.c
new file mode 100644
index 0000000..9e823d9
--- /dev/null
+++ b/crypto/sm3_generic.c
@@ -0,0 +1,210 @@
+/*
+ * SM3 secure hash, as specified by OSCCA GM/T 0004-2012 SM3 and
+ * described at https://tools.ietf.org/html/draft-shen-sm3-hash-01
+ *
+ * Copyright (C) 2017 ARM Limited or its affiliates.
+ * Written by Gilad Ben-Yossef <gilad@benyossef.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/types.h>
+#include <crypto/sm3.h>
+#include <crypto/sm3_base.h>
+#include <linux/bitops.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
+
+const u8 sm3_zero_message_hash[SM3_DIGEST_SIZE] = {
+	0x1A, 0xB2, 0x1D, 0x83, 0x55, 0xCF, 0xA1, 0x7F,
+	0x8e, 0x61, 0x19, 0x48, 0x31, 0xE8, 0x1A, 0x8F,
+	0x22, 0xBE, 0xC8, 0xC7, 0x28, 0xFE, 0xFB, 0x74,
+	0x7E, 0xD0, 0x35, 0xEB, 0x50, 0x82, 0xAA, 0x2B
+};
+EXPORT_SYMBOL_GPL(sm3_zero_message_hash);
+
+static inline u32 p0(u32 x)
+{
+	return x ^ rol32(x, 9) ^ rol32(x, 17);
+}
+
+static inline u32 p1(u32 x)
+{
+	return x ^ rol32(x, 15) ^ rol32(x, 23);
+}
+
+static inline u32 ff(unsigned int n, u32 a, u32 b, u32 c)
+{
+	return (n < 16) ? (a ^ b ^ c) : ((a & b) | (a & c) | (b & c));
+}
+
+static inline u32 gg(unsigned int n, u32 e, u32 f, u32 g)
+{
+	return (n < 16) ? (e ^ f ^ g) : ((e & f) | ((~e) & g));
+}
+
+static inline u32 t(unsigned int n)
+{
+	return (n < 16) ? SM3_T1 : SM3_T2;
+}
+
+static void sm3_expand(u32 *t, u32 *w, u32 *wt)
+{
+	int i;
+	unsigned int tmp;
+
+	/* load the input */
+	for (i = 0; i <= 15; i++)
+		w[i] = get_unaligned_be32((__u32 *)t + i);
+
+	for (i = 16; i <= 67; i++) {
+		tmp = w[i - 16] ^ w[i - 9] ^ rol32(w[i - 3], 15);
+		w[i] = p1(tmp) ^ (rol32(w[i - 13], 7)) ^ w[i - 6];
+	}
+
+	for (i = 0; i <= 63; i++)
+		wt[i] = w[i] ^ w[i + 4];
+}
+
+static void sm3_compress(u32 *w, u32 *wt, u32 *m)
+{
+	u32 ss1;
+	u32 ss2;
+	u32 tt1;
+	u32 tt2;
+	u32 a, b, c, d, e, f, g, h;
+	int i;
+
+	a = m[0];
+	b = m[1];
+	c = m[2];
+	d = m[3];
+	e = m[4];
+	f = m[5];
+	g = m[6];
+	h = m[7];
+
+	for (i = 0; i <= 63; i++) {
+
+		ss1 = rol32((rol32(a, 12) + e + rol32(t(i), i)), 7);
+
+		ss2 = ss1 ^ rol32(a, 12);
+
+		tt1 = ff(i, a, b, c) + d + ss2 + *wt;
+		wt++;
+
+		tt2 = gg(i, e, f, g) + h + ss1 + *w;
+		w++;
+
+		d = c;
+		c = rol32(b, 9);
+		b = a;
+		a = tt1;
+		h = g;
+		g = rol32(f, 19);
+		f = e;
+		e = p0(tt2);
+	}
+
+	m[0] = a ^ m[0];
+	m[1] = b ^ m[1];
+	m[2] = c ^ m[2];
+	m[3] = d ^ m[3];
+	m[4] = e ^ m[4];
+	m[5] = f ^ m[5];
+	m[6] = g ^ m[6];
+	m[7] = h ^ m[7];
+
+	a = b = c = d = e = f = g = h = ss1 = ss2 = tt1 = tt2 = 0;
+}
+
+static void sm3_transform(struct sm3_state *sst, u8 const *src)
+{
+	unsigned int w[68];
+	unsigned int wt[64];
+
+	sm3_expand((u32 *)src, w, wt);
+	sm3_compress(w, wt, sst->state);
+
+	memzero_explicit(w, sizeof(w));
+	memzero_explicit(wt, sizeof(wt));
+}
+
+static void sm3_generic_block_fn(struct sm3_state *sst, u8 const *src,
+				    int blocks)
+{
+	while (blocks--) {
+		sm3_transform(sst, src);
+		src += SM3_BLOCK_SIZE;
+	}
+}
+
+int crypto_sm3_update(struct shash_desc *desc, const u8 *data,
+			  unsigned int len)
+{
+	return sm3_base_do_update(desc, data, len, sm3_generic_block_fn);
+}
+EXPORT_SYMBOL(crypto_sm3_update);
+
+static int sm3_final(struct shash_desc *desc, u8 *out)
+{
+	sm3_base_do_finalize(desc, sm3_generic_block_fn);
+	return sm3_base_finish(desc, out);
+}
+
+int crypto_sm3_finup(struct shash_desc *desc, const u8 *data,
+			unsigned int len, u8 *hash)
+{
+	sm3_base_do_update(desc, data, len, sm3_generic_block_fn);
+	return sm3_final(desc, hash);
+}
+EXPORT_SYMBOL(crypto_sm3_finup);
+
+static struct shash_alg sm3_alg = {
+	.digestsize	=	SM3_DIGEST_SIZE,
+	.init		=	sm3_base_init,
+	.update		=	crypto_sm3_update,
+	.final		=	sm3_final,
+	.finup		=	crypto_sm3_finup,
+	.descsize	=	sizeof(struct sm3_state),
+	.base		=	{
+		.cra_name	 =	"sm3",
+		.cra_driver_name =	"sm3-generic",
+		.cra_flags	 =	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	 =	SM3_BLOCK_SIZE,
+		.cra_module	 =	THIS_MODULE,
+	}
+};
+
+static int __init sm3_generic_mod_init(void)
+{
+	return crypto_register_shash(&sm3_alg);
+}
+
+static void __exit sm3_generic_mod_fini(void)
+{
+	crypto_unregister_shash(&sm3_alg);
+}
+
+module_init(sm3_generic_mod_init);
+module_exit(sm3_generic_mod_fini);
+
+MODULE_LICENSE("GPL v2");
+MODULE_DESCRIPTION("SM3 Secure Hash Algorithm");
+
+MODULE_ALIAS_CRYPTO("sm3");
+MODULE_ALIAS_CRYPTO("sm3-generic");
diff --git a/include/crypto/sm3.h b/include/crypto/sm3.h
new file mode 100644
index 0000000..1438942
--- /dev/null
+++ b/include/crypto/sm3.h
@@ -0,0 +1,40 @@
+/*
+ * Common values for SM3 algorithm
+ */
+
+#ifndef _CRYPTO_SM3_H
+#define _CRYPTO_SM3_H
+
+#include <linux/types.h>
+
+#define SM3_DIGEST_SIZE	32
+#define SM3_BLOCK_SIZE	64
+
+#define SM3_T1		0x79CC4519
+#define SM3_T2		0x7A879D8A
+
+#define SM3_IVA		0x7380166f
+#define SM3_IVB		0x4914b2b9
+#define SM3_IVC		0x172442d7
+#define SM3_IVD		0xda8a0600
+#define SM3_IVE		0xa96f30bc
+#define SM3_IVF		0x163138aa
+#define SM3_IVG		0xe38dee4d
+#define SM3_IVH		0xb0fb0e4e
+
+extern const u8 sm3_zero_message_hash[SM3_DIGEST_SIZE];
+
+struct sm3_state {
+	u32 state[SM3_DIGEST_SIZE / 4];
+	u64 count;
+	u8 buffer[SM3_BLOCK_SIZE];
+};
+
+struct shash_desc;
+
+extern int crypto_sm3_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len);
+
+extern int crypto_sm3_finup(struct shash_desc *desc, const u8 *data,
+			     unsigned int len, u8 *hash);
+#endif
diff --git a/include/crypto/sm3_base.h b/include/crypto/sm3_base.h
new file mode 100644
index 0000000..256948e
--- /dev/null
+++ b/include/crypto/sm3_base.h
@@ -0,0 +1,117 @@
+/*
+ * sm3_base.h - core logic for SM3 implementations
+ *
+ * Copyright (C) 2017 ARM Limited or its affiliates.
+ * Written by Gilad Ben-Yossef <gilad@benyossef.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <crypto/internal/hash.h>
+#include <crypto/sm3.h>
+#include <linux/crypto.h>
+#include <linux/module.h>
+#include <asm/unaligned.h>
+
+typedef void (sm3_block_fn)(struct sm3_state *sst, u8 const *src, int blocks);
+
+static inline int sm3_base_init(struct shash_desc *desc)
+{
+	struct sm3_state *sctx = shash_desc_ctx(desc);
+
+	sctx->state[0] = SM3_IVA;
+	sctx->state[1] = SM3_IVB;
+	sctx->state[2] = SM3_IVC;
+	sctx->state[3] = SM3_IVD;
+	sctx->state[4] = SM3_IVE;
+	sctx->state[5] = SM3_IVF;
+	sctx->state[6] = SM3_IVG;
+	sctx->state[7] = SM3_IVH;
+	sctx->count = 0;
+
+	return 0;
+}
+
+static inline int sm3_base_do_update(struct shash_desc *desc,
+				      const u8 *data,
+				      unsigned int len,
+				      sm3_block_fn *block_fn)
+{
+	struct sm3_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->count % SM3_BLOCK_SIZE;
+
+	sctx->count += len;
+
+	if (unlikely((partial + len) >= SM3_BLOCK_SIZE)) {
+		int blocks;
+
+		if (partial) {
+			int p = SM3_BLOCK_SIZE - partial;
+
+			memcpy(sctx->buffer + partial, data, p);
+			data += p;
+			len -= p;
+
+			block_fn(sctx, sctx->buffer, 1);
+		}
+
+		blocks = len / SM3_BLOCK_SIZE;
+		len %= SM3_BLOCK_SIZE;
+
+		if (blocks) {
+			block_fn(sctx, data, blocks);
+			data += blocks * SM3_BLOCK_SIZE;
+		}
+		partial = 0;
+	}
+	if (len)
+		memcpy(sctx->buffer + partial, data, len);
+
+	return 0;
+}
+
+static inline int sm3_base_do_finalize(struct shash_desc *desc,
+					sm3_block_fn *block_fn)
+{
+	const int bit_offset = SM3_BLOCK_SIZE - sizeof(__be64);
+	struct sm3_state *sctx = shash_desc_ctx(desc);
+	__be64 *bits = (__be64 *)(sctx->buffer + bit_offset);
+	unsigned int partial = sctx->count % SM3_BLOCK_SIZE;
+
+	sctx->buffer[partial++] = 0x80;
+	if (partial > bit_offset) {
+		memset(sctx->buffer + partial, 0x0, SM3_BLOCK_SIZE - partial);
+		partial = 0;
+
+		block_fn(sctx, sctx->buffer, 1);
+	}
+
+	memset(sctx->buffer + partial, 0x0, bit_offset - partial);
+	*bits = cpu_to_be64(sctx->count << 3);
+	block_fn(sctx, sctx->buffer, 1);
+
+	return 0;
+}
+
+static inline int sm3_base_finish(struct shash_desc *desc, u8 *out)
+{
+	struct sm3_state *sctx = shash_desc_ctx(desc);
+	__be32 *digest = (__be32 *)out;
+	int i;
+
+	for (i = 0; i < SM3_DIGEST_SIZE / sizeof(__be32); i++)
+		put_unaligned_be32(sctx->state[i], digest++);
+
+	*sctx = (struct sm3_state){};
+	return 0;
+}
-- 
2.1.4
