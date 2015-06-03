From: Jay Monkman <jay.monkman@freescale.com>
Subject: Re: Crypto driver -DCP
Date: Wed, 3 Jun 2015 15:02:13 -0500
Message-ID: <556F5D45.9020809@freescale.com>
References: <554BBD05.3050807@freescale.com> <201505290300.36019.marex@denx.de> <20150529012359.GA15471@gondor.apana.org.au> <201505290329.59713.marex@denx.de> <20150529013211.GA15566@gondor.apana.org.au> <556DFC98.10406@smoothsmoothie.com> <20150603021135.GA2451@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Marek Vasut <marex@denx.de>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bn0109.outbound.protection.outlook.com ([157.56.110.109]:13373
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756081AbbFCUfQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 3 Jun 2015 16:35:16 -0400
In-Reply-To: <20150603021135.GA2451@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/02/2015 09:11 PM, Herbert Xu wrote:
> On Tue, Jun 02, 2015 at 01:57:28PM -0500, Jay Monkman wrote:
>>
>> I have another question. The DCP (and other crypto accelerators on
>> other SOCs) supports key slots - basically write only RAM that's
>> used to store keys so they can be used for encrypt/decrypt
>> operations. DCP supports 4 key slots, other devices have different
>> numbers. Do you have any suggestion for how to add support for
>> something like that to the driver?
>
> So these would allow faster switching of keys I presume?

That would be one use, but a more likely use would be to prevent access 
to the keys. A system could write keys to the key slots in the 
bootloader or in a TrustZone secure world. Then those keys could be used 
for crypto operations in Linux without ever exposing them. Key slots can 
be written to, but cannot be read from.

Even with keys stored in key slots, other keys may be used. For example, 
someone could do:
     operation w/ key in slot 1
     operation w/ key provided in descriptor
     operation w/ key in slot 1

I don't think an LRU scheme would allow something like that.
