From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/11] [CRYPTO] chainiv: Add chain IV generator
Date: Thu, 22 Nov 2007 20:12:35 +0800
Message-ID: <20071122121235.GB9357@gondor.apana.org.au>
References: <20071122084758.GA7536@gondor.apana.org.au> <E1Iv7jn-00020S-00@gondolin.me.apana.org.au> <20071122111711.GC2444@2ka.mipt.ru> <20071122112613.GB8781@gondor.apana.org.au> <20071122120500.GF28024@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:1671 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752030AbXKVM2p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Nov 2007 07:28:45 -0500
Content-Disposition: inline
In-Reply-To: <20071122120500.GF28024@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 22, 2007 at 03:05:00PM +0300, Evgeniy Polyakov wrote:
>
> What if dm-crypt will use the same interface (or other bulk-processing
> user) will use it with software crypto? Or was it specially designed for
> ipsec only?

dm-crypt (when we convert it to using givcrypt instead of its
own hard-coded IV generators) will specify the IV generators
explicitly which would bypass chainiv.

> I.e. it is an ipsec helper only and should not be used by other users?

Yes new applications should use explicit IV generators.  As
I said I wouldn't be against changing the default for sync away
from chainiv if something more appropriate comes up.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
