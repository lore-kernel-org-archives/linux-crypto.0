Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA712C63682
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jan 2022 07:07:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237562AbiAZHH1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jan 2022 02:07:27 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:40413 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237559AbiAZHHZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jan 2022 02:07:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1643180839;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=1VapLQQk9KAoOWLbgE8//O90bixt9wVg2yiZM3bOoYI=;
    b=gnT0c/JnmA2GHytrDNIL+W+uN+ieUWcp/2MSrziOF+Rdu4jP0jIa4ecWumWJdtPm5/
    bavnMiIBmL+gL/8EI3hw8jmagTJUiHp7sAH9Do1vQqtrB0reL9VtkNtUp/Ck4XbT7FzL
    pYEWZBb1LedxLFXTvOFws2sWWBFlJncM4BGZFt3AIHbiF5ec6XVdQ+T+GiydpxasX84S
    7V8d/RQnjSxrYDUkP/Jcrf7mNehixit1+jtb8R+4gpKHybITO8NPzi3nI+5TmOzRbpZr
    cBS4wsroT5/4rAWEBtWcAu0gG12YXo1s23OSv6/AAuIhcOcrTZsr4fNJ/wCm5ebtL/cv
    S6dw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJvScdWrN"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.38.0 DYNA|AUTH)
    with ESMTPSA id v5f65ay0Q77JiuN
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 26 Jan 2022 08:07:19 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH 6/7] crypto: ESDM - add Kernel RNG entropy source
Date:   Wed, 26 Jan 2022 08:05:08 +0100
Message-ID: <274193597.ifERbkFSEj@positron.chronox.de>
In-Reply-To: <2486550.t9SDvczpPo@positron.chronox.de>
References: <2486550.t9SDvczpPo@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Kernel RNG entropy source is used as a separate entropy source for
the ESDM. It can be enabled at compile time together with its implied
entropy rate. If the FIPS mode is enabled, the entropy rate is
automatically set to 0 since the entropy source is not SP800-90B
compliant and thus must be considered to deliver no entropy.

As long as the Kernel RNG is not fully initialized, the entropy rate is
also forced to 0.

The entropy rate states how many bits of entropy are present in 256 bits
of data from that entropy source. If a different amount of data is
pulled from the entropy source, the entropy ratio is scaled accordingly.

When the entropy ratio is set to zero, the Kernel RNG provides data but
without claiming any entropy for it.

When the compile time switch for enabling runtime setting of the entropy
rate is enabled (CONFIG_CRYPTO_ESDM_RUNTIME_ES_CONFIG), the entropy rate
can be configured at the kernel command line with the option
esdm_es_random.krng_entropy. If this option is not set, the default
value set during compile time is used.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/esdm/Kconfig          |  28 ++++++++
 crypto/esdm/Makefile         |   1 +
 crypto/esdm/esdm_es_krng.c   | 120 +++++++++++++++++++++++++++++++++++
 crypto/esdm/esdm_es_krng.h   |  17 +++++
 crypto/esdm/esdm_es_mgr.c    |   4 ++
 crypto/esdm/esdm_es_mgr_cb.h |   3 +
 6 files changed, 173 insertions(+)
 create mode 100644 crypto/esdm/esdm_es_krng.c
 create mode 100644 crypto/esdm/esdm_es_krng.h

diff --git a/crypto/esdm/Kconfig b/crypto/esdm/Kconfig
index eeef71546bc3..43e11484e95c 100644
--- a/crypto/esdm/Kconfig
+++ b/crypto/esdm/Kconfig
@@ -111,6 +111,34 @@ config CRYPTO_ESDM_JENT_ENTROPY_RATE
 	  will provide 256 bits of data without being credited to contain
 	  entropy.
 
