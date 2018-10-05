From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 5/9] crypto: crc-t10dif/arm64 - move PMULL based code into core library
Date: Fri,  5 Oct 2018 10:13:29 +0200
Message-ID: <20181005081333.15018-6-ard.biesheuvel@linaro.org>
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
 arch/arm64/crypto/crct10dif-ce-glue.c | 61 +++++---------------
 1 file changed, 14 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/crypto/crct10dif-ce-glue.c b/arch/arm64/crypto/crct10dif-ce-glue.c
index b461d62023f2..c67db86aba2c 100644
--- a/arch/arm64/crypto/crct10dif-ce-glue.c
+++ b/arch/arm64/crypto/crct10dif-ce-glue.c
@@ -10,13 +10,12 @@
 
 #include <linux/cpufeature.h>
 #include <linux/crc-t10dif.h>
+#include <linux/ffp.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/string.h>
 
-#include <crypto/internal/hash.h>
-
 #include <asm/neon.h>
 #include <asm/simd.h>
 
@@ -25,27 +24,17 @@
 asmlinkage u16 crc_t10dif_pmull_p64(u16 init_crc, const u8 buf[], u64 len);
 asmlinkage u16 crc_t10dif_pmull_p8(u16 init_crc, const u8 buf[], u64 len);
 
-static u16 (*crc_t10dif_pmull)(u16 init_crc, const u8 buf[], u64 len);
-
-static int crct10dif_init(struct shash_desc *desc)
-{
-	u16 *crc = shash_desc_ctx(desc);
-
-	*crc = 0;
-	return 0;
-}
+DEFINE_FFP(crc_t10dif_pmull, crc_t10dif_pmull_p8);
 
-static int crct10dif_update(struct shash_desc *desc, const u8 *data,
-			    unsigned int length)
+static __u16 crct10dif_update_arm64(u16 crc, const u8 *data, unsigned int length)
 {
-	u16 *crc = shash_desc_ctx(desc);
 	unsigned int l;
 
 	if (unlikely((u64)data % CRC_T10DIF_PMULL_CHUNK_SIZE)) {
 		l = min_t(u32, length, CRC_T10DIF_PMULL_CHUNK_SIZE -
 			  ((u64)data % CRC_T10DIF_PMULL_CHUNK_SIZE));
 
-		*crc = crc_t10dif_generic(*crc, data, l);
+		crc = crc_t10dif_generic(crc, data, l);
 
 		length -= l;
 		data += l;
@@ -54,51 +43,31 @@ static int crct10dif_update(struct shash_desc *desc, const u8 *data,
 	if (length > 0) {
 		if (may_use_simd()) {
 			kernel_neon_begin();
-			*crc = crc_t10dif_pmull(*crc, data, length);
+			crc = crc_t10dif_pmull(crc, data, length);
 			kernel_neon_end();
 		} else {
-			*crc = crc_t10dif_generic(*crc, data, length);
+			crc = crc_t10dif_generic(crc, data, length);
 		}
 	}
 
-	return 0;
-}
-
-static int crct10dif_final(struct shash_desc *desc, u8 *out)
-{
-	u16 *crc = shash_desc_ctx(desc);
-
-	*(u16 *)out = *crc;
-	return 0;
+	return crc;
 }
 
-static struct shash_alg crc_t10dif_alg = {
-	.digestsize		= CRC_T10DIF_DIGEST_SIZE,
-	.init			= crct10dif_init,
-	.update			= crct10dif_update,
-	.final			= crct10dif_final,
-	.descsize		= CRC_T10DIF_DIGEST_SIZE,
-
-	.base.cra_name		= "crct10dif",
-	.base.cra_driver_name	= "crct10dif-arm64-ce",
-	.base.cra_priority	= 200,
-	.base.cra_blocksize	= CRC_T10DIF_BLOCK_SIZE,
-	.base.cra_module	= THIS_MODULE,
-};
-
 static int __init crc_t10dif_mod_init(void)
 {
 	if (elf_hwcap & HWCAP_PMULL)
-		crc_t10dif_pmull = crc_t10dif_pmull_p64;
-	else
-		crc_t10dif_pmull = crc_t10dif_pmull_p8;
+		SET_FFP(crc_t10dif_pmull, crc_t10dif_pmull_p64);
 
-	return crypto_register_shash(&crc_t10dif_alg);
+	SET_FFP(crc_t10dif_update_arch, crct10dif_update_arm64);
+
+	return 0;
 }
 
 static void __exit crc_t10dif_mod_exit(void)
 {
-	crypto_unregister_shash(&crc_t10dif_alg);
+	RESET_FFP(crc_t10dif_update_arch);
+	/* wait for all users to switch back to the old version */
+	synchronize_rcu();
 }
 
 module_cpu_feature_match(ASIMD, crc_t10dif_mod_init);
@@ -106,5 +75,3 @@ module_exit(crc_t10dif_mod_exit);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
 MODULE_LICENSE("GPL v2");
-MODULE_ALIAS_CRYPTO("crct10dif");
-MODULE_ALIAS_CRYPTO("crct10dif-arm64-ce");
-- 
2.11.0
