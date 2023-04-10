Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2D6C77B6F
	for <linux-crypto@archiver.kernel.org>; Mon, 10 Apr 2023 21:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbjDJVQt (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 10 Apr 2023 17:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbjDJVQr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 10 Apr 2023 17:16:47 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582281BFB
        for <linux-crypto@vger.kernel.org>; Mon, 10 Apr 2023 14:16:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681161394; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=T26QhyTz9h6+bXsiIUflyN0w3VI6oHGre63KVnZdQ1y5UmsNuk27LZDA7kKOneqC7O
    Q0KpgyZYP5Z14FXRwTzZUBU6AMK+Pz7bJFXy+0Kv7z59dtMo9pR0/y5fRAunDL0zqQln
    GOmdHFfVF7RzajejBe/MzYRHDbHtzomx8OlJEIHpALqlZ9rNFIhCWFIcE8QMCol1FQgu
    0Kh6EDP63OgZ3esTB92QmFby8OTZZLPwYVkyzDtPbjzLUyzrCVUAeKzXPZ+GntfykUez
    o39U/mpUNcw5079JQGIqYJSHSY3duI+UIU2r+ONxHI2jH5wVQdIil+aTwuoNKorp2fxL
    kQig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1681161394;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=OXKmJ3YW8D04Z1DEMgAeJrS7VIv1iG8aoPphmKpNPXA=;
    b=dJE2TfP5ePZA3J0oib4TBg17q+qEbzK1lKOGf1kpd2H9mD5z160DHklYD2xPWVup+c
    uuVxt0TTAhTxEBMhsvOydJx6AgOtkGfdzrojFCmSre/WF+nT07ML5882hSytrDXGsTCE
    n+8f+3xafOJRfcuyLBeY2MZpAfO83DwmOOT8irm/0yfLpiOnY6KrjGjEGmVGbXqYw9ss
    03p3YDRGVx9UQtwtBSnjKXyqQaiWd+5lcjD2zTEIoH+YZzahf9Rvju5NOdmgsujFzfPd
    2FCM9hrZUM9aCsaKK830VfMNiWnN6yxEQL8RBarbgjpAIHmEmSb9ggDrVq5Mat3k3PcH
    sPeg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1681161394;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=OXKmJ3YW8D04Z1DEMgAeJrS7VIv1iG8aoPphmKpNPXA=;
    b=J5iFKW4uG0ZcRMreMu0k2bq02CfcACMjO0klkrRO0eMDOzTMBAXJzd/p05QAP+2nUo
    huVOHt/NK2kvxOO1gQC3STNa7FWaSmOhksgDK+Cp0hRfsBcOOq5dKUm4Wud19uAFeO3j
    46agy4Qm0pHW0vx7g1TGwAtJtA8e6qzvW9RFS+/tL/Ha2Xido49Wu58zBXC+4jEhvXvU
    1vMevCuP8J6Tx/ab0j7pfPEHRAKnw119qKerQv/IGyUqCe84xqhTWplFiPbNLQGuSkph
    7/d5NDf/EHPBrSyd26rWkiISy58JF7cLXNKoz7sJrWcDvvY72CtnPIOUXqe/my+qzz4S
    ofBQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1681161394;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=OXKmJ3YW8D04Z1DEMgAeJrS7VIv1iG8aoPphmKpNPXA=;
    b=lgbKE9ZgZa52eTFXpO+vlxmGlC0vZ/NcH/tsUP+hTX1e/gphcCEFydmxfeKn77xVby
    CmoaqFPD1NFxkYAY0sCw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x24dNoX176cDw2h2is1y"
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.4.0 DYNA|AUTH)
    with ESMTPSA id ta02b6z3ALGWLMJ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 10 Apr 2023 23:16:32 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Vladis Dronov <vdronov@redhat.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>
