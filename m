From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/4] cpu_chainiv: add percpu IV chain genarator
Date: Thu, 9 Apr 2009 11:20:45 +0800
Message-ID: <20090409032045.GA2232@gondor.apana.org.au>
References: <20090316114940.GN13998@secunet.com> <20090316115251.GP13998@secunet.com> <20090327083615.GB27903@gondor.apana.org.au> <20090330115415.GC6791@secunet.com> <20090330131955.GA22604@gondor.apana.org.au> <20090408114014.GL6791@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:48610 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757351AbZDIDUw (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 8 Apr 2009 23:20:52 -0400
Content-Disposition: inline
In-Reply-To: <20090408114014.GL6791@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Apr 08, 2009 at 01:40:14PM +0200, Steffen Klassert wrote:
>
> Actually I'm instantiate a crypto_nivaead_type algorithm and choose for
> cpu_chainiv as the IV generator for that algorithm. If I want to do the
> same with eseqiv it would require to add aead support to eseqiv.
> Is this what you are thinking about, or is there a way to instantiate a
> crypto_aead_type algorithm and notify the ablkcipher to choose for
> eseqiv as it's default IV genarator?

You can allocate eseqiv(alg), e.g., eseqiv(cbc(aes)).

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
