From: Austin Zhang <austin_zhang@linux.intel.com>
Subject: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API -V3.
Date: Wed, 06 Aug 2008 01:23:31 -0400
Message-ID: <1218000211.4231.23.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: dwmw2@infradead.org, davem@davemloft.net, randy.dunlap@oracle.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au, bunk@kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32686 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750980AbYHFFZX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 6 Aug 2008 01:25:23 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=EF=BB=BF=EF=BB=BFRevised by comments:
Add 'static' for limitation namespace;
Resend for fixing lines-folded by adjusting evolution config;
(The patch was created against 2.6.27-rc1)

>From NHM processor onward, Intel processors can support hardware accel=
erated
CRC32c algorithm with the new CRC32 instruction in SSE 4.2 instruction =
set.
The patch detects the availability of the feature, and chooses the most=
 proper
way to calculate CRC32c checksum.
Byte code instructions are used for compiler compatibility.
No MMX / XMM registers is involved in the implementation.

Signed-off-by: Austin Zhang <austin.zhang@intel.com>
Signed-off-by: Kent Liu <kent.liu@intel.com>
---
 arch/x86/crypto/Makefile       |    2
 arch/x86/crypto/crc32c-intel.c |  190 ++++++++++++++++++++++++++++++++=
+++++++++
 crypto/Kconfig                 |   12 ++
 include/asm-x86/cpufeature.h   |    2
 4 files changed, 206 insertions(+)

