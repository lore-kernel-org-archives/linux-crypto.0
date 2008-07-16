From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] RNG: Add Pseudo Random Number Generator to kernel
Date: Wed, 16 Jul 2008 22:03:16 +0800
Message-ID: <20080716140316.GA16681@gondor.apana.org.au>
References: <20080703202102.GB5237@hmsendeavour.rdu.redhat.com> <20080716134456.GA16546@gondor.apana.org.au> <20080716135841.GC24291@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net
To: Neil Horman <nhorman@tuxdriver.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:55371 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755910AbYGPODU (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jul 2008 10:03:20 -0400
Content-Disposition: inline
In-Reply-To: <20080716135841.GC24291@hmsreliant.think-freely.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 16, 2008 at 09:58:41AM -0400, Neil Horman wrote:
>
> No, this was rather a stream of conscious thing, shifting incrementing numbers
> through the buffer, I can certainly make it a simple counter.

Yeah I think a simple counter fits the spirit of the specification
better.  It'll also have a much longer period than this.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
