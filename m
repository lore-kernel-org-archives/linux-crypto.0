Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB91C433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 09:41:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 916C9610A6
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 09:41:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240289AbhIQJmp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Sep 2021 05:42:45 -0400
Received: from mo4-p04-ob.smtp.rzone.de ([85.215.255.124]:14700 "EHLO
        mo4-p04-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234309AbhIQJmo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Sep 2021 05:42:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1631871137;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=//Dh8M4SE2k0m4HMbZGh6aRuGT1nDrPqMIVtNyHu25A=;
    b=LP9oTvqbcmEk7IPZma1+z+fH1wEszZqpMsyKn5lgr1zEzwM1kaJpa0kbqoJNcBJOfB
    /iKz3buw1etFKNPw/nrDhTMVWB5QI8qRLLiRtFAkcqJqPQsXxi0geO7x3x1/RTuBAyLs
    15j+GAfcyvU5gDCH91Fl/ygJkFqTv8X8Sco/4ICSzrV7UtvL3m+aufu3hDarSJzhXCH5
    6jQlUAAYDI0hsDK1tPffGRgdFeyA+07KJwowm1iJOCEp3tOcAN3YjWOFFX3XpDinl0pG
    jILSP8ESn377q/r4RxyssJsiF9l2YAzf7RPdy20oudstCybk6paDco36gDhX9pZOGJpR
    QNMA==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvSOeicf6o="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.33.3 DYNA|AUTH)
    with ESMTPSA id f080d4x8H9WGcpV
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 17 Sep 2021 11:32:16 +0200 (CEST)
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
Subject: [PATCH v42 08/13] LRNG - add kernel crypto API PRNG extension
Date:   Thu, 16 Sep 2021 12:14:38 +0200
Message-ID: <2366920.bsEb6sMSpy@positron.chronox.de>
In-Reply-To: <2294055.9jK4hKOXjS@positron.chronox.de>
References: <2294055.9jK4hKOXjS@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add runtime-pluggable support for all PRNGs that are accessible via
the kernel crypto API, including hardware PRNGs. The PRNG is selected
with the module parameter drng_name where the name must be one that the
kernel crypto API can resolve into an RNG.

This allows using of the kernel crypto API PRNG implementations that
provide an interface to hardware PRNGs. Using this extension,
the LRNG uses the hardware PRNGs to generate random numbers. An
example is the S390 CPACF support providing such a PRNG.

The hash is provided by a kernel crypto API SHASH whose digest size
complies with the seedsize of the PRNG.

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
Reviewed-by: Roman Drahtmueller <draht@schaltsekun.de>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/lrng/Kconfig      |  13 ++
 drivers/char/lrng/Makefile     |   1 +
 drivers/char/lrng/lrng_kcapi.c | 227 +++++++++++++++++++++++++++++++++
 3 files changed, 241 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_kcapi.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index aa611363b97e..ffd2df43f2d4 100644
--- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -225,6 +225,19 @@ config LRNG_DRBG
 	  Enable the SP800-90A DRBG support for the LRNG. Once the
 	  module is loaded, output from /dev/random, /dev/urandom,
 	  getrandom(2), or get_random_bytes_full is provided by a DRBG.
+
+config LRNG_KCAPI
+	tristate "Kernel Crypto API support for the LRNG"
+	depends on CRYPTO
+	depends on !LRNG_DRBG
+	select CRYPTO_RNG
+	select LRNG_KCAPI_HASH
+	help
+	  Enable the support for generic pseudo-random number
+	  generators offered by the kernel crypto API with the
+	  LRNG. Once the module is loaded, output from /dev/random,
+	  /dev/urandom, getrandom(2), or get_random_bytes is
+	  provided by the selected kernel crypto API RNG.
 endif # LRNG_DRNG_SWITCH
 
 endif # LRNG
diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 7e5acb8cac3d..ad7c413cc0d9 100644
--- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -13,3 +13,4 @@ obj-$(CONFIG_SYSCTL)		+= lrng_proc.o
 obj-$(CONFIG_LRNG_DRNG_SWITCH)	+= lrng_switch.o
 obj-$(CONFIG_LRNG_KCAPI_HASH)	+= lrng_kcapi_hash.o
 obj-$(CONFIG_LRNG_DRBG)		+= lrng_drbg.o
+obj-$(CONFIG_LRNG_KCAPI)	+= lrng_kcapi.o
diff --git a/drivers/char/lrng/lrng_kcapi.c b/drivers/char/lrng/lrng_kcapi.c
new file mode 100644
index 000000000000..b06449cb2365
--- /dev/null
+++ b/drivers/char/lrng/lrng_kcapi.c
@@ -0,0 +1,227 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * Backend for the LRNG providing the cryptographic primitives using the
+ * kernel crypto API.
+ *
+ * Copyright (C) 2018 - 2021, Stephan Mueller <smueller@chronox.de>
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <crypto/hash.h>
+#include <crypto/rng.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/lrng.h>
+
+#include "lrng_kcapi_hash.h"
+
+static char *drng_name = NULL;
+module_param(drng_name, charp, 0444);
+MODULE_PARM_DESC(drng_name, "Kernel crypto API name of DRNG");
+
+static char *pool_hash = "sha512";
+module_param(pool_hash, charp, 0444);
+MODULE_PARM_DESC(pool_hash,
+		 "Kernel crypto API name of hash or keyed message digest to read the entropy pool");
+
+static char *seed_hash = NULL;
+module_param(seed_hash, charp, 0444);
+MODULE_PARM_DESC(seed_hash,
+		 "Kernel crypto API name of hash with output size equal to seedsize of DRNG to bring seed string to the size required by the DRNG");
+
+struct lrng_drng_info {
+	struct crypto_rng *kcapi_rng;
+	void *lrng_hash;
+};
+
+static void *lrng_kcapi_drng_hash_alloc(void)
+{
+	return lrng_kcapi_hash_alloc(pool_hash);
+}
+
+static int lrng_kcapi_drng_seed_helper(void *drng, const u8 *inbuf,
+				       u32 inbuflen)
+{
+	SHASH_DESC_ON_STACK(shash, NULL);
+	struct lrng_drng_info *lrng_drng_info = (struct lrng_drng_info *)drng;
+	struct crypto_rng *kcapi_rng = lrng_drng_info->kcapi_rng;
+	void *hash = lrng_drng_info->lrng_hash;
+	u32 digestsize = lrng_kcapi_hash_digestsize(hash);
+	u8 digest[64] __aligned(8);
+	int ret;
+
+	if (!hash)
+		return crypto_rng_reset(kcapi_rng, inbuf, inbuflen);
+
+	BUG_ON(digestsize > sizeof(digest));
+
+	ret = lrng_kcapi_hash_init(shash, hash) ?:
+	      lrng_kcapi_hash_update(shash, inbuf, inbuflen) ?:
+	      lrng_kcapi_hash_final(shash, digest);
+	lrng_kcapi_hash_zero(shash);
+	if (ret)
+		return ret;
+
+	ret = crypto_rng_reset(kcapi_rng, digest, digestsize);
+	if (ret)
+		return ret;
+
+	memzero_explicit(digest, digestsize);
+	return 0;
+}
+
+static int lrng_kcapi_drng_generate_helper(void *drng, u8 *outbuf,
+					   u32 outbuflen)
+{
+	struct lrng_drng_info *lrng_drng_info = (struct lrng_drng_info *)drng;
+	struct crypto_rng *kcapi_rng = lrng_drng_info->kcapi_rng;
+	int ret = crypto_rng_get_bytes(kcapi_rng, outbuf, outbuflen);
+
+	if (ret < 0)
+		return ret;
+
+	return outbuflen;
+}
+
+static void *lrng_kcapi_drng_alloc(u32 sec_strength)
+{
+	struct lrng_drng_info *lrng_drng_info;
+	struct crypto_rng *kcapi_rng;
+	int seedsize;
+	void *ret =  ERR_PTR(-ENOMEM);
+
+	if (!drng_name) {
+		pr_err("DRNG name missing\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (!memcmp(drng_name, "drbg", 4) ||
+	    !memcmp(drng_name, "stdrng", 6) ||
+	    !memcmp(drng_name, "jitterentropy_rng", 17)) {
+		pr_err("Refusing to load the requested random number generator\n");
+		return ERR_PTR(-EINVAL);
+	}
+
+	lrng_drng_info = kmalloc(sizeof(*lrng_drng_info), GFP_KERNEL);
+	if (!lrng_drng_info)
+		return ERR_PTR(-ENOMEM);
+
+	kcapi_rng = crypto_alloc_rng(drng_name, 0, 0);
+	if (IS_ERR(kcapi_rng)) {
+		pr_err("DRNG %s cannot be allocated\n", drng_name);
+		ret = ERR_CAST(kcapi_rng);
+		goto free;
+	}
+	lrng_drng_info->kcapi_rng = kcapi_rng;
+
+	seedsize =  crypto_rng_seedsize(kcapi_rng);
+
+	if (sec_strength > seedsize)
+		pr_info("Seedsize DRNG (%u bits) lower than security strength of LRNG noise source (%u bits)\n",
+			crypto_rng_seedsize(kcapi_rng) * 8, sec_strength * 8);
+
+	if (seedsize) {
+		void *lrng_hash;
+
+		if (!seed_hash) {
+			switch (seedsize) {
+			case 32:
+				seed_hash = "sha256";
+				break;
+			case 48:
+				seed_hash = "sha384";
+				break;
+			case 64:
+				seed_hash = "sha512";
+				break;
+			default:
+				pr_err("Seed size %d cannot be processed\n",
+				       seedsize);
+				goto dealloc;
+			}
+		}
+
+		lrng_hash = lrng_kcapi_hash_alloc(seed_hash);
+		if (IS_ERR(lrng_hash)) {
+			ret = ERR_CAST(lrng_hash);
+			goto dealloc;
+		}
+
+		if (seedsize != lrng_kcapi_hash_digestsize(lrng_hash)) {
+			pr_err("Seed hash output size not equal to DRNG seed size\n");
+			lrng_kcapi_hash_dealloc(lrng_hash);
+			ret = ERR_PTR(-EINVAL);
+			goto dealloc;
+		}
+
+		lrng_drng_info->lrng_hash = lrng_hash;
+
+		pr_info("Seed hash %s allocated\n", seed_hash);
+	} else {
+		lrng_drng_info->lrng_hash = NULL;
+	}
+
+	pr_info("Kernel crypto API DRNG %s allocated\n", drng_name);
+
+	return lrng_drng_info;
+
+dealloc:
+	crypto_free_rng(kcapi_rng);
+free:
+	kfree(lrng_drng_info);
+	return ret;
+}
+
+static void lrng_kcapi_drng_dealloc(void *drng)
+{
+	struct lrng_drng_info *lrng_drng_info = (struct lrng_drng_info *)drng;
+	struct crypto_rng *kcapi_rng = lrng_drng_info->kcapi_rng;
+
+	crypto_free_rng(kcapi_rng);
+	if (lrng_drng_info->lrng_hash)
+		lrng_kcapi_hash_dealloc(lrng_drng_info->lrng_hash);
+	kfree(lrng_drng_info);
+	pr_info("DRNG %s deallocated\n", drng_name);
+}
+
+static const char *lrng_kcapi_drng_name(void)
+{
+	return drng_name;
+}
+
+static const char *lrng_kcapi_pool_hash(void)
+{
+	return pool_hash;
+}
+
+static const struct lrng_crypto_cb lrng_kcapi_crypto_cb = {
+	.lrng_drng_name			= lrng_kcapi_drng_name,
+	.lrng_hash_name			= lrng_kcapi_pool_hash,
+	.lrng_drng_alloc		= lrng_kcapi_drng_alloc,
+	.lrng_drng_dealloc		= lrng_kcapi_drng_dealloc,
+	.lrng_drng_seed_helper		= lrng_kcapi_drng_seed_helper,
+	.lrng_drng_generate_helper	= lrng_kcapi_drng_generate_helper,
+	.lrng_hash_alloc		= lrng_kcapi_drng_hash_alloc,
+	.lrng_hash_dealloc		= lrng_kcapi_hash_dealloc,
+	.lrng_hash_digestsize		= lrng_kcapi_hash_digestsize,
+	.lrng_hash_init			= lrng_kcapi_hash_init,
+	.lrng_hash_update		= lrng_kcapi_hash_update,
+	.lrng_hash_final		= lrng_kcapi_hash_final,
+	.lrng_hash_desc_zero		= lrng_kcapi_hash_zero,
+};
+
+static int __init lrng_kcapi_init(void)
+{
+	return lrng_set_drng_cb(&lrng_kcapi_crypto_cb);
+}
+static void __exit lrng_kcapi_exit(void)
+{
+	lrng_set_drng_cb(NULL);
+}
+
+late_initcall(lrng_kcapi_init);
+module_exit(lrng_kcapi_exit);
+MODULE_LICENSE("Dual BSD/GPL");
+MODULE_AUTHOR("Stephan Mueller <smueller@chronox.de>");
+MODULE_DESCRIPTION("Linux Random Number Generator - kernel crypto API DRNG backend");
-- 
2.31.1




