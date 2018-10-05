From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 4/9] crypto: crc-t10dif - use patchable function pointer for core update routine
Date: Fri,  5 Oct 2018 10:13:28 +0200
Message-ID: <20181005081333.15018-5-ard.biesheuvel@linaro.org>
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

Use a patchable function pointer for the core CRC-T10DIF transform so
that we can allow modules to supersede this transform based on platform
capabilities.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/Kconfig             |   1 +
 crypto/Makefile            |   2 +-
 crypto/crct10dif_common.c  |  82 -----------
 include/linux/crc-t10dif.h |  18 ++-
 lib/Kconfig                |   2 -
 lib/crc-t10dif.c           | 143 +++++++-------------
 6 files changed, 69 insertions(+), 179 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 63ef279322d2..009c736a082e 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -611,6 +611,7 @@ config CRYPTO_CRC32_MIPS
 config CRYPTO_CRCT10DIF
 	tristate "CRCT10DIF algorithm"
 	select CRYPTO_HASH
+	select CRCT10DIF
 	help
 	  CRC T10 Data Integrity Field computation is being cast as
 	  a crypto transform.  This allows for faster crc t10 diff
diff --git a/crypto/Makefile b/crypto/Makefile
index 5c207c76abf7..0c2491a5a657 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -122,7 +122,7 @@ obj-$(CONFIG_CRYPTO_DEFLATE) += deflate.o
 obj-$(CONFIG_CRYPTO_MICHAEL_MIC) += michael_mic.o
 obj-$(CONFIG_CRYPTO_CRC32C) += crc32c_generic.o
 obj-$(CONFIG_CRYPTO_CRC32) += crc32_generic.o
-obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_common.o crct10dif_generic.o
+obj-$(CONFIG_CRYPTO_CRCT10DIF) += crct10dif_generic.o
 obj-$(CONFIG_CRYPTO_AUTHENC) += authenc.o authencesn.o
 obj-$(CONFIG_CRYPTO_LZO) += lzo.o
 obj-$(CONFIG_CRYPTO_LZ4) += lz4.o
