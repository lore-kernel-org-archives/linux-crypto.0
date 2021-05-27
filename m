Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C40C4707F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 16:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10CA761248
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 16:12:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237176AbhE0QOa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 12:14:30 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.179]:27122 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236293AbhE0QOQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 12:14:16 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1622131892; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Y2s9UhkZLm2K9FNN/zf0FxV4UcxZPGjW3ktmO6vbcT70vQWDr8WJofWxQZ0YhMQ3Q1
    DxjxOkFMB3/1dhnL2UihnPnLj4LxzZxkM7/OVn/zKoGyJur/HhkAxdIumfHcx9/1d339
    kRDIisSNnbhfoo8OmsmWPPQvslBdEmsLRDHI+Kml60NOl9zxR7fwcio5NK8ddQhGcrqX
    rOVKnHV4TMza6RdztXD1XR2ZenEFpAawQ7k+NfT1M+iZ8MUFAvIjt5Mzs5N9gR3ruVut
    wHxyioZdqtoFqJh5bsQmBHbV33B1Uk2HZlNbEzSFNCz8crTAt8g39goG57aeFm+R7MJh
    +qag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1622131892;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=RfqmGjXt/nEWVmiwFES876S/nx5XAYPOZNlyIhbeUCE=;
    b=oucGb4LnzjZUdZR7R54AIZAdW/3Tizor5Zt9qpy50nGR33sprRO3UJA3RpAyExIQnj
    D2poRxN7d6+D6qWSq204ANGm69Tx8u2OtCUc+KPxoHyUMFKkmH1AxmVAuqFhSbj93W8N
    a7ePYyNNcUOvcwcsfd/idQbJegR2V/03wYs6MD/Ty2AOLNFTxAXMI3C9q8Jz9irku5BM
    vPTc1/lqwuwXtjCYSbhSl2ZSJzCNcDw7RvexRbasGQ4eg06Od3eLhwUypQj4Tthfp0by
    yCeDELpT3SbPr9blW0+gjoxNqri1AAh/B7+jwNutKgzBO/IVSYXXt/2GGwcIyKvWUKP8
    CpPQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1622131892;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=RfqmGjXt/nEWVmiwFES876S/nx5XAYPOZNlyIhbeUCE=;
    b=bFv57qTBDNVmwEUkjfAyCCdOIcL62lQ7Tl99HRkoGlKn7FoNi2I4l0LEBZm8H6nCZs
    xzmEpY+tq7RSggDn/cIZi3ce9ODe4aYBiMFUFt+fQoaZdpsEZCqN075rsxx0b6feTn1z
    AZpKghmMTYe8fzXDr6BlC32kGm6VAsvvJ1QommRJ/F6tFI6dU6qs3jcPJJubnNHcp+RM
    m8t+CiewXtiTKyhmH04k6oQXeodfREtT2y+B4rJCcJAzmlAfEYPWcGDIM5Ep8BT++AHD
    TyhJ5LiJ3RYlH2ITf40ZpoV+REM97ZuSRiGWj8sG7gWrFKvj1Hs4DSNUu5mID90dl7n/
    yXiA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJvSfFeK2"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.26.3 DYNA|AUTH)
    with ESMTPSA id R0123ax4RGBV0Ts
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 27 May 2021 18:11:31 +0200 (CEST)
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
        John Haxby <john.haxby@oracle.com>
Subject: [PATCH v40 04/13] LRNG - add switchable DRNG support
Date:   Thu, 27 May 2021 17:57:32 +0200
Message-ID: <3728895.5tnKXvvxBo@positron.chronox.de>
In-Reply-To: <18450229.rjpLZT9oXI@positron.chronox.de>
References: <18450229.rjpLZT9oXI@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The DRNG switch support allows replacing the DRNG mechanism of the
LRNG. The switching support rests on the interface definition of
include/linux/lrng.h. A new DRNG is implemented by filling in the
interface defined in this header file.

In addition to the DRNG, the extension also has to provide a hash
implementation that is used to hash the entropy pool for random number
extraction.

Note: It is permissible to implement a DRNG whose operations may sleep.
However, the hash function must not sleep.

The switchable DRNG support allows replacing the DRNG at runtime.
However, only one DRNG extension is allowed to be loaded at any given
time. Before replacing it with another DRNG implementation, the possibly
existing DRNG extension must be unloaded.

The switchable DRNG extension activates the new DRNG during load time.
It is expected, however, that such a DRNG switch would be done only once
by an administrator to load the intended DRNG implementation.

It is permissible to compile DRNG extensions either as kernel modules or
statically. The initialization of the DRNG extension should be performed
with a late_initcall to ensure the extension is available when user
space starts but after all other initialization completed.
The initialization is performed by registering the function call data
structure with the lrng_set_drng_cb function. In order to unload the
DRNG extension, lrng_set_drng_cb must be invoked with the NULL
parameter.

The DRNG extension should always provide a security strength that is at
least as strong as LRNG_DRNG_SECURITY_STRENGTH_BITS.

