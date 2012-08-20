From: David Miller <davem@davemloft.net>
Subject: [PATCH 3/4] sparc64: Add SHA384/SHA512 driver making use of the
 'sha512' instruction.
Date: Sun, 19 Aug 2012 22:10:24 -0700 (PDT)
Message-ID: <20120819.221024.2015569171734771260.davem@davemloft.net>
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
 arch/sparc/crypto/sha512_asm.S  |  102 ++++++++++++++++++
 arch/sparc/crypto/sha512_glue.c |  222 +++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                  |    9 ++
 4 files changed, 335 insertions(+)
 create mode 100644 arch/sparc/crypto/sha512_asm.S
 create mode 100644 arch/sparc/crypto/sha512_glue.c

diff --git a/arch/sparc/crypto/Makefile b/arch/sparc/crypto/Makefile
index 578f845..cfae0e8 100644
--- a/arch/sparc/crypto/Makefile
+++ b/arch/sparc/crypto/Makefile
@@ -4,6 +4,8 @@
 
 obj-$(CONFIG_CRYPTO_SHA1_SPARC64) += sha1-sparc64.o
 obj-$(CONFIG_CRYPTO_SHA256_SPARC64) += sha256-sparc64.o
+obj-$(CONFIG_CRYPTO_SHA512_SPARC64) += sha512-sparc64.o
 
 sha1-sparc64-y := sha1_asm.o sha1_glue.o
 sha256-sparc64-y := sha256_asm.o sha256_glue.o
