Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCC83C05027
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Feb 2023 14:44:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbjBQOoH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Feb 2023 09:44:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjBQOoG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Feb 2023 09:44:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C336D797
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2023 06:43:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 53A63B82C32
        for <linux-crypto@vger.kernel.org>; Fri, 17 Feb 2023 14:43:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7CACC433D2;
        Fri, 17 Feb 2023 14:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676645037;
        bh=en14dJeDaO/kimDm3Yxyv3es/XUjDIdCUPAIzvaTTGo=;
        h=From:To:Cc:Subject:Date:From;
        b=X6WQlEvTxzgTjwdeC7KZpvMBKMfBxIMxzOsnDfNC/lptc0UVydCE6/0e0btCLcvb6
         jxRgCZdsVz6462reRb+v51GNsFspxGdr35hAMMAEK1SEb6UZikgvcltJ4alBefxXpY
         N1wrC/9mrrps5n3eSvt6iUyMGYwmXj7EUMXzKS6AgegNaVUdExVBRpveSgeVShS/Um
         MWBTzNo7OyMvWu9kbpmImBrYoMDoz5bfJlnIXQdSBpLtzEk9X4TK4mGbirdq7GQBKb
         Pio0borZx4jHmbdxfHRbaeKNvQTJB5vfzUArGAkNc4zfaztoZ4nse2WP4vwprkztmv
         I8lloQQck40Mg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH v2] crypto: lib - implement library version of AES in CFB mode
Date:   Fri, 17 Feb 2023 15:43:48 +0100
Message-Id: <20230217144348.1537615-1-ardb@kernel.org>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11011; i=ardb@kernel.org; h=from:subject; bh=en14dJeDaO/kimDm3Yxyv3es/XUjDIdCUPAIzvaTTGo=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBj75KjK0mYMs8QyK3WqTqhPErBWf+HeD5NLHNdR bl+Vto+xv6JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCY++SowAKCRDDTyI5ktmP JE1gDACGhl586xJJHeW+lQABf+Wd4gEFHBFKjUwfEL/3Qq3jzj1UJ6ZbCuFFxA3QA64JlvkjsHs 5pneKdpcDnLdNLtdnukvwssACJjnphCNj/PCgkPEzh7wyx2SSJ0NlRZoq5lo6w7WPc+eY7GmBU3 DNASJLSFstESwRz2S9T/TkyVzFEXD/JNG5HW8VDGZpdczcdqI4mNr2WQ3q1N9hB/sc9ZW+FwMwq po1E9be3SUy9WkPbOD9ipjUzi7E6YE0OkNTFQBvfp9ThwgRmnuLXx6oJWyRiPCa58KkUcdE1Ne+ 3UXgzHkyxqWIiY30es1Gk5bJAFHurQ6Gwcu+liR3WxXbPqoUMPDCxTCfVZ9+ZuGsmhJHS601TFa vtylitdEXzGyOXMohPxBoSuRqxm7mfHyWTDd+X++xTQeBPdjnVkRVT14icGsDAVwBp5QH/quebx EUqDIdGjbY1RCh6WFbewG+fOmrYq76/4FbulxmdhtqIZxV49n8iTCiJNA396fCPJCIsLc=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Implement AES in CFB mode using the existing, mostly constant-time
generic AES library implementation. This will be used by the TPM code
to encrypt communications with TPM hardware, which is often a discrete
component connected using sniffable wires or traces.

While a CFB template does exist, using a skcipher is a major pain for
non-performance critical synchronous crypto where the algorithm is known
at compile time and the data is in contiguous buffers with valid kernel
virtual addresses.

Tested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Reviewed-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Link: https://lore.kernel.org/all/20230216201410.15010-1-James.Bottomley@HansenPartnership.com/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
v1 was sent out by James and is archived at the URL above

v2:
- add test cases and kerneldoc comments
- add memzero_explicit() calls to wipe the keystream buffers
- add module exports
- add James's Tb/Rb

 include/crypto/aes.h |   5 +
 lib/crypto/Kconfig   |   5 +
 lib/crypto/Makefile  |   3 +
 lib/crypto/aescfb.c  | 257 ++++++++++++++++++++
 4 files changed, 270 insertions(+)

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 2090729701ab6d7a..9339da7c20a8b54e 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -87,4 +87,9 @@ void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in);
 extern const u8 crypto_aes_sbox[];
 extern const u8 crypto_aes_inv_sbox[];
 
