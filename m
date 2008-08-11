From: Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH] crypto: obscure state information on free
Date: Mon, 11 Aug 2008 16:26:07 -0400
Message-ID: <20080811202607.GA11527@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: nhorman@tuxdriver.com, herbert@gondor.apana.org.au,
	davem@davemloft.net
To: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3887 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbYHKU0W (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2008 16:26:22 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Patch to obscure state information on free in prng code.  Keeps prying eyes from
sifting through your trash :)

Regards
Neil

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>


 prng.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/crypto/prng.c b/crypto/prng.c
index b203093..fc6fa28 100644
--- a/crypto/prng.c
+++ b/crypto/prng.c
@@ -296,6 +296,7 @@ EXPORT_SYMBOL_GPL(alloc_prng_context);
 void free_prng_context(struct prng_context *ctx)
 {
 	crypto_free_cipher(ctx->tfm);
+	memset(ctx, 0, sizeof(struct prng_context));
 	kfree(ctx);
 }
 EXPORT_SYMBOL_GPL(free_prng_context);
-- 
/****************************************************
 * Neil Horman <nhorman@tuxdriver.com>
 * Software Engineer, Red Hat
 ****************************************************/
