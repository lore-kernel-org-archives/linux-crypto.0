From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 1/3] crypto: dh_helper - return unsigned int for
 dh_data_size()
Date: Tue, 3 Oct 2017 19:08:28 +0300
Message-ID: <e1fd27df-69eb-7516-ebac-862fd580bc6a@microchip.com>
References: <20170929092106.24276-1-tudor.ambarus@microchip.com>
 <22466.1507021562@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
        <keyrings@vger.kernel.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:36872 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdJCQIb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Oct 2017 12:08:31 -0400
In-Reply-To: <22466.1507021562@warthog.procyon.org.uk>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, David,

On 10/03/2017 12:06 PM, David Howells wrote:
> Tudor Ambarus <tudor.ambarus@microchip.com> wrote:
> 
>> -static inline int dh_data_size(const struct dh *p)
>> +static inline unsigned int dh_data_size(const struct dh *p)
>>   {
>>   	return p->key_size + p->p_size + p->g_size;
>>   }
> 
> If this is a problem, do you need to do range checking?

The algorithm does not impose any constraint in this direction, as far
as I'm aware of.

It's unnatural to return a signed integer in a function which just sums
unsigned integers. No checking is needed, the function should return the
unsigned result.

Cheers,
ta
