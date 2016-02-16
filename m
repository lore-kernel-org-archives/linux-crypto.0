From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] Documentation: crypto API documentation updates
Date: Tue, 16 Feb 2016 20:17:46 +0000
Message-ID: <20160216201746.GA11908@gondor.apana.org.au>
References: <1550901.OUzcZboqul@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52985 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110AbcBPURu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 15:17:50 -0500
Content-Disposition: inline
In-Reply-To: <1550901.OUzcZboqul@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 16, 2016 at 11:31:26AM +0100, Stephan Mueller wrote:
> Hi,
> 
> This patch set updates the kernel crypto API documentation. Due to recent
> updates to the API, the documentation needs to be synchronized with the
> reality.
> 
> The output of the DocBook with these patches is found in [1].

All applied.  Thanks!

> Herbert: The documentation in include/crypto/skcipher.h references
> CRYPTO_ALG_TYPE_SKCIPHER which does (not yet?) exist. Shall that reference
> stay in the documentation?

It will come into existence when I create the algorithm interface
for skcipher.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
