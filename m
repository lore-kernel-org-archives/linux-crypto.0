From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/4] cpu_chainiv: add percpu IV chain genarator
Date: Fri, 27 Mar 2009 16:36:15 +0800
Message-ID: <20090327083615.GB27903@gondor.apana.org.au>
References: <20090316114940.GN13998@secunet.com> <20090316115251.GP13998@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36115 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752110AbZC0IgX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Mar 2009 04:36:23 -0400
Content-Disposition: inline
In-Reply-To: <20090316115251.GP13998@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 16, 2009 at 12:52:51PM +0100, Steffen Klassert wrote:
> If the crypro requests of a crypto transformation are processed in
> parallel, the usual chain IV generator would serialize the crypto
> requests again. The percpu IV chain genarator allocates the IV as
> percpu data and generates percpu IV chains, so a crypro request
> does not need to wait for the completition of the IV generation
> from a previous request that runs on a different cpu.
> 
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

I actually thought about this one when I first wrote chainiv,
I chose to avoid this because it has some security consequences.
In particular, an attacker would now be able to infer whether two
packets belong to two differnt flows from the fact that they came
from two different IV streams.

In any case, I don't think this is central to your work, right?

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
