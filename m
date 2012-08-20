From: David Miller <davem@davemloft.net>
Subject: [PATCH 4/4] sparc64: Add MD5 driver making use of the 'md5'
 instruction.
Date: Sun, 19 Aug 2012 22:10:30 -0700 (PDT)
Message-ID: <20120819.221030.1905348537676038204.davem@davemloft.net>
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
 arch/sparc/crypto/Makefile   |    2 +
 arch/sparc/crypto/md5_asm.S  |   70 ++++++++++++++++
 arch/sparc/crypto/md5_glue.c |  186 ++++++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig               |    9 ++
 4 files changed, 267 insertions(+)
 create mode 100644 arch/sparc/crypto/md5_asm.S
 create mode 100644 arch/sparc/crypto/md5_glue.c

diff --git a/arch/sparc/crypto/Makefile b/arch/sparc/crypto/Makefile
index cfae0e8..5356698 100644
--- a/arch/sparc/crypto/Makefile
+++ b/arch/sparc/crypto/Makefile
@@ -5,7 +5,9 @@
 obj-$(CONFIG_CRYPTO_SHA1_SPARC64) += sha1-sparc64.o
 obj-$(CONFIG_CRYPTO_SHA256_SPARC64) += sha256-sparc64.o
 obj-$(CONFIG_CRYPTO_SHA512_SPARC64) += sha512-sparc64.o
+obj-$(CONFIG_CRYPTO_MD5_SPARC64) += md5-sparc64.o
 
 sha1-sparc64-y := sha1_asm.o sha1_glue.o
 sha256-sparc64-y := sha256_asm.o sha256_glue.o
 sha512-sparc64-y := sha512_asm.o sha512_glue.o