+comment "Kernel RNG Entropy Source"
+
+config CRYPTO_ESDM_KERNEL_RNG
+	bool "Enable Kernel RNG as ESDM Seed Source"
+	help
+	  The Linux RNG may use the kernel RNG (random.c) as entropy
+	  source.
+
+config CRYPTO_ESDM_KERNEL_RNG_ENTROPY_RATE
+	int "Kernel RNG Entropy Source Entropy Rate"
+	depends on CRYPTO_ESDM_KERNEL_RNG
+	range 0 256
+	default 256
+	help
+	  The option defines the amount of entropy the ESDM applies to 256
+	  bits of data obtained from the kernel RNG entropy source. The
+	  ESDM enforces the limit that this value must be in the range
+	  between 0 and 256.
+
+	  When configuring this value to 0, the kernel RNG entropy source
+	  will provide 256 bits of data without being credited to contain
+	  entropy.
+
+	  Note: This value is set to 0 automatically when booting the
+	  kernel in FIPS mode (with fips=1 kernel command line option).
+	  This is due to the fact that random.c is not SP800-90B
+	  compliant.
+
 endmenu # "Entropy Source Configuration"
 
 config CRYPTO_ESDM_DRNG_KCAPI
diff --git a/crypto/esdm/Makefile b/crypto/esdm/Makefile
index 99a86ce3e3af..404436de0aa2 100644
--- a/crypto/esdm/Makefile
+++ b/crypto/esdm/Makefile
@@ -9,4 +9,5 @@ obj-$(CONFIG_CRYPTO_ESDM_SHA256)	+= esdm_sha256.o
 
 obj-$(CONFIG_CRYPTO_ESDM_DRNG_KCAPI)	+= esdm_drng_kcapi.o
 
+obj-$(CONFIG_CRYPTO_ESDM_KERNEL_RNG)	+= esdm_es_krng.o
 obj-$(CONFIG_CRYPTO_ESDM_JENT)		+= esdm_es_jent.o
diff --git a/crypto/esdm/esdm_es_krng.c b/crypto/esdm/esdm_es_krng.c
new file mode 100644
index 000000000000..d536a9139276
--- /dev/null
+++ b/crypto/esdm/esdm_es_krng.c
@@ -0,0 +1,120 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * ESDM Fast Entropy Source: Linux kernel RNG (random.c)
+ *
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/fips.h>
+#include <linux/module.h>
+#include <linux/random.h>
+#include <linux/types.h>
+
+#include "esdm_es_aux.h"
+#include "esdm_es_krng.h"
+
+static u32 krng_entropy = CONFIG_CRYPTO_ESDM_KERNEL_RNG_ENTROPY_RATE;
+#ifdef CONFIG_CRYPTO_ESDM_RUNTIME_ES_CONFIG
+module_param(krng_entropy, uint, 0644);
+MODULE_PARM_DESC(krng_entropy, "Entropy in bits of 256 data bits from the kernel RNG noise source");
+#endif
+
+static atomic_t esdm_krng_initial_rate = ATOMIC_INIT(0);
+
+static struct random_ready_callback esdm_krng_ready = {
+	.owner = THIS_MODULE,
+	.func = NULL,
+};
+
+static u32 esdm_krng_fips_entropylevel(u32 entropylevel)
+{
+	return fips_enabled ? 0 : entropylevel;
+}
+
+static void esdm_krng_adjust_entropy(struct random_ready_callback *rdy)
+{
+	u32 entropylevel;
+
+	krng_entropy = atomic_read_u32(&esdm_krng_initial_rate);
+
+	entropylevel = esdm_krng_fips_entropylevel(krng_entropy);
+	pr_debug("Kernel RNG is fully seeded, setting entropy rate to %u bits of entropy\n",
+		 entropylevel);
+	esdm_drng_force_reseed();
+	if (entropylevel)
+		esdm_es_add_entropy();
+}
+
+static u32 esdm_krng_entropylevel(u32 requested_bits)
+{
+	if (esdm_krng_ready.func == NULL) {
+		int err;
+
+		esdm_krng_ready.func = esdm_krng_adjust_entropy;
+
+		err = add_random_ready_callback(&esdm_krng_ready);
+		switch (err) {
+		case 0:
+			atomic_set(&esdm_krng_initial_rate, krng_entropy);
+			krng_entropy = 0;
+			pr_debug("Kernel RNG is not yet seeded, setting entropy rate to 0 bits of entropy\n");
+			break;
+
+		case -EALREADY:
+			pr_debug("Kernel RNG is fully seeded, setting entropy rate to %u bits of entropy\n",
+				 esdm_krng_fips_entropylevel(krng_entropy));
+			break;
+		default:
+			esdm_krng_ready.func = NULL;
+			return 0;
+		}
+	}
+
+	return esdm_fast_noise_entropylevel(
+		esdm_krng_fips_entropylevel(krng_entropy), requested_bits);
+}
+
+static u32 esdm_krng_poolsize(void)
+{
+	return esdm_krng_entropylevel(esdm_security_strength());
+}
+
+/*
+ * esdm_krng_get() - Get kernel RNG entropy
+ *
+ * @eb: entropy buffer to store entropy
+ * @requested_bits: requested entropy in bits
+ */
+static void esdm_krng_get(struct entropy_buf *eb, u32 requested_bits,
+			  bool __unused)
+{
+	u32 ent_bits = esdm_krng_entropylevel(requested_bits);
+
+	get_random_bytes(eb->e[esdm_ext_es_krng], requested_bits >> 3);
+
+	pr_debug("obtained %u bits of entropy from kernel RNG noise source\n",
+		 ent_bits);
+
+	eb->e_bits[esdm_ext_es_krng] = ent_bits;
+}
+
+static void esdm_krng_es_state(unsigned char *buf, size_t buflen)
+{
+	snprintf(buf, buflen,
+		 " Available entropy: %u\n"
+		 " Entropy Rate per 256 data bits: %u\n",
+		 esdm_krng_poolsize(),
+		 esdm_krng_entropylevel(256));
+}
+
+struct esdm_es_cb esdm_es_krng = {
+	.name			= "KernelRNG",
+	.get_ent		= esdm_krng_get,
+	.curr_entropy		= esdm_krng_entropylevel,
+	.max_entropy		= esdm_krng_poolsize,
+	.state			= esdm_krng_es_state,
+	.reset			= NULL,
+	.switch_hash		= NULL,
+};
diff --git a/crypto/esdm/esdm_es_krng.h b/crypto/esdm/esdm_es_krng.h
new file mode 100644
index 000000000000..b164594bfe79
--- /dev/null
+++ b/crypto/esdm/esdm_es_krng.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright (C) 2022, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _ESDM_ES_RANDOM_H
+#define _ESDM_ES_RANDOM_H
+
+#include "esdm_es_mgr_cb.h"
+
+#ifdef CONFIG_CRYPTO_ESDM_KERNEL_RNG
+
+extern struct esdm_es_cb esdm_es_krng;
+
+#endif /* CONFIG_CRYPTO_ESDM_KERNEL_RNG */
+
+#endif /* _ESDM_ES_RANDOM_H */
diff --git a/crypto/esdm/esdm_es_mgr.c b/crypto/esdm/esdm_es_mgr.c
index b7b1a4151137..0a65aafac8d2 100644
--- a/crypto/esdm/esdm_es_mgr.c
+++ b/crypto/esdm/esdm_es_mgr.c
@@ -14,6 +14,7 @@
 #include "esdm_drng_mgr.h"
 #include "esdm_es_aux.h"
 #include "esdm_es_jent.h"
