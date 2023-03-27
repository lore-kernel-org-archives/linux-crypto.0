Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B9AC7619A
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Mar 2023 07:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbjC0HEJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Mar 2023 03:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjC0HEI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Mar 2023 03:04:08 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52944203
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 00:04:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679900634; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Jy0g/YugYijuF/SaX1pkg096AN207ux8GA78MV8+9MqYkAafD+QYC3tST9j5tPjjkt
    XX2ODPxSAx/uPaWpdYDrLwUMILGJGAXr8u2QDKr/URqv4hno4Zxr90tbkXX08T3Afysh
    9mzkSvn6VVQuEOkhgCUxjpfmOhwYYM96H7HcTugFvfO3tHt8x5mlh9Zn1TuGorNrXYSc
    9OfMmsK07LyGVMmHC/YdgLDvEdQT83q+Slqm5+Y95qmUips0nZxxTg6GaoTDij7RHzUi
    Jwgi7iW7iRmrQbDMYfP5MFgb6N0XHmEaZYMuly/Qvbv9GRTaVDsIcRX19VrF2AX9vmSP
    lGfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1679900634;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Hxn09WhfSce/rrp9nNGF7vlrpqTbfOalTJJ7BdnO6ZQ=;
    b=Kil4QHtJK6dt1+W7FLFvUUmPrftK6zNH+mfsdA3QcGTsROPBPdns04hrZguHTi4fw2
    DIi8bGz9jVjAuTgzcycOLJdvmHhW4WZICHS3Hi68Oa+7MsfI+6zYZOeJB6WopyHhCL0F
    FZlkPFnnwECGZwe2zBYzPHthufR8yt+KMopWIzER1cOiADJYX6km+y7039AvqqemiS3N
    uT8aCB1GEOwwnGq/QHpXjjxlZRXZbNew3T8192sQlZFJsHe9RGX0iA09wp9tTbssd0vC
    lASRhtYOfj6yp/uJS8QnmR77tSyXIOOhTx5117IGRpRV8HJLo0xN41+n1RXj0mH3EClb
    NPUg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1679900634;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=Hxn09WhfSce/rrp9nNGF7vlrpqTbfOalTJJ7BdnO6ZQ=;
    b=rrYzpkg3KS91zw6UKg9jBsmmBnFFPrjRe6AZ9L6Edl6IMJJNDPWCuz7uVActKb8zdC
    Z++HeFLXck2bsaYng0oVavyZlA2mU+o34mao46mY7wPEs5kk3ZRmyP7t+L9kkuGS4L6v
    YCOj9awhhilIJrLJXZO2kl9a4wPwrGlrzzCA6eAjEdbwG0b5U2+VgSk5McLtdWCpbg/c
    mtZid1JdGhhxHNry2O5LqD5u9cmrdQTtpyFvUNN0GWVY9CsKZsDeiwTe4LPn+xluopOM
    doJdkQGOMKiccw5TAg/qvlRkjMm0g61e85mptv31V5o9nW7kGJoorVgQSi3cimp9lFlf
    LoHA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDz1d0+/iw=="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.3.1 AUTH)
    with ESMTPSA id u24edez2R73rk0h
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Mon, 27 Mar 2023 09:03:53 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Cc:     Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH v4] crypto: jitter - permanent and intermittent health errors
Date:   Mon, 27 Mar 2023 09:03:52 +0200
Message-ID: <4478169.LvFx2qVVIh@positron.chronox.de>
In-Reply-To: <12194787.O9o76ZdvQC@positron.chronox.de>
References: <12194787.O9o76ZdvQC@positron.chronox.de>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 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
 kBFBHm+xdudNab2U0OpfqrWerOw3WcGd2
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

According to SP800-90B, two health failures are allowed: the intermittend
and the permanent failure. So far, only the intermittent failure was
implemented. The permanent failure was achieved by resetting the entire
entropy source including its health test state and waiting for two or
more back-to-back health errors.

This approach is appropriate for RCT, but not for APT as APT has a
non-linear cutoff value. Thus, this patch implements 2 cutoff values
for both RCT/APT. This implies that the health state is left untouched
when an intermittent failure occurs. The noise source is reset
and a new APT powerup-self test is performed. Yet, whith the unchanged
health test state, the counting of failures continues until a permanent
failure is reached.

