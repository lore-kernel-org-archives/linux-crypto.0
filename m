Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9F8C28CF5
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 07:07:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237559AbiAZHH1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 02:07:27 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:37203 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237560AbiAZHHZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 02:07:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643180840;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=5W8dF4J0+VsTtyaYaW6dTsomv2iFvEugHmuG4DR/nr8=;
    b=YMInTWCflU2sk4Ok8eDtpowV/5SAv/Jl9F9YUs0f/vY2hMX5Mc0uOqPBVruNdzieC3
    i0xomDaRsrphO91RKqXjTObiDM1Xyull6gSPuaDJvWYPLdNOEt6+UJScMxw5pyq8THY0
    mr6flCvzT2PMzRgSAcmuDdu1S2uN+Wr0QYq34vsfU0ub154U5AKpP3j2ePqXBKTgctZ6
    4pPcin5eZMrIDTeKs5zryUy+ilEutoe9lnQWtq3nYBdCIRSDL3lAn8pyD3RJ/ZEJ0GIX
    ldIMT5tZBu0WobFapfpH6OmQUQrtfh5++2hQUKpxTsvb9yyQCYbQ/Y9ouyWG7+9eZZOD
    pIqQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvScdWrN"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
    with ESMTPSA id v5f65ay0Q77JiuO
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 26 Jan 2022 08:07:19 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH 5/7] crypto: ESDM - add Jitter RNG entropy source
Date:   Wed, 26 Jan 2022 08:04:44 +0100
Message-ID: <5596750.E0xQCEvomI@positron.chronox.de>
In-Reply-To: <2486550.t9SDvczpPo@positron.chronox.de>
References: <2486550.t9SDvczpPo@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Jitter RNG entropy source provided as part of the kernel crypto API
is used as a separate entropy source for the ESDM. It can be enabled at
compile time together with its implied entropy rate.

The entropy rate states how many bits of entropy are present in 256 bits
of data from that entropy source. If a different amount of data is
pulled from the entropy source, the entropy ratio is scaled accordingly.

In FIPS mode, the amount of entropy is set to 256 bits considering that
this entropy source is provided with an entropy analysis demonstrating
its compliance with SP800-90B and thus allowing to claim full strength.

When the entropy ratio is set to zero, the Jitter RNG provides data but
without claiming any entropy for it.

In addition, the patch offers the compile time option to allow setting
the entropy rate with the kernel command line using the parameter of
esdm_es_jent.jent_entropy.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/esdm/Kconfig          |  45 ++++++++++++
 crypto/esdm/Makefile         |   2 +
 crypto/esdm/esdm_es_jent.c   | 128 +++++++++++++++++++++++++++++++++++
 crypto/esdm/esdm_es_jent.h   |  17 +++++
 crypto/esdm/esdm_es_mgr.c    |   4 ++
 crypto/esdm/esdm_es_mgr_cb.h |   3 +
 6 files changed, 199 insertions(+)
 create mode 100644 crypto/esdm/esdm_es_jent.c
 create mode 100644 crypto/esdm/esdm_es_jent.h

diff --git a/crypto/esdm/Kconfig b/crypto/esdm/Kconfig
index 1351d4d146dc..eeef71546bc3 100644
--- a/crypto/esdm/Kconfig
+++ b/crypto/esdm/Kconfig
@@ -68,6 +68,51 @@ config CRYPTO_ESDM_SEED_BUFFER_INIT_ADD_BITS
 
 endmenu # "Specific DRNG seeding strategies"
 
