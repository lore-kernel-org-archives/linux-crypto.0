From: David Miller <davem@davemloft.net>
Subject: [PATCH 1/4] sparc64: Add SHA1 driver making use of the 'sha1'
 instruction.
Date: Sun, 19 Aug 2012 22:10:09 -0700 (PDT)
Message-ID: <20120819.221009.488187233179758429.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
To: sparclinux@vger.kernel.org
Return-path: <sparclinux-owner@vger.kernel.org>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/Kbuild             |    1 +
 arch/sparc/crypto/Makefile    |    7 ++
 arch/sparc/crypto/sha1_asm.S  |   72 ++++++++++++++++
 arch/sparc/crypto/sha1_glue.c |  181 +++++++++++++++++++++++++++++++++++++++++
 arch/sparc/lib/ksyms.c        |    4 +
 crypto/Kconfig                |    9 ++
 6 files changed, 274 insertions(+)
 create mode 100644 arch/sparc/crypto/Makefile
 create mode 100644 arch/sparc/crypto/sha1_asm.S
 create mode 100644 arch/sparc/crypto/sha1_glue.c

diff --git a/arch/sparc/Kbuild b/arch/sparc/Kbuild
index 5cd0116..675afa2 100644
--- a/arch/sparc/Kbuild
+++ b/arch/sparc/Kbuild
@@ -6,3 +6,4 @@ obj-y += kernel/
 obj-y += mm/
 obj-y += math-emu/
 obj-y += net/
