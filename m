From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: authenc - convert to ahash
Date: Wed, 22 Jul 2009 15:02:59 +0800
Message-ID: <20090722070259.GA29808@gondor.apana.org.au>
References: <20090721090217.GF20288@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59399 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751476AbZGVHDC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2009 03:03:02 -0400
Content-Disposition: inline
In-Reply-To: <20090721090217.GF20288@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jul 21, 2009 at 11:02:17AM +0200, Steffen Klassert wrote:
>
> +	err = crypto_ahash_finup(ahreq);
> +	if (err == -EINPROGRESS)
> +		return;

This is redundant.  All completion functions must expect to be
called with EINPROGRESS followed by the actual completion later.

The same probably applies to other EINPROGRESS checks in this patch.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