Subject: [PATCH v2 2/2] crypto: jitter - add interface for gathering of raw entropy
Date:   Mon, 10 Apr 2023 22:55:46 +0200
Message-ID: <1853927.tdWV9SEqCh@positron.chronox.de>
In-Reply-To: <4825604.31r3eYUQgx@positron.chronox.de>
References: <2684670.mvXUDI8C0e@positron.chronox.de>
 <4825604.31r3eYUQgx@positron.chronox.de>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 mQENBFqo+vgBCACp9hezmvJ4eeZv4PkyoMxGpXHN4Ox2+aofXxMv/yQ6oyZ69xu0U0yFcEcSWbe
 4qhxB+nlOvSBRJ8ohEU3hlGLrAKJwltHVzeO6nCby/T57b6SITCbcnZGIgKwX4CrJYmfQ4svvMG
 NDOORPk6SFkK7hhe1cWJb+Gc5czw3wy7By5c1OtlnbmGB4k5+p7Mbi+rui/vLTKv7FKY5t2CpQo
 OxptxFc/yq9sMdBnsjvhcCHcl1kpnQPTMppztWMj4Nkkd+Trvpym0WZ1px6+3kxhMn6LNYytHTC
 mf/qyf1+1/PIpyEXvx66hxeN+fN/7R+0iYCisv3JTtfNkCV3QjGdKqT3ABEBAAG0HVN0ZXBoYW4
 gTXVlbGxlciA8c21AZXBlcm0uZGU+iQFOBBMBCAA4FiEEO8xD1NLIfReEtp7kQh7pNjJqwVsFAl
 qo/M8CGwMFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AACgkQQh7pNjJqwVsV8gf+OcAaiSqhn0mYk
 fC7Fe48n9InAkHiSQ/T7eN+wWYLYMWGG0N2z5gBnNfdc4oFVL+ngye4C3bm98Iu7WnSl0CTOe1p
 KGFJg3Y7YzSa5/FzS9nKsg6iXpNWL5nSYyz8T9Q0KGKNlAiyQEGkt8y05m8hNsvqkgDb923/RFf
 UYX4mTUXJ1vk/6SFCA/72JQN7PpwMgGir7FNybuuDUuDLDgQ+BZHhJlW91XE2nwxUo9IrJ2FeT8
 GgFKzX8A//peRZTSSeatJBr0HRKfTrKYw3lf897sddUjyQU1nDYv9EMLBvkzuE+gwUakt2rOcpR
 +4Fn5jkQbN4vpfGPnybMAMMxW6GIrQfU3RlcGhhbiBNdWVsbGVyIDxzbUBjaHJvbm94LmRlPokB
 TgQTAQgAOBYhBDvMQ9TSyH0XhLae5EIe6TYyasFbBQJaqPzEAhsDBQsJCAcCBhUKCQgLAgQWAgM
 BAh4BAheAAAoJEEIe6TYyasFbsqUH/2euuyRj8b1xuapmrNUuU4atn9FN6XE1cGzXYPHNEUGBiM
 kInPwZ/PFurrni7S22cMN+IuqmQzLo40izSjXhRJAa165GoJSrtf7S6iwry/k1S9nY2Vc/dxW6q
 nFq7mJLAs0JWHOfhRe1caMb7P95B+O5B35023zYr9ApdQ4+Lyk+xx1+i++EOxbTJVqLZEF1EGmO
 Wh3ERcGyT05+1LQ84yDSCUxZVZFrbA2Mtg8cdyvu68urvKiOCHzDH/xRRhFxUz0+dCOGBFSgSfK
 I9cgS009BdH3Zyg795QV6wfhNas4PaNPN5ArMAvgPH1BxtkgyMjUSyLQQDrmuqHnLzExEQfG0JV
 N0ZXBoYW4gTXVlbGxlciA8c211ZWxsZXJAY2hyb25veC5kZT6JAU4EEwEIADgWIQQ7zEPU0sh9F
 4S2nuRCHuk2MmrBWwUCWqj6+AIbAwULCQgHAgYVCgkICwIEFgIDAQIeAQIXgAAKCRBCHuk2MmrB
 WxVrB/wKYSuURgwKs2pJ2kmLIp34StoreNqe6cdIF7f7e8o7NaT528hFAVuDSTUyjXO+idbC0P+
 zu9y2SZfQhc4xbD+Zf0QngX7/sqIWVeiXJa6uR/qrtJF7OBEvlGkxcAwkC0d/Ts68ps4QbZ7s5q
 WBJJY4LmnytqvXGb63/fOTwImYiY3tKCOSCM2YQRFt6BO71t8tu/4NLk0KSW9OHa9nfcDqI18aV
 ylGMu5zNjYqjJpT/be1UpyZo6I/7p0yAQfGJ5YBiN4S264mdFN7jOvxZE3NKXhL4QMt34hOSWPO
 pW8ZGEo1hKjEdHFvYowPpcoOFicP+zvxdpMtUTEkppREN2a+uQENBFqo+vgBCACiLHsDAX7C0l0
 sB8DhVvTDpC2CyaeuNW9GZ1Qqkenh3Y5KnYnh5Gg5b0jubSkauJ75YEOsOeClWuebL3i76kARC8
 Gfo727wSLvfIAcWhO1ws6j1Utc8s1HNO0+vcGC9EEkn7LzO5piEUPkentjrSF7clPsXziW4IJq/
 z3DYZQkVPk7PSw6r0jXWR/p6sj4aXxslIiDgFJZyopki7Sl2805JYcvKKC6OWTyPHJMlnu9dNxJ
 viAentAUwzHxNqmvYjlkqBr/sFnjC9kydElecVm4YQh3TC6yt5h49AslAVlFYfwQwcio1LNWySc
 lWHbDZhcVZJZZi4++gpFmmg1AjyfLABEBAAGJATYEGAEIACAWIQQ7zEPU0sh9F4S2nuRCHuk2Mm
 rBWwUCWqj6+AIbIAAKCRBCHuk2MmrBWxPCCACQGQu5eOcH9qsqSOO64n+xUX7PG96S8s2JolN3F
 t2YWKUzjVHLu5jxznmDwx+GJ3P7thrzW+V5XdDcXgSAXW793TaJ/XMM0jEG+jgvuhE65JfWCK+8
 sumrO24M1KnVQigxrMpG5FT7ndpBRGbs059QSqoMVN4x2dvaP81/+u0sQQ2EGrhPFB2aOA3s7bb
 Wy8xGVIPLcCqByPLbxbHzaU/dkiutSaYqmzdgrTdcuESSbK4qEv3g1i2Bw5kdqeY9mM96SUL8cG
 UokqFtVP7b2mSfm51iNqlO3nsfwpRnl/IlRPThWLhM7/qr49GdWYfQsK4hbw0fo09QFCXN53MPL
 hLwuQENBFqo+vgBCAClaPqyK/PUbf7wxTfu3ZBAgaszL98Uf1UHTekRNdYO7FP1dWWT4SebIgL8
 wwtWZEqI1pydyvk6DoNF6CfRFq1lCo9QA4Rms7Qx3cdXu1G47ZtQvOqxvO4SPvi7lg3PgnuiHDU
 STwo5a8+ojxbLzs5xExbx4RDGtykBoaOoLYeenn92AQ//gN6wCDjEjwP2u39xkWXlokZGrwn3yt
 FE20rUTNCSLxdmoCr1faHzKmvql95wmA7ahg5s2vM9/95W4G71lJhy2crkZIAH0fx3iOUbDmlZ3
 T3UvoLuyMToUyaQv5lo0lV2KJOBGhjnAfmykHsxQu0RygiNwvO3TGjpaeB5ABEBAAGJATYEGAEI
 ACAWIQQ7zEPU0sh9F4S2nuRCHuk2MmrBWwUCWqj6+AIbDAAKCRBCHuk2MmrBW5Y4B/oCLcRZyN0
 ETep2JK5CplZHHRN27DhL4KfnahZv872vq3c83hXDDIkCm/0/uDElso+cavceg5pIsoP2bvEeSJ
 jGMJ5PVdCYOx6r/Fv/tkr46muOvaLdgnphv/CIA+IRykwyzXe3bsucHC4a1fnSoTMnV1XhsIh8z
 WTINVVO8+qdNEv3ix2nP5yArexUGzmJV0HIkKm59wCLz4FpWR+QZru0i8kJNuFrdnDIP0wxDjiV
 BifPhiegBv+/z2DOj8D9EI48KagdQP7MY7q/u1n3+pGTwa+F1hoGo5IOU5MnwVv7UHiW1MSNQ2/
 kBFBHm+xdudNab2U0OpfqrWerOw3WcGd2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The test interface allows a privileged process to capture the raw
