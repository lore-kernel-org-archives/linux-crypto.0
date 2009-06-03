From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] aead: Add generic aead wrapper interface
Date: Wed, 3 Jun 2009 22:14:19 +1000
Message-ID: <20090603121419.GA13672@gondor.apana.org.au>
References: <20090513130618.GD20366@secunet.com> <20090513130818.GF20366@secunet.com> <20090602035041.GB22831@gondor.apana.org.au> <20090602092151.GJ20366@secunet.com> <20090602092815.GA26832@gondor.apana.org.au> <20090603093216.GK20366@secunet.com> <20090603094049.GA11356@gondor.apana.org.au> <20090603112353.GL20366@secunet.com> <20090603115931.GA13361@gondor.apana.org.au> <20090603121435.GN20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:34613 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752385AbZFCMOW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2009 08:14:22 -0400
Content-Disposition: inline
In-Reply-To: <20090603121435.GN20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jun 03, 2009 at 02:14:35PM +0200, Steffen Klassert wrote:
>
> Aha, ok I see. So I will see whether I can instantiate pcrypt
> with tcrypt as you suggested and drop the wrapper from the next
> patchset.

It should be straightforward as you just need to call crypto_has_alg.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
