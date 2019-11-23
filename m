Return-Path: <SRS0=AJZI=ZP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877A2C43215
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 20:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 577AE204FD
	for <linux-crypto@archiver.kernel.org>; Sat, 23 Nov 2019 20:40:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="dixvTwZc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfKWUjp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 23 Nov 2019 15:39:45 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.124]:8933 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfKWUjo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 23 Nov 2019 15:39:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1574541578;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=p+/Xlqo7If7tuaOyfbuWJk4O4l5TUpTRKUwTp4QXRWc=;
        b=dixvTwZcrp6YEZDBouKrzhyE/9++I3kVpX4ye77PmBGwDYvrP+rvBPPjfqF/UcLmm0
        R4HqcMpxWwszzpgYoTsjioT+Tt1HyEXnbftv0OFuYLJmHE5ruppBf7PqnGjA8+L8BrDK
        WWBLt8DBKisDyWyyMWdp+W/l1t30MF5/Ppgb+Ct1q08DDpMH5l9BLZYvzuP59iiYq+9+
        DLVvue7C3lJQl9CG12xjs1hTvjdmYs3v/RYQUAL82xnCjjFaw2grusxTxzHATQXPibgX
        D+Xrz/TYuiqwViKGLlG0MXHq8uP2r26hC/wmslAwYDHAZN94AnW1hP+6PwQJ3/uacpK1
        QRTQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDaJfSfWrhX"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id N09a57vANKcd3ya
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Sat, 23 Nov 2019 21:38:39 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Nicolai Stange <nstange@suse.de>,
        "Peter, Matthias" <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Roman Drahtmueller <draht@schaltsekun.de>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v26 02/12] LRNG - allocate one SDRNG instance per NUMA node
Date:   Sat, 23 Nov 2019 21:10:41 +0100
Message-ID: <56236375.DK8cemDQLA@positron.chronox.de>
In-Reply-To: <2722222.P16TYeLAVu@positron.chronox.de>
References: <6157374.ptSnyUpaCn@positron.chronox.de> <2787174.DQlWHN5GGo@positron.chronox.de> <2722222.P16TYeLAVu@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In order to improve NUMA-locality when serving getrandom(2) requests,
allocate one DRNG instance per node.

The SDRNG instance that is present right from the start of the kernel is
reused as the first per-NUMA-node SDRNG. For all remaining online NUMA
nodes a new SDRNG instance is allocated.

During boot time, the multiple SDRNG instances are seeded sequentially.
With this, the first SDRNG instance (referenced as the initial SDRNG
in the code) is completely seeded with 256 bits of entropy before the
next SDRNG instance is completely seeded.

When random numbers are requested, the NUMA-node-local SDRNG is checked
whether it has been already fully seeded. If this is not the case, the
initial SDRNG is used to serve the request.

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
 drivers/char/lrng/Makefile        |   2 +
 drivers/char/lrng/lrng_internal.h |   5 ++
 drivers/char/lrng/lrng_numa.c     | 101 ++++++++++++++++++++++++++++++
 3 files changed, 108 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_numa.c

diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 2761623715d2..a00cddb45773 100644
=2D-- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -7,3 +7,5 @@ obj-y				+=3D lrng_pool.o lrng_aux.o \
 				   lrng_sw_noise.o lrng_archrandom.o \
 				   lrng_sdrng.o lrng_chacha20.o \
 				   lrng_interfaces.o \
+
+obj-$(CONFIG_NUMA)		+=3D lrng_numa.o
diff --git a/drivers/char/lrng/lrng_internal.h b/drivers/char/lrng/lrng_int=
ernal.h
index 675ba28bd2e6..fb7890939089 100644
=2D-- a/drivers/char/lrng/lrng_internal.h
+++ b/drivers/char/lrng/lrng_internal.h
@@ -261,8 +261,13 @@ int lrng_sdrng_get_sleep(u8 *outbuf, u32 outbuflen);
 void lrng_sdrng_force_reseed(void);
 void lrng_sdrng_seed_work(struct work_struct *dummy);
