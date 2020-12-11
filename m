Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD154C4361B
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 12:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6684323EB1
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Dec 2020 12:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395552AbgLKM2y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Dec 2020 07:28:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388407AbgLKM2Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Dec 2020 07:28:25 -0500
From:   Ard Biesheuvel <ardb@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH v2 2/2] crypto: remove cipher routines from public crypto API
Date:   Fri, 11 Dec 2020 13:27:15 +0100
Message-Id: <20201211122715.15090-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201211122715.15090-1-ardb@kernel.org>
References: <20201211122715.15090-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The cipher routines in the crypto API are mostly intended for templates
implementing skcipher modes generically in software, and shouldn't be
used outside of the crypto subsystem. So move the prototypes and all
related definitions to a new header file under include/crypto/internal.
Also, let's use the new module namespace feature to move the symbol
exports into a new namespace CRYPTO_INTERNAL.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 Documentation/crypto/api-skcipher.rst        |   4 +-
 arch/arm/crypto/aes-neonbs-glue.c            |   3 +
 arch/s390/crypto/aes_s390.c                  |   2 +
 crypto/adiantum.c                            |   2 +
 crypto/ansi_cprng.c                          |   2 +
 crypto/cbc.c                                 |   1 +
 crypto/ccm.c                                 |   2 +
 crypto/cfb.c                                 |   2 +
 crypto/cipher.c                              |   7 +-
 crypto/cmac.c                                |   2 +
 crypto/ctr.c                                 |   2 +
 crypto/drbg.c                                |   2 +
 crypto/ecb.c                                 |   1 +
 crypto/essiv.c                               |   2 +
 crypto/keywrap.c                             |   2 +
 crypto/ofb.c                                 |   2 +
 crypto/pcbc.c                                |   2 +
 crypto/skcipher.c                            |   2 +
 crypto/testmgr.c                             |   3 +
 crypto/vmac.c                                |   2 +
 crypto/xcbc.c                                |   2 +
 crypto/xts.c                                 |   2 +
 drivers/crypto/geode-aes.c                   |   2 +
 drivers/crypto/inside-secure/safexcel.c      |   1 +
 drivers/crypto/inside-secure/safexcel_hash.c |   1 +
 drivers/crypto/qat/qat_common/adf_ctl_drv.c  |   1 +
 drivers/crypto/qat/qat_common/qat_algs.c     |   1 +
 drivers/crypto/vmx/aes.c                     |   1 +
 drivers/crypto/vmx/vmx.c                     |   1 +
 include/crypto/algapi.h                      |  39 ----
 include/crypto/internal/cipher.h             | 218 ++++++++++++++++++++
 include/crypto/internal/skcipher.h           |   1 +
 include/linux/crypto.h                       | 163 ---------------
 33 files changed, 273 insertions(+), 207 deletions(-)

diff --git a/Documentation/crypto/api-skcipher.rst b/Documentation/crypto/api-skcipher.rst
index 1aaf8985894b..04d6cc5357c8 100644
--- a/Documentation/crypto/api-skcipher.rst
+++ b/Documentation/crypto/api-skcipher.rst
@@ -28,8 +28,8 @@ Symmetric Key Cipher Request Handle
 Single Block Cipher API
 -----------------------
 
-.. kernel-doc:: include/linux/crypto.h
+.. kernel-doc:: include/crypto/internal/cipher.h
    :doc: Single Block Cipher API
 
-.. kernel-doc:: include/linux/crypto.h
+.. kernel-doc:: include/crypto/internal/cipher.h
    :functions: crypto_alloc_cipher crypto_free_cipher crypto_has_cipher crypto_cipher_blocksize crypto_cipher_setkey crypto_cipher_encrypt_one crypto_cipher_decrypt_one
diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index f70af1d0514b..5c6cd3c63cbc 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -9,6 +9,7 @@
 #include <asm/simd.h>
 #include <crypto/aes.h>
 #include <crypto/ctr.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/simd.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