+md5-sparc64-y := md5_asm.o md5_glue.o
diff --git a/arch/sparc/crypto/md5_asm.S b/arch/sparc/crypto/md5_asm.S
new file mode 100644
index 0000000..220b73b
--- /dev/null
+++ b/arch/sparc/crypto/md5_asm.S
@@ -0,0 +1,70 @@
+#include <linux/linkage.h>
+#include <asm/visasm.h>
+
+ENTRY(md5_sparc64_transform)
+	/* %o0 = digest, %o1 = data, %o2 = rounds */
+	VISEntryHalf
+	ld	[%o0 + 0x00], %f0
+	ld	[%o0 + 0x04], %f1
+	andcc	%o1, 0x7, %g0
+	ld	[%o0 + 0x08], %f2
+	bne,pn	%xcc, 10f
+	 ld	[%o0 + 0x0c], %f3
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
+	/* md5 */
+	.word	0x81b02800
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
+	/* md5 */
+	.word	0x81b02800
+
+	subcc	%o2, 1, %o2
+	fsrc1	%f26, %f10
+	bne,pt	%xcc, 1b
+	 add	%o1, 0x40, %o1
+
+	ba,a,pt	%xcc, 5b
+ENDPROC(md5_sparc64_transform)
diff --git a/arch/sparc/crypto/md5_glue.c b/arch/sparc/crypto/md5_glue.c
new file mode 100644
index 0000000..bdfcfef
--- /dev/null
+++ b/arch/sparc/crypto/md5_glue.c
@@ -0,0 +1,186 @@
+/* Glue code for MD5 hashing optimized for sparc64 crypto opcodes.
+ *
+ * This is based largely upon arch/x86/crypto/sha1_ssse3_glue.c
+ * and crypto/md5.c which are:
+ *
+ * Copyright (c) Alan Smithee.
+ * Copyright (c) Andrew McDonald <andrew@mcdonald.org.uk>
+ * Copyright (c) Jean-Francois Dive <jef@linuxbe.org>
+ * Copyright (c) Mathias Krause <minipli@googlemail.com>
+ * Copyright (c) Cryptoapi developers.
+ * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
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
+#include <crypto/md5.h>
+
+#include <asm/pstate.h>
+#include <asm/elf.h>
+
+asmlinkage void md5_sparc64_transform(u32 *digest, const char *data,
+				      unsigned int rounds);
+
+static int md5_sparc64_init(struct shash_desc *desc)
+{
+	struct md5_state *mctx = shash_desc_ctx(desc);
+
+	mctx->hash[0] = cpu_to_le32(0x67452301);
+	mctx->hash[1] = cpu_to_le32(0xefcdab89);
+	mctx->hash[2] = cpu_to_le32(0x98badcfe);
+	mctx->hash[3] = cpu_to_le32(0x10325476);
+	mctx->byte_count = 0;
+
+	return 0;
+}
+
+static void __md5_sparc64_update(struct md5_state *sctx, const u8 *data,
+				 unsigned int len, unsigned int partial)
+{
+	unsigned int done = 0;
+
+	sctx->byte_count += len;
+	if (partial) {
+		done = MD5_HMAC_BLOCK_SIZE - partial;
+		memcpy((u8 *)sctx->block + partial, data, done);
+		md5_sparc64_transform(sctx->hash, (u8 *)sctx->block, 1);
+	}
+	if (len - done >= MD5_HMAC_BLOCK_SIZE) {
+		const unsigned int rounds = (len - done) / MD5_HMAC_BLOCK_SIZE;
+
+		md5_sparc64_transform(sctx->hash, data + done, rounds);
+		done += rounds * MD5_HMAC_BLOCK_SIZE;
+	}
+
+	memcpy(sctx->block, data + done, len - done);
+}
+
+static int md5_sparc64_update(struct shash_desc *desc, const u8 *data,
+			      unsigned int len)
+{
+	struct md5_state *sctx = shash_desc_ctx(desc);
+	unsigned int partial = sctx->byte_count % MD5_HMAC_BLOCK_SIZE;
+
+	/* Handle the fast case right here */
+	if (partial + len < MD5_HMAC_BLOCK_SIZE) {
+		sctx->byte_count += len;
+		memcpy((u8 *)sctx->block + partial, data, len);
+	} else
+		__md5_sparc64_update(sctx, data, len, partial);
+
+	return 0;
+}
+
+/* Add padding and return the message digest. */
+static int md5_sparc64_final(struct shash_desc *desc, u8 *out)
+{
+	struct md5_state *sctx = shash_desc_ctx(desc);
+	unsigned int i, index, padlen;
+	u32 *dst = (u32 *)out;
+	__le64 bits;
+	static const u8 padding[MD5_HMAC_BLOCK_SIZE] = { 0x80, };
+
+	bits = cpu_to_le64(sctx->byte_count << 3);
+
+	/* Pad out to 56 mod 64 and append length */
+	index = sctx->byte_count % MD5_HMAC_BLOCK_SIZE;
+	padlen = (index < 56) ? (56 - index) : ((MD5_HMAC_BLOCK_SIZE+56) - index);
+
+	/* We need to fill a whole block for __md5_sparc64_update() */
+	if (padlen <= 56) {
+		sctx->byte_count += padlen;
+		memcpy((u8 *)sctx->block + index, padding, padlen);
+	} else {
+		__md5_sparc64_update(sctx, padding, padlen, index);
+	}
+	__md5_sparc64_update(sctx, (const u8 *)&bits, sizeof(bits), 56);
+
+	/* Store state in digest */
+	for (i = 0; i < MD5_HASH_WORDS; i++)
+		dst[i] = sctx->hash[i];
+
+	/* Wipe context */
+	memset(sctx, 0, sizeof(*sctx));
+
+	return 0;
+}
+
+static int md5_sparc64_export(struct shash_desc *desc, void *out)
+{
+	struct md5_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(out, sctx, sizeof(*sctx));
+
+	return 0;
+}
+
+static int md5_sparc64_import(struct shash_desc *desc, const void *in)
+{
+	struct md5_state *sctx = shash_desc_ctx(desc);
+
+	memcpy(sctx, in, sizeof(*sctx));
+
+	return 0;
+}
+
+static struct shash_alg alg = {
+	.digestsize	=	MD5_DIGEST_SIZE,
+	.init		=	md5_sparc64_init,
+	.update		=	md5_sparc64_update,
+	.final		=	md5_sparc64_final,
+	.export		=	md5_sparc64_export,
+	.import		=	md5_sparc64_import,
+	.descsize	=	sizeof(struct md5_state),
+	.statesize	=	sizeof(struct md5_state),
+	.base		=	{
+		.cra_name	=	"md5",
+		.cra_driver_name=	"md5-sparc64",
+		.cra_priority	=	150,
+		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize	=	MD5_HMAC_BLOCK_SIZE,
+		.cra_module	=	THIS_MODULE,
+	}
+};
+
+static bool __init sparc64_has_md5_opcode(void)
+{
+	unsigned long cfr;
+
+	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
+		return false;
+
+	__asm__ __volatile__("rd %%asr26, %0" : "=r" (cfr));
+	if (!(cfr & CFR_MD5))
+		return false;
+
+	return true;
+}
+
+static int __init md5_sparc64_mod_init(void)
+{
+	if (sparc64_has_md5_opcode()) {
+		pr_info("Using sparc64 md5 opcode optimized MD5 implementation\n");
+		return crypto_register_shash(&alg);
+	}
+	pr_info("sparc64 md5 opcode not available.\n");
+	return -ENODEV;
+}
+
+static void __exit md5_sparc64_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(md5_sparc64_mod_init);
+module_exit(md5_sparc64_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("MD5 Secure Hash Algorithm, sparc64 md5 opcode accelerated");
+
+MODULE_ALIAS("md5");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index e7ed12a..4cb1ab0 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -354,6 +354,15 @@ config CRYPTO_MD5
 	help
 	  MD5 message digest algorithm (RFC1321).
 
+config CRYPTO_MD5_SPARC64
+	tristate "MD5 digest algorithm (SPARC64)"
+	depends on SPARC64
+	select CRYPTO_MD5
+	select CRYPTO_HASH
+	help
+	  MD5 message digest algorithm (RFC1321) implemented
+	  using sparc64 crypto instructions, when available.
+
 config CRYPTO_MICHAEL_MIC
 	tristate "Michael MIC keyed digest algorithm"
 	select CRYPTO_HASH
-- 
1.7.10.4

