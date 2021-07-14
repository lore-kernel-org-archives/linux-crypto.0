Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2207BC11F67
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jul 2021 05:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B5BB613B9
	for <linux-crypto@archiver.kernel.org>; Wed, 14 Jul 2021 05:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbhGNFy6 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 14 Jul 2021 01:54:58 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([81.169.146.223]:13894 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237957AbhGNFy5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Jul 2021 01:54:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1626241857;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=kIn18Gl5jJH4Qdjhpwk/B77xDmu22AE5ZZyc01lwBWU=;
    b=dlKtEsaKCju2aKn8wTYqlt3fydAvh0U7DKx1ZOMm0kfyF3b6+/C4M6omw+GL8NMD8l
    +hTK1PNgTkWxr1/2Ad7xOG6RSNOQvUrJ1RPlYk0dcWxwbygIqzvT/ZeuEg3ssqSPYAXL
    kbprzolGu/bCp0FjItI2NSHGN7Ne3I7AWKzZJRCmXqp08dhMcW9DETAkpWfNGdbvVB5N
    AT7q+9RJ+xSxshYwr+UuO4kBm2nPhyYr28xfKmfzpW/L9Fg6/Pmy2W/7yzsDkH30mI/C
    2/ZSCTXwdqqShOQfXMPJvisPG0iRzN8ywSSMvu74KqwkcuS2jMHExGWd43OX8KxEYPfN
    L2nQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXPSI/SaRQ=="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.28.1 DYNA|AUTH)
    with ESMTPSA id N0753fx6E5ouwyZ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 14 Jul 2021 07:50:56 +0200 (CEST)
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
Subject: [PATCH v41 05/13] LRNG - add common generic hash support
Date:   Wed, 14 Jul 2021 07:45:48 +0200
Message-ID: <2460884.q7F22EL2Vm@positron.chronox.de>
In-Reply-To: <7822794.ITf6fX9eNu@positron.chronox.de>
References: <7822794.ITf6fX9eNu@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The LRNG switchable DRNG support also allows the replacement of the hash
implementation used as conditioning component. The common generic hash
support code provides the required callbacks using the synchronous hash
implementations of the kernel crypto API.

All synchronous hash implementations supported by the kernel crypto API
can be used as part of the LRNG with this generic support.

The generic support is intended to be configured by separate switchable
DRNG backends.

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
CC: "Peter, Matthias" <matthias.peter@bsi.bund.de>
CC: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
CC: Neil Horman <nhorman@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/lrng/Kconfig           |   8 +++
 drivers/char/lrng/Makefile          |   1 +
 drivers/char/lrng/lrng_kcapi_hash.c | 103 ++++++++++++++++++++++++++++
 drivers/char/lrng/lrng_kcapi_hash.h |  20 ++++++
 4 files changed, 132 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_kcapi_hash.c
 create mode 100644 drivers/char/lrng/lrng_kcapi_hash.h

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index c10a0c3f2015..ab17c45a356b 100644
--- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -209,4 +209,12 @@ menuconfig LRNG_DRNG_SWITCH
 	  accessible via the external interfaces. With this configuration
 	  option other DRNGs can be selected and loaded at runtime.
 
+if LRNG_DRNG_SWITCH
+
+config LRNG_KCAPI_HASH
+	bool
+	select CRYPTO_HASH
+
+endif # LRNG_DRNG_SWITCH
+
 endif # LRNG
diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 0eb4a6849c88..40f8826edeeb 100644
--- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -11,3 +11,4 @@ obj-y				+= lrng_pool.o lrng_aux.o \
 obj-$(CONFIG_NUMA)		+= lrng_numa.o
 obj-$(CONFIG_SYSCTL)		+= lrng_proc.o
 obj-$(CONFIG_LRNG_DRNG_SWITCH)	+= lrng_switch.o
+obj-$(CONFIG_LRNG_KCAPI_HASH)	+= lrng_kcapi_hash.o
diff --git a/drivers/char/lrng/lrng_kcapi_hash.c b/drivers/char/lrng/lrng_kcapi_hash.c
new file mode 100644
index 000000000000..9647d980e468
--- /dev/null
+++ b/drivers/char/lrng/lrng_kcapi_hash.c
@@ -0,0 +1,103 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * Backend for providing the hash primitive using the kernel crypto API.
+ *
+ * Copyright (C) 2021, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/hash.h>
+
+#include "lrng_kcapi_hash.h"
+
+struct lrng_hash_info {
+	struct crypto_shash *tfm;
+};
+
+static inline void _lrng_kcapi_hash_free(struct lrng_hash_info *lrng_hash)
+{
+	struct crypto_shash *tfm = lrng_hash->tfm;
+
+	crypto_free_shash(tfm);
+	kfree(lrng_hash);
+}
+
+void *lrng_kcapi_hash_alloc(const char *name)
+{
+	struct lrng_hash_info *lrng_hash;
+	struct crypto_shash *tfm;
+	int ret;
+
+	if (!name) {
+		pr_err("Hash name missing\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	tfm = crypto_alloc_shash(name, 0, 0);
+	if (IS_ERR(tfm)) {
+		pr_err("could not allocate hash %s\n", name);
+		return ERR_CAST(tfm);
+	}
+
+	ret = sizeof(struct lrng_hash_info);
+	lrng_hash = kmalloc(ret, GFP_KERNEL);
+	if (!lrng_hash) {
+		crypto_free_shash(tfm);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	lrng_hash->tfm = tfm;
+
+	pr_info("Hash %s allocated\n", name);
+
+	return lrng_hash;
+}
+EXPORT_SYMBOL(lrng_kcapi_hash_alloc);
+
+u32 lrng_kcapi_hash_digestsize(void *hash)
+{
+	struct lrng_hash_info *lrng_hash = (struct lrng_hash_info *)hash;
+	struct crypto_shash *tfm = lrng_hash->tfm;
+
+	return crypto_shash_digestsize(tfm);
+}
+EXPORT_SYMBOL(lrng_kcapi_hash_digestsize);
+
+void lrng_kcapi_hash_dealloc(void *hash)
+{
+	struct lrng_hash_info *lrng_hash = (struct lrng_hash_info *)hash;
+
+	_lrng_kcapi_hash_free(lrng_hash);
+	pr_info("Hash deallocated\n");
+}
+EXPORT_SYMBOL(lrng_kcapi_hash_dealloc);
+
+int lrng_kcapi_hash_init(struct shash_desc *shash, void *hash)
+{
+	struct lrng_hash_info *lrng_hash = (struct lrng_hash_info *)hash;
+	struct crypto_shash *tfm = lrng_hash->tfm;
+
+	shash->tfm = tfm;
+	return crypto_shash_init(shash);
+}
+EXPORT_SYMBOL(lrng_kcapi_hash_init);
+
+int lrng_kcapi_hash_update(struct shash_desc *shash, const u8 *inbuf,
+			   u32 inbuflen)
+{
+	return crypto_shash_update(shash, inbuf, inbuflen);
+}
+EXPORT_SYMBOL(lrng_kcapi_hash_update);
+
+int lrng_kcapi_hash_final(struct shash_desc *shash, u8 *digest)
+{
+	return crypto_shash_final(shash, digest);
+}
+EXPORT_SYMBOL(lrng_kcapi_hash_final);
+
+void lrng_kcapi_hash_zero(struct shash_desc *shash)
+{
+	shash_desc_zero(shash);
+}
+EXPORT_SYMBOL(lrng_kcapi_hash_zero);
diff --git a/drivers/char/lrng/lrng_kcapi_hash.h b/drivers/char/lrng/lrng_kcapi_hash.h
new file mode 100644
index 000000000000..2f94558d2dd6
--- /dev/null
+++ b/drivers/char/lrng/lrng_kcapi_hash.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Copyright (C) 2020 - 2021, Stephan Mueller <smueller@chronox.de>
+ */
+
+#ifndef _LRNG_KCAPI_HASH_H
+#define _LRNG_KCAPI_HASH_H
+
+#include <linux/module.h>
+
+void *lrng_kcapi_hash_alloc(const char *name);
+u32 lrng_kcapi_hash_digestsize(void *hash);
+void lrng_kcapi_hash_dealloc(void *hash);
+int lrng_kcapi_hash_init(struct shash_desc *shash, void *hash);
+int lrng_kcapi_hash_update(struct shash_desc *shash, const u8 *inbuf,
+			   u32 inbuflen);
+int lrng_kcapi_hash_final(struct shash_desc *shash, u8 *digest);
+void lrng_kcapi_hash_zero(struct shash_desc *shash);
+
+#endif /* _LRNG_KCAPI_HASH_H */
-- 
2.31.1




