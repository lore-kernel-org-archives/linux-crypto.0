Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAB5C4708B
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 16:13:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D821D613C5
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 16:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237186AbhE0QOc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 12:14:32 -0400
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.100]:36645 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237051AbhE0QOR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 12:14:17 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1622131884; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Fxm1ro7LMBBHHB6c7jPMfiRC/GT3Tq/I+ttLP6BgdY+Q7s/I6WtLbq71Tzw7uJAfjs
    Ehrvv3GgXWkKLR3aLoRuwbM1UbN3roYRORfd6nfuaByhqnhlqWRnMez6lzbFS4kBLwa8
    qR0xjCS0zBx9IKlDvaopYda/R3nX76A43NxY39hoftqTAeE5iZkXNsMQxjtUj6/cHqAP
    xMlNM+wCUOmIVMLDQVDhVg+av2Y3+X+AFLvO/nu9lm3xd/mZBUPnZpPU72TJRKA+tvyR
    WhisvBtwTodekxQTTr22p5nszrA9UfaaeNaQUN9PTFciEce4kcTdtRNMgOMzLMVZ00MS
    wiZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1622131884;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=2TV0uTZbW1JQUIpPa1mP0SIEuzE2CNSB6yn4DmpuhR8=;
    b=TyiTbBH+Axh9m7vLJ6ex97esy8RmPw/Ykgr+/taOxk1Xb04h5OTeZ6DWY5AuZ32bYQ
    qaviQ2W1I3RY0BDB7fZ/cnL9A9SA4Nnm3QU3DcW9STPUr+PpeNn1FHE23Qj5kb/5tFuy
    4GdLQ1e5g7va1SomhWNIoPLtY9YiauOlqoozyfhUOExlU+R74wfZa5LkFRsRBuzf5sbY
    8gBNV1Tb3fcMh8nlaO1kYaOsBWbcBCIVIqJMQ6OAuIJoKSO9ZdDGTdd8cLUHTnItNQ3C
    FsaOFOdVGgePjC7uD41VSmUeF9Bz3NL8HIatSunElbbtl1OjSwD0kcEEz0P+tH70vGev
    XKFw==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1622131884;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=2TV0uTZbW1JQUIpPa1mP0SIEuzE2CNSB6yn4DmpuhR8=;
    b=FBE+hDaUVykec8PG0VXfI7hi2dNvE/WqOR1EOObSd9Kemv506FvPUmlZEk8TpTEofT
    Sal4L4GmhLhm2IEg62eXshl0M2jqG1lJXEXeQZPd/W5j+OkQyidgu1tKBFS2x2cMTcAx
    o3TbqBwziWHxN9t8ScJ7/EGTRCe02pfgrOnpa9D2b7SS8rGlxL0iJv05RIjvnxlXZjRF
    gNpFUViwFVyHZuYB2a51B4WEEgjcqUgekaIOo+PzTmbXxe7Uad0OAfB5wyCHE43WsX+e
    Z2hS2/U65QFVhH76OQlwylfS7u/2qBH/NySNgUtIQc6Zso0yySSM2Yq7YaeI8sKPYAEg
    QClg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJvSfFeK2"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.26.3 DYNA|AUTH)
    with ESMTPSA id R0123ax4RGBN0Tk
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 27 May 2021 18:11:23 +0200 (CEST)
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
Subject: [PATCH v40 10/13] LRNG - add Jitter RNG fast noise source
Date:   Thu, 27 May 2021 18:02:48 +0200
Message-ID: <1905320.hsLGNjb90J@positron.chronox.de>
In-Reply-To: <18450229.rjpLZT9oXI@positron.chronox.de>
References: <18450229.rjpLZT9oXI@positron.chronox.de>
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
Reviewed-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Tested-by: Neil Horman <nhorman@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/lrng/Kconfig     | 12 +++++
 drivers/char/lrng/Makefile    |  1 +
 drivers/char/lrng/lrng_jent.c | 91 +++++++++++++++++++++++++++++++++++
 3 files changed, 104 insertions(+)
 create mode 100644 drivers/char/lrng/lrng_jent.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index e66e8cd1d86f..7e302b204f7c 100644
--- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -196,4 +196,16 @@ config LRNG_KCAPI
 	  provided by the selected kernel crypto API RNG.
 endif # LRNG_DRNG_SWITCH
 
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
 endif # LRNG
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
index 000000000000..ba1dd2ae89d2
--- /dev/null
+++ b/drivers/char/lrng/lrng_jent.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG Fast Noise Source: Jitter RNG
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
+static u32 jitterrng = LRNG_DRNG_SECURITY_STRENGTH_BITS>>4;
+module_param(jitterrng, uint, 0644);
+MODULE_PARM_DESC(jitterrng, "Entropy in bits of 256 data bits from Jitter RNG noise source");
+
+static bool lrng_jent_initialized = false;
+static struct rand_data *lrng_jent_state;
+
+static int __init lrng_jent_initialize(void)
+{
+	u32 ent_bits = lrng_fast_noise_entropylevel(jitterrng,
+					LRNG_DRNG_SECURITY_STRENGTH_BITS);
+
+	/* Initialize the Jitter RNG after the clocksources are initialized. */
+	lrng_jent_state = jent_lrng_entropy_collector();
+	if (!lrng_jent_state) {
+		jitterrng = 0;
+		pr_info("Jitter RNG unusable on current system\n");
+		return 0;
+	}
+	lrng_jent_initialized = true;
+	lrng_update_entropy_thresh(ent_bits);
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




