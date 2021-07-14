Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F19C11F68
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jul 2021 05:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3C9F613B6
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jul 2021 05:52:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237998AbhGNFzO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jul 2021 01:55:14 -0400
Received: from mo4-p03-ob.smtp.rzone.de ([81.169.146.174]:11883 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237959AbhGNFzA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jul 2021 01:55:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626241849;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=QPS7OuH3DnMGYhAOAdZFeI9eRAvYhooyGueRH9+3eaQ=;
    b=tEngVz1KJa+q1P8czzuUJP5st33/XIHV0R43TV83p/+U5xLNfbnJ0Z1kW0OWrk2Cr4
    ObyT/BT+bA5PtqQQhMOTpHb15R6jMihZZin24es9DR+ApwJASzHPYPwAV8JsZOPV/Hj4
    VqUy8R2f2q/Pz5YzEwN7BT6ac9J1CzMqlKyRfyT4a8GQFsXbqv0vy8IMtKgY8VVYWrpv
    St/IwWl4l+Rc9I5RPT0PovE/L+rNuuemnk0fO058BDuvtgXB4bnDL6lJQScS4wp7yYMq
    sdScOGit/Ffvvo/aA5GfGwMRMQA1/x0ZDb+PCuDykPZe6aKSMUbXNa3Pe0VfOvZMttnx
    h1yg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXPSI/SaRQ=="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id N0753fx6E5omwyS
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 14 Jul 2021 07:50:48 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Tso Ted <tytso@mit.edu>, linux-crypto@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>,
        Alexander Lobakin <alobakin@mailbox.org>
Subject: [PATCH v41 10/13] LRNG - add Jitter RNG fast noise source
Date:   Wed, 14 Jul 2021 07:48:40 +0200
Message-ID: <8015368.FPDjnrgga5@positron.chronox.de>
In-Reply-To: <7822794.ITf6fX9eNu@positron.chronox.de>
References: <7822794.ITf6fX9eNu@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The Jitter RNG fast noise source implemented as part of the kernel
crypto API is queried for 256 bits of entropy at the time the seed
buffer managed by the LRNG is about to be filled.

CC: Torsten Duwe <duwe@lst.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Alexander E. Patrakov" <patrakov@gmail.com>
CC: "Ahmed S. Darwish" <darwish.07@gmail.com>
CC: "Theodore Y. Ts'o" <tytso@mit.edu>
CC: Willy Tarreau <w@1wt.eu>
CC: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Vito Caputo <vcaputo@pengaru.com>
CC: Andreas Dilger <adilger.kernel@dilger.ca>
CC: Jan Kara <jack@suse.cz>
CC: Ray Strode <rstrode@redhat.com>
CC: William Jon McCann <mccann@jhu.edu>
CC: zhangjs <zachary@baishancloud.com>
CC: Andy Lutomirski <luto@kernel.org>
CC: Florian Weimer <fweimer@redhat.com>
CC: Lennart Poettering <mzxreary@0pointer.de>
CC: Nicolai Stange <nstange@suse.de>
CC: Alexander Lobakin <alobakin@mailbox.org>
Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/lrng/Kconfig     | 27 +++++++++++
 drivers/char/lrng/Makefile    |  1 +
 drivers/char/lrng/lrng_jent.c | 90 +++++++++++++++++++++++++++++++++++
 3 files changed, 118 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_jent.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index ffd2df43f2d4..e622b8532e2b 100644
--- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -182,6 +182,33 @@ config LRNG_IRQ_ENTROPY_RATE
 	  interrupt entropy source will still deliver data but without
 	  being credited with entropy.
 
+comment "Jitter RNG Entropy Source"
+
+config LRNG_JENT
+	bool "Enable Jitter RNG as LRNG Seed Source"
+	depends on CRYPTO
+	select CRYPTO_JITTERENTROPY
+	help
+	  The Linux RNG may use the Jitter RNG as noise source. Enabling
+	  this option enables the use of the Jitter RNG. Its default
+	  entropy level is 16 bits of entropy per 256 data bits delivered
+	  by the Jitter RNG. This entropy level can be changed at boot
+	  time or at runtime with the lrng_base.jitterrng configuration
+	  variable.
+
+config LRNG_JENT_ENTROPY_RATE
+	int "Jitter RNG Entropy Source Entropy Rate"
+	range 0 256
+	default 16
+	help
+	  The option defines the amount of entropy the LRNG applies to 256
+	  bits of data obtained from the Jitter RNG entropy source. The
+	  LRNG enforces the limit that this value must be in the range
+	  between 0 and 256.
+
+	  In order to disable the Jitter RNG entropy source, the option
+	  has to be set to 0.
+
 comment "CPU Entropy Source"
 
 config LRNG_CPU_ENTROPY_RATE
diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 97d2b13d3227..6be88156010a 100644
--- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -14,3 +14,4 @@ obj-$(CONFIG_LRNG_DRNG_SWITCH)	+= lrng_switch.o
 obj-$(CONFIG_LRNG_KCAPI_HASH)	+= lrng_kcapi_hash.o
 obj-$(CONFIG_LRNG_DRBG)		+= lrng_drbg.o
 obj-$(CONFIG_LRNG_KCAPI)	+= lrng_kcapi.o
+obj-$(CONFIG_LRNG_JENT)		+= lrng_jent.o
diff --git a/drivers/char/lrng/lrng_jent.c b/drivers/char/lrng/lrng_jent.c
new file mode 100644
index 000000000000..2599ab9352b6
--- /dev/null
+++ b/drivers/char/lrng/lrng_jent.c
@@ -0,0 +1,90 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG Fast Entropy Source: Jitter RNG
+ *
+ * Copyright (C) 2016 - 2021, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/types.h>
+#include <crypto/internal/jitterentropy.h>
+
+#include "lrng_internal.h"
+
+/*
+ * Estimated entropy of data is a 16th of LRNG_DRNG_SECURITY_STRENGTH_BITS.
+ * Albeit a full entropy assessment is provided for the noise source indicating
+ * that it provides high entropy rates and considering that it deactivates
+ * when it detects insufficient hardware, the chosen under estimation of
+ * entropy is considered to be acceptable to all reviewers.
+ */
+static u32 jitterrng = CONFIG_LRNG_JENT_ENTROPY_RATE;
+#ifdef CONFIG_LRNG_RUNTIME_ES_CONFIG
+module_param(jitterrng, uint, 0644);
+MODULE_PARM_DESC(jitterrng, "Entropy in bits of 256 data bits from Jitter RNG noise source");
+#endif
+
+static bool lrng_jent_initialized = false;
+static struct rand_data *lrng_jent_state;
+
+static int __init lrng_jent_initialize(void)
+{
+	/* Initialize the Jitter RNG after the clocksources are initialized. */
+	lrng_jent_state = jent_lrng_entropy_collector();
+	if (!lrng_jent_state) {
+		jitterrng = 0;
+		pr_info("Jitter RNG unusable on current system\n");
+		return 0;
+	}
+	lrng_jent_initialized = true;
+	lrng_pool_add_entropy();
+	pr_debug("Jitter RNG working on current system\n");
+
+	return 0;
+}
+device_initcall(lrng_jent_initialize);
+
+/**
+ * lrng_get_jent() - Get Jitter RNG entropy
+ *
+ * @outbuf: buffer to store entropy
+ * @outbuflen: length of buffer
+ *
+ * Return:
+ * * > 0 on success where value provides the added entropy in bits
+ * * 0 if no fast source was available
+ */
+u32 lrng_get_jent(u8 *outbuf, u32 requested_bits)
+{
+	int ret;
+	u32 ent_bits = lrng_jent_entropylevel(requested_bits);
+	unsigned long flags;
+	static DEFINE_SPINLOCK(lrng_jent_lock);
+
+	spin_lock_irqsave(&lrng_jent_lock, flags);
+
+	if (!ent_bits || !lrng_jent_initialized) {
+		spin_unlock_irqrestore(&lrng_jent_lock, flags);
+		return 0;
+	}
+
+	ret = jent_read_entropy(lrng_jent_state, outbuf, requested_bits >> 3);
+	spin_unlock_irqrestore(&lrng_jent_lock, flags);
+
+	if (ret) {
+		pr_debug("Jitter RNG failed with %d\n", ret);
+		return 0;
+	}
+
+	pr_debug("obtained %u bits of entropy from Jitter RNG noise source\n",
+		 ent_bits);
+
+	return ent_bits;
+}
+
+u32 lrng_jent_entropylevel(u32 requested_bits)
+{
+	return lrng_fast_noise_entropylevel((lrng_jent_initialized) ?
+					    jitterrng : 0, requested_bits);
+}
-- 
2.31.1




