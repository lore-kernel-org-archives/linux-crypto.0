From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: crypto ahash error handling
Date: Wed, 10 Nov 2010 21:27:59 +0900
Message-ID: <20101110122759.GA18577@gondor.apana.org.au>
References: <4CD7B95E.9040501@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39271 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab0KJM2C (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Nov 2010 07:28:02 -0500
Content-Disposition: inline
In-Reply-To: <4CD7B95E.9040501@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
> Hello,
> 
> When using crypto ahash API, is it necessary/mandatory to call
> crypto_ahash_final() if crypto_ahash_update() returns error...
> 
> Basically it might happen after several calls while calculating hash if
> HW error happens.
> It is not possible to continue hash calculation. it is necessary to
> reset HW and start whole hash again..
> 
> Any comments?

>From the driver's perspective you cannot expect that the user
will call crypto_ahash_final in this case, or for that matter in
any other case as the user is always free to leave a hash in
an unfinalised state.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
