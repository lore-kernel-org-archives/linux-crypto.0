From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Question on structures
Date: Mon, 25 Oct 2010 20:07:36 -0400
Message-ID: <20101026000736.GA6315@gondor.apana.org.au>
References: <Pine.GSO.4.64.1010251641420.2377@well.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Mark Allyn <allyn@well.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:44736 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab0JZAHi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Oct 2010 20:07:38 -0400
Content-Disposition: inline
In-Reply-To: <Pine.GSO.4.64.1010251641420.2377@well.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Mark Allyn <allyn@well.com> wrote:
> 
> Folks:
> 
> Perhaps this is due to me being a neophyte . . .
> 
> I notice that some of the structure have two different sets of functions.
> 
> For example, the ahash_alg structure has .init and then .base.cra_init. 
> What is the difference between the two?

cra_init initialises a tfm object, while init is an operation
specific to hash algorithms --- it initialises the hash state.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
