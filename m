Return-Path: <SRS0=LfhG=TD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 509CBC43219
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 19:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71109206BB
	for <linux-crypto@archiver.kernel.org>; Fri,  3 May 2019 19:59:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="SiInVzNt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbfECT7E (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 3 May 2019 15:59:04 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([85.215.255.22]:27547 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbfECT7E (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 May 2019 15:59:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1556913536;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=b2nOT0fgJ+QuKu5qvFdY18oqsXt7rOxVRuaFY2oECBI=;
        b=SiInVzNt8as6JrGUnD2ueH6DzhpjMJFXyNl/57+wblXi3Lz+p1y5OqSjkSElQUVV7p
        z5rc3b6PcvVNuBVXxYWE8X1QgIZbjcT/cOTbqmiiXyEs2T1YwWLpwBmT7Qcu5xft1nR+
        MlnoN31lxKtQ+E1Ga9XI6dMCJMwWttHvLhaIJjjfEdP4+LP6CibQjI+lEIuJwn+7f7l1
        xEneLH0cEt17FEC7CmY69Y+lo7EgE/jnlTZHTO3IPoGd49zOQsvZamzanN0uAzLOiOyy
        Wt2AB3YSt4d3Xn0ao1XurQa3tLDAcdB1d90e8Z9kzAqePkwySfAWKk5asg/ouWuMogiI
        Tyyw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSd/cc="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv43JwtprR
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 3 May 2019 21:58:55 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH v4] crypto: DRBG - add FIPS 140-2 CTRNG for noise source
Date:   Fri, 03 May 2019 21:58:54 +0200
Message-ID: <1978979.Zxv6YQyJUk@positron.chronox.de>
In-Reply-To: <20190503014241.cy35pjinezhapga7@gondor.apana.org.au>
References: <1852500.fyBc0DU23F@positron.chronox.de> <5352150.0CmBXKFm2E@positron.chronox.de> <20190503014241.cy35pjinezhapga7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Changes v4:
 * use if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) and compile CTRNG variables
   unconditionally

---8<---

FIPS 140-2 section 4.9.2 requires a continuous self test of the noise
source. Up to kernel 4.8 drivers/char/random.c provided this continuous
self test. Afterwards it was moved to a location that is inconsistent
with the FIPS 140-2 requirements.

Thus, the FIPS 140-2 CTRNG is added to the DRBG when it obtains the
seed. This patch resurrects the function drbg_fips_continous_test that
existed some time ago and applies it to the noise sources.

The Jitter RNG implements its own FIPS 140-2 self test and thus does not
need to be subjected to the test in the DRBG.

The patch contains a tiny fix to ensure proper zeroization in case of an
error during the Jitter RNG data gathering.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 84 +++++++++++++++++++++++++++++++++++++++++--
 include/crypto/drbg.h |  2 ++
 2 files changed, 83 insertions(+), 3 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 2a5b16bb000c..8328d7d9b42e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -219,6 +219,57 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
 	}
 }
 