@@ -23,6 +24,8 @@ MODULE_ALIAS_CRYPTO("cbc(aes)-all");
 MODULE_ALIAS_CRYPTO("ctr(aes)");
 MODULE_ALIAS_CRYPTO("xts(aes)");
 
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
+
 asmlinkage void aesbs_convert_key(u8 out[], u32 const rk[], int rounds);
 
 asmlinkage void aesbs_ecb_encrypt(u8 out[], u8 const in[], u8 const rk[],
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 73044634d342..54c7536f2482 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -21,6 +21,7 @@
 #include <crypto/algapi.h>
 #include <crypto/ghash.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -1055,3 +1056,4 @@ MODULE_ALIAS_CRYPTO("aes-all");
 
 MODULE_DESCRIPTION("Rijndael (AES) Cipher Algorithm");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/adiantum.c b/crypto/adiantum.c
index ce4d5725342c..84450130cb6b 100644
--- a/crypto/adiantum.c
+++ b/crypto/adiantum.c
@@ -32,6 +32,7 @@
 
 #include <crypto/b128ops.h>
 #include <crypto/chacha.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/poly1305.h>
 #include <crypto/internal/skcipher.h>
@@ -616,3 +617,4 @@ MODULE_DESCRIPTION("Adiantum length-preserving encryption mode");
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Eric Biggers <ebiggers@google.com>");
 MODULE_ALIAS_CRYPTO("adiantum");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index c475c1129ff2..3f512efaba3a 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -7,6 +7,7 @@
  *  (C) Neil Horman <nhorman@tuxdriver.com>
  */
 
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/rng.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -470,3 +471,4 @@ subsys_initcall(prng_mod_init);
 module_exit(prng_mod_fini);
 MODULE_ALIAS_CRYPTO("stdrng");
 MODULE_ALIAS_CRYPTO("ansi_cprng");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/cbc.c b/crypto/cbc.c
index 0d9509dff891..6c03e96b945f 100644
--- a/crypto/cbc.c
+++ b/crypto/cbc.c
@@ -6,6 +6,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/crypto/ccm.c b/crypto/ccm.c
index 494d70901186..6b815ece51c6 100644
--- a/crypto/ccm.c
+++ b/crypto/ccm.c
@@ -6,6 +6,7 @@
  */
 
 #include <crypto/internal/aead.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
@@ -954,3 +955,4 @@ MODULE_ALIAS_CRYPTO("ccm_base");
 MODULE_ALIAS_CRYPTO("rfc4309");
 MODULE_ALIAS_CRYPTO("ccm");
 MODULE_ALIAS_CRYPTO("cbcmac");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/cfb.c b/crypto/cfb.c
index 4e5219bbcd19..0d664dfb47bc 100644
--- a/crypto/cfb.c
+++ b/crypto/cfb.c
@@ -20,6 +20,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -250,3 +251,4 @@ module_exit(crypto_cfb_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CFB block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("cfb");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/cipher.c b/crypto/cipher.c
index fd78150deb1c..b47141ed4a9f 100644
--- a/crypto/cipher.c
+++ b/crypto/cipher.c
@@ -9,6 +9,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <linux/kernel.h>
 #include <linux/crypto.h>
 #include <linux/errno.h>
@@ -53,7 +54,7 @@ int crypto_cipher_setkey(struct crypto_cipher *tfm,
 
 	return cia->cia_setkey(crypto_cipher_tfm(tfm), key, keylen);
 }
-EXPORT_SYMBOL_GPL(crypto_cipher_setkey);
+EXPORT_SYMBOL_NS_GPL(crypto_cipher_setkey, CRYPTO_INTERNAL);
 
 static inline void cipher_crypt_one(struct crypto_cipher *tfm,
 				    u8 *dst, const u8 *src, bool enc)
@@ -81,11 +82,11 @@ void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
 {
 	cipher_crypt_one(tfm, dst, src, true);
 }
-EXPORT_SYMBOL_GPL(crypto_cipher_encrypt_one);
+EXPORT_SYMBOL_NS_GPL(crypto_cipher_encrypt_one, CRYPTO_INTERNAL);
 
 void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
 			       u8 *dst, const u8 *src)
 {
 	cipher_crypt_one(tfm, dst, src, false);
 }
-EXPORT_SYMBOL_GPL(crypto_cipher_decrypt_one);
+EXPORT_SYMBOL_NS_GPL(crypto_cipher_decrypt_one, CRYPTO_INTERNAL);
diff --git a/crypto/cmac.c b/crypto/cmac.c
index df36be1efb81..f4a5d3bfb376 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -11,6 +11,7 @@
  *   Author: Kazunori Miyazawa <miyazawa@linux-ipv6.org>
  */
 
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
@@ -313,3 +314,4 @@ module_exit(crypto_cmac_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CMAC keyed hash algorithm");
 MODULE_ALIAS_CRYPTO("cmac");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/ctr.c b/crypto/ctr.c
index c39fcffba27f..23c698b22013 100644
--- a/crypto/ctr.c
+++ b/crypto/ctr.c
@@ -7,6 +7,7 @@
 
 #include <crypto/algapi.h>
 #include <crypto/ctr.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -358,3 +359,4 @@ MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("CTR block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("rfc3686");
 MODULE_ALIAS_CRYPTO("ctr");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 3132967a1749..1b4587e0ddad 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -98,6 +98,7 @@
  */
 
 #include <crypto/drbg.h>
+#include <crypto/internal/cipher.h>
 #include <linux/kernel.h>
 
 /***************************************************************
@@ -2161,3 +2162,4 @@ MODULE_DESCRIPTION("NIST SP800-90A Deterministic Random Bit Generator (DRBG) "
 		   CRYPTO_DRBG_HMAC_STRING
 		   CRYPTO_DRBG_CTR_STRING);
 MODULE_ALIAS_CRYPTO("stdrng");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/ecb.c b/crypto/ecb.c
index 69a687cbdf21..71fbb0543d64 100644
--- a/crypto/ecb.c
+++ b/crypto/ecb.c
@@ -6,6 +6,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
diff --git a/crypto/essiv.c b/crypto/essiv.c
index d012be23d496..8bcc5bdcb2a9 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -30,6 +30,7 @@
 
 #include <crypto/authenc.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
@@ -643,3 +644,4 @@ module_exit(essiv_module_exit);
 MODULE_DESCRIPTION("ESSIV skcipher/aead wrapper for block encryption");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("essiv");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/keywrap.c b/crypto/keywrap.c
index 0355cce21b1e..3517773bc7f7 100644
--- a/crypto/keywrap.c
+++ b/crypto/keywrap.c
@@ -85,6 +85,7 @@
 #include <linux/crypto.h>
 #include <linux/scatterlist.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 
 struct crypto_kw_block {
@@ -316,3 +317,4 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
 MODULE_DESCRIPTION("Key Wrapping (RFC3394 / NIST SP800-38F)");
 MODULE_ALIAS_CRYPTO("kw");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/ofb.c b/crypto/ofb.c
index 2ec68e3f2c55..b630fdecceee 100644
--- a/crypto/ofb.c
+++ b/crypto/ofb.c
@@ -8,6 +8,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -102,3 +103,4 @@ module_exit(crypto_ofb_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("OFB block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("ofb");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/pcbc.c b/crypto/pcbc.c
index ae921fb74dc9..7030f59e46b6 100644
--- a/crypto/pcbc.c
+++ b/crypto/pcbc.c
@@ -10,6 +10,7 @@
  */
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <linux/err.h>
 #include <linux/init.h>
@@ -191,3 +192,4 @@ module_exit(crypto_pcbc_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PCBC block cipher mode of operation");
 MODULE_ALIAS_CRYPTO("pcbc");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index b4dae640de9f..ff16d05644c7 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -10,6 +10,7 @@
  */
 
 #include <crypto/internal/aead.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/bug.h>
@@ -986,3 +987,4 @@ EXPORT_SYMBOL_GPL(skcipher_alloc_instance_simple);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Symmetric key cipher type");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 321e38eef51b..a896d77e9611 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -33,10 +33,13 @@
 #include <crypto/akcipher.h>
 #include <crypto/kpp.h>
 #include <crypto/acompress.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/simd.h>
 
 #include "internal.h"
 
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
+
 static bool notests;
 module_param(notests, bool, 0644);
 MODULE_PARM_DESC(notests, "disable crypto self-tests");
diff --git a/crypto/vmac.c b/crypto/vmac.c
index 9b565d1040d6..4633b2dda1e0 100644
--- a/crypto/vmac.c
+++ b/crypto/vmac.c
@@ -36,6 +36,7 @@
 #include <linux/scatterlist.h>
 #include <asm/byteorder.h>
 #include <crypto/scatterwalk.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 
 /*
@@ -693,3 +694,4 @@ module_exit(vmac_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("VMAC hash algorithm");
 MODULE_ALIAS_CRYPTO("vmac64");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index af3b7eb5d7c7..6074c5c1da49 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -6,6 +6,7 @@
  * 	Kazunori Miyazawa <miyazawa@linux-ipv6.org>
  */
 
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/hash.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
@@ -272,3 +273,4 @@ module_exit(crypto_xcbc_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("XCBC keyed hash algorithm");
 MODULE_ALIAS_CRYPTO("xcbc");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/crypto/xts.c b/crypto/xts.c
index ad45b009774b..6c12f30dbdd6 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -7,6 +7,7 @@
  * Based on ecb.c
  * Copyright (c) 2006 Herbert Xu <herbert@gondor.apana.org.au>
  */
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/scatterwalk.h>
 #include <linux/err.h>
@@ -464,3 +465,4 @@ module_exit(xts_module_exit);
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("XTS block cipher mode");
 MODULE_ALIAS_CRYPTO("xts");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/drivers/crypto/geode-aes.c b/drivers/crypto/geode-aes.c
index f4f18bfc2247..4ee010f39912 100644
--- a/drivers/crypto/geode-aes.c
+++ b/drivers/crypto/geode-aes.c
@@ -10,6 +10,7 @@
 #include <linux/spinlock.h>
 #include <crypto/algapi.h>
 #include <crypto/aes.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 
 #include <linux/io.h>
@@ -434,3 +435,4 @@ module_pci_driver(geode_aes_driver);
 MODULE_AUTHOR("Advanced Micro Devices, Inc.");
 MODULE_DESCRIPTION("Geode LX Hardware AES driver");
 MODULE_LICENSE("GPL");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 2e1562108a85..30aedfcfee7c 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1999,3 +1999,4 @@ MODULE_AUTHOR("Ofer Heifetz <oferh@marvell.com>");
 MODULE_AUTHOR("Igal Liberman <igall@marvell.com>");
 MODULE_DESCRIPTION("Support for SafeXcel cryptographic engines: EIP97 & EIP197");
 MODULE_LICENSE("GPL v2");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 50fb6d90a2e0..bc60b5802256 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -13,6 +13,7 @@
 #include <crypto/sha3.h>
 #include <crypto/skcipher.h>
 #include <crypto/sm3.h>
+#include <crypto/internal/cipher.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
diff --git a/drivers/crypto/qat/qat_common/adf_ctl_drv.c b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
index eb9b3be9d8eb..96b437bfe3de 100644
--- a/drivers/crypto/qat/qat_common/adf_ctl_drv.c
+++ b/drivers/crypto/qat/qat_common/adf_ctl_drv.c
@@ -464,3 +464,4 @@ MODULE_AUTHOR("Intel");
 MODULE_DESCRIPTION("Intel(R) QuickAssist Technology");
 MODULE_ALIAS_CRYPTO("intel_qat");
 MODULE_VERSION(ADF_DRV_VERSION);
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 31c7a206a629..ff78c73c47e3 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -4,6 +4,7 @@
 #include <linux/slab.h>
 #include <linux/crypto.h>
 #include <crypto/internal/aead.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/skcipher.h>
 #include <crypto/aes.h>
 #include <crypto/sha1.h>
diff --git a/drivers/crypto/vmx/aes.c b/drivers/crypto/vmx/aes.c
index 2bc5d4e1adf4..d05c02baebcf 100644
--- a/drivers/crypto/vmx/aes.c
+++ b/drivers/crypto/vmx/aes.c
@@ -14,6 +14,7 @@
 #include <asm/simd.h>
 #include <asm/switch_to.h>
 #include <crypto/aes.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/internal/simd.h>
 
 #include "aesp8-ppc.h"
diff --git a/drivers/crypto/vmx/vmx.c b/drivers/crypto/vmx/vmx.c
index 3e0335fb406c..87a194455d6a 100644
--- a/drivers/crypto/vmx/vmx.c
+++ b/drivers/crypto/vmx/vmx.c
@@ -78,3 +78,4 @@ MODULE_DESCRIPTION("IBM VMX cryptographic acceleration instructions "
 		   "support on Power 8");
 MODULE_LICENSE("GPL");
 MODULE_VERSION("1.0.0");
+MODULE_IMPORT_NS(CRYPTO_INTERNAL);
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 18dd7a4aaf7d..86f0748009af 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -189,45 +189,6 @@ static inline void *crypto_instance_ctx(struct crypto_instance *inst)
 	return inst->__ctx;
 }
 
-struct crypto_cipher_spawn {
-	struct crypto_spawn base;
-};
-
-static inline int crypto_grab_cipher(struct crypto_cipher_spawn *spawn,
-				     struct crypto_instance *inst,
-				     const char *name, u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_CIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
-}
-
-static inline void crypto_drop_cipher(struct crypto_cipher_spawn *spawn)
-{
-	crypto_drop_spawn(&spawn->base);
-}
-
-static inline struct crypto_alg *crypto_spawn_cipher_alg(
-	struct crypto_cipher_spawn *spawn)
-{
-	return spawn->base.alg;
-}
-
-static inline struct crypto_cipher *crypto_spawn_cipher(
-	struct crypto_cipher_spawn *spawn)
-{
-	u32 type = CRYPTO_ALG_TYPE_CIPHER;
-	u32 mask = CRYPTO_ALG_TYPE_MASK;
-
-	return __crypto_cipher_cast(crypto_spawn_tfm(&spawn->base, type, mask));
-}
-
-static inline struct cipher_alg *crypto_cipher_alg(struct crypto_cipher *tfm)
-{
-	return &crypto_cipher_tfm(tfm)->__crt_alg->cra_cipher;
-}
-
 static inline struct crypto_async_request *crypto_get_backlog(
 	struct crypto_queue *queue)
 {
diff --git a/include/crypto/internal/cipher.h b/include/crypto/internal/cipher.h
new file mode 100644
index 000000000000..a9174ba90250
--- /dev/null
+++ b/include/crypto/internal/cipher.h
@@ -0,0 +1,218 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2002 James Morris <jmorris@intercode.com.au>
+ * Copyright (c) 2002 David S. Miller (davem@redhat.com)
+ * Copyright (c) 2005 Herbert Xu <herbert@gondor.apana.org.au>
+ *
+ * Portions derived from Cryptoapi, by Alexander Kjeldaas <astor@fast.no>
+ * and Nettle, by Niels Möller.
+ */
+
+#ifndef _CRYPTO_INTERNAL_CIPHER_H
+#define _CRYPTO_INTERNAL_CIPHER_H
+
+#include <crypto/algapi.h>
+
+struct crypto_cipher {
+	struct crypto_tfm base;
+};
+
+/**
+ * DOC: Single Block Cipher API
+ *
+ * The single block cipher API is used with the ciphers of type
+ * CRYPTO_ALG_TYPE_CIPHER (listed as type "cipher" in /proc/crypto).
+ *
+ * Using the single block cipher API calls, operations with the basic cipher
+ * primitive can be implemented. These cipher primitives exclude any block
+ * chaining operations including IV handling.
+ *
+ * The purpose of this single block cipher API is to support the implementation
+ * of templates or other concepts that only need to perform the cipher operation
+ * on one block at a time. Templates invoke the underlying cipher primitive
+ * block-wise and process either the input or the output data of these cipher
+ * operations.
+ */
+
+static inline struct crypto_cipher *__crypto_cipher_cast(struct crypto_tfm *tfm)
+{
+	return (struct crypto_cipher *)tfm;
+}
+
+/**
+ * crypto_alloc_cipher() - allocate single block cipher handle
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	     single block cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Allocate a cipher handle for a single block cipher. The returned struct
+ * crypto_cipher is the cipher handle that is required for any subsequent API
+ * invocation for that single block cipher.
+ *
+ * Return: allocated cipher handle in case of success; IS_ERR() is true in case
+ *	   of an error, PTR_ERR() returns the error code.
+ */
+static inline struct crypto_cipher *crypto_alloc_cipher(const char *alg_name,
+							u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_CIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	return __crypto_cipher_cast(crypto_alloc_base(alg_name, type, mask));
+}
+
+static inline struct crypto_tfm *crypto_cipher_tfm(struct crypto_cipher *tfm)
+{
+	return &tfm->base;
+}
+
+/**
+ * crypto_free_cipher() - zeroize and free the single block cipher handle
+ * @tfm: cipher handle to be freed
+ */
+static inline void crypto_free_cipher(struct crypto_cipher *tfm)
+{
+	crypto_free_tfm(crypto_cipher_tfm(tfm));
+}
+
+/**
+ * crypto_has_cipher() - Search for the availability of a single block cipher
+ * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
+ *	     single block cipher
+ * @type: specifies the type of the cipher
+ * @mask: specifies the mask for the cipher
+ *
+ * Return: true when the single block cipher is known to the kernel crypto API;
+ *	   false otherwise
+ */
+static inline int crypto_has_cipher(const char *alg_name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_CIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+
+	return crypto_has_alg(alg_name, type, mask);
+}
+
+/**
+ * crypto_cipher_blocksize() - obtain block size for cipher
+ * @tfm: cipher handle
+ *
+ * The block size for the single block cipher referenced with the cipher handle
+ * tfm is returned. The caller may use that information to allocate appropriate
+ * memory for the data returned by the encryption or decryption operation
+ *
+ * Return: block size of cipher
+ */
+static inline unsigned int crypto_cipher_blocksize(struct crypto_cipher *tfm)
+{
+	return crypto_tfm_alg_blocksize(crypto_cipher_tfm(tfm));
+}
+
+static inline unsigned int crypto_cipher_alignmask(struct crypto_cipher *tfm)
+{
+	return crypto_tfm_alg_alignmask(crypto_cipher_tfm(tfm));
+}
+
+static inline u32 crypto_cipher_get_flags(struct crypto_cipher *tfm)
+{
+	return crypto_tfm_get_flags(crypto_cipher_tfm(tfm));
+}
+
+static inline void crypto_cipher_set_flags(struct crypto_cipher *tfm,
+					   u32 flags)
+{
+	crypto_tfm_set_flags(crypto_cipher_tfm(tfm), flags);
+}
+
+static inline void crypto_cipher_clear_flags(struct crypto_cipher *tfm,
+					     u32 flags)
+{
+	crypto_tfm_clear_flags(crypto_cipher_tfm(tfm), flags);
+}
+
+/**
+ * crypto_cipher_setkey() - set key for cipher
+ * @tfm: cipher handle
+ * @key: buffer holding the key
+ * @keylen: length of the key in bytes
+ *
+ * The caller provided key is set for the single block cipher referenced by the
+ * cipher handle.
+ *
+ * Note, the key length determines the cipher type. Many block ciphers implement
+ * different cipher modes depending on the key size, such as AES-128 vs AES-192
+ * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
+ * is performed.
+ *
+ * Return: 0 if the setting of the key was successful; < 0 if an error occurred
+ */
+int crypto_cipher_setkey(struct crypto_cipher *tfm,
+			 const u8 *key, unsigned int keylen);
+
+/**
+ * crypto_cipher_encrypt_one() - encrypt one block of plaintext
+ * @tfm: cipher handle
+ * @dst: points to the buffer that will be filled with the ciphertext
+ * @src: buffer holding the plaintext to be encrypted
+ *
+ * Invoke the encryption operation of one block. The caller must ensure that
+ * the plaintext and ciphertext buffers are at least one block in size.
+ */
+void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
+			       u8 *dst, const u8 *src);
+
+/**
+ * crypto_cipher_decrypt_one() - decrypt one block of ciphertext
+ * @tfm: cipher handle
+ * @dst: points to the buffer that will be filled with the plaintext
+ * @src: buffer holding the ciphertext to be decrypted
+ *
+ * Invoke the decryption operation of one block. The caller must ensure that
+ * the plaintext and ciphertext buffers are at least one block in size.
+ */
+void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
+			       u8 *dst, const u8 *src);
+
+struct crypto_cipher_spawn {
+	struct crypto_spawn base;
+};
+
+static inline int crypto_grab_cipher(struct crypto_cipher_spawn *spawn,
+				     struct crypto_instance *inst,
+				     const char *name, u32 type, u32 mask)
+{
+	type &= ~CRYPTO_ALG_TYPE_MASK;
+	type |= CRYPTO_ALG_TYPE_CIPHER;
+	mask |= CRYPTO_ALG_TYPE_MASK;
+	return crypto_grab_spawn(&spawn->base, inst, name, type, mask);
+}
+
+static inline void crypto_drop_cipher(struct crypto_cipher_spawn *spawn)
+{
+	crypto_drop_spawn(&spawn->base);
+}
+
+static inline struct crypto_alg *crypto_spawn_cipher_alg(
+       struct crypto_cipher_spawn *spawn)
+{
+	return spawn->base.alg;
+}
+
+static inline struct crypto_cipher *crypto_spawn_cipher(
+	struct crypto_cipher_spawn *spawn)
+{
+	u32 type = CRYPTO_ALG_TYPE_CIPHER;
+	u32 mask = CRYPTO_ALG_TYPE_MASK;
+
+	return __crypto_cipher_cast(crypto_spawn_tfm(&spawn->base, type, mask));
+}
+
+static inline struct cipher_alg *crypto_cipher_alg(struct crypto_cipher *tfm)
+{
+	return &crypto_cipher_tfm(tfm)->__crt_alg->cra_cipher;
+}
+
+#endif
diff --git a/include/crypto/internal/skcipher.h b/include/crypto/internal/skcipher.h
index 10226c12c5df..9dd6c0c17eb8 100644
--- a/include/crypto/internal/skcipher.h
+++ b/include/crypto/internal/skcipher.h
@@ -9,6 +9,7 @@
 #define _CRYPTO_INTERNAL_SKCIPHER_H
 
 #include <crypto/algapi.h>
+#include <crypto/internal/cipher.h>
 #include <crypto/skcipher.h>
 #include <linux/list.h>
 #include <linux/types.h>
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ef90e07c9635..9b55cd6b1f1b 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -636,10 +636,6 @@ struct crypto_tfm {
 	void *__crt_ctx[] CRYPTO_MINALIGN_ATTR;
 };
 
-struct crypto_cipher {
-	struct crypto_tfm base;
-};
-
 struct crypto_comp {
 	struct crypto_tfm base;
 };
@@ -743,165 +739,6 @@ static inline unsigned int crypto_tfm_ctx_alignment(void)
 	return __alignof__(tfm->__crt_ctx);
 }
 
-/**
- * DOC: Single Block Cipher API
- *
- * The single block cipher API is used with the ciphers of type
- * CRYPTO_ALG_TYPE_CIPHER (listed as type "cipher" in /proc/crypto).
- *
- * Using the single block cipher API calls, operations with the basic cipher
- * primitive can be implemented. These cipher primitives exclude any block
- * chaining operations including IV handling.
- *
- * The purpose of this single block cipher API is to support the implementation
- * of templates or other concepts that only need to perform the cipher operation
- * on one block at a time. Templates invoke the underlying cipher primitive
- * block-wise and process either the input or the output data of these cipher
- * operations.
- */
-
-static inline struct crypto_cipher *__crypto_cipher_cast(struct crypto_tfm *tfm)
-{
-	return (struct crypto_cipher *)tfm;
-}
-
-/**
- * crypto_alloc_cipher() - allocate single block cipher handle
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	     single block cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Allocate a cipher handle for a single block cipher. The returned struct
- * crypto_cipher is the cipher handle that is required for any subsequent API
- * invocation for that single block cipher.
- *
- * Return: allocated cipher handle in case of success; IS_ERR() is true in case
- *	   of an error, PTR_ERR() returns the error code.
- */
-static inline struct crypto_cipher *crypto_alloc_cipher(const char *alg_name,
-							u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_CIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	return __crypto_cipher_cast(crypto_alloc_base(alg_name, type, mask));
-}
-
-static inline struct crypto_tfm *crypto_cipher_tfm(struct crypto_cipher *tfm)
-{
-	return &tfm->base;
-}
-
-/**
- * crypto_free_cipher() - zeroize and free the single block cipher handle
- * @tfm: cipher handle to be freed
- */
-static inline void crypto_free_cipher(struct crypto_cipher *tfm)
-{
-	crypto_free_tfm(crypto_cipher_tfm(tfm));
-}
-
-/**
- * crypto_has_cipher() - Search for the availability of a single block cipher
- * @alg_name: is the cra_name / name or cra_driver_name / driver name of the
- *	     single block cipher
- * @type: specifies the type of the cipher
- * @mask: specifies the mask for the cipher
- *
- * Return: true when the single block cipher is known to the kernel crypto API;
- *	   false otherwise
- */
-static inline int crypto_has_cipher(const char *alg_name, u32 type, u32 mask)
-{
-	type &= ~CRYPTO_ALG_TYPE_MASK;
-	type |= CRYPTO_ALG_TYPE_CIPHER;
-	mask |= CRYPTO_ALG_TYPE_MASK;
-
-	return crypto_has_alg(alg_name, type, mask);
-}
-
-/**
- * crypto_cipher_blocksize() - obtain block size for cipher
- * @tfm: cipher handle
- *
- * The block size for the single block cipher referenced with the cipher handle
- * tfm is returned. The caller may use that information to allocate appropriate
- * memory for the data returned by the encryption or decryption operation
- *
- * Return: block size of cipher
- */
-static inline unsigned int crypto_cipher_blocksize(struct crypto_cipher *tfm)
-{
-	return crypto_tfm_alg_blocksize(crypto_cipher_tfm(tfm));
-}
-
-static inline unsigned int crypto_cipher_alignmask(struct crypto_cipher *tfm)
-{
-	return crypto_tfm_alg_alignmask(crypto_cipher_tfm(tfm));
-}
-
-static inline u32 crypto_cipher_get_flags(struct crypto_cipher *tfm)
-{
-	return crypto_tfm_get_flags(crypto_cipher_tfm(tfm));
-}
-
-static inline void crypto_cipher_set_flags(struct crypto_cipher *tfm,
-					   u32 flags)
-{
-	crypto_tfm_set_flags(crypto_cipher_tfm(tfm), flags);
-}
-
-static inline void crypto_cipher_clear_flags(struct crypto_cipher *tfm,
-					     u32 flags)
-{
-	crypto_tfm_clear_flags(crypto_cipher_tfm(tfm), flags);
-}
-
-/**
- * crypto_cipher_setkey() - set key for cipher
- * @tfm: cipher handle
- * @key: buffer holding the key
- * @keylen: length of the key in bytes
- *
- * The caller provided key is set for the single block cipher referenced by the
- * cipher handle.
- *
- * Note, the key length determines the cipher type. Many block ciphers implement
- * different cipher modes depending on the key size, such as AES-128 vs AES-192
- * vs. AES-256. When providing a 16 byte key for an AES cipher handle, AES-128
- * is performed.
- *
- * Return: 0 if the setting of the key was successful; < 0 if an error occurred
- */
-int crypto_cipher_setkey(struct crypto_cipher *tfm,
-			 const u8 *key, unsigned int keylen);
-
-/**
- * crypto_cipher_encrypt_one() - encrypt one block of plaintext
- * @tfm: cipher handle
- * @dst: points to the buffer that will be filled with the ciphertext
- * @src: buffer holding the plaintext to be encrypted
- *
- * Invoke the encryption operation of one block. The caller must ensure that
- * the plaintext and ciphertext buffers are at least one block in size.
- */
-void crypto_cipher_encrypt_one(struct crypto_cipher *tfm,
-			       u8 *dst, const u8 *src);
-
-/**
- * crypto_cipher_decrypt_one() - decrypt one block of ciphertext
- * @tfm: cipher handle
- * @dst: points to the buffer that will be filled with the plaintext
- * @src: buffer holding the ciphertext to be decrypted
- *
- * Invoke the decryption operation of one block. The caller must ensure that
- * the plaintext and ciphertext buffers are at least one block in size.
- */
-void crypto_cipher_decrypt_one(struct crypto_cipher *tfm,
-			       u8 *dst, const u8 *src);
-
 static inline struct crypto_comp *__crypto_comp_cast(struct crypto_tfm *tfm)
 {
 	return (struct crypto_comp *)tfm;
-- 
2.17.1

