From: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: Using separate initcall level for crypto subsystem
Date: Mon, 29 Dec 2014 21:03:00 -0800
Message-ID: <8E00673E-2A44-4DE4-8709-CBDADB6ADFB8@holtmann.org>
References: <EB9C4333-B282-4D94-9713-C986F1B7E931@holtmann.org> <20141223211716.GB3051@gondor.apana.org.au>
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Johan Hedberg <johan.hedberg@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:45735 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaL3FDG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 30 Dec 2014 00:03:06 -0500
In-Reply-To: <20141223211716.GB3051@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

>> we wanted to add some crypto selftests to the Bluetooth subsystem that checks our usage of the crypto handling we use for Bluetooth Low Energy Legacy Pairing and Secure Connections.
>> 
>> Since the Crypto subsystem and Bluetooth subsystem both use subsys_initcall that goes horrible wrong when running it built-in. So I wonder if it would make sense to introduce a crypto_initcall that comes before the subsys_initcall.
>> 
>> Any thoughts on this?
> 
> If it's just for self-tests would it be possible for them to be
> done after system boot-up?

we can easily run them later on. However when the Bluetooth subsystem is built as module, then I would prefer to have the module loading fail in case one of the selftest fails. I can hack around this with a lot of ifdef config magic. If we would have all crypto, cipher etc. modules as crypto_initcall, then I would have to add nothing extra on my side. It would reduce the ifdef config magic on our side a lot.

My personal take is that the crypto subsystem has become such a basic feature that it might make sense to ensure that all pieces (including ciphers) are loaded before we initialize any other subsystem.

Regards

Marcel
