From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock: fix for non-64byte aligned data
Date: Thu, 4 Nov 2010 13:46:06 -0500
Message-ID: <20101104184606.GA1994@gondor.apana.org.au>
References: <1288893036-31704-1-git-send-email-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Chuck Ebbert <cebbert@redhat.com>,
	Nico Erfurth <ne@erfurth.eu>,
	Harald Welte <HaraldWelte@viatech.com>,
	Michal Ludvig <michal@logix.cz>
To: Phil Sutter <phil@nwl.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44992 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0KDSqO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Nov 2010 14:46:14 -0400
Content-Disposition: inline
In-Reply-To: <1288893036-31704-1-git-send-email-phil@nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Nov 04, 2010 at 05:50:36PM +0000, Phil Sutter wrote:
> Using cryptodev-linux with it's zero-copy functionality, one is mighty
> enough to pass various misaligned/mis-sized buffers unmodified to the
> engine's driver, which occured to be an easy way to break padlock
> equipped machines:

OK.

> On one hand, the original code is broken in padlock_xcrypt_cbc(): when
> passing the "initial" bytes to xcryptcbc, 'count' is incorrectly used as
> length. This may trigger prefetch-related issues, but will definitely
> lead to data corruption as xcryptcbc is called again afterwards,
> altering (count - initial) * AES_BLOCK_SIZE bytes after the end of
> 'output' in memory.

Ouch, does the attached patch fix this problem for you?

> Another problem occurs when passing non-64byte aligned buffers, which
> leads to memory corruption in userspace (running applications crash
> randomly). This problem is too subtile for me to have more than vague
> assumptions about it's origin. Anyways, this patch fixes them:

I'd like to determine whether this is due to the previous bug.
If it still crashes randomly even with my one-line patch please
let me know.

> Instead of handling the "odd" bytes (i.e., the remainder when dividing
> into prefetch blocks of 64bytes) at the beginning, go for them in the
> end, copying the data out if prefetching would run beyond the page
> boundary.

I'd like to avoid this copying unless the hardware really needs
it.

Can you provide some information on the CPU where you're seeing
this?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
commit c054a076a1bd4731820a9c4d638b13d5c9bf5935
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Thu Nov 4 14:38:39 2010 -0400

    crypto: padlock - Fix AES-CBC handling on odd-block-sized input
    
    On certain VIA chipsets AES-CBC requires the input/output to be
    a multiple of 64 bytes.  We had a workaround for this but it was
    buggy as it sent the whole input for processing when it is meant
    to only send the initial number of blocks which makes the rest
    a multiple of 64 bytes.
    
    As expected this causes memory corruption whenever the workaround
    kicks in.
    
    Reported-by: Phil Sutter <phil@nwl.cc>
    Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/padlock-aes.c b/drivers/crypto/padlock-aes.c
index 2e992bc..8a515ba 100644
--- a/drivers/crypto/padlock-aes.c
+++ b/drivers/crypto/padlock-aes.c
@@ -286,7 +286,7 @@ static inline u8 *padlock_xcrypt_cbc(const u8 *input, u8 *output, void *key,
 	if (initial)
 		asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 			      : "+S" (input), "+D" (output), "+a" (iv)
-			      : "d" (control_word), "b" (key), "c" (count));
+			      : "d" (control_word), "b" (key), "c" (initial));
 
 	asm volatile (".byte 0xf3,0x0f,0xa7,0xd0"	/* rep xcryptcbc */
 		      : "+S" (input), "+D" (output), "+a" (iv)
