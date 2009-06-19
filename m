From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC] [PATCH 2/5] pcrypt: Add pcrypt crypto parallelization
	wrapper
Date: Fri, 19 Jun 2009 20:21:13 +0800
Message-ID: <20090619122113.GA18631@gondor.apana.org.au>
References: <20090608070749.GR20366@secunet.com> <20090608071000.GT20366@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:36305 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752656AbZFSMVQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Jun 2009 08:21:16 -0400
Content-Disposition: inline
In-Reply-To: <20090608071000.GT20366@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jun 08, 2009 at 09:10:00AM +0200, Steffen Klassert wrote:
>
> +config CRYPTO_PCRYPT_CORE
> +	bool
> +	select CRYPTO_AEAD

BTW just noticed that this forces AEAD to be built-in even when
pcrypt is a module.  We should fix this up.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
