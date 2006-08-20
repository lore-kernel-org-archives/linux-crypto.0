From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] cit_encrypt_iv/cit_decrypt_iv for ECB mode
Date: Sun, 20 Aug 2006 21:20:09 +1000
Message-ID: <E1GElLd-0006HN-00@gondolin.me.apana.org.au>
References: <20060820080403.GA602@1wt.eu>
Cc: solar@openwall.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:19473 "EHLO
	arnor.apana.org.au") by vger.kernel.org with ESMTP id S1750740AbWHTLUc
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Aug 2006 07:20:32 -0400
To: w@1wt.eu (Willy Tarreau)
In-Reply-To: <20060820080403.GA602@1wt.eu>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Willy Tarreau <w@1wt.eu> wrote:
> 
> That's what I thought after reading the code too. BTW, 2.6 does not
> initialize the pointers either.

This has been changed in the cryptodev-2.6 tree:

http://www.kernel.org/git/?p=linux/kernel/git/herbert/cryptodev-2.6.git;a=commitdiff;h=310d6a0c14eda153869adaf74e69dbd1a1256e7f

[CRYPTO] cipher: Removed special IV checks for ECB

This patch makes IV operations on ECB fail through nocrypt_iv rather than
calling BUG().  This is needed to generalise CBC/ECB using the template
mechanism.

In fact with the new block cipher type calling the IV-specific
functions on ECB will work in the same way as the IV-less functions.
This makes sense because the IV length is simply zero.
 
> I wonder whether we shouldn't consider that those functions must at
> least clear the memory area that was submitted to them, such as
> proposed below. It would also fix the problem for potential other
> users. I don't think we need to check whether dst is valid given
> the small amount of tests performed in crypt().

If the user is ignoring the error value here then you're in serious
trouble anyway since they've just lost all their data.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
