From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: Force panic on continuous CPRNG test failure
	when in FIPS mode
Date: Wed, 28 Jan 2009 07:15:11 -0500
Message-ID: <20090128121511.GA6361@hmsreliant.think-freely.org>
References: <20090123155817.GA29548@hmsreliant.think-freely.org> <20090128041828.GB13157@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49651 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZA1MPU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Jan 2009 07:15:20 -0500
Content-Disposition: inline
In-Reply-To: <20090128041828.GB13157@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 28, 2009 at 03:18:28PM +1100, Herbert Xu wrote:
> 
> I'm OK with this change but I'd like it to look like:
> 
> 	if (fips_enabled) {
> 		panic(...)
> 	}
> 
> 	blah blah blah
> 
> This way the FIPS crap doesn't get in the way of everyday use.
> 
> Thanks,


Sure, new patch, extra commentary removed.  Also brought the panic/printk text
into agreement.


FIPS 140-2 specifies that all access to various cryptographic modules be
prevented in the event that any of the provided self tests fail on the various
implemented algorithms.  We already panic when any of the test in testmgr.c
fail when we are operating in fips mode.  The continuous test in the cprng here
was missed when that was implmented.  This code simply checks for the
fips_enabled flag if the test fails, and warns us via syslog or panics the box
accordingly.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 ansi_cprng.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)


diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 7447806..3003f21 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -132,10 +132,15 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 			 */
 			if (!memcmp(ctx->rand_data, ctx->last_rand_data,
 					DEFAULT_BLK_SZ)) {
-				printk(KERN_ERR
-					"ctx %p Failed repetition check!\n",
-					ctx);
-				ctx->flags |= PRNG_NEED_RESET;
+				if (fips_enabled) {
+					panic("cprng %p Failed repetition check!\n",
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
