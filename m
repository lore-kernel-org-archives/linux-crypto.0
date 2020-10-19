Return-Path: <SRS0=7/wf=D2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F334C4363D
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 19:53:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E37E3222C2
	for <linux-crypto@archiver.kernel.org>; Mon, 19 Oct 2020 19:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="iPUuwz2H"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731576AbgJSTxb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 19 Oct 2020 15:53:31 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.179]:34146 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731419AbgJSTwq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Oct 2020 15:52:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1603137162;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=+v/bsCsJhKy5vLwMSLj5aaJGDfzbnF1Civ8ZP0F0mAY=;
        b=iPUuwz2HHxym2X1rt44bQDbYHjt5ouVnqIKrzRpHQ1TQbBJi9ky2/0gFHoic1vIzRj
        RQPYWrxV1oHiXnXYU65dLh6N2nJGbIeQJ8NrKSWeQfihWJTP65jBlekyDCmXOo3e5/tC
        ioP2AqQSeWD7ALMln1NmvkCuxBbH2/Be1apOC00XGOj2v//rRpnlFJ1CJrImWYPDs3KT
        p59PyXbZ324IPRpIRDuuZeLbSWIPrIVdH5N4Ayt1iL3TruI+KWkak73kr7pmZ/thE95x
        AnMtxv9ICYUAwjwm8xQ7L6ddD9F9I0tDnaDwOAcsC2UZQP46MFfWMXkHdNgI3bOWoWt6
        HMDg==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJPSb3t0="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 47.2.1 DYNA|AUTH)
        with ESMTPSA id C0b627w9JJpiU6s
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 19 Oct 2020 21:51:44 +0200 (CEST)
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
Subject: [PATCH v36 07/13] LRNG - add SP800-90A DRBG extension
Date:   Mon, 19 Oct 2020 21:34:51 +0200
Message-ID: <7861221.NyiUUSuA9g@positron.chronox.de>
In-Reply-To: <3073852.aeNJFYEL58@positron.chronox.de>
References: <20200921075857.4424-1-nstange@suse.de> <20201016172619.GA18410@lst.de> <3073852.aeNJFYEL58@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Using the LRNG switchable DRNG support, the SP800-90A DRBG extension is
implemented.

The DRBG uses the kernel crypto API DRBG implementation. In addition, it
uses the kernel crypto API SHASH support to provide the hashing
operation.

The DRBG supports the choice of either a CTR DRBG using AES-256, HMAC
DRBG with SHA-512 core or Hash DRBG with SHA-512 core. The used core can
be selected with the module parameter lrng_drbg_type. The default is the
CTR DRBG.

When compiling the DRBG extension statically, the DRBG is loaded at
late_initcall stage which implies that with the start of user space, the
user space interfaces of getrandom(2), /dev/random and /dev/urandom
provide random data produced by an SP800-90A DRBG.

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
Reviewed-by: Roman Drahtmueller <draht@schaltsekun.de>
Tested-by: Roman Drahtm=FCller <draht@schaltsekun.de>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
=2D--
 drivers/char/lrng/Kconfig     |  10 ++
 drivers/char/lrng/Makefile    |   1 +
 drivers/char/lrng/lrng_drbg.c | 197 ++++++++++++++++++++++++++++++++++
 3 files changed, 208 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_drbg.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index daa2057248ac..a3c4cd153f35 100644
=2D-- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -81,6 +81,16 @@ if LRNG_DRNG_SWITCH
 config LRNG_KCAPI_HASH
 	bool
=20
+config LRNG_DRBG
+	tristate "SP800-90A support for the LRNG"
+	depends on CRYPTO
+	select CRYPTO_DRBG_MENU
+	select CRYPTO_SHA512
+	select LRNG_KCAPI_HASH
+	help
+	  Enable the SP800-90A DRBG support for the LRNG. Once the
+	  module is loaded, output from /dev/random, /dev/urandom,
+	  getrandom(2), or get_random_bytes_full is provided by a DRBG.
 endif # LRNG_DRNG_SWITCH
=20
 endif # LRNG
diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 40f8826edeeb..6ebd252db12f 100644
=2D-- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -12,3 +12,4 @@ obj-$(CONFIG_NUMA)		+=3D lrng_numa.o
 obj-$(CONFIG_SYSCTL)		+=3D lrng_proc.o
 obj-$(CONFIG_LRNG_DRNG_SWITCH)	+=3D lrng_switch.o
 obj-$(CONFIG_LRNG_KCAPI_HASH)	+=3D lrng_kcapi_hash.o