+#include "esdm_es_krng.h"
 #include "esdm_es_mgr.h"
 
 struct esdm_state {
@@ -57,6 +58,9 @@ u32 esdm_write_wakeup_bits = (ESDM_WRITE_WAKEUP_ENTROPY << 3);
 struct esdm_es_cb *esdm_es[] = {
 #ifdef CONFIG_CRYPTO_ESDM_JENT
 	&esdm_es_jent,
+#endif
+#ifdef CONFIG_CRYPTO_ESDM_KERNEL_RNG
+	&esdm_es_krng,
 #endif
 	&esdm_es_aux
 };
diff --git a/crypto/esdm/esdm_es_mgr_cb.h b/crypto/esdm/esdm_es_mgr_cb.h
index 18f0e4317691..a94ad28f7d0f 100644
--- a/crypto/esdm/esdm_es_mgr_cb.h
+++ b/crypto/esdm/esdm_es_mgr_cb.h
@@ -16,6 +16,9 @@
 enum esdm_external_es {
 #ifdef CONFIG_CRYPTO_ESDM_JENT
 	esdm_ext_es_jitter,			/* Jitter RNG */
+#endif
+#ifdef CONFIG_CRYPTO_ESDM_KERNEL_RNG
+	esdm_ext_es_krng,			/* random.c */
 #endif
 	esdm_ext_es_aux,			/* MUST BE LAST ES! */
 	esdm_ext_es_last			/* MUST be the last entry */
-- 
2.33.1




