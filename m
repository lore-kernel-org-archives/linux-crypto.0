From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 09/17] crypto: ansi_cprng - Clean up some variable types
Date: 2 Dec 2014 03:50:51 -0500
Message-ID: <20141202085051.18958.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:36490 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750891AbaLBIux (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:50:53 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Add a few const annotations, use unsigned bytes consistently, and
make do_cont_test a bool.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index dff27a7a..6723a561 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -82,7 +82,7 @@ static void xor_block(unsigned char const *in, unsigned char *out)
  * Returns DEFAULT_BLK_SZ bytes of random data per call
  * returns 0 if generation succeeded, <0 if something went wrong
  */
-static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
+static int _get_more_prng_bytes(struct prng_context *ctx, bool cont_test)
 {
 	int i;
 	unsigned char tmp[DEFAULT_BLK_SZ];
@@ -176,8 +176,8 @@ static int _get_more_prng_bytes(struct prng_context *ctx, int cont_test)
 }
 
 /* Our exported functions */
-static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx,
-				int do_cont_test)
+static int get_prng_bytes(unsigned char *buf, unsigned int nbytes,
+				struct prng_context *ctx, bool do_cont_test)
 {
 	unsigned char *ptr = buf;
 	unsigned int byte_count = (unsigned int)nbytes;
@@ -312,7 +312,7 @@ static int cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 {
 	struct prng_context *prng = crypto_rng_ctx(tfm);
 
-	return get_prng_bytes(rdata, dlen, prng, 0);
+	return get_prng_bytes(rdata, dlen, prng, false);
 }
 
 /*
@@ -324,8 +324,8 @@ static int cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 static int cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 {
 	struct prng_context *prng = crypto_rng_ctx(tfm);
-	u8 *key = seed + DEFAULT_BLK_SZ;
-	u8 *dt = NULL;
+	u8 const *key = seed + DEFAULT_BLK_SZ;
+	u8 const *dt = NULL;
 
 	if (slen < DEFAULT_PRNG_KSZ + DEFAULT_BLK_SZ)
 		return -EINVAL;
@@ -346,13 +346,13 @@ static int fips_cprng_get_random(struct crypto_rng *tfm, u8 *rdata,
 {
 	struct prng_context *prng = crypto_rng_ctx(tfm);
 
-	return get_prng_bytes(rdata, dlen, prng, 1);
+	return get_prng_bytes(rdata, dlen, prng, true);
 }
 
 static int fips_cprng_reset(struct crypto_rng *tfm, u8 *seed, unsigned int slen)
 {
 	u8 rdata[DEFAULT_BLK_SZ];
-	u8 *key = seed + DEFAULT_BLK_SZ;
+	u8 const *key = seed + DEFAULT_BLK_SZ;
 	int rc;
 
 	struct prng_context *prng = crypto_rng_ctx(tfm);
-- 
2.1.3
