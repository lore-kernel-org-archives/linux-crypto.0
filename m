From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] crypto: DRBG - use aligned buffers
Date: Mon, 13 Jun 2016 17:37:14 +0800
Message-ID: <20160613093714.GA7634@gondor.apana.org.au>
References: <3932580.AnntHTzK82@positron.chronox.de>
 <1525370.lyuSIsxrou@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49256 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964895AbcFMJha (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 13 Jun 2016 05:37:30 -0400
Content-Disposition: inline
In-Reply-To: <1525370.lyuSIsxrou@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 10, 2016 at 07:56:57AM +0200, Stephan Mueller wrote:
> Hardware cipher implementation may require aligned buffers. All buffers
> that potentially are processed with a cipher are now aligned.
> 
> At the time of the allocation of the memory, we have not yet allocated
> the cipher implementations. Hence, we cannot obtain the alignmask for
> the used cipher yet. Therefore, the DRBG code uses an alignment which
> should satisfy all cipher implementations.

Why not change it so that you allocate these buffers after you
have obtained the tfm object? An alignment of 8 doesn't work for
padlock at least, but then again the padlock driver doesn't support
CTR so it's no big deal.

I think if you are going to worry about alignment then let's do it
properly and use the actual alignment required.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
