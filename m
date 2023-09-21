Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8582CE7D0A3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Sep 2023 17:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbjIURte (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Sep 2023 13:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjIURtI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Sep 2023 13:49:08 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [81.169.146.167])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FE0159155
        for <linux-crypto@vger.kernel.org>; Thu, 21 Sep 2023 10:20:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1695297005; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=Em6B7H33R6v/fv8xxEysoyeavqZBlUTDyfZbfDf3JE7ZPLijfJ4jzibihKWYUYhzi5
    3ovcuQKHpoHry568CREM/HnkvOKLJV8qdPkIjtn+2tvdIppKVqqTlYxjZmDASN+Z+U4h
    rGuhzOCmUyTO83cwV11LTBLHTFTAu2dK5Mhd+SiAA1uP/rSb2ICB9lSxEndhDrZDOfZ0
    aC+LVYFZK5aOBEkC7whrzLj51RWT59GdxBLz43rjICA41e20bXOnyeOG/tp0QErv61rX
    DiywhZQMihQxm6bAX02++ws/gp7FAQCw2WlAsiK0ej3iQYNA16IUkKrgEVt9UVv/vTxQ
    +kqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1695297005;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=ftClGQv14xOAkeo7YOmehhtX7Dx8t3CzzFz/IbW9UkY=;
    b=dtn0BRROLkOwiNpW0KZoVs7z2joOEM4bQtW+mR8Rti0p0/YGf/R+W78eu8SxItV+rZ
    y2G3M1VNylk9ua6KY5OaxPIJ2Bq98iJM1eJu/T+7O1QdKPtCWlA2WWh/4HTrDXHKsTXJ
    Iel2qYgyjIhpe5W2tz+UisY7BxHVgdCW5aqtuT4WMR1pq01hG9QHjCq+4Uve+Bh36RHm
    DWk+xa2pXwflP7nvSI/OxatRVHZPtIdc7ca9zsk6kdK72rvjjILdNvpZoLqgBMa+z8BP
    M1kvoBAOYcNrndAOa7pwFu+yCnTWmCqmryEG0Xb9xS98H2oi5flphxOc3Mi2LjMazHRa
    5CaQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1695297005;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=ftClGQv14xOAkeo7YOmehhtX7Dx8t3CzzFz/IbW9UkY=;
    b=JpGifu1sUT8MzaT/IaNzYNEz2NqxTBE5PT3AtTvFLijbbLGfnVS47BEyyCTSmen1MM
    4r5H8DwhWR+l9XzSeYZ5pi8vhgqAiwf2J+pzVL33rV2FffD5c6UAJiy61CmK2hWZ0JWh
    MEFH/bYG//AoWODW3sP13no+oIYXZuKBYkhPKTeJhsaYUcfCORY/DF5ECEIzw5V4W1LT
    THqYZ5Uh8UdyApXN5zSOW03M0PWB2bZBdmfYN0ndqusu4Ri+mP6ybIn/AJS+IZ1xFP3f
    aZQtnZFPUZH/W3HdZrk04xmSt6hdHnvJ10ZrmtmctOI3mOqM1JDGdLk2U+BKSsvTbPnT
    mSTA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1695297005;
    s=strato-dkim-0003; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=ftClGQv14xOAkeo7YOmehhtX7Dx8t3CzzFz/IbW9UkY=;
    b=3CC3Kq0AUjYRCjKd5iy0lmU749QpsEJzGONsmmtRgwG6E0UsBlBLJ1R8NqTmMxqT/a
    trIjKDIzHuc3K+eECzDQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9yGwdNoa/n6V4wJnv+Q=="
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 49.8.2 AUTH)
    with ESMTPSA id u045efz8LBo58td
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 21 Sep 2023 13:50:05 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, "Ospan, Abylay" <aospan@amazon.com>
Subject: [PATCH 1/3] crypto: jitter - add RCT/APT support for different OSRs
Date:   Thu, 21 Sep 2023 13:48:11 +0200
Message-ID: <5974948.lOV4Wx5bFT@positron.chronox.de>
In-Reply-To: <2700818.mvXUDI8C0e@positron.chronox.de>
References: <2700818.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Autocrypt: addr=smueller@chronox.de;
 keydata=
 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
 kBFBHm+xdudNab2U0OpfqrWerOw3WcGd2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The oversampling rate (OSR) value specifies the heuristically implied