+void aescfb_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
+		    int len, const u8 iv[AES_BLOCK_SIZE]);
+void aescfb_decrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
+		    int len, const u8 iv[AES_BLOCK_SIZE]);
+
 #endif
diff --git a/lib/crypto/Kconfig b/lib/crypto/Kconfig
index 45436bfc6dffe1db..b01253cac70a7499 100644
--- a/lib/crypto/Kconfig
+++ b/lib/crypto/Kconfig
@@ -8,6 +8,11 @@ config CRYPTO_LIB_UTILS
 config CRYPTO_LIB_AES
 	tristate
 
+config CRYPTO_LIB_AESCFB
+	tristate
+	select CRYPTO_LIB_AES
+	select CRYPTO_LIB_UTILS
+
 config CRYPTO_LIB_AESGCM
 	tristate
 	select CRYPTO_LIB_AES
diff --git a/lib/crypto/Makefile b/lib/crypto/Makefile
index 6ec2d4543d9cad48..33213a01aab101e8 100644
--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -10,6 +10,9 @@ obj-$(CONFIG_CRYPTO_LIB_CHACHA_GENERIC)		+= libchacha.o
 obj-$(CONFIG_CRYPTO_LIB_AES)			+= libaes.o
 libaes-y					:= aes.o
 
+obj-$(CONFIG_CRYPTO_LIB_AESCFB)			+= libaescfb.o
+libaescfb-y					:= aescfb.o
+
 obj-$(CONFIG_CRYPTO_LIB_AESGCM)			+= libaesgcm.o
 libaesgcm-y					:= aesgcm.o
 
