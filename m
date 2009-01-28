From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: IPSec AH hardware offload
Date: Wed, 28 Jan 2009 14:37:36 +1100
Message-ID: <20090128033736.GA5888@gondor.apana.org.au>
References: <20090120141448.GG3849@brook.picochip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jamie Iles <jamie.iles@picochip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:35571 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751292AbZA1Dhk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2009 22:37:40 -0500
Content-Disposition: inline
In-Reply-To: <20090120141448.GG3849@brook.picochip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jamie Iles <jamie.iles@picochip.com> wrote:
> 
> I'm currently developing a driver for a hardware crypto offload engine that is
> capable of offloading both ESP and AH in IPSec. I've noticed that none of the
> crypto drivers in 2.6.28 do offload for ahash and that the netkey AH
> implementation both use synchronous hashes. Are the synchronous software
> versions likely to be more efficient than hardware offloading or is there an
> architectural reason for not using async hashes?

No it's just because nobody has gotten around to complete the
async hash work yet.  So we're currently half-way through the
process of converting existing algorithms to the shash interface,
which allows them to be used efficiently by IPsec through the
ahash interface.

Once that's completed we can then convert IPsec (or rather, authenc)
over to using ahash.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