entropy in the recorded data - H_submitter =3D 1/osr. A different entropy
estimate implies a different APT/RCT cutoff value. This change adds
support for OSRs 1 through 15. This OSR can be selected by the caller
of the Jitter RNG.

=46or this patch, the caller still uses one hard-coded OSR. A subsequent
patch allows this value to be configured.

In addition, the power-up self test is adjusted as follows:

* It allows the caller to provide an oversampling rate that should be
tested with - commonly it should be the same as used for the actual
runtime operation. This makes the power-up testing therefore consistent
with the runtime operation.

* It calls now jent_measure_jitter (i.e. collects the full entropy
that can possibly be harvested by the Jitter RNG) instead of only
jent_condition_data (which only returns the entropy harvested from
the conditioning component). This should now alleviate reports where
the Jitter RNG initialization thinks there is too little entropy.

* The power-up test now solely relies on the (enhanced) APT and RCT
test that is used as a health test at runtime.

The code allowing the different OSRs as well as the power-up test
changes are present in the user space version of the Jitter RNG 3.4.1
and thus was already in production use for some time.

Reported-by "Ospan, Abylay" <aospan@amazon.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
=2D--
 crypto/jitterentropy-kcapi.c |   4 +-
 crypto/jitterentropy.c       | 233 ++++++++++++++++++-----------------
 crypto/jitterentropy.h       |   3 +-
 3 files changed, 123 insertions(+), 117 deletions(-)

diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
index 7d1463a1562a..1de730f94683 100644
=2D-- a/crypto/jitterentropy-kcapi.c
+++ b/crypto/jitterentropy-kcapi.c
@@ -245,7 +245,7 @@ static int jent_kcapi_init(struct crypto_tfm *tfm)
 	crypto_shash_init(sdesc);
 	rng->sdesc =3D sdesc;
