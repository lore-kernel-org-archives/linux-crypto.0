From: Austin Zhang <austin_zhang@linux.intel.com>
Subject: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API -V2.
Date: Tue, 05 Aug 2008 07:56:43 -0400
Message-ID: <1217937403.3641.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, dwmw2@infradead.org,
	davem@davemloft.net, randy.dunlap@oracle.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga10.intel.com ([192.55.52.92]:45945 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758693AbYHEL62 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Aug 2008 07:58:28 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Revised by comments:
Move hardware feature detect into module init;
Revise dependency in Kconfig;
Revise variable type;
Add information output while module loading failed; 
 

>From NHM processor onward, Intel processors can support hardware
accelerated
CRC32c algorithm with the new CRC32 instruction in SSE 4.2 instruction
set.
The patch detects the availability of the feature, and chooses the most
proper
way to calculate CRC32c checksum.
Byte code instructions are used for compiler compatibility.
No MMX / XMM registers is involved in the implementation.

Signed-off-by: Austin Zhang <austin.zhang@intel.com>
Signed-off-by: Kent Liu <kent.liu@intel.com>
---
 arch/x86/crypto/Makefile       |    2 
 arch/x86/crypto/crc32c-intel.c |  190
+++++++++++++++++++++++++++++++++++++++++
 crypto/Kconfig                 |   12 ++
 include/asm-x86/cpufeature.h   |    2 
 4 files changed, 206 insertions(+)

diff -Naurp linux-2.6/arch/x86/crypto/crc32c-intel.c
linux-2.6-patch/arch/x86/crypto/crc32c-intel.c
--- linux-2.6/arch/x86/crypto/crc32c-intel.c	1969-12-31
19:00:00.000000000 -0500
+++ linux-2.6-patch/arch/x86/crypto/crc32c-intel.c	2008-08-05
07:06:21.000000000 -0400
@@ -0,0 +1,190 @@
+/*
+ * Using hardware provided CRC32 instruction to accelerate the CRC32
disposal.
+ * CRC32C polynomial:0x1EDC6F41(BE)/0x82F63B78(LE)
+ * CRC32 is a new instruction in Intel SSE4.2, the reference can be
found at:
+ * http://www.intel.com/products/processor/manuals/
+ * Intel(R) 64 and IA-32 Architectures Software Developer's Manual
+ * Volume 2A: Instruction Set Reference, A-M
+ */
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <crypto/internal/hash.h>
+
+#include <asm/cpufeature.h>
+
+#define CHKSUM_BLOCK_SIZE	1
+#define CHKSUM_DIGEST_SIZE	4
+
+#ifdef CONFIG_X86_64
+#define REX_PRE "0x48, "
+#define SCALE_F 8
+#else
+#define REX_PRE
+#define SCALE_F 4
+#endif
+
+u32 crc32c_intel_le_hw_byte(u32 crc, unsigned char const *data, size_t
length)
+{
+	while (length--) {
+		__asm__ __volatile__(
+			".byte 0xf2, 0xf, 0x38, 0xf0, 0xf1"
+			:"=S"(crc)
+			:"0"(crc), "c"(*data)
+		);
+		data++;
+	}
+
+	return crc;
+}
+
+u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, size_t
len)
+{
+	unsigned int iquotient = len / SCALE_F;
+	unsigned int iremainder = len % SCALE_F;
+	unsigned long *ptmp = (unsigned long *)p;
+
+	while (iquotient--) {
+		__asm__ __volatile__(
+			".byte 0xf2, " REX_PRE "0xf, 0x38, 0xf1, 0xf1;"
+			:"=S"(crc)
+			:"0"(crc), "c"(*ptmp)
+		);
+		ptmp++;
+	}
+
+	if (iremainder)
+		crc = crc32c_intel_le_hw_byte(crc, (unsigned char *)ptmp,
+				 iremainder);
+
+	return crc;
+}
+
+/*
+ * Setting the seed allows arbitrary accumulators and flexible XOR
policy
+ * If your algorithm starts with ~0, then XOR with ~0 before you set
+ * the seed.
+ */
+static int crc32c_intel_setkey(struct crypto_ahash *hash, const u8
*key,
+			unsigned int keylen)
+{
+	u32 *mctx = crypto_ahash_ctx(hash);
+
+	if (keylen != sizeof(u32)) {
+		crypto_ahash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	*mctx = le32_to_cpup((__le32 *)key);
+	return 0;
+}
+
+static int crc32c_intel_init(struct ahash_request *req)
+{
+	u32 *mctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	u32 *crcp = ahash_request_ctx(req);
+
+	*crcp = *mctx;
+
+	return 0;
+}
+
+static int crc32c_intel_update(struct ahash_request *req)
+{
+	struct crypto_hash_walk walk;
+	u32 *crcp = ahash_request_ctx(req);
+	u32 crc = *crcp;
+	int nbytes;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes;
+	   nbytes = crypto_hash_walk_done(&walk, 0))
+	crc = crc32c_intel_le_hw(crc, walk.data, nbytes);
+
+	*crcp = crc;
+	return 0;
+}
+
+static int crc32c_intel_final(struct ahash_request *req)
+{
+	u32 *crcp = ahash_request_ctx(req);
+
+	*(__le32 *)req->result = ~cpu_to_le32p(crcp);
+	return 0;
+}
+
+static int crc32c_intel_digest(struct ahash_request *req)
+{
+	struct crypto_hash_walk walk;
+	u32 *mctx = crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	u32 crc = *mctx;
+	int nbytes;
+
+	for (nbytes = crypto_hash_walk_first(req, &walk); nbytes;
+	   nbytes = crypto_hash_walk_done(&walk, 0))
+		crc = crc32c_intel_le_hw(crc, walk.data, nbytes);
+
+	*(__le32 *)req->result = ~cpu_to_le32(crc);
+	return 0;
+}
+
+static int crc32c_intel_cra_init(struct crypto_tfm *tfm)
+{
+	u32 *key = crypto_tfm_ctx(tfm);
+
+	*key = ~0;
+
+	tfm->crt_ahash.reqsize = sizeof(u32);
+
+	return 0;
+}
+
+static struct crypto_alg alg = {
+	.cra_name               =       "crc32c",
+	.cra_driver_name        =       "crc32c-intel",
+	.cra_priority           =       200,
+	.cra_flags              =       CRYPTO_ALG_TYPE_AHASH,
+	.cra_blocksize          =       CHKSUM_BLOCK_SIZE,
+	.cra_alignmask          =       3,
+	.cra_ctxsize            =       sizeof(u32),
+	.cra_module             =       THIS_MODULE,
+	.cra_list               =       LIST_HEAD_INIT(alg.cra_list),
+	.cra_init               =       crc32c_intel_cra_init,
+	.cra_type               =       &crypto_ahash_type,
+	.cra_u                  =       {
+		.ahash = {
+			.digestsize    =       CHKSUM_DIGEST_SIZE,
+			.setkey        =       crc32c_intel_setkey,
+			.init          =       crc32c_intel_init,
+			.update        =       crc32c_intel_update,
+			.final         =       crc32c_intel_final,
+			.digest        =       crc32c_intel_digest,
+		}
+	}
+};
+
+
+static int __init crc32c_intel_mod_init(void)
+{
+	if (cpu_has_xmm4_2)
+		return crypto_register_alg(&alg);
+	else {
+		printk(KERN_ERR"No support in current hardware.\n");
+		return -1;
+	}
+}
+
+static void __exit crc32c_intel_mod_fini(void)
+{
+	crypto_unregister_alg(&alg);
+}
+
+module_init(crc32c_intel_mod_init);
+module_exit(crc32c_intel_mod_fini);
+
+MODULE_AUTHOR("Austin Zhang <austin.zhang@intel.com>, Kent Liu
<kent.liu@intel.com>");
+MODULE_DESCRIPTION("CRC32c (Castagnoli) optimization using Intel
Hardware.");
+MODULE_LICENSE("GPL");
+
+MODULE_ALIAS("crc32c");
+MODULE_ALIAS("crc32c-intel");
+
diff -Naurp linux-2.6/arch/x86/crypto/Makefile
linux-2.6-patch/arch/x86/crypto/Makefile
--- linux-2.6/arch/x86/crypto/Makefile	2008-08-04 01:08:00.000000000
-0400
+++ linux-2.6-patch/arch/x86/crypto/Makefile	2008-08-05
07:06:08.000000000 -0400
@@ -10,6 +10,8 @@ obj-$(CONFIG_CRYPTO_AES_X86_64) += aes-x
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) += twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) += salsa20-x86_64.o
 