Any non-failing raw entropy value causes the health tests to reset.

The intermittent error has an unchanged significance level of 2^-30.
The permanent error has a significance level of 2^-60. Considering that
this level also indicates a false-positive rate (see SP800-90B section 4.2)
a false-positive must only be incurred with a low probability when
considering a fleet of Linux kernels as a whole. Hitting the permanent
error may cause a panic(), the following calculation applies: Assuming
that a fleet of 10^9 Linux kernels run concurrently with this patch in
FIPS mode and on each kernel 2 health tests are performed every minute
for one year, the chances of a false positive is about 1:1000
based on the binomial distribution.

In addition, any power-up health test errors triggered with
jent_entropy_init are treated as permanent errors.

A permanent failure causes the entire entropy source to permanently
return an error. This implies that a caller can only remedy the situation
by re-allocating a new instance of the Jitter RNG. In a subsequent
patch, a transparent re-allocation will be provided which also changes
the implied heuristic entropy assessment.

In addition, when the kernel is booted with fips=1, the Jitter RNG
is defined to be part of a FIPS module. The permanent error of the
Jitter RNG is translated as a FIPS module error. In this case, the entire
FIPS module must cease operation. This is implemented in the kernel by
invoking panic().

The patch also fixes an off-by-one in the RCT cutoff value which is now
set to 30 instead of 31. This is because the counting of the values
starts with 0.

Reviewed-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---

v4:
 - fix comment regarding fips=1
 - update patch subject to match common naming schema
 - remove now unused jent_panic function
 - added Reviewed-by line

v3:
 - remove an unused goto target

v2:
 - Drop the enforcement of permanent disabling the entropy source

 crypto/jitterentropy-kcapi.c |  51 ++++++-------
 crypto/jitterentropy.c       | 144 +++++++++++++----------------------
 crypto/jitterentropy.h       |   1 -
 3 files changed, 76 insertions(+), 120 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 2d115bec15ae..b9edfaa51b27 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -37,6 +37,7 @@
  * DAMAGE.
  */
 
+#include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -59,11 +60,6 @@ void jent_zfree(void *ptr)
 	kfree_sensitive(ptr);
 }
 
