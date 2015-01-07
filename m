From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Using separate initcall level for crypto subsystem
Date: Wed, 7 Jan 2015 14:15:35 +1100
Message-ID: <20150107031535.GA25465@gondor.apana.org.au>
References: <EB9C4333-B282-4D94-9713-C986F1B7E931@holtmann.org>
 <20141223211716.GB3051@gondor.apana.org.au>
 <8E00673E-2A44-4DE4-8709-CBDADB6ADFB8@holtmann.org>
 <20141231161716.GA30540@gondor.apana.org.au>
 <F6435F09-4F45-4C8E-BB48-E7FB13643CC1@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Johan Hedberg <johan.hedberg@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:34582 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbbAGDQP (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Jan 2015 22:16:15 -0500
Content-Disposition: inline
In-Reply-To: <F6435F09-4F45-4C8E-BB48-E7FB13643CC1@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 06, 2015 at 06:30:36PM -0800, Marcel Holtmann wrote:
>
> that is indeed true. All the crypto algorithm need to be moved as well. I considered that already since I had debugged the initcall order with a kernel without modules.

If there were a real user then I would consider it.  I'm definitely
not adding this much complexity just for a self-test.

> Actually I was thinking to convert the algorithms to a newly introduced module_crypto_alg() and module_crypto_shash() helpers.
> 
> This would be similar to module_usb_driver() and module_pci_driver(). And then changing the initcall level would be trivial. The module_init/module_exit is just all the same boilerplate anyway and we could get rid of it this way.

I'm OK with this though if it turns out to reduce the amount of
code.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
