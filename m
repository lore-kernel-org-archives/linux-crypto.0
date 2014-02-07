From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH 0/3] support for interleaving in generic chaining
 modes
Date: Fri, 7 Feb 2014 10:23:35 +0800
Message-ID: <20140207022335.GA27694@gondor.apana.org.au>
References: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, davem@davemloft.net,
	jussi.kivilinna@iki.fi
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:59896 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaBGCYQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Feb 2014 21:24:16 -0500
Content-Disposition: inline
In-Reply-To: <1391689504-28160-1-git-send-email-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 06, 2014 at 01:25:01PM +0100, Ard Biesheuvel wrote:
> My apologies if this has been discussed/debated before on linux-crypto.
> 
> When working on accelerated crypto for ARM and arm64, I noticed that many of
> the existing accelerated implementations for other architectures duplicate much
> of the chaining modes, not because they can be accelerated themselves but mainly
> because the generic chaining mode implementations cannot present the data in
> large enough chunks for the accelerated implementations to reach their optimal
> speed.
> 
> This series proposes a way to improve on that. I have only implemented the CBC
> example because it makes for nice a benchmark, but CTR and XTS are other obvious
> candidates for the treatment.
> 
> I have included my arm64 AES cipher implementation for reference.

We can already do this using the existing blkcipher interface
if the underlying accelerated implementation exports an ECB
version of itself.

So if we're going to do this I'd like to see CBC/CTR/XTS simply
be modified to use ecb(X) instead of X where appropriate.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
