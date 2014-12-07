From: George Spelvin <linux@horizon.com>
Subject: [PATCH v2 18/25] crypto: testmgr - Add CPRNG stutter test.
Date: Sun,  7 Dec 2014 07:26:26 -0500
Message-ID: <cc79d229013770c762886e1d3098656216fb9f83.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Cc: smueller@chronox.de, herbert@gondor.apana.org.au, linux@horizon.com
To: nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:26842 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753173AbaLGM1C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 7 Dec 2014 07:27:02 -0500
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
In-Reply-To: <cover.1417951990.git.linux@horizon.com>
References: <cover.1417951990.git.linux@horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a test for the kind of bug that caused CVE-2013-4345,
which was in the code that adapted from fixed-size cipher blocks
to arbitrary-sized reads.

This does every known answer test twice: the first time using
block-aligned reads (assuming the known answer is a full block),
and a second time using reads of size 0, 1, 2, ... 61, 0, 1, ...

A simple 32-bit hash of all of the output bytes (not just the known
ones) is compared between the two.  Any error in the bookkeeping
will result in a mismatch.

A non-cryptographic hash suffices to detect coding errors.
We just need something better than an additive checksum, because
transposition is possible.

The maximum read size (61) is chosen so the pattern repeats
after 1891 = 31 * 61 bytes.  If this is relatively prime to the
CPRNG's internal buffer size, a long enough test will eventually
explore every possible read size at every possible alignment in
the CPRNG's internal buffer.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/testmgr.c | 98 ++++++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 89 insertions(+), 9 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6bf43682..a15860ad 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1455,11 +1455,15 @@ static int test_cprng(struct crypto_rng *tfm,
 		      const struct cprng_testvec *template, unsigned int tcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
-	int err = 0, i, j;
-	u8 result[32];
+	int err = 0, i;
 
 	for (i = 0; i < tcount; i++) {
-		if (template[i].rlen > sizeof(result)) {
+		int j, k, bytes;
+		u32 hash1 = 0, hash2 = 0;
+		u8 result[61];		/* See below for size advice */
+		int rlen = template[i].rlen;
+
+		if (rlen > sizeof(result)) {
 			printk(KERN_CRIT "alg: cprng: Cannot test %s\n", algo);
 			err = -EOVERFLOW;
 			break;
@@ -1468,33 +1472,109 @@ static int test_cprng(struct crypto_rng *tfm,
 
 		err = crypto_rng_reset(tfm, template[i].seed, template[i].slen);
 		if (err) {
+fail_reset:
 			printk(KERN_ERR "alg: cprng: Failed to reset rng "
 			       "for %s\n", algo);
 			break;
 		}
 
 		for (j = 0; j < template[i].loops; j++) {
-			err = crypto_rng_get_bytes(tfm, result,
-						   template[i].rlen);
-			if (err != template[i].rlen) {
+			err = crypto_rng_get_bytes(tfm, result, rlen);
+			if (err != rlen) {
+fail_get:
 				printk(KERN_ERR "alg: cprng: Failed to obtain "
 				       "the correct amount of random data for "
 				       "%s (requested %d, got %d)\n", algo,
-				       template[i].rlen, err);
+				       rlen, err);
 				if (err >= 0)
 					err = -EINVAL;
 				break;
 			}
+			/* Compute simple hash for use by stutter test */
+			for (k = 0; k < rlen; k++) {
+				hash1 += result[k];
+				hash1 += hash1 << 10;
+				hash1 ^= hash1 >> 6;
+			}
 		}
 
-		err = memcmp(result, template[i].result, template[i].rlen);
+		err = memcmp(result, template[i].result, rlen);
 		if (err) {
 			printk(KERN_ERR "alg: cprng: Test %d failed for %s\n",
 			       i, algo);
-			hexdump(result, template[i].rlen);
+			hexdump(result, rlen);
 			err = -EINVAL;
 			break;
 		}
+
+		/*
+		 * Stutter test: repeat the computation, using odd-sized
+		 * reads.  This is to verify the output deblocking code,
+		 * which was the source of CVE-2013-4345.  So we read
+		 * from the RNG in 0, 1, 2, 3, 4, 5, ... byte chunks.
+		 *
+		 * When the read size reaches the size of our buffer,
+		 * the read size starts back at 0.
+		 *
+		 * For the current buffer size of 61, that happens after
+		 * 1891 = 31 * 61 bytes.  If this is relatively prime to
+		 * the CPRNG's internal state size, this will, if the test
+		 * is long enough, do every possible read size starting
+		 * at every possible offset in the CPRNG's internal state.
+		 *
+		 * The basic requirement to produce an odd total that
+		 * will be relatively prime to power-of-two state sizes
+		 * is that it be congruent to 1 or 2 mod 4.
+		 *
+		 * If you want to worry about larger factors, try:
+		 *  13:    91 =  7 * 13     73:  2701 = 37 * 73
+		 *  22:   253 = 11 * 23     82:  3403 = 41 * 83
+		 *  46:  1081 = 23 * 47    106:  5671 = 53 * 107
+		 *  58:  1711 = 29 * 59    157: 12403 = 79 * 157
+		 *  61:  1891 = 31 * 61    166: 13861 = 83 * 167
+		 *
+		 * The complete output streams are compared using a
+		 * non-cryptographic hash over the output bytes, which
+		 * is sufficient for the class of errors this is designed
+		 * to detect.
+		 */
+		err = crypto_rng_reset(tfm, template[i].seed, template[i].slen);
+		if (err)
+			goto fail_reset;
+
+		bytes = template[i].rlen * template[i].loops;
+		rlen = 0;
+		for (rlen = 0; ; rlen++) {
+			if (rlen > sizeof(result)) {
+				rlen = 0;
+			} else if (rlen > bytes) {
+				if (!bytes)
+					break;
+				rlen = bytes;
+			}
+			bytes -= rlen;
+			err = crypto_rng_get_bytes(tfm, result, rlen);
+			if (err != rlen)
+				goto fail_get;
+			/*
+			 * This is Bob Jenkins' one-at-a-time hash.
+			 * We just want something simple, byte-at-a-time,
+			 * and sensitive to transpositions, which a plain
+			 * additive checksum isn't.
+			 */
+			for (k = 0; k < rlen; k++) {
+				hash2 += result[k];
+				hash2 += hash2 << 10;
+				hash2 ^= hash2 >> 6;
+			}
+		}
+		if (hash1 != hash2) {
+			printk(KERN_ERR "alg: cprng: Stutter test %d failed "
+			       "for %s: %08x != %08x\n", i, algo, hash1, hash2);
+			err = -EINVAL;
+			break;
+		}
+		err = 0;
 	}
 
 	return err;
-- 
2.1.3
