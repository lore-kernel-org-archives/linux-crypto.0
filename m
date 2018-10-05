From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 8/9] crypto: crc-t10dif/powerpc - move PMULL based code into core library
Date: Fri,  5 Oct 2018 10:13:32 +0200
Message-ID: <20181005081333.15018-9-ard.biesheuvel@linaro.org>
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
 arch/powerpc/crypto/crct10dif-vpmsum_glue.c | 55 +++-----------------
 1 file changed, 6 insertions(+), 49 deletions(-)

diff --git a/arch/powerpc/crypto/crct10dif-vpmsum_glue.c b/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
index 02ea277863d1..a4db7ecc0ccc 100644
--- a/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
+++ b/arch/powerpc/crypto/crct10dif-vpmsum_glue.c
@@ -11,8 +11,8 @@
  */
 
 #include <linux/crc-t10dif.h>
-#include <crypto/internal/hash.h>
 #include <linux/init.h>
+#include <linux/ffp.h>
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
@@ -63,59 +63,18 @@ static u16 crct10dif_vpmsum(u16 crci, unsigned char const *p, size_t len)
 	return crc & 0xffff;
 }
 
-static int crct10dif_vpmsum_init(struct shash_desc *desc)
-{
-	u16 *crc = shash_desc_ctx(desc);
-
-	*crc = 0;
-	return 0;
-}
-
-static int crct10dif_vpmsum_update(struct shash_desc *desc, const u8 *data,
-			    unsigned int length)
-{
-	u16 *crc = shash_desc_ctx(desc);
-
-	*crc = crct10dif_vpmsum(*crc, data, length);
-
-	return 0;
-}
-
-
-static int crct10dif_vpmsum_final(struct shash_desc *desc, u8 *out)
-{
-	u16 *crcp = shash_desc_ctx(desc);
-
-	*(u16 *)out = *crcp;
-	return 0;
-}
-
-static struct shash_alg alg = {
-	.init		= crct10dif_vpmsum_init,
-	.update		= crct10dif_vpmsum_update,
-	.final		= crct10dif_vpmsum_final,
-	.descsize	= CRC_T10DIF_DIGEST_SIZE,
-	.digestsize	= CRC_T10DIF_DIGEST_SIZE,
-	.base		= {
-		.cra_name		= "crct10dif",
-		.cra_driver_name	= "crct10dif-vpmsum",
-		.cra_priority		= 200,
-		.cra_blocksize		= CRC_T10DIF_BLOCK_SIZE,
-		.cra_module		= THIS_MODULE,
-	}
-};
-
 static int __init crct10dif_vpmsum_mod_init(void)
 {
-	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
-		return -ENODEV;
+	SET_FFP(crc_t10dif_update_arch, crct10dif_vpmsum);
 
-	return crypto_register_shash(&alg);
+	return 0;
 }
 
 static void __exit crct10dif_vpmsum_mod_fini(void)
 {
-	crypto_unregister_shash(&alg);
+	RESET_FFP(crc_t10dif_update_arch);
+	/* wait for all users to switch back to the old version */
+	synchronize_rcu();
 }
 
 module_cpu_feature_match(PPC_MODULE_FEATURE_VEC_CRYPTO, crct10dif_vpmsum_mod_init);
@@ -124,5 +83,3 @@ module_exit(crct10dif_vpmsum_mod_fini);
 MODULE_AUTHOR("Daniel Axtens <dja@axtens.net>");
 MODULE_DESCRIPTION("CRCT10DIF using vector polynomial multiply-sum instructions");
 MODULE_LICENSE("GPL");
-MODULE_ALIAS_CRYPTO("crct10dif");
-MODULE_ALIAS_CRYPTO("crct10dif-vpmsum");
-- 
2.11.0
