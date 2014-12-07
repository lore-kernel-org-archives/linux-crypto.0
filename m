From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 12/25] crypto: ansi_cprng - Get rid of rdata buffer in fips_cprng_reset
Date: Sun,  7 Dec 2014 07:26:20 -0500
Message-ID: <76ba26d25b868553da29728fd6277e10a4587c26.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:55403 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753147AbaLGM1E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:04 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Calling the lower-level function does what's needed with less overhead.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index f6a1e987..249b944f 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -329,7 +329,6 @@ static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 
 static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 {
-	u8 rdata[DEFAULT_BLK_SZ];
 	u8 *key = seed + DEFAULT_BLK_SZ;
 	int rc;
 
@@ -348,7 +347,7 @@ static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 		goto out;
 
 	/* this primes our continuity test */
-	rc = get_prng_bytes(rdata, DEFAULT_BLK_SZ, prng, false);
+	rc = _get_more_prng_bytes(prng, false);
 	prng->rand_data_valid = DEFAULT_BLK_SZ;
 
 out:
-- 
2.1.3