+sha512-sparc64-y := sha512_asm.o sha512_glue.o
diff --git a/arch/sparc/crypto/sha512_asm.S b/arch/sparc/crypto/sha512_asm.S
new file mode 100644
index 0000000..04244da
--- /dev/null
+++ b/arch/sparc/crypto/sha512_asm.S
@@ -0,0 +1,102 @@
+#include <linux/linkage.h>
+#include <asm/visasm.h>
+
+ENTRY(sha512_sparc64_transform)
+	/* %o0 = digest, %o1 = data, %o2 = rounds */
+	VISEntry
+	ldd	[%o0 + 0x00], %f0
+	ldd	[%o0 + 0x08], %f2
+	ldd	[%o0 + 0x10], %f4
+	ldd	[%o0 + 0x18], %f6
+	ldd	[%o0 + 0x20], %f8
+	ldd	[%o0 + 0x28], %f10
+	andcc	%o1, 0x7, %g0
+	ldd	[%o0 + 0x30], %f12
+	bne,pn	%xcc, 10f
+	 ldd	[%o0 + 0x38], %f14
+
+1:
+	ldd	[%o1 + 0x00], %f16
+	ldd	[%o1 + 0x08], %f18
+	ldd	[%o1 + 0x10], %f20
+	ldd	[%o1 + 0x18], %f22
+	ldd	[%o1 + 0x20], %f24
+	ldd	[%o1 + 0x28], %f26
+	ldd	[%o1 + 0x30], %f28
+	ldd	[%o1 + 0x38], %f30
+	ldd	[%o1 + 0x40], %f32
+	ldd	[%o1 + 0x48], %f34
+	ldd	[%o1 + 0x50], %f36
+	ldd	[%o1 + 0x58], %f38
+	ldd	[%o1 + 0x60], %f40
+	ldd	[%o1 + 0x68], %f42
+	ldd	[%o1 + 0x70], %f44
+	ldd	[%o1 + 0x78], %f46
+
+	/* sha512 */
+	.word	0x81b02860
+
+	subcc	%o2, 1, %o2
+	bne,pt	%xcc, 1b
+	 add	%o1, 0x80, %o1
+
+5:
+	std	%f0, [%o0 + 0x00]
+	std	%f2, [%o0 + 0x08]
+	std	%f4, [%o0 + 0x10]
+	std	%f6, [%o0 + 0x18]
+	std	%f8, [%o0 + 0x20]
+	std	%f10, [%o0 + 0x28]
+	std	%f12, [%o0 + 0x30]
+	std	%f14, [%o0 + 0x38]
+	retl
+	 VISExit
+10:
+	alignaddr %o1, %g0, %o1
+
+	ldd	[%o1 + 0x00], %f18
+1:
+	ldd	[%o1 + 0x08], %f20
+	ldd	[%o1 + 0x10], %f22
+	ldd	[%o1 + 0x18], %f24
+	ldd	[%o1 + 0x20], %f26
+	ldd	[%o1 + 0x28], %f28
+	ldd	[%o1 + 0x30], %f30
+	ldd	[%o1 + 0x38], %f32
+	ldd	[%o1 + 0x40], %f34
+	ldd	[%o1 + 0x48], %f36
+	ldd	[%o1 + 0x50], %f38
+	ldd	[%o1 + 0x58], %f40
+	ldd	[%o1 + 0x60], %f42
+	ldd	[%o1 + 0x68], %f44
+	ldd	[%o1 + 0x70], %f46
+	ldd	[%o1 + 0x78], %f48
+	ldd	[%o1 + 0x80], %f50
+
+	faligndata %f18, %f20, %f16
+	faligndata %f20, %f22, %f18
+	faligndata %f22, %f24, %f20
+	faligndata %f24, %f26, %f22
+	faligndata %f26, %f28, %f24
+	faligndata %f28, %f30, %f26
+	faligndata %f30, %f32, %f28
+	faligndata %f32, %f34, %f30
+	faligndata %f34, %f36, %f32
+	faligndata %f36, %f38, %f34
+	faligndata %f38, %f40, %f36
+	faligndata %f40, %f42, %f38
+	faligndata %f42, %f44, %f40
+	faligndata %f44, %f46, %f42
+	faligndata %f46, %f48, %f44
+	faligndata %f48, %f50, %f46
+
+	/* sha512 */
+	.word	0x81b02860
+
+	subcc	%o2, 1, %o2
+	fsrc1	%f50, %f18
+	bne,pt	%xcc, 1b
+	 add	%o1, 0x80, %o1
+
+	ba,a,pt	%xcc, 5b
+ENDPROC(sha512_sparc64_transform)
diff --git a/arch/sparc/crypto/sha512_glue.c b/arch/sparc/crypto/sha512_glue.c
new file mode 100644
index 0000000..4d960be
--- /dev/null
+++ b/arch/sparc/crypto/sha512_glue.c
@@ -0,0 +1,222 @@
+/* Glue code for SHA512 hashing optimized for sparc64 crypto opcodes.
+ *
+ * This is based largely upon crypto/sha512_generic.c
+ *
+ * Copyright (c) Jean-Luc Cooke <jlcooke@certainkey.com>
+ * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
+ * Copyright (c) 2003 Kyle McMartin <kyle@debian.org>
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
+asmlinkage void sha512_sparc64_transform(u64 *digest, const char *data,
+					 unsigned int rounds);
+
+static int sha512_sparc64_init(struct shash_desc *desc)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	sctx->state[0] = SHA512_H0;
+	sctx->state[1] = SHA512_H1;
+	sctx->state[2] = SHA512_H2;
+	sctx->state[3] = SHA512_H3;
+	sctx->state[4] = SHA512_H4;
+	sctx->state[5] = SHA512_H5;
+	sctx->state[6] = SHA512_H6;
+	sctx->state[7] = SHA512_H7;
+	sctx->count[0] = sctx->count[1] = 0;
+
+	return 0;
+}
+
+static int sha384_sparc64_init(struct shash_desc *desc)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	sctx->state[0] = SHA384_H0;
+	sctx->state[1] = SHA384_H1;
+	sctx->state[2] = SHA384_H2;
+	sctx->state[3] = SHA384_H3;
+	sctx->state[4] = SHA384_H4;
+	sctx->state[5] = SHA384_H5;
+	sctx->state[6] = SHA384_H6;
+	sctx->state[7] = SHA384_H7;
+	sctx->count[0] = sctx->count[1] = 0;
+
+	return 0;
+}
+
+static void __sha512_sparc64_update(struct sha512_state *sctx, const u8 *data,
+				    unsigned int len, unsigned int partial)
+{
+	unsigned int done = 0;
+
+	if ((sctx->count[0] += len) < len)
+		sctx->count[1]++;
+	if (partial) {
+		done = SHA512_BLOCK_SIZE - partial;
+		memcpy(sctx->buf + partial, data, done);
+		sha512_sparc64_transform(sctx->state, sctx->buf, 1);
+	}
+	if (len - done >= SHA512_BLOCK_SIZE) {
+		const unsigned int rounds = (len - done) / SHA512_BLOCK_SIZE;
+
+		sha512_sparc64_transform(sctx->state, data + done, rounds);
+		done += rounds * SHA512_BLOCK_SIZE;
+	}
+
+	memcpy(sctx->buf, data + done, len - done);
+}
+
+static int sha512_sparc64_update(struct shash_desc *desc, const u8 *data,
+				 unsigned int len)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->count[0] % SHA512_BLOCK_SIZE;
+
+	/* Handle the fast case right here */
+	if (partial + len < SHA512_BLOCK_SIZE) {
+		if ((sctx->count[0] += len) < len)
+			sctx->count[1]++;
+		memcpy(sctx->buf + partial, data, len);
+	} else
+		__sha512_sparc64_update(sctx, data, len, partial);
+
+	return 0;
+}
+
+static int sha512_sparc64_final(struct shash_desc *desc, u8 *out)
+{
+	struct sha512_state *sctx = shash_desc_ctx(desc);
+	unsigned int i, index, padlen;
+	__be64 *dst = (__be64 *)out;
+	__be64 bits[2];
+	static const u8 padding[SHA512_BLOCK_SIZE] = { 0x80, };
+
+	/* Save number of bits */
+	bits[1] = cpu_to_be64(sctx->count[0] << 3);
+	bits[0] = cpu_to_be64(sctx->count[1] << 3 | sctx->count[0] >> 61);
+
+	/* Pad out to 112 mod 128 and append length */
+	index = sctx->count[0] % SHA512_BLOCK_SIZE;
+	padlen = (index < 112) ? (112 - index) : ((SHA512_BLOCK_SIZE+112) - index);
+
+	/* We need to fill a whole block for __sha512_sparc64_update() */
+	if (padlen <= 112) {
+		if ((sctx->count[0] += padlen) < padlen)
+			sctx->count[1]++;
+		memcpy(sctx->buf + index, padding, padlen);
+	} else {
+		__sha512_sparc64_update(sctx, padding, padlen, index);
+	}
+	__sha512_sparc64_update(sctx, (const u8 *)&bits, sizeof(bits), 112);
+
+	/* Store state in digest */
+	for (i = 0; i < 8; i++)
+		dst[i] = cpu_to_be64(sctx->state[i]);
+
+	/* Wipe context */
+	memset(sctx, 0, sizeof(*sctx));
+
+	return 0;
+}
+
+static int sha384_sparc64_final(struct shash_desc *desc, u8 *hash)
+{
+	u8 D[64];
+
+	sha512_sparc64_final(desc, D);
+
+	memcpy(hash, D, 48);
+	memset(D, 0, 64);
+
+	return 0;
+}
+
+static struct shash_alg sha512 = {
+	.digestsize	=	SHA512_DIGEST_SIZE,
+	.init		=	sha512_sparc64_init,
+	.update		=	sha512_sparc64_update,
+	.final		=	sha512_sparc64_final,
+	.descsize	=	sizeof(struct sha512_state),
+	.base		=	{
+		.cra_name	=	"sha512",
+		.cra_driver_name=	"sha512-sparc64",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA512_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static struct shash_alg sha384 = {
+	.digestsize	=	SHA384_DIGEST_SIZE,
+	.init		=	sha384_sparc64_init,
+	.update		=	sha512_sparc64_update,
+	.final		=	sha384_sparc64_final,
+	.descsize	=	sizeof(struct sha512_state),
+	.base		=	{
+		.cra_name	=	"sha384",
+		.cra_driver_name=	"sha384-sparc64",
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	SHA384_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static bool __init sparc64_has_sha512_opcode(void)
+{
+	unsigned long cfr;
+
+	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
+		return false;
+
+	__asm__ __volatile__("rd %%asr26, %0" : "=r" (cfr));
+	if (!(cfr & CFR_SHA512))
+		return false;
+
+	return true;
+}
+
+static int __init sha512_sparc64_mod_init(void)
+{
+	if (sparc64_has_sha512_opcode()) {
+		int ret = crypto_register_shash(&sha384);
+		if (ret < 0)
+			return ret;
+
+		ret = crypto_register_shash(&sha512);
+		if (ret < 0) {
+			crypto_unregister_shash(&sha384);
+			return ret;
+		}
+
+		pr_info("Using sparc64 sha512 opcode optimized SHA-512/SHA-384 implementation\n");
+		return 0;
+	}
+	pr_info("sparc64 sha512 opcode not available.\n");
+	return -ENODEV;
+}
+
+static void __exit sha512_sparc64_mod_fini(void)
+{
+	crypto_unregister_shash(&sha384);
+	crypto_unregister_shash(&sha512);
+}
+
+module_init(sha512_sparc64_mod_init);
+module_exit(sha512_sparc64_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SHA-384 and SHA-512 Secure Hash Algorithm, sparc64 sha512 opcode accelerated");
+
+MODULE_ALIAS("sha384");
+MODULE_ALIAS("sha512");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 4782d84..e7ed12a 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -475,6 +475,15 @@ config CRYPTO_SHA512
 	  This code also includes SHA-384, a 384 bit hash with 192 bits
 	  of security against collision attacks.
 
+config CRYPTO_SHA512_SPARC64
+	tristate "SHA384 and SHA512 digest algorithm (SPARC64)"
+	depends on SPARC64
+	select CRYPTO_SHA512
+	select CRYPTO_HASH
+	help
+	  SHA-512 secure hash standard (DFIPS 180-2) implemented
+	  using sparc64 crypto instructions, when available.
+
 config CRYPTO_TGR192
 	tristate "Tiger digest algorithms"
 	select CRYPTO_HASH
-- 
1.7.10.4

