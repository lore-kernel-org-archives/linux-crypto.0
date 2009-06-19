From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] pcrypt: Add pcrypt crypto parallelization
	wrapper
Date: Fri, 19 Jun 2009 20:29:33 +0800
Message-ID: <20090619122933.GB18631@gondor.apana.org.au>
References: <20090608070749.GR20366@secunet.com> <20090608071000.GT20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:43003 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751938AbZFSM3f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2009 08:29:35 -0400
Content-Disposition: inline
In-Reply-To: <20090608071000.GT20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2009 at 09:10:00AM +0200, Steffen Klassert wrote:
>
> +config CRYPTO_PCRYPT
> +	tristate "Parallel crypto engine (EXPERIMENTAL)"
> +	depends on USE_GENERIC_SMP_HELPERS && EXPERIMENTAL
> +	select CRYPTO_MANAGER
> +	select CRYPTO_PCRYPT_CORE
> +	help
> +	  This converts an arbitrary crypto algorithm into a parallel
> +	  algorithm that is executed in a softirq.

BTW, do we really need softirqs for these things? Cryptographic
operations are typically slow (especially when you have to move
them to other CPUs to handle a single NIC:) so if we're going to
the trouble of making it async then we should put them in work
queues instead.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
