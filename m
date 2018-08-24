From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH v2 03/17] zinc: ChaCha20 generic C implementation
Date: Fri, 24 Aug 2018 15:38:35 -0600
Message-ID: <20180824213849.23647-4-Jason@zx2c4.com>
References: <20180824213849.23647-1-Jason@zx2c4.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        linux-crypto@vger.kernel.org
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180824213849.23647-1-Jason@zx2c4.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

This implements the ChaCha20 permutation as a single C statement, by way
of the comma operator, which the compiler is able to simplify
terrifically.

Information: https://cr.yp.to/chacha.html

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Samuel Neves <sneves@dei.uc.pt>
Cc: Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>
Cc: linux-crypto@vger.kernel.org
---
 include/zinc/chacha20.h      |  47 ++++++++++++
 lib/zinc/Kconfig             |   4 +
 lib/zinc/Makefile            |   4 +
 lib/zinc/chacha20/chacha20.c | 137 +++++++++++++++++++++++++++++++++++
 lib/zinc/main.c              |   5 ++
 5 files changed, 197 insertions(+)
 create mode 100644 include/zinc/chacha20.h
 create mode 100644 lib/zinc/chacha20/chacha20.c

diff --git a/include/zinc/chacha20.h b/include/zinc/chacha20.h
new file mode 100644
index 000000000000..ba50a2424ad0
--- /dev/null
+++ b/include/zinc/chacha20.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#ifndef _ZINC_CHACHA20_H
+#define _ZINC_CHACHA20_H
+
+#include <linux/simd.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+
+enum {
+	CHACHA20_IV_SIZE = 16,
+	CHACHA20_KEY_SIZE = 32,
+	CHACHA20_BLOCK_SIZE = 64,
+	HCHACHA20_KEY_SIZE = 32,
+	HCHACHA20_NONCE_SIZE = 16
+};
+
+struct chacha20_ctx {
+	u32 key[8];
+	u32 counter[4];
+} __aligned(32);
+
+void chacha20_fpu_init(void);
+
+static inline void chacha20_init(struct chacha20_ctx *state, const u8 key[CHACHA20_KEY_SIZE], const u64 nonce)
+{
+	__le32 *le_key = (__le32 *)key;
+	state->key[0] = le32_to_cpu(le_key[0]);
+	state->key[1] = le32_to_cpu(le_key[1]);
+	state->key[2] = le32_to_cpu(le_key[2]);
+	state->key[3] = le32_to_cpu(le_key[3]);
+	state->key[4] = le32_to_cpu(le_key[4]);
+	state->key[5] = le32_to_cpu(le_key[5]);
+	state->key[6] = le32_to_cpu(le_key[6]);
+	state->key[7] = le32_to_cpu(le_key[7]);
+	state->counter[0] = state->counter[1] = 0;
+	state->counter[2] = nonce & U32_MAX;
+	state->counter[3] = nonce >> 32;
+}
+void chacha20(struct chacha20_ctx *state, u8 *dst, const u8 *src, u32 len, simd_context_t simd_context);
+
+void hchacha20(u8 derived_key[CHACHA20_KEY_SIZE], const u8 nonce[HCHACHA20_NONCE_SIZE], const u8 key[HCHACHA20_KEY_SIZE], simd_context_t simd_context);
+
+#endif /* _ZINC_CHACHA20_H */
diff --git a/lib/zinc/Kconfig b/lib/zinc/Kconfig
index aa4f8d449d6b..5311a0d6ba8b 100644
--- a/lib/zinc/Kconfig
+++ b/lib/zinc/Kconfig
@@ -6,6 +6,10 @@ config ZINC
 	select NEON
 	select KERNEL_MODE_NEON
 
+config ZINC_CHACHA20
+	bool
+	select ZINC
+
 config ZINC_DEBUG
 	bool "Zinc cryptography library debugging and self-tests"
 	depends on ZINC
diff --git a/lib/zinc/Makefile b/lib/zinc/Makefile
index 8e30115217db..6ec77feb4ab7 100644
--- a/lib/zinc/Makefile
+++ b/lib/zinc/Makefile
@@ -2,6 +2,10 @@ ccflags-y := -O3
 ccflags-y += -Wframe-larger-than=8192
 ccflags-y += -D'pr_fmt(fmt)=KBUILD_MODNAME ": " fmt'
 