diff --git a/crypto/crct10dif_common.c b/crypto/crct10dif_common.c
deleted file mode 100644
index b2fab366f518..000000000000
--- a/crypto/crct10dif_common.c
+++ /dev/null
@@ -1,82 +0,0 @@
-/*
- * Cryptographic API.
- *
- * T10 Data Integrity Field CRC16 Crypto Transform
- *
- * Copyright (c) 2007 Oracle Corporation.  All rights reserved.
- * Written by Martin K. Petersen <martin.petersen@oracle.com>
- * Copyright (C) 2013 Intel Corporation
- * Author: Tim Chen <tim.c.chen@linux.intel.com>
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
- * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
- * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
- * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
- * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
- * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
- * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
- * SOFTWARE.
- *
- */
-
-#include <linux/crc-t10dif.h>
-#include <linux/module.h>
-#include <linux/kernel.h>
-
-/* Table generated using the following polynomium:
- * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
- * gt: 0x8bb7
- */
-static const __u16 t10_dif_crc_table[256] = {
-	0x0000, 0x8BB7, 0x9CD9, 0x176E, 0xB205, 0x39B2, 0x2EDC, 0xA56B,
-	0xEFBD, 0x640A, 0x7364, 0xF8D3, 0x5DB8, 0xD60F, 0xC161, 0x4AD6,
-	0x54CD, 0xDF7A, 0xC814, 0x43A3, 0xE6C8, 0x6D7F, 0x7A11, 0xF1A6,
-	0xBB70, 0x30C7, 0x27A9, 0xAC1E, 0x0975, 0x82C2, 0x95AC, 0x1E1B,
-	0xA99A, 0x222D, 0x3543, 0xBEF4, 0x1B9F, 0x9028, 0x8746, 0x0CF1,
-	0x4627, 0xCD90, 0xDAFE, 0x5149, 0xF422, 0x7F95, 0x68FB, 0xE34C,
-	0xFD57, 0x76E0, 0x618E, 0xEA39, 0x4F52, 0xC4E5, 0xD38B, 0x583C,
-	0x12EA, 0x995D, 0x8E33, 0x0584, 0xA0EF, 0x2B58, 0x3C36, 0xB781,
-	0xD883, 0x5334, 0x445A, 0xCFED, 0x6A86, 0xE131, 0xF65F, 0x7DE8,
-	0x373E, 0xBC89, 0xABE7, 0x2050, 0x853B, 0x0E8C, 0x19E2, 0x9255,
-	0x8C4E, 0x07F9, 0x1097, 0x9B20, 0x3E4B, 0xB5FC, 0xA292, 0x2925,
-	0x63F3, 0xE844, 0xFF2A, 0x749D, 0xD1F6, 0x5A41, 0x4D2F, 0xC698,
-	0x7119, 0xFAAE, 0xEDC0, 0x6677, 0xC31C, 0x48AB, 0x5FC5, 0xD472,
-	0x9EA4, 0x1513, 0x027D, 0x89CA, 0x2CA1, 0xA716, 0xB078, 0x3BCF,
-	0x25D4, 0xAE63, 0xB90D, 0x32BA, 0x97D1, 0x1C66, 0x0B08, 0x80BF,
-	0xCA69, 0x41DE, 0x56B0, 0xDD07, 0x786C, 0xF3DB, 0xE4B5, 0x6F02,
-	0x3AB1, 0xB106, 0xA668, 0x2DDF, 0x88B4, 0x0303, 0x146D, 0x9FDA,
-	0xD50C, 0x5EBB, 0x49D5, 0xC262, 0x6709, 0xECBE, 0xFBD0, 0x7067,
-	0x6E7C, 0xE5CB, 0xF2A5, 0x7912, 0xDC79, 0x57CE, 0x40A0, 0xCB17,
-	0x81C1, 0x0A76, 0x1D18, 0x96AF, 0x33C4, 0xB873, 0xAF1D, 0x24AA,
-	0x932B, 0x189C, 0x0FF2, 0x8445, 0x212E, 0xAA99, 0xBDF7, 0x3640,
-	0x7C96, 0xF721, 0xE04F, 0x6BF8, 0xCE93, 0x4524, 0x524A, 0xD9FD,
-	0xC7E6, 0x4C51, 0x5B3F, 0xD088, 0x75E3, 0xFE54, 0xE93A, 0x628D,
-	0x285B, 0xA3EC, 0xB482, 0x3F35, 0x9A5E, 0x11E9, 0x0687, 0x8D30,
-	0xE232, 0x6985, 0x7EEB, 0xF55C, 0x5037, 0xDB80, 0xCCEE, 0x4759,
-	0x0D8F, 0x8638, 0x9156, 0x1AE1, 0xBF8A, 0x343D, 0x2353, 0xA8E4,
-	0xB6FF, 0x3D48, 0x2A26, 0xA191, 0x04FA, 0x8F4D, 0x9823, 0x1394,
-	0x5942, 0xD2F5, 0xC59B, 0x4E2C, 0xEB47, 0x60F0, 0x779E, 0xFC29,
-	0x4BA8, 0xC01F, 0xD771, 0x5CC6, 0xF9AD, 0x721A, 0x6574, 0xEEC3,
-	0xA415, 0x2FA2, 0x38CC, 0xB37B, 0x1610, 0x9DA7, 0x8AC9, 0x017E,
-	0x1F65, 0x94D2, 0x83BC, 0x080B, 0xAD60, 0x26D7, 0x31B9, 0xBA0E,
-	0xF0D8, 0x7B6F, 0x6C01, 0xE7B6, 0x42DD, 0xC96A, 0xDE04, 0x55B3
-};
-
-__u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len)
-{
-	unsigned int i;
-
-	for (i = 0 ; i < len ; i++)
-		crc = (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff];
-
-	return crc;
-}
-EXPORT_SYMBOL(crc_t10dif_generic);
-
-MODULE_DESCRIPTION("T10 DIF CRC calculation common code");
-MODULE_LICENSE("GPL");
diff --git a/include/linux/crc-t10dif.h b/include/linux/crc-t10dif.h
index 4dfe09ff4cf2..ae4f46723f5d 100644
--- a/include/linux/crc-t10dif.h
+++ b/include/linux/crc-t10dif.h
@@ -3,14 +3,28 @@
 #define _LINUX_CRC_T10DIF_H
 
 #include <linux/types.h>
