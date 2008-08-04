From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c algorithm by new crypto API.
Date: Mon, 4 Aug 2008 22:17:30 +0800
Message-ID: <20080804141730.GA11415@gondor.apana.org.au>
References: <1217842507.20845.18.camel@localhost.localdomain> <1217859214.3454.629.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Austin Zhang <austin_zhang@linux.intel.com>, davem@davemloft.net,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:60703 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753700AbYHDORk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 4 Aug 2008 10:17:40 -0400
Content-Disposition: inline
In-Reply-To: <1217859214.3454.629.camel@pmac.infradead.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 04, 2008 at 03:13:34PM +0100, David Woodhouse wrote:
>
> > +static int __init crc32c_intel_mod_init(void)
> > +{
> > +	return crypto_register_alg(&alg);
> > +}
> > +
> 
> Am I missing something here, or are you registering the crypto algorithm
> _unconditionally_ and then just causing init requests for it to fail on
> older hardware?  Wouldn't it be better to register the driver _only_
> when the hardware is capable? Or at least "if at least one cpu is
> capable".

Yes I think this is a show-stopper :)

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
