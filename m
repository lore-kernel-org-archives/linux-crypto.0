From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: des3_ede: permit weak keys unless
	REQ_WEAK_KEY set
Date: Fri, 5 Dec 2008 23:24:27 +0800
Message-ID: <20081205152427.GA32475@gondor.apana.org.au>
References: <200812041557.49601.jarod@redhat.com> <493942D9.6030807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>,
	linux-kernel@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:47557 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754514AbYLEPYe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Dec 2008 10:24:34 -0500
Content-Disposition: inline
In-Reply-To: <493942D9.6030807@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 05, 2008 at 10:03:53AM -0500, Jarod Wilson wrote:
>
>  	if (unlikely(!((K[0] ^ K[2]) | (K[1] ^ K[3])) ||
> -		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))))
> +		     !((K[2] ^ K[4]) | (K[3] ^ K[5]))) &&
> +		     (*flags & CRYPTO_TFM_REQ_WEAK_KEY))
>  	{
>  		*flags |= CRYPTO_TFM_RES_BAD_KEY_SCHED;

This should be changed to RES_WEAK_KEY.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