-void jent_panic(char *s)
-{
-	panic("%s", s);
-}
-
 void jent_memcpy(void *dest, const void *src, unsigned int n)
 {
 	memcpy(dest, src, n);
@@ -102,7 +98,6 @@ void jent_get_nstime(__u64 *out)
 struct jitterentropy {
 	spinlock_t jent_lock;
 	struct rand_data *entropy_collector;
-	unsigned int reset_cnt;
 };
 
 static int jent_kcapi_init(struct crypto_tfm *tfm)
@@ -138,32 +133,30 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 
 	spin_lock(&rng->jent_lock);
 
-	/* Return a permanent error in case we had too many resets in a row. */
-	if (rng->reset_cnt > (1<<10)) {
-		ret = -EFAULT;
-		goto out;
-	}
-
 	ret = jent_read_entropy(rng->entropy_collector, rdata, dlen);
 
-	/* Reset RNG in case of health failures */
-	if (ret < -1) {
-		pr_warn_ratelimited("Reset Jitter RNG due to health test failure: %s failure\n",
-				    (ret == -2) ? "Repetition Count Test" :
-						  "Adaptive Proportion Test");
-
-		rng->reset_cnt++;
-
+	if (ret == -3) {
+		/* Handle permanent health test error */
+		/*
+		 * If the kernel was booted with fips=1, it implies that
+		 * the entire kernel acts as a FIPS 140 module. In this case
+		 * an SP800-90B permanent health test error is treated as
+		 * a FIPS module error.
+		 */
+		if (fips_enabled)
+			panic("Jitter RNG permanent health test failure\n");
+
+		pr_err("Jitter RNG permanent health test failure\n");
+		ret = -EFAULT;
+	} else if (ret == -2) {
+		/* Handle intermittent health test error */
+		pr_warn_ratelimited("Reset Jitter RNG due to intermittent health test failure\n");
 		ret = -EAGAIN;
-	} else {
-		rng->reset_cnt = 0;
-
-		/* Convert the Jitter RNG error into a usable error code */
-		if (ret == -1)
-			ret = -EINVAL;
+	} else if (ret == -1) {
+		/* Handle other errors */
+		ret = -EINVAL;
 	}
 
-out:
 	spin_unlock(&rng->jent_lock);
 
 	return ret;
@@ -197,6 +190,10 @@ static int __init jent_mod_init(void)
 
 	ret = jent_entropy_init();
 	if (ret) {
+		/* Handle permanent health test error */
+		if (fips_enabled)
+			panic("jitterentropy: Initialization failed with host not compliant with requirements: %d\n", ret);
+
 		pr_info("jitterentropy: Initialization failed with host not compliant with requirements: %d\n", ret);
 		return -EFAULT;
 	}
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 93bff3213823..22f48bf4c6f5 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -85,10 +85,14 @@ struct rand_data {
 				      * bit generation */
 
 	/* Repetition Count Test */
-	int rct_count;			/* Number of stuck values */
+	unsigned int rct_count;			/* Number of stuck values */
 
-	/* Adaptive Proportion Test for a significance level of 2^-30 */
+	/* Intermittent health test failure threshold of 2^-30 */
+#define JENT_RCT_CUTOFF		30	/* Taken from SP800-90B sec 4.4.1 */
 #define JENT_APT_CUTOFF		325	/* Taken from SP800-90B sec 4.4.2 */
+	/* Permanent health test failure threshold of 2^-60 */
+#define JENT_RCT_CUTOFF_PERMANENT	60
+#define JENT_APT_CUTOFF_PERMANENT	355
 #define JENT_APT_WINDOW_SIZE	512	/* Data window size */
 	/* LSB of time stamp to process */
 #define JENT_APT_LSB		16
@@ -97,8 +101,6 @@ struct rand_data {
 	unsigned int apt_count;		/* APT counter */
 	unsigned int apt_base;		/* APT base reference */
 	unsigned int apt_base_set:1;	/* APT base reference set? */
-
-	unsigned int health_failure:1;	/* Permanent health failure */
 };
 
 /* Flags that can be used to initialize the RNG */
@@ -169,19 +171,26 @@ static void jent_apt_insert(struct rand_data *ec, unsigned int delta_masked)
 		return;
 	}
 
-	if (delta_masked == ec->apt_base) {
+	if (delta_masked == ec->apt_base)
 		ec->apt_count++;
 
-		if (ec->apt_count >= JENT_APT_CUTOFF)
-			ec->health_failure = 1;
-	}
-
 	ec->apt_observations++;
 
 	if (ec->apt_observations >= JENT_APT_WINDOW_SIZE)
 		jent_apt_reset(ec, delta_masked);
 }
 
+/* APT health test failure detection */
+static int jent_apt_permanent_failure(struct rand_data *ec)
+{
+	return (ec->apt_count >= JENT_APT_CUTOFF_PERMANENT) ? 1 : 0;
+}
+
+static int jent_apt_failure(struct rand_data *ec)
+{
+	return (ec->apt_count >= JENT_APT_CUTOFF) ? 1 : 0;
+}
+
 /***************************************************************************
  * Stuck Test and its use as Repetition Count Test
  *
@@ -206,55 +215,14 @@ static void jent_apt_insert(struct rand_data *ec, unsigned int delta_masked)
  */
 static void jent_rct_insert(struct rand_data *ec, int stuck)
 {
-	/*
-	 * If we have a count less than zero, a previous RCT round identified
-	 * a failure. We will not overwrite it.
-	 */
-	if (ec->rct_count < 0)
-		return;
-
 	if (stuck) {
 		ec->rct_count++;
-
-		/*
-		 * The cutoff value is based on the following consideration:
-		 * alpha = 2^-30 as recommended in FIPS 140-2 IG 9.8.
-		 * In addition, we require an entropy value H of 1/OSR as this
-		 * is the minimum entropy required to provide full entropy.
-		 * Note, we collect 64 * OSR deltas for inserting them into
-		 * the entropy pool which should then have (close to) 64 bits
-		 * of entropy.
-		 *
-		 * Note, ec->rct_count (which equals to value B in the pseudo
-		 * code of SP800-90B section 4.4.1) starts with zero. Hence
-		 * we need to subtract one from the cutoff value as calculated
-		 * following SP800-90B.
-		 */
-		if ((unsigned int)ec->rct_count >= (31 * ec->osr)) {
-			ec->rct_count = -1;
-			ec->health_failure = 1;
-		}
 	} else {
+		/* Reset RCT */
 		ec->rct_count = 0;
 	}
 }
 
-/*
- * Is there an RCT health test failure?
- *
- * @ec [in] Reference to entropy collector
- *
- * @return
- * 	0 No health test failure
- * 	1 Permanent health test failure
- */
-static int jent_rct_failure(struct rand_data *ec)
-{
-	if (ec->rct_count < 0)
-		return 1;
-	return 0;
-}
-
 static inline __u64 jent_delta(__u64 prev, __u64 next)
 {
 #define JENT_UINT64_MAX		(__u64)(~((__u64) 0))
@@ -303,18 +271,26 @@ static int jent_stuck(struct rand_data *ec, __u64 current_delta)
 	return 0;
 }
 
-/*
- * Report any health test failures
- *
- * @ec [in] Reference to entropy collector
- *
- * @return
- * 	0 No health test failure
- * 	1 Permanent health test failure
- */
+/* RCT health test failure detection */
+static int jent_rct_permanent_failure(struct rand_data *ec)
+{
+	return (ec->rct_count >= JENT_RCT_CUTOFF_PERMANENT) ? 1 : 0;
+}
+
+static int jent_rct_failure(struct rand_data *ec)
+{
+	return (ec->rct_count >= JENT_RCT_CUTOFF) ? 1 : 0;
+}
+
+/* Report of health test failures */
 static int jent_health_failure(struct rand_data *ec)
 {
-	return ec->health_failure;
+	return jent_rct_failure(ec) | jent_apt_failure(ec);
+}
+
+static int jent_permanent_health_failure(struct rand_data *ec)
+{
+	return jent_rct_permanent_failure(ec) | jent_apt_permanent_failure(ec);
 }
 
 /***************************************************************************
@@ -600,8 +576,8 @@ static void jent_gen_entropy(struct rand_data *ec)
  *
  * The following error codes can occur:
  *	-1	entropy_collector is NULL
- *	-2	RCT failed
- *	-3	APT test failed
+ *	-2	Intermittent health failure
+ *	-3	Permanent health failure
  */
 int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 		      unsigned int len)
