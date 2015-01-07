From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Using separate initcall level for crypto subsystem
Date: Tue, 6 Jan 2015 18:30:36 -0800
Message-ID: <F6435F09-4F45-4C8E-BB48-E7FB13643CC1@holtmann.org>
References: <EB9C4333-B282-4D94-9713-C986F1B7E931@holtmann.org> <20141223211716.GB3051@gondor.apana.org.au> <8E00673E-2A44-4DE4-8709-CBDADB6ADFB8@holtmann.org> <20141231161716.GA30540@gondor.apana.org.au>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Johan Hedberg <johan.hedberg@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:59227 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbbAGCan convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 6 Jan 2015 21:30:43 -0500
In-Reply-To: <20141231161716.GA30540@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

>> we can easily run them later on. However when the Bluetooth subsystem is built as module, then I would prefer to have the module loading fail in case one of the selftest fails. I can hack around this with a lot of ifdef config magic. If we would have all crypto, cipher etc. modules as crypto_initcall, then I would have to add nothing extra on my side. It would reduce the ifdef config magic on our side a lot.
>> 
>> My personal take is that the crypto subsystem has become such a basic feature that it might make sense to ensure that all pieces (including ciphers) are loaded before we initialize any other subsystem.
> 
> I don't think moving the crypto initcalls up is the answer because
> moving the subsystem itself isn't enough if you actually want to
> use crypto algorithms.

that is indeed true. All the crypto algorithm need to be moved as well. I considered that already since I had debugged the initcall order with a kernel without modules.

> You'd need to move the algorithms too which would be a nightmare.

Actually I was thinking to convert the algorithms to a newly introduced module_crypto_alg() and module_crypto_shash() helpers.

This would be similar to module_usb_driver() and module_pci_driver(). And then changing the initcall level would be trivial. The module_init/module_exit is just all the same boilerplate anyway and we could get rid of it this way.

Regards

Marcel
