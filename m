From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: aesni-intel - avoid IPsec re-ordering
Date: Wed, 20 Jan 2016 16:38:07 +0800
Message-ID: <20160120083806.GA20214@gondor.apana.org.au>
References: <CAMFBXfk=u_QYTdz0+P1WoNwuGN1xBaw0Ff2Y_XvLdQnKTasOcw@mail.gmail.com>
 <20160119074343.GA7753@gondor.apana.org.au>
 <CAMFBXfkgjTtBX4sePTr30WenzDgw=h0yp8fp17de=ao+8AT=Mg@mail.gmail.com>
 <20160120032537.GA18992@gondor.apana.org.au>
 <CAMFBXfkS_maZVwpEcUF+gUU9Q74tKKcxFiS+Oe3FBXnrrxyFAA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Raj Ammanur <rammanur@arista.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46863 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbcATIib (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Jan 2016 03:38:31 -0500
Content-Disposition: inline
In-Reply-To: <CAMFBXfkS_maZVwpEcUF+gUU9Q74tKKcxFiS+Oe3FBXnrrxyFAA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 20, 2016 at 12:31:46AM -0800, Raj Ammanur wrote:
> 
> RAJ: ok. would it also be useful to be able to set the length as a module
> load time parameter?

That would be a bad interface.  If we wanted to have an adjustable
limit it needs to be set by the entity that is creating the tfm,
i.e., IPsec.
 
> RAJ: hmm, thats true, yes.
> 
> so, is the below description, that you wrote in one of your email replies,
> the solution for which you are going to create a patch?
> 
> > So what I'm thinking of is to have the softirq path forcibly regain
> > control from cryptd where possible.  This is tricky because cryptd
> > might be in the middle of processing a request.  So that's why I'd
> > like to disable softirqs while we're processing a request.

Yes.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