The hash extension must not sleep and must not maintain a separate
state.

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
Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Reviewed-by: Roman Drahtmueller <draht@schaltsekun.de>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/lrng/Kconfig       |   7 +
 drivers/char/lrng/Makefile      |   1 +
 drivers/char/lrng/lrng_switch.c | 219 ++++++++++++++++++++++++++++++++
 3 files changed, 227 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_switch.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index c9e35e808c77..4e02542d7fcc 100644
--- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -158,4 +158,11 @@ config LRNG_COLLECTION_SIZE
 	default 4096 if LRNG_COLLECTION_SIZE_4096
 	default 8192 if LRNG_COLLECTION_SIZE_8192
 
+menuconfig LRNG_DRNG_SWITCH
+	bool "Support DRNG runtime switching"
+	help
+	  The Linux RNG per default uses a ChaCha20 DRNG that is
+	  accessible via the external interfaces. With this configuration
+	  option other DRNGs can be selected and loaded at runtime.
+
 endif # LRNG
diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index ac97f0b11cb7..0eb4a6849c88 100644
--- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -10,3 +10,4 @@ obj-y				+= lrng_pool.o lrng_aux.o \
 
 obj-$(CONFIG_NUMA)		+= lrng_numa.o
 obj-$(CONFIG_SYSCTL)		+= lrng_proc.o
