From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 01/11] crypto: Documentation - crypto API high level
 spec
Date: Mon, 3 Nov 2014 09:53:04 -0600
Message-ID: <5457A4E0.30109@amd.com>
References: <6375771.bx7QqLJLuR@tachyon.chronox.de>
 <4163724.RCMDlx8dmE@tachyon.chronox.de> <20141103083439.635f5cb6@lwn.net>
 <4303532.NGaUQ44sQJ@tachyon.chronox.de>
 <20141103144925.GA31688@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Stephan Mueller <smueller@chronox.de>,
	Jonathan Corbet <corbet@lwn.net>,
	"David S. Miller" <davem@davemloft.net>,
	Marek Vasut <marex@denx.de>,
	"Jason Cooper" <cryptography@lakedaemon.net>,
	Grant Likely <grant.likely@secretlab.ca>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0123.outbound.protection.outlook.com ([207.46.100.123]:14638
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751922AbaKCQIF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 3 Nov 2014 11:08:05 -0500
In-Reply-To: <20141103144925.GA31688@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/03/2014 08:49 AM, Herbert Xu wrote:
> On Mon, Nov 03, 2014 at 03:18:29PM +0100, Stephan Mueller wrote:
>>
>>>> + * CRYPTO_ALG_TYPE_DIGEST	Raw message digest
>>>> + * CRYPTO_ALG_TYPE_HASH		Alias for CRYPTO_ALG_TYPE_DIGEST
>>>> + * CRYPTO_ALG_TYPE_SHASH	Synchronous multi-block hash
>>>> + * CRYPTO_ALG_TYPE_AHASH	Asynchronous multi-block hash
>>>> + * CRYPTO_ALG_TYPE_RNG		Random Number Generation
>>>> + * CRYPTO_ALG_TYPE_PCOMPRESS
>>>
>>> What's that last one?
>>
>> Same here.
>
> pcompress is an enhanced version of compress allowing for piece-meal
> compression/decompression rather than having to shove everything in
> all at once.
>
> Eventually pcompress should replace the compress interface once
> everything is converted across.

Herbert, I was looking at adding async support for ALG_TYPE_COMPRESS
since the CCP device will support compression/decompression but only
as an everything at once invocation.  Given what you're saying about
pcompress replacing compress, would this be something you'd even
consider though?

Thanks,
Tom

>
> Thanks,
>
