From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 06/25] crypto: ansi_cprng - Make cont_test a bool
Date: Sun,  7 Dec 2014 07:26:14 -0500
Message-ID: <ce162d7f0ec81077828c7b2a56208730812eee91.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:19437 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753157AbaLGM1A (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:00 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This makes no difference to the generated code, but I like to use bool
where appropriate for documentation.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 2edac42e..730e0857 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -79,7 +79,7 @@ static void xor_vectors(unsigned char *in1, unsigned char *in2,
  * Returns DEFAULT_BLK_SZ bytes of random data per call
  * returns 0 if generation succeeded, <0 if something went wrong
  */
-static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
+static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 {
 	int i;
 	unsigned char tmp[DEFAULT_BLK_SZ];
@@ -155,7 +155,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 
 /* Our exported functions */
 static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
-				int do_cont_test)
+				bool do_cont_test)
 {
 	unsigned char *ptr = buf;
 	unsigned int byte_count = (unsigned int)nbytes;
@@ -322,7 +322,7 @@ static int cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 {
 	struct prng_context *prng = crypto_rng_ctx(tfm);
 
-	return get_prng_bytes(rdata, dlen, prng, 0);
+	return get_prng_bytes(rdata, dlen, prng, false);
 }
 
 /*
@@ -356,7 +356,7 @@ static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 {
 	struct prng_context *prng = crypto_rng_ctx(tfm);
 
-	return get_prng_bytes(rdata, dlen, prng, 1);
+	return get_prng_bytes(rdata, dlen, prng, true);
 }
 
 static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
@@ -380,7 +380,7 @@ static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 		goto out;
 
 	/* this primes our continuity test */
-	rc = get_prng_bytes(rdata, DEFAULT_BLK_SZ, prng, 0);
+	rc = get_prng_bytes(rdata, DEFAULT_BLK_SZ, prng, false);
 	prng->rand_data_valid = DEFAULT_BLK_SZ;
 
 out:
-- 
2.1.3
