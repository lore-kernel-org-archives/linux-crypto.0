Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80E3C28CF5
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 07:07:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbiAZHHY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 02:07:24 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:41793 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiAZHHX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 02:07:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643180839;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=kKMeQ4jbF2RlwL77OU3Y0p14ptPgkI8XQ+SVVGGN4cQ=;
    b=bRrUL/ly8ep2ngLTlSwiQF72bS8kJe6ZpTKou/po8G9gQ8BMM54iJqd1+e2Yr0708B
    8Xy7TPYje/lC4QsXfmLM4MuG/vbOEPW9BrfcWnt0gqg9vsQbIRYJZZaJ0KegQWA/ce7w
    b9rKZPx2/w4Oxtlp+Y0T9//z6PWvKEgtF6hHe36zST1laySy45Fvt9cWsTWR3AARxsmD
    zXC5XAvz8+hXgXg54gOFDowybTownaua7Z7cx/OdyMlVECG1kj/7mdA1m7HawIm+6J2T
    YE2x9/g2zQiyeAakoXTpUwun+EkCNFmxKv/zqyeWCvrjfHTnlqPWcdAn5TN3418rxfKO
    zGsw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvScdWrN"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
    with ESMTPSA id v5f65ay0Q77IiuM
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 26 Jan 2022 08:07:18 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH 7/7] crypto: ESDM - add kernel crypto API RNG interface
Date:   Wed, 26 Jan 2022 08:05:29 +0100
Message-ID: <3328650.KVeVyVuyWN@positron.chronox.de>
In-Reply-To: <2486550.t9SDvczpPo@positron.chronox.de>
References: <2486550.t9SDvczpPo@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The ESDM export interfaces that allow obtaining random numbers from a
fully seeded DRNG as specified in crypto/esdm.h. By using the interface
function esdm_get_random_bytes_full, the ESDM is registered as a random
number generator with the kernel crypto API's RNG framework. This
registered RNG provides random numbers from an always appropriately
seeded and initialized DRNG.

When a caller performs a crypto_rng_reset() call on the ESDM, the ESDM
injects the provided data into the auxiliary pool and flags a reseed.
This reseed is performed by the immediate subsequent DRNG generation
operation.

The RNG registered by the ESDM with the kernel crypto API is accessible
via the name "esdm". In addition, the ESDM is registered as "stdrng"
with the highest priority which implies that the kernel crypto API call
of crypto_get_default_rng accesses the ESDM.

The ESDM is marked as fips_allowed = 1 in the testmgr because it
complies with the FIPS 140 rules as follows:

- SP800-90A: The ESDM uses the kernel crypto API's DRBG and thus
  provides access to a fully seeded and SP800-90A DRBG.

- SP800-90B: The ESDM manages entropy sources via its plugins. Currently
  there is no internal entropy source provided which means that the used
  entropy sources must provide their own SP800-90B analysis. For the
  Jitter RNG, a separate SP800-90B analysis is provided. The ESDM only
  ensures that the Jitter RNG is appropriately initialized before it is
  used as an entropy source. The kernel RNG (random.c) entropy source on
  the other hand is not SP800-90B compliant. Thus, in FIPS mode, the
  ESDM credits its data with zero bits of entropy.

