From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] camellia: simplify key setup and CAMELLIA_ROUNDSM macro
Date: Wed, 14 Mar 2012 20:30:53 +1100
Message-ID: <20120314093052.GA2847@gondor.apana.org.au>
References: <20120303115900.25935.68751.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:36905 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751242Ab2CNJaz (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Mar 2012 05:30:55 -0400
Content-Disposition: inline
In-Reply-To: <20120303115900.25935.68751.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Mar 03, 2012 at 01:59:00PM +0200, Jussi Kivilinna wrote:
> camellia_setup_tail() applies 'inverse of the last half of P-function' to
> subkeys, which is unneeded if keys are applied directly to yl/yr in
> CAMELLIA_ROUNDSM.
> 
> Patch speeds up key setup and should speed up CAMELLIA_ROUNDSM as applying
> key to yl/yr early has less register dependencies.
> 
> Quick tcrypt camellia results:
>  x86_64, AMD Phenom II, ~5% faster
>  x86_64, Intel Core 2, ~0.5% faster
>  i386, Intel Atom N270, ~1% faster
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