+obj-$(CONFIG_CRYPTO_CRC32C_INTEL) += crc32c-intel.o
+
 aes-i586-y := aes-i586-asm_32.o aes_glue.o
 twofish-i586-y := twofish-i586-asm_32.o twofish_glue.o
 salsa20-i586-y := salsa20-i586-asm_32.o salsa20_glue.o
diff -Naurp linux-2.6/crypto/Kconfig linux-2.6-patch/crypto/Kconfig
--- linux-2.6/crypto/Kconfig	2008-08-04 01:08:00.000000000 -0400
+++ linux-2.6-patch/crypto/Kconfig	2008-08-05 07:06:08.000000000 -0400
@@ -221,6 +221,18 @@ config CRYPTO_CRC32C
 	  See Castagnoli93.  This implementation uses lib/libcrc32c.
           Module will be crc32c.
 
+config CRYPTO_CRC32C_INTEL
+        tristate "CRC32c INTEL hardware acceleration"
+	depends on X86
+        select CRYPTO_ALGAPI
+        help
+          In Intel processor with SSE4.2 supported, the processor will
+          support CRC32C implementation using hardware accelerated
CRC32
+          instruction. This option will create 'crc32c-intel' module,
+          which will enable any routine to use the CRC32 instruction to
+          gain performance compared with software implementation.
+          Module will be crc32c-intel.
+
 config CRYPTO_MD4
 	tristate "MD4 digest algorithm"
 	select CRYPTO_ALGAPI
diff -Naurp linux-2.6/include/asm-x86/cpufeature.h
linux-2.6-patch/include/asm-x86/cpufeature.h
--- linux-2.6/include/asm-x86/cpufeature.h	2008-08-04 01:08:08.000000000
-0400
+++ linux-2.6-patch/include/asm-x86/cpufeature.h	2008-08-05
07:06:08.000000000 -0400
@@ -91,6 +91,7 @@
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_XMM4_2	(4*32+20) /* Streaming SIMD Extensions-4.2
*/
 
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, word
5 */
 #define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore
insn) */
@@ -189,6 +190,7 @@ extern const char * const x86_power_flag
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+#define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
 
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1


