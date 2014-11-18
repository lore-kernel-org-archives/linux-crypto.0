From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 06/10] crypto: AF_ALG: make setkey optional
Date: Tue, 18 Nov 2014 22:10:13 +0800
Message-ID: <20141118141013.GC12100@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de>
 <2196615.OgfUNzPKdf@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
	LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, ABI/API <linux-api@vger.kernel.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34139 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbaKROKT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:19 -0500
Content-Disposition: inline
In-Reply-To: <2196615.OgfUNzPKdf@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Nov 16, 2014 at 03:26:58AM +0100, Stephan Mueller wrote:
> The current AF_ALG implementation requires that a userspace interface
> implementation must provide a callback for setkey. Such a call is not
> appliable to random number generators.
> 
> To prepare AF_ALG for the addition of a random number generator user
> space interface, this function callback invocation is made optional.
> 
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Did you actually try this? AFAICS setkey is already optional.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
