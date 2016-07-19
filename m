From: alastair@au1.ibm.com
Subject: [PATCH V2 2/2] crypto: vmx - Convert to CPU feature based module autoloading
Date: Tue, 19 Jul 2016 14:03:53 +1000
Message-ID: <1468901033-28996-3-git-send-email-alastair@au1.ibm.com>
References: <1468901033-28996-1-git-send-email-alastair@au1.ibm.com>
Cc: benh@kernel.crashing.org, paulus@samba.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Alastair D'Silva" <alastair@d-silva.org>
To: mpe@ellerman.id.au
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1468901033-28996-1-git-send-email-alastair@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Alastair D'Silva <alastair@d-silva.org>

This patch utilises the GENERIC_CPU_AUTOPROBE infrastructure
to automatically load the vmx_crypto module if the CPU supports
it.

Signed-off-by: Alastair D'Silva <alastair@d-silva.org>
---
 drivers/crypto/vmx/Kconfig | 2 +-
 drivers/crypto/vmx/vmx.c   | 6 ++----
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/vmx/Kconfig b/drivers/crypto/vmx/Kconfig
index 89d8208..a83ead1 100644
--- a/drivers/crypto/vmx/Kconfig
+++ b/drivers/crypto/vmx/Kconfig
@@ -1,7 +1,7 @@
 config CRYPTO_DEV_VMX_ENCRYPT
 	tristate "Encryption acceleration support on P8 CPU"
 	depends on CRYPTO_DEV_VMX
-	default y
+	default m
 	help
 	  Support for VMX cryptographic acceleration instructions on Power8 CPU.
 	  This module supports acceleration for AES and GHASH in hardware. If you
diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
index e163d57..5a40f2f 100644
--- a/drivers/crypto/vmx/vmx.c
+++ b/drivers/crypto/vmx/vmx.c
@@ -23,6 +23,7 @@
 #include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/err.h>
+#include <linux/cpufeature.h>
 #include <linux/crypto.h>
 #include <asm/cputable.h>
 #include <crypto/internal/hash.h>
@@ -43,9 +44,6 @@ int __init p8_init(void)
 	int ret = 0;
 	struct crypto_alg **alg_it;
 
-	if (!(cur_cpu_spec->cpu_user_features2 & PPC_FEATURE2_VEC_CRYPTO))
-		return -ENODEV;
-
 	for (alg_it = algs; *alg_it; alg_it++) {
 		ret = crypto_register_alg(*alg_it);
 		printk(KERN_INFO "crypto_register_alg '%s' = %d\n",
@@ -78,7 +76,7 @@ void __exit p8_exit(void)
 	crypto_unregister_shash(&p8_ghash_alg);
 }
 
-module_init(p8_init);
+module_cpu_feature_match(PPC_MODULE_FEATURE_VEC_CRYPTO, p8_init);
 module_exit(p8_exit);
 
 MODULE_AUTHOR("Marcelo Cerri<mhcerri@br.ibm.com>");
-- 
2.7.4

V2: No change
