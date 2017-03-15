From: Daniel Axtens <dja@axtens.net>
Subject: [PATCH 4/4] crypto: powerpc - Stress test for vpmsum implementations
Date: Wed, 15 Mar 2017 23:37:37 +1100
Message-ID: <20170315123737.20234-4-dja@axtens.net>
References: <20170315123737.20234-1-dja@axtens.net>
Cc: anton@samba.org, Daniel Axtens <dja@axtens.net>
To: linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36626 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbdCOMih (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Mar 2017 08:38:37 -0400
Received: by mail-io0-f196.google.com with SMTP id 68so2825882ioh.3
        for <linux-crypto@vger.kernel.org>; Wed, 15 Mar 2017 05:38:36 -0700 (PDT)
In-Reply-To: <20170315123737.20234-1-dja@axtens.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

vpmsum implementations often don't kick in for short test vectors.
This is a simple test module that does a configurable number of
random tests, each up to 64kB and each with random offsets.

Both CRC-T10DIF and CRC32C are tested.

Cc: Anton Blanchard <anton@samba.org>
Signed-off-by: Daniel Axtens <dja@axtens.net>

--

Not super fussy about the inclusion or otherwise of this - it was very
useful for debugging my code, and more tests are good :)

Also, I originally found the bug in Anton's CRC32c using this.

Tests pass on both BE 64 bit and LE 64 bit.
---
 arch/powerpc/crypto/Makefile          |   1 +
 arch/powerpc/crypto/crc-vpmsum_test.c | 137 ++++++++++++++++++++++++++++++++++
 crypto/Kconfig                        |   8 ++
 3 files changed, 146 insertions(+)
 create mode 100644 arch/powerpc/crypto/crc-vpmsum_test.c

diff --git a/arch/powerpc/crypto/Makefile b/arch/powerpc/crypto/Makefile
index e66aaf19764d..67eca3af9fc7 100644
--- a/arch/powerpc/crypto/Makefile
+++ b/arch/powerpc/crypto/Makefile
@@ -11,6 +11,7 @@ obj-$(CONFIG_CRYPTO_SHA1_PPC_SPE) += sha1-ppc-spe.o
 obj-$(CONFIG_CRYPTO_SHA256_PPC_SPE) += sha256-ppc-spe.o
 obj-$(CONFIG_CRYPTO_CRC32C_VPMSUM) += crc32c-vpmsum.o
 obj-$(CONFIG_CRYPTO_CRCT10DIF_VPMSUM) += crct10dif-vpmsum.o
+obj-$(CONFIG_CRYPTO_VPMSUM_TESTER) += crc-vpmsum_test.o
 
 aes-ppc-spe-y := aes-spe-core.o aes-spe-keys.o aes-tab-4k.o aes-spe-modes.o aes-spe-glue.o
 md5-ppc-y := md5-asm.o md5-glue.o
