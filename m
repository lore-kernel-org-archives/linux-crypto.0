Return-Path: <SRS0=6qCq=6B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F5DFC2D0EF
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 19:35:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C85F0214D8
	for <linux-crypto@archiver.kernel.org>; Fri, 17 Apr 2020 19:35:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="SigULMlc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730539AbgDQTfI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 Apr 2020 15:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728826AbgDQTfH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Apr 2020 15:35:07 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D6EC061A0F
        for <linux-crypto@vger.kernel.org>; Fri, 17 Apr 2020 12:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1587152104;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ASUP7/87F7kMdwtqVT+okEUZsYp7C8+VWYF3e+J3RLQ=;
        b=SigULMlclESlb6/CZMWr3P5CkKdNHpMuSPIKN/OBzvD2Z5TaSlC6t4ku4n1C+GlNmj
        q4KGdxKiOPoQ29uNTerNTUdhOF1wDivcw2ujdyaydNVEjWbPtYmn+CdSgipkQA2pXGKT
        ieI06dDSbBRpXaowILWS+ueSCSXV56taOlrV7O9OB2G4g7+oyM9r36fhxJM1bxLgZEMy
        Q8bpWhgDFSCfCRax2//eITZAe0TvRqUnd5zIB6ZPRFqwrI3M57qPBdo/WwtaEyspGP/O
        5yletHRDgJ3yjvRThgQFjXhx4Rt0olKs8gjCVN6WY2wZsg0TuA/MYTAPnlIry5fKe6k+
        R8Sw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJfSf//ci"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.5.0 DYNA|AUTH)
        with ESMTPSA id c09283w3HJZ33Aw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 17 Apr 2020 21:35:03 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH v2 2/2] crypto: DRBG always seeded with SP800-90B compliant noise source
Date:   Fri, 17 Apr 2020 21:34:03 +0200
Message-ID: <5758230.OPWXXBSBrc@positron.chronox.de>
In-Reply-To: <9339058.MEWKF1lRGI@positron.chronox.de>
References: <9339058.MEWKF1lRGI@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As the Jitter RNG provides an SP800-90B compliant noise source, use this
noise source always for the (re)seeding of the DRBG.

To make sure the DRBG is always properly seeded, the reseed threshold
is reduced to 1<<20 generate operations.

The Jitter RNG may report health test failures. Such health test
failures are treated as transient as follows. The DRBG will not reseed
from the Jitter RNG (but from get_random_bytes) in case of a health
test failure. Though, it produces the requested random number.

The Jitter RNG has a failure counter where at most 1024 consecutive
resets due to a health test failure are considered as a transient error.
If more consecutive resets are required, the Jitter RNG will return
a permanent error which is returned to the caller by the DRBG. With this
approach, the worst case reseed threshold is significantly lower than
mandated by SP800-90A in order to seed with an SP800-90B noise source:
the DRBG has a reseed threshold of 2^20 * 1024 = 2^30 generate requests.

Yet, in case of a transient Jitter RNG health test failure, the DRBG is
seeded with the data obtained from get_random_bytes.

However, if the Jitter RNG fails during the initial seeding operation
even due to a health test error, the DRBG will send an error to the
caller because at that time, the DRBG has received no seed that is
SP800-90B compliant.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c         | 26 +++++++++++++++++++-------
 include/crypto/drbg.h |  6 +-----
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index b6929eb5f565..e57901d8545b 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1087,10 +1087,6 @@ static void drbg_async_seed(struct work_struct *work)
 	if (ret)
 		goto unlock;
 
-	/* If nonblocking pool is initialized, deactivate Jitter RNG */
-	crypto_free_rng(drbg->jent);
-	drbg->jent = NULL;
-
 	/* Set seeded to false so that if __drbg_seed fails the
 	 * next generate call will trigger a reseed.
 	 */
@@ -1168,7 +1164,23 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 						   entropylen);
 			if (ret) {
 				pr_devel("DRBG: jent failed with %d\n", ret);
-				goto out;
+
+				/*
+				 * Do not treat the transient failure of the
+				 * Jitter RNG as an error that needs to be
+				 * reported. The combined number of the
+				 * maximum reseed threshold times the maximum
+				 * number of Jitter RNG transient errors is
+				 * less than the reseed threshold required by
+				 * SP800-90A allowing us to treat the
+				 * transient errors as such.
+				 *
+				 * However, we mandate that at least the first
+				 * seeding operation must succeed with the
+				 * Jitter RNG.
+				 */
+				if (!reseed || ret != -EAGAIN)
+					goto out;
 			}
 
 			drbg_string_fill(&data1, entropy, entropylen * 2);
@@ -1492,6 +1504,8 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
 	if (list_empty(&drbg->test_data.list))
 		return 0;
 
+	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
+
 	INIT_WORK(&drbg->seed_work, drbg_async_seed);
 
 	drbg->random_ready.owner = THIS_MODULE;
@@ -1512,8 +1526,6 @@ static int drbg_prepare_hrng(struct drbg_state *drbg)
 		return err;
 	}
 
-	drbg->jent = crypto_alloc_rng("jitterentropy_rng", 0, 0);
-
 	/*
 	 * Require frequent reseeds until the seed source is fully
 	 * initialized.
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index 8c9af21efce1..c4165126937e 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -184,11 +184,7 @@ static inline size_t drbg_max_addtl(struct drbg_state *drbg)
 static inline size_t drbg_max_requests(struct drbg_state *drbg)
 {
 	/* SP800-90A requires 2**48 maximum requests before reseeding */
-#if (__BITS_PER_LONG == 32)
-	return SIZE_MAX;
-#else
-	return (1UL<<48);
-#endif
+	return (1<<20);
 }
 
 /*
-- 
2.25.2