+/*
+ * FIPS 140-2 continuous self test for the noise source
+ * The test is performed on the noise source input data. Thus, the function
+ * implicitly knows the size of the buffer to be equal to the security
+ * strength.
+ *
+ * Note, this function disregards the nonce trailing the entropy data during
+ * initial seeding.
+ *
+ * drbg->drbg_mutex must have been taken.
+ *
+ * @drbg DRBG handle
+ * @entropy buffer of seed data to be checked
+ *
+ * return:
+ *	0 on success
+ *	-EAGAIN on when the CTRNG is not yet primed
+ *	< 0 on error
+ */
+static int drbg_fips_continuous_test(struct drbg_state *drbg,
+				     const unsigned char *entropy)
+{
+	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
+		unsigned short entropylen = drbg_sec_strength(drbg->core->flags);
+		int ret = 0;
+
+		/* skip test if we test the overall system */
+		if (list_empty(&drbg->test_data.list))
+			return 0;
+		/* only perform test in FIPS mode */
+		if (!fips_enabled)
+			return 0;
+
+		if (!drbg->fips_primed) {
+			/* Priming of FIPS test */
+			memcpy(drbg->prev, entropy, entropylen);
+			drbg->fips_primed = true;
+			/* priming: another round is needed */
+			return -EAGAIN;
+		}
+		ret = memcmp(drbg->prev, entropy, entropylen);
+		if (!ret)
+			panic("DRBG continuous self test failed\n");
+		memcpy(drbg->prev, entropy, entropylen);
+		/* the test shall pass when the two values are not equal */
+		return (ret != 0) ? 0 : -EFAULT;
+	} else {
+		return 0;
+	}
+}
+
 /*
  * Convert an integer into a byte representation of this integer.
  * The byte representation is big-endian
@@ -1006,16 +1057,23 @@ static void drbg_async_seed(struct work_struct *work)
 					       seed_work);
 	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
 	unsigned char entropy[32];
+	int ret;
 
 	BUG_ON(!entropylen);
 	BUG_ON(entropylen > sizeof(entropy));
-	get_random_bytes(entropy, entropylen);
 
 	drbg_string_fill(&data, entropy, entropylen);
 	list_add_tail(&data.list, &seedlist);
 
 	mutex_lock(&drbg->drbg_mutex);
 
+	do {
+		get_random_bytes(entropy, entropylen);
+		ret = drbg_fips_continuous_test(drbg, entropy);
+		if (ret && ret != -EAGAIN)
+			goto unlock;
+	} while (ret);
+
 	/* If nonblocking pool is initialized, deactivate Jitter RNG */
 	crypto_free_rng(drbg->jent);
 	drbg->jent = NULL;
@@ -1030,6 +1088,7 @@ static void drbg_async_seed(struct work_struct *work)
 	if (drbg->seeded)
 		drbg->reseed_threshold = drbg_max_requests(drbg);
 
+unlock:
 	mutex_unlock(&drbg->drbg_mutex);
 
 	memzero_explicit(entropy, entropylen);
@@ -1081,7 +1140,12 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		BUG_ON((entropylen * 2) > sizeof(entropy));
 
 		/* Get seed from in-kernel /dev/urandom */
-		get_random_bytes(entropy, entropylen);
+		do {
+			get_random_bytes(entropy, entropylen);
+			ret = drbg_fips_continuous_test(drbg, entropy);
+			if (ret && ret != -EAGAIN)
+				goto out;
+		} while (ret);
 
 		if (!drbg->jent) {
 			drbg_string_fill(&data1, entropy, entropylen);
@@ -1094,7 +1158,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 						   entropylen);
 			if (ret) {
 				pr_devel("DRBG: jent failed with %d\n", ret);
-				return ret;
+				goto out;
 			}
 
 			drbg_string_fill(&data1, entropy, entropylen * 2);
@@ -1121,6 +1185,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 
 	ret = __drbg_seed(drbg, &seedlist, reseed);
 
+out:
 	memzero_explicit(entropy, entropylen * 2);
 
 	return ret;
@@ -1142,6 +1207,11 @@ static inline void drbg_dealloc_state(struct drbg_state *drbg)
 	drbg->reseed_ctr = 0;
 	drbg->d_ops = NULL;
 	drbg->core = NULL;
+	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
+		kzfree(drbg->prev);
+		drbg->prev = NULL;
+		drbg->fips_primed = false;
+	}
 }
 
 /*
@@ -1211,6 +1281,14 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 		drbg->scratchpad = PTR_ALIGN(drbg->scratchpadbuf, ret + 1);
 	}
 
+	if (IS_ENABLED(CONFIG_CRYPTO_FIPS)) {
+		drbg->prev = kzalloc(drbg_sec_strength(drbg->core->flags),
+				     GFP_KERNEL);
+		if (!drbg->prev)
+			goto fini;
+		drbg->fips_primed = false;
+	}
+
 	return 0;
 
 fini:
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 3fb581bf3b87..8c9af21efce1 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -129,6 +129,8 @@ struct drbg_state {
 
 	bool seeded;		/* DRBG fully seeded? */
 	bool pr;		/* Prediction resistance enabled? */
+	bool fips_primed;	/* Continuous test primed? */
+	unsigned char *prev;	/* FIPS 140-2 continuous test value */
 	struct work_struct seed_work;	/* asynchronous seeding support */
 	struct crypto_rng *jent;
 	const struct drbg_state_ops *d_ops;
-- 
2.21.0




