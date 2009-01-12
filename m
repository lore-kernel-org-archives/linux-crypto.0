From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH crypto 4/4] AES-NI: Add support to Intel AES-NI
	instructions for x86_64 platform
Date: Mon, 12 Jan 2009 21:43:35 +1100
Message-ID: <20090112104335.GA4942@gondor.apana.org.au>
References: <1231120947.5937.31.camel@yhuang-dev.sh.intel.com> <20090109070144.GA7358@gondor.apana.org.au> <1231743310.5937.107.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Huang Ying <ying.huang@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:50980 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752143AbZALKnl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 12 Jan 2009 05:43:41 -0500
Content-Disposition: inline
In-Reply-To: <1231743310.5937.107.camel@yhuang-dev.sh.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 12, 2009 at 02:55:10PM +0800, Huang Ying wrote:
>
> I use a "shell" cbc(aes) algorithm which chooses between
> cryptd(__cbc-aes-aesni) and __cbc-aes-aesni according to context. But
> the struct ablkcipher_request passed in can not be used for cryptd(*).
> This can be resolved by allocating another struct ablkcipher_request for
> cryptd(*) for each incoming struct ablkcipher_request. But is there any
> better solution?

You should include that other ablkcipher_request as part of the
context of your ablkcipher_request.

See for example how aead embeds it.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
