From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH] crypto: prevent helper ciphers from being allocated
 by users
Date: Tue, 17 Mar 2015 22:45:52 +1100
Message-ID: <20150317114552.GA12326@gondor.apana.org.au>
References: <13986065.EbkBp8M36a@tachyon.chronox.de>
 <20150317112350.GA11671@gondor.apana.org.au>
 <1442292.caf3IdtESe@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:60387 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225AbbCQLpz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Mar 2015 07:45:55 -0400
Content-Disposition: inline
In-Reply-To: <1442292.caf3IdtESe@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 17, 2015 at 12:40:12PM +0100, Stephan Mueller wrote:
>
> >How about adding a flag to all these internal algorithms and then
> >change crypto_alg_mod_lookup to disable that flag by default?
> 
> The issue with flags is the following: first we have to think about 
> whether we want a black list or white list approach. Your suggestion 
> implies a black list. Black lists for ensuring security is not good IMHO 
> as it has a tendency to miss cases. This especially applies to this area 
> where we have already an indicator for internal ciphers: the prio is so 
> low that it will never ever be selected based on the name. Now, adding a 
> flag means that we mark such an internal cipher twice.

Huh? Using prio is already a black list.

In any case abusing the priority field like this is not acceptable,
especially when the priority can be set from user-space.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