=20
=2D	rng->entropy_collector =3D jent_entropy_collector_alloc(1, 0, sdesc);
+	rng->entropy_collector =3D jent_entropy_collector_alloc(0, 0, sdesc);
 	if (!rng->entropy_collector) {
 		ret =3D -ENOMEM;
 		goto err;
@@ -334,7 +334,7 @@ static int __init jent_mod_init(void)
=20
 	desc->tfm =3D tfm;
 	crypto_shash_init(desc);
=2D	ret =3D jent_entropy_init(desc);
+	ret =3D jent_entropy_init(0, 0, desc);
 	shash_desc_zero(desc);
 	crypto_free_shash(tfm);
 	if (ret) {
diff --git a/crypto/jitterentropy.c b/crypto/jitterentropy.c
index fe9c233ec769..c99734af82b8 100644
=2D-- a/crypto/jitterentropy.c
+++ b/crypto/jitterentropy.c
@@ -72,6 +72,8 @@ struct rand_data {
 	__u64 prev_time;		/* SENSITIVE Previous time stamp */
 	__u64 last_delta;		/* SENSITIVE stuck test */
 	__s64 last_delta2;		/* SENSITIVE stuck test */
+
+	unsigned int flags;		/* Flags used to initialize */
 	unsigned int osr;		/* Oversample rate */
 #define JENT_MEMORY_BLOCKS 64
 #define JENT_MEMORY_BLOCKSIZE 32
@@ -88,16 +90,9 @@ struct rand_data {
 	/* Repetition Count Test */
 	unsigned int rct_count;			/* Number of stuck values */
=20
=2D	/* Intermittent health test failure threshold of 2^-30 */
=2D	/* From an SP800-90B perspective, this RCT cutoff value is equal to 31.=
 */
=2D	/* However, our RCT implementation starts at 1, so we subtract 1 here. =
*/
=2D#define JENT_RCT_CUTOFF		(31 - 1)	/* Taken from SP800-90B sec 4.4.1 */
=2D#define JENT_APT_CUTOFF		325			/* Taken from SP800-90B sec 4.4.2 */
=2D	/* Permanent health test failure threshold of 2^-60 */
=2D	/* From an SP800-90B perspective, this RCT cutoff value is equal to 61.=
 */
=2D	/* However, our RCT implementation starts at 1, so we subtract 1 here. =
*/
=2D#define JENT_RCT_CUTOFF_PERMANENT	(61 - 1)
=2D#define JENT_APT_CUTOFF_PERMANENT	355
+	/* Adaptive Proportion Test cutoff values */
+	unsigned int apt_cutoff; /* Intermittent health test failure */
+	unsigned int apt_cutoff_permanent; /* Permanent health test failure */
 #define JENT_APT_WINDOW_SIZE	512	/* Data window size */
 	/* LSB of time stamp to process */
 #define JENT_APT_LSB		16
@@ -122,6 +117,9 @@ struct rand_data {
 				   * zero). */
 #define JENT_ESTUCK		8 /* Too many stuck results during init. */
 #define JENT_EHEALTH		9 /* Health test failed during initialization */
+#define JENT_ERCT	       10 /* RCT failed during initialization */
+#define JENT_EHASH	       11 /* Hash self test failed */
+#define JENT_EMEM	       12 /* Can't allocate memory for initialization */
=20
 /*
  * The output n bits can receive more than n bits of min entropy, of cours=
e,
@@ -147,6 +145,48 @@ struct rand_data {
  * This test complies with SP800-90B section 4.4.2.
  *************************************************************************=
**/
=20
+/*
+ * See the SP 800-90B comment #10b for the corrected cutoff for the SP 800=
=2D90B
+ * APT.
+ * http://www.untruth.org/~josh/sp80090b/UL%20SP800-90B-final%20comments%2=
0v1.9%2020191212.pdf
+ * In in the syntax of R, this is C =3D 2 + qbinom(1 =E2=88=92 2^(=E2=88=
=9230), 511, 2^(-1/osr)).
+ * (The original formula wasn't correct because the first symbol must
+ * necessarily have been observed, so there is no chance of observing 0 of=
 these
+ * symbols.)
+ *
+ * For the alpha < 2^-53, R cannot be used as it uses a float data type wi=
thout
+ * arbitrary precision. A SageMath script is used to calculate those cutoff
+ * values.
+ *
+ * For any value above 14, this yields the maximal allowable value of 512
+ * (by FIPS 140-2 IG 7.19 Resolution # 16, we cannot choose a cutoff value=
 that
+ * renders the test unable to fail).
+ */
+static const unsigned int jent_apt_cutoff_lookup[15] =3D {
+	325, 422, 459, 477, 488, 494, 499, 502,
+	505, 507, 508, 509, 510, 511, 512 };
+static const unsigned int jent_apt_cutoff_permanent_lookup[15] =3D {
+	355, 447, 479, 494, 502, 507, 510, 512,
+	512, 512, 512, 512, 512, 512, 512 };
+#define ARRAY_SIZE(x) (sizeof(x) / sizeof((x)[0]))
+
+static void jent_apt_init(struct rand_data *ec, unsigned int osr)
+{
+	/*
+	 * Establish the apt_cutoff based on the presumed entropy rate of
+	 * 1/osr.
+	 */
+	if (osr >=3D ARRAY_SIZE(jent_apt_cutoff_lookup)) {
+		ec->apt_cutoff =3D jent_apt_cutoff_lookup[
+			ARRAY_SIZE(jent_apt_cutoff_lookup) - 1];
+		ec->apt_cutoff_permanent =3D jent_apt_cutoff_permanent_lookup[
+			ARRAY_SIZE(jent_apt_cutoff_permanent_lookup) - 1];
+	} else {
+		ec->apt_cutoff =3D jent_apt_cutoff_lookup[osr - 1];
+		ec->apt_cutoff_permanent =3D
+				jent_apt_cutoff_permanent_lookup[osr - 1];
+	}
+}
 /*
  * Reset the APT counter
  *
@@ -187,12 +227,12 @@ static void jent_apt_insert(struct rand_data *ec, uns=
igned int delta_masked)
 /* APT health test failure detection */
 static int jent_apt_permanent_failure(struct rand_data *ec)
 {
=2D	return (ec->apt_count >=3D JENT_APT_CUTOFF_PERMANENT) ? 1 : 0;
+	return (ec->apt_count >=3D ec->apt_cutoff_permanent) ? 1 : 0;
 }
=20
 static int jent_apt_failure(struct rand_data *ec)
 {
=2D	return (ec->apt_count >=3D JENT_APT_CUTOFF) ? 1 : 0;
+	return (ec->apt_count >=3D ec->apt_cutoff) ? 1 : 0;
 }
=20
 /*************************************************************************=
**
@@ -275,15 +315,28 @@ static int jent_stuck(struct rand_data *ec, __u64 cur=
rent_delta)
 	return 0;
 }
=20
=2D/* RCT health test failure detection */
+/*
+ * The cutoff value is based on the following consideration:
+ * alpha =3D 2^-30 or 2^-60 as recommended in SP800-90B.
+ * In addition, we require an entropy value H of 1/osr as this is the mini=
mum
+ * entropy required to provide full entropy.
+ * Note, we collect (DATA_SIZE_BITS + ENTROPY_SAFETY_FACTOR)*osr deltas for
+ * inserting them into the entropy pool which should then have (close to)
+ * DATA_SIZE_BITS bits of entropy in the conditioned output.
+ *
+ * Note, ec->rct_count (which equals to value B in the pseudo code of SP80=
0-90B
+ * section 4.4.1) starts with zero. Hence we need to subtract one from the
+ * cutoff value as calculated following SP800-90B. Thus
+ * C =3D ceil(-log_2(alpha)/H) =3D 30*osr or 60*osr.
+ */
 static int jent_rct_permanent_failure(struct rand_data *ec)
 {
=2D	return (ec->rct_count >=3D JENT_RCT_CUTOFF_PERMANENT) ? 1 : 0;
+	return (ec->rct_count >=3D (60 * ec->osr)) ? 1 : 0;
 }
=20
 static int jent_rct_failure(struct rand_data *ec)
 {
=2D	return (ec->rct_count >=3D JENT_RCT_CUTOFF) ? 1 : 0;
+	return (ec->rct_count >=3D (30 * ec->osr)) ? 1 : 0;
 }
=20
 /* Report of health test failures */
@@ -448,7 +501,7 @@ static void jent_memaccess(struct rand_data *ec, __u64 =
loop_cnt)
  *
  * @return result of stuck test
  */
=2Dstatic int jent_measure_jitter(struct rand_data *ec)
+static int jent_measure_jitter(struct rand_data *ec, __u64 *ret_current_de=
lta)
 {
 	__u64 time =3D 0;
 	__u64 current_delta =3D 0;
@@ -472,6 +525,10 @@ static int jent_measure_jitter(struct rand_data *ec)
 	if (jent_condition_data(ec, current_delta, stuck))
 		stuck =3D 1;
=20
+	/* return the raw entropy value */
+	if (ret_current_delta)
+		*ret_current_delta =3D current_delta;
+
 	return stuck;
 }
=20
@@ -489,11 +546,11 @@ static void jent_gen_entropy(struct rand_data *ec)
 		safety_factor =3D JENT_ENTROPY_SAFETY_FACTOR;
=20
 	/* priming of the ->prev_time value */
=2D	jent_measure_jitter(ec);
+	jent_measure_jitter(ec, NULL);
=20
 	while (!jent_health_failure(ec)) {
 		/* If a stuck measurement is received, repeat measurement */
=2D		if (jent_measure_jitter(ec))
+		if (jent_measure_jitter(ec, NULL))
 			continue;
=20
 		/*
@@ -554,7 +611,8 @@ int jent_read_entropy(struct rand_data *ec, unsigned ch=
ar *data,
 			 * Perform startup health tests and return permanent
 			 * error if it fails.
 			 */
=2D			if (jent_entropy_init(ec->hash_state))
+			if (jent_entropy_init(ec->osr, ec->flags,
+					      ec->hash_state))
 				return -3;
=20
 			return -2;
@@ -604,11 +662,15 @@ struct rand_data *jent_entropy_collector_alloc(unsign=
ed int osr,
=20
 	/* verify and set the oversampling rate */
 	if (osr =3D=3D 0)
=2D		osr =3D 1; /* minimum sampling rate is 1 */
+		osr =3D 1; /* H_submitter =3D 1 / osr */
 	entropy_collector->osr =3D osr;
+	entropy_collector->flags =3D flags;
=20
 	entropy_collector->hash_state =3D hash_state;
=20
+	/* Initialize the APT */
+	jent_apt_init(entropy_collector, osr);
+
 	/* fill the data pad with non-zero values */
 	jent_gen_entropy(entropy_collector);
=20
@@ -622,20 +684,14 @@ void jent_entropy_collector_free(struct rand_data *en=
tropy_collector)
 	jent_zfree(entropy_collector);
 }
=20
=2Dint jent_entropy_init(void *hash_state)
+int jent_entropy_init(unsigned int osr, unsigned int flags, void *hash_sta=
te)
 {
=2D	int i;
=2D	__u64 delta_sum =3D 0;
=2D	__u64 old_delta =3D 0;
=2D	unsigned int nonstuck =3D 0;
=2D	int time_backwards =3D 0;
=2D	int count_mod =3D 0;
=2D	int count_stuck =3D 0;
=2D	struct rand_data ec =3D { 0 };
=2D
=2D	/* Required for RCT */
=2D	ec.osr =3D 1;
=2D	ec.hash_state =3D hash_state;
+	struct rand_data *ec;
+	int i, time_backwards =3D 0, ret =3D 0;
+
+	ec =3D jent_entropy_collector_alloc(osr, flags, hash_state);
+	if (!ec)
+		return JENT_EMEM;
=20
 	/* We could perform statistical tests here, but the problem is
 	 * that we only have a few loop counts to do testing. These
@@ -664,31 +720,28 @@ int jent_entropy_init(void *hash_state)
 #define TESTLOOPCOUNT 1024
 #define CLEARCACHE 100
 	for (i =3D 0; (TESTLOOPCOUNT + CLEARCACHE) > i; i++) {
=2D		__u64 time =3D 0;
=2D		__u64 time2 =3D 0;
=2D		__u64 delta =3D 0;
=2D		unsigned int lowdelta =3D 0;
=2D		int stuck;
+		__u64 start_time =3D 0, end_time =3D 0, delta =3D 0;
=20
 		/* Invoke core entropy collection logic */
=2D		jent_get_nstime(&time);
=2D		ec.prev_time =3D time;
=2D		jent_condition_data(&ec, time, 0);
=2D		jent_get_nstime(&time2);
+		jent_measure_jitter(ec, &delta);
+		end_time =3D ec->prev_time;
+		start_time =3D ec->prev_time - delta;
=20
 		/* test whether timer works */
=2D		if (!time || !time2)
=2D			return JENT_ENOTIME;
=2D		delta =3D jent_delta(time, time2);
+		if (!start_time || !end_time) {
+			ret =3D JENT_ENOTIME;
+			goto out;
+		}
+
 		/*
 		 * test whether timer is fine grained enough to provide
 		 * delta even when called shortly after each other -- this
 		 * implies that we also have a high resolution timer
 		 */
=2D		if (!delta)
=2D			return JENT_ECOARSETIME;
=2D
=2D		stuck =3D jent_stuck(&ec, delta);
+		if (!delta || (end_time =3D=3D start_time)) {
+			ret =3D JENT_ECOARSETIME;
+			goto out;
+		}
=20
 		/*
 		 * up to here we did not modify any variable that will be
@@ -700,49 +753,9 @@ int jent_entropy_init(void *hash_state)
 		if (i < CLEARCACHE)
 			continue;
=20
=2D		if (stuck)
=2D			count_stuck++;
=2D		else {
=2D			nonstuck++;
=2D
=2D			/*
=2D			 * Ensure that the APT succeeded.
=2D			 *
=2D			 * With the check below that count_stuck must be less
=2D			 * than 10% of the overall generated raw entropy values
=2D			 * it is guaranteed that the APT is invoked at
=2D			 * floor((TESTLOOPCOUNT * 0.9) / 64) =3D=3D 14 times.
=2D			 */
=2D			if ((nonstuck % JENT_APT_WINDOW_SIZE) =3D=3D 0) {
=2D				jent_apt_reset(&ec,
=2D					       delta & JENT_APT_WORD_MASK);
=2D			}
=2D		}
=2D
=2D		/* Validate health test result */
=2D		if (jent_health_failure(&ec))
=2D			return JENT_EHEALTH;
=2D
 		/* test whether we have an increasing timer */
=2D		if (!(time2 > time))
+		if (!(end_time > start_time))
 			time_backwards++;
=2D
=2D		/* use 32 bit value to ensure compilation on 32 bit arches */
=2D		lowdelta =3D time2 - time;
=2D		if (!(lowdelta % 100))
=2D			count_mod++;
=2D
=2D		/*
=2D		 * ensure that we have a varying delta timer which is necessary
=2D		 * for the calculation of entropy -- perform this check
=2D		 * only after the first loop is executed as we need to prime
=2D		 * the old_data value
=2D		 */
=2D		if (delta > old_delta)
=2D			delta_sum +=3D (delta - old_delta);
=2D		else
=2D			delta_sum +=3D (old_delta - delta);
=2D		old_delta =3D delta;
 	}
=20
 	/*
@@ -752,31 +765,23 @@ int jent_entropy_init(void *hash_state)
 	 * should not fail. The value of 3 should cover the NTP case being
 	 * performed during our test run.
 	 */
=2D	if (time_backwards > 3)
=2D		return JENT_ENOMONOTONIC;
=2D
=2D	/*
=2D	 * Variations of deltas of time must on average be larger
=2D	 * than 1 to ensure the entropy estimation
=2D	 * implied with 1 is preserved
=2D	 */
=2D	if ((delta_sum) <=3D 1)
=2D		return JENT_EVARVAR;
+	if (time_backwards > 3) {
+		ret =3D JENT_ENOMONOTONIC;
+		goto out;
+	}
=20
=2D	/*
=2D	 * Ensure that we have variations in the time stamp below 10 for at
=2D	 * least 10% of all checks -- on some platforms, the counter increments
=2D	 * in multiples of 100, but not always
=2D	 */
=2D	if ((TESTLOOPCOUNT/10 * 9) < count_mod)
=2D		return JENT_ECOARSETIME;
+	/* Did we encounter a health test failure? */
+	if (jent_rct_failure(ec)) {
+		ret =3D JENT_ERCT;
+		goto out;
+	}
+	if (jent_apt_failure(ec)) {
+		ret =3D JENT_EHEALTH;
+		goto out;
+	}
=20
=2D	/*
=2D	 * If we have more than 90% stuck results, then this Jitter RNG is
=2D	 * likely to not work well.
=2D	 */
=2D	if ((TESTLOOPCOUNT/10 * 9) < count_stuck)
=2D		return JENT_ESTUCK;
+out:
+	jent_entropy_collector_free(ec);
=20
=2D	return 0;
+	return ret;
 }
diff --git a/crypto/jitterentropy.h b/crypto/jitterentropy.h
index 4c92176ea2b1..626c6228b7e2 100644
=2D-- a/crypto/jitterentropy.h
+++ b/crypto/jitterentropy.h
@@ -9,7 +9,8 @@ extern int jent_hash_time(void *hash_state, __u64 time, u8 =
*addtl,
 int jent_read_random_block(void *hash_state, char *dst, unsigned int dst_l=
en);
=20
 struct rand_data;
=2Dextern int jent_entropy_init(void *hash_state);
+extern int jent_entropy_init(unsigned int osr, unsigned int flags,
+			     void *hash_state);
 extern int jent_read_entropy(struct rand_data *ec, unsigned char *data,
 			     unsigned int len);
=20
=2D-=20
2.42.0




