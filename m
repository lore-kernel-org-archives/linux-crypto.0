From: David Miller <davem@davemloft.net>
Subject: [PATCH] sparc64: Add CRC32C driver making use of the new crc32c
 opcode.
Date: Wed, 22 Aug 2012 20:52:31 -0700 (PDT)
Message-ID: <20120822.205231.113785660704668571.davem@davemloft.net>
References: <20120822.022118.64713091452626424.davem@davemloft.net>
	<20120822134040.GA7440@gondor.apana.org.au>
	<20120822.143111.2226960299830142976.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sparclinux@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20120822.143111.2226960299830142976.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: David S. Miller <davem@davemloft.net>
---

This was largely straightforward, except for two things.

1) The tests assume that the 32-bit crc is stored in the context in
   cpu endian.  The sparc64 crc32c opcode wants to work with a little
   endian mode, but sparc64 is big-endian.

   This requirement is codified in the crc32c test:

		*(u32 *)sdesc.ctx = le32_to_cpu(420553207);
		err = crypto_shash_final(&sdesc.shash, (u8 *)&val);
		if (err) {
			printk(KERN_ERR "alg: crc32c: Operation failed for "
			       "%s: %d\n", driver, err);
			break;
		}

		if (val != ~420553207) {
			printk(KERN_ERR "alg: crc32c: Test failed for %s: "
			       "%d\n", driver, val);

   So I trick things.  I store the crc in the context as the crypto
   layer expects, but when I load it into and out of the FPU registers
   I use little endian loads and stores.

2) The instruction only supports crc'ing 8 bytes at a time, so for any
   sub 8-byte calculations I call down into the C version.

 arch/sparc/crypto/Makefile      |    4 +
 arch/sparc/crypto/crc32c_asm.S  |   29 +++++++
 arch/sparc/crypto/crc32c_glue.c |  177 +++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                  |    9 ++
 4 files changed, 219 insertions(+)
 create mode 100644 arch/sparc/crypto/crc32c_asm.S
 create mode 100644 arch/sparc/crypto/crc32c_glue.c

diff --git a/arch/sparc/crypto/Makefile b/arch/sparc/crypto/Makefile
index 5034324..c6ca941 100644
--- a/arch/sparc/crypto/Makefile
+++ b/arch/sparc/crypto/Makefile
@@ -9,9 +9,13 @@ obj-$(CONFIG_CRYPTO_MD5_SPARC64) += md5-sparc64.o
 
 obj-$(CONFIG_CRYPTO_AES_SPARC64) += aes-sparc64.o
 
+obj-$(CONFIG_CRYPTO_CRC32C_SPARC64) += crc32c-sparc64.o
+
 sha1-sparc64-y := sha1_asm.o sha1_glue.o
 sha256-sparc64-y := sha256_asm.o sha256_glue.o
 sha512-sparc64-y := sha512_asm.o sha512_glue.o
 md5-sparc64-y := md5_asm.o md5_glue.o
 
 aes-sparc64-y := aes_asm.o aes_glue.o
