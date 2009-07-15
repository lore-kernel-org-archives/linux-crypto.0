From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [1/9] Convert padlock sha to shash
Date: Wed, 15 Jul 2009 08:48:47 +0800
Message-ID: <20090715004847.GA17017@gondor.apana.org.au>
References: <20090711101958.GA14642@gondor.apana.org.au> <20090714202615.GA21476@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:53754 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756804AbZGOAsu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2009 20:48:50 -0400
Content-Disposition: inline
In-Reply-To: <20090714202615.GA21476@Chamillionaire.breakpoint.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 14, 2009 at 10:26:15PM +0200, Sebastian Andrzej Siewior wrote:
> 
> I have here a via nano so I should be able to test it.
> Do you have a particular test case in mind or should I just grab
> ipsec-tools, setup a tunnel and send a few packets?

Yes, that should be enough.  You don't even ipsec-tools, just
a manual SA setup with ip xfrm should be good enough.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
