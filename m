From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 12/35] crypto: padlock - Switch sha to shash
Date: Wed, 15 Jul 2009 18:38:43 +0800
Message-ID: <20090715103843.GA21411@gondor.apana.org.au>
References: <20090715071424.GA19023@gondor.apana.org.au> <E1MQyij-0004zN-Ec@gondolin.me.apana.org.au> <20090715102818.GM20288@secunet.com> <20090715103025.GA21263@gondor.apana.org.au> <20090715103646.GN20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53125 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752525AbZGOKip (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jul 2009 06:38:45 -0400
Content-Disposition: inline
In-Reply-To: <20090715103646.GN20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 15, 2009 at 12:36:46PM +0200, Steffen Klassert wrote:
>
> It's 32-bit.
> One of my test systems had padlock enabled by chance.

This should fix it.

commit faae890883624e14a328863eafabf54a36698774
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Jul 15 18:37:48 2009 +0800

    crypto: padlock - Fix compile error on i386
    
    The previous change to allow hashing from states other than the
    initial broke compilation on i386 because the inline assembly
    tried to squeeze a u64 into a 32-bit register.  As we've already
    checked for 32-bit overflows we can simply truncate it to u32,
    or unsigned long so that we don't truncate at all on x86-64.
    
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/padlock-sha.c b/drivers/crypto/padlock-sha.c
index fb6e6c3..a936ba4 100644
--- a/drivers/crypto/padlock-sha.c
+++ b/drivers/crypto/padlock-sha.c
@@ -103,7 +103,8 @@ static int padlock_sha1_finup(struct shash_desc *desc, const u8 *in,
 	ts_state = irq_ts_save();
 	asm volatile (".byte 0xf3,0x0f,0xa6,0xc8" /* rep xsha1 */
 		      : \
-		      : "c"(state.count + count), "a"(state.count), \
+		      : "c"((unsigned long)state.count + count), \
+			"a"((unsigned long)state.count), \
 			"S"(in), "D"(result));
 	irq_ts_restore(ts_state);
 
@@ -165,7 +166,8 @@ static int padlock_sha256_finup(struct shash_desc *desc, const u8 *in,
 	ts_state = irq_ts_save();
 	asm volatile (".byte 0xf3,0x0f,0xa6,0xd0" /* rep xsha256 */
 		      : \
-		      : "c"(state.count + count), "a"(state.count), \
+		      : "c"((unsigned long)state.count + count), \
+			"a"((unsigned long)state.count), \
 			"S"(in), "D"(result));
 	irq_ts_restore(ts_state);
 
Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
