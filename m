Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A59CC4743C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 12:18:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7CC106100A
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jun 2021 12:18:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhFWMUp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jun 2021 08:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbhFWMUp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jun 2021 08:20:45 -0400
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Jun 2021 05:18:27 PDT
Received: from smtp-bc0b.mail.infomaniak.ch (smtp-bc0b.mail.infomaniak.ch [IPv6:2001:1600:3:17::bc0b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6F7C061574
        for <linux-crypto@vger.kernel.org>; Wed, 23 Jun 2021 05:18:27 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4G92934tY5zMqKM9;
        Wed, 23 Jun 2021 14:08:23 +0200 (CEST)
Received: from localhost (unknown [23.97.221.149])
        by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4G92923gCQzlh8Tm;
        Wed, 23 Jun 2021 14:08:22 +0200 (CEST)
From:   =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        James Morris <jamorris@linux.microsoft.com>,
        John Haxby <john.haxby@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Simo Sorce <simo@redhat.com>,
        =?UTF-8?q?Stephan=20M=C3=BCller?= <smueller@chronox.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH v1] crypto: Make the DRBG compliant with NIST SP800-90A rev1
Date:   Wed, 23 Jun 2021 14:07:51 +0200
Message-Id: <20210623120751.3033390-1-mic@digikod.net>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Mickaël Salaün <mic@linux.microsoft.com>

Starting from November 2020, the first revision of NIST SP800-90A (June
2015) is required for FIPS 140-2.  One of the changes brought by this
first revision is that nonces used for seeding (instantiation) and
re-seeding must come from entropy sources compliant with NIST SP800-90B
(cf. NIST SP800-90A rev1, section 8.6.7).  However, this seeding is
currently done with the Linux RNG (i.e. in-kernel /dev/urandom) that
uses ChaCha20, a non-approved algorithm.
Cf. https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-90Ar1.pdf

These changes replace the use of the Linux RNG with the Jitter RNG,
which is NIST SP800-90B compliant, to get a proper entropy input and a
nonce as defined by FIPS.

However, only using the Jitter RNG may not provide adequate security as
it could be possible for an attacker to know the state of the CPU and
predict this RNG output.  To avoid this threat, we are making this both
FIPS compliant and secure thanks to the use of Linux RNG as a random
source (but not entropy per se) for the personalization string
(instantiation) and the additional input (re-seeding).  These extra
inputs have a length equal to the DRBG strength.  The original
user-supplied personalization string and additional input are still used
but potentially truncated to fit with the 2**35 limit (cf. NIST
SP800-90A rev1, table 2 and 3).

This new DRBG uses the same random and entropy sources as the current
version but in a way that makes is compliant with FIPS 140-2.

Cc: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: James Morris <jamorris@linux.microsoft.com>
Cc: John Haxby <john.haxby@oracle.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Simo Sorce <simo@redhat.com>
Cc: Stephan Müller <smueller@chronox.de>
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Link: https://lore.kernel.org/r/20210623120751.3033390-1-mic@digikod.net
---

Do you prefer to truncate the user-supplied personalization string and
the additional input, or to return an error if they are greater than
2**27 (instead of 2**35)?

Another solution to avoid truncating the personalization string and the
additional input would be to hash them with SHA-512 and concatenate the
resulting fixed-size buffers.
---
 crypto/drbg.c         | 77 ++++++++++++++++++++++++++++++++-----------
 include/crypto/drbg.h |  2 +-
 2 files changed, 58 insertions(+), 21 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1b4587e0ddad..b817a831815e 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -1119,9 +1119,10 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		     bool reseed)
 {
 	int ret;
-	unsigned char entropy[((32 + 16) * 2)];
-	unsigned int entropylen = drbg_sec_strength(drbg->core->flags);
-	struct drbg_string data1;
+	unsigned char entropy[((32 * 2) + 16)];
+	const unsigned int strength = drbg_sec_strength(drbg->core->flags);
+	unsigned int entropylen = strength;
+	struct drbg_string data1, data2;
 	LIST_HEAD(seedlist);
 
 	/* 9.1 / 9.2 / 9.3.1 step 3 */
@@ -1147,21 +1148,32 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		BUG_ON(!entropylen);
 		if (!reseed)
 			entropylen = ((entropylen + 1) / 2) * 3;
-		BUG_ON((entropylen * 2) > sizeof(entropy));
-
-		/* Get seed from in-kernel /dev/urandom */
-		ret = drbg_get_random_bytes(drbg, entropy, entropylen);
-		if (ret)
-			goto out;
+		/*
+		 * Check that a minimal automatic personalization string
+		 * (instantiation) or additional input (re-seeding) of strength
+		 * length fits in.
+		 */
+		BUG_ON((entropylen + strength) > sizeof(entropy));
 
 		if (!drbg->jent) {
-			drbg_string_fill(&data1, entropy, entropylen);
-			pr_devel("DRBG: (re)seeding with %u bytes of entropy\n",
-				 entropylen);
+			/*
+			 * Get entropy, nonce, personalization string or
+			 * additional input from in-kernel /dev/urandom
+			 */
+			ret = drbg_get_random_bytes(drbg, entropy, entropylen + strength);
+			if (ret)
+				goto out;
+
+			drbg_string_fill(&data1, entropy, entropylen + strength);
+			pr_devel("DRBG: (re)seeding with %u bytes of random\n",
+				 entropylen + strength);
 		} else {
-			/* Get seed from Jitter RNG */
-			ret = crypto_rng_get_bytes(drbg->jent,
-						   entropy + entropylen,
+			/*
+			 * Get entropy (strength length), concatenated with a
+			 * nonce (half strength length) when instantiating,
+			 * both from the SP800-90B compliant Jitter RNG.
+			 */
+			ret = crypto_rng_get_bytes(drbg->jent, entropy,
 						   entropylen);
 			if (ret) {
 				pr_devel("DRBG: jent failed with %d\n", ret);
@@ -1184,9 +1196,25 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 					goto out;
 			}
 
-			drbg_string_fill(&data1, entropy, entropylen * 2);
-			pr_devel("DRBG: (re)seeding with %u bytes of entropy\n",
-				 entropylen * 2);
+			/*
+			 * To improve security while still be compliant with
+			 * SP800-90A rev1, automatically append a minimal
+			 * personalization string (instantiation) or additional
+			 * input (re-seeding) of strength length from in-kernel
+			 * /dev/urandom (random source).  This may then replace
+			 * a (small) part of the supplied pers according to
+			 * drbg_max_addtl().
+			 */
+			ret = drbg_get_random_bytes(drbg, entropy + entropylen,
+						    strength);
+			if (ret)
+				goto out;
+
+			drbg_string_fill(&data1, entropy, entropylen + strength);
+
+			pr_devel("DRBG: (re)seeding with %u bytes of entropy "
+				 "and %u bytes of random\n", entropylen,
+				 strength);
 		}
 	}
 	list_add_tail(&data1.list, &seedlist);
@@ -1197,7 +1225,16 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	 * contents whether it is appropriate
 	 */
 	if (pers && pers->buf && 0 < pers->len) {
-		list_add_tail(&pers->list, &seedlist);
+		const size_t available = drbg_max_addtl(drbg) - pers->len;
+
+		data2 = *pers;
+		/*
+		 * Make sure that the drbg_max_addtl() limit is still respected
+		 * according to the automatically appended random values.
+		 */
+		if (available < strength)
+			data2.len -= strength - available;
+		list_add_tail(&data2.list, &seedlist);
 		pr_devel("DRBG: using personalization string\n");
 	}
 
@@ -1209,7 +1246,7 @@ static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 	ret = __drbg_seed(drbg, &seedlist, reseed);
 
 out:
-	memzero_explicit(entropy, entropylen * 2);
+	memzero_explicit(entropy, sizeof(entropy));
 
 	return ret;
 }
diff --git a/include/crypto/drbg.h b/include/crypto/drbg.h
index c4165126937e..7fcff8d2289e 100644
--- a/include/crypto/drbg.h
+++ b/include/crypto/drbg.h
@@ -168,7 +168,7 @@ static inline size_t drbg_max_request_bytes(struct drbg_state *drbg)
 
 static inline size_t drbg_max_addtl(struct drbg_state *drbg)
 {
-	/* SP800-90A requires 2**35 bytes additional info str / pers str */
+	/* SP800-90A requires 2**35 bits of additional info str / pers str */
 #if (__BITS_PER_LONG == 32)
 	/*
 	 * SP800-90A allows smaller maximum numbers to be returned -- we

base-commit: 13311e74253fe64329390df80bed3f07314ddd61
-- 
2.32.0