+menu "Entropy Source Configuration"
+
+config CRYPTO_ESDM_RUNTIME_ES_CONFIG
+	bool "Enable runtime configuration of entropy sources"
+	help
+	  When enabling this option, the ESDM provides the mechanism
+	  allowing to alter the entropy rate of each entropy source
+	  during boot time and runtime.
+
+	  Each entropy source allows its entropy rate changed with
+	  a kernel command line option. When not providing any
+	  option, the default specified during kernel compilation
+	  is applied.
+
+comment "Jitter RNG Entropy Source"
+
+config CRYPTO_ESDM_JENT
+	bool "Enable Jitter RNG as ESDM Seed Source"
+	depends on CRYPTO
+	select CRYPTO_JITTERENTROPY
+	help
+	  The Linux RNG may use the Jitter RNG as entropy source. Enabling
+	  this option enables the use of the Jitter RNG. Its default
+	  entropy level is 16 bits of entropy per 256 data bits delivered
+	  by the Jitter RNG. This entropy level can be changed at boot
+	  time or at runtime with the esdm_base.jitterrng configuration
+	  variable.
+
+config CRYPTO_ESDM_JENT_ENTROPY_RATE
+	int "Jitter RNG Entropy Source Entropy Rate"
+	depends on CRYPTO_ESDM_JENT
+	range 0 256
+	default 16
+	help
+	  The option defines the amount of entropy the ESDM applies to 256
+	  bits of data obtained from the Jitter RNG entropy source. The
+	  ESDM enforces the limit that this value must be in the range
+	  between 0 and 256.
+
+	  When configuring this value to 0, the Jitter RNG entropy source
+	  will provide 256 bits of data without being credited to contain
+	  entropy.
+
+endmenu # "Entropy Source Configuration"
+
 config CRYPTO_ESDM_DRNG_KCAPI
 	bool
 	depends on CRYPTO
diff --git a/crypto/esdm/Makefile b/crypto/esdm/Makefile
index 24dc7af234b6..99a86ce3e3af 100644
--- a/crypto/esdm/Makefile
+++ b/crypto/esdm/Makefile
@@ -8,3 +8,5 @@ obj-y					+= esdm_es_mgr.o esdm_drng_mgr.o \
 obj-$(CONFIG_CRYPTO_ESDM_SHA256)	+= esdm_sha256.o
 
 obj-$(CONFIG_CRYPTO_ESDM_DRNG_KCAPI)	+= esdm_drng_kcapi.o
