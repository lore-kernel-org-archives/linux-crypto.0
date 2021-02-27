Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3BB7C433E0
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Feb 2021 13:45:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C46A64EBC
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Feb 2021 13:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbhB0Npb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Feb 2021 08:45:31 -0500
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.177]:27120 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbhB0Npa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Feb 2021 08:45:30 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1614433259; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=OKJbVmiU9Z89hzfbqyHcD6e198GO2JUfUGoZgxRfFFUp9vVPZjE9JcS8z6BEba3CvE
    2Ub2Qc4vk4cEPXqlQE7ewyLclJSUfkPXpAyo0zF0rO1sCeUHRgMGJMhqKgveAfprhz9P
    tMEcA2zyVMYaaXO60JU4r6bFgDD+e6IcsYjq+GIUvCYnG4V12jwDIrZe+U0WVfhuiGcX
    No+/2OkTS1B5XoF/MQqeh9kjqG2lF/KZvLRZOPyHFoJngw6f2VwTkamsUhV81NOJir1v
    4bFmhYYY7/9AvIH2a5ZVICYJvHokwkarH4bL5u4c9G5A8G/F0JXUin6o7vw/KuARK86c
    Ubfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1614433259;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=bVwbrLTWDiRymsY9m3ShBMD93WrfDDhmROGLTUcpmO8=;
    b=qsOGc4Vh5uFxfJ40zcRH3CVYsOSK1i3he5uUy+MzvJ04mZA9ig6cus8R0dBJ9U2OYt
    tDzaswRx75cN5VGWT3kX4R9SC6i7ADjaL7iQNCBFdkhrrevy82UHafRmAt6Mvb3WgkbN
    Rz6E5Q0L8akwcR2o+3wkW1JuUWl8W1jCK0s4pC1/F/VR+REoP94Ze0K0IB061UeFVlLL
    d4tn9ZqZCkLvdEWNxVwHnTPFI73yOjAyfuGXbPMGWm0tg8kBNq0rtal4kfxGMFvsFNvb
    pY92ni+bAEOvRvcyB3KX3oJzNrxB6anKX9T4Y2OW9mPcEjv1xA/eNLdbF5zGnsCLGxYI
    SFvQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1614433259;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=bVwbrLTWDiRymsY9m3ShBMD93WrfDDhmROGLTUcpmO8=;
    b=S1Is8ss7+yjX5AZa7qIl666SGjAR5y2+fKNMR8n7nxyxXJyNpGzLuj3tedEjF8m66U
    bFMiJM1Q0txWHV/uHm7LHzgqS34+uHvQ9eXCKC6JJp8azB1ubRJFlGRnMoDc01zXyj6f
    Gx2mAsPJIYTR/5HGaFFA6zABJkXrlTrRWSdj8bx0Oz08cSE7jpol6CffkSrL8fEsJ0L1
    6WNIRRF9YUztDSmENj3NoOUeDSPblNF0TVtFCS//4YBPkkNChFAKypIj79jEKv2h+4MO
    kkMQzTXOZtA2YHwGbC4a6GZtJZj0WqTWsekY8jHIu86XMv/9gNUJ5AL4AxVtmstSvuEd
    Jyqw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZIfSc8k+7"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.19.0 DYNA|AUTH)
    with ESMTPSA id 608030x1RDewUDI
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sat, 27 Feb 2021 14:40:58 +0100 (CET)
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
Subject: [PATCH v38 03/13] LRNG - sysctls and /proc interface
Date:   Sat, 27 Feb 2021 14:35:35 +0100
Message-ID: <3408825.R56niFO833@positron.chronox.de>
In-Reply-To: <3277560.QJadu78ljV@positron.chronox.de>
References: <3277560.QJadu78ljV@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The LRNG sysctl interface provides the same controls as the existing
/dev/random implementation. These sysctls behave identically and are
implemented identically. The goal is to allow a possible merge of the
existing /dev/random implementation with this implementation which
implies that this patch tries have a very close similarity. Yet, all
sysctls are documented at [1].

In addition, it provides the file lrng_type which provides details about
the LRNG:

=2D the name of the DRNG that produces the random numbers for /dev/random,
/dev/urandom, getrandom(2)

=2D the hash used to produce random numbers from the entropy pool

=2D the number of secondary DRNG instances

=2D indicator whether the LRNG operates SP800-90B compliant

=2D indicator whether a high-resolution timer is identified - only with a
high-resolution timer the interrupt noise source will deliver sufficient
entropy

=2D indicator whether the LRNG has been minimally seeded (i.e. is the
secondary DRNG seeded with at least 128 bits of of entropy)

