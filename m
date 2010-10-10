From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: return codes
Date: Sun, 10 Oct 2010 14:51:50 +0800
Message-ID: <20101010065150.GA11552@gondor.apana.org.au>
References: <20101009012913.GA2829@gondor.apana.org.au> <1286681683.2666.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:33938 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819Ab0JJGvz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 10 Oct 2010 02:51:55 -0400
Content-Disposition: inline
In-Reply-To: <1286681683.2666.21.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Oct 09, 2010 at 11:34:43PM -0400, Mimi Zohar wrote:
> On Sat, 2010-10-09 at 09:29 +0800, Herbert Xu wrote:
> > Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > > Hi,
> > > 
> > > Looking at different examples of the same crypto call, it's unclear
> > > whether it only returns negative error values. Some examples only test
> > > for negative values, while others test for not 0. tcrypt.c does "if
> > > (ret)".  Would appreciate some clarification.
> > 
> > Unless the call can return positive values then it makes no
> > difference.  Which particular call are you talking about?
> > 
> > Cheers,
> 
> Just to name a few: crypto_hash_init(), crypto_hash_update(),
> crypto_hash_final(). Also crypto_blkcipher_decrypt/encrypt().  Would be
> nice to know definitively that they return < 0 on error and 0 for
> success.

Yes it's zero or negative.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