unconditioned noise that is collected by the Jitter RNG for statistical
analysis. Such testing allows the analysis how much entropy
the Jitter RNG noise source provides on a given platform. The obtained
data is the time stamp sampled by the Jitter RNG. Considering that
the Jitter RNG inserts the delta of this time stamp compared to the
immediately preceding time stamp, the obtained data needs to be
post-processed accordingly to obtain the data the Jitter RNG inserts
into its entropy pool.

The raw entropy collection is provided to obtain the raw unmodified
time stamps that are about to be added to the Jitter RNG entropy pool
and are credited with entropy. Thus, this patch adds an interface
which renders the Jitter RNG insecure. This patch is NOT INTENDED
FOR PRODUCTION SYSTEMS, but solely for development/test systems to
verify the available entropy rate.

Access to the data is given through the jent_raw_hires debugfs file.
The data buffer should be multiples of sizeof(u32) to fill the entire
buffer. Using the option jitterentropy_testing.boot_raw_hires_test=1
the raw noise of the first 1000 entropy events since boot can be
sampled.

This test interface allows generating the data required for
analysis whether the Jitter RNG is in compliance with SP800-90B
sections 3.1.3 and 3.1.4.

If the test interface is not compiled, its code is a noop which has no
impact on the performance.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/Kconfig                 |  20 +++
 crypto/Makefile                |   1 +
 crypto/jitterentropy-kcapi.c   |   9 +-
 crypto/jitterentropy-testing.c | 294 +++++++++++++++++++++++++++++++++
 crypto/jitterentropy.h         |  10 ++
 5 files changed, 333 insertions(+), 1 deletion(-)
 create mode 100644 crypto/jitterentropy-testing.c

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 113dee4b167b..9b39730bfa73 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1288,6 +1288,26 @@ config CRYPTO_JITTERENTROPY
 
 	  See https://www.chronox.de/jent.html
 
