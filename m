Return-Path: <SRS0=7/wf=D2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718DCC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 19:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F214B222C2
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 19:53:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="oHAhqs0A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731335AbgJSTxY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Oct 2020 15:53:24 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.176]:27164 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731409AbgJSTwr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Oct 2020 15:52:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1603137161;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=aUdzSh7zvyd5hi5OoyB17iKZFiThsRr2C8UuKPbq7Q0=;
        b=oHAhqs0AgbqLi8PENhLzAhJarN6cT367phFJ2IUoUJcfBLp79BWpEX1YeOt7Ig9ZXa
        GHi9STD9OFWA464O5zkUKnVHbWCCAQhAQGCK/bXZiiyn2kFACf6kJUfawr6994Tgpx6b
        yQGym6dn8bgv/V0TahaW6Vy00zjAGXJi3790OTULrbA2QNEHD1g53gfxFuSXG3JQkk6l
        ph5lcGz9vCPAy+88d9agdLG3l7W7AeKAom7HYFSeH+gSiCe0ezYnqv5RIoDVGB5p85Fa
        YXjtGSFQwkLimJdQkEGhcBalIBKJMkvgMzDFYTC0pHOk/Qop3epMOcs3m/cJ4Hm+3IwJ
        di0A==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJPSb3t0="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id C0b627w9JJpoU6v
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 19 Oct 2020 21:51:50 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Willy Tarreau <w@1wt.eu>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
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
        Petr Tesarik <ptesarik@suse.cz>
Subject: [PATCH v36 04/13] LRNG - add switchable DRNG support
Date:   Mon, 19 Oct 2020 21:32:58 +0200
Message-ID: <3557336.kQq0lBPeGt@positron.chronox.de>
In-Reply-To: <3073852.aeNJFYEL58@positron.chronox.de>
References: <20200921075857.4424-1-nstange@suse.de> <20201016172619.GA18410@lst.de> <3073852.aeNJFYEL58@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
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
Tested-by: Roman Drahtm=FCller <draht@schaltsekun.de>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
=2D--
 drivers/char/lrng/Kconfig       |   7 ++
 drivers/char/lrng/Makefile      |   1 +
 drivers/char/lrng/lrng_switch.c | 203 ++++++++++++++++++++++++++++++++
 3 files changed, 211 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_switch.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index fbbcf2ef43b6..e211fcf5aa8b 100644
=2D-- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -69,4 +69,11 @@ config LRNG_COLLECTION_SIZE
 	default 512 if LRNG_COLLECTION_SIZE_512
 	default 1024 if LRNG_COLLECTION_SIZE_1024
=20
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
=2D-- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -10,3 +10,4 @@ obj-y				+=3D lrng_pool.o lrng_aux.o \
=20
 obj-$(CONFIG_NUMA)		+=3D lrng_numa.o
 obj-$(CONFIG_SYSCTL)		+=3D lrng_proc.o
