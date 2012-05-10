From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: CRYPTO_ALG_ASYNC
Date: Thu, 10 May 2012 20:16:11 +1000
Message-ID: <20120510101611.GA21025@gondor.apana.org.au>
References: <CALLzPKYc0wBtTiNtDGgY09D_7MJPtwBoQ1AS_U-Jsg02+hEPOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto <linux-crypto@vger.kernel.org>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:55719 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755449Ab2EJKQN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 May 2012 06:16:13 -0400
Content-Disposition: inline
In-Reply-To: <CALLzPKYc0wBtTiNtDGgY09D_7MJPtwBoQ1AS_U-Jsg02+hEPOA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 10, 2012 at 12:33:40PM +0300, Kasatkin, Dmitry wrote:
> Hello Herbert,
> 
> CRYPTO_ALG_ASYNC is heavily used like:
> 
>     crypto_alloc_shash(hash_alg, 0, CRYPTO_ALG_ASYNC);

Where did you see that? There is no need to specify ASYNC in the
mask for shash since they're always synchronous.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
