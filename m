From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCHv3 06/11] crypto: omap-des: Fix support for unequal lengths
Date: Thu, 15 Sep 2016 12:15:28 +0300
Message-ID: <a1b80dda-f344-c09d-4165-bfbd92e669fd@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-7-git-send-email-t-kristo@ti.com>
 <20160913093506.GA30561@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <lokeshvutla@ti.com>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Lokesh Vutla <a0131933@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:47722 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757554AbcIOJQF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 15 Sep 2016 05:16:05 -0400
In-Reply-To: <20160913093506.GA30561@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 13/09/16 12:35, Herbert Xu wrote:
> On Thu, Aug 04, 2016 at 01:28:41PM +0300, Tero Kristo wrote:
>> From: Lokesh Vutla <a0131933@ti.com>
>>
>> For cases where total length of an input SGs is not same as
>> length of the input data for encryption, omap-des driver
>> crashes. This happens in the case when IPsec is trying to use
>> omap-des driver.
>>
>> To avoid this, we copy all the pages from the input SG list
>> into a contiguous buffer and prepare a single element SG list
>> for this buffer with length as the total bytes to crypt, which is
>> similar thing that is done in case of unaligned lengths.
>
> Ugh, that means copying every single packet, right?
>
> So if it's just the SG list that's the problem, why don't you
> copy that instead? That is, allocate a new SG list and set it
> up so that there is no excess data.
>
> Cheers,
>

I'll take a look at this. I have this kind of solution in place for the 
re-worked SHA driver, so can probably re-use it here.

-Tero