+config CRYPTO_JITTERENTROPY_TESTINTERFACE
+	bool "CPU Jitter RNG Test Interface"
+	depends on CRYPTO_JITTERENTROPY
+	help
+	  The test interface allows a privileged process to capture
+	  the raw unconditioned high resolution time stamp noise that
+	  is collected by the Jitter RNG for statistical analysis. As
+	  this data is used at the same time to generate random bits,
+	  the Jitter RNG operates in an insecure mode as long as the
+	  recording is enabled. This interface therefore is only
+	  intended for testing purposes and is not suitable for
+	  production systems.
+
+	  The raw noise data can be obtained using the jent_raw_hires
+	  debugfs file. Using the option
+	  jitterentropy_testing.boot_raw_hires_test=1 the raw noise of
+	  the first 1000 entropy events since boot can be sampled.
+
+	  If unsure, select N.
+
 config CRYPTO_KDF800108_CTR
 	tristate
 	select CRYPTO_HMAC
diff --git a/crypto/Makefile b/crypto/Makefile
index d0126c915834..45dae478af2b 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -171,6 +171,7 @@ CFLAGS_jitterentropy.o = -O0
 KASAN_SANITIZE_jitterentropy.o = n
 UBSAN_SANITIZE_jitterentropy.o = n
 jitterentropy_rng-y := jitterentropy.o jitterentropy-kcapi.o
+obj-$(CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE) += jitterentropy-testing.o
 obj-$(CONFIG_CRYPTO_TEST) += tcrypt.o
 obj-$(CONFIG_CRYPTO_GHASH) += ghash-generic.o
 obj-$(CONFIG_CRYPTO_POLYVAL) += polyval-generic.o
diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index b25dbd7b9be6..a64d7c2a78a4 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -88,6 +88,7 @@ void jent_get_nstime(__u64 *out)
 		tmp = ktime_get_ns();
 
 	*out = tmp;
+	jent_raw_hires_entropy_store(tmp);
 }
 
 int jent_hash_time(void *hash_state, __u64 time, u8 *addtl,
@@ -319,9 +320,13 @@ static int __init jent_mod_init(void)
 	struct crypto_shash *tfm;
 	int ret = 0;
 
+	jent_testing_init();
+
 	tfm = crypto_alloc_shash(JENT_CONDITIONING_HASH, 0, 0);
-	if (IS_ERR(tfm))
+	if (IS_ERR(tfm)) {
+		jent_testing_exit();
 		return PTR_ERR(tfm);
+	}
 
 	desc->tfm = tfm;
 	crypto_shash_init(desc);
@@ -333,6 +338,7 @@ static int __init jent_mod_init(void)
 		if (fips_enabled)
 			panic("jitterentropy: Initialization failed with host not compliant with requirements: %d\n", ret);
 
+		jent_testing_exit();
 		pr_info("jitterentropy: Initialization failed with host not compliant with requirements: %d\n", ret);
 		return -EFAULT;
 	}
@@ -341,6 +347,7 @@ static int __init jent_mod_init(void)
 
 static void __exit jent_mod_exit(void)
 {
+	jent_testing_exit();
 	crypto_unregister_rng(&jent_alg);
 }
 
