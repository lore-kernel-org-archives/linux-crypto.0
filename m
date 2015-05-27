From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v1 3/3] crypto: ccp - Protect against poorly marked end
 of sg list
Date: Wed, 27 May 2015 09:15:16 -0500
Message-ID: <5565D174.5070107@amd.com>
References: <20150526180635.6527.5580.stgit@tlendack-t1.amdoffice.net>
 <20150527094305.GA28142@gondor.apana.org.au>
 <20150527094554.GA28211@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1bbn0101.outbound.protection.outlook.com ([157.56.111.101]:22112
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752133AbbE0OPc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 May 2015 10:15:32 -0400
In-Reply-To: <20150527094554.GA28211@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 05/27/2015 04:45 AM, Herbert Xu wrote:
> On Wed, May 27, 2015 at 05:43:05PM +0800, Herbert Xu wrote:
>> Tom Lendacky <thomas.lendacky@amd.com> wrote:
>>> Scatter gather lists can be created with more available entries than are
>>> actually used (e.g. using sg_init_table() to reserve a specific number
>>> of sg entries, but in actuality using something less than that based on
>>> the data length).  The caller sometimes fails to mark the last entry
>>> with sg_mark_end().  In these cases, sg_nents() will return the original
>>> size of the sg list as opposed to the actual number of sg entries that
>>> contain valid data.
>>>
>>> On arm64, if the sg_nents() value is used in a call to dma_map_sg() in
>>> this situation, then it causes a BUG_ON in lib/swiotlb.c because an
>>> "empty" sg list entry results in dma_capable() returning false and
>>> swiotlb trying to create a bounce buffer of size 0. This occurred in
>>> the userspace crypto interface before being fixed by
>>>
>>> 0f477b655a52 ("crypto: algif - Mark sgl end at the end of data")
>>>
>>> Protect against this in the future by counting the number of sg entries
>>> needed to meet the length requirement and supplying that value to
>>> dma_map_sg().
>>
>> Is this needed for any reason other than this bug that's already
>> been fixed?
>
> Could this be needed if you have a properly marked SG list say of
> 100 bytes but len is only 10 bytes?

I don't think that situation matters because the DMA mapping should
succeed just fine at 100 bytes even if only needing/using 10 bytes.

Thanks,
Tom

>
> Cheers,
>