=2D indicator whether the LRNG has been fully seeded (i.e. is the
secondary DRNG seeded with at least 256 bits of entropy)

[1] https://www.chronox.de/lrng.html

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
 drivers/char/lrng/Makefile          |   1 +
 drivers/char/lrng/lrng_interfaces.c |   2 -
 drivers/char/lrng/lrng_internal.h   |   4 +
 drivers/char/lrng/lrng_proc.c       | 184 ++++++++++++++++++++++++++++
 4 files changed, 189 insertions(+), 2 deletions(-)
 create mode 100644 drivers/char/lrng/lrng_proc.c

diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 29724c65287d..ac97f0b11cb7 100644
=2D-- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -9,3 +9,4 @@ obj-y				+=3D lrng_pool.o lrng_aux.o \
 				   lrng_interfaces.o
=20
 obj-$(CONFIG_NUMA)		+=3D lrng_numa.o
+obj-$(CONFIG_SYSCTL)		+=3D lrng_proc.o
diff --git a/drivers/char/lrng/lrng_interfaces.c b/drivers/char/lrng/lrng_i=
nterfaces.c
index efcadcfa79f2..8121ba495844 100644
=2D-- a/drivers/char/lrng/lrng_interfaces.c
+++ b/drivers/char/lrng/lrng_interfaces.c
@@ -38,8 +38,6 @@ static DECLARE_WAIT_QUEUE_HEAD(lrng_write_wait);
 static DECLARE_WAIT_QUEUE_HEAD(lrng_init_wait);
 static struct fasync_struct *fasync;
=20
=2Dstruct ctl_table random_table[];
=2D
 /********************************** Helper *******************************=
****/
=20
 /* Is the DRNG seed level too low? */
diff --git a/drivers/char/lrng/lrng_internal.h b/drivers/char/lrng/lrng_int=
ernal.h
index 1bfb3710c767..0a9af852a8fe 100644
=2D-- a/drivers/char/lrng/lrng_internal.h
+++ b/drivers/char/lrng/lrng_internal.h
@@ -108,7 +108,11 @@ void lrng_cc20_init_state_boot(struct chacha20_state *=
state);
=20
 /********************************** /proc ********************************=
*****/
=20
+#ifdef CONFIG_SYSCTL
+void lrng_pool_inc_numa_node(void);
+#else
 static inline void lrng_pool_inc_numa_node(void) { }
