From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/9] Convert padlock sha to shash
Date: Thu, 16 Jul 2009 10:34:13 +0800
Message-ID: <20090716023413.GA28905@gondor.apana.org.au>
References: <20090711101958.GA14642@gondor.apana.org.au> <20090714202615.GA21476@Chamillionaire.breakpoint.cc> <20090715004847.GA17017@gondor.apana.org.au> <20090715220606.GA30627@Chamillionaire.breakpoint.cc> <20090716021601.GA28776@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59662 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757184AbZGPCeP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 22:34:15 -0400
Content-Disposition: inline
In-Reply-To: <20090716021601.GA28776@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jul 16, 2009 at 10:16:01AM +0800, Herbert Xu wrote:
>
> Can you please pull my tree again? There were quite a few bugs
> that I fixed last night.

Oh and please make sure you have this patch applied too:

commit e9b25f16cda88b33fe15b30c009912e6c471edda
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Jul 16 10:33:27 2009 +0800

    crypto: padlock - Fix hashing of partial blocks
    
    When we encounter partial blocks in finup, we'll invoke the xsha
    instruction with a bogus count that is not a multiple of the block
    size.  This patch fixes it.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index a936ba4..76cb6b3 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -94,6 +94,7 @@ static int padlock_sha1_finup(struct shash_desc *desc, const u8 *in,
 			memcpy(state.buffer + leftover, in, count);
 			in = state.buffer;
 			count += leftover;
+			state.count &= ~(SHA1_BLOCK_SIZE - 1);
 		}
 	}
 
@@ -157,6 +158,7 @@ static int padlock_sha256_finup(struct shash_desc *desc, const u8 *in,
 			memcpy(state.buf + leftover, in, count);
 			in = state.buf;
 			count += leftover;
+			state.count &= ~(SHA1_BLOCK_SIZE - 1);
 		}
 	}
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
