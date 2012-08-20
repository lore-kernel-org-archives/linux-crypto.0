From: David Miller <davem@davemloft.net>
Subject: [PATCH 2/4] sparc64: Add SHA224/SHA256 driver making use of the
 'sha256' instruction.
Date: Sun, 19 Aug 2012 22:10:18 -0700 (PDT)
Message-ID: <20120819.221018.1863234243581202163.davem@davemloft.net>
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
 arch/sparc/crypto/Makefile      |    2 +
 arch/sparc/crypto/sha256_asm.S  |   78 +++++++++++++
 arch/sparc/crypto/sha256_glue.c |  237 +++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                  |    9 ++
 4 files changed, 326 insertions(+)
 create mode 100644 arch/sparc/crypto/sha256_asm.S
 create mode 100644 arch/sparc/crypto/sha256_glue.c

diff --git a/arch/sparc/crypto/Makefile b/arch/sparc/crypto/Makefile
index 9760472..578f845 100644
--- a/arch/sparc/crypto/Makefile
+++ b/arch/sparc/crypto/Makefile
@@ -3,5 +3,7 @@
 #
 
 obj-$(CONFIG_CRYPTO_SHA1_SPARC64) += sha1-sparc64.o
+obj-$(CONFIG_CRYPTO_SHA256_SPARC64) += sha256-sparc64.o
 
 sha1-sparc64-y := sha1_asm.o sha1_glue.o
