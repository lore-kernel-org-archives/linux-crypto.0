Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CF642DFFA;
	Wed, 21 Jan 2026 10:25:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768991114; cv=none; b=oA2cv4hoLY0t/wpqC9lnW8bMDFGF6Le8zg+M2yd6a6E3Yf3n2NwUYoI55+C8NmAYTLLd0RAAQatiFH0OShcWhZUDkLMMsegB2ye2/8wzBBxcM8QFF4WQbU2+bD2hCTRaF6vqG5d7Ad9+xOaKyDZErcFL7F3Q8XjqN1SDf7Bzn4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768991114; c=relaxed/simple;
	bh=v0RbQTaOt2Atbs3TtNRTNpMvPiLaueCK9HZ1jLpG6ME=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=n97Xq7+SPEaI6vNPycmK9UTtlr9kOF9iZcenAhcazkBweAicQXYKcznR5DBHl9+K10fNyCMYjTxxgw7k5AJa0UISfOmCZX8ifs4dGGx54Ure74u0mctPug4NzC2SCVpxF143AuIsi4mjOxDpIeYqyX/SkT+szLmILXtgmrePmBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from ubt.. (unknown [210.73.43.101])
	by APP-03 (Coremail) with SMTP id rQCowABHaeAzqHBpmt4aBg--.14445S2;
	Wed, 21 Jan 2026 18:19:32 +0800 (CST)
From: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
To: Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-riscv@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chunyan Zhang <zhang.lyra@gmail.com>
Subject: [PATCH] crypto: aegis128: Add RISC-V vector SIMD implementation
Date: Wed, 21 Jan 2026 18:19:23 +0800
Message-Id: <20260121101923.64657-1-zhangchunyan@iscas.ac.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:rQCowABHaeAzqHBpmt4aBg--.14445S2
X-Coremail-Antispam: 1UD129KBjvAXoWfuw15Xr48AryrAr1fXrWfGrg_yoW8tw4kAo
	ZrGF4fWr4ku3W2gFWak3y7GFn3uwsxKwsYv3WFvF4UZFsxtF15K34Ivw45Wr1xAw12k3Wa
	yFyfX3WrWw4jyw1Dn29KB7ZKAUJUUUU8529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYP7k0a2IF6w4kM7kC6x804xWl14x267AKxVW8JVW5JwAFc2x0
	x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj4
	1l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0
	I7IYx2IY6xkF7I0E14v26F4j6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwV
	C2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Gr0_Cr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcxkI7VAKI48JM4IIrI8v6xkF7I0E8cxan2IY
	04v7MxkF7I0En4kS14v26r1q6r43MxkIecxEwVAFwVW8twCF04k20xvY0x0EwIxGrwCFx2
	IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v2
	6r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67
	AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IY
	s7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr
	0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU5q387UUUUU==
X-CM-SenderInfo: x2kd0wxfkx051dq6x2xfdvhtffof0/1tbiBwsOB2lwmIUy0wAAsg

Add a RISC-V vector-accelerated implementation of aegis128 by
wiring it into the generic SIMD hooks.

This implementation supports vlen values of 512, 256, and 128.

Signed-off-by: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
---
 crypto/Kconfig              |   4 +-
 crypto/Makefile             |   4 +
 crypto/aegis-rvv.h          |  21 +
 crypto/aegis128-rvv-inner.c | 752 ++++++++++++++++++++++++++++++++++++
 crypto/aegis128-rvv.c       |  63 +++
 5 files changed, 842 insertions(+), 2 deletions(-)
 create mode 100644 crypto/aegis-rvv.h
 create mode 100644 crypto/aegis128-rvv-inner.c
 create mode 100644 crypto/aegis128-rvv.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 2e5b195b1b06..c4901610aac0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -777,8 +777,8 @@ config CRYPTO_AEGIS128
 	  AEGIS-128 AEAD algorithm
 
 config CRYPTO_AEGIS128_SIMD
-	bool "AEGIS-128 (arm NEON, arm64 NEON)"
-	depends on CRYPTO_AEGIS128 && ((ARM || ARM64) && KERNEL_MODE_NEON)
+	bool "AEGIS-128 (arm NEON, arm64 NEON, RISC-V vector)"
+	depends on CRYPTO_AEGIS128 && (((ARM || ARM64) && KERNEL_MODE_NEON) || RISCV)
 	default y
 	help
 	  AEGIS-128 AEAD algorithm
diff --git a/crypto/Makefile b/crypto/Makefile
index 16a35649dd91..3d94cae9eeba 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -121,6 +121,10 @@ endif
 # Enable <arm_neon.h>
 CFLAGS_aegis128-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)
 
+ifeq ($(ARCH),riscv)
+aegis128-$(CONFIG_CRYPTO_AEGIS128_SIMD) += aegis128-rvv.o aegis128-rvv-inner.o
+endif
+
 obj-$(CONFIG_CRYPTO_PCRYPT) += pcrypt.o
 obj-$(CONFIG_CRYPTO_CRYPTD) += cryptd.o
 obj-$(CONFIG_CRYPTO_DES) += des_generic.o