diff --git a/lib/crypto/aescfb.c b/lib/crypto/aescfb.c
new file mode 100644
index 0000000000000000..749dc1258a44b7af
--- /dev/null
+++ b/lib/crypto/aescfb.c
@@ -0,0 +1,257 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Minimal library implementation of AES in CFB mode
+ *
+ * Copyright 2023 Google LLC
+ */
+
+#include <linux/module.h>
+
+#include <crypto/algapi.h>
+#include <crypto/aes.h>
+
+#include <asm/irqflags.h>
+
+static void aescfb_encrypt_block(const struct crypto_aes_ctx *ctx, void *dst,
+				 const void *src)
+{
+	unsigned long flags;
+
+	/*
+	 * In AES-CFB, the AES encryption operates on known 'plaintext' (the IV
+	 * and ciphertext), making it susceptible to timing attacks on the
+	 * encryption key. The AES library already mitigates this risk to some
+	 * extent by pulling the entire S-box into the caches before doing any
+	 * substitutions, but this strategy is more effective when running with
+	 * interrupts disabled.
+	 */
+	local_irq_save(flags);
+	aes_encrypt(ctx, dst, src);
+	local_irq_restore(flags);
+}
+
+/**
+ * aescfb_encrypt - Perform AES-CFB encryption on a block of data
+ *
+ * @ctx:	The AES-CFB key schedule
+ * @dst:	Pointer to the ciphertext output buffer
+ * @src:	Pointer the plaintext (may equal @dst for encryption in place)
+ * @len:	The size in bytes of the plaintext and ciphertext.
+ * @iv:		The initialization vector (IV) to use for this block of data
+ */
+void aescfb_encrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
+		    int len, const u8 iv[AES_BLOCK_SIZE])
+{
+	u8 ks[AES_BLOCK_SIZE];
+	const u8 *v = iv;
+
+	while (len > 0) {
+		aescfb_encrypt_block(ctx, ks, v);
+		crypto_xor_cpy(dst, src, ks, min(len, AES_BLOCK_SIZE));
+		v = dst;
+
+		dst += AES_BLOCK_SIZE;
+		src += AES_BLOCK_SIZE;
+		len -= AES_BLOCK_SIZE;
+	}
+
+	memzero_explicit(ks, sizeof(ks));
+}
+EXPORT_SYMBOL(aescfb_encrypt);
+
+/**
+ * aescfb_decrypt - Perform AES-CFB decryption on a block of data
+ *
+ * @ctx:	The AES-CFB key schedule
+ * @dst:	Pointer to the plaintext output buffer
+ * @src:	Pointer the ciphertext (may equal @dst for decryption in place)
+ * @len:	The size in bytes of the plaintext and ciphertext.
+ * @iv:		The initialization vector (IV) to use for this block of data
+ */
+void aescfb_decrypt(const struct crypto_aes_ctx *ctx, u8 *dst, const u8 *src,
+		    int len, const u8 iv[AES_BLOCK_SIZE])
+{
+	u8 ks[2][AES_BLOCK_SIZE];
+
+	aescfb_encrypt_block(ctx, ks[0], iv);
+
+	for (int i = 0; len > 0; i ^= 1) {
+		if (len > AES_BLOCK_SIZE)
+			/*
+			 * Generate the keystream for the next block before
+			 * performing the XOR, as that may update in place and
+			 * overwrite the ciphertext.
+			 */
+			aescfb_encrypt_block(ctx, ks[!i], src);
+
+		crypto_xor_cpy(dst, src, ks[i], min(len, AES_BLOCK_SIZE));
+
+		dst += AES_BLOCK_SIZE;
+		src += AES_BLOCK_SIZE;
+		len -= AES_BLOCK_SIZE;
+	}
+
+	memzero_explicit(ks, sizeof(ks));
+}
+EXPORT_SYMBOL(aescfb_decrypt);
+
+MODULE_DESCRIPTION("Generic AES-CFB library");
+MODULE_AUTHOR("Ard Biesheuvel <ardb@kernel.org>");
+MODULE_LICENSE("GPL");
+
+#ifndef CONFIG_CRYPTO_MANAGER_DISABLE_TESTS
+
+/*
+ * Test code below. Vectors taken from crypto/testmgr.h
+ */
+
+static struct {
+	u8	ptext[64];
+	u8	ctext[64];
+
+	u8	key[AES_MAX_KEY_SIZE];
+	u8	iv[AES_BLOCK_SIZE];
+
+	int	klen;
+	int	len;
+} const aescfb_tv[] __initconst = {
+	{ /* From NIST SP800-38A */
+		.key    = "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ctext	= "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
+			  "\x33\x34\x49\xf8\xe8\x3c\xfb\x4a"
+			  "\xc8\xa6\x45\x37\xa0\xb3\xa9\x3f"
+			  "\xcd\xe3\xcd\xad\x9f\x1c\xe5\x8b"
+			  "\x26\x75\x1f\x67\xa3\xcb\xb1\x40"
+			  "\xb1\x80\x8c\xf1\x87\xa4\xf4\xdf"
+			  "\xc0\x4b\x05\x35\x7c\x5d\x1c\x0e"
+			  "\xea\xc4\xc6\x6f\x9f\xf7\xf2\xe6",
+		.len	= 64,
+	}, {
+		.key	= "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
+			  "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
+			  "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
+		.klen	= 24,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ctext	= "\xcd\xc8\x0d\x6f\xdd\xf1\x8c\xab"
+			  "\x34\xc2\x59\x09\xc9\x9a\x41\x74"
+			  "\x67\xce\x7f\x7f\x81\x17\x36\x21"
+			  "\x96\x1a\x2b\x70\x17\x1d\x3d\x7a"
+			  "\x2e\x1e\x8a\x1d\xd5\x9b\x88\xb1"
+			  "\xc8\xe6\x0f\xed\x1e\xfa\xc4\xc9"
+			  "\xc0\x5f\x9f\x9c\xa9\x83\x4f\xa0"
+			  "\x42\xae\x8f\xba\x58\x4b\x09\xff",
+		.len	= 64,
+	}, {
+		.key	= "\x60\x3d\xeb\x10\x15\xca\x71\xbe"
+			  "\x2b\x73\xae\xf0\x85\x7d\x77\x81"
+			  "\x1f\x35\x2c\x07\x3b\x61\x08\xd7"
+			  "\x2d\x98\x10\xa3\x09\x14\xdf\xf4",
+		.klen	= 32,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae\x2d\x8a\x57\x1e\x03\xac\x9c"
+			  "\x9e\xb7\x6f\xac\x45\xaf\x8e\x51"
+			  "\x30\xc8\x1c\x46\xa3\x5c\xe4\x11"
+			  "\xe5\xfb\xc1\x19\x1a\x0a\x52\xef"
+			  "\xf6\x9f\x24\x45\xdf\x4f\x9b\x17"
+			  "\xad\x2b\x41\x7b\xe6\x6c\x37\x10",
+		.ctext	= "\xdc\x7e\x84\xbf\xda\x79\x16\x4b"
+			  "\x7e\xcd\x84\x86\x98\x5d\x38\x60"
+			  "\x39\xff\xed\x14\x3b\x28\xb1\xc8"
+			  "\x32\x11\x3c\x63\x31\xe5\x40\x7b"
+			  "\xdf\x10\x13\x24\x15\xe5\x4b\x92"
+			  "\xa1\x3e\xd0\xa8\x26\x7a\xe2\xf9"
+			  "\x75\xa3\x85\x74\x1a\xb9\xce\xf8"
+			  "\x20\x31\x62\x3d\x55\xb1\xe4\x71",
+		.len	= 64,
+	}, { /* > 16 bytes, not a multiple of 16 bytes */
+		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f\x96"
+			  "\xe9\x3d\x7e\x11\x73\x93\x17\x2a"
+			  "\xae",
+		.ctext	= "\x3b\x3f\xd9\x2e\xb7\x2d\xad\x20"
+			  "\x33\x34\x49\xf8\xe8\x3c\xfb\x4a"
+			  "\xc8",
+		.len	= 17,
+	}, { /* < 16 bytes */
+		.key	= "\x2b\x7e\x15\x16\x28\xae\xd2\xa6"
+			  "\xab\xf7\x15\x88\x09\xcf\x4f\x3c",
+		.klen	= 16,
+		.iv	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f",
+		.ptext	= "\x6b\xc1\xbe\xe2\x2e\x40\x9f",
+		.ctext	= "\x3b\x3f\xd9\x2e\xb7\x2d\xad",
+		.len	= 7,
+	},
+};
+
+static int __init libaescfb_init(void)
+{
+	for (int i = 0; i < ARRAY_SIZE(aescfb_tv); i++) {
+		struct crypto_aes_ctx ctx;
+		u8 buf[64];
+
+		if (aes_expandkey(&ctx, aescfb_tv[i].key, aescfb_tv[i].klen)) {
+			pr_err("aes_expandkey() failed on vector %d\n", i);
+			return -ENODEV;
+		}
+
+		aescfb_encrypt(&ctx, buf, aescfb_tv[i].ptext, aescfb_tv[i].len,
+			       aescfb_tv[i].iv);
+		if (memcmp(buf, aescfb_tv[i].ctext, aescfb_tv[i].len)) {
+			pr_err("aescfb_encrypt() #1 failed on vector %d\n", i);
+			return -ENODEV;
+		}
+
+		/* decrypt in place */
+		aescfb_decrypt(&ctx, buf, buf, aescfb_tv[i].len, aescfb_tv[i].iv);
+		if (memcmp(buf, aescfb_tv[i].ptext, aescfb_tv[i].len)) {
+			pr_err("aescfb_decrypt() failed on vector %d\n", i);
+			return -ENODEV;
+		}
+
+		/* encrypt in place */
+		aescfb_encrypt(&ctx, buf, buf, aescfb_tv[i].len, aescfb_tv[i].iv);
+		if (memcmp(buf, aescfb_tv[i].ctext, aescfb_tv[i].len)) {
+			pr_err("aescfb_encrypt() #2 failed on vector %d\n", i);
+
+			return -ENODEV;
+		}
+
+	}
+	return 0;
+}
+module_init(libaescfb_init);
+
+static void __exit libaescfb_exit(void)
+{
+}
+module_exit(libaescfb_exit);
+#endif
-- 
2.39.1

