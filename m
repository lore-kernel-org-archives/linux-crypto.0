From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] prng: fix repetition test to properly update on each
	iteration
Date: Mon, 7 Jul 2008 10:22:10 -0400
Message-ID: <20080707142210.GB5372@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	nhorman@tuxdriver.com
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4304 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbYGGOW0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jul 2008 10:22:26 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Fixing a silly bug that I missed in the initial submission
Fix the repetition test in prng to update on each iteration.  Currently we check
against the last iteration to make sure the given prng context isn't stuck, but
we never update the last data buffer.

Best
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 prng.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/prng.c b/crypto/prng.c
index 1310175..5b66bdf 100644
--- a/crypto/prng.c
+++ b/crypto/prng.c
@@ -153,6 +153,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 					ctx->flags |= PRNG_NEED_RESET;
 					return -1;
 				}
+				memcpy(ctx->last_rand_data, ctx->rand_data, DEFAULT_BLK_SZ);
 
 				/*
 				 * Lastly xor the random data with I
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
