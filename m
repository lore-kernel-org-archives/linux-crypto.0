From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH RFC] crypto: drbg - lower reseed threshold if seed source is degraded
Date: Sun, 07 Jun 2015 00:04:17 +0200
Message-ID: <1546948.ChzZZVGUza@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, andreas.steffen@strongswan.org,
	Ted Tso <tytso@mit.edu>, sandyinchina@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46100 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbbFFWFD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 6 Jun 2015 18:05:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

may I ask for review of the following patch. I would like particular feedback
to the initial threshold value, which the patch currently sets to 50 (requests
by a caller to the DRBG for random numbers). Thank you.

I am not sure about this value because there are two conflicting issues
revolving around this value:

1. We have to ensure that the DRBG has a sufficiently entropic internal state.
That would mean, I should set that value as low as possible.

2. This is the more problematic one: when considering information theory, if
you draw from a DRNG (which the nonblocking pool is in the worst case -- and
the boot time discussed below is our worst case) that is not fully seeded, you
reduce the entropy in that DRNG (contrary to conventional wisdom). For the
discussion, let us assume the worst case that there is coming in one bit of
entropy at a time into the discussed DRNG. In between the addition of each bit
of entropy, an attacker can access the DRNG (i.e. the SHA1 output of the
nonblocking_pool). When only one bit of entropy is added to the
nonblocking_pool, the attack complexity would be 1 bit. When an attacker would
access the nonblocking_pool after each received bit, in the worst case, the
attack complexity is not 2**128 but rather 256 (i.e. 1 bit for each individual
attack between the addition of one new bit of entropy). So, the total attack
complexity is the sum of the individual attack complexities (i.e. the
complexity added after the previous attack is performed). This issue is
aggravated by the nonblocking pool as the entropy counter used for declaring
that the threshold defining the that nonblocking pool is initialized is never
decreased by requests, but only increased. So, with that issue in mind, we
want to set the reseed threshold of the DRBG to rather a higher level.

Thus I am struggling to find the right(TM) initial value for the reseeding
threshold.

Or maybe you can tell me that there is no need for the patch to begin with as
the initial seed plus the async request to the nonblocking pool is good as is.
:-)

Note, this patch is on top of the patch updating the async reseeding sent out 
yesterday.

---8<---
As required by SP800-90A, the DRBG implements are reseeding threshold.
This threshold is at 2**48 (64 bit) and 2**32 bit (32 bit) as
implemented in drbg_max_requests.

With the recently introduced changes, the DRBG is now always used as a
stdrng which is initialized very early in the boot cycle. To ensure that
sufficient entropy is present, the Jitter RNG is added to even provide
entropy at early boot time.

However, the 2nd seed source, the nonblocking pool, is usually
degraded at that time. Therefore, the DRBG is seeded with the Jitter RNG
(which I believe contains good entropy, which however is questioned by
others) and is seeded with a degradded nonblocking pool. This seed is
now used for quasi the lifetime of the system (2**48 requests is a lot).

The patch now changes the reseed threshold as follows: up until the time
the DRBG obtains a seed from a fully iniitialized nonblocking pool, the
reseeding threshold is lowered such that the DRBG is forced to reseed
itself resonably often. Once it obtains the seed from a fully
initialized nonblocking pool, the reseed threshold is set to the value
required by SP800-90A.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 35 ++++++++++++++++++++++++++---------
 include/crypto/drbg.h |  1 +
 2 files changed, 27 insertions(+), 9 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 3fed67e..0ea4d3c 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1075,10 +1075,16 @@ static void drbg_async_seed(void *private)
 	mutex_lock(&drbg->drbg_mutex);
 	ret = __drbg_seed(drbg, &seedlist, true);
 
-	/* If nonblocking pool is initialized, deactivate Jitter RNG */
-	if (!ret && drbg->jent) {
-		crypto_free_rng(drbg->jent);
-		drbg->jent = NULL;
+	/*
+	 * If nonblocking pool is initialized: set reseeding threshold to
+	 * regular threshold and deactivate Jitter RNG.
+	 */
+	if (!ret) {
+		drbg->reseed_threshold = drbg_max_requests(drbg);
+		if (drbg->jent) {
+			crypto_free_rng(drbg->jent);
+			drbg->jent = NULL;
+		}
 	}
 	memzero_explicit(entropy, entropylen);
 	mutex_unlock(&drbg->drbg_mutex);
@@ -1157,10 +1163,16 @@ static int drbg_seed(struct drbg_state *drbg, struct 
drbg_string *pers,
 				 entropylen * 2);
 		}
 
-		/* If nonblocking pool is initialized, deactivate Jitter RNG 
*/
-		if (!ret && drbg->jent) {
-			crypto_free_rng(drbg->jent);
-			drbg->jent = NULL;
+		/*
+		 * If nonblocking pool is initialized: set reseeding threshold
+		 * to regular threshold and deactivate Jitter RNG.
+		 */
+		if (!ret) {
+			drbg->reseed_threshold = drbg_max_requests(drbg);
+			if (drbg->jent) {
+				crypto_free_rng(drbg->jent);
+				drbg->jent = NULL;
+			}
 		}
 	}
 	list_add_tail(&data1.list, &seedlist);
@@ -1357,7 +1369,7 @@ static int drbg_generate(struct drbg_state *drbg,
 	 * 9.3.1 step 6 and 9 supplemented by 9.3.2 step c is implemented
 	 * here. The spec is a bit convoluted here, we make it simpler.
 	 */
-	if ((drbg_max_requests(drbg)) < drbg->reseed_ctr)
+	if (drbg->reseed_threshold < drbg->reseed_ctr)
 		drbg->seeded = false;
 
 	if (drbg->pr || !drbg->seeded) {
@@ -1504,6 +1516,11 @@ static int drbg_instantiate(struct drbg_state *drbg, 
struct drbg_string *pers,
 		drbg->core = &drbg_cores[coreref];
 		drbg->pr = pr;
 		drbg->seeded = false;
+		/*
+		 * Require frequent reseeds until the seed source is fully
+		 * initialized.
+		 */
+		drbg->reseed_threshold = 50;
 
 		ret = drbg_alloc_state(drbg);
 		if (ret)
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index e2c9530..6d83fff 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -110,6 +110,7 @@ struct drbg_state {
 	unsigned char *C;
 	/* Number of RNG requests since last reseed -- 10.1.1.1 1c) */
 	size_t reseed_ctr;
+	size_t reseed_threshold;
 	 /* some memory the DRBG can use for its operation */
 	unsigned char *scratchpad;
 	void *priv_data;	/* Cipher handle */
-- 
2.4.2