+
+obj-$(CONFIG_CRYPTO_ESDM_JENT)		+= esdm_es_jent.o
diff --git a/crypto/esdm/esdm_es_jent.c b/crypto/esdm/esdm_es_jent.c
new file mode 100644
index 000000000000..8cbd649e8f42
--- /dev/null
+++ b/crypto/esdm/esdm_es_jent.c
@@ -0,0 +1,128 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * ESDM Fast Entropy Source: Jitter RNG
+ *
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/fips.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <crypto/internal/jitterentropy.h>
+
+#include "esdm_definitions.h"
+#include "esdm_es_aux.h"
+#include "esdm_es_jent.h"
+
+/*
+ * Estimated entropy of data is a 16th of ESDM_DRNG_SECURITY_STRENGTH_BITS.
+ * Albeit a full entropy assessment is provided for the noise source indicating
+ * that it provides high entropy rates and considering that it deactivates
+ * when it detects insufficient hardware, the chosen under estimation of
+ * entropy is considered to be acceptable to all reviewers.
+ */
+static u32 jent_entropy = CONFIG_CRYPTO_ESDM_JENT_ENTROPY_RATE;
+#ifdef CONFIG_CRYPTO_ESDM_RUNTIME_ES_CONFIG
+module_param(jent_entropy, uint, 0644);
+MODULE_PARM_DESC(jent_entropy, "Entropy in bits of 256 data bits from Jitter RNG noise source");
+#endif
+
+static bool esdm_jent_initialized = false;
+static struct rand_data *esdm_jent_state;
+
+static int __init esdm_jent_initialize(void)
+{
+	/* Initialize the Jitter RNG after the clocksources are initialized. */
+	if (jent_entropy_init() ||
+	    (esdm_jent_state = jent_entropy_collector_alloc(1, 0)) == NULL) {
+		jent_entropy = 0;
+		pr_info("Jitter RNG unusable on current system\n");
+		return 0;
+	}
+	esdm_jent_initialized = true;
+	pr_debug("Jitter RNG working on current system\n");
+
+	/* In FIPS mode, the Jitter RNG is defined to have full of entropy */
+	if (fips_enabled)
+		jent_entropy = ESDM_DRNG_SECURITY_STRENGTH_BITS;
+
+	esdm_drng_force_reseed();
+	if (jent_entropy)
+		esdm_es_add_entropy();
+
+	return 0;
+}
+device_initcall(esdm_jent_initialize);
+
+static u32 esdm_jent_entropylevel(u32 requested_bits)
+{
+	return esdm_fast_noise_entropylevel(esdm_jent_initialized ?
+					    jent_entropy : 0, requested_bits);
+}
+
+static u32 esdm_jent_poolsize(void)
+{
+	return esdm_jent_entropylevel(esdm_security_strength());
+}
+
+
+/*
+ * esdm_get_jent() - Get Jitter RNG entropy
+ *
+ * @eb: entropy buffer to store entropy
+ * @requested_bits: requested entropy in bits
+ */
+static void esdm_jent_get(struct entropy_buf *eb, u32 requested_bits,
+			  bool __unused)
+{
+	int ret;
+	u32 ent_bits = esdm_jent_entropylevel(requested_bits);
+	unsigned long flags;
+	static DEFINE_SPINLOCK(esdm_jent_lock);
+
+	spin_lock_irqsave(&esdm_jent_lock, flags);
+
+	if (!esdm_jent_initialized) {
+		spin_unlock_irqrestore(&esdm_jent_lock, flags);
+		goto err;
+	}
+
+	ret = jent_read_entropy(esdm_jent_state, eb->e[esdm_ext_es_jitter],
+				requested_bits >> 3);
+	spin_unlock_irqrestore(&esdm_jent_lock, flags);
+
+	if (ret) {
+		pr_debug("Jitter RNG failed with %d\n", ret);
+		goto err;
+	}
+
+	pr_debug("obtained %u bits of entropy from Jitter RNG noise source\n",
+		 ent_bits);
+
+	eb->e_bits[esdm_ext_es_jitter] = ent_bits;
+	return;
+
+err:
+	eb->e_bits[esdm_ext_es_jitter] = 0;
+}
+
+static void esdm_jent_es_state(unsigned char *buf, size_t buflen)
+{
+	snprintf(buf, buflen,
+		 " Available entropy: %u\n"
+		 " Enabled: %s\n",
+		 esdm_jent_poolsize(),
+		 esdm_jent_initialized ? "true" : "false");
+}
+
+struct esdm_es_cb esdm_es_jent = {
+	.name			= "JitterRNG",
+	.get_ent		= esdm_jent_get,
+	.curr_entropy		= esdm_jent_entropylevel,
+	.max_entropy		= esdm_jent_poolsize,
+	.state			= esdm_jent_es_state,
+	.reset			= NULL,
+	.switch_hash		= NULL,
+};
diff --git a/crypto/esdm/esdm_es_jent.h b/crypto/esdm/esdm_es_jent.h
new file mode 100644
index 000000000000..d6a48f267018
--- /dev/null
+++ b/crypto/esdm/esdm_es_jent.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _ESDM_ES_JENT_H
+#define _ESDM_ES_JENT_H
+
+#include "esdm_es_mgr_cb.h"
+
+#ifdef CONFIG_CRYPTO_ESDM_JENT
+
+extern struct esdm_es_cb esdm_es_jent;
+
+#endif /* CONFIG_CRYPTO_ESDM_JENT */
+
+#endif /* _ESDM_ES_JENT_H */
diff --git a/crypto/esdm/esdm_es_mgr.c b/crypto/esdm/esdm_es_mgr.c
index 8bdef5a934a8..b7b1a4151137 100644
--- a/crypto/esdm/esdm_es_mgr.c
+++ b/crypto/esdm/esdm_es_mgr.c
@@ -13,6 +13,7 @@
 
 #include "esdm_drng_mgr.h"
 #include "esdm_es_aux.h"
+#include "esdm_es_jent.h"
 #include "esdm_es_mgr.h"
 
 struct esdm_state {
@@ -54,6 +55,9 @@ u32 esdm_write_wakeup_bits = (ESDM_WRITE_WAKEUP_ENTROPY << 3);
  * enum enum esdm_external_es
  */
 struct esdm_es_cb *esdm_es[] = {
+#ifdef CONFIG_CRYPTO_ESDM_JENT
+	&esdm_es_jent,
+#endif
 	&esdm_es_aux
 };
 
diff --git a/crypto/esdm/esdm_es_mgr_cb.h b/crypto/esdm/esdm_es_mgr_cb.h
index 41b39983196f..18f0e4317691 100644
--- a/crypto/esdm/esdm_es_mgr_cb.h
+++ b/crypto/esdm/esdm_es_mgr_cb.h
@@ -14,6 +14,9 @@
 #include "esdm_drng_mgr.h"
 
 enum esdm_external_es {
+#ifdef CONFIG_CRYPTO_ESDM_JENT
+	esdm_ext_es_jitter,			/* Jitter RNG */
+#endif
 	esdm_ext_es_aux,			/* MUST BE LAST ES! */
 	esdm_ext_es_last			/* MUST be the last entry */
 };
-- 
2.33.1




