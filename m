Return-Path: <SRS0=AsAY=B5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BDDCC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Aug 2020 11:58:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 212CC2072D
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Aug 2020 11:58:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgHSL6r (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Aug 2020 07:58:47 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:45812 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728449AbgHSL6X (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Aug 2020 07:58:23 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1k8MjU-0003A7-C0; Wed, 19 Aug 2020 21:58:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 19 Aug 2020 21:58:20 +1000
Date:   Wed, 19 Aug 2020 21:58:20 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>
Subject: [v3 PATCH] crypto: algapi - Remove skbuff.h inclusion
Message-ID: <20200819115820.GA19411@gondor.apana.org.au>
References: <20200611142133.GA11754@gondor.apana.org.au>
 <20200612070912.GA5893@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200612070912.GA5893@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

v3

Add sizes.h to arch/x86/crypto glue code.

---8<---
The header file algapi.h includes skbuff.h unnecessarily since
all we need is a forward declaration for struct sk_buff.  This
patch removes that inclusion.

Unfortunately skbuff.h pulls in a lot of things and drivers over
the years have come to rely on it so this patch adds a lot of
missing inclusions that result from this.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/powerpc/crypto/crc-vpmsum_test.c b/arch/powerpc/crypto/crc-vpmsum_test.c
index dce86e75f1a8..8014cc48b62b 100644
--- a/arch/powerpc/crypto/crc-vpmsum_test.c
+++ b/arch/powerpc/crypto/crc-vpmsum_test.c
@@ -9,6 +9,7 @@
 #include <crypto/internal/hash.h>
 #include <linux/init.h>
 #include <linux/module.h>
+#include <linux/random.h>
 #include <linux/string.h>
 #include <linux/kernel.h>
 #include <linux/cpufeature.h>
diff --git a/arch/x86/crypto/blake2s-glue.c b/arch/x86/crypto/blake2s-glue.c
index 6737bcea1fa1..c025a01cf708 100644
--- a/arch/x86/crypto/blake2s-glue.c
+++ b/arch/x86/crypto/blake2s-glue.c
@@ -11,6 +11,7 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/sizes.h>
 
 #include <asm/cpufeature.h>
 #include <asm/fpu/api.h>
diff --git a/arch/x86/crypto/chacha_glue.c b/arch/x86/crypto/chacha_glue.c
index e67a59130025..7b3a1cf0984b 100644
--- a/arch/x86/crypto/chacha_glue.c
+++ b/arch/x86/crypto/chacha_glue.c
@@ -12,6 +12,7 @@
 #include <crypto/internal/skcipher.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/sizes.h>
 #include <asm/simd.h>
 
 asmlinkage void chacha_block_xor_ssse3(u32 *state, u8 *dst, const u8 *src,
diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index 8acbb6584a37..50bf06876f8c 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -11,6 +11,7 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/scatterlist.h>
 
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
diff --git a/arch/x86/crypto/nhpoly1305-avx2-glue.c b/arch/x86/crypto/nhpoly1305-avx2-glue.c
index 80fcb85736e1..8ea5ab0f1ca7 100644
--- a/arch/x86/crypto/nhpoly1305-avx2-glue.c
+++ b/arch/x86/crypto/nhpoly1305-avx2-glue.c
@@ -10,6 +10,7 @@
 #include <crypto/internal/simd.h>
 #include <crypto/nhpoly1305.h>
 #include <linux/module.h>
+#include <linux/sizes.h>
 #include <asm/simd.h>
 
 asmlinkage void nh_avx2(const u32 *key, const u8 *message, size_t message_len,
diff --git a/arch/x86/crypto/nhpoly1305-sse2-glue.c b/arch/x86/crypto/nhpoly1305-sse2-glue.c
index cc6b7c1a2705..2b353d42ed13 100644
--- a/arch/x86/crypto/nhpoly1305-sse2-glue.c
+++ b/arch/x86/crypto/nhpoly1305-sse2-glue.c
@@ -10,6 +10,7 @@
 #include <crypto/internal/simd.h>
 #include <crypto/nhpoly1305.h>
 #include <linux/module.h>
+#include <linux/sizes.h>
 #include <asm/simd.h>
 
 asmlinkage void nh_sse2(const u32 *key, const u8 *message, size_t message_len,
diff --git a/arch/x86/crypto/poly1305_glue.c b/arch/x86/crypto/poly1305_glue.c
index dfe921efa9b2..f85885d6ccd8 100644
--- a/arch/x86/crypto/poly1305_glue.c
+++ b/arch/x86/crypto/poly1305_glue.c
@@ -11,6 +11,7 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/sizes.h>
 #include <asm/intel-family.h>
 #include <asm/simd.h>
 
diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 198a8eb1cd56..d2ec3ff9bc1e 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -9,6 +9,7 @@
 
 #include <linux/err.h>
 #include <linux/delay.h>
+#include <linux/device.h>
 #include <crypto/engine.h>
 #include <uapi/linux/sched/types.h>
 #include "internal.h"
diff --git a/crypto/ecrdsa.c b/crypto/ecrdsa.c
index 887ec21aee49..6a3fd09057d0 100644
--- a/crypto/ecrdsa.c
+++ b/crypto/ecrdsa.c
@@ -22,6 +22,7 @@
 #include <crypto/internal/akcipher.h>
 #include <crypto/akcipher.h>
 #include <linux/oid_registry.h>
+#include <linux/scatterlist.h>
 #include "ecrdsa_params.asn1.h"
 #include "ecrdsa_pub_key.asn1.h"
 #include "ecc.h"
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index eb7d1dd506bf..e8a4165a1874 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -37,11 +37,11 @@
  * DAMAGE.
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/fips.h>
 #include <linux/time.h>
-#include <linux/crypto.h>
 #include <crypto/internal/rng.h>
 
 #include "jitterentropy.h"
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index ddd3d10ffc15..8ac3e73e8ea6 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/random.h>
+#include <linux/scatterlist.h>
 
 /*
  * Hash algorithm OIDs plus ASN.1 DER wrappings [RFC4880 sec 5.2.2].
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 23c27fc96394..66ee3bbc9872 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -27,6 +27,7 @@
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
 #include <linux/string.h>
+#include <linux/uio.h>
 #include <crypto/rng.h>
 #include <crypto/drbg.h>
 #include <crypto/akcipher.h>
diff --git a/drivers/crypto/amcc/crypto4xx_core.h b/drivers/crypto/amcc/crypto4xx_core.h
index 6b6841359190..a4e25b46cd0a 100644
--- a/drivers/crypto/amcc/crypto4xx_core.h
+++ b/drivers/crypto/amcc/crypto4xx_core.h
@@ -15,6 +15,7 @@
 
 #include <linux/ratelimit.h>
 #include <linux/mutex.h>
+#include <linux/scatterlist.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/aead.h>
 #include <crypto/internal/rng.h>
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index bd270e66185e..4e9059c5fbb5 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -8,6 +8,7 @@
  * Author: Gary R Hook <gary.hook@amd.com>
  */
 
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/interrupt.h>
diff --git a/drivers/crypto/img-hash.c b/drivers/crypto/img-hash.c
index 87226b7c2795..91f555ccbb31 100644
--- a/drivers/crypto/img-hash.c
+++ b/drivers/crypto/img-hash.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
diff --git a/drivers/crypto/marvell/cesa/cesa.h b/drivers/crypto/marvell/cesa/cesa.h
index 0c9cbb681e49..48cab49d2c44 100644
--- a/drivers/crypto/marvell/cesa/cesa.h
+++ b/drivers/crypto/marvell/cesa/cesa.h
@@ -2,12 +2,10 @@
 #ifndef __MARVELL_CESA_H__
 #define __MARVELL_CESA_H__
 
-#include <crypto/algapi.h>
-#include <crypto/hash.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
-#include <linux/crypto.h>
+#include <linux/dma-direction.h>
 #include <linux/dmapool.h>
 
 #define CESA_ENGINE_OFF(i)			(((i) * 0x2000))
diff --git a/drivers/crypto/marvell/cesa/cipher.c b/drivers/crypto/marvell/cesa/cipher.c
index 45b4d7a29833..4f4e1d055cb8 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -11,6 +11,8 @@
 
 #include <crypto/aes.h>
 #include <crypto/internal/des.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
 
 #include "cesa.h"
 
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index f2a2fc111164..90cb50c76491 100644
--- a/drivers/crypto/marvell/cesa/hash.c
+++ b/drivers/crypto/marvell/cesa/hash.c
@@ -12,6 +12,8 @@
 #include <crypto/hmac.h>
 #include <crypto/md5.h>
 #include <crypto/sha.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
 
 #include "cesa.h"
 
diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 62c6fe88b212..1be549a07a21 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -18,6 +18,7 @@
 #include <linux/errno.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
+#include <linux/mm.h>
 #include <linux/percpu.h>
 #include <linux/smp.h>
 #include <linux/slab.h>
diff --git a/drivers/crypto/qce/core.c b/drivers/crypto/qce/core.c
index cb6d61eb7302..ea616b7259ae 100644
--- a/drivers/crypto/qce/core.c
+++ b/drivers/crypto/qce/core.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/clk.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
 #include <linux/mod_devicetable.h>
diff --git a/drivers/crypto/qce/sha.c b/drivers/crypto/qce/sha.c
index c230843e2ffb..87be96a0b0bb 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <crypto/internal/hash.h>
 
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 5630c5addd28..a2d3da0ad95f 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
diff --git a/drivers/crypto/qcom-rng.c b/drivers/crypto/qcom-rng.c
index 4730f84b646d..99ba8d51d102 100644
--- a/drivers/crypto/qcom-rng.c
+++ b/drivers/crypto/qcom-rng.c
@@ -7,6 +7,7 @@
 #include <linux/acpi.h>
 #include <linux/clk.h>
 #include <linux/crypto.h>
+#include <linux/io.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
diff --git a/drivers/crypto/rockchip/rk3288_crypto.c b/drivers/crypto/rockchip/rk3288_crypto.c
index f385587f99af..35d73061d156 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.c
+++ b/drivers/crypto/rockchip/rk3288_crypto.c
@@ -10,6 +10,7 @@
  */
 
 #include "rk3288_crypto.h"
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/of.h>
diff --git a/drivers/crypto/rockchip/rk3288_crypto.h b/drivers/crypto/rockchip/rk3288_crypto.h
index 2b49c677afdb..3db595570c9c 100644
--- a/drivers/crypto/rockchip/rk3288_crypto.h
+++ b/drivers/crypto/rockchip/rk3288_crypto.h
@@ -7,6 +7,7 @@
 #include <crypto/algapi.h>
 #include <linux/interrupt.h>
 #include <linux/delay.h>
+#include <linux/scatterlist.h>
 #include <crypto/internal/hash.h>
 #include <crypto/internal/skcipher.h>
 
diff --git a/drivers/crypto/rockchip/rk3288_crypto_ahash.c b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
index 6b7ecbec092e..81befe7febaa 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_ahash.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_ahash.c
@@ -8,6 +8,7 @@
  *
  * Some ideas are from marvell/cesa.c and s5p-sss.c driver.
  */
+#include <linux/device.h>
 #include "rk3288_crypto.h"
 
 /*
diff --git a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
index 4a75c8e1fa6c..1cece1a7d3f0 100644
--- a/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
+++ b/drivers/crypto/rockchip/rk3288_crypto_skcipher.c
@@ -8,6 +8,7 @@
  *
  * Some ideas are from marvell-cesa.c and s5p-sss.c driver.
  */
+#include <linux/device.h>
 #include "rk3288_crypto.h"
 
 #define RK_CRYPTO_DEC			BIT(0)
diff --git a/drivers/crypto/sahara.c b/drivers/crypto/sahara.c
index 0c8cb23ae708..d60679c79822 100644
--- a/drivers/crypto/sahara.c
+++ b/drivers/crypto/sahara.c
@@ -18,7 +18,7 @@
 #include <crypto/sha.h>
 
 #include <linux/clk.h>
-#include <linux/crypto.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
 #include <linux/irq.h>
diff --git a/drivers/crypto/ux500/cryp/cryp_core.c b/drivers/crypto/ux500/cryp/cryp_core.c
index 800dfc4d16c4..e64e764bb035 100644
--- a/drivers/crypto/ux500/cryp/cryp_core.c
+++ b/drivers/crypto/ux500/cryp/cryp_core.c
@@ -11,7 +11,8 @@
 
 #include <linux/clk.h>
 #include <linux/completion.h>
-#include <linux/crypto.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/dmaengine.h>
 #include <linux/err.h>
 #include <linux/errno.h>
@@ -27,7 +28,6 @@
 #include <linux/platform_data/dma-ste-dma40.h>
 
 #include <crypto/aes.h>
-#include <crypto/algapi.h>
 #include <crypto/ctr.h>
 #include <crypto/internal/des.h>
 #include <crypto/internal/skcipher.h>
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index a5ee8c2fb4e0..c231d3710f83 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -15,6 +15,7 @@
 
 #include <linux/clk.h>
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/err.h>
 #include <linux/init.h>
 #include <linux/io.h>
diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index 27079354dbe9..bf1f421e05f2 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -10,6 +10,7 @@
 #include <crypto/internal/aead.h>
 #include <crypto/scatterwalk.h>
 
+#include <linux/dma-mapping.h>
 #include <linux/module.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
diff --git a/include/crypto/algapi.h b/include/crypto/algapi.h
index 99fcb2d7a831..18dd7a4aaf7d 100644
--- a/include/crypto/algapi.h
+++ b/include/crypto/algapi.h
@@ -10,7 +10,6 @@
 #include <linux/crypto.h>
 #include <linux/list.h>
 #include <linux/kernel.h>
-#include <linux/skbuff.h>
 
 /*
  * Maximum values for blocksize and alignmask, used to allocate
@@ -27,6 +26,7 @@ struct crypto_instance;
 struct module;
 struct rtattr;
 struct seq_file;
+struct sk_buff;
 
 struct crypto_type {
 	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
