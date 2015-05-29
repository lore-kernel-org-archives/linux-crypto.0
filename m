From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: algif_aead - Switch to new AEAD interface
Date: Fri, 29 May 2015 21:28:40 +0800
Message-ID: <20150529132840.GA20596@gondor.apana.org.au>
References: <20150527092441.GA27913@gondor.apana.org.au>
 <2444206.rbm5Z3UBF9@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50527 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754917AbbE2N2q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 09:28:46 -0400
Content-Disposition: inline
In-Reply-To: <2444206.rbm5Z3UBF9@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 29, 2015 at 12:09:35PM +0200, Stephan Mueller wrote:
> 
> > -	return (ctx->used >= (ctx->aead_assoclen + (ctx->enc ? 0 : as)));
> > +	return ctx->used >= ctx->aead_assoclen + as;
> 
> This change requires that the buffer handed in by user space always has room 
> for the tag, regardless whether it is needed or not. Is that intended?

Yes for two reasons.  One is that sometimes we need to enforce
in-place processing, in which case dst must be at least as big
as src.  The other reason is to eventually allow in-place processing
through algif_aead.  Unless the two SG lists were of the same length,
it isn't possible to do that.

> > -		/* add the size needed for the auth tag to be created */
> > -		outlen += as;
> > -	} else {
> > -		/* output data size is input without the authentication tag */
> > -		outlen = used - as;
> 
> The removal of these make me wonder: with those missing, the output of the 
> cipher operation does not have CT || tag (in case of encryption) or PT (in 
> case of encryption.
> 
> Note, I have updated my user space code to require space for the AD in the 
> output buffer. When reverting those changes with the following patch, the code 
> works nicely. If I do not apply the patch, the beginning of the CT or PT is as 
> expected, but the end is bogus. Also, the tag would be missing.

Well used is now supposed to always contain the tag in both cases.

Can you send me the code that you're using to test this and I'll
do some tests on it.
 
> However, when use those changes and I perform the test of libkcapi/test/kcapi 
> -y -s, I get the following strange crash which i have no idea where to look 
> for the cause (normal sendmsg and vmsplice tests with libkcapi/test/kcapi -y 
> and libkcapi/test/kcapi -y -v work flawless)

This is clearly not good.  It looks like memory corruption.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
