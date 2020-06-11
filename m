Return-Path: <SRS0=adZw=7Y=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3F0C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 14:21:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0ECEB2065C
	for <linux-crypto@archiver.kernel.org>; Thu, 11 Jun 2020 14:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgFKOVg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jun 2020 10:21:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:35128 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726277AbgFKOVg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jun 2020 10:21:36 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jjO5F-0003kn-Mu; Fri, 12 Jun 2020 00:21:34 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 12 Jun 2020 00:21:33 +1000
Date:   Fri, 12 Jun 2020 00:21:33 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: algapi - Remove skbuff.h inclusion
Message-ID: <20200611142133.GA11754@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The header file algapi.h includes skbuff.h unnecessarily since
all we need is a forward declaration for struct sk_buff.  This
patch removes that inclusion.

Unfortunately skbuff.h pulls in a lot of things and drivers over
the years have come to rely on it so this patch adds a lot of
missing inclusions that result from this.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
index 8a17621f7d3a..e9069f14efec 100644
--- a/arch/x86/crypto/curve25519-x86_64.c
+++ b/arch/x86/crypto/curve25519-x86_64.c
@@ -11,6 +11,7 @@
 #include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/scatterlist.h>
 
 #include <asm/cpufeature.h>
 #include <asm/processor.h>
diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 3655d9d3f5df..6891f670cd3e 100644
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
index b43684c0dade..5b94343de837 100644
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
index d31031de51bc..1e4b32a1dc30 100644
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
index 6863f911fcee..a75c00b8cae0 100644
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
index 422193690fd4..409949338e85 100644
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
index 0e25fc3087f3..ba93a76936e3 100644
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
index e8632d5f343f..6edbe682a84f 100644
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
index f133c2ccb5ae..bf820a6dd695 100644
--- a/drivers/crypto/marvell/cesa/cipher.c
+++ b/drivers/crypto/marvell/cesa/cipher.c
@@ -11,6 +11,8 @@
 
 #include <crypto/aes.h>
 #include <crypto/internal/des.h>
+#include <linux/device.h>
+#include <linux/dma-mapping.h>
 
 #include "cesa.h"
 
diff --git a/drivers/crypto/marvell/cesa/hash.c b/drivers/crypto/marvell/cesa/hash.c
index b971284332b6..ca11816c3981 100644
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
index 1ab62e7d5f3c..4f78828e075e 100644
--- a/drivers/crypto/qce/sha.c
+++ b/drivers/crypto/qce/sha.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <crypto/internal/hash.h>
 
diff --git a/drivers/crypto/qce/skcipher.c b/drivers/crypto/qce/skcipher.c
index 9412433f3b21..428080f1a385 100644
--- a/drivers/crypto/qce/skcipher.c
+++ b/drivers/crypto/qce/skcipher.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/device.h>
+#include <linux/dma-mapping.h>
 #include <linux/interrupt.h>
 #include <linux/moduleparam.h>
 #include <linux/types.h>
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
index 466e30bd529c..138d60a841f2 100644
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
index c24f2db8d5e8..f40fda40ee7a 100644
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
index 09f7f468eef8..ed777f40bf4f 100644
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
index 00a9cf98debe..8287c7aa9fb1 100644
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
