From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Crypto API
Date: Thu, 14 Jan 2010 11:40:11 +1100
Message-ID: <20100114004011.GA23131@gondor.apana.org.au>
References: <4B4D6828.9000506@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:40828 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754461Ab0ANAkO (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2010 19:40:14 -0500
Content-Disposition: inline
In-Reply-To: <4B4D6828.9000506@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
> 
> I develop some drivers for crypto HW and met some difficulties.
> Some algorithm functions are called behind crypto_kmap()
> 
> data = crypto_kmap(sg_page(sg), 0);
> 
> It will do inc_preempt_count();
> 
> I try to use DMA controller to perform memory transfers and try to use
> wait_for_completion()

crypto_kmap is for software crypto.  If you're doing DMA, you
shouldn't use it.

Please take a look at other crypto drivers under drivers/crypto
as to how DMA should be implemented.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
