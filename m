From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] crypto: force reset of cprng on allocation
Date: Fri, 23 Jan 2009 11:50:27 -0500
Message-ID: <20090123165027.GB29548@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55888 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085AbZAWQug (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 23 Jan 2009 11:50:36 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

pseudo RNGs provide predictable outputs based on input parateters {key, V, DT},
the idea behind them is that only the user should know what the inputs are.
While its nice to have default known values for testing purposes, it seems
dangerous to allow the use of those default values without some sort of safety
measure in place, lest an attacker easily guess the output of the cprng.  This
patch forces the NEED_RESET flag on when allocating a cprng context, so that any
user is forced to reseed it before use.  The defaults can still be used for
testing, but this will prevent their inadvertent use, and be more secure.
   
Signed-off-by: Neil Horman <nhorman@redhat.com>

ansi_cprng.c |   11 ++++++++++-
1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 7eef5be..d9c3971 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -348,7 +348,16 @@ static int cprng_init(struct crypto_tfm *tfm)
 
 	spin_lock_init(&ctx->prng_lock);
 
-	return reset_prng_context(ctx, NULL, DEFAULT_PRNG_KSZ, NULL, NULL);
+	if (reset_prng_context(ctx, NULL, DEFAULT_PRNG_KSZ, NULL, NULL) < 0)
+		return -EINVAL;
+
+	/*
+	 * after allocation, we should always force the user to reset
+	 * so they don't inadvertently use the insecure default values
+	 * without specifying them intentially
+	 */
+	ctx->flags |= PRNG_NEED_RESET;
+	return 0;
 }
 
 static void cprng_exit(struct crypto_tfm *tfm)