diff --git a/arch/powerpc/crypto/crc-vpmsum_test.c b/arch/powerpc/crypto/crc-vpmsum_test.c
new file mode 100644
index 000000000000..d58242557f33
--- /dev/null
+++ b/arch/powerpc/crypto/crc-vpmsum_test.c
@@ -0,0 +1,137 @@
+/*
+ * CRC vpmsum tester
+ * Copyright 2017 Daniel Axtens, IBM Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/crc-t10dif.h>
+#include <linux/crc32.h>
+#include <crypto/internal/hash.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/cpufeature.h>
+#include <asm/switch_to.h>
+
+static unsigned long iterations = 10000;
+
+#define MAX_CRC_LENGTH 65535
+
+
+static int __init crc_test_init(void)
+{
+	u16 crc16 = 0, verify16 = 0;
+	u32 crc32 = 0, verify32 = 0;
+	__le32 verify32le = 0;
+	unsigned char *data;
+	unsigned long i;
+	int ret;
+
+	struct crypto_shash *crct10dif_tfm;
+	struct crypto_shash *crc32c_tfm;
+	
+	if (!cpu_has_feature(CPU_FTR_ARCH_207S))
+		return -ENODEV;
+	
+	data = kmalloc(MAX_CRC_LENGTH, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
+
+	if (IS_ERR(crct10dif_tfm)) {
+		pr_err("Error allocating crc-t10dif\n");
+		goto free_buf;
+	}
+
+	crc32c_tfm = crypto_alloc_shash("crc32c", 0, 0);
+
+	if (IS_ERR(crc32c_tfm)) {
+		pr_err("Error allocating crc32c\n");
+		goto free_16;
+	}
+
+	do {
+		SHASH_DESC_ON_STACK(crct10dif_shash, crct10dif_tfm);
+		SHASH_DESC_ON_STACK(crc32c_shash, crc32c_tfm);
+
+		crct10dif_shash->tfm = crct10dif_tfm;
+		ret = crypto_shash_init(crct10dif_shash);
+
+		if (ret) {
+			pr_err("Error initing crc-t10dif\n");
+			goto free_32;
+		}
+	
+
+		crc32c_shash->tfm = crc32c_tfm;
+		ret = crypto_shash_init(crc32c_shash);
+
+		if (ret) {
+			pr_err("Error initing crc32c\n");
+			goto free_32;
+		}
+	
+		pr_info("crc-vpmsum_test begins, %lu iterations\n", iterations);
+		for (i=0; i<iterations; i++) {
+			size_t len, offset;
+
+			get_random_bytes(data, MAX_CRC_LENGTH);
+			get_random_bytes(&len, sizeof(len));
+			get_random_bytes(&offset, sizeof(offset));
+			
+			len %= MAX_CRC_LENGTH;
+			offset &= 15;
+			if (len <= offset)
+				continue;
+			len -= offset;
+		
+			crypto_shash_update(crct10dif_shash, data+offset, len);
+			crypto_shash_final(crct10dif_shash, (u8 *)(&crc16));
+			verify16 = crc_t10dif_generic(verify16, data+offset, len);
+
+		
+			if (crc16 != verify16) {
+				pr_err("FAILURE in CRC16: got 0x%04x expected 0x%04x (len %lu)\n",
+				       crc16, verify16, len);
+				break;
+			}
+
+			crypto_shash_update(crc32c_shash, data+offset, len);
+			crypto_shash_final(crc32c_shash, (u8 *)(&crc32));
+			verify32 = le32_to_cpu(verify32le);
+		        verify32le = ~cpu_to_le32(__crc32c_le(~verify32, data+offset, len));
+			if (crc32 != (u32)verify32le) {
+				pr_err("FAILURE in CRC32: got 0x%08x expected 0x%08x (len %lu)\n",
+				       crc32, verify32, len);
+				break;
+			}
+		}
+		pr_info("crc-vpmsum_test done, completed %lu iterations\n", i);
+	} while (0);
+
+free_32:
+	crypto_free_shash(crc32c_tfm);
+
+free_16:
+	crypto_free_shash(crct10dif_tfm);
+	
+free_buf:
+	kfree(data);
+	
+	return 0;
+}
+
+static void __exit crc_test_exit(void) {}
+
+module_init(crc_test_init);
+module_exit(crc_test_exit);
+module_param(iterations, long, 0400);
+
+MODULE_AUTHOR("Daniel Axtens <dja@axtens.net>");
+MODULE_DESCRIPTION("Vector polynomial multiply-sum CRC tester");
+MODULE_LICENSE("GPL");
diff --git a/crypto/Kconfig b/crypto/Kconfig
index 9cf63dd84364..6854c1fe54b7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -522,6 +522,14 @@ config CRYPTO_CRCT10DIF_VPMSUM
 	  multiply-sum (vpmsum) instructions, introduced in POWER8. Enable on
 	  POWER8 and newer processors for improved performance.
 
+config CRYPTO_VPMSUM_TESTER
+	tristate "Powerpc64 vpmsum hardware acceleration tester"
+	depends on CRYPTO_CRCT10DIF_VPMSUM && CRYPTO_CRC32C_VPMSUM
+	help
+	  Stress test for CRC32c and CRC-T10DIF algorithms implemented with
+	  POWER8 vpmsum instructions.
+	  Unless you are testing these algorithms, you don't need this.
+
 config CRYPTO_GHASH
 	tristate "GHASH digest algorithm"
 	select CRYPTO_GF128MUL
-- 
2.9.3
