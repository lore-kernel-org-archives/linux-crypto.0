From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 9/9] crypto: crc-t10dif/x86 - move PMULL based code into core library
Date: Fri,  5 Oct 2018 10:13:33 +0200
Message-ID: <20181005081333.15018-10-ard.biesheuvel@linaro.org>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andy Lutomirski <luto@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Move the PMULL based routines out of the crypto API into the core
CRC-T10DIF library.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/x86/crypto/crct10dif-pclmul_glue.c | 98 +++-----------------
 1 file changed, 13 insertions(+), 85 deletions(-)

diff --git a/arch/x86/crypto/crct10dif-pclmul_glue.c b/arch/x86/crypto/crct10dif-pclmul_glue.c
index cd4df9322501..47f0017ad7f3 100644
--- a/arch/x86/crypto/crct10dif-pclmul_glue.c
+++ b/arch/x86/crypto/crct10dif-pclmul_glue.c
@@ -25,7 +25,7 @@
 #include <linux/types.h>
 #include <linux/module.h>
 #include <linux/crc-t10dif.h>
-#include <crypto/internal/hash.h>
+#include <linux/ffp.h>
 #include <linux/init.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
@@ -36,90 +36,17 @@
 asmlinkage __u16 crc_t10dif_pcl(__u16 crc, const unsigned char *buf,
 				size_t len);
 
-struct chksum_desc_ctx {
-	__u16 crc;
-};
-
-/*
- * Steps through buffer one byte at at time, calculates reflected
- * crc using table.
- */
-
-static int chksum_init(struct shash_desc *desc)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	ctx->crc = 0;
-
-	return 0;
-}
-
-static int chksum_update(struct shash_desc *desc, const u8 *data,
-			 unsigned int length)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	if (irq_fpu_usable()) {
-		kernel_fpu_begin();
-		ctx->crc = crc_t10dif_pcl(ctx->crc, data, length);
-		kernel_fpu_end();
-	} else
-		ctx->crc = crc_t10dif_generic(ctx->crc, data, length);
-	return 0;
-}
-
-static int chksum_final(struct shash_desc *desc, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	*(__u16 *)out = ctx->crc;
-	return 0;
-}
-
-static int __chksum_finup(__u16 *crcp, const u8 *data, unsigned int len,
-			u8 *out)
+static __u16 crct10dif_update_x86(__u16 crc, const u8 *data, unsigned int length)
 {
 	if (irq_fpu_usable()) {
 		kernel_fpu_begin();
-		*(__u16 *)out = crc_t10dif_pcl(*crcp, data, len);
+		crc = crc_t10dif_pcl(crc, data, length);
 		kernel_fpu_end();
-	} else
-		*(__u16 *)out = crc_t10dif_generic(*crcp, data, len);
-	return 0;
-}
-
-static int chksum_finup(struct shash_desc *desc, const u8 *data,
-			unsigned int len, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup(&ctx->crc, data, len, out);
-}
-
-static int chksum_digest(struct shash_desc *desc, const u8 *data,
-			 unsigned int length, u8 *out)
-{
-	struct chksum_desc_ctx *ctx = shash_desc_ctx(desc);
-
-	return __chksum_finup(&ctx->crc, data, length, out);
-}
-
-static struct shash_alg alg = {
-	.digestsize		=	CRC_T10DIF_DIGEST_SIZE,
-	.init		=	chksum_init,
-	.update		=	chksum_update,
-	.final		=	chksum_final,
-	.finup		=	chksum_finup,
-	.digest		=	chksum_digest,
-	.descsize		=	sizeof(struct chksum_desc_ctx),
-	.base			=	{
-		.cra_name		=	"crct10dif",
-		.cra_driver_name	=	"crct10dif-pclmul",
-		.cra_priority		=	200,
-		.cra_blocksize		=	CRC_T10DIF_BLOCK_SIZE,
-		.cra_module		=	THIS_MODULE,
+	} else {
+		crc = crc_t10dif_generic(crc, data, length);
 	}
-};
+	return crc;
+}
 
 static const struct x86_cpu_id crct10dif_cpu_id[] = {
 	X86_FEATURE_MATCH(X86_FEATURE_PCLMULQDQ),
@@ -132,12 +59,16 @@ static int __init crct10dif_intel_mod_init(void)
 	if (!x86_match_cpu(crct10dif_cpu_id))
 		return -ENODEV;
 
-	return crypto_register_shash(&alg);
+	SET_FFP(crc_t10dif_update_arch, crct10dif_update_x86);
+
+	return 0;
 }
 
 static void __exit crct10dif_intel_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	RESET_FFP(crc_t10dif_update_arch);
+	/* wait for all users to switch back to the old version */
+	synchronize_rcu();
 }
 
 module_init(crct10dif_intel_mod_init);
@@ -146,6 +77,3 @@ module_exit(crct10dif_intel_mod_fini);
 MODULE_AUTHOR("Tim Chen <tim.c.chen@linux.intel.com>");
 MODULE_DESCRIPTION("T10 DIF CRC calculation accelerated with PCLMULQDQ.");
 MODULE_LICENSE("GPL");
-
-MODULE_ALIAS_CRYPTO("crct10dif");
-MODULE_ALIAS_CRYPTO("crct10dif-pclmul");
-- 
2.11.0