+obj-$(CONFIG_LRNG_DRNG_SWITCH)	+= lrng_switch.o
diff --git a/drivers/char/lrng/lrng_switch.c b/drivers/char/lrng/lrng_switch.c
new file mode 100644
index 000000000000..a2b117b2b87e
--- /dev/null
+++ b/drivers/char/lrng/lrng_switch.c
@@ -0,0 +1,219 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG DRNG switching support
+ *
+ * Copyright (C) 2016 - 2021, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/lrng.h>
+
+#include "lrng_internal.h"
+
+static int lrng_drng_switch(struct lrng_drng *drng_store,
+			    const struct lrng_crypto_cb *cb, int node)
+{
+	const struct lrng_crypto_cb *old_cb;
+	unsigned long flags = 0, flags2 = 0;
+	int ret;
+	u8 seed[LRNG_DRNG_SECURITY_STRENGTH_BYTES];
+	void *new_drng = cb->lrng_drng_alloc(LRNG_DRNG_SECURITY_STRENGTH_BYTES);
+	void *old_drng, *new_hash, *old_hash;
+	u32 current_security_strength;
+	bool sl = false, reset_drng = !lrng_get_available();
+
+	if (IS_ERR(new_drng)) {
+		pr_warn("could not allocate new DRNG for NUMA node %d (%ld)\n",
+			node, PTR_ERR(new_drng));
+		return PTR_ERR(new_drng);
+	}
+
+	new_hash = cb->lrng_hash_alloc();
+	if (IS_ERR(new_hash)) {
+		pr_warn("could not allocate new LRNG pool hash (%ld)\n",
+			PTR_ERR(new_hash));
+		cb->lrng_drng_dealloc(new_drng);
+		return PTR_ERR(new_hash);
+	}
+
+	if (cb->lrng_hash_digestsize(new_hash) > LRNG_MAX_DIGESTSIZE) {
+		pr_warn("digest size of newly requested hash too large\n");
+		cb->lrng_hash_dealloc(new_hash);
+		cb->lrng_drng_dealloc(new_drng);
+		return -EINVAL;
+	}
+
+	current_security_strength = lrng_security_strength();
+	lrng_drng_lock(drng_store, &flags);
+
+	/*
+	 * Pull from existing DRNG to seed new DRNG regardless of seed status
+	 * of old DRNG -- the entropy state for the DRNG is left unchanged which
+	 * implies that als the new DRNG is reseeded when deemed necessary. This
+	 * seeding of the new DRNG shall only ensure that the new DRNG has the
+	 * same entropy as the old DRNG.
+	 */
+	ret = drng_store->crypto_cb->lrng_drng_generate_helper(
+				drng_store->drng, seed, sizeof(seed));
+	lrng_drng_unlock(drng_store, &flags);
+
+	if (ret < 0) {
+		reset_drng = true;
+		pr_warn("getting random data from DRNG failed for NUMA node %d (%d)\n",
+			node, ret);
+	} else {
+		/* seed new DRNG with data */
+		ret = cb->lrng_drng_seed_helper(new_drng, seed, ret);
+		if (ret < 0) {
+			reset_drng = true;
+			pr_warn("seeding of new DRNG failed for NUMA node %d (%d)\n",
+				node, ret);
+		} else {
+			pr_debug("seeded new DRNG of NUMA node %d instance from old DRNG instance\n",
+				 node);
+		}
+	}
+
+	mutex_lock(&drng_store->lock);
+	write_lock_irqsave(&drng_store->hash_lock, flags2);
+	/*
+	 * If we switch the DRNG from the initial ChaCha20 DRNG to something
+	 * else, there is a lock transition from spin lock to mutex (see
+	 * lrng_drng_is_atomic and how the lock is taken in lrng_drng_lock).
+	 * Thus, we need to take both locks during the transition phase.
+	 */
+	if (lrng_drng_is_atomic(drng_store)) {
+		spin_lock_irqsave(&drng_store->spin_lock, flags);
+		sl = true;
+	} else {
+		__acquire(&drng_store->spin_lock);
+	}
+
+	/* Trigger the switch of the per-CPU entropy pools for current node. */
+	ret = lrng_pcpu_switch_hash(node, cb, new_hash, drng_store->crypto_cb);
+	if (!ret) {
+		u32 additional = 0;
+
+		if (reset_drng)
+			lrng_drng_reset(drng_store);
+
+		old_drng = drng_store->drng;
+		old_cb = drng_store->crypto_cb;
+		drng_store->drng = new_drng;
+		drng_store->crypto_cb = cb;
+
+		old_hash = drng_store->hash;
+		drng_store->hash = new_hash;
+		pr_info("Entropy pool read-hash allocated for DRNG for NUMA node %d\n",
+			node);
+
+		lrng_set_digestsize(cb->lrng_hash_digestsize(new_hash));
+		if (lrng_sp80090c_compliant())
+			additional = CONFIG_LRNG_SEED_BUFFER_INIT_ADD_BITS;
+		lrng_set_entropy_thresh(lrng_security_strength() + additional +
+					CONFIG_LRNG_OVERSAMPLE_ES_BITS);
+
+		/* Reseed if previous LRNG security strength was insufficient */
+		if (current_security_strength < lrng_security_strength())
+			drng_store->force_reseed = true;
+
+		/* Force oversampling seeding as we initialize DRNG */
+		if (IS_ENABLED(CONFIG_LRNG_OVERSAMPLE_ENTROPY_SOURCES)) {
+			drng_store->force_reseed = true;
+			drng_store->fully_seeded = false;
+		}
+
+		/* ChaCha20 serves as atomic instance left untouched. */
+		if (old_drng != &chacha20) {
+			old_cb->lrng_drng_dealloc(old_drng);
+			old_cb->lrng_hash_dealloc(old_hash);
+		}
+
+		pr_info("DRNG of NUMA node %d switched\n", node);
+	}
+
+	if (sl)
+		spin_unlock_irqrestore(&drng_store->spin_lock, flags);
+	else
+		__release(&drng_store->spin_lock);
+	write_unlock_irqrestore(&drng_store->hash_lock, flags2);
+	mutex_unlock(&drng_store->lock);
+
+	return ret;
+}
+
+/*
+ * Switch the existing DRNG instances with new using the new crypto callbacks.
+ * The caller must hold the lrng_crypto_cb_update lock.
+ */
+static int lrng_drngs_switch(const struct lrng_crypto_cb *cb)
+{
+	struct lrng_drng **lrng_drng = lrng_drng_instances();
+	struct lrng_drng *lrng_drng_init = lrng_drng_init_instance();
+	int ret = 0;
+
+	/* Update DRNG */
+	if (lrng_drng) {
+		u32 node;
+
+		for_each_online_node(node) {
+			if (lrng_drng[node])
+				ret = lrng_drng_switch(lrng_drng[node], cb,
+						       node);
+		}
+	} else {
+		ret = lrng_drng_switch(lrng_drng_init, cb, 0);
+	}
+
+	if (!ret)
+		lrng_set_available();
+
+	return 0;
+}
+
+/**
+ * lrng_set_drng_cb - Register new cryptographic callback functions for DRNG
+ * The registering implies that all old DRNG states are replaced with new
+ * DRNG states.
+ *
+ * @cb: Callback functions to be registered -- if NULL, use the default
+ *	callbacks pointing to the ChaCha20 DRNG.
+ *
+ * Return:
+ * * 0 on success
+ * * < 0 on error
+ */
+int lrng_set_drng_cb(const struct lrng_crypto_cb *cb)
+{
+	struct lrng_drng *lrng_drng_init = lrng_drng_init_instance();
+	int ret;
+
+	if (!cb)
+		cb = &lrng_cc20_crypto_cb;
+
+	mutex_lock(&lrng_crypto_cb_update);
+
+	/*
+	 * If a callback other than the default is set, allow it only to be
+	 * set back to the default callback. This ensures that multiple
+	 * different callbacks can be registered at the same time. If a
+	 * callback different from the current callback and the default
+	 * callback shall be set, the current callback must be deregistered
+	 * (e.g. the kernel module providing it must be unloaded) and the new
+	 * implementation can be registered.
+	 */
+	if ((cb != &lrng_cc20_crypto_cb) &&
+	    (lrng_drng_init->crypto_cb != &lrng_cc20_crypto_cb)) {
+		pr_warn("disallow setting new cipher callbacks, unload the old callbacks first!\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = lrng_drngs_switch(cb);
+
+out:
+	mutex_unlock(&lrng_crypto_cb_update);
+	return ret;
+}
+EXPORT_SYMBOL(lrng_set_drng_cb);
-- 
2.31.1




