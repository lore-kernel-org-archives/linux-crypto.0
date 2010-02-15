From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: Possible bug: blkcipher_walk_done()
Date: Mon, 15 Feb 2010 21:02:35 +0200
Message-ID: <4B799A4B.4040904@nokia.com>
References: <4B727F75.20305@nokia.com> <20100214054756.GA9688@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:26896 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867Ab0BOTCv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Feb 2010 14:02:51 -0500
In-Reply-To: <20100214054756.GA9688@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Strange what you say.... if err < 0 the page are never mapped...

Pages mapped before... and they are not unmapped and mapped again...
So they left mapped..
And yes... if HW fails then it need to break the function and unmap
previously mapped pages.

I will submit patches for review soon to this list.

Thanks for your discussion!

- Dmitry

ext Herbert Xu wrote:
> On Wed, Feb 10, 2010 at 09:42:13AM +0000, Dmitry Kasatkin wrote:
>   
>> Hi,
>>
>> It seems that there is a mistake in the implementation of
>>
>> int blkcipher_walk_done(struct blkcipher_desc *desc,
>>             struct blkcipher_walk *walk, int err)
>>
>> blkcipher_walk_virt() will call crypto_kmap() to map page.
>>
>> But in the case then err argument is < 0 and we cannot continue then
>> blkcipher_walk_done() will not
>> unmap the page.
>>
>> What do you think?
>>     
>
> Only blkcipher.c itself calls blkcipher_walk_done with err < 0.
> Algorithms are not supposed to do that as this interface is only
> for synchronous implementations.
>
> When blkcipher.c uses it with err < 0 the pages are never mapped.
>
> Do you need to be able to fail with a synchronous algorithm?
>
> Cheers,
>   