+#endif
=20
 /****************************** LRNG interfaces **************************=
*****/
=20
diff --git a/drivers/char/lrng/lrng_proc.c b/drivers/char/lrng/lrng_proc.c
new file mode 100644
index 000000000000..244681679b39
=2D-- /dev/null
+++ b/drivers/char/lrng/lrng_proc.c
@@ -0,0 +1,184 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG proc and sysctl interfaces
+ *
+ * Copyright (C) 2016 - 2021, Stephan Mueller <smueller@chronox.de>
+ */
+
+#include <linux/lrng.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
+#include <linux/sysctl.h>
+#include <linux/uuid.h>
+
+#include "lrng_internal.h"
+#include "lrng_sw_noise.h"
+
+/*
+ * This function is used to return both the bootid UUID, and random
+ * UUID.  The difference is in whether table->data is NULL; if it is,
+ * then a new UUID is generated and returned to the user.
+ *
+ * If the user accesses this via the proc interface, the UUID will be
+ * returned as an ASCII string in the standard UUID format; if via the
+ * sysctl system call, as 16 bytes of binary data.
+ */
+static int lrng_proc_do_uuid(struct ctl_table *table, int write,
+			     void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table fake_table;
+	unsigned char buf[64], tmp_uuid[16], *uuid;
+
+	uuid =3D table->data;
+	if (!uuid) {
+		uuid =3D tmp_uuid;
+		generate_random_uuid(uuid);
+	} else {
+		static DEFINE_SPINLOCK(bootid_spinlock);
+
+		spin_lock(&bootid_spinlock);
+		if (!uuid[8])
+			generate_random_uuid(uuid);
+		spin_unlock(&bootid_spinlock);
+	}
+
+	sprintf(buf, "%pU", uuid);
+
+	fake_table.data =3D buf;
+	fake_table.maxlen =3D sizeof(buf);
+
+	return proc_dostring(&fake_table, write, buffer, lenp, ppos);
+}
+
+static int lrng_proc_do_entropy(struct ctl_table *table, int write,
+				void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table fake_table;
+	int entropy_count;
+
+	entropy_count =3D lrng_avail_entropy();
+
+	fake_table.data =3D &entropy_count;
+	fake_table.maxlen =3D sizeof(entropy_count);
+
+	return proc_dointvec(&fake_table, write, buffer, lenp, ppos);
+}
+
+static int lrng_proc_do_poolsize(struct ctl_table *table, int write,
+				 void *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table fake_table;
+	int entropy_count;
+
+	/* LRNG can at most retain entropy in per-CPU pools and aux pool */
+	entropy_count =3D lrng_get_digestsize() + lrng_pcpu_avail_pool_size();
+
+	fake_table.data =3D &entropy_count;
+	fake_table.maxlen =3D sizeof(entropy_count);
+
+	return proc_dointvec(&fake_table, write, buffer, lenp, ppos);
+}
+
+static int lrng_min_write_thresh;
+static int lrng_max_write_thresh =3D LRNG_MAX_DIGESTSIZE;
+static char lrng_sysctl_bootid[16];
+static int lrng_drng_reseed_max_min;
+
+struct ctl_table random_table[] =3D {
+	{
+		.procname	=3D "poolsize",
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0444,
+		.proc_handler	=3D lrng_proc_do_poolsize,
+	},
+	{
+		.procname	=3D "entropy_avail",
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0444,
+		.proc_handler	=3D lrng_proc_do_entropy,
+	},
+	{
+		.procname	=3D "write_wakeup_threshold",
+		.data		=3D &lrng_write_wakeup_bits,
+		.maxlen		=3D sizeof(int),
+		.mode		=3D 0644,
+		.proc_handler	=3D proc_dointvec_minmax,
+		.extra1		=3D &lrng_min_write_thresh,
+		.extra2		=3D &lrng_max_write_thresh,
+	},
+	{
+		.procname	=3D "boot_id",
+		.data		=3D &lrng_sysctl_bootid,
+		.maxlen		=3D 16,
+		.mode		=3D 0444,
+		.proc_handler	=3D lrng_proc_do_uuid,
+	},
+	{
+		.procname	=3D "uuid",
+		.maxlen		=3D 16,
+		.mode		=3D 0444,
+		.proc_handler	=3D lrng_proc_do_uuid,
+	},
+	{
+		.procname       =3D "urandom_min_reseed_secs",
+		.data           =3D &lrng_drng_reseed_max_time,
+		.maxlen         =3D sizeof(int),
+		.mode           =3D 0644,
+		.proc_handler   =3D proc_dointvec,
+		.extra1		=3D &lrng_drng_reseed_max_min,
+	},
+	{ }
+};
+
+/* Number of online DRNGs */
+static u32 numa_drngs =3D 1;
+
+void lrng_pool_inc_numa_node(void)
+{
+	numa_drngs++;
+}
+
+static int lrng_proc_type_show(struct seq_file *m, void *v)
+{
+	struct lrng_drng *lrng_drng_init =3D lrng_drng_init_instance();
+	unsigned long flags =3D 0;
+	unsigned char buf[365];
+
+	lrng_drng_lock(lrng_drng_init, &flags);
+	snprintf(buf, sizeof(buf),
+		 "DRNG name: %s\n"
+		 "Hash for reading entropy pool: %s\n"
+		 "Hash for operating aux entropy pool: %s\n"
+		 "LRNG security strength in bits: %d\n"
+		 "per-CPU interrupt collection size: %u\n"
+		 "number of DRNG instances: %u\n"
+		 "SP800-90B compliance: %s\n"
+		 "High-resolution timer: %s\n"
+		 "LRNG minimally seeded: %s\n"
+		 "LRNG fully seeded: %s\n"
+		 "Continuous compression: %s\n",
+		 lrng_drng_init->crypto_cb->lrng_drng_name(),
+		 lrng_drng_init->crypto_cb->lrng_hash_name(),
+		 lrng_drng_init->crypto_cb->lrng_hash_name(),
+		 lrng_security_strength(),
+		 LRNG_DATA_NUM_VALUES,
+		 numa_drngs,
+		 lrng_sp80090b_compliant() ? "true" : "false",
+		 lrng_pool_highres_timer() ? "true" : "false",
+		 lrng_state_min_seeded() ? "true" : "false",
+		 lrng_state_fully_seeded() ? "true" : "false",
+		 lrng_pcpu_continuous_compression_state() ? "true" : "false");
+	lrng_drng_unlock(lrng_drng_init, &flags);
+
+	seq_write(m, buf, strlen(buf));
+
+	return 0;
+}
+
+static int __init lrng_proc_type_init(void)
+{
+	proc_create_single("lrng_type", 0444, NULL, &lrng_proc_type_show);
+	return 0;
+}
+
+module_init(lrng_proc_type_init);
=2D-=20
2.29.2