=20
+#ifdef CONFIG_NUMA
+struct lrng_sdrng **lrng_sdrng_instances(void);
+void lrng_drngs_numa_alloc(void);
+#else	/* CONFIG_NUMA */
 static inline struct lrng_sdrng **lrng_sdrng_instances(void) { return NULL=
; }
 static inline void lrng_drngs_numa_alloc(void) { return; }
+#endif /* CONFIG_NUMA */
=20
 /************************** Health Test linking code *********************=
*****/
=20
diff --git a/drivers/char/lrng/lrng_numa.c b/drivers/char/lrng/lrng_numa.c
new file mode 100644
index 000000000000..5401f927919a
=2D-- /dev/null
+++ b/drivers/char/lrng/lrng_numa.c
@@ -0,0 +1,101 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG NUMA support
+ *
+ * Copyright (C) 2016 - 2019, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/lrng.h>
+#include <linux/slab.h>
+
+#include "lrng_internal.h"
+
+static struct lrng_sdrng **lrng_sdrng __read_mostly =3D NULL;
+
+struct lrng_sdrng **lrng_sdrng_instances(void)
+{
+	return lrng_sdrng;
+}
+
+/* Allocate the data structures for the per-NUMA node DRNGs */
+static void _lrng_drngs_numa_alloc(struct work_struct *work)
+{
+	struct lrng_sdrng **sdrngs;
+	struct lrng_sdrng *lrng_sdrng_init =3D lrng_sdrng_init_instance();
+	u32 node;
+	bool init_sdrng_used =3D false;
+
+	mutex_lock(&lrng_crypto_cb_update);
+
+	/* per-NUMA-node DRNGs are already present */
+	if (lrng_sdrng)
+		goto unlock;
+
+	sdrngs =3D kcalloc(nr_node_ids, sizeof(void *), GFP_KERNEL|__GFP_NOFAIL);
+	for_each_online_node(node) {
+		struct lrng_sdrng *sdrng;
+
+		if (!init_sdrng_used) {
+			sdrngs[node] =3D lrng_sdrng_init;
+			init_sdrng_used =3D true;
+			continue;
+		}
+
+		sdrng =3D kmalloc_node(sizeof(struct lrng_sdrng),
+				     GFP_KERNEL|__GFP_NOFAIL, node);
+		memset(sdrng, 0, sizeof(lrng_sdrng));
+
+		sdrng->crypto_cb =3D lrng_sdrng_init->crypto_cb;
+		sdrng->sdrng =3D sdrng->crypto_cb->lrng_drng_alloc(
+					LRNG_DRNG_SECURITY_STRENGTH_BYTES);
+		if (IS_ERR(sdrng->sdrng)) {
+			kfree(sdrng);
+			goto err;
+		}
+
+		mutex_init(&sdrng->lock);
+		spin_lock_init(&sdrng->spin_lock);
+
+		/*
+		 * No reseeding of NUMA DRNGs from previous DRNGs as this
+		 * would complicate the code. Let it simply reseed.
+		 */
+		lrng_sdrng_reset(sdrng);
+		sdrngs[node] =3D sdrng;
+
+		lrng_pool_inc_numa_node();
+		pr_info("secondary DRNG for NUMA node %d allocated\n", node);
+	}
+
+	/* Ensure that all NUMA nodes receive changed memory here. */
+	mb();
+
+	if (!cmpxchg(&lrng_sdrng, NULL, sdrngs))
+		goto unlock;
+
+err:
+	for_each_online_node(node) {
+		struct lrng_sdrng *sdrng =3D sdrngs[node];
+
+		if (sdrng =3D=3D lrng_sdrng_init)
+			continue;
+
+		if (sdrng) {
+			sdrng->crypto_cb->lrng_drng_dealloc(sdrng->sdrng);
+			kfree(sdrng);
+		}
+	}
+	kfree(sdrngs);
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
=2D-=20
2.23.0




