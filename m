Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46F5DC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 09:44:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25B90610A6
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Sep 2021 09:44:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245708AbhIQJpj (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Sep 2021 05:45:39 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.84]:35200 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245597AbhIQJpi (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Sep 2021 05:45:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1631871130;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=2YWf6vGGbLdXyqrkbiAYZCnH/VB40o1Irx9UnNa34Ww=;
    b=QYc2zPeTUQunqN/q3sNlNeIyTao0s2z/81EPG61edMPlNXFMk+lWimf3GpA1ZdhA0T
    kvKqwnUZlvz/xhJzNvwidYavz6Kkwxb5wmuJV1TRKWu0nhmiItVLDm86av8xBsQ18nS5
    xhqgzacsTdcxxy9w/uOEJaKp0u+BgYp9aZ+KkhEeLPm3nf1b7DZrzxZthW6k6M1cMVn9
    jE9yF6TrFim5SwA36hsYGDIt8czdWMonXDBEa+LEn51/l6+WLo+gE426kTCJLrlVIP4g
    PRPDb6WGvZ1fRcwjJilAXEJPmttTh92wo2E6CdirQzJ3nqhMvYbpARukYNBy9ttg//7R
    xbeQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvSOeicf6o="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.33.3 DYNA|AUTH)
    with ESMTPSA id f080d4x8H9W7cpL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 17 Sep 2021 11:32:07 +0200 (CEST)
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
Subject: [PATCH v42 13/13] LRNG - add power-on and runtime self-tests
Date:   Thu, 16 Sep 2021 12:16:50 +0200
Message-ID: <1830699.7yZFGbs1K6@positron.chronox.de>
In-Reply-To: <2294055.9jK4hKOXjS@positron.chronox.de>
References: <2294055.9jK4hKOXjS@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Parts of the LRNG are already covered by self-tests, including:

* Self-test of SP800-90A DRBG provided by the Linux kernel crypto API.

* Self-test of the PRNG provided by the Linux kernel crypto API.

* Raw noise source data testing including SP800-90B compliant
  tests when enabling CONFIG_LRNG_HEALTH_TESTS

This patch adds the self-tests for the remaining critical functions of
the LRNG that are essential to maintain entropy and provide
cryptographic strong random numbers. The following self-tests are
implemented:

* Self-test of the time array maintenance. This test verifies whether
the time stamp array management to store multiple values in one integer
implements a concatenation of the data.

* Self-test of the software hash implementation ensures that this
function operates compliant to the FIPS 180-4 specification. The
self-test performs a hash operation of a zeroized per-CPU data array.

* Self-test of the ChaCha20 DRNG is based on the self-tests that are
already present and implemented with the stand-alone user space
ChaCha20 DRNG implementation available at [1]. The self-tests cover
different use cases of the DRNG seeded with known seed data.

The status of the LRNG self-tests is provided with the selftest_status
SysFS file. If the file contains a zero, the self-tests passed. The
value 0xffffffff means that the self-tests were not executed. Any other
value indicates a self-test failure.

The self-test may be compiled to panic the system if the self-test
fails.

All self-tests operate on private state data structures. This implies
that none of the self-tests have any impact on the regular LRNG
operations. This allows the self-tests to be repeated at runtime by
writing anything into the selftest_status SysFS file.

[1] https://www.chronox.de/chacha20.html

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
CC: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
CC: Neil Horman <nhorman@redhat.com>
Reviewed-by: Alexander Lobakin <alobakin@pm.me>
Tested-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 drivers/char/lrng/Kconfig         |  43 +++-
 drivers/char/lrng/Makefile        |   1 +
 drivers/char/lrng/lrng_selftest.c | 369 ++++++++++++++++++++++++++++++
 3 files changed, 405 insertions(+), 8 deletions(-)
 create mode 100644 drivers/char/lrng/lrng_selftest.c

diff --git a/drivers/char/lrng/Kconfig b/drivers/char/lrng/Kconfig
index 32692aff9774..de50abaf53cb 100644
--- a/drivers/char/lrng/Kconfig
+++ b/drivers/char/lrng/Kconfig
@@ -165,15 +165,16 @@ config LRNG_COLLECTION_SIZE
 	default 8192 if LRNG_COLLECTION_SIZE_8192
 
 config LRNG_HEALTH_TESTS
-	bool "Enable noise source online health tests"
+	bool "Enable interrupt entropy source online health tests"
 	help
-	  The online health tests validate the noise source at
-	  runtime for fatal errors. These tests include SP800-90B
-	  compliant tests which are invoked if the system is booted
-	  with fips=1. In case of fatal errors during active
-	  SP800-90B tests, the issue is logged and the noise
-	  data is discarded. These tests are required for full
-	  compliance with SP800-90B.
+	  The online health tests applied to the interrupt entropy
+	  source validate the noise source at runtime for fatal
+	  errors. These tests include SP800-90B compliant tests
+	  which are invoked if the system is booted with fips=1.
+	  In case of fatal errors during active SP800-90B tests,
+	  the issue is logged and the noise data is discarded.
+	  These tests are required for full compliance of the
+	  interrupt entropy source with SP800-90B.
 
 	  If unsure, say Y.
 
@@ -493,4 +494,30 @@ config LRNG_TESTING
 
 endif #LRNG_TESTING_MENU
 
+config LRNG_SELFTEST
+	bool "Enable power-on and on-demand self-tests"
+	help
+	  The power-on self-tests are executed during boot time
+	  covering the ChaCha20 DRNG, the hash operation used for
+	  processing the entropy pools and the auxiliary pool, and
+	  the time stamp management of the LRNG.
+
+	  The on-demand self-tests are triggered by writing any
+	  value into the SysFS file selftest_status. At the same
+	  time, when reading this file, the test status is
+	  returned. A zero indicates that all tests were executed
+	  successfully.
+
+	  If unsure, say Y.
+
+if LRNG_SELFTEST
+
+config LRNG_SELFTEST_PANIC
+	bool "Panic the kernel upon self-test failure"
+	help
+	  If the option is enabled, the kernel is terminated if an
+	  LRNG power-on self-test failure is detected.
+
+endif # LRNG_SELFTEST
+
 endif # LRNG
diff --git a/drivers/char/lrng/Makefile b/drivers/char/lrng/Makefile
index 919c85cd103a..623813764aca 100644
--- a/drivers/char/lrng/Makefile
+++ b/drivers/char/lrng/Makefile
@@ -17,3 +17,4 @@ obj-$(CONFIG_LRNG_KCAPI)	+= lrng_kcapi.o
 obj-$(CONFIG_LRNG_JENT)		+= lrng_es_jent.o
 obj-$(CONFIG_LRNG_HEALTH_TESTS)	+= lrng_health.o
 obj-$(CONFIG_LRNG_TESTING)	+= lrng_testing.o
+obj-$(CONFIG_LRNG_SELFTEST)	+= lrng_selftest.o
diff --git a/drivers/char/lrng/lrng_selftest.c b/drivers/char/lrng/lrng_selftest.c
new file mode 100644
index 000000000000..e219f7ea832b
--- /dev/null
+++ b/drivers/char/lrng/lrng_selftest.c
@@ -0,0 +1,369 @@
+// SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
+/*
+ * LRNG power-on and on-demand self-test
+ *
+ * Copyright (C) 2016 - 2021, Stephan Mueller <smueller@chronox.de>
+ */
+
+/*
+ * In addition to the self-tests below, the following LRNG components
+ * are covered with self-tests during regular operation:
+ *
+ * * power-on self-test: SP800-90A DRBG provided by the Linux kernel crypto API
+ * * power-on self-test: PRNG provided by the Linux kernel crypto API
+ * * runtime test: Raw noise source data testing including SP800-90B compliant
+ *		   tests when enabling CONFIG_LRNG_HEALTH_TESTS
+ *
+ * Additional developer tests present with LRNG code:
+ * * SP800-90B APT and RCT test enforcement validation when enabling
+ *   CONFIG_LRNG_APT_BROKEN or CONFIG_LRNG_RCT_BROKEN.
+ * * Collection of raw entropy from the interrupt noise source when enabling
+ *   CONFIG_LRNG_TESTING and pulling the data from the kernel with the provided
+ *   interface.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/lrng.h>
+#include <linux/slab.h>
+
+#include "lrng_chacha20.h"
+#include "lrng_internal.h"
+#include "lrng_es_irq.h"
+
+#define LRNG_SELFTEST_PASSED		0
+#define LRNG_SEFLTEST_ERROR_TIME	(1 << 0)
+#define LRNG_SEFLTEST_ERROR_CHACHA20	(1 << 1)
+#define LRNG_SEFLTEST_ERROR_HASH	(1 << 2)
+#define LRNG_SEFLTEST_ERROR_GCD		(1 << 3)
+#define LRNG_SELFTEST_NOT_EXECUTED	0xffffffff
+
+static u32 lrng_data_selftest_ptr = 0;
+static u32 lrng_data_selftest[LRNG_DATA_ARRAY_SIZE];
+
+static unsigned int lrng_selftest_status = LRNG_SELFTEST_NOT_EXECUTED;
+
+static inline void lrng_selftest_bswap32(u32 *ptr, u32 words)
+{
+	u32 i;
+
+	/* Byte-swap data which is an LE representation */
+	for (i = 0; i < words; i++) {
+		__le32 *p = (__le32 *)ptr;
+
+		*p = cpu_to_le32(*ptr);
+		ptr++;
+	}
+}
+
+static inline void lrng_data_process_selftest_insert(u32 time)
+{
+	u32 ptr = lrng_data_selftest_ptr++ & LRNG_DATA_WORD_MASK;
+	unsigned int array = lrng_data_idx2array(ptr);
+	unsigned int slot = lrng_data_idx2slot(ptr);
+
+	/* zeroization of slot to ensure the following OR adds the data */
+	lrng_data_selftest[array] &=
+		~(lrng_data_slot_val(0xffffffff & LRNG_DATA_SLOTSIZE_MASK,
+				     slot));
+	lrng_data_selftest[array] |=
+		lrng_data_slot_val(time & LRNG_DATA_SLOTSIZE_MASK, slot);
+}
+
+static inline void lrng_data_process_selftest_u32(u32 data)
+{
+	u32 pre_ptr, ptr, mask;
+	unsigned int pre_array;
+
+	/* Increment pointer by number of slots taken for input value */
+	lrng_data_selftest_ptr += LRNG_DATA_SLOTS_PER_UINT;
+
+	/* ptr to current unit */
+	ptr = lrng_data_selftest_ptr;
+
+	lrng_pcpu_split_u32(&ptr, &pre_ptr, &mask);
+
+	/* MSB of data go into previous unit */
+	pre_array = lrng_data_idx2array(pre_ptr);
+	/* zeroization of slot to ensure the following OR adds the data */
+	lrng_data_selftest[pre_array] &= ~(0xffffffff &~ mask);
+	lrng_data_selftest[pre_array] |= data & ~mask;
+
+	/* LSB of data go into current unit */
+	lrng_data_selftest[lrng_data_idx2array(ptr)] = data & mask;
+}
+
+static unsigned int lrng_data_process_selftest(void)
+{
+	u32 time;
+	u32 idx_zero_compare = (0 << 0) | (1 << 8) | (2 << 16) | (3 << 24);
+	u32 idx_one_compare  = (4 << 0) | (5 << 8) | (6 << 16) | (7 << 24);
+	u32 idx_last_compare =
+		(((LRNG_DATA_NUM_VALUES - 4) & LRNG_DATA_SLOTSIZE_MASK) << 0)  |
+		(((LRNG_DATA_NUM_VALUES - 3) & LRNG_DATA_SLOTSIZE_MASK) << 8)  |
+		(((LRNG_DATA_NUM_VALUES - 2) & LRNG_DATA_SLOTSIZE_MASK) << 16) |
+		(((LRNG_DATA_NUM_VALUES - 1) & LRNG_DATA_SLOTSIZE_MASK) << 24);
+
+	(void)idx_one_compare;
+
+	/* "poison" the array to verify the operation of the zeroization */
+	lrng_data_selftest[0] = 0xffffffff;
+	lrng_data_selftest[1] = 0xffffffff;
+
+	lrng_data_process_selftest_insert(0);
+	/*
+	 * Note, when using lrng_data_process_u32() on unaligned ptr,
+	 * the first slots will go into next word, and the last slots go
+	 * into the previous word.
+	 */
+	lrng_data_process_selftest_u32((4 << 0) | (1 << 8) | (2 << 16) |
+				       (3 << 24));
+	lrng_data_process_selftest_insert(5);
+	lrng_data_process_selftest_insert(6);
+	lrng_data_process_selftest_insert(7);
+
+	if ((lrng_data_selftest[0] != idx_zero_compare) ||
+	    (lrng_data_selftest[1] != idx_one_compare))
+		goto err;
+
+	/* Reset for next test */
+	lrng_data_selftest[0] = 0;
+	lrng_data_selftest[1] = 0;
+	lrng_data_selftest_ptr = 0;
+
+	for (time = 0; time < LRNG_DATA_NUM_VALUES; time++)
+		lrng_data_process_selftest_insert(time);
+
+	if ((lrng_data_selftest[0] != idx_zero_compare) ||
+	    (lrng_data_selftest[1] != idx_one_compare)  ||
+	    (lrng_data_selftest[LRNG_DATA_ARRAY_SIZE - 1] != idx_last_compare))
+		goto err;
+
+	return LRNG_SELFTEST_PASSED;
+
+err:
+	pr_err("LRNG data array self-test FAILED\n");
+	return LRNG_SEFLTEST_ERROR_TIME;
+}
+
+/* The test vectors are taken from crypto/testmgr.h */
+static unsigned int lrng_hash_selftest(void)
+{
+	SHASH_DESC_ON_STACK(shash, NULL);
+	const struct lrng_crypto_cb *crypto_cb = &lrng_cc20_crypto_cb;
+	static const u8 lrng_hash_selftest_result[] =
+#ifdef CONFIG_CRYPTO_LIB_SHA256
+		{ 0xba, 0x78, 0x16, 0xbf, 0x8f, 0x01, 0xcf, 0xea,
+		  0x41, 0x41, 0x40, 0xde, 0x5d, 0xae, 0x22, 0x23,
+		  0xb0, 0x03, 0x61, 0xa3, 0x96, 0x17, 0x7a, 0x9c,
+		  0xb4, 0x10, 0xff, 0x61, 0xf2, 0x00, 0x15, 0xad };
+#else /* CONFIG_CRYPTO_LIB_SHA256 */
+		{ 0xa9, 0x99, 0x3e, 0x36, 0x47, 0x06, 0x81, 0x6a, 0xba, 0x3e,
+		  0x25, 0x71, 0x78, 0x50, 0xc2, 0x6c, 0x9c, 0xd0, 0xd8, 0x9d };
+#endif /* CONFIG_CRYPTO_LIB_SHA256 */
+	static const u8 hash_input[] = { 0x61, 0x62, 0x63 }; /* "abc" */
+	u8 digest[sizeof(lrng_hash_selftest_result)] __aligned(sizeof(u32));
+
+	BUG_ON(sizeof(digest) != crypto_cb->lrng_hash_digestsize(NULL));
+
+	if (!crypto_cb->lrng_hash_init(shash, NULL) &&
+	    !crypto_cb->lrng_hash_update(shash, hash_input,
+					 sizeof(hash_input)) &&
+	    !crypto_cb->lrng_hash_final(shash, digest) &&
+	    !memcmp(digest, lrng_hash_selftest_result, sizeof(digest)))
+		return 0;
+
+	pr_err("LRNG %s Hash self-test FAILED\n", crypto_cb->lrng_hash_name());
+	return LRNG_SEFLTEST_ERROR_HASH;
+}
+
+/*
+ * The test vectors were generated using the ChaCha20 DRNG from
+ * https://www.chronox.de/chacha20.html
+ */
+static unsigned int lrng_chacha20_drng_selftest(void)
+{
+	const struct lrng_crypto_cb *crypto_cb = &lrng_cc20_crypto_cb;
+	u8 seed[CHACHA_KEY_SIZE * 2] = {
+		0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+		0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
+		0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
+		0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
+		0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
+		0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f,
+		0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
+		0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f,
+	};
+	struct chacha20_block chacha20;
+	int ret;
+	u8 outbuf[CHACHA_KEY_SIZE * 2] __aligned(sizeof(u32));
+
+	/*
+	 * Expected result when ChaCha20 DRNG state is zero:
+	 *	* constants are set to "expand 32-byte k"
+	 *	* remaining state is 0
+	 * and pulling one half ChaCha20 DRNG block.
+	 */
+	static const u8 expected_halfblock[CHACHA_KEY_SIZE] = {
+		0x76, 0xb8, 0xe0, 0xad, 0xa0, 0xf1, 0x3d, 0x90,
+		0x40, 0x5d, 0x6a, 0xe5, 0x53, 0x86, 0xbd, 0x28,
+		0xbd, 0xd2, 0x19, 0xb8, 0xa0, 0x8d, 0xed, 0x1a,
+		0xa8, 0x36, 0xef, 0xcc, 0x8b, 0x77, 0x0d, 0xc7 };
+
+	/*
+	 * Expected result when ChaCha20 DRNG state is zero:
+	 *	* constants are set to "expand 32-byte k"
+	 *	* remaining state is 0
+	 * followed by a reseed with two keyblocks
+	 *	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+	 *	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
+	 *	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
+	 *	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
+	 *	0x20, 0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27,
+	 *	0x28, 0x29, 0x2a, 0x2b, 0x2c, 0x2d, 0x2e, 0x2f,
+	 *	0x30, 0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37,
+	 *	0x38, 0x39, 0x3a, 0x3b, 0x3c, 0x3d, 0x3e, 0x3f
+	 * and pulling one ChaCha20 DRNG block.
+	 */
+	static const u8 expected_oneblock[CHACHA_KEY_SIZE * 2] = {
+		0xe3, 0xb0, 0x8a, 0xcc, 0x34, 0xc3, 0x17, 0x0e,
+		0xc3, 0xd8, 0xc3, 0x40, 0xe7, 0x73, 0xe9, 0x0d,
+		0xd1, 0x62, 0xa3, 0x5d, 0x7d, 0xf2, 0xf1, 0x4a,
+		0x24, 0x42, 0xb7, 0x1e, 0xb0, 0x05, 0x17, 0x07,
+		0xb9, 0x35, 0x10, 0x69, 0x8b, 0x46, 0xfb, 0x51,
+		0xe9, 0x91, 0x3f, 0x46, 0xf2, 0x4d, 0xea, 0xd0,
+		0x81, 0xc1, 0x1b, 0xa9, 0x5d, 0x52, 0x91, 0x5f,
+		0xcd, 0xdc, 0xc6, 0xd6, 0xc3, 0x7c, 0x50, 0x23 };
+
+	/*
+	 * Expected result when ChaCha20 DRNG state is zero:
+	 *	* constants are set to "expand 32-byte k"
+	 *	* remaining state is 0
+	 * followed by a reseed with one key block plus one byte
+	 *	0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
+	 *	0x08, 0x09, 0x0a, 0x0b, 0x0c, 0x0d, 0x0e, 0x0f,
+	 *	0x10, 0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
+	 *	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d, 0x1e, 0x1f,
+	 *	0x20
+	 * and pulling less than one ChaCha20 DRNG block.
+	 */
+	static const u8 expected_block_nonalinged[CHACHA_KEY_SIZE + 4] = {
+		0x9c, 0xfc, 0x5e, 0x31, 0x21, 0x62, 0x11, 0x85,
+		0xd3, 0x77, 0xd3, 0x69, 0x0f, 0xa8, 0x16, 0x55,
+		0xb4, 0x4c, 0xf6, 0x52, 0xf3, 0xa8, 0x37, 0x99,
+		0x38, 0x76, 0xa0, 0x66, 0xec, 0xbb, 0xce, 0xa9,
+		0x9c, 0x95, 0xa1, 0xfd };
+
+	BUILD_BUG_ON(sizeof(seed) % sizeof(u32));
+
+	memset(&chacha20, 0, sizeof(chacha20));
+	lrng_cc20_init_rfc7539(&chacha20);
+	lrng_selftest_bswap32((u32 *)seed, sizeof(seed) / sizeof(u32));
+
+	/* Generate with zero state */
+	ret = crypto_cb->lrng_drng_generate_helper(&chacha20, outbuf,
+						   sizeof(expected_halfblock));
+	if (ret != sizeof(expected_halfblock))
+		goto err;
+	if (memcmp(outbuf, expected_halfblock, sizeof(expected_halfblock)))
+		goto err;
+
+	/* Clear state of DRNG */
+	memset(&chacha20.key.u[0], 0, 48);
+
+	/* Reseed with 2 key blocks */
+	ret = crypto_cb->lrng_drng_seed_helper(&chacha20, seed,
+					       sizeof(expected_oneblock));
+	if (ret < 0)
+		goto err;
+	ret = crypto_cb->lrng_drng_generate_helper(&chacha20, outbuf,
+						   sizeof(expected_oneblock));
+	if (ret != sizeof(expected_oneblock))
+		goto err;
+	if (memcmp(outbuf, expected_oneblock, sizeof(expected_oneblock)))
+		goto err;
+
+	/* Clear state of DRNG */
+	memset(&chacha20.key.u[0], 0, 48);
+
+	/* Reseed with 1 key block and one byte */
+	ret = crypto_cb->lrng_drng_seed_helper(&chacha20, seed,
+					sizeof(expected_block_nonalinged));
+	if (ret < 0)
+		goto err;
+	ret = crypto_cb->lrng_drng_generate_helper(&chacha20, outbuf,
+					sizeof(expected_block_nonalinged));
+	if (ret != sizeof(expected_block_nonalinged))
+		goto err;
+	if (memcmp(outbuf, expected_block_nonalinged,
+		   sizeof(expected_block_nonalinged)))
+		goto err;
+
+	return LRNG_SELFTEST_PASSED;
+
+err:
+	pr_err("LRNG ChaCha20 DRNG self-test FAILED\n");
+	return LRNG_SEFLTEST_ERROR_CHACHA20;
+}
+
+static unsigned int lrng_gcd_selftest(void)
+{
+	u32 history[10];
+	unsigned int i;
+
+#define LRNG_GCD_SELFTEST 3
+	for (i = 0; i < ARRAY_SIZE(history); i++)
+		history[i] = i * LRNG_GCD_SELFTEST;
+
+	if (lrng_gcd_analyze(history, ARRAY_SIZE(history)) == LRNG_GCD_SELFTEST)
+		return LRNG_SELFTEST_PASSED;
+
+	pr_err("LRNG GCD self-test FAILED\n");
+	return LRNG_SEFLTEST_ERROR_GCD;
+}
+
+static int lrng_selftest(void)
+{
+	unsigned int ret = lrng_data_process_selftest();
+
+	ret |= lrng_chacha20_drng_selftest();
+	ret |= lrng_hash_selftest();
+	ret |= lrng_gcd_selftest();
+
+	if (ret) {
+		if (IS_ENABLED(CONFIG_LRNG_SELFTEST_PANIC))
+			panic("LRNG self-tests failed: %u\n", ret);
+	} else {
+		pr_info("LRNG self-tests passed\n");
+	}
+
+	lrng_selftest_status = ret;
+
+	if (lrng_selftest_status)
+		return -EFAULT;
+	return 0;
+}
+
+#ifdef CONFIG_SYSFS
+/* Re-perform self-test when any value is written to the sysfs file. */
+static int lrng_selftest_sysfs_set(const char *val,
+				   const struct kernel_param *kp)
+{
+	return lrng_selftest();
+}
+
+static const struct kernel_param_ops lrng_selftest_sysfs = {
+	.set = lrng_selftest_sysfs_set,
+	.get = param_get_uint,
+};
+module_param_cb(selftest_status, &lrng_selftest_sysfs, &lrng_selftest_status,
+		0644);
+#endif	/* CONFIG_SYSFS */
+
+static int __init lrng_selftest_init(void)
+{
+	return lrng_selftest();
+}
+
+module_init(lrng_selftest_init);
-- 
2.31.1