diff -Naurp linux-2.6/arch/x86/crypto/crc32c-intel.c linux-2.6-patch/ar=
ch/x86/crypto/crc32c-intel.c
--- linux-2.6/arch/x86/crypto/crc32c-intel.c	1969-12-31 19:00:00.000000=
000 -0500
+++ linux-2.6-patch/arch/x86/crypto/crc32c-intel.c	2008-08-05 21:57:37.=
000000000 -0400
@@ -0,0 +1,190 @@
+/*
+ * Using hardware provided CRC32 instruction to accelerate the CRC32 d=
isposal.
+ * CRC32C polynomial:0x1EDC6F41(BE)/0x82F63B78(LE)
+ * CRC32 is a new instruction in Intel SSE4.2, the reference can be fo=
und at:
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
+static u32 crc32c_intel_le_hw_byte(u32 crc, unsigned char const *data,=
 size_t length)
+{
+	while (length--) {
+		__asm__ __volatile__(
+			".byte 0xf2, 0xf, 0x38, 0xf0, 0xf1"
+			:"=3DS"(crc)
+			:"0"(crc), "c"(*data)
+		);
+		data++;
+	}
+
+	return crc;
+}
+
+static u32 __pure crc32c_intel_le_hw(u32 crc, unsigned char const *p, =
size_t len)
+{
+	unsigned int iquotient =3D len / SCALE_F;
+	unsigned int iremainder =3D len % SCALE_F;
+	unsigned long *ptmp =3D (unsigned long *)p;
+
+	while (iquotient--) {
+		__asm__ __volatile__(
+			".byte 0xf2, " REX_PRE "0xf, 0x38, 0xf1, 0xf1;"
+			:"=3DS"(crc)
+			:"0"(crc), "c"(*ptmp)
+		);
+		ptmp++;
+	}
+
+	if (iremainder)
+		crc =3D crc32c_intel_le_hw_byte(crc, (unsigned char *)ptmp,
+				 iremainder);
+
+	return crc;
+}
+
+/*
+ * Setting the seed allows arbitrary accumulators and flexible XOR pol=
icy
+ * If your algorithm starts with ~0, then XOR with ~0 before you set
+ * the seed.
+ */
+static int crc32c_intel_setkey(struct crypto_ahash *hash, const u8 *ke=
y,
+			unsigned int keylen)
+{
+	u32 *mctx =3D crypto_ahash_ctx(hash);
+
+	if (keylen !=3D sizeof(u32)) {
+		crypto_ahash_set_flags(hash, CRYPTO_TFM_RES_BAD_KEY_LEN);
+		return -EINVAL;
+	}
+	*mctx =3D le32_to_cpup((__le32 *)key);
+	return 0;
+}
+
+static int crc32c_intel_init(struct ahash_request *req)
+{
+	u32 *mctx =3D crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	u32 *crcp =3D ahash_request_ctx(req);
+
+	*crcp =3D *mctx;
+
+	return 0;
+}
+
+static int crc32c_intel_update(struct ahash_request *req)
+{
+	struct crypto_hash_walk walk;
+	u32 *crcp =3D ahash_request_ctx(req);
+	u32 crc =3D *crcp;
+	int nbytes;
+
+	for (nbytes =3D crypto_hash_walk_first(req, &walk); nbytes;
+	   nbytes =3D crypto_hash_walk_done(&walk, 0))
+	crc =3D crc32c_intel_le_hw(crc, walk.data, nbytes);
+
+	*crcp =3D crc;
+	return 0;
+}
+
+static int crc32c_intel_final(struct ahash_request *req)
+{
+	u32 *crcp =3D ahash_request_ctx(req);
+
+	*(__le32 *)req->result =3D ~cpu_to_le32p(crcp);
+	return 0;
+}
+
+static int crc32c_intel_digest(struct ahash_request *req)
+{
+	struct crypto_hash_walk walk;
+	u32 *mctx =3D crypto_ahash_ctx(crypto_ahash_reqtfm(req));
+	u32 crc =3D *mctx;
+	int nbytes;
+
+	for (nbytes =3D crypto_hash_walk_first(req, &walk); nbytes;
+	   nbytes =3D crypto_hash_walk_done(&walk, 0))
+		crc =3D crc32c_intel_le_hw(crc, walk.data, nbytes);
+
+	*(__le32 *)req->result =3D ~cpu_to_le32(crc);
+	return 0;
+}
+
+static int crc32c_intel_cra_init(struct crypto_tfm *tfm)
+{
+	u32 *key =3D crypto_tfm_ctx(tfm);
+
+	*key =3D ~0;
+
+	tfm->crt_ahash.reqsize =3D sizeof(u32);
+
+	return 0;
+}
+
+static struct crypto_alg alg =3D {
+	.cra_name               =3D       "crc32c",
+	.cra_driver_name        =3D       "crc32c-intel",
+	.cra_priority           =3D       200,
+	.cra_flags              =3D       CRYPTO_ALG_TYPE_AHASH,
+	.cra_blocksize          =3D       CHKSUM_BLOCK_SIZE,
+	.cra_alignmask          =3D       3,
+	.cra_ctxsize            =3D       sizeof(u32),
+	.cra_module             =3D       THIS_MODULE,
+	.cra_list               =3D       LIST_HEAD_INIT(alg.cra_list),
+	.cra_init               =3D       crc32c_intel_cra_init,
+	.cra_type               =3D       &crypto_ahash_type,
+	.cra_u                  =3D       {
+		.ahash =3D {
+			.digestsize    =3D       CHKSUM_DIGEST_SIZE,
+			.setkey        =3D       crc32c_intel_setkey,
+			.init          =3D       crc32c_intel_init,
+			.update        =3D       crc32c_intel_update,
+			.final         =3D       crc32c_intel_final,
+			.digest        =3D       crc32c_intel_digest,
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
+MODULE_AUTHOR("Austin Zhang <austin.zhang@intel.com>, Kent Liu <kent.l=
iu@intel.com>");
+MODULE_DESCRIPTION("CRC32c (Castagnoli) optimization using Intel Hardw=
are.");
+MODULE_LICENSE("GPL");
+
+MODULE_ALIAS("crc32c");
+MODULE_ALIAS("crc32c-intel");
+
diff -Naurp linux-2.6/arch/x86/crypto/Makefile linux-2.6-patch/arch/x86=
/crypto/Makefile
--- linux-2.6/arch/x86/crypto/Makefile	2008-08-04 01:08:00.000000000 -0=
400
+++ linux-2.6-patch/arch/x86/crypto/Makefile	2008-08-05 21:56:14.000000=
000 -0400
@@ -10,6 +10,8 @@ obj-$(CONFIG_CRYPTO_AES_X86_64) +=3D aes-x
 obj-$(CONFIG_CRYPTO_TWOFISH_X86_64) +=3D twofish-x86_64.o
 obj-$(CONFIG_CRYPTO_SALSA20_X86_64) +=3D salsa20-x86_64.o
=20
+obj-$(CONFIG_CRYPTO_CRC32C_INTEL) +=3D crc32c-intel.o
+
 aes-i586-y :=3D aes-i586-asm_32.o aes_glue.o
 twofish-i586-y :=3D twofish-i586-asm_32.o twofish_glue.o
 salsa20-i586-y :=3D salsa20-i586-asm_32.o salsa20_glue.o
diff -Naurp linux-2.6/crypto/Kconfig linux-2.6-patch/crypto/Kconfig
--- linux-2.6/crypto/Kconfig	2008-08-04 01:08:00.000000000 -0400
+++ linux-2.6-patch/crypto/Kconfig	2008-08-05 21:56:14.000000000 -0400
@@ -221,6 +221,18 @@ config CRYPTO_CRC32C
 	  See Castagnoli93.  This implementation uses lib/libcrc32c.
           Module will be crc32c.
=20
+config CRYPTO_CRC32C_INTEL
+        tristate "CRC32c INTEL hardware acceleration"
+	depends on X86
+        select CRYPTO_ALGAPI
+        help
+          In Intel processor with SSE4.2 supported, the processor will
+          support CRC32C implementation using hardware accelerated CRC=
32
+          instruction. This option will create 'crc32c-intel' module,
+          which will enable any routine to use the CRC32 instruction t=
o
+          gain performance compared with software implementation.
+          Module will be crc32c-intel.
+
 config CRYPTO_MD4
 	tristate "MD4 digest algorithm"
 	select CRYPTO_ALGAPI
diff -Naurp linux-2.6/include/asm-x86/cpufeature.h linux-2.6-patch/incl=
ude/asm-x86/cpufeature.h
--- linux-2.6/include/asm-x86/cpufeature.h	2008-08-04 01:08:08.00000000=
0 -0400
+++ linux-2.6-patch/include/asm-x86/cpufeature.h	2008-08-05 21:56:14.00=
0000000 -0400
@@ -91,6 +91,7 @@
 #define X86_FEATURE_CX16	(4*32+13) /* CMPXCHG16B */
 #define X86_FEATURE_XTPR	(4*32+14) /* Send Task Priority Messages */
 #define X86_FEATURE_DCA		(4*32+18) /* Direct Cache Access */
+#define X86_FEATURE_XMM4_2	(4*32+20) /* Streaming SIMD Extensions-4.2 =
*/
=20
 /* VIA/Cyrix/Centaur-defined CPU features, CPUID level 0xC0000001, wor=
d 5 */
 #define X86_FEATURE_XSTORE	(5*32+ 2) /* on-CPU RNG present (xstore ins=
n) */
@@ -189,6 +190,7 @@ extern const char * const x86_power_flag
 #define cpu_has_gbpages		boot_cpu_has(X86_FEATURE_GBPAGES)
 #define cpu_has_arch_perfmon	boot_cpu_has(X86_FEATURE_ARCH_PERFMON)
 #define cpu_has_pat		boot_cpu_has(X86_FEATURE_PAT)
+#define cpu_has_xmm4_2		boot_cpu_has(X86_FEATURE_XMM4_2)
=20
 #if defined(CONFIG_X86_INVLPG) || defined(CONFIG_X86_64)
 # define cpu_has_invlpg		1


--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
