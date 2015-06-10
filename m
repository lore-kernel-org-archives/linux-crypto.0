From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH v2] crypto: drbg - reseed often if seedsource is degraded
Date: Wed, 10 Jun 2015 03:33:37 +0200
Message-ID: <1734010.LdNLRSju42@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: andreas.steffen@strongswan.org, Ted Tso <tytso@mit.edu>,
	sandyinchina@gmail.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46190 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751475AbbFJCdR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Jun 2015 22:33:17 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Changes v2: 
* port the patch to current cryptodev tree plus the async seeding DRBG patches

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
 crypto/drbg.c         | 12 +++++++++++-
 include/crypto/drbg.h |  1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index c6cbf13..5fad297 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1088,6 +1088,9 @@ static void drbg_async_seed(struct work_struct *work)
 
 	__drbg_seed(drbg, &seedlist, true);
 
+	if (drbg->seeded)
+		drbg->reseed_threshold = drbg_max_requests(drbg);
+
 	mutex_unlock(&drbg->drbg_mutex);
 
 	memzero_explicit(entropy, entropylen);
@@ -1334,7 +1337,7 @@ static int drbg_generate(struct drbg_state *drbg,
 	 * 9.3.1 step 6 and 9 supplemented by 9.3.2 step c is implemented
 	 * here. The spec is a bit convoluted here, we make it simpler.
 	 */
-	if ((drbg_max_requests(drbg)) < drbg->reseed_ctr)
+	if (drbg->reseed_threshold < drbg->reseed_ctr)
 		drbg->seeded = false;
 
 	if (drbg->pr || !drbg->seeded) {
@@ -1478,6 +1481,12 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
 
 	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
 
+	/*
+	 * Require frequent reseeds until the seed source is fully
+	 * initialized.
+	 */
+	drbg->reseed_threshold = 50;
+
 	return err;
 }
 
@@ -1522,6 +1531,7 @@ static int drbg_instantiate(struct drbg_state *drbg, struct drbg_string *pers,
 		drbg->core = &drbg_cores[coreref];
 		drbg->pr = pr;
 		drbg->seeded = false;
+		drbg->reseed_threshold = drbg_max_requests(drbg);
 
 		ret = drbg_alloc_state(drbg);
 		if (ret)
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index fad6450..9756c70 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -111,6 +111,7 @@ struct drbg_state {
 	unsigned char *C;
 	/* Number of RNG requests since last reseed -- 10.1.1.1 1c) */
 	size_t reseed_ctr;
+	size_t reseed_threshold;
 	 /* some memory the DRBG can use for its operation */
 	unsigned char *scratchpad;
 	void *priv_data;	/* Cipher handle */
-- 
2.4.2
