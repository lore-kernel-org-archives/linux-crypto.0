Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BC8CDB465
	for <linux-crypto@archiver.kernel.org>; Thu, 19 Oct 2023 05:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232621AbjJSFrv (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Oct 2023 01:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbjJSFru (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Oct 2023 01:47:50 -0400
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [81.169.146.161])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B828124
        for <linux-crypto@vger.kernel.org>; Wed, 18 Oct 2023 22:47:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1697694285; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=a1csoRkctLhqvtY3usOZp4So6YbfKrLBqsfzuj+pDbvhLl6+Bl982E6Ro9OnPZuCtC
    3PhrJLwuLe+S8yBoU1ISUrjh9FRdLfHfJ9g90EAMGd0YdOmKvT+VMaFdpRHX267lXKGJ
    HocaPYe3ONR+k/HT1TIXyb7ODjdtD2S3BhuQr/Cbus9Eyj2Mp1Qfj5AVJu641VBudRBZ
    djHmbzoEbgL+cAc//zllAar2xOwufCb47Oiix5SHsuMiFhUQCaN8KFW19asQsfv4G3Ye
    rACiq1IqbaOxnjhAAR3zQH6+8O/rC2BAlw0Qu+a2E+JcgGOA+4gd5yxdZaTSwspFhIhE
    QMCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1697694285;
    s=strato-dkim-0002; d=strato.com;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=en6MA+0nNqYor3VGLy6bMayIhQuf3jpkidi2zdIQeCg=;
    b=Ax0IXhHWcilGk3vGKsnJCAg6IUJxcEw/XWXs4H6oMq+Lho2MiPYJ0Y/plJHscXzVWp
    IEK81CWHIoXOXerO15zYY7R6SdovL1dNoaVfdbI002UIHo2FIiuUf+t3nroabTZ0r3kf
    4NS6R8oQIbNtOAEvRC3PTptV56s83vaHh/6QK5yrzuGWEUdDk5WMn4UKIqH4+Y0k/nhV
    jazEwR90fvfXzwlpW2CEi82Rpe0KT1gptYwpVztZftYxN4nxAQgEHtxSFMP0BdQqbNTz
    TSXiRzDKO+CIaPFqw2D090RNHyBz758FE/JJZ2CeV088G/o4RMv/G/91A0k+D9uzbLiM
    7SKg==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1697694285;
    s=strato-dkim-0002; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=en6MA+0nNqYor3VGLy6bMayIhQuf3jpkidi2zdIQeCg=;
    b=IdoPgV2Ij+s7yEte4ia9Dc7DF01QyiJxybTlvkl2ehZb7Vyc74b0Il32lpkH+NrRLr
    jOmwGIQabSJzfWOBSsTCdcWeQjLPoqaJjZvKlDdb85q87mREIkpH3OW9R8nkza4yHYV+
    TkbmkxfsYbosRRQtf8xXiyDh2l0Gd/u9LtX4JF6ZCWewyNoly5vbTTDbnbdCn2b/WcnZ
    JJh2w06VWCzVbVP+x8BASpE+b2QelozyL+BUP2VQ4qZgpvqY9DR6j7F8+FzercX+QMcp
    8LIg2ysdLkN+eU0gUuj6T6N6amkMz8/o+iTth9XvemkvFf1RTu0y6X4xsKgXToN1qMEH
    ZENw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1697694285;
    s=strato-dkim-0003; d=chronox.de;
    h=Message-ID:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=en6MA+0nNqYor3VGLy6bMayIhQuf3jpkidi2zdIQeCg=;
    b=CuoeCa5ljBDn7ukR4RyHRIY5KoMYICyTGtrnwWC3Po0BYNFmeIrN6qZLhfYOnFf+Dc
    5o4LJBO9NW465anZezAA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9y2gdNk2TvDr2d0i04sY="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.9.0 DYNA|AUTH)
    with ESMTPSA id 22e7d3z9J5iiGxw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 19 Oct 2023 07:44:44 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, "Ospan, Abylay" <aospan@amazon.com>,
        Joachim Vandersmissen <git@jvdsn.com>
Subject: [PATCH] crypto: jitter - use permanent health test storage
Date:   Thu, 19 Oct 2023 07:44:42 +0200
Message-ID: <5719392.DvuYhMxLoT@positron.chronox.de>
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

The health test result in the current code is only given for the currently
processed raw time stamp. This implies that to react on the health test error,
the result must be checked after each raw time stamp being processed. To
avoid this constant checking requirement, any health test error is recorded
and stored to be analyzed at a later time, if needed.

This change ensures that the power-up test catches any health test error.
Without that patch, the power-up health test result is not enforced.

The introduced changes are already in use with the user space version of
the Jitter RNG.

Fixes: 04597c8dd6c4 ("jitter - add RCT/APT support for different OSRs")
Reported-by: Joachim Vandersmissen <git@jvdsn.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/jitterentropy.c | 125 ++++++++++++++++++++++++-----------------
 1 file changed, 74 insertions(+), 51 deletions(-)

diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index 09c9db90c154..edd865157a3c 100644
--- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -100,6 +100,8 @@ struct rand_data {
 	unsigned int apt_observations;	/* Number of collected observations */
 	unsigned int apt_count;		/* APT counter */
 	unsigned int apt_base;		/* APT base reference */
+	unsigned int health_failure;	/* Record health failure */
+
 	unsigned int apt_base_set:1;	/* APT base reference set? */
 };
 
@@ -121,6 +123,13 @@ struct rand_data {
 #define JENT_EHASH	       11 /* Hash self test failed */
 #define JENT_EMEM	       12 /* Can't allocate memory for initialization */
 
+#define JENT_RCT_FAILURE	1 /* Failure in RCT health test. */
+#define JENT_APT_FAILURE	2 /* Failure in APT health test. */
+#define JENT_PERMANENT_FAILURE_SHIFT	16
+#define JENT_PERMANENT_FAILURE(x)	(x << JENT_PERMANENT_FAILURE_SHIFT)
+#define JENT_RCT_FAILURE_PERMANENT	JENT_PERMANENT_FAILURE(JENT_RCT_FAILURE)
+#define JENT_APT_FAILURE_PERMANENT	JENT_PERMANENT_FAILURE(JENT_APT_FAILURE)
+
 /*
  * The output n bits can receive more than n bits of min entropy, of course,
  * but the fixed output of the conditioning function can only asymptotically
@@ -215,26 +224,22 @@ static void jent_apt_insert(struct rand_data *ec, unsigned int delta_masked)
 		return;
 	}
 
-	if (delta_masked == ec->apt_base)
+	if (delta_masked == ec->apt_base) {
 		ec->apt_count++;
 
+		/* Note, ec->apt_count starts with one. */
+		if (ec->apt_count >= ec->apt_cutoff_permanent)
+			ec->health_failure |= JENT_APT_FAILURE_PERMANENT;
+		else if (ec->apt_count >= ec->apt_cutoff)
+			ec->health_failure |= JENT_APT_FAILURE;
+	}
+
 	ec->apt_observations++;
 
 	if (ec->apt_observations >= JENT_APT_WINDOW_SIZE)
 		jent_apt_reset(ec, delta_masked);
 }
 