+#include <linux/ffp.h>
+#include <linux/rcupdate.h>
 
 #define CRC_T10DIF_DIGEST_SIZE 2
 #define CRC_T10DIF_BLOCK_SIZE 1
-#define CRC_T10DIF_STRING "crct10dif"
 
 extern __u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer,
 				size_t len);
-extern __u16 crc_t10dif_update(__u16 crc, unsigned char const *, size_t);
+
+DECLARE_FFP(crc_t10dif_update_arch, crc_t10dif_generic);
+
+static inline __u16 crc_t10dif_update(__u16 crc, unsigned char const *buffer,
+				      size_t len)
+{
+	__u16 ret;
+
+	rcu_read_lock();
+	ret = crc_t10dif_update_arch(crc, buffer, len);
+	rcu_read_unlock();
+
+	return ret;
+}
 
 static inline __u16 crc_t10dif(const unsigned char *buffer, size_t len)
 {
diff --git a/lib/Kconfig b/lib/Kconfig
index a3928d4438b5..01a8a8daf08f 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -89,8 +89,6 @@ config CRC16
 
 config CRC_T10DIF
 	tristate "CRC calculation for the T10 Data Integrity Field"
-	select CRYPTO
-	select CRYPTO_CRCT10DIF
 	help
 	  This option is only needed if a module that's not in the
 	  kernel tree needs to calculate CRC checks for use with the
diff --git a/lib/crc-t10dif.c b/lib/crc-t10dif.c
index 036ee664c9e1..54dd4b7a763c 100644
--- a/lib/crc-t10dif.c
+++ b/lib/crc-t10dif.c
@@ -3,9 +3,13 @@
  *
  * Copyright (c) 2007 Oracle Corporation.  All rights reserved.
  * Written by Martin K. Petersen <martin.petersen@oracle.com>
+ * Copyright (C) 2013 Intel Corporation
+ * Author: Tim Chen <tim.c.chen@linux.intel.com>
  *
- * This source code is licensed under the GNU General Public License,
- * Version 2. See the file COPYING for more details.
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
  */
 
 #include <linux/types.h>
@@ -13,104 +17,59 @@
 #include <linux/crc-t10dif.h>
 #include <linux/err.h>
 #include <linux/init.h>
-#include <crypto/hash.h>
-#include <crypto/algapi.h>
-#include <linux/static_key.h>
-#include <linux/notifier.h>
 
-static struct crypto_shash __rcu *crct10dif_tfm;
-static struct static_key crct10dif_fallback __read_mostly;
-static DEFINE_MUTEX(crc_t10dif_mutex);
-
-static int crc_t10dif_rehash(struct notifier_block *self, unsigned long val, void *data)
-{
-	struct crypto_alg *alg = data;
-	struct crypto_shash *new, *old;
-
-	if (val != CRYPTO_MSG_ALG_LOADED ||
-	    static_key_false(&crct10dif_fallback) ||
-	    strncmp(alg->cra_name, CRC_T10DIF_STRING, strlen(CRC_T10DIF_STRING)))
-		return 0;
-
-	mutex_lock(&crc_t10dif_mutex);
-	old = rcu_dereference_protected(crct10dif_tfm,
-					lockdep_is_held(&crc_t10dif_mutex));
-	if (!old) {
-		mutex_unlock(&crc_t10dif_mutex);
-		return 0;
-	}
-	new = crypto_alloc_shash("crct10dif", 0, 0);
-	if (IS_ERR(new)) {
-		mutex_unlock(&crc_t10dif_mutex);
-		return 0;
-	}
-	rcu_assign_pointer(crct10dif_tfm, new);
-	mutex_unlock(&crc_t10dif_mutex);
-
-	synchronize_rcu();
-	crypto_free_shash(old);
-	return 0;
-}
-
-static struct notifier_block crc_t10dif_nb = {
-	.notifier_call = crc_t10dif_rehash,
+/* Table generated using the following polynomium:
+ * x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
+ * gt: 0x8bb7
+ */
+static const __u16 t10_dif_crc_table[256] __cacheline_aligned = {
+	0x0000, 0x8BB7, 0x9CD9, 0x176E, 0xB205, 0x39B2, 0x2EDC, 0xA56B,
+	0xEFBD, 0x640A, 0x7364, 0xF8D3, 0x5DB8, 0xD60F, 0xC161, 0x4AD6,
+	0x54CD, 0xDF7A, 0xC814, 0x43A3, 0xE6C8, 0x6D7F, 0x7A11, 0xF1A6,
+	0xBB70, 0x30C7, 0x27A9, 0xAC1E, 0x0975, 0x82C2, 0x95AC, 0x1E1B,
+	0xA99A, 0x222D, 0x3543, 0xBEF4, 0x1B9F, 0x9028, 0x8746, 0x0CF1,
+	0x4627, 0xCD90, 0xDAFE, 0x5149, 0xF422, 0x7F95, 0x68FB, 0xE34C,
+	0xFD57, 0x76E0, 0x618E, 0xEA39, 0x4F52, 0xC4E5, 0xD38B, 0x583C,
+	0x12EA, 0x995D, 0x8E33, 0x0584, 0xA0EF, 0x2B58, 0x3C36, 0xB781,
+	0xD883, 0x5334, 0x445A, 0xCFED, 0x6A86, 0xE131, 0xF65F, 0x7DE8,
+	0x373E, 0xBC89, 0xABE7, 0x2050, 0x853B, 0x0E8C, 0x19E2, 0x9255,
+	0x8C4E, 0x07F9, 0x1097, 0x9B20, 0x3E4B, 0xB5FC, 0xA292, 0x2925,
+	0x63F3, 0xE844, 0xFF2A, 0x749D, 0xD1F6, 0x5A41, 0x4D2F, 0xC698,
+	0x7119, 0xFAAE, 0xEDC0, 0x6677, 0xC31C, 0x48AB, 0x5FC5, 0xD472,
+	0x9EA4, 0x1513, 0x027D, 0x89CA, 0x2CA1, 0xA716, 0xB078, 0x3BCF,
+	0x25D4, 0xAE63, 0xB90D, 0x32BA, 0x97D1, 0x1C66, 0x0B08, 0x80BF,
+	0xCA69, 0x41DE, 0x56B0, 0xDD07, 0x786C, 0xF3DB, 0xE4B5, 0x6F02,
+	0x3AB1, 0xB106, 0xA668, 0x2DDF, 0x88B4, 0x0303, 0x146D, 0x9FDA,
+	0xD50C, 0x5EBB, 0x49D5, 0xC262, 0x6709, 0xECBE, 0xFBD0, 0x7067,
+	0x6E7C, 0xE5CB, 0xF2A5, 0x7912, 0xDC79, 0x57CE, 0x40A0, 0xCB17,
+	0x81C1, 0x0A76, 0x1D18, 0x96AF, 0x33C4, 0xB873, 0xAF1D, 0x24AA,
+	0x932B, 0x189C, 0x0FF2, 0x8445, 0x212E, 0xAA99, 0xBDF7, 0x3640,
+	0x7C96, 0xF721, 0xE04F, 0x6BF8, 0xCE93, 0x4524, 0x524A, 0xD9FD,
+	0xC7E6, 0x4C51, 0x5B3F, 0xD088, 0x75E3, 0xFE54, 0xE93A, 0x628D,
+	0x285B, 0xA3EC, 0xB482, 0x3F35, 0x9A5E, 0x11E9, 0x0687, 0x8D30,
+	0xE232, 0x6985, 0x7EEB, 0xF55C, 0x5037, 0xDB80, 0xCCEE, 0x4759,
+	0x0D8F, 0x8638, 0x9156, 0x1AE1, 0xBF8A, 0x343D, 0x2353, 0xA8E4,
+	0xB6FF, 0x3D48, 0x2A26, 0xA191, 0x04FA, 0x8F4D, 0x9823, 0x1394,
+	0x5942, 0xD2F5, 0xC59B, 0x4E2C, 0xEB47, 0x60F0, 0x779E, 0xFC29,
+	0x4BA8, 0xC01F, 0xD771, 0x5CC6, 0xF9AD, 0x721A, 0x6574, 0xEEC3,
+	0xA415, 0x2FA2, 0x38CC, 0xB37B, 0x1610, 0x9DA7, 0x8AC9, 0x017E,
+	0x1F65, 0x94D2, 0x83BC, 0x080B, 0xAD60, 0x26D7, 0x31B9, 0xBA0E,
+	0xF0D8, 0x7B6F, 0x6C01, 0xE7B6, 0x42DD, 0xC96A, 0xDE04, 0x55B3
 };
 
-__u16 crc_t10dif_update(__u16 crc, const unsigned char *buffer, size_t len)
-{
-	struct {
-		struct shash_desc shash;
-		char ctx[2];
-	} desc;
-	int err;
-
-	if (static_key_false(&crct10dif_fallback))
-		return crc_t10dif_generic(crc, buffer, len);
-
-	rcu_read_lock();
-	desc.shash.tfm = rcu_dereference(crct10dif_tfm);
-	desc.shash.flags = 0;
-	*(__u16 *)desc.ctx = crc;
-
-	err = crypto_shash_update(&desc.shash, buffer, len);
-	rcu_read_unlock();
-
-	BUG_ON(err);
-
-	return *(__u16 *)desc.ctx;
-}
-EXPORT_SYMBOL(crc_t10dif_update);
-
-static int __init crc_t10dif_mod_init(void)
+__u16 crc_t10dif_generic(__u16 crc, const unsigned char *buffer, size_t len)
 {
-	crypto_register_notifier(&crc_t10dif_nb);
-	crct10dif_tfm = crypto_alloc_shash("crct10dif", 0, 0);
-	if (IS_ERR(crct10dif_tfm)) {
-		static_key_slow_inc(&crct10dif_fallback);
-		crct10dif_tfm = NULL;
-	}
-	return 0;
-}
+	unsigned int i;
 
-static void __exit crc_t10dif_mod_fini(void)
-{
-	crypto_unregister_notifier(&crc_t10dif_nb);
-	crypto_free_shash(crct10dif_tfm);
-}
-
-module_init(crc_t10dif_mod_init);
-module_exit(crc_t10dif_mod_fini);
-
-static int crc_t10dif_transform_show(char *buffer, const struct kernel_param *kp)
-{
-	if (static_key_false(&crct10dif_fallback))
-		return sprintf(buffer, "fallback\n");
+	for (i = 0 ; i < len ; i++)
+		crc = (crc << 8) ^ t10_dif_crc_table[((crc >> 8) ^ buffer[i]) & 0xff];
 
-	return sprintf(buffer, "%s\n",
-		crypto_tfm_alg_driver_name(crypto_shash_tfm(crct10dif_tfm)));
+	return crc;
 }
+EXPORT_SYMBOL(crc_t10dif_generic);
 
-module_param_call(transform, NULL, crc_t10dif_transform_show, NULL, 0644);
+DEFINE_FFP(crc_t10dif_update_arch, crc_t10dif_generic);
+EXPORT_SYMBOL(crc_t10dif_update_arch);
 
 MODULE_DESCRIPTION("T10 DIF CRC calculation");
 MODULE_LICENSE("GPL");
-- 
2.11.0