diff --git a/crypto/aegis-rvv.h b/crypto/aegis-rvv.h
new file mode 100644
index 000000000000..2fae8c93b02a
--- /dev/null
+++ b/crypto/aegis-rvv.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright 2026 Institute of Software, CAS
+ */
+
+#ifndef _AEGIS_RVV_H
+#define _AEGIS_RVV_H
+
+extern const u8 crypto_aes_sbox[];
+
+void crypto_aegis128_init_rvv(void *state, const void *key, const void *iv);
+void crypto_aegis128_update_rvv(void *state, const void *msg);
+void crypto_aegis128_encrypt_chunk_rvv(void *state, void *dst, const void *src,
+					unsigned int size);
+void crypto_aegis128_decrypt_chunk_rvv(void *state, void *dst, const void *src,
+					unsigned int size);
+int crypto_aegis128_final_rvv(void *state, void *tag_xor,
+			       unsigned int assoclen,
+			       unsigned int cryptlen,
+			       unsigned int authsize);
+#endif
diff --git a/crypto/aegis128-rvv-inner.c b/crypto/aegis128-rvv-inner.c
new file mode 100644
index 000000000000..ee2f206eea22
--- /dev/null
+++ b/crypto/aegis128-rvv-inner.c
@@ -0,0 +1,752 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2026 Institute of Software, CAS
+ * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
+ *
+ * Based on aegis128-neon-inner.c:
+ *	Copyright (C) 2019 Linaro, Ltd. <ard.biesheuvel@linaro.org>
+ */
+
+#include <asm/vector.h>
+#include <linux/types.h>
+
+#include "aegis-rvv.h"
+#include "aegis.h"
+
+#define AEGIS128_STATE_BLOCKS 5
+#define RVV_VLEN	riscv_vector_vlen()
+
+typedef u8 aegis128_block_bytes[AEGIS_BLOCK_SIZE];
+struct aegis_state {
+	aegis128_block_bytes blocks[AEGIS128_STATE_BLOCKS];
+};
+
+/* Load 256 bytes at one time into the vector registers starting from r0 */
+#define preload_sbox_1(m, r0)  do {				\
+	unsigned long vl;					\
+	asm volatile (".option	push\n"				\
+		      ".option	arch,+v\n"			\
+		      "vsetvli	%0, x0, e8, "m", ta, ma\n"	\
+		      "vle8.v	"r0", (%1)\n"			\
+		      ".option	pop\n"				\
+		      : "=&r" (vl)				\
+		      :						\
+		      "r" (crypto_aes_sbox)			\
+	:);							\
+} while (0)
+
+/* Load 256 bytes at two times into the vector registers starting from r0 and r1 */
+#define preload_sbox_2(m, r0, r1)  do {				\
+	unsigned long vl;					\
+	asm volatile (".option	push\n"				\
+		      ".option	arch,+v\n"			\
+		      "vsetvli	%0, x0, e8, "m", ta, ma\n"	\
+		      "vle8.v	"r0", (%1)\n"			\
+		      "vle8.v	"r1", (%2)\n"			\
+		      ".option	pop\n"				\
+		      : "=&r" (vl)				\
+		      :						\
+		      "r" (crypto_aes_sbox),			\
+		      "r" (crypto_aes_sbox + 0x80)		\
+	:);							\
+} while (0)
+
+/* v16 - v31: crypto_aes_sbox[0-255] */
+#define preload_sbox_128() preload_sbox_2("m8", "v16", "v24")
+
+/* v16 - v23: crypto_aes_sbox[0-255] */
+#define preload_sbox_256() preload_sbox_1("m8", "v16")
+
+/* v16 - v19: crypto_aes_sbox[0-255] */
+#define preload_sbox_512() preload_sbox_1("m4", "v16")
+
+static __always_inline
+void preload_round_data(void)
+{
+	static const u8 rev32qu16[] = {
+		0x2, 0x3, 0x0, 0x1, 0x6, 0x7, 0x4, 0x5,
+		0xa, 0xb, 0x8, 0x9, 0xe, 0xf, 0xc, 0xd,
+	};
+
+	static const u8 shift_rows[] = {
+		0x0, 0x5, 0xa, 0xf, 0x4, 0x9, 0xe, 0x3,
+		0x8, 0xd, 0x2, 0x7, 0xc, 0x1, 0x6, 0xb,
+	};
+
+	static const u8 ror32by8[] = {
+		0x1, 0x2, 0x3, 0x0, 0x5, 0x6, 0x7, 0x4,
+		0x9, 0xa, 0xb, 0x8, 0xd, 0xe, 0xf, 0xc,
+	};
+
+	asm volatile (".option	push\n"
+		      ".option	arch,+v\n"
+		      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+		      "vle8.v	v13, (%[rev32qu16])\n"
+		      "vle8.v	v14, (%[shift_rows])\n"
+		      "vle8.v	v15, (%[ror32by8])\n"
+		      ".option	pop\n"
+		      : :
+		      [rev32qu16]"r"(rev32qu16),
+		      [shift_rows]"r"(shift_rows),
+		      [ror32by8]"r"(ror32by8)
+	:);
+
+	switch (RVV_VLEN) {
+	case 128:
+		preload_sbox_128();
+		break;
+	case 256:
+		preload_sbox_256();
+		break;
+	case 512:
+		preload_sbox_512();
+		break;
+	default:
+		pr_err("ERROR: %d is not supported vector length!", RVV_VLEN);
+	}
+}
+
+
+#define AEGIS128_ROUND_PART1				\
+	".option	push\n"				\
+	".option	arch,+v\n"			\
+	"vsetivli	zero, 0x10, e8, m1, ta, ma\n"	\
+	/* s = vqtbl1q_u8(s, vld1q_u8(shift_rows)) */	\
+	"vle8.v		v0, (%[s])\n"			\
+	"vrgather.vv	v1, v0, v14\n" /* v14: shift_rows */
+
+#define AEGIS128_ROUND_PART3						\
+	/* s= (v << 1) ^ (uint8x16_t)(((int8x16_t)v >> 7) & 0x1b) */	\
+	"vsetivli	zero, 0x10, e8, m1, ta, ma\n"			\
+	"vsra.vi	v3, v2, 7\n" /* ((int8x16_t)v >> 7) */		\
+	"vand.vx	v3, v3, %[x1b]\n"				\
+	"vsll.vi	v4, v2, 1\n" /* (v << 1) */			\
+	"vxor.vv	v3, v4, v3\n"					\
+	/* s ^= (uint8x16_t)vrev32q_u16((uint16x8_t)v) */		\
+	"vrgather.vv	v4, v2, v13\n" /* v13: rev32qu16 */		\
+	"vxor.vv	v3, v3, v4\n"					\
+	/* s ^= vqtbl1q_u8(v ^ s, vld1q_u8(ror32by8)); */		\
+	"vxor.vv	v4, v3, v2\n" /* v ^ s */			\
+	"vrgather.vv	v5, v4, v15\n" /* v15: ror32by8 */		\
+	"vxor.vv	v3, v3, v5\n"					\
+	"vle8.v		v4, (%[d])\n"					\
+	"vxor.vv	v3, v3, v4\n" /* dst ^= v3 */			\
+	"vse8.v		v3, (%[d])\n"					\
+	".option	pop\n"
+
+/*
+ * v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + step), s - step);
+ * r: vector register which stores sbox array
+ */
+#define gather_sbox(r)				\
+	"vsub.vx	v1, v1, %[step]\n"	\
+	"vrgather.vv	v3, "r", v1\n"		\
+	"vor.vv		v2, v2, v3\n"
+
+static __always_inline
+void aegis128_round_128(u8 *dst, const u8 *src)
+{
+	unsigned long vl;
+
+	/* v16 - v31: crypto_aes_sbox[0-255] */
+	asm volatile (AEGIS128_ROUND_PART1
+		      /* v = vqtbl4q_u8(vld1q_u8_x4(crypto_aes_sbox), s); */
+		      "vsetvli		%0, x0, e8, m1, ta, ma\n"
+		      "vrgather.vv	v2, v16, v1\n"
+		      /* v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0x10), s - 0x10); */
+		      gather_sbox("v17")
+		      gather_sbox("v18")
+		      gather_sbox("v19")
+		      gather_sbox("v20")
+		      gather_sbox("v21")
+		      gather_sbox("v22")
+		      gather_sbox("v23")
+		      gather_sbox("v24")
+		      gather_sbox("v25")
+		      gather_sbox("v26")
+		      gather_sbox("v27")
+		      gather_sbox("v28")
+		      gather_sbox("v29")
+		      gather_sbox("v30")
+		      gather_sbox("v31")
+		      AEGIS128_ROUND_PART3
+		      : "=&r" (vl) :
+		      [s]"r"(src),
+		      [step]"r"(0x10),
+		      [x1b]"r"(0x1b),
+		      [d]"r"(dst)
+		      : "memory"
+	);
+}
+
+static __always_inline
+void aegis128_round_256(u8 *dst, const u8 *src)
+{
+	unsigned long vl;
+
+	/* v16 - v23: crypto_aes_sbox[0-255] */
+	asm volatile (AEGIS128_ROUND_PART1
+		      /* v = vqtbl4q_u8(vld1q_u8_x4(crypto_aes_sbox), s); */
+		      "vsetvli		%0, x0, e8, m1, ta, ma\n"
+		      "vrgather.vv	v2, v16, v1\n"
+		      /* v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0x20), s - 0x20); */
+		      gather_sbox("v17")
+		      gather_sbox("v18")
+		      gather_sbox("v19")
+		      gather_sbox("v20")
+		      gather_sbox("v21")
+		      gather_sbox("v22")
+		      gather_sbox("v23")
+		      AEGIS128_ROUND_PART3
+		      : "=&r" (vl) :
+		      [s]"r"(src),
+		      [step]"r"(0x20),
+		      [x1b]"r"(0x1b),
+		      [d]"r"(dst)
+		      : "memory"
+	);
+}
+
+static __always_inline
+void aegis128_round_512(u8 *dst, const u8 *src)
+{
+	unsigned long vl;
+
+	/* v16 - v19: crypto_aes_sbox[0-255] */
+	asm volatile (AEGIS128_ROUND_PART1
+		      /* v = vqtbl4q_u8(vld1q_u8_x4(crypto_aes_sbox), s); */
+		      "vsetvli		%0, x0, e8, m1, ta, ma\n"
+		      "vrgather.vv	v2, v16, v1\n"
+		      /*v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0x40), s - 0x40);*/
+		      gather_sbox("v17")
+		      /*v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0x80), s - 0x80);*/
+		      gather_sbox("v18")
+		      /*v = vqtbx4q_u8(v, vld1q_u8_x4(crypto_aes_sbox + 0xc0), s - 0xc0);*/
+		      gather_sbox("v19")
+		      AEGIS128_ROUND_PART3
+		      : "=&r" (vl) :
+		      [s]"r"(src),
+		      [step]"r"(0x40),
+		      [x1b]"r"(0x1b),
+		      [d]"r"(dst)
+		      : "memory"
+	);
+}
+
+static __always_inline
+void aegis128_round(u8 *dst, const u8 *src)
+{
+	switch (RVV_VLEN) {
+	case 128:
+		aegis128_round_128(dst, src);
+		break;
+	case 256:
+		aegis128_round_256(dst, src);
+		break;
+	case 512:
+		aegis128_round_512(dst, src);
+		break;
+	default:
+		pr_err("ERROR: %d is not supported vector length!", RVV_VLEN);
+	}
+}
+
+static __always_inline
+void aegis128_update_rvv(struct aegis_state *state, const void *key)
+{
+	u8 k[AEGIS_BLOCK_SIZE];
+
+	/* save key to k[16] */
+	asm volatile (".option	push\n"
+		      ".option	arch,+v\n"
+		      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+		      "vle8.v	v1, (%[key])\n"
+		      "vse8.v	v1, (%[k])\n"
+		      ".option	pop\n"
+		      : :
+		      [key]"r"(key),
+		      [k]"r"(k)
+	:);
+
+	aegis128_round(k, state->blocks[4]);
+	aegis128_round(state->blocks[4], state->blocks[3]);
+	aegis128_round(state->blocks[3], state->blocks[2]);
+	aegis128_round(state->blocks[2], state->blocks[1]);
+	aegis128_round(state->blocks[1], state->blocks[0]);
+
+	/* state->blocks[0] ^= key */
+	asm volatile (".option	push\n"
+		      ".option	arch,+v\n"
+		      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+		      "vle8.v	v1, (%[k])\n"
+		      "vle8.v	v2, (%[block0])\n"
+		      "vxor.vv	v2, v2, v1\n"
+		      "vse8.v	v2, (%[block0])\n"
+		      ".option	pop\n"
+		      : :
+		      [k]"r"(k),
+		      [block0]"r"(state->blocks[0])
+	:);
+}
+
+void crypto_aegis128_init_rvv(void *state, const void *key, const void *iv)
+{
+	struct aegis_state *st = state;
+	u8 kiv[AEGIS_BLOCK_SIZE];
+
+	static const u8 const0[] = {
+		0x00, 0x01, 0x01, 0x02, 0x03, 0x05, 0x08, 0x0d,
+		0x15, 0x22, 0x37, 0x59, 0x90, 0xe9, 0x79, 0x62,
+	};
+	static const u8 const1[] = {
+		0xdb, 0x3d, 0x18, 0x55, 0x6d, 0xc2, 0x2f, 0xf1,
+		0x20, 0x11, 0x31, 0x42, 0x73, 0xb5, 0x28, 0xdd,
+	};
+
+	/*
+	 * kiv = key^iv
+	 * struct aegis128_state st = {{
+		kiv,
+		vld1q_u8(const1),
+		vld1q_u8(const0),
+		key ^ vld1q_u8(const0),
+		key ^ vld1q_u8(const1),
+	   }};
+	 */
+	asm volatile (".option	push\n"
+		      ".option	arch,+v\n"
+		      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+		      "vle8.v	v0, (%[const0])\n"
+		      "vle8.v	v1, (%[const1])\n"
+		      "vse8.v	v0, (%[block2])\n"
+		      "vse8.v	v1, (%[block1])\n"
+		      "vle8.v	v2, (%[iv])\n"
+		      "vle8.v	v3, (%[key])\n"
+		      "vxor.vv	v0, v0, v3\n"
+		      "vxor.vv	v1, v1, v3\n"
+		      "vxor.vv	v2, v2, v3\n"
+		      "vse8.v	v2, (%[block0])\n"
+		      "vse8.v	v2, (%[kiv])\n"
+		      "vse8.v	v0, (%[block3])\n"
+		      "vse8.v	v1, (%[block4])\n"
+		      ".option	pop\n"
+		      : :
+		      [const0]"r"(const0),
+		      [const1]"r"(const1),
+		      [block1]"r"(st->blocks[1]),
+		      [block2]"r"(st->blocks[2]),
+		      [iv]"r"(iv),
+		      [key]"r"(key),
+		      [block0]"r"(st->blocks[0]),
+		      [kiv]"r"(kiv),
+		      [block3]"r"(st->blocks[3]),
+		      [block4]"r"(st->blocks[4])
+	:);
+
+	preload_round_data();
+
+	for (int i = 0; i < 5; i++) {
+		aegis128_update_rvv(st, key);
+		aegis128_update_rvv(st, kiv);
+	}
+}
+
+void crypto_aegis128_update_rvv(void *state, const void *msg)
+{
+	struct aegis_state *st = state;
+
+	preload_round_data();
+
+	aegis128_update_rvv(st, msg);
+}
+
+static const u8 permute[] __aligned(64) = {
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+	 0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 15,
+	-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
+};
+
+void crypto_aegis128_encrypt_chunk_rvv(void *state, void *dst, const void *src,
+					unsigned int size)
+{
+	struct aegis_state *st = state;
+	const int short_input = size < AEGIS_BLOCK_SIZE;
+	u8 s[AEGIS_BLOCK_SIZE];
+	u8 msg[AEGIS_BLOCK_SIZE];
+
+	preload_round_data();
+
+	while (size >= AEGIS_BLOCK_SIZE) {
+		/* s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4]; */
+		asm volatile (".option	push\n"
+			      ".option	arch,+v\n"
+			      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+			      "vle8.v	v1, (%[block1])\n"
+			      "vle8.v	v2, (%[block2])\n"
+			      "vle8.v	v3, (%[block3])\n"
+			      "vle8.v	v4, (%[block4])\n"
+			      "vxor.vv	v1, v1, v4\n"
+			      "vand.vv	v2, v2, v3\n"
+			      "vxor.vv	v1, v1, v2\n"
+			      "vse8.v	v1, (%[s])\n"
+			      ".option	pop\n"
+			      : :
+			      [block1]"r"(st->blocks[1]),
+			      [block2]"r"(st->blocks[2]),
+			      [block3]"r"(st->blocks[3]),
+			      [block4]"r"(st->blocks[4]),
+			      [s]"r"(s)
+		:);
+
+		aegis128_update_rvv(st, src);
+		/* dst = s ^ src*/
+		asm volatile (".option	push\n"
+			      ".option	arch,+v\n"
+			      "vle8.v	v1, (%[s])\n"
+			      "vle8.v	v2, (%[src])\n"
+			      "vxor.vv	v1, v1, v2\n"
+			      "vse8.v	v1, (%[dst])\n"
+			      "vse8.v	v1, (%[msg])\n"
+			      ".option	pop\n"
+			      : :
+			      [s]"r"(s),
+			      [src]"r"(src),
+			      [dst]"r"(dst),
+			      [msg]"r"(msg)
+		:);
+
+		size -= AEGIS_BLOCK_SIZE;
+		src += AEGIS_BLOCK_SIZE;
+		dst += AEGIS_BLOCK_SIZE;
+	}
+
+	if (size > 0) {
+		u8 buf[AEGIS_BLOCK_SIZE];
+		const void *in = src;
+		void *out = dst;
+		u8 m[AEGIS_BLOCK_SIZE];
+
+		/* s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4]; */
+		asm volatile (".option	push\n"
+			      ".option	arch,+v\n"
+			      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+			      "vle8.v	v1, (%[block1])\n"
+			      "vle8.v	v2, (%[block2])\n"
+			      "vle8.v	v3, (%[block3])\n"
+			      "vle8.v	v4, (%[block4])\n"
+			      "vxor.vv	v1, v1, v4\n" /* st.v[1] ^ st.v[4] */
+			      "vand.vv	v2, v2, v3\n" /* st.v[2] & st.v[3] */
+			      "vxor.vv	v1, v1, v2\n"
+			      "vse8.v	v1, (%[s])\n"
+			      ".option	pop\n"
+			      : :
+			      [block1]"r"(st->blocks[1]),
+			      [block2]"r"(st->blocks[2]),
+			      [block3]"r"(st->blocks[3]),
+			      [block4]"r"(st->blocks[4]),
+			      [s]"r"(s)
+		:);
+
+		if (__builtin_expect(short_input, 0))
+			in = out = memcpy(buf + AEGIS_BLOCK_SIZE - size, src, size);
+
+		/*
+		 * m = vqtbl1q_u8(vld1q_u8(in + size - AEGIS_BLOCK_SIZE),
+		 *		  vld1q_u8(permute + 32 - size));
+		 */
+		asm volatile (".option		push\n"
+			      ".option		arch,+v\n"
+			      "vle8.v		v1, (%[in])\n"
+			      "vle8.v		v2, (%[p])\n"
+			      "vrgather.vv	v3, v1, v2\n"
+			      "vse8.v		v3, (%[m])\n"
+			      ".option		pop\n"
+			      : :
+			      [in]"r"(in + size - AEGIS_BLOCK_SIZE),
+			      [p]"r"(permute + 32 - size),
+			      [m]"r"(m)
+		:);
+
+		aegis128_update_rvv(st, m);
+
+		/*
+		 * vst1q_u8(out + size - AEGIS_BLOCK_SIZE,
+		 *			vqtbl1q_u8(m ^ s, vld1q_u8(permute + size)));
+		 */
+		asm volatile (".option		push\n"
+			      ".option		arch,+v\n"
+			      "vsetivli		zero, 0x10, e8, m1, ta, ma\n"
+			      "vle8.v		v1, (%[m])\n"
+			      "vle8.v		v2, (%[s])\n"
+			      "vxor.vv		v1, v1, v2\n"
+			      "vle8.v		v2, (%[p])\n"
+			      "vrgather.vv	v3, v1, v2\n"
+			      "vse8.v		v3, (%[out])\n"
+			      ".option		pop\n"
+			      : :
+			      [m]"r"(m),
+			      [s]"r"(s),
+			      [p]"r"(permute + size),
+			      [out]"r"(out + size - AEGIS_BLOCK_SIZE)
+		:);
+
+		if (__builtin_expect(short_input, 0)) {
+			memcpy(dst, out, size);
+		} else {
+			/* vst1q_u8(out - AEGIS_BLOCK_SIZE, m); */
+			asm volatile (".option	push\n"
+				      ".option	arch,+v\n"
+				      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+				      "vle8.v	v1, (%[msg])\n"
+				      "vse8.v	v1, (%[out])\n"
+				      ".option	pop\n"
+				      : :
+				      [msg]"r"(msg),
+				      [out]"r"(out - AEGIS_BLOCK_SIZE)
+			:);
+		}
+	}
+}
+
+void crypto_aegis128_decrypt_chunk_rvv(void *state, void *dst, const void *src,
+					unsigned int size)
+{
+	struct aegis_state *st = state;
+	const int short_input = size < AEGIS_BLOCK_SIZE;
+	u8 s[AEGIS_BLOCK_SIZE];
+	u8 msg[AEGIS_BLOCK_SIZE];
+
+	preload_round_data();
+
+	while (size >= AEGIS_BLOCK_SIZE) {
+		/* s = vld1q_u8(src) ^ st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4]; */
+		asm volatile (".option	push\n"
+			      ".option	arch,+v\n"
+			      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+			      "vle8.v	v1, (%[block1])\n"
+			      "vle8.v	v2, (%[block2])\n"
+			      "vle8.v	v3, (%[block3])\n"
+			      "vle8.v	v4, (%[block4])\n"
+			      "vle8.v	v5, (%[src])\n"
+			      "vxor.vv	v1, v1, v4\n"
+			      "vand.vv	v2, v2, v3\n"
+			      "vxor.vv	v1, v1, v2\n"
+			      "vxor.vv	v1, v1, v5\n"
+			      "vse8.v	v1, (%[msg])\n"
+			      ".option	pop\n"
+			      : :
+			      [block1]"r"(st->blocks[1]),
+			      [block2]"r"(st->blocks[2]),
+			      [block3]"r"(st->blocks[3]),
+			      [block4]"r"(st->blocks[4]),
+			      [src]"r"(src),
+			      [msg]"r"(msg)
+		:);
+
+		aegis128_update_rvv(st, msg);
+		/* dst = s */
+		asm volatile (".option	push\n"
+			      ".option	arch,+v\n"
+			      "vle8.v	v1, (%[msg])\n"
+			      "vse8.v	v1, (%[dst])\n"
+			      ".option	pop\n"
+			      : :
+			      [msg]"r"(msg),
+			      [dst]"r"(dst)
+		:);
+
+		size -= AEGIS_BLOCK_SIZE;
+		src += AEGIS_BLOCK_SIZE;
+		dst += AEGIS_BLOCK_SIZE;
+	}
+
+	if (size > 0) {
+		u8 buf[AEGIS_BLOCK_SIZE];
+		const void *in = src;
+		void *out = dst;
+		u8 m[AEGIS_BLOCK_SIZE];
+
+		/* s = st.v[1] ^ (st.v[2] & st.v[3]) ^ st.v[4]; */
+		asm volatile (".option	push\n"
+			      ".option	arch,+v\n"
+			      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+			      "vle8.v	v1, (%[block1])\n"
+			      "vle8.v	v2, (%[block2])\n"
+			      "vle8.v	v3, (%[block3])\n"
+			      "vle8.v	v4, (%[block4])\n"
+			      "vxor.vv	v1, v1, v4\n" /* st.v[1] ^ st.v[4] */
+			      "vand.vv	v2, v2, v3\n" /* st.v[2] & st.v[3] */
+			      "vxor.vv	v1, v1, v2\n"
+			      "vse8.v	v1, (%[s])\n"
+			      ".option	pop\n"
+			      : :
+			      [block1]"r"(st->blocks[1]),
+			      [block2]"r"(st->blocks[2]),
+			      [block3]"r"(st->blocks[3]),
+			      [block4]"r"(st->blocks[4]),
+			      [s]"r"(s)
+		:);
+
+		if (__builtin_expect(short_input, 0))
+			in = out = memcpy(buf + AEGIS_BLOCK_SIZE - size, src, size);
+
+		/*
+		 * m = s ^ vqtbx1q_u8(s, vld1q_u8(in + size - AEGIS_BLOCK_SIZE),
+		 *		      vld1q_u8(permute + 32 - size));
+		 */
+		asm volatile (".option		push\n"
+			      ".option		arch,+v\n"
+			      "vle8.v		v1, (%[in])\n"
+			      "vle8.v		v2, (%[p])\n"
+			      "vrgather.vv	v3, v1, v2\n"
+			      "vle8.v		v4, (%[s])\n"
+			      "vmsltu.vx	v0, v2, %[x10]\n" /* set if less then 0x10 */
+			      "vmerge.vvm	v3, v4, v3, v0\n"
+			      "vxor.vv		v3, v4, v3\n"
+			      "vse8.v		v3, (%[m])\n"
+			      ".option		pop\n"
+			      : :
+			      [in]"r"(in + size - AEGIS_BLOCK_SIZE),
+			      [p]"r"(permute + 32 - size),
+			      [s]"r"(s),
+			      [x10]"r"(0x10),
+			      [m]"r"(m)
+		:);
+
+		aegis128_update_rvv(st, m);
+
+		/*
+		 * vst1q_u8(out + size - AEGIS_BLOCK_SIZE,
+		 *	    vqtbl1q_u8(m, vld1q_u8(permute + size)));
+		 */
+		asm volatile (".option		push\n"
+			      ".option		arch,+v\n"
+			      "vsetivli		zero, 0x10, e8, m1, ta, ma\n"
+			      "vle8.v		v1, (%[m])\n"
+			      "vle8.v		v2, (%[p])\n"
+			      "vrgather.vv	v3, v1, v2\n"
+			      "vse8.v		v3, (%[out])\n"
+			      ".option		pop\n"
+			      : :
+			      [m]"r"(m),
+			      [p]"r"(permute + size),
+			      [out]"r"(out + size - AEGIS_BLOCK_SIZE)
+		:);
+
+		if (__builtin_expect(short_input, 0)) {
+			memcpy(dst, out, size);
+		} else {
+			/* vst1q_u8(out - AEGIS_BLOCK_SIZE, m); */
+			asm volatile (".option	push\n"
+				      ".option	arch,+v\n"
+				      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+				      "vle8.v	v1, (%[msg])\n"
+				      "vse8.v	v1, (%[out])\n"
+				      ".option	pop\n"
+				      : :
+				      [msg]"r"(msg),
+				      [out]"r"(out - AEGIS_BLOCK_SIZE)
+			:);
+		}
+	}
+}
+
+int crypto_aegis128_final_rvv(void *state, void *tag_xor,
+			       unsigned int assoclen,
+			       unsigned int cryptlen,
+			       unsigned int authsize)
+{
+	struct aegis_state *st = state;
+	u64 v[2];
+	int i;
+
+	preload_round_data();
+
+	/*
+	 *v = st.v[3] ^ (uint8x16_t)vcombine_u64(vmov_n_u64(8ULL * assoclen),
+	 *					 vmov_n_u64(8ULL * cryptlen));
+	 */
+	v[0] = 8ULL * assoclen;
+	v[1] = 8ULL * cryptlen;
+	asm volatile (".option	push\n"
+		      ".option	arch,+v\n"
+		      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+		      "vle8.v	v0, (%[v])\n"
+		      "vle8.v	v1, (%[block3])\n"
+		      "vxor.vv	v0, v0, v1\n"
+		      "vse8.v	v0, (%[v])\n"
+		      ".option	pop\n"
+		      : :
+		      [v]"r"(v),
+		      [block3]"r"(st->blocks[3])
+	:);
+
+	for (i = 0; i < 7; i++)
+		aegis128_update_rvv(st, v);
+
+	/* v = st.v[0] ^ st.v[1] ^ st.v[2] ^ st.v[3] ^ st.v[4]; */
+	asm volatile (".option	push\n"
+		      ".option	arch,+v\n"
+		      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+		      "vle8.v	v0, (%[block0])\n"
+		      "vle8.v	v1, (%[block1])\n"
+		      "vle8.v	v2, (%[block2])\n"
+		      "vle8.v	v3, (%[block3])\n"
+		      "vle8.v	v4, (%[block4])\n"
+		      "vxor.vv	v0, v0, v1\n"
+		      "vxor.vv	v2, v2, v3\n"
+		      "vxor.vv	v0, v0, v2\n"
+		      "vxor.vv	v0, v0, v4\n"
+		      "vse8.v	v0, (%[v])\n"
+		      ".option	pop\n"
+		      : :
+		      [block0]"r"(st->blocks[0]),
+		      [block1]"r"(st->blocks[1]),
+		      [block2]"r"(st->blocks[2]),
+		      [block3]"r"(st->blocks[3]),
+		      [block4]"r"(st->blocks[4]),
+		      [v]"r"(v)
+	:);
+
+	if (authsize > 0) {
+		/*
+		 * v = vqtbl1q_u8(~vceqq_u8(v, vld1q_u8(tag_xor)),
+		 *			    vld1q_u8(permute + authsize));
+		 */
+		asm volatile (".option		push\n"
+			      ".option		arch,+v\n"
+			      "vsetivli		zero, 0x10, e8, m1, ta, ma\n"
+			      "vle8.v		v0, (%[v])\n"
+			      "vle8.v		v1, (%[tag_xor])\n"
+			      "vmseq.vv		v0, v0, v1\n" /* vceqq_u8(v, vld1q_u8(tag_xor) */
+			      "vmv.v.i		v1, 0\n" /* set v1 = 0 */
+			      "vmerge.vxm	v1, v1, %[xff], v0\n"
+			      "vxor.vi		v1, v1, -1\n" /* vnot.v v0, v0 */
+			      "vle8.v		v0, (%[pa])\n"
+			      "vrgather.vv	v2, v1, v0\n"
+			      "vredmin.vs	v2, v2, v2\n" /* vminvq_s8((int8x16_t)v) */
+			      "vse8.v		v2, (%[v])\n"
+			      ".option		pop\n"
+			      : :
+			      [v]"r"(v),
+			      [tag_xor]"r"(tag_xor),
+			      [xff]"r"(0xff),
+			      [pa]"r"(permute + authsize)
+		:);
+
+		return *((s8 *)v);
+	}
+
+	asm volatile (".option	push\n"
+		      ".option	arch,+v\n"
+		      "vsetivli	zero, 0x10, e8, m1, ta, ma\n"
+		      "vle8.v	v0, (%[v])\n"
+		      "vse8.v	v0, (%[tag_xor])\n"
+		      ".option	pop\n"
+		      : :
+		      [v]"r"(v),
+		      [tag_xor]"r"(tag_xor)
+	:);
+
+	return 0;
+}
diff --git a/crypto/aegis128-rvv.c b/crypto/aegis128-rvv.c
new file mode 100644
index 000000000000..ce0536121ec3
--- /dev/null
+++ b/crypto/aegis128-rvv.c
@@ -0,0 +1,63 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright 2026 Institute of Software, CAS
+ * Author: Chunyan Zhang <zhangchunyan@iscas.ac.cn>
+ */
+
+#include <asm/vector.h>
+
+#include "aegis.h"
+#include "aegis-rvv.h"
+
+bool crypto_aegis128_have_simd(void)
+{
+	return IS_ENABLED(CONFIG_RISCV_ISA_V);
+}
+
+void crypto_aegis128_init_simd(struct aegis_state *state,
+			       const union aegis_block *key,
+			       const u8 *iv)
+{
+	kernel_vector_begin();
+	crypto_aegis128_init_rvv(state, key, iv);
+	kernel_vector_end();
+}
+
+void crypto_aegis128_update_simd(struct aegis_state *state, const void *msg)
+{
+	kernel_vector_begin();
+	crypto_aegis128_update_rvv(state, msg);
+	kernel_vector_end();
+}
+
+void crypto_aegis128_encrypt_chunk_simd(struct aegis_state *state, u8 *dst,
+					const u8 *src, unsigned int size)
+{
+	kernel_vector_begin();
+	crypto_aegis128_encrypt_chunk_rvv(state, dst, src, size);
+	kernel_vector_end();
+}
+
+void crypto_aegis128_decrypt_chunk_simd(struct aegis_state *state, u8 *dst,
+					const u8 *src, unsigned int size)
+{
+	kernel_vector_begin();
+	crypto_aegis128_decrypt_chunk_rvv(state, dst, src, size);
+	kernel_vector_end();
+}
+
+int crypto_aegis128_final_simd(struct aegis_state *state,
+			       union aegis_block *tag_xor,
+			       unsigned int assoclen,
+			       unsigned int cryptlen,
+			       unsigned int authsize)
+{
+	int ret;
+
+	kernel_vector_begin();
+	ret = crypto_aegis128_final_rvv(state, tag_xor, assoclen, cryptlen,
+					 authsize);
+	kernel_vector_end();
+
+	return ret;
+}
-- 
2.34.1