+obj-y += crypto/
diff --git a/arch/sparc/crypto/Makefile b/arch/sparc/crypto/Makefile
new file mode 100644
index 0000000..9760472
--- /dev/null
+++ b/arch/sparc/crypto/Makefile
@@ -0,0 +1,7 @@
+#
+# Arch-specific CryptoAPI modules.
+#
+
+obj-$(CONFIG_CRYPTO_SHA1_SPARC64) += sha1-sparc64.o
+
+sha1-sparc64-y := sha1_asm.o sha1_glue.o
diff --git a/arch/sparc/crypto/sha1_asm.S b/arch/sparc/crypto/sha1_asm.S
new file mode 100644
index 0000000..d2147eb
--- /dev/null
+++ b/arch/sparc/crypto/sha1_asm.S
@@ -0,0 +1,72 @@
+#include <linux/linkage.h>
+#include <asm/visasm.h>
+
+ENTRY(sha1_sparc64_transform)
+	/* %o0 = digest, %o1 = data, %o2 = rounds */
+	VISEntryHalf
+	ld	[%o0 + 0x00], %f0
+	ld	[%o0 + 0x04], %f1
+	ld	[%o0 + 0x08], %f2
+	andcc	%o1, 0x7, %g0
+	ld	[%o0 + 0x0c], %f3
+	bne,pn	%xcc, 10f
+	 ld	[%o0 + 0x10], %f4
+
+1:
+	ldd	[%o1 + 0x00], %f8
+	ldd	[%o1 + 0x08], %f10
+	ldd	[%o1 + 0x10], %f12
+	ldd	[%o1 + 0x18], %f14
+	ldd	[%o1 + 0x20], %f16
+	ldd	[%o1 + 0x28], %f18
+	ldd	[%o1 + 0x30], %f20
+	ldd	[%o1 + 0x38], %f22
+
+	/* sha1 */
+	.word	0x81b02820
+
+	subcc	%o2, 1, %o2
+	bne,pt	%xcc, 1b
+	 add	%o1, 0x40, %o1
+
+5:
+	st	%f0, [%o0 + 0x00]
+	st	%f1, [%o0 + 0x04]
+	st	%f2, [%o0 + 0x08]
+	st	%f3, [%o0 + 0x0c]
+	st	%f4, [%o0 + 0x10]
+	retl
+	 VISExitHalf
+10:
+	alignaddr %o1, %g0, %o1
+
+	ldd	[%o1 + 0x00], %f10
+1:
+	ldd	[%o1 + 0x08], %f12
+	ldd	[%o1 + 0x10], %f14
+	ldd	[%o1 + 0x18], %f16
+	ldd	[%o1 + 0x20], %f18
+	ldd	[%o1 + 0x28], %f20
+	ldd	[%o1 + 0x30], %f22
+	ldd	[%o1 + 0x38], %f24
+	ldd	[%o1 + 0x40], %f26
+
+	faligndata %f10, %f12, %f8
+	faligndata %f12, %f14, %f10
+	faligndata %f14, %f16, %f12
+	faligndata %f16, %f18, %f14
+	faligndata %f18, %f20, %f16
+	faligndata %f20, %f22, %f18
+	faligndata %f22, %f24, %f20
+	faligndata %f24, %f26, %f22
+
+	/* sha1 */
+	.word	0x81b02820
+
+	subcc	%o2, 1, %o2
+	fsrc1	%f26, %f10
+	bne,pt	%xcc, 1b
+	 add	%o1, 0x40, %o1
+
+	ba,a,pt	%xcc, 5b
+ENDPROC(sha1_sparc64_transform)
diff --git a/arch/sparc/crypto/sha1_glue.c b/arch/sparc/crypto/sha1_glue.c
new file mode 100644
index 0000000..6bd1abc
--- /dev/null
+++ b/arch/sparc/crypto/sha1_glue.c
@@ -0,0 +1,181 @@
+/* Glue code for SHA1 hashing optimized for sparc64 crypto opcodes.
+ *
+ * This is based largely upon arch/x86/crypto/sha1_ssse3_glue.c
+ *
+ * Copyright (c) Alan Smithee.
+ * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
+ * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
+ * Copyright (c) Mathias Krause <minipli@googlemail.com>
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/mm.h>
+#include <linux/cryptohash.h>
+#include <linux/types.h>
+#include <crypto/sha.h>
+
+#include <asm/pstate.h>
+#include <asm/elf.h>
+
+asmlinkage void sha1_sparc64_transform(u32 *digest, const char *data,
+				       unsigned int rounds);
+
+static int sha1_sparc64_init(struct shash_desc *desc)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	*sctx = (struct sha1_state){
+		.state = { SHA1_H0, SHA1_H1, SHA1_H2, SHA1_H3, SHA1_H4 },
+	};
+
+	return 0;
+}
+
+static void __sha1_sparc64_update(struct sha1_state *sctx, const u8 *data,
+				  unsigned int len, unsigned int partial)
+{
+	unsigned int done = 0;
+
+	sctx->count += len;
+	if (partial) {
+		done = SHA1_BLOCK_SIZE - partial;
+		memcpy(sctx->buffer + partial, data, done);
+		sha1_sparc64_transform(sctx->state, sctx->buffer, 1);
+	}
+	if (len - done >= SHA1_BLOCK_SIZE) {
+		const unsigned int rounds = (len - done) / SHA1_BLOCK_SIZE;
+
+		sha1_sparc64_transform(sctx->state, data + done, rounds);
+		done += rounds * SHA1_BLOCK_SIZE;
+	}
+
+	memcpy(sctx->buffer, data + done, len - done);
+}
+
+static int sha1_sparc64_update(struct shash_desc *desc, const u8 *data,
+			       unsigned int len)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->count % SHA1_BLOCK_SIZE;
+
+	/* Handle the fast case right here */
+	if (partial + len < SHA1_BLOCK_SIZE) {
+		sctx->count += len;
+		memcpy(sctx->buffer + partial, data, len);
+	} else
+		__sha1_sparc64_update(sctx, data, len, partial);
+
+	return 0;
+}
+
+/* Add padding and return the message digest. */
+static int sha1_sparc64_final(struct shash_desc *desc, u8 *out)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+	unsigned int i, index, padlen;
+	__be32 *dst = (__be32 *)out;
+	__be64 bits;
+	static const u8 padding[SHA1_BLOCK_SIZE] = { 0x80, };
+
+	bits = cpu_to_be64(sctx->count << 3);
+
+	/* Pad out to 56 mod 64 and append length */
+	index = sctx->count % SHA1_BLOCK_SIZE;
+	padlen = (index < 56) ? (56 - index) : ((SHA1_BLOCK_SIZE+56) - index);
+
+	/* We need to fill a whole block for __sha1_sparc64_update() */
+	if (padlen <= 56) {
+		sctx->count += padlen;
+		memcpy(sctx->buffer + index, padding, padlen);
+	} else {
+		__sha1_sparc64_update(sctx, padding, padlen, index);
+	}
+	__sha1_sparc64_update(sctx, (const u8 *)&bits, sizeof(bits), 56);
+
+	/* Store state in digest */
+	for (i = 0; i < 5; i++)
+		dst[i] = cpu_to_be32(sctx->state[i]);
+
+	/* Wipe context */
+	memset(sctx, 0, sizeof(*sctx));
+
+	return 0;
+}
+
+static int sha1_sparc64_export(struct shash_desc *desc, void *out)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+
+	return 0;
+}
+
+static int sha1_sparc64_import(struct shash_desc *desc, const void *in)
+{
+	struct sha1_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+
+	return 0;
+}
+
+static struct shash_alg alg = {
+	.digestsize	=	SHA1_DIGEST_SIZE,
+	.init		=	sha1_sparc64_init,
+	.update		=	sha1_sparc64_update,
+	.final		=	sha1_sparc64_final,
+	.export		=	sha1_sparc64_export,
+	.import		=	sha1_sparc64_import,
+	.descsize	=	sizeof(struct sha1_state),
+	.statesize	=	sizeof(struct sha1_state),
+	.base		=	{
+		.cra_name	=	"sha1",
+		.cra_driver_name=	"sha1-sparc64",
+		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA1_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static bool __init sparc64_has_sha1_opcode(void)
+{
+	unsigned long cfr;
+
+	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
+		return false;
+
+	__asm__ __volatile__("rd %%asr26, %0" : "=r" (cfr));
+	if (!(cfr & CFR_SHA1))
+		return false;
+
+	return true;
+}
+
+static int __init sha1_sparc64_mod_init(void)
+{
+	if (sparc64_has_sha1_opcode()) {
+		pr_info("Using sparc64 sha1 opcode optimized SHA-1 implementation\n");
+		return crypto_register_shash(&alg);
+	}
+	pr_info("sparc64 sha1 opcode not available.\n");
+	return -ENODEV;
+}
+
+static void __exit sha1_sparc64_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(sha1_sparc64_mod_init);
+module_exit(sha1_sparc64_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SHA1 Secure Hash Algorithm, sparc64 sha1 opcode accelerated");
+
+MODULE_ALIAS("sha1");
diff --git a/arch/sparc/lib/ksyms.c b/arch/sparc/lib/ksyms.c
index 3b31218..ee31b88 100644
--- a/arch/sparc/lib/ksyms.c
+++ b/arch/sparc/lib/ksyms.c
@@ -134,6 +134,10 @@ EXPORT_SYMBOL(copy_user_page);
 void VISenter(void);
 EXPORT_SYMBOL(VISenter);
 
+/* CRYPTO code needs this */
+void VISenterhalf(void);
+EXPORT_SYMBOL(VISenterhalf);
+
 extern void xor_vis_2(unsigned long, unsigned long *, unsigned long *);
 extern void xor_vis_3(unsigned long, unsigned long *, unsigned long *,
 		unsigned long *);
diff --git a/crypto/Kconfig b/crypto/Kconfig
index a323805..167c856 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -433,6 +433,15 @@ config CRYPTO_SHA1_SSSE3
 	  using Supplemental SSE3 (SSSE3) instructions or Advanced Vector
 	  Extensions (AVX), when available.
 
+config CRYPTO_SHA1_SPARC64
+	tristate "SHA1 digest algorithm (SPARC64)"
+	depends on SPARC64
+	select CRYPTO_SHA1
+	select CRYPTO_HASH
+	help
+	  SHA-1 secure hash standard (FIPS 180-1/DFIPS 180-2) implemented
+	  using sparc64 crypto instructions, when available.
+
 config CRYPTO_SHA256
 	tristate "SHA224 and SHA256 digest algorithm"
 	select CRYPTO_HASH
-- 
1.7.10.4