+obj-$(CONFIG_LRNG_DRBG)		+=3D lrng_drbg.o
diff --git a/drivers/char/lrng/lrng_drbg.c b/drivers/char/lrng/lrng_drbg.c
new file mode 100644
index 000000000000..c428d41af64d
=2D-- /dev/null
+++ b/drivers/char/lrng/lrng_drbg.c
@@ -0,0 +1,197 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * Backend for the LRNG providing the cryptographic primitives using the
+ * kernel crypto API and its DRBG.
+ *
+ * Copyright (C) 2016 - 2020, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/drbg.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/lrng.h>
+
+#include "lrng_kcapi_hash.h"
+
+/*
+ * Define a DRBG plus a hash / MAC used to extract data from the entropy p=
ool.
+ * For LRNG_HASH_NAME you can use a hash or a MAC (HMAC or CMAC) of your c=
hoice
+ * (Note, you should use the suggested selections below -- using SHA-1 or =
MD5
+ * is not wise). The idea is that the used cipher primitive can be selecte=
d to
+ * be the same as used for the DRBG. I.e. the LRNG only uses one cipher
+ * primitive using the same cipher implementation with the options offered=
 in
+ * the following. This means, if the CTR DRBG is selected and AES-NI is pr=
esent,
+ * both the CTR DRBG and the selected cmac(aes) use AES-NI.
+ *
+ * The security strengths of the DRBGs are all 256 bits according to
+ * SP800-57 section 5.6.1.
+ *
+ * This definition is allowed to be changed.
+ */
+#ifdef CONFIG_CRYPTO_DRBG_CTR
+static unsigned int lrng_drbg_type =3D 0;
+#elif defined CONFIG_CRYPTO_DRBG_HMAC
+static unsigned int lrng_drbg_type =3D 1;
+#elif defined CONFIG_CRYPTO_DRBG_HASH
+static unsigned int lrng_drbg_type =3D 2;
+#else
+#error "Unknown DRBG in use"
+#endif
+
+/* The parameter must be r/o in sysfs as otherwise races appear. */
+module_param(lrng_drbg_type, uint, 0444);
+MODULE_PARM_DESC(lrng_drbg_type, "DRBG type used for LRNG (0->CTR_DRBG, 1-=
>HMAC_DRBG, 2->Hash_DRBG)");
+
+struct lrng_drbg {
+	const char *hash_name;
+	const char *drbg_core;
+};
+
+static const struct lrng_drbg lrng_drbg_types[] =3D {
+	{	/* CTR_DRBG with AES-256 using derivation function */
+		.hash_name =3D "sha512",
+		.drbg_core =3D "drbg_nopr_ctr_aes256",
+	}, {	/* HMAC_DRBG with SHA-512 */
+		.hash_name =3D "sha512",
+		.drbg_core =3D "drbg_nopr_hmac_sha512",
+	}, {	/* Hash_DRBG with SHA-512 using derivation function */
+		.hash_name =3D "sha512",
+		.drbg_core =3D "drbg_nopr_sha512"
+	}
+};
+
+static int lrng_drbg_drng_seed_helper(void *drng, const u8 *inbuf, u32 inb=
uflen)
+{
+	struct drbg_state *drbg =3D (struct drbg_state *)drng;
+	LIST_HEAD(seedlist);
+	struct drbg_string data;
+	int ret;
+
+	drbg_string_fill(&data, inbuf, inbuflen);
+	list_add_tail(&data.list, &seedlist);
+	ret =3D drbg->d_ops->update(drbg, &seedlist, drbg->seeded);
+
+	if (ret >=3D 0)
+		drbg->seeded =3D true;
+
+	return ret;
+}
+
+static int lrng_drbg_drng_generate_helper(void *drng, u8 *outbuf, u32 outb=
uflen)
+{
+	struct drbg_state *drbg =3D (struct drbg_state *)drng;
+
+	return drbg->d_ops->generate(drbg, outbuf, outbuflen, NULL);
+}
+
+static void *lrng_drbg_drng_alloc(u32 sec_strength)
+{
+	struct drbg_state *drbg;
+	int coreref =3D -1;
+	bool pr =3D false;
+	int ret;
+
+	drbg_convert_tfm_core(lrng_drbg_types[lrng_drbg_type].drbg_core,
+			      &coreref, &pr);
+	if (coreref < 0)
+		return ERR_PTR(-EFAULT);
+
+	drbg =3D kzalloc(sizeof(struct drbg_state), GFP_KERNEL);
+	if (!drbg)
+		return ERR_PTR(-ENOMEM);
+
+	drbg->core =3D &drbg_cores[coreref];
+	drbg->seeded =3D false;
+	ret =3D drbg_alloc_state(drbg);
+	if (ret)
+		goto err;
+
+	if (sec_strength > drbg_sec_strength(drbg->core->flags)) {
+		pr_err("Security strength of DRBG (%u bits) lower than requested by LRNG=
 (%u bits)\n",
+			drbg_sec_strength(drbg->core->flags) * 8,
+			sec_strength * 8);
+		goto dealloc;
+	}
+
+	if (sec_strength < drbg_sec_strength(drbg->core->flags))
+		pr_warn("Security strength of DRBG (%u bits) higher than requested by LR=
NG (%u bits)\n",
+			drbg_sec_strength(drbg->core->flags) * 8,
+			sec_strength * 8);
+
+	pr_info("DRBG with %s core allocated\n", drbg->core->backend_cra_name);
+
+	return drbg;
+
+dealloc:
+	if (drbg->d_ops)
+		drbg->d_ops->crypto_fini(drbg);
+	drbg_dealloc_state(drbg);
+err:
+	kfree(drbg);
+	return ERR_PTR(-EINVAL);
+}
+
+static void lrng_drbg_drng_dealloc(void *drng)
+{
+	struct drbg_state *drbg =3D (struct drbg_state *)drng;
+
+	if (drbg && drbg->d_ops)
+		drbg->d_ops->crypto_fini(drbg);
+	drbg_dealloc_state(drbg);
+	kfree_sensitive(drbg);
+	pr_info("DRBG deallocated\n");
+}
+
+static void *lrng_drbg_hash_alloc(void)
+{
+	return lrng_kcapi_hash_alloc(lrng_drbg_types[lrng_drbg_type].hash_name);
+}
+
+static const char *lrng_drbg_name(void)
+{
+	return lrng_drbg_types[lrng_drbg_type].drbg_core;
+}
+
+static const char *lrng_hash_name(void)
+{
+	return lrng_drbg_types[lrng_drbg_type].hash_name;
+}
+
+static const struct lrng_crypto_cb lrng_drbg_crypto_cb =3D {
+	.lrng_drng_name			=3D lrng_drbg_name,
+	.lrng_hash_name			=3D lrng_hash_name,
+	.lrng_drng_alloc		=3D lrng_drbg_drng_alloc,
+	.lrng_drng_dealloc		=3D lrng_drbg_drng_dealloc,
+	.lrng_drng_seed_helper		=3D lrng_drbg_drng_seed_helper,
+	.lrng_drng_generate_helper	=3D lrng_drbg_drng_generate_helper,
+	.lrng_hash_alloc		=3D lrng_drbg_hash_alloc,
+	.lrng_hash_dealloc		=3D lrng_kcapi_hash_dealloc,
+	.lrng_hash_digestsize		=3D lrng_kcapi_hash_digestsize,
+	.lrng_hash_init			=3D lrng_kcapi_hash_init,
+	.lrng_hash_update		=3D lrng_kcapi_hash_update,
+	.lrng_hash_final		=3D lrng_kcapi_hash_final,
+};
+
+static int __init lrng_drbg_init(void)
+{
+	if (lrng_drbg_type >=3D ARRAY_SIZE(lrng_drbg_types)) {
+		pr_err("lrng_drbg_type parameter too large (given %u - max: %lu)",
+		       lrng_drbg_type,
+		       (unsigned long)ARRAY_SIZE(lrng_drbg_types) - 1);
+		return -EAGAIN;
+	}
+	return lrng_set_drng_cb(&lrng_drbg_crypto_cb);
+}
+
+static void __exit lrng_drbg_exit(void)
+{
+	lrng_set_drng_cb(NULL);
+}
+
+late_initcall(lrng_drbg_init);
+module_exit(lrng_drbg_exit);
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("Linux Random Number Generator - SP800-90A DRBG backend=
");
=2D-=20
2.26.2




