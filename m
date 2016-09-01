From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCHv3 03/11] crypto: omap-sham: implement context
 export/import APIs
Date: Thu, 1 Sep 2016 09:12:59 +0300
Message-ID: <60a5ed40-5552-3ec8-fa21-7e6fb8213fc3@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-4-git-send-email-t-kristo@ti.com>
 <20160809100633.GA6751@gondor.apana.org.au>
 <d828fca9-a97a-7722-c4cb-24e07816cbc4@ti.com>
 <20160901033320.GA650@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <lokeshvutla@ti.com>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:45125 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751948AbcIAGNp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 02:13:45 -0400
In-Reply-To: <20160901033320.GA650@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/09/16 06:33, Herbert Xu wrote:
> On Mon, Aug 29, 2016 at 05:11:35PM +0300, Tero Kristo wrote:
>>
>>>> +static int omap_sham_export(struct ahash_request *req, void *out)
>>>> +{
>>>> +	struct omap_sham_reqctx *rctx = ahash_request_ctx(req);
>>>> +
>>>> +	while (omap_sham_flush(req) == -EINPROGRESS)
>>>> +		msleep(10);
>>>
>>> Do we really need this? You must not call export until the previous
>>> operation has completed.
>>>
>>> Cheers,
>>>
>>
>> Sorry about a late reply, I was out on vacation.
>>
>> For OMAP SHAM, this is actually needed, because the driver still has
>> a very large internal buffer for performance reasons, and the whole
>> buffer can't be exported. The flush functionality pushes out
>> sufficient amount of data to the hardware, so that the rest of the
>> buffer can be exported to the available space.
>
> It doesn't matter whether you have a buffer or not.  The point
> is that the completion function should not be called until the
> operation is actually complete.  This is the whole point of the
> async interface.
>
> As the user must not call export until the completion function
> has been called, there should be no need to wait in the export
> function.

Well, but the driver doesn't flush its buffers automatically, it caches 
data until it has sufficient amount available. So, assuming you want to 
do this:

sham_init
   sham_update 256 bytes
   sham_update 256 bytes
   wait until two above updates are complete
   sham_export

... the execution hangs at the wait phase as the driver is still waiting 
for more data to cache, and will never complete the two update requests. 
Currently, the driver is written in such way that it waits until it has 
enough data cached before starting to push it out to hardware, or waits 
until sham_final to be called. Pushing out small pieces of data causes 
severe performance degradation on the driver, as setting up the DMA 
operation itself is rather costly.

Either way, flush for the buffers is needed, I wonder if automatic flush 
should be added also based on some timer.

-Tero