+sha256-sparc64-y := sha256_asm.o sha256_glue.o
diff --git a/arch/sparc/crypto/sha256_asm.S b/arch/sparc/crypto/sha256_asm.S
new file mode 100644
index 0000000..771ce26
--- /dev/null
+++ b/arch/sparc/crypto/sha256_asm.S
@@ -0,0 +1,78 @@
+#include <linux/linkage.h>
+#include <asm/visasm.h>
+
+ENTRY(sha256_sparc64_transform)
+	/* %o0 = digest, %o1 = data, %o2 = rounds */
+	VISEntryHalf
+	ld	[%o0 + 0x00], %f0
+	ld	[%o0 + 0x04], %f1
+	ld	[%o0 + 0x08], %f2
+	ld	[%o0 + 0x0c], %f3
+	ld	[%o0 + 0x10], %f4
+	ld	[%o0 + 0x14], %f5
+	andcc	%o1, 0x7, %g0
+	ld	[%o0 + 0x18], %f6
+	bne,pn	%xcc, 10f
+	 ld	[%o0 + 0x1c], %f7
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
+	/* sha256 */
+	.word	0x81b02840
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
+	st	%f5, [%o0 + 0x14]
+	st	%f6, [%o0 + 0x18]
+	st	%f7, [%o0 + 0x1c]
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
+	/* sha256 */
+	.word	0x81b02840
+
+	subcc	%o2, 1, %o2
+	fsrc1	%f26, %f10
+	bne,pt	%xcc, 1b
+	 add	%o1, 0x40, %o1
+
+	ba,a,pt	%xcc, 5b
+ENDPROC(sha256_sparc64_transform)
diff --git a/arch/sparc/crypto/sha256_glue.c b/arch/sparc/crypto/sha256_glue.c
new file mode 100644
index 0000000..75e1ade
--- /dev/null
+++ b/arch/sparc/crypto/sha256_glue.c
@@ -0,0 +1,237 @@
+/* Glue code for SHA256 hashing optimized for sparc64 crypto opcodes.
+ *
+ * This is based largely upon crypto/sha256_generic.c
+ *
+ * Copyright (c) Jean-Luc Cooke <jlcooke@certainkey.com>
+ * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
+ * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
+ * SHA224 Support Copyright 2007 Intel Corporation <jonathan.lynch@intel.com>
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
+asmlinkage void sha256_sparc64_transform(u32 *digest, const char *data,
+					 unsigned int rounds);
+
+static int sha224_sparc64_init(struct shash_desc *desc)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	sctx->state[0] = SHA224_H0;
+	sctx->state[1] = SHA224_H1;
+	sctx->state[2] = SHA224_H2;
+	sctx->state[3] = SHA224_H3;
+	sctx->state[4] = SHA224_H4;
+	sctx->state[5] = SHA224_H5;
+	sctx->state[6] = SHA224_H6;
+	sctx->state[7] = SHA224_H7;
+	sctx->count = 0;
+
+	return 0;
+}
+
+static int sha256_sparc64_init(struct shash_desc *desc)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	sctx->state[0] = SHA256_H0;
+	sctx->state[1] = SHA256_H1;
+	sctx->state[2] = SHA256_H2;
+	sctx->state[3] = SHA256_H3;
+	sctx->state[4] = SHA256_H4;
+	sctx->state[5] = SHA256_H5;
+	sctx->state[6] = SHA256_H6;
+	sctx->state[7] = SHA256_H7;
+	sctx->count = 0;
+
+	return 0;
+}
+
+static void __sha256_sparc64_update(struct sha256_state *sctx, const u8 *data,
+				    unsigned int len, unsigned int partial)
+{
+	unsigned int done = 0;
+
+	sctx->count += len;
+	if (partial) {
+		done = SHA256_BLOCK_SIZE - partial;
+		memcpy(sctx->buf + partial, data, done);
+		sha256_sparc64_transform(sctx->state, sctx->buf, 1);
+	}
+	if (len - done >= SHA256_BLOCK_SIZE) {
+		const unsigned int rounds = (len - done) / SHA256_BLOCK_SIZE;
+
+		sha256_sparc64_transform(sctx->state, data + done, rounds);
+		done += rounds * SHA256_BLOCK_SIZE;
+	}
+
+	memcpy(sctx->buf, data + done, len - done);
+}
+
+static int sha256_sparc64_update(struct shash_desc *desc, const u8 *data,
+				 unsigned int len)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->count % SHA256_BLOCK_SIZE;
+
+	/* Handle the fast case right here */
+	if (partial + len < SHA256_BLOCK_SIZE) {
+		sctx->count += len;
+		memcpy(sctx->buf + partial, data, len);
+	} else
+		__sha256_sparc64_update(sctx, data, len, partial);
+
+	return 0;
+}
+
+static int sha256_sparc64_final(struct shash_desc *desc, u8 *out)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+	unsigned int i, index, padlen;
+	__be32 *dst = (__be32 *)out;
+	__be64 bits;
+	static const u8 padding[SHA256_BLOCK_SIZE] = { 0x80, };
+
+	bits = cpu_to_be64(sctx->count << 3);
+
+	/* Pad out to 56 mod 64 and append length */
+	index = sctx->count % SHA256_BLOCK_SIZE;
+	padlen = (index < 56) ? (56 - index) : ((SHA256_BLOCK_SIZE+56) - index);
+
+	/* We need to fill a whole block for __sha256_sparc64_update() */
+	if (padlen <= 56) {
+		sctx->count += padlen;
+		memcpy(sctx->buf + index, padding, padlen);
+	} else {
+		__sha256_sparc64_update(sctx, padding, padlen, index);
+	}
+	__sha256_sparc64_update(sctx, (const u8 *)&bits, sizeof(bits), 56);
+
+	/* Store state in digest */
+	for (i = 0; i < 8; i++)
+		dst[i] = cpu_to_be32(sctx->state[i]);
+
+	/* Wipe context */
+	memset(sctx, 0, sizeof(*sctx));
+
+	return 0;
+}
+
+static int sha224_sparc64_final(struct shash_desc *desc, u8 *hash)
+{
+	u8 D[SHA256_DIGEST_SIZE];
+
+	sha256_sparc64_final(desc, D);
+
+	memcpy(hash, D, SHA224_DIGEST_SIZE);
+	memset(D, 0, SHA256_DIGEST_SIZE);
+
+	return 0;
+}
+
+static int sha256_sparc64_export(struct shash_desc *desc, void *out)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+	return 0;
+}
+
+static int sha256_sparc64_import(struct shash_desc *desc, const void *in)
+{
+	struct sha256_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+	return 0;
+}
+
+static struct shash_alg sha256 = {
+	.digestsize	=	SHA256_DIGEST_SIZE,
+	.init		=	sha256_sparc64_init,
+	.update		=	sha256_sparc64_update,
+	.final		=	sha256_sparc64_final,
+	.export		=	sha256_sparc64_export,
+	.import		=	sha256_sparc64_import,
+	.descsize	=	sizeof(struct sha256_state),
+	.statesize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha256",
+		.cra_driver_name=	"sha256-sparc64",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA256_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static struct shash_alg sha224 = {
+	.digestsize	=	SHA224_DIGEST_SIZE,
+	.init		=	sha224_sparc64_init,
+	.update		=	sha256_sparc64_update,
+	.final		=	sha224_sparc64_final,
+	.descsize	=	sizeof(struct sha256_state),
+	.base		=	{
+		.cra_name	=	"sha224",
+		.cra_driver_name=	"sha224-sparc64",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA224_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static bool __init sparc64_has_sha256_opcode(void)
+{
+	unsigned long cfr;
+
+	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
+		return false;
+
+	__asm__ __volatile__("rd %%asr26, %0" : "=r" (cfr));
+	if (!(cfr & CFR_SHA256))
+		return false;
+
+	return true;
+}
+
+static int __init sha256_sparc64_mod_init(void)
+{
+	if (sparc64_has_sha256_opcode()) {
+		int ret = crypto_register_shash(&sha224);
+		if (ret < 0)
+			return ret;
+
+		ret = crypto_register_shash(&sha256);
+		if (ret < 0) {
+			crypto_unregister_shash(&sha224);
+			return ret;
+		}
+
+		pr_info("Using sparc64 sha256 opcode optimized SHA-256/SHA-224 implementation\n");
+		return 0;
+	}
+	pr_info("sparc64 sha256 opcode not available.\n");
+	return -ENODEV;
+}
+
+static void __exit sha256_sparc64_mod_fini(void)
+{
+	crypto_unregister_shash(&sha224);
+	crypto_unregister_shash(&sha256);
+}
+
+module_init(sha256_sparc64_mod_init);
+module_exit(sha256_sparc64_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SHA-224 and SHA-256 Secure Hash Algorithm, sparc64 sha256 opcode accelerated");
+
+MODULE_ALIAS("sha224");
+MODULE_ALIAS("sha256");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 167c856..4782d84 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -454,6 +454,15 @@ config CRYPTO_SHA256
 	  This code also includes SHA-224, a 224 bit hash with 112 bits
 	  of security against collision attacks.
 
+config CRYPTO_SHA256_SPARC64
+	tristate "SHA224 and SHA256 digest algorithm (SPARC64)"
+	depends on SPARC64
+	select CRYPTO_SHA256
+	select CRYPTO_HASH
+	help
+	  SHA-256 secure hash standard (DFIPS 180-2) implemented
+	  using sparc64 crypto instructions, when available.
+
 config CRYPTO_SHA512
 	tristate "SHA384 and SHA512 digest algorithms"
 	select CRYPTO_HASH
-- 
1.7.10.4