-/* APT health test failure detection */
-static int jent_apt_permanent_failure(struct rand_data *ec)
-{
-	return (ec->apt_count >= ec->apt_cutoff_permanent) ? 1 : 0;
-}
-
-static int jent_apt_failure(struct rand_data *ec)
-{
-	return (ec->apt_count >= ec->apt_cutoff) ? 1 : 0;
-}
-
 /***************************************************************************
  * Stuck Test and its use as Repetition Count Test
  *
@@ -261,6 +266,30 @@ static void jent_rct_insert(struct rand_data *ec, int stuck)
 {
 	if (stuck) {
 		ec->rct_count++;
+
+		/*
+		 * The cutoff value is based on the following consideration:
+		 * alpha = 2^-30 or 2^-60 as recommended in SP800-90B.
+		 * In addition, we require an entropy value H of 1/osr as this
+		 * is the minimum entropy required to provide full entropy.
+		 * Note, we collect (DATA_SIZE_BITS + ENTROPY_SAFETY_FACTOR)*osr
+		 * deltas for inserting them into the entropy pool which should
+		 * then have (close to) DATA_SIZE_BITS bits of entropy in the
+		 * conditioned output.
+		 *
+		 * Note, ec->rct_count (which equals to value B in the pseudo
+		 * code of SP800-90B section 4.4.1) starts with zero. Hence
+		 * we need to subtract one from the cutoff value as calculated
+		 * following SP800-90B. Thus C = ceil(-log_2(alpha)/H) = 30*osr
+		 * or 60*osr.
+		 */
+		if ((unsigned int)ec->rct_count >= (60 * ec->osr)) {
+			ec->rct_count = -1;
+			ec->health_failure |= JENT_RCT_FAILURE_PERMANENT;
+		} else if ((unsigned int)ec->rct_count >= (30 * ec->osr)) {
+			ec->rct_count = -1;
+			ec->health_failure |= JENT_RCT_FAILURE;
+		}
 	} else {
 		/* Reset RCT */
 		ec->rct_count = 0;
@@ -316,38 +345,24 @@ static int jent_stuck(struct rand_data *ec, __u64 current_delta)
 }
 
 /*
- * The cutoff value is based on the following consideration:
- * alpha = 2^-30 or 2^-60 as recommended in SP800-90B.
- * In addition, we require an entropy value H of 1/osr as this is the minimum
- * entropy required to provide full entropy.
- * Note, we collect (DATA_SIZE_BITS + ENTROPY_SAFETY_FACTOR)*osr deltas for
- * inserting them into the entropy pool which should then have (close to)
- * DATA_SIZE_BITS bits of entropy in the conditioned output.
- *
- * Note, ec->rct_count (which equals to value B in the pseudo code of SP800-90B
- * section 4.4.1) starts with zero. Hence we need to subtract one from the
- * cutoff value as calculated following SP800-90B. Thus
- * C = ceil(-log_2(alpha)/H) = 30*osr or 60*osr.
+ * Report any health test failures
+ *
+ * @ec [in] Reference to entropy collector
+ *
+ * @return a bitmask indicating which tests failed
+ *	0 No health test failure
+ *	1 RCT failure
+ *	2 APT failure
+ *	1<<JENT_PERMANENT_FAILURE_SHIFT RCT permanent failure
+ *	2<<JENT_PERMANENT_FAILURE_SHIFT APT permanent failure
  */
