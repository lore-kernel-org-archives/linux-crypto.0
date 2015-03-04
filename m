From: yjin <yanjiang.jin@windriver.com>
Subject: Re: [PATCH 1/3] crypto: caam: fix some compile warnings
Date: Wed, 4 Mar 2015 12:57:01 +0800
Message-ID: <54F6909D.8040002@windriver.com>
References: <1425365453-19358-1-git-send-email-yanjiang.jin@windriver.com>	<1425365453-19358-2-git-send-email-yanjiang.jin@windriver.com> <20150303125953.8585904680288a9734566b42@freescale.com> <54F66EA3.7080506@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <horia.geanta@freescale.com>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <ruchika.gupta@freescale.com>,
	<cristian.stoica@freescale.com>, <NiteshNarayanLal@freescale.com>,
	<linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<jinyanjiang@gmail.com>
To: Kim Phillips <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:50161 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbbCDE6c (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 Mar 2015 23:58:32 -0500
In-Reply-To: <54F66EA3.7080506@windriver.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 2015=E5=B9=B403=E6=9C=8804=E6=97=A5 10:32, yjin wrote:
>
> On 2015=E5=B9=B403=E6=9C=8804=E6=97=A5 02:59, Kim Phillips wrote:
>> On Tue, 3 Mar 2015 14:50:51 +0800
>> <yanjiang.jin@windriver.com> wrote:
>>
>>> This commit is to avoid the below warnings:
>>>
>>> drivers/crypto/caam/sg_sw_sec4.h:88:12: warning:
>>> 'dma_map_sg_chained' defined but not used [-Wunused-function]
>>>   static int dma_map_sg_chained(struct device *dev, struct=20
>>> scatterlist *sg,
>>>              ^
>>> drivers/crypto/caam/sg_sw_sec4.h:104:12: warning:
>>> 'dma_unmap_sg_chained' defined but not used [-Wunused-function]
>>>   static int dma_unmap_sg_chained(struct device *dev,
>>>              ^
>> I'm not seeing these warnings - both caamalg.c and caamhash.c use
>> those functions fine.
>
> As you said, both caamalg.c and caamhash.c use those functions, so no=
=20
> warning reported.
>
> But if a new file just wants to include "sg_sw_sec4.h", doesn't want=20
> to use these functions, the above warnings will appear.
>
> We can find an example in Freescale SDK 1.6:
> caampkc.c includes pkc_desc.h, pkc_desc.h includes sg_sw_sec4.h, but=20
> caampkc.c doesn't call those functions.
>
> Without my patch, every file which includes sg_sw_sec4.h must call=20
> these two functions in the future, I don't think it is a good idea.
>
> Thanks!
> Yanjiang
>>
>>> -static int dma_map_sg_chained(struct device *dev, struct=20
>>> scatterlist *sg,
>>> +static inline int dma_map_sg_chained(struct device *dev, struct=20
>>> scatterlist *sg,
>>>                     unsigned int nents, enum dma_data_direction dir=
,
>>>                     bool chained)
>> not to mention this isn't how to fix a defined but not used warning:
>> marking the functions inline results in different compiler output.
>>
>> NACK from me.
An alternative is moving the definitions to a ".c" file, but I don't=20
think it will be fundamental different.
I know I am fixing a potential error which doesn't exist now, it seems=20
useless for the current upstream version, we can abandon my patch. But =
I=20
still think the current implementation adds unnecessary restrictions fo=
r=20
its users.

Thanks!
Yanjiang
>>
>> Kim
>>
>>
>
> --=20
> To unsubscribe from this list: send the line "unsubscribe=20
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