+
+crc32c-sparc64-y := crc32c_asm.o crc32c_glue.o
diff --git a/arch/sparc/crypto/crc32c_asm.S b/arch/sparc/crypto/crc32c_asm.S
new file mode 100644
index 0000000..cb479ec
--- /dev/null
+++ b/arch/sparc/crypto/crc32c_asm.S
@@ -0,0 +1,29 @@
+#include <linux/linkage.h>
+#include <asm/visasm.h>
+#include <asm/asi.h>
+
+#define F3F(x,y,z)	(((x)<<30)|((y)<<19)|((z)<<5))
+
+#define FPD_ENCODE(x)	(((x) >> 5) | ((x) & ~(0x20)))
+
+#define RS1(x)		(FPD_ENCODE(x) << 14)
+#define RS2(x)		(FPD_ENCODE(x) <<  0)
+#define RD(x)		(FPD_ENCODE(x) << 25)
+
+#define CRC32C(a,b,c)	\
+	.word		(F3F(2,0x36,0x147)|RS1(a)|RS2(b)|RD(c));
+
+ENTRY(crc32c_sparc64)
+	/* %o0=crc32p, %o1=data_ptr, %o2=len */
+	VISEntryHalf
+	lda	[%o0] ASI_PL, %f1
+1:	ldd	[%o1], %f2
+	CRC32C(0,2,0)
+	subcc	%o2, 8, %o2
+	bne,pt	%icc, 1b
+	 add	%o1, 0x8, %o1
+	sta	%f1, [%o0] ASI_PL
+	VISExitHalf
+2:	retl
+	 nop
+ENDPROC(crc32c_sparc64)
diff --git a/arch/sparc/crypto/crc32c_glue.c b/arch/sparc/crypto/crc32c_glue.c
new file mode 100644
index 0000000..ec31cdb
--- /dev/null
+++ b/arch/sparc/crypto/crc32c_glue.c
@@ -0,0 +1,177 @@
+/* Glue code for CRC32C optimized for sparc64 crypto opcodes.
+ *
+ * This is based largely upon arch/x86/crypto/crc32c-intel.c
+ *
+ * Copyright (C) 2008 Intel Corporation
+ * Authors: Austin Zhang <austin_zhang@linux.intel.com>
+ *          Kent Liu <kent.liu@intel.com>
+ */
+
+#define pr_fmt(fmt)	KBUILD_MODNAME ": " fmt
+
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/crc32.h>
+
+#include <crypto/internal/hash.h>
+
+#include <asm/pstate.h>
+#include <asm/elf.h>
+
+/*
+ * Setting the seed allows arbitrary accumulators and flexible XOR policy
+ * If your algorithm starts with ~0, then XOR with ~0 before you set
+ * the seed.
+ */
+static int crc32c_sparc64_setkey(struct crypto_shash *hash, const u8 *key,
+				 unsigned int keylen)
+{
+	u32 *mctx = crypto_shash_ctx(hash);
+
+	if (keylen != sizeof(u32)) {
+		crypto_shash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	*(__le32 *)mctx = le32_to_cpup((__le32 *)key);
+	return 0;
+}
+
+static int crc32c_sparc64_init(struct shash_desc *desc)
+{
+	u32 *mctx = crypto_shash_ctx(desc->tfm);
+	u32 *crcp = shash_desc_ctx(desc);
+
+	*crcp = *mctx;
+
+	return 0;
+}
+
+extern void crc32c_sparc64(u32 *crcp, const u64 *data, unsigned int len);
+
+static void crc32c_compute(u32 *crcp, const u64 *data, unsigned int len)
+{
+	unsigned int asm_len;
+
+	asm_len = len & ~7U;
+	if (asm_len) {
+		crc32c_sparc64(crcp, data, asm_len);
+		data += asm_len / 8;
+		len -= asm_len;
+	}
+	if (len)
+		*crcp = __crc32c_le(*crcp, (const unsigned char *) data, len);
+}
+
+static int crc32c_sparc64_update(struct shash_desc *desc, const u8 *data,
+				 unsigned int len)
+{
+	u32 *crcp = shash_desc_ctx(desc);
+
+	crc32c_compute(crcp, (const u64 *) data, len);
+
+	return 0;
+}
+
+static int __crc32c_sparc64_finup(u32 *crcp, const u8 *data, unsigned int len,
+				  u8 *out)
+{
+	u32 tmp = *crcp;
+
+	crc32c_compute(&tmp, (const u64 *) data, len);
+
+	*(__le32 *) out = ~cpu_to_le32(tmp);
+	return 0;
+}
+
+static int crc32c_sparc64_finup(struct shash_desc *desc, const u8 *data,
+				unsigned int len, u8 *out)
+{
+	return __crc32c_sparc64_finup(shash_desc_ctx(desc), data, len, out);
+}
+
+static int crc32c_sparc64_final(struct shash_desc *desc, u8 *out)
+{
+	u32 *crcp = shash_desc_ctx(desc);
+
+	*(__le32 *) out = ~cpu_to_le32p(crcp);
+	return 0;
+}
+
+static int crc32c_sparc64_digest(struct shash_desc *desc, const u8 *data,
+				 unsigned int len, u8 *out)
+{
+	return __crc32c_sparc64_finup(crypto_shash_ctx(desc->tfm), data, len,
+				      out);
+}
+
+static int crc32c_sparc64_cra_init(struct crypto_tfm *tfm)
+{
+	u32 *key = crypto_tfm_ctx(tfm);
+
+	*key = ~0;
+
+	return 0;
+}
+
+#define CHKSUM_BLOCK_SIZE	1
+#define CHKSUM_DIGEST_SIZE	4
+
+static struct shash_alg alg = {
+	.setkey			=	crc32c_sparc64_setkey,
+	.init			=	crc32c_sparc64_init,
+	.update			=	crc32c_sparc64_update,
+	.final			=	crc32c_sparc64_final,
+	.finup			=	crc32c_sparc64_finup,
+	.digest			=	crc32c_sparc64_digest,
+	.descsize		=	sizeof(u32),
+	.digestsize		=	CHKSUM_DIGEST_SIZE,
+	.base			=	{
+		.cra_name		=	"crc32c",
+		.cra_driver_name	=	"crc32c-sparc64",
+		.cra_priority		=	150,
+		.cra_blocksize		=	CHKSUM_BLOCK_SIZE,
+		.cra_ctxsize		=	sizeof(u32),
+		.cra_alignmask		=	7,
+		.cra_module		=	THIS_MODULE,
+		.cra_init		=	crc32c_sparc64_cra_init,
+	}
+};
+
+static bool __init sparc64_has_crc32c_opcode(void)
+{
+	unsigned long cfr;
+
+	if (!(sparc64_elf_hwcap & HWCAP_SPARC_CRYPTO))
+		return false;
+
+	__asm__ __volatile__("rd %%asr26, %0" : "=r" (cfr));
+	if (!(cfr & CFR_CRC32C))
+		return false;
+
+	return true;
+}
+
+static int __init crc32c_sparc64_mod_init(void)
+{
+	if (sparc64_has_crc32c_opcode()) {
+		pr_info("Using sparc64 crc32c opcode optimized CRC32C implementation\n");
+		return crypto_register_shash(&alg);
+	}
+	pr_info("sparc64 crc32c opcode not available.\n");
+	return -ENODEV;
+}
+
+static void __exit crc32c_sparc64_mod_fini(void)
+{
+	crypto_unregister_shash(&alg);
+}
+
+module_init(crc32c_sparc64_mod_init);
+module_exit(crc32c_sparc64_mod_fini);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("CRC32c (Castagnoli), sparc64 crc32c opcode accelerated");
+
+MODULE_ALIAS("crc32c");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 49f867b..83993ea 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -336,6 +336,15 @@ config CRYPTO_CRC32C_INTEL
 	  gain performance compared with software implementation.
 	  Module will be crc32c-intel.
 
+config CRYPTO_CRC32C_SPARC64
+	tristate "CRC32c CRC algorithm (SPARC64)"
+	depends on SPARC64
+	select CRYPTO_HASH
+	select CRC32
+	help
+	  CRC32c CRC algorithm implemented using sparc64 crypto instructions,
+	  when available.
+
 config CRYPTO_GHASH
 	tristate "GHASH digest algorithm"
 	select CRYPTO_GF128MUL
-- 
1.7.10.4

