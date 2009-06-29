From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: [PATCH 1/2] crypto/ansi prng: use just a BH lock
Date: Mon, 29 Jun 2009 23:44:30 +0200
Message-ID: <20090629214430.GA29616@Chamillionaire.breakpoint.cc>
References: <1246281425.3688.13.camel@queen> <20090629140704.GA25939@Chamillionaire.breakpoint.cc> <20090629152027.GA5022@hmsreliant.think-freely.org>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	davem@davemloft.net, Eric Sesterhenn <eric.sesterhenn@lsexperts.de>
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42272 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752976AbZF2Vob (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Jun 2009 17:44:31 -0400
Content-Disposition: inline
In-Reply-To: <20090629152027.GA5022@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

the current code uses a mix of sping_lock() & spin_lock_irqsave(). This can
lead to deadlock with the correct timming & cprng_get_random() + cprng_reset()
sequence.
I've converted them to bottom half locks since all three user grab just a BH
lock so this runs probably in softirq :)

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
---
 crypto/ansi_cprng.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index d80ed4c..ff00b58 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -187,7 +187,6 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 /* Our exported functions */
 static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
 {
-	unsigned long flags;
 	unsigned char *ptr = buf;
 	unsigned int byte_count = (unsigned int)nbytes;
 	int err;
@@ -196,7 +195,7 @@ static int get_prng_bytes(char *buf, size_t nbytes, struct prng_context *ctx)
 	if (nbytes < 0)
 		return -EINVAL;
 
-	spin_lock_irqsave(&ctx->prng_lock, flags);
+	spin_lock_bh(&ctx->prng_lock);
 
 	err = -EINVAL;
 	if (ctx->flags & PRNG_NEED_RESET)
@@ -268,7 +267,7 @@ empty_rbuf:
 		goto remainder;
 
 done:
-	spin_unlock_irqrestore(&ctx->prng_lock, flags);
+	spin_unlock_bh(&ctx->prng_lock);
 	dbgprint(KERN_CRIT "returning %d from get_prng_bytes in context %p\n",
 		err, ctx);
 	return err;
@@ -287,7 +286,7 @@ static int reset_prng_context(struct prng_context *ctx,
 	int rc = -EINVAL;
 	unsigned char *prng_key;
 
-	spin_lock(&ctx->prng_lock);
+	spin_lock_bh(&ctx->prng_lock);
 	ctx->flags |= PRNG_NEED_RESET;
 
 	prng_key = (key != NULL) ? key : (unsigned char *)DEFAULT_PRNG_KEY;
@@ -332,7 +331,7 @@ static int reset_prng_context(struct prng_context *ctx,
 	rc = 0;
 	ctx->flags &= ~PRNG_NEED_RESET;
 out:
-	spin_unlock(&ctx->prng_lock);
+	spin_unlock_bh(&ctx->prng_lock);
 
 	return rc;
 
-- 
1.6.3.3

