From: Anton Blanchard <anton@ozlabs.org>
Subject: [PATCH] crypto: crc32c-vpmsum - Convert to CPU feature based module autoloading
Date: Thu,  4 Aug 2016 16:38:15 +1000
Message-ID: <1470292695-9829-1-git-send-email-anton@ozlabs.org>
Cc: alastair@d-silva.org, linuxppc-dev@lists.ozlabs.org,
	linux-crypto@vger.kernel.org
To: benh@kernel.crashing.org, paulus@samba.org, mpe@ellerman.id.au,
	herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:48902 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbcHDGil (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Aug 2016 02:38:41 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Anton Blanchard <anton@samba.org>

This patch utilises the GENERIC_CPU_AUTOPROBE infrastructure
to automatically load the crc32c-vpmsum module if the CPU supports
it.

Signed-off-by: Anton Blanchard <anton@samba.org>
---
 arch/powerpc/crypto/crc32c-vpmsum_glue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/crypto/crc32c-vpmsum_glue.c b/arch/powerpc/crypto/crc32c-vpmsum_glue.c
index bfe3d37..9fa046d 100644
--- a/arch/powerpc/crypto/crc32c-vpmsum_glue.c
+++ b/arch/powerpc/crypto/crc32c-vpmsum_glue.c
@@ -4,6 +4,7 @@
 #include <linux/module.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
+#include <linux/cpufeature.h>
 #include <asm/switch_to.h>
 
 #define CHKSUM_BLOCK_SIZE	1
@@ -157,7 +158,7 @@ static void __exit crc32c_vpmsum_mod_fini(void)
 	crypto_unregister_shash(&alg);
 }
 
-module_init(crc32c_vpmsum_mod_init);
+module_cpu_feature_match(PPC_MODULE_FEATURE_VEC_CRYPTO, crc32c_vpmsum_mod_init);
 module_exit(crc32c_vpmsum_mod_fini);
 
 MODULE_AUTHOR("Anton Blanchard <anton@samba.org>");
-- 
2.7.4