diff --git a/crypto/jitterentropy-testing.c b/crypto/jitterentropy-testing.c
new file mode 100644
index 000000000000..4313abece3f4
--- /dev/null
+++ b/crypto/jitterentropy-testing.c
@@ -0,0 +1,294 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause */
+/*
+ * Test interface for Jitter RNG.
+ *
+ * Copyright (C) 2023, Stephan Mueller <smueller@chronox.de>
+ */
+
+#include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+
+#include "jitterentropy.h"
+
+#define JENT_TEST_RINGBUFFER_SIZE	(1<<10)
+#define JENT_TEST_RINGBUFFER_MASK	(JENT_TEST_RINGBUFFER_SIZE - 1)
+
+struct jent_testing {
+	u32 jent_testing_rb[JENT_TEST_RINGBUFFER_SIZE];
+	u32 rb_reader;
+	atomic_t rb_writer;
+	atomic_t jent_testing_enabled;
+	spinlock_t lock;
+	wait_queue_head_t read_wait;
+};
+
+static struct dentry *jent_raw_debugfs_root = NULL;
+
+/*************************** Generic Data Handling ****************************/
+
+/*
+ * boot variable:
+ * 0 ==> No boot test, gathering of runtime data allowed
+ * 1 ==> Boot test enabled and ready for collecting data, gathering runtime
+ *	 data is disabled
+ * 2 ==> Boot test completed and disabled, gathering of runtime data is
+ *	 disabled
+ */
+
+static void jent_testing_reset(struct jent_testing *data)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&data->lock, flags);
+	data->rb_reader = 0;
+	atomic_set(&data->rb_writer, 0);
+	spin_unlock_irqrestore(&data->lock, flags);
+}
+
+static void jent_testing_data_init(struct jent_testing *data, u32 boot)
+{
+	/*
+	 * The boot time testing implies we have a running test. If the
+	 * caller wants to clear it, he has to unset the boot_test flag
+	 * at runtime via sysfs to enable regular runtime testing
+	 */
+	if (boot)
+		return;
+
+	jent_testing_reset(data);
+	atomic_set(&data->jent_testing_enabled, 1);
+	pr_warn("Enabling data collection\n");
+}
+
+static void jent_testing_fini(struct jent_testing *data, u32 boot)
+{
+	/* If we have boot data, we do not reset yet to allow data to be read */
+	if (boot)
+		return;
+
+	atomic_set(&data->jent_testing_enabled, 0);
+	jent_testing_reset(data);
+	pr_warn("Disabling data collection\n");
+}
+
+static bool jent_testing_store(struct jent_testing *data, u32 value,
+			       u32 *boot)
+{
+	unsigned long flags;
+
+	if (!atomic_read(&data->jent_testing_enabled) && (*boot != 1))
+		return false;
+
+	spin_lock_irqsave(&data->lock, flags);
+
+	/*
+	 * Disable entropy testing for boot time testing after ring buffer
+	 * is filled.
+	 */
+	if (*boot) {
+		if (((u32)atomic_read(&data->rb_writer)) >
+		     JENT_TEST_RINGBUFFER_SIZE) {
+			*boot = 2;
+			pr_warn_once("One time data collection test disabled\n");
+			spin_unlock_irqrestore(&data->lock, flags);
+			return false;
+		}
+
+		if (atomic_read(&data->rb_writer) == 1)
+			pr_warn("One time data collection test enabled\n");
+	}
+
+	data->jent_testing_rb[((u32)atomic_read(&data->rb_writer)) &
+			      JENT_TEST_RINGBUFFER_MASK] = value;
+	atomic_inc(&data->rb_writer);
+
+	spin_unlock_irqrestore(&data->lock, flags);
+
+	if (wq_has_sleeper(&data->read_wait))
+		wake_up_interruptible(&data->read_wait);
+
+	return true;
+}
+
+static bool jent_testing_have_data(struct jent_testing *data)
+{
+	return ((((u32)atomic_read(&data->rb_writer)) &
+		 JENT_TEST_RINGBUFFER_MASK) !=
+		 (data->rb_reader & JENT_TEST_RINGBUFFER_MASK));
+}
+
+static int jent_testing_reader(struct jent_testing *data, u32 *boot,
+			       u8 *outbuf, u32 outbuflen)
+{
+	unsigned long flags;
+	int collected_data = 0;
+
+	jent_testing_data_init(data, *boot);
+
+	while (outbuflen) {
+		u32 writer = (u32)atomic_read(&data->rb_writer);
+
+		spin_lock_irqsave(&data->lock, flags);
+
+		/* We have no data or reached the writer. */
+		if (!writer || (writer == data->rb_reader)) {
+
+			spin_unlock_irqrestore(&data->lock, flags);
+
+			/*
+			 * Now we gathered all boot data, enable regular data
+			 * collection.
+			 */
+			if (*boot) {
+				*boot = 0;
+				goto out;
+			}
+
+			wait_event_interruptible(data->read_wait,
+						 jent_testing_have_data(data));
+			if (signal_pending(current)) {
+				collected_data = -ERESTARTSYS;
+				goto out;
+			}
+
+			continue;
+		}
+
+		/* We copy out word-wise */
+		if (outbuflen < sizeof(u32)) {
+			spin_unlock_irqrestore(&data->lock, flags);
+			goto out;
+		}
+
+		memcpy(outbuf, &data->jent_testing_rb[data->rb_reader],
+		       sizeof(u32));
+		data->rb_reader++;
+
+		spin_unlock_irqrestore(&data->lock, flags);
+
+		outbuf += sizeof(u32);
+		outbuflen -= sizeof(u32);
+		collected_data += sizeof(u32);
+	}
+
+out:
+	jent_testing_fini(data, *boot);
+	return collected_data;
+}
+
+static int jent_testing_extract_user(struct file *file, char __user *buf,
+				     size_t nbytes, loff_t *ppos,
+				     int (*reader)(u8 *outbuf, u32 outbuflen))
+{
+	u8 *tmp, *tmp_aligned;
+	int ret = 0, large_request = (nbytes > 256);
+
+	if (!nbytes)
+		return 0;
+
+	/*
+	 * The intention of this interface is for collecting at least
+	 * 1000 samples due to the SP800-90B requirements. So, we make no
+	 * effort in avoiding allocating more memory that actually needed
+	 * by the user. Hence, we allocate sufficient memory to always hold
+	 * that amount of data.
+	 */
+	tmp = kmalloc(JENT_TEST_RINGBUFFER_SIZE + sizeof(u32), GFP_KERNEL);
+	if (!tmp)
+		return -ENOMEM;
+
+	tmp_aligned = PTR_ALIGN(tmp, sizeof(u32));
+
+	while (nbytes) {
+		int i;
+
+		if (large_request && need_resched()) {
+			if (signal_pending(current)) {
+				if (ret == 0)
+					ret = -ERESTARTSYS;
+				break;
+			}
+			schedule();
+		}
+
+		i = min_t(int, nbytes, JENT_TEST_RINGBUFFER_SIZE);
+		i = reader(tmp_aligned, i);
+		if (i <= 0) {
+			if (i < 0)
+				ret = i;
+			break;
+		}
+		if (copy_to_user(buf, tmp_aligned, i)) {
+			ret = -EFAULT;
+			break;
+		}
+
+		nbytes -= i;
+		buf += i;
+		ret += i;
+	}
+
+	kfree_sensitive(tmp);
+
+	if (ret > 0)
+		*ppos += ret;
+
+	return ret;
+}
+
+/************** Raw High-Resolution Timer Entropy Data Handling **************/
+
+static u32 boot_raw_hires_test = 0;
+module_param(boot_raw_hires_test, uint, 0644);
+MODULE_PARM_DESC(boot_raw_hires_test,
+		 "Enable gathering boot time high resolution timer entropy of the first IRQ entropy events");
+
+static struct jent_testing jent_raw_hires = {
+	.rb_reader = 0,
+	.rb_writer = ATOMIC_INIT(0),
+	.lock      = __SPIN_LOCK_UNLOCKED(jent_raw_hires.lock),
+	.read_wait = __WAIT_QUEUE_HEAD_INITIALIZER(jent_raw_hires.read_wait)
+};
+
+int jent_raw_hires_entropy_store(__u32 value)
+{
+	return jent_testing_store(&jent_raw_hires, value, &boot_raw_hires_test);
+}
+EXPORT_SYMBOL(jent_raw_hires_entropy_store);
+
+static int jent_raw_hires_entropy_reader(u8 *outbuf, u32 outbuflen)
+{
+	return jent_testing_reader(&jent_raw_hires, &boot_raw_hires_test,
+				   outbuf, outbuflen);
+}
+
+static ssize_t jent_raw_hires_read(struct file *file, char __user *to,
+				   size_t count, loff_t *ppos)
+{
+	return jent_testing_extract_user(file, to, count, ppos,
+					 jent_raw_hires_entropy_reader);
+}
+
+static const struct file_operations jent_raw_hires_fops = {
+	.owner = THIS_MODULE,
+	.read = jent_raw_hires_read,
+};
+
+/******************************* Initialization *******************************/
+
+void jent_testing_init(void)
+{
+	jent_raw_debugfs_root = debugfs_create_dir(KBUILD_MODNAME, NULL);
+
+	debugfs_create_file_unsafe("jent_raw_hires", 0400,
+				   jent_raw_debugfs_root, NULL,
+				   &jent_raw_hires_fops);
+}
+EXPORT_SYMBOL(jent_testing_init);
+
+void jent_testing_exit(void)
+{
+	debugfs_remove_recursive(jent_raw_debugfs_root);
+}
+EXPORT_SYMBOL(jent_testing_exit);
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index b3890ff26a02..4c92176ea2b1 100644
--- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -17,3 +17,13 @@ extern struct rand_data *jent_entropy_collector_alloc(unsigned int osr,
 						      unsigned int flags,
 						      void *hash_state);
 extern void jent_entropy_collector_free(struct rand_data *entropy_collector);
+
+#ifdef CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE
+int jent_raw_hires_entropy_store(__u32 value);
+void jent_testing_init(void);
+void jent_testing_exit(void);
+#else /* CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE */
+static inline int jent_raw_hires_entropy_store(__u32 value) { return 0; }
+static inline void jent_testing_init(void) { }
+static inline void jent_testing_exit(void) { }
+#endif /* CONFIG_CRYPTO_JITTERENTROPY_TESTINTERFACE */
-- 
2.40.0