+obj-$(CONFIG_LRNG_DRNG_SWITCH)	+=3D lrng_switch.o
diff --git a/drivers/char/lrng/lrng_switch.c b/drivers/char/lrng/lrng_switc=
h.c
new file mode 100644
index 000000000000..cbaf5cd544aa
=2D-- /dev/null
+++ b/drivers/char/lrng/lrng_switch.c
@@ -0,0 +1,203 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG DRNG switching support
+ *
+ * Copyright (C) 2016 - 2020, Stephan Mueller <smueller@chronox.de>
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
+	unsigned long flags =3D 0, flags2 =3D 0;
+	int ret;
+	u8 seed[LRNG_DRNG_SECURITY_STRENGTH_BYTES];
+	void *new_drng =3D cb->lrng_drng_alloc(LRNG_DRNG_SECURITY_STRENGTH_BYTES);
+	void *old_drng, *new_hash, *old_hash;
+	u32 current_security_strength;
+	bool sl =3D false, reset_drng =3D !lrng_get_available();
+
+	if (IS_ERR(new_drng)) {
+		pr_warn("could not allocate new DRNG for NUMA node %d (%ld)\n",
+			node, PTR_ERR(new_drng));
+		return PTR_ERR(new_drng);
+	}
+
+	new_hash =3D cb->lrng_hash_alloc();
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
+	current_security_strength =3D lrng_security_strength();
+	lrng_drng_lock(drng_store, &flags);
+
+	/*
+	 * Pull from existing DRNG to seed new DRNG regardless of seed status
+	 * of old DRNG -- the entropy state for the DRNG is left unchanged which
+	 * implies that als the new DRNG is reseeded when deemed necessary. This
+	 * seeding of the new DRNG shall only ensure that the new DRNG has the
+	 * same entropy as the old DRNG.
+	 */
+	ret =3D drng_store->crypto_cb->lrng_drng_generate_helper(
+				drng_store->drng, seed, sizeof(seed));
+	lrng_drng_unlock(drng_store, &flags);
+
+	if (ret < 0) {
+		reset_drng =3D true;
+		pr_warn("getting random data from DRNG failed for NUMA node %d (%d)\n",
+			node, ret);
+	} else {
+		/* seed new DRNG with data */
+		ret =3D cb->lrng_drng_seed_helper(new_drng, seed, ret);
+		if (ret < 0) {
+			reset_drng =3D true;
+			pr_warn("seeding of new DRNG failed for NUMA node %d (%d)\n",
+				node, ret);
+		} else {
+			pr_debug("seeded new DRNG of NUMA node %d instance from old DRNG instan=
ce\n",
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
+		sl =3D true;
+	} else {
+		__acquire(&drng_store->spin_lock);
+	}
+
+	if (reset_drng)
+		lrng_drng_reset(drng_store);
+
+	old_drng =3D drng_store->drng;
+	old_cb =3D drng_store->crypto_cb;
+	drng_store->drng =3D new_drng;
+	drng_store->crypto_cb =3D cb;
+
+	old_hash =3D drng_store->hash;
+	drng_store->hash =3D new_hash;
+	pr_info("Entropy pool read-hash allocated for DRNG for NUMA node %d\n",
+		node);
+
+	lrng_set_digestsize(cb->lrng_hash_digestsize(new_hash));
+
+	/* Reseed if previous LRNG security strength was insufficient */
+	if (current_security_strength < lrng_security_strength())
+		drng_store->force_reseed =3D true;
+
+	if (sl)
+		spin_unlock_irqrestore(&drng_store->spin_lock, flags);
+	else
+		__release(&drng_store->spin_lock);
+	write_unlock_irqrestore(&drng_store->hash_lock, flags2);
+	mutex_unlock(&drng_store->lock);
+
+	/* ChaCha20 serves as atomic instance left untouched. */
+	if (old_drng !=3D &chacha20) {
+		old_cb->lrng_drng_dealloc(old_drng);
+		old_cb->lrng_hash_dealloc(old_hash);
+	}
+
+	pr_info("DRNG of NUMA node %d switched\n", node);
+
+	return 0;
+}
+
+/*
+ * Switch the existing DRNG instances with new using the new crypto callba=
cks.
+ * The caller must hold the lrng_crypto_cb_update lock.
+ */
+static int lrng_drngs_switch(const struct lrng_crypto_cb *cb)
+{
+	struct lrng_drng **lrng_drng =3D lrng_drng_instances();
+	struct lrng_drng *lrng_drng_init =3D lrng_drng_init_instance();
+	int ret =3D 0;
+
+	/* Update DRNG */
+	if (lrng_drng) {
+		u32 node;
+
+		for_each_online_node(node) {
+			if (lrng_drng[node])
+				ret =3D lrng_drng_switch(lrng_drng[node], cb,
+						       node);
+		}
+	} else {
+		ret =3D lrng_drng_switch(lrng_drng_init, cb, 0);
+	}
+
+	if (!ret)
+		lrng_set_available();
+
+	return 0;
+}
+
+/**
+ * lrng_set_drng_cb - Register new cryptographic callback functions for DR=
NG
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
+	struct lrng_drng *lrng_drng_init =3D lrng_drng_init_instance();
+	int ret;
+
+	if (!cb)
+		cb =3D &lrng_cc20_crypto_cb;
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
+	if ((cb !=3D &lrng_cc20_crypto_cb) &&
+	    (lrng_drng_init->crypto_cb !=3D &lrng_cc20_crypto_cb)) {
+		pr_warn("disallow setting new cipher callbacks, unload the old callbacks=
 first!\n");
+		ret =3D -EINVAL;
+		goto out;
+	}
+
+	ret =3D lrng_drngs_switch(cb);
+
+out:
+	mutex_unlock(&lrng_crypto_cb_update);
+	return ret;
+}
+EXPORT_SYMBOL(lrng_set_drng_cb);
=2D-=20
2.26.2




