From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH v2 2/4] pcrypt: Add pcrypt crypto parallelization
	engine
Date: Mon, 27 Apr 2009 16:56:20 +0800
Message-ID: <20090427085620.GB21761@gondor.apana.org.au>
References: <20090424102451.GB12680@secunet.com> <20090424102720.GD12680@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:56878 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753867AbZD0I40 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Apr 2009 04:56:26 -0400
Content-Disposition: inline
In-Reply-To: <20090424102720.GD12680@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 24, 2009 at 12:27:20PM +0200, Steffen Klassert wrote:
>
> +	alg = crypto_get_attr_alg(tb, algt->type,
> +				  (algt->mask & CRYPTO_ALG_TYPE_MASK)
> +				  | CRYPTO_ALG_PCRYPT);

Do you really need to exclude pcrypt algorithms here? If the user
wants to added another layer of pcrypt then we should obey.

Otherwise this looks pretty good to me.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