+ifeq ($(CONFIG_ZINC_CHACHA20),y)
+zinc-y += chacha20/chacha20.o
+endif
+
 zinc-y += main.o
 
 obj-$(CONFIG_ZINC) := zinc.o
diff --git a/lib/zinc/chacha20/chacha20.c b/lib/zinc/chacha20/chacha20.c
new file mode 100644
index 000000000000..29c487375ccd
--- /dev/null
+++ b/lib/zinc/chacha20/chacha20.c
@@ -0,0 +1,137 @@
+/* SPDX-License-Identifier: GPL-2.0
+ *
+ * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
+ */
+
+#include <zinc/chacha20.h>
+
+#include <linux/kernel.h>
+#include <crypto/algapi.h>
+
+#ifndef HAVE_CHACHA20_ARCH_IMPLEMENTATION
+void __init chacha20_fpu_init(void) { }
+static inline bool chacha20_arch(u8 *out, const u8 *in, const size_t len, const u32 key[8], const u32 counter[4], simd_context_t simd_context) { return false; }
+static inline bool hchacha20_arch(u8 *derived_key, const u8 *nonce, const u8 *key, simd_context_t simd_context) { return false; }
+#endif
+
+#define EXPAND_32_BYTE_K 0x61707865U, 0x3320646eU, 0x79622d32U, 0x6b206574U
+
+#define QUARTER_ROUND(x, a, b, c, d) ( \
+	x[a] += x[b], \
+	x[d] = rol32((x[d] ^ x[a]), 16), \
+	x[c] += x[d], \
+	x[b] = rol32((x[b] ^ x[c]), 12), \
+	x[a] += x[b], \
+	x[d] = rol32((x[d] ^ x[a]), 8), \
+	x[c] += x[d], \
+	x[b] = rol32((x[b] ^ x[c]), 7) \
+)
+
+#define C(i, j) (i * 4 + j)
+
+#define DOUBLE_ROUND(x) ( \
+	/* Column Round */ \
+	QUARTER_ROUND(x, C(0, 0), C(1, 0), C(2, 0), C(3, 0)), \
+	QUARTER_ROUND(x, C(0, 1), C(1, 1), C(2, 1), C(3, 1)), \
+	QUARTER_ROUND(x, C(0, 2), C(1, 2), C(2, 2), C(3, 2)), \
+	QUARTER_ROUND(x, C(0, 3), C(1, 3), C(2, 3), C(3, 3)), \
+	/* Diagonal Round */ \
+	QUARTER_ROUND(x, C(0, 0), C(1, 1), C(2, 2), C(3, 3)), \
+	QUARTER_ROUND(x, C(0, 1), C(1, 2), C(2, 3), C(3, 0)), \
+	QUARTER_ROUND(x, C(0, 2), C(1, 3), C(2, 0), C(3, 1)), \
+	QUARTER_ROUND(x, C(0, 3), C(1, 0), C(2, 1), C(3, 2)) \
+)
+
+#define TWENTY_ROUNDS(x) ( \
+	DOUBLE_ROUND(x), \
+	DOUBLE_ROUND(x), \
+	DOUBLE_ROUND(x), \
+	DOUBLE_ROUND(x), \
+	DOUBLE_ROUND(x), \
+	DOUBLE_ROUND(x), \
+	DOUBLE_ROUND(x), \
+	DOUBLE_ROUND(x), \
+	DOUBLE_ROUND(x), \
+	DOUBLE_ROUND(x) \
+)
+
+static void chacha20_block_generic(__le32 *stream, u32 *state)
+{
+	u32 x[CHACHA20_BLOCK_SIZE / sizeof(u32)];
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(x); ++i)
+		x[i] = state[i];
+
+	TWENTY_ROUNDS(x);
+
+	for (i = 0; i < ARRAY_SIZE(x); ++i)
+		stream[i] = cpu_to_le32(x[i] + state[i]);
+
+	++state[12];
+}
+
+static void chacha20_generic(u8 *out, const u8 *in, u32 len, const u32 key[8], const u32 counter[4])
+{
+	__le32 buf[CHACHA20_BLOCK_SIZE / sizeof(__le32)];
+	u32 x[] = {
+		EXPAND_32_BYTE_K,
+		key[0], key[1], key[2], key[3],
+		key[4], key[5], key[6], key[7],
+		counter[0], counter[1], counter[2], counter[3]
+	};
+
+	if (out != in)
+		memmove(out, in, len);
+
+	while (len >= CHACHA20_BLOCK_SIZE) {
+		chacha20_block_generic(buf, x);
+		crypto_xor(out, (u8 *)buf, CHACHA20_BLOCK_SIZE);
+		len -= CHACHA20_BLOCK_SIZE;
+		out += CHACHA20_BLOCK_SIZE;
+	}
+	if (len) {
+		chacha20_block_generic(buf, x);
+		crypto_xor(out, (u8 *)buf, len);
+	}
+}
+
+void chacha20(struct chacha20_ctx *state, u8 *dst, const u8 *src, u32 len, simd_context_t simd_context)
+{
+	if (!chacha20_arch(dst, src, len, state->key, state->counter, simd_context))
+		chacha20_generic(dst, src, len, state->key, state->counter);
+	state->counter[0] += (len + 63) / 64;
+}
+EXPORT_SYMBOL(chacha20);
+
+static void hchacha20_generic(u8 derived_key[CHACHA20_KEY_SIZE], const u8 nonce[HCHACHA20_NONCE_SIZE], const u8 key[HCHACHA20_KEY_SIZE])
+{
+	__le32 *out = (__force __le32 *)derived_key;
+	u32 x[] = {
+		EXPAND_32_BYTE_K,
+		le32_to_cpup((__le32 *)(key + 0)), le32_to_cpup((__le32 *)(key + 4)), le32_to_cpup((__le32 *)(key + 8)), le32_to_cpup((__le32 *)(key + 12)),
+		le32_to_cpup((__le32 *)(key + 16)), le32_to_cpup((__le32 *)(key + 20)), le32_to_cpup((__le32 *)(key + 24)), le32_to_cpup((__le32 *)(key + 28)),
+		le32_to_cpup((__le32 *)(nonce + 0)), le32_to_cpup((__le32 *)(nonce + 4)), le32_to_cpup((__le32 *)(nonce +  8)), le32_to_cpup((__le32 *)(nonce + 12))
+	};
+
+	TWENTY_ROUNDS(x);
+
+	out[0] = cpu_to_le32(x[0]);
+	out[1] = cpu_to_le32(x[1]);
+	out[2] = cpu_to_le32(x[2]);
+	out[3] = cpu_to_le32(x[3]);
+	out[4] = cpu_to_le32(x[12]);
+	out[5] = cpu_to_le32(x[13]);
+	out[6] = cpu_to_le32(x[14]);
+	out[7] = cpu_to_le32(x[15]);
+}
+
+void hchacha20(u8 derived_key[CHACHA20_KEY_SIZE], const u8 nonce[HCHACHA20_NONCE_SIZE], const u8 key[HCHACHA20_KEY_SIZE], simd_context_t simd_context)
+{
+	if (!hchacha20_arch(derived_key, nonce, key, simd_context))
+		hchacha20_generic(derived_key, nonce, key);
+}
+/* Deliberately not EXPORT_SYMBOL'd, since there are few reasons why somebody
+ * should be using this directly, rather than via xchacha20. Revisit only in
+ * the unlikely event that somebody has a good reason to export this.
+ */
diff --git a/lib/zinc/main.c b/lib/zinc/main.c
index 590872563955..79b85045f22f 100644
--- a/lib/zinc/main.c
+++ b/lib/zinc/main.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2015-2018 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
  */
 
+#include <zinc/chacha20.h>
+
 #include <linux/init.h>
 #include <linux/module.h>
 
@@ -17,6 +19,9 @@
 
 static int __init mod_init(void)
 {
+#ifdef CONFIG_ZINC_CHACHA20
+	chacha20_fpu_init();
+#endif
 	return 0;
 }
 
-- 
2.18.0