- SP800-90C: The ESDM follows the current draft of SP800-90C when
  compiled with the option CONFIG_CRYPTO_ESDM_OVERSAMPLE_ENTROPY_SOURCES.
  The DRBG is initially seeded with at least 384 bits of entropy before
  it is marked as fully seeded (and thus produces random numbers via the
  esdm_get_random_bytes_full call. Subsequent reseeds are performed with
  at least 256 bits of entropy. The conditioning operation performed in
  the auxiliary pool requires 64 more bits of entropy to be fed into the
  conditioner function provide the respective entropy output (e.g. 256
  bits of entropy are fed into the SHA-256 conditioner resulting in the
  output of 192 bits of entropy provided by the entropy source to the
  ESDM). With the given entropy sources, the ESDM follows the RBG2(NP)
  construction method.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/esdm/Kconfig                | 14 +++++
 crypto/esdm/Makefile               |  2 +
 crypto/esdm/esdm_drng_kcapi.c      |  1 +
 crypto/esdm/esdm_interface_kcapi.c | 91 ++++++++++++++++++++++++++++++
 crypto/testmgr.c                   |  8 +++
 5 files changed, 116 insertions(+)
 create mode 100644 crypto/esdm/esdm_interface_kcapi.c

diff --git a/crypto/esdm/Kconfig b/crypto/esdm/Kconfig
index 43e11484e95c..3636c1c79602 100644
--- a/crypto/esdm/Kconfig
+++ b/crypto/esdm/Kconfig
@@ -27,6 +27,20 @@ config CRYPTO_ESDM_SHA256
 	bool
 	default y if CRYPTO_LIB_SHA256
 
+menu "ESDM Interfaces"
+
+config CRYPTO_ESDM_KCAPI_IF
+	tristate "Interface with Kernel Crypto API"
+	depends on CRYPTO_RNG
+	help
+	  The ESDM can be registered with the kernel crypto API's
+	  random number generator framework. This offers a random
+	  number generator with the name "esdm" and a priority that
+	  is intended to be higher than the existing RNG
+	  implementations.
+
+endmenu # "ESDM Interfaces"
+
 menu "Specific DRNG seeding strategies"
 
 config CRYPTO_ESDM_OVERSAMPLE_ENTROPY_SOURCES
diff --git a/crypto/esdm/Makefile b/crypto/esdm/Makefile
index 404436de0aa2..0bf8d65dd5fa 100644
--- a/crypto/esdm/Makefile
+++ b/crypto/esdm/Makefile
@@ -11,3 +11,5 @@ obj-$(CONFIG_CRYPTO_ESDM_DRNG_KCAPI)	+= esdm_drng_kcapi.o
 
 obj-$(CONFIG_CRYPTO_ESDM_KERNEL_RNG)	+= esdm_es_krng.o
 obj-$(CONFIG_CRYPTO_ESDM_JENT)		+= esdm_es_jent.o
+
+obj-$(CONFIG_CRYPTO_ESDM_KCAPI_IF)	+= esdm_interface_kcapi.o
diff --git a/crypto/esdm/esdm_drng_kcapi.c b/crypto/esdm/esdm_drng_kcapi.c
index ae8d2be91b37..03135337196b 100644
--- a/crypto/esdm/esdm_drng_kcapi.c
+++ b/crypto/esdm/esdm_drng_kcapi.c
@@ -99,6 +99,7 @@ static void *esdm_kcapi_drng_alloc(u32 sec_strength)
 	}
 
 	if (!memcmp(drng_name, "stdrng", 6) ||
+	    !memcmp(drng_name, "esdm", 4) ||
 	    !memcmp(drng_name, "jitterentropy_rng", 17)) {
 		pr_err("Refusing to load the requested random number generator\n");
 		return ERR_PTR(-EINVAL);
diff --git a/crypto/esdm/esdm_interface_kcapi.c b/crypto/esdm/esdm_interface_kcapi.c
new file mode 100644
index 000000000000..f2968d83c991
--- /dev/null
+++ b/crypto/esdm/esdm_interface_kcapi.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * ESDM interface with the RNG framework of the kernel crypto API
+ *
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#include <crypto/esdm.h>
+#include <linux/module.h>
+#include <crypto/internal/rng.h>
+
+#include "esdm_drng_mgr.h"
+#include "esdm_es_aux.h"
+
+static int esdm_kcapi_if_init(struct crypto_tfm *tfm)
+{
+	return 0;
+}
+
+static void esdm_kcapi_if_cleanup(struct crypto_tfm *tfm) { }
+
+static int esdm_kcapi_if_reseed(const u8 *src, unsigned int slen)
+{
+	int ret;
+
+	if (!slen)
+		return 0;
+
+	/* Insert caller-provided data without crediting entropy */
+	ret = esdm_pool_insert_aux((u8 *)src, slen, 0);
+	if (ret)
+		return ret;
+
+	/* Make sure the new data is immediately available to DRNG */
+	esdm_drng_force_reseed();
+
+	return 0;
+}
+
+static int esdm_kcapi_if_random(struct crypto_rng *tfm,
+				const u8 *src, unsigned int slen,
+				u8 *rdata, unsigned int dlen)
+{
+	int ret = esdm_kcapi_if_reseed(src, slen);
+
+	if (!ret)
+		esdm_get_random_bytes_full(rdata, dlen);
+
+	return ret;
+}
+
+static int esdm_kcapi_if_reset(struct crypto_rng *tfm,
+			       const u8 *seed, unsigned int slen)
+{
+	return esdm_kcapi_if_reseed(seed, slen);
+}
+
+static struct rng_alg esdm_alg = {
+	.generate		= esdm_kcapi_if_random,
+	.seed			= esdm_kcapi_if_reset,
+	.seedsize		= 0,
+	.base			= {
+		.cra_name               = "stdrng",
+		.cra_driver_name        = "esdm",
+		.cra_priority           = 500,
+		.cra_ctxsize            = 0,
+		.cra_module             = THIS_MODULE,
+		.cra_init               = esdm_kcapi_if_init,
+		.cra_exit               = esdm_kcapi_if_cleanup,
+
+	}
+};
+
+static int __init esdm_kcapi_if_mod_init(void)
+{
+	return crypto_register_rng(&esdm_alg);
+}
+
+static void __exit esdm_kcapi_if_mod_exit(void)
+{
+	crypto_unregister_rng(&esdm_alg);
+}
+
+module_init(esdm_kcapi_if_mod_init);
+module_exit(esdm_kcapi_if_mod_exit);
+
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("Entropy Source and DRNG Manager kernel crypto API RNG framework interface");
+MODULE_ALIAS_CRYPTO("esdm");
+MODULE_ALIAS_CRYPTO("stdrng");
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 2ce698eb14b6..0865105f9377 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4878,6 +4878,14 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.akcipher = __VECS(ecrdsa_tv_template)
 		}
+	}, {
+		.alg = "esdm",
+		.test = alg_test_null,
+#ifdef CONFIG_CRYPTO_ESDM_OVERSAMPLE_ENTROPY_SOURCES
+		.fips_allowed = 1,
+#else
+		.fips_allowed = 0,
+#endif
 	}, {
 		.alg = "essiv(authenc(hmac(sha256),cbc(aes)),sha256)",
 		.test = alg_test_aead,
-- 
2.33.1




