Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D6AC433EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 09:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4A60610A6
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 09:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245615AbhIQJj4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Sep 2021 05:39:56 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.121]:34298 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241403AbhIQJjw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Sep 2021 05:39:52 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Sep 2021 05:39:52 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1631871144;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=YYVyCa1AKBYWEXJ5Aa0jWO5d0uV4daDcsZ2R9K5cQDM=;
    b=OSehhtzafoaFw/3/MFNpWPqKeK5Xg6Su5SB7NuTwtX2knT3E3QtX9JKChHszLUH4Us
    J+LT80OxDX88Rp6H9MjacZyIMJq1Wda7efRsHsGJ1nk4dz6dtO+XzBMT6VD0MoHXfSRV
    Bo6I8X02GT9aBiM/uR91nGNGbFQOGbmAASockj1MrBvQiDDlNFhpfoXmTvnpg6AUH/+m
    A9v2YoW9UTM3zmKa0GlhdkTUO3zTS3bXEioxEsrDw52s3rNN5WomuricHNZtY5JdT549
    Ez5mxXr+QPiz60bjZklxQMZ1+CwWHRlerrIy9W1VHV75JuOO6TlT1VjgPoUlH4PpqWcE
    VzYw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvSOeicf6o="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.33.3 DYNA|AUTH)
    with ESMTPSA id f080d4x8H9WNcpf
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 17 Sep 2021 11:32:23 +0200 (CEST)
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
Subject: [PATCH v42 02/13] LRNG - allocate one DRNG instance per NUMA node
Date:   Thu, 16 Sep 2021 12:12:08 +0200
Message-ID: <8416707.0CM7ZkIBX3@positron.chronox.de>
In-Reply-To: <2294055.9jK4hKOXjS@positron.chronox.de>
References: <2294055.9jK4hKOXjS@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to improve NUMA-locality when serving getrandom(2) requests,
allocate one DRNG instance per node.

The DRNG instance that is present right from the start of the kernel is
reused as the first per-NUMA-node DRNG. For all remaining online NUMA
nodes a new DRNG instance is allocated.

During boot time, the multiple DRNG instances are seeded sequentially.
With this, the first DRNG instance (referenced as the initial DRNG
in the code) is completely seeded with 256 bits of entropy before the
next DRNG instance is completely seeded.

When random numbers are requested, the NUMA-node-local DRNG is checked
whether it has been already fully seeded. If this is not the case, the
initial DRNG is used to serve the request.

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
CC: Eric Biggers <ebiggers@kernel.org>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Tested-by: Alexander Lobakin <alobakin@pm.me>
Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Reviewed-by: Roman Drahtmueller <draht@schaltsekun.de>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/lrng/Makefile    |   2 +
 drivers/char/lrng/lrng_numa.c | 122 ++++++++++++++++++++++++++++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_numa.c

diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index c26f932628d7..80b152059598 100644
--- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -7,3 +7,5 @@ obj-y				+= lrng_es_mgr.o lrng_aux.o \
 				   lrng_es_irq.o lrng_es_archrandom.o \
 				   lrng_drng.o lrng_chacha20.o \
 				   lrng_interfaces.o lrng_es_aux.o
+
+obj-$(CONFIG_NUMA)		+= lrng_numa.o
diff --git a/drivers/char/lrng/lrng_numa.c b/drivers/char/lrng/lrng_numa.c
new file mode 100644
index 000000000000..fbfb40a5fb8d
--- /dev/null
+++ b/drivers/char/lrng/lrng_numa.c
@@ -0,0 +1,122 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG NUMA support
+ *
+ * Copyright (C) 2016 - 2021, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/lrng.h>
+#include <linux/slab.h>
+
+#include "lrng_internal.h"
+
+static struct lrng_drng **lrng_drng __read_mostly = NULL;
+
+struct lrng_drng **lrng_drng_instances(void)
+{
+	return smp_load_acquire(&lrng_drng);
+}
+
+/* Allocate the data structures for the per-NUMA node DRNGs */
+static void _lrng_drngs_numa_alloc(struct work_struct *work)
+{
+	struct lrng_drng **drngs;
+	struct lrng_drng *lrng_drng_init = lrng_drng_init_instance();
+	u32 node;
+	bool init_drng_used = false;
+
+	mutex_lock(&lrng_crypto_cb_update);
+
+	/* per-NUMA-node DRNGs are already present */
+	if (lrng_drng)
+		goto unlock;
+
+	drngs = kcalloc(nr_node_ids, sizeof(void *), GFP_KERNEL|__GFP_NOFAIL);
+	for_each_online_node(node) {
+		struct lrng_drng *drng;
+
+		if (!init_drng_used) {
+			drngs[node] = lrng_drng_init;
+			init_drng_used = true;
+			continue;
+		}
+
+		drng = kmalloc_node(sizeof(struct lrng_drng),
+				     GFP_KERNEL|__GFP_NOFAIL, node);
+		memset(drng, 0, sizeof(lrng_drng));
+
+		drng->crypto_cb = lrng_drng_init->crypto_cb;
+		drng->drng = drng->crypto_cb->lrng_drng_alloc(
+					LRNG_DRNG_SECURITY_STRENGTH_BYTES);
+		if (IS_ERR(drng->drng)) {
+			kfree(drng);
+			goto err;
+		}
+
+		drng->hash = drng->crypto_cb->lrng_hash_alloc();
+		if (IS_ERR(drng->hash)) {
+			drng->crypto_cb->lrng_drng_dealloc(drng->drng);
+			kfree(drng);
+			goto err;
+		}
+
+		mutex_init(&drng->lock);
+		spin_lock_init(&drng->spin_lock);
+		rwlock_init(&drng->hash_lock);
+
+		/*
+		 * Switch the hash used by the per-CPU pool.
+		 * We do not need to lock the new hash as it is not usable yet
+		 * due to **drngs not yet being initialized.
+		 */
+		if (lrng_pcpu_switch_hash(node, drng->crypto_cb, drng->hash,
+					  &lrng_cc20_crypto_cb))
+			goto err;
+
+		/*
+		 * No reseeding of NUMA DRNGs from previous DRNGs as this
+		 * would complicate the code. Let it simply reseed.
+		 */
+		lrng_drng_reset(drng);
+		drngs[node] = drng;
+
+		lrng_pool_inc_numa_node();
+		pr_info("DRNG and entropy pool read hash for NUMA node %d allocated\n",
+			node);
+	}
+
+	/* counterpart to smp_load_acquire in lrng_drng_instances */
+	if (!cmpxchg_release(&lrng_drng, NULL, drngs)) {
+		lrng_pool_all_numa_nodes_seeded(false);
+		goto unlock;
+	}
+
+err:
+	for_each_online_node(node) {
+		struct lrng_drng *drng = drngs[node];
+
+		if (drng == lrng_drng_init)
+			continue;
+
+		if (drng) {
+			lrng_pcpu_switch_hash(node, &lrng_cc20_crypto_cb, NULL,
+					      drng->crypto_cb);
+			drng->crypto_cb->lrng_hash_dealloc(drng->hash);
+			drng->crypto_cb->lrng_drng_dealloc(drng->drng);
+			kfree(drng);
+		}
+	}
+	kfree(drngs);
+
+unlock:
+	mutex_unlock(&lrng_crypto_cb_update);
+}
+
+static DECLARE_WORK(lrng_drngs_numa_alloc_work, _lrng_drngs_numa_alloc);
+
+void lrng_drngs_numa_alloc(void)
+{
+	schedule_work(&lrng_drngs_numa_alloc_work);
+}
-- 
2.31.1




