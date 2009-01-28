From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto: sha-s390 - Switch to shash
Date: Wed, 28 Jan 2009 14:56:15 +1100
Message-ID: <20090128035615.GA13051@gondor.apana.org.au>
References: <20090118225517.GA30510@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59857 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752281AbZA1D4V (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Jan 2009 22:56:21 -0500
Content-Disposition: inline
In-Reply-To: <20090118225517.GA30510@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 19, 2009 at 09:55:17AM +1100, Herbert Xu wrote:
> 
> Could you let me if this patch breaks s390?
> 
> commit 0fe7dddf02811152d7e58747bfe419ec0f43ea4e
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Sun Jan 18 20:33:33 2009 +1100
> 
>     crypto: sha-s390 - Switch to shash
>     
>     This patch converts the S390 sha algorithms to the new shash interface.
>     
>     Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

I'm going to throw this into cryptodev and if it breaks, please
yell.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
