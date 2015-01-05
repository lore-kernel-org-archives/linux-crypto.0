From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AEAD: add check for presence of auth tag
Date: Mon, 5 Jan 2015 21:39:57 +1100
Message-ID: <20150105103957.GA25307@gondor.apana.org.au>
References: <15957213.Wu7Np8vQse@tachyon.chronox.de>
 <20150105101901.GA24736@gondor.apana.org.au>
 <7639295.Yx6QIQScqO@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: 'LKML' <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:42402 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbbAEKkA (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Jan 2015 05:40:00 -0500
Content-Disposition: inline
In-Reply-To: <7639295.Yx6QIQScqO@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 05, 2015 at 11:26:48AM +0100, Stephan Mueller wrote:
>
> Could you please help me understand where that check should be and what should 
> be done at the crypto API level?

All I was asking for is a length check like the one at the top
of crypto_authenc_decypt.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
