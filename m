From: Michal Ludvig <michal@logix.cz>
Subject: Re: PadLock XSHA
Date: Sat, 30 Aug 2008 21:55:00 +1200
Message-ID: <48B918F4.9030604@logix.cz>
References: <20080830084316.GA19371@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bubetka.logix.cz ([208.84.148.239]:36987 "EHLO maxipes.logix.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750777AbYH3KOl (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 30 Aug 2008 06:14:41 -0400
In-Reply-To: <20080830084316.GA19371@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

> Can you remind me the reason why our PadLock SHA implementation
> copies things into a page before hashing it?
> 
> According to the programming manual, it would seem that the state
> should be recorded in EDI after each 64-byte block so we should
> be able to use the init/update/final model, no?
> 
> Or has the chip changed since we implemented it?

IIRC The first versions of VIA PadLock required the input data to be
aligned on 16-bytes boundaries and more importantly they always
finalised the hash. Therefore we had to collect all data before hashing
them.

The only way to allow for multiple updates before final() was through a
page fault, i.e. have a writable page followed by a non-accessible page,
put all the data that go into update() towards the end of the r/w page
and with some PadLock trickery run or resume hashing and tell it to hash
more than a page of input. As soon as it stepped to the non-accessible
space it would save the current state to memory and raise the page
fault. This has been implemented in OpenSSL padlock engine but am not
sure if we did it in the kernel as well. I doubt it.

AFAIK Recent versions of PadLock don't insist on finalising the hash and
 don't insist on input data alignment either and this workaround isn't
needed anymore. I don't know if VIA still sells their motherboard models
with the older CPUs or not.

HTH,

Michal
