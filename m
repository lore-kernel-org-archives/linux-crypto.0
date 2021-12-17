Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB0EC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Dec 2021 09:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbhLQJls (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Dec 2021 04:41:48 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:12447 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbhLQJls (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Dec 2021 04:41:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1639734103;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=QJDvqAj2MasIMOqUtYpRs8oAybr8RohQtMM08gHmJe4=;
    b=aMv3vhm4YeqpWCOdZ+xUN5V6MUKRpd94XpP5CEkhEtLjq1FV0Cpai24AAF8sdru7IQ
    ibcNPv5jQppKiiJy+5tGxtk3A/bFExb2KxCsEincaHCiPE15KpgGkCj3YqnMiGw2KqU4
    Qhff7MG0RwMl8OQylO4hI4OzWUjQ6ER2xI7iQokPYMS0Hx49bELSIL6Et9rLLT0LQQZT
    1xmbcaCoV0NUhKVrhYgB6zsi7k84IRyN0Foo6IpcoGULCOYdZj4qdDjmYkDigpKiCrGH
    0Q7nuzK1F/x5/Kx22T04pwqvkKr2OijIJWMq7j76byEgfSUY6U7kkI+kfMFstDiJQlfu
    vJuQ==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9zW8BKRp5UFiyGZZ4jof7Xg=="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.35.3 AUTH)
    with ESMTPSA id h03d91xBH9fgHeA
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Fri, 17 Dec 2021 10:41:42 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, simo@redhat.com, skozina@redhat.com,
        Nicolai Stange <nstange@suse.de>
Subject: [PATCH] crypto: jitter - add oversampling of noise source
Date:   Fri, 17 Dec 2021 10:41:42 +0100
Message-ID: <2573346.vuYhMxLoTh@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The output n bits can receive more than n bits of min entropy, of course,
but the fixed output of the conditioning function can only asymptotically
approach the output size bits of min entropy, not attain that bound.
Random maps will tend to have output collisions, which reduces the
creditable output entropy (that is what SP 800-90B Section 3.1.5.1.2
attempts to bound).

The value "64" is justified in Appendix A.4 of the current 90C draft,
and aligns with NIST's in "epsilon" definition in this document, which is
that a string can be considered "full entropy" if you can bound the min
entropy in each bit of output to at least 1-epsilon, where epsilon is
required to be <= 2^(-32).

Note, this patch causes the Jitter RNG to cut its performance in half in
FIPS mode because the conditioning function of the LFSR produces 64 bits
of entropy in one block. The oversampling requires that additionally 64
bits of entropy are sampled from the noise source. If the conditioner is
changed, such as using SHA-256, the impact of the oversampling is only
one fourth, because for the 256 bit block of the conditioner, only 64
additional bits from the noise source must be sampled.

This patch resurrects the function jent_fips_enabled as the oversampling
support is only enabled in FIPS mode.

This patch is derived from the user space jitterentropy-library.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/jitterentropy-kcapi.c |  6 ++++++
 crypto/jitterentropy.c       | 22 ++++++++++++++++++++--
 crypto/jitterentropy.h       |  1 +
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 2d115bec15ae..b02f93805e83 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -37,6 +37,7 @@
  * DAMAGE.
  */
 
+#include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -59,6 +60,11 @@ void jent_zfree(void *ptr)
 	kfree_sensitive(ptr);
 }
 
+int jent_fips_enabled(void)
+{
+	return fips_enabled;
+}
+
 void jent_panic(char *s)
 {
 	panic("%s", s);
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 8f5283f28ed3..9996120ad23c 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -117,6 +117,21 @@ struct rand_data {
 #define JENT_EHEALTH		9 /* Health test failed during initialization */
 #define JENT_ERCT		10 /* RCT failed during initialization */
 
+/*
+ * The output n bits can receive more than n bits of min entropy, of course,
+ * but the fixed output of the conditioning function can only asymptotically
+ * approach the output size bits of min entropy, not attain that bound. Random
+ * maps will tend to have output collisions, which reduces the creditable
+ * output entropy (that is what SP 800-90B Section 3.1.5.1.2 attempts to bound).
+ *
+ * The value "64" is justified in Appendix A.4 of the current 90C draft,
+ * and aligns with NIST's in "epsilon" definition in this document, which is
+ * that a string can be considered "full entropy" if you can bound the min
+ * entropy in each bit of output to at least 1-epsilon, where epsilon is
+ * required to be <= 2^(-32).
+ */
+#define JENT_ENTROPY_SAFETY_FACTOR	64
+
 #include "jitterentropy.h"
 
 /***************************************************************************
@@ -542,7 +557,10 @@ static int jent_measure_jitter(struct rand_data *ec)
  */
 static void jent_gen_entropy(struct rand_data *ec)
 {
-	unsigned int k = 0;
+	unsigned int k = 0, safety_factor = JENT_ENTROPY_SAFETY_FACTOR;
+
+	if (!jent_fips_enabled())
+		safety_factor = 0;
 
 	/* priming of the ->prev_time value */
 	jent_measure_jitter(ec);
@@ -556,7 +574,7 @@ static void jent_gen_entropy(struct rand_data *ec)
 		 * We multiply the loop value with ->osr to obtain the
 		 * oversampling rate requested by the caller
 		 */
-		if (++k >= (DATA_SIZE_BITS * ec->osr))
+		if (++k >= ((DATA_SIZE_BITS + safety_factor) * ec->osr))
 			break;
 	}
 }
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index b7397b617ef0..c83fff32d130 100644
--- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -2,6 +2,7 @@
 
 extern void *jent_zalloc(unsigned int len);
 extern void jent_zfree(void *ptr);
+extern int jent_fips_enabled(void);
 extern void jent_panic(char *s);
 extern void jent_memcpy(void *dest, const void *src, unsigned int n);
 extern void jent_get_nstime(__u64 *out);
-- 
2.33.1




