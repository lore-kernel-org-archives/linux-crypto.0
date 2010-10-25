From: Mark Allyn <allyn@well.com>
Subject: Re: Questions about ahash
Date: Mon, 25 Oct 2010 16:51:05 -0700 (PDT)
Message-ID: <Pine.GSO.4.64.1010251647580.2377@well.com>
References: <20101025234206.GA6046@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: "Allyn, Mark A" <mark.a.allyn@intel.com>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.well.com ([208.17.81.207]:44324 "EHLO smtp.well.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757170Ab0JYXvL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Oct 2010 19:51:11 -0400
In-Reply-To: <20101025234206.GA6046@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Herbert:

Perhaps this is very fundamential, but what is the difference between
synchronous and asynchronous as far as crypto is concerned? My device
performs encryption and decryption asynchronously in relation to
the main processor in the system. The driver tells the device to
do x, then goes away and does other stuff, then gets an interrupt
when the device is done and ready.

The user space app waits for the device to finish, but the kernel
is doing other stuff in the meantime.


Truly,

Mark Allyn
Portland, Oregon
www.allyn.com
971-563-7588

> You should use shash only if your hardware is synchronous, e.g.,
> the AESNI instruction is a good example where a synchronous
> interface is appropriate.
>
> The reason crypto_ahash is so different is because it should be
> used where you need an asynchronous interface, where state has
> to be stored indefinitely.
