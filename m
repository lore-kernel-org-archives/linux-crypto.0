Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D968AC6FD1D
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Mar 2023 07:23:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjCWHXY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Mar 2023 03:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjCWHXX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2023 03:23:23 -0400
X-Greylist: delayed 180 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 23 Mar 2023 00:23:20 PDT
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.163])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F0E9775
        for <linux-crypto@vger.kernel.org>; Thu, 23 Mar 2023 00:23:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679555838; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=PNJw2ldCFHYUjIoUzmI2fVTDB1pYXSwm1P2XpqX02dTiDSRge/DY49aEj+T2O5fGCd
    Opx/gnyCHmXFYtyA0jiiZeKnqxFlN2Cyuj3WjtUdYyDsjDqcwfv6IZoDi58zCzcoDPA7
    IiG9cIrY9uKfNVG6dMY81Ry8L/x3gMdHHdgjtdiiEeozpQOy6DvDlAugKY2WtA8PxLtt
    acmL5hySCEUuZ3hTxn3IqjoaT5MheS3j5pgUpiRV8a4UOM+tm0t9AVno8a38iMHgux9q
    e/pYvQNaJ07uWauIUOcxNsg+tp7nWUYV/9KS2tdp99pYcRfBATXEYF+O3FPAllpC8q2m
    myOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1679555838;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=aTob7ObK7QLQQtxoiu1Xxke5tGs7lVBA0Ma06MwCevk=;
    b=RWQcugEjKJpsBf2nb88ucLzncNetAyoIqo0JM/yildHOVO62+YsFvGrwcV0+xbIEzF
    UpXFajni1KYLWlnEBvmLoXWvCBr0WydrALbIufQBzhIvWN3Ltsr8nh2tpnH3zNm7N3fz
    Y+W8GCfn2bNWly/gxkebwL5eQNCALCtuUSUHSM0n0rxCAB5QhaSBolKI/Wy1WNBb+fkH
    mKYDrPwsZiPtX/erwuCcSE5Vywv+1vEYAC9Bsy3ggcIlqzvBe82f19fMnXUGFSG6Fkc7
    qa9XWM0OHLPrObvVUunu/naU/nOZgEbTzG89R0oGNizFuyS8SXBMI+JOjt3RwGrHrdTx
    zt+Q==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1679555838;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=aTob7ObK7QLQQtxoiu1Xxke5tGs7lVBA0Ma06MwCevk=;
    b=rNe7zw+gXnrrRiE4vcDb8VC5+4dL3uQbQB+pm3DWxKgasNPDjcp0nJGqUTDGFvl1a9
    RwNiIYvXWzZO8u2Kl5tz9tMr6StZ2A7dFQpEil5Qo9oVexOM2O1dQPiOXmvuXOpUOcV+
    cdZ7l0uKDSorK1XOvSgPOPHullekTUnFSwPdcH8M67jeshFK2chmYAxRNkyDs2xJjXoO
    MHV1noKk/Rzs31fufWtte07N0lyxcQSJbwoRvcWkglGv/MbwyH6/JGDlWTa8GEm5g5pZ
    MWTrHAlh+Zk0gGMNQG7Ag0640eiKPPur7C4bvLuEgw3l29PPyN8rHT5NY+Slle0CFFJR
    WlFw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDr2d0uyvAg="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.3.1 DYNA|AUTH)
    with ESMTPSA id u24edez2N7HHVjL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 23 Mar 2023 08:17:17 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au
Subject: [PATCH] crypto: Jitter RNG - Permanent and Intermittent health errors
Date:   Thu, 23 Mar 2023 08:17:14 +0100
Message-ID: <12194787.O9o76ZdvQC@positron.chronox.de>
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

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/jitterentropy-kcapi.c |  45 ++++++-----
 crypto/jitterentropy.c       | 144 +++++++++++++----------------------
 2 files changed, 80 insertions(+), 109 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 2d115bec15ae..31d0fd57791b 100644
--- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -37,6 +37,7 @@
  * DAMAGE.
  */
 
+#include <linux/fips.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
@@ -102,7 +103,7 @@ void jent_get_nstime(__u64 *out)
 struct jitterentropy {
 	spinlock_t jent_lock;
 	struct rand_data *entropy_collector;
-	unsigned int reset_cnt;
+	bool disabled;
 };
 
 static int jent_kcapi_init(struct crypto_tfm *tfm)
@@ -138,29 +139,35 @@ static int jent_kcapi_random(struct crypto_rng *tfm,
 
 	spin_lock(&rng->jent_lock);
 
-	/* Return a permanent error in case we had too many resets in a row. */
-	if (rng->reset_cnt > (1<<10)) {
+	/* Enforce a disabled entropy source. */
+	if (rng->disabled) {
 		ret = -EFAULT;
 		goto out;
 	}
 
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
+		 * If the kernel was booted with fips=2, it implies that
+		 * the entire kernel acts as a FIPS 140 module. In this case
+		 * an SP800-90B permanent health test error is treated as
+		 * a FIPS module error.
+		 */
+		if (fips_enabled)
+			panic("Jitter RNG permanent health test failure\n");
+
+		pr_err("Jitter RNG permanent health test failure - disabling entropy source\n");
+		rng->disabled = true;
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
 
 out:
@@ -197,6 +204,10 @@ static int __init jent_mod_init(void)
 
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
index 93bff3213823..aa04749c6e46 100644
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
-- 
2.40.0




