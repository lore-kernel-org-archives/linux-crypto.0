From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v1 3/3] crypto: ccp - Protect against poorly marked end
 of sg list
Date: Wed, 27 May 2015 09:12:02 -0500
Message-ID: <5565D0B2.8070708@amd.com>
References: <20150527094305.GA28142@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0117.outbound.protection.outlook.com ([157.56.110.117]:39904
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751542AbbE0OM0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 10:12:26 -0400
In-Reply-To: <20150527094305.GA28142@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/27/2015 04:43 AM, Herbert Xu wrote:
> Tom Lendacky <thomas.lendacky@amd.com> wrote:
>> Scatter gather lists can be created with more available entries than are
>> actually used (e.g. using sg_init_table() to reserve a specific number
>> of sg entries, but in actuality using something less than that based on
>> the data length).  The caller sometimes fails to mark the last entry
>> with sg_mark_end().  In these cases, sg_nents() will return the original
>> size of the sg list as opposed to the actual number of sg entries that
>> contain valid data.
>>
>> On arm64, if the sg_nents() value is used in a call to dma_map_sg() in
>> this situation, then it causes a BUG_ON in lib/swiotlb.c because an
>> "empty" sg list entry results in dma_capable() returning false and
>> swiotlb trying to create a bounce buffer of size 0. This occurred in
>> the userspace crypto interface before being fixed by
>>
>> 0f477b655a52 ("crypto: algif - Mark sgl end at the end of data")
>>
>> Protect against this in the future by counting the number of sg entries
>> needed to meet the length requirement and supplying that value to
>> dma_map_sg().
>
> Is this needed for any reason other than this bug that's already
> been fixed?
>

I added this just to protect against any other users of the API that
may do something similar in the future (or if the user should re-use
an sg list and leave leftover sg entries in it). Since software
crypto implementations walk the sg list based on length and do not use
DMA mappings it is possible for this bug to pop up again in another
location since it is likely that the testing won't be done with
hardware crypto devices.

> The reason I'm asking is because while this patch fixes your driver
> everybody else will still crash and burn should something like this
> happen again.

A number of other drivers already have similar sg-count functions in
them.

I'm ok if you decide that this patch shouldn't be applied. It's just
that this is typically an issue that won't be found until after the
release of a kernel rather than during the development stages.

Thanks,
Tom

>
> Cheers,
>
