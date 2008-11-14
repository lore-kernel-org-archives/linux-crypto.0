From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] ansi_cprng: zero out key data on exit
Date: Fri, 14 Nov 2008 15:55:36 -0500
Message-ID: <20081114205536.GA27175@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nhorman@tuxdriver.com
To: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43215 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbYKNU5n (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Nov 2008 15:57:43 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Its been mentioned to me a few times that the ansi_cprng doesn't zero out its
data when a context is freed.  Given that we store key, and other seed data in
that structure, I think its probably a good idea that we zero it out.  This
patch does that.

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 ansi_cprng.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 72db0fd..e6ad373 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -266,6 +266,7 @@ done:
 static void free_prng_context(struct prng_context *ctx)
 {
 	crypto_free_cipher(ctx->tfm);
+	memset(ctx, 0, sizeof(struct prng_context));
 }
 
 static int reset_prng_context(struct prng_context *ctx,
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
