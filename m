From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] crypto: Force panic on continuous CPRNG test failure when
	in FIPS mode
Date: Fri, 23 Jan 2009 10:58:17 -0500
Message-ID: <20090123155817.GA29548@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nhorman@tuxdriver.com
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60344 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760469AbZAWP61 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Jan 2009 10:58:27 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


FIPS 140-2 specifies that all access to various cryptographic modules be
prevented in the event that any of the provided self tests fail on the various
implemented algorithms. The way this is currently done is by simply panicing the
box.  We do this already for the various alg tests in testmgr.c, we should do it
in the case of a failure for the continuous test in the CPRNG as well.  This
patch implements that change

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 0fac8ff..7eef5be 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -132,10 +132,20 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 			 */
 			if (!memcmp(ctx->rand_data, ctx->last_rand_data,
 					DEFAULT_BLK_SZ)) {
-				printk(KERN_ERR
-					"ctx %p Failed repetition check!\n",
-					ctx);
-				ctx->flags |= PRNG_NEED_RESET;
+				if (fips_enabled) {
+					/* FIPS 140-2 requires that we disable
+					 * further use of crypto code if we fail
+					 * this test,  easiest way to do that
+					 * is panic the box
+					 */
+					panic("cprng %p failed continuity test",
+						ctx);  
+				} else {
+					printk(KERN_ERR
+						"ctx %p Failed repetition check!\n",
+						ctx);
+					ctx->flags |= PRNG_NEED_RESET;
+				}
 				return -EINVAL;
 			}
 			memcpy(ctx->last_rand_data, ctx->rand_data,
