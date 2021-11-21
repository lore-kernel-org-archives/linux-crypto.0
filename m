Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B809DC433FE
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Nov 2021 16:50:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238602AbhKUQxZ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Nov 2021 11:53:25 -0500
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.102]:19631 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238326AbhKUQxA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Nov 2021 11:53:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1637513308;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=v3VE4sz9UanANB1pBtIQXd8R3GDdDazSufrH3xmz0kU=;
    b=WmuwXtmk/09WylE/IqDxEoesY9AV5RVPW8wq6HUu4dgfSlL9+35Gny1p+3kH1TLunj
    N3Jnjdt0NeTw9YhNiFXrr09X1Hn7mvOtxHsAF11rg4eHooaNfX7+CT7/L/pSJfAzxtrY
    6/qKoQxeW8MZXpit5mAzB1Ft7Q5efy7BzANcUcL867+V4qEOgL1fWI8UTFGauY4R5NB/
    iBklKNtbz+cc65mc3b8P5WWs9AlmLxPPv+RTodWWlID9joZt8ceCQW+pex3xGhVJNGq9
    LSpLdK/UqOP5AIJRd4nqhAESDZws3owd3jemrZBLeiPJc8ScsFbyvLWUi5Z48gIUr1ZH
    YLZw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJvSfE+K2"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.34.5 DYNA|AUTH)
    with ESMTPSA id U02dfbxALGmR3Wc
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 21 Nov 2021 17:48:27 +0100 (CET)
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
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Subject: [PATCH v43 12/15] LRNG - add Jitter RNG fast noise source
Date:   Sun, 21 Nov 2021 17:46:32 +0100
Message-ID: <1784588.LH7GnMWURc@positron.chronox.de>
In-Reply-To: <2036923.9o76ZdvQCi@positron.chronox.de>
References: <2036923.9o76ZdvQCi@positron.chronox.de>
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
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Tested-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Neil Horman <nhorman@redhat.com>
Tested-by: Jirka Hladky <jhladky@redhat.com>
Reviewed-by: Jirka Hladky <jhladky@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/lrng/Kconfig        | 29 ++++++++++
 drivers/char/lrng/Makefile       |  1 +
 drivers/char/lrng/lrng_es_jent.c | 97 ++++++++++++++++++++++++++++++++
 3 files changed, 127 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_es_jent.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index 25684c54d6a9..478b12839907 100644
--- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -215,6 +215,35 @@ config LRNG_IRQ_ENTROPY_RATE
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
+	depends on LRNG_JENT
+	range 0 256
+	default 16
+	help
+	  The option defines the amount of entropy the LRNG applies to 256
+	  bits of data obtained from the Jitter RNG entropy source. The
+	  LRNG enforces the limit that this value must be in the range
+	  between 0 and 256.
+
+	  When configuring this value to 0, the Jitter RNG entropy source
+	  will provide 256 bits of data without being credited to contain
+	  entropy.
+
 comment "CPU Entropy Source"
 
 config LRNG_CPU
diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 85abeaa68136..c797fbd10a98 100644
--- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -15,3 +15,4 @@ obj-$(CONFIG_LRNG_DRNG_SWITCH)	+= lrng_switch.o
 obj-$(CONFIG_LRNG_KCAPI_HASH)	+= lrng_kcapi_hash.o
 obj-$(CONFIG_LRNG_DRBG)		+= lrng_drbg.o
 obj-$(CONFIG_LRNG_KCAPI)	+= lrng_kcapi.o
+obj-$(CONFIG_LRNG_JENT)		+= lrng_es_jent.o
diff --git a/drivers/char/lrng/lrng_es_jent.c b/drivers/char/lrng/lrng_es_jent.c
new file mode 100644
index 000000000000..2ed221cc9372
--- /dev/null
+++ b/drivers/char/lrng/lrng_es_jent.c
@@ -0,0 +1,97 @@
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
+	if (jent_entropy_init() ||
+	    (lrng_jent_state = jent_entropy_collector_alloc(1, 0)) == NULL) {
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
+/*
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
+	if (!lrng_jent_initialized) {
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
+
+void lrng_jent_es_state(unsigned char *buf, size_t buflen)
+{
+	snprintf(buf, buflen,
+		 "JitterRNG ES properties:\n"
+		 " Enabled: %s\n", lrng_jent_initialized ? "true" : "false");
+}
-- 
2.31.1