@@ -616,39 +592,23 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 
 		jent_gen_entropy(ec);
 
-		if (jent_health_failure(ec)) {
-			int ret;
-
-			if (jent_rct_failure(ec))
-				ret = -2;
-			else
-				ret = -3;
-
+		if (jent_permanent_health_failure(ec)) {
 			/*
-			 * Re-initialize the noise source
-			 *
-			 * If the health test fails, the Jitter RNG remains
-			 * in failure state and will return a health failure
-			 * during next invocation.
+			 * At this point, the Jitter RNG instance is considered
+			 * as a failed instance. There is no rerun of the
+			 * startup test any more, because the caller
+			 * is assumed to not further use this instance.
 			 */
-			if (jent_entropy_init())
-				return ret;
-
-			/* Set APT to initial state */
-			jent_apt_reset(ec, 0);
-			ec->apt_base_set = 0;
-
-			/* Set RCT to initial state */
-			ec->rct_count = 0;
-
-			/* Re-enable Jitter RNG */
-			ec->health_failure = 0;
-
+			return -3;
+		} else if (jent_health_failure(ec)) {
 			/*
-			 * Return the health test failure status to the
-			 * caller as the generated value is not appropriate.
+			 * Perform startup health tests and return permanent
+			 * error if it fails.
 			 */
-			return ret;
+			if (jent_entropy_init())
+				return -3;
+
+			return -2;
 		}
 
 		if ((DATA_SIZE_BITS / 8) < len)
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index b7397b617ef0..5cc583f6bc6b 100644
--- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -2,7 +2,6 @@
 
 extern void *jent_zalloc(unsigned int len);
 extern void jent_zfree(void *ptr);
-extern void jent_panic(char *s);
 extern void jent_memcpy(void *dest, const void *src, unsigned int n);
 extern void jent_get_nstime(__u64 *out);
 
-- 
2.40.0




