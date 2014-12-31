From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Using separate initcall level for crypto subsystem
Date: Thu, 1 Jan 2015 03:17:16 +1100
Message-ID: <20141231161716.GA30540@gondor.apana.org.au>
References: <EB9C4333-B282-4D94-9713-C986F1B7E931@holtmann.org>
 <20141223211716.GB3051@gondor.apana.org.au>
 <8E00673E-2A44-4DE4-8709-CBDADB6ADFB8@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Johan Hedberg <johan.hedberg@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:60507 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaLaQRW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 31 Dec 2014 11:17:22 -0500
Content-Disposition: inline
In-Reply-To: <8E00673E-2A44-4DE4-8709-CBDADB6ADFB8@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Dec 29, 2014 at 09:03:00PM -0800, Marcel Holtmann wrote:
>
> we can easily run them later on. However when the Bluetooth subsystem is built as module, then I would prefer to have the module loading fail in case one of the selftest fails. I can hack around this with a lot of ifdef config magic. If we would have all crypto, cipher etc. modules as crypto_initcall, then I would have to add nothing extra on my side. It would reduce the ifdef config magic on our side a lot.
> 
> My personal take is that the crypto subsystem has become such a basic feature that it might make sense to ensure that all pieces (including ciphers) are loaded before we initialize any other subsystem.

I don't think moving the crypto initcalls up is the answer because
moving the subsystem itself isn't enough if you actually want to
use crypto algorithms.

You'd need to move the algorithms too which would be a nightmare.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
