From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 17/17] crypto: ansi_cprng - Shrink default seed size
Date: 2 Dec 2014 04:02:01 -0500
Message-ID: <20141202090201.19813.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:18790 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750927AbaLBJCC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 04:02:02 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The larger seed with deterministic DT is still supported, but make the
default non-deterministically random, with fresh DT.

This must come after the patch that makes testmgr.c not depend on
the default seedsize to allocate its buffers, since it tests the
non-default (larger seed) case.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Patch 15 is a prerequisite for this one.

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 4ed7c0cf..875c4bf9 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -390,7 +390,7 @@ static struct crypto_alg rng_algs[] = { {
 		.rng = {
 			.rng_make_random	= cprng_get_random,
 			.rng_reset		= cprng_reset,
-			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
+			.seedsize = DEFAULT_BLK_SZ + DEFAULT_PRNG_KSZ
 		}
 	}
 #ifdef CONFIG_CRYPTO_FIPS
@@ -408,7 +408,7 @@ static struct crypto_alg rng_algs[] = { {
 		.rng = {
 			.rng_make_random	= fips_cprng_get_random,
 			.rng_reset		= fips_cprng_reset,
-			.seedsize = DEFAULT_PRNG_KSZ + 2*DEFAULT_BLK_SZ,
+			.seedsize = DEFAULT_BLK_SZ + DEFAULT_PRNG_KSZ
 		}
 	}
 #endif
-- 
2.1.3