-static int jent_rct_permanent_failure(struct rand_data *ec)
+unsigned int jent_health_failure(struct rand_data *ec)
 {
-	return (ec->rct_count >= (60 * ec->osr)) ? 1 : 0;
-}
+	/* Test is only enabled in FIPS mode */
+	if (!fips_enabled)
+		return 0;
 
-static int jent_rct_failure(struct rand_data *ec)
-{
-	return (ec->rct_count >= (30 * ec->osr)) ? 1 : 0;
-}
-
-/* Report of health test failures */
-static int jent_health_failure(struct rand_data *ec)
-{
-	return jent_rct_failure(ec) | jent_apt_failure(ec);
-}
-
-static int jent_permanent_health_failure(struct rand_data *ec)
-{
-	return jent_rct_permanent_failure(ec) | jent_apt_permanent_failure(ec);
+	return ec->health_failure;
 }
 
 /***************************************************************************
@@ -594,11 +609,12 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 		return -1;
 
 	while (len > 0) {
-		unsigned int tocopy;
+		unsigned int tocopy, health_test_result;
 
 		jent_gen_entropy(ec);
 
-		if (jent_permanent_health_failure(ec)) {
+		health_test_result = jent_health_failure(ec);
+		if (health_test_result > JENT_PERMANENT_FAILURE_SHIFT) {
 			/*
 			 * At this point, the Jitter RNG instance is considered
 			 * as a failed instance. There is no rerun of the
@@ -606,13 +622,18 @@ int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			 * is assumed to not further use this instance.
 			 */
 			return -3;
-		} else if (jent_health_failure(ec)) {
+		} else if (health_test_result) {
 			/*
 			 * Perform startup health tests and return permanent
 			 * error if it fails.
 			 */
-			if (jent_entropy_init(0, 0, NULL, ec))
+			if (jent_entropy_init(0, 0, NULL, ec)) {
+				/* Mark the permanent error */
+				ec->health_failure &=
+					JENT_RCT_FAILURE_PERMANENT |
+					JENT_APT_FAILURE_PERMANENT;
 				return -3;
+			}
 
 			return -2;
 		}
@@ -695,6 +716,7 @@ int jent_entropy_init(unsigned int osr, unsigned int flags, void *hash_state,
 	 */
 	struct rand_data *ec = p_ec;
 	int i, time_backwards = 0, ret = 0, ec_free = 0;
+	unsigned int health_test_result;
 
 	if (!ec) {
 		ec = jent_entropy_collector_alloc(osr, flags, hash_state);
@@ -708,6 +730,9 @@ int jent_entropy_init(unsigned int osr, unsigned int flags, void *hash_state,
 		ec->apt_base_set = 0;
 		/* Reset the RCT */
 		ec->rct_count = 0;
+		/* Reset intermittent, leave permanent health test result */
+		ec->health_failure &= (~JENT_RCT_FAILURE);
+		ec->health_failure &= (~JENT_APT_FAILURE);
 	}
 
 	/* We could perform statistical tests here, but the problem is
@@ -788,12 +813,10 @@ int jent_entropy_init(unsigned int osr, unsigned int flags, void *hash_state,
 	}
 
 	/* Did we encounter a health test failure? */
-	if (jent_rct_failure(ec)) {
-		ret = JENT_ERCT;
-		goto out;
-	}
-	if (jent_apt_failure(ec)) {
-		ret = JENT_EHEALTH;
+	health_test_result = jent_health_failure(ec);
+	if (health_test_result) {
+		ret = (health_test_result & JENT_RCT_FAILURE) ? JENT_ERCT :
+								JENT_EHEALTH;
 		goto out;
 	}
 
-- 
2.42.0




