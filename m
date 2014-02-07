From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/3] support for interleaving in generic chaining
 modes
Date: Fri, 7 Feb 2014 17:23:05 +0800
Message-ID: <20140207092304.GA2573@gondor.apana.org.au>
References: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
 <20140207022335.GA27694@gondor.apana.org.au>
 <CAKv+Gu-4J6jO135QgNrLrEX96U7aS7k4BE82j9ZLzwe60HfTTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:48074 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaBGJXP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Feb 2014 04:23:15 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-4J6jO135QgNrLrEX96U7aS7k4BE82j9ZLzwe60HfTTQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 07, 2014 at 08:30:26AM +0100, Ard Biesheuvel wrote:
> 
> I agree that it would be trivial for cbc(%s) to probe for ecb(%s)
> before settling on using plain '%s.
> But how to probe for an /accelerated/ ecb(%s), i.e., how to avoid
> using the generic ecb(%s) which adds nothing but overhead?
> The other issue is how to find out what the optimal chunk size is for
> the accelerated ecb(%s) implementation, which would involve adding a
> struct member that holds the preferred number of blocks presented in a
> single invocation.
> In fact, that would solve both issues, as the probe could check this
> struct member for a >1 value (as my current series does but in against
> a cipher_alg instance)

I'd like to see some numbers on the actual overhead of ecb before
we get too deeply into optimising it away.

In any case, one easy solution is to change the driver name of
generic ecb to ecb_generic (cf. ccm.c) which you could then
check for in cbc and elsewhere.

Also, how are you determining the optimal number of blocks? For
the in-place case you're bound by how much memory you can find
for the temporary buffer.  For the not-in-place case wouldn't you
just go for as much as you can?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
