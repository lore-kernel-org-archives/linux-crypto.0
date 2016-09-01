From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCHv3 03/11] crypto: omap-sham: implement context
 export/import APIs
Date: Thu, 1 Sep 2016 10:28:47 +0300
Message-ID: <4c45de7f-002c-48b5-c950-f445354adb09@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-4-git-send-email-t-kristo@ti.com>
 <20160809100633.GA6751@gondor.apana.org.au>
 <d828fca9-a97a-7722-c4cb-24e07816cbc4@ti.com>
 <20160901033320.GA650@gondor.apana.org.au>
 <60a5ed40-5552-3ec8-fa21-7e6fb8213fc3@ti.com>
 <20160901061630.GB650@gondor.apana.org.au>
 <70468d4d-9f26-1bad-ace1-4b7c5cf43b52@ti.com>
 <20160901071958.GA2076@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <lokeshvutla@ti.com>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:56701 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751589AbcIAH31 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 03:29:27 -0400
In-Reply-To: <20160901071958.GA2076@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/09/16 10:19, Herbert Xu wrote:
> On Thu, Sep 01, 2016 at 09:56:06AM +0300, Tero Kristo wrote:
>>
>> Hmm, looking at the driver, sham_update returns 0 immediately if it
>> just caches data. In a sense, the update is not completed at this
>> point. Are you saying this is illegal and can't be done?
>
> Once you call the completion function (and returning zero from
> the update itself is equivalent to calling the completion function)
> the hardware must not touch the request anymore.

Yeah, it is not touching it anymore. All the data has been copied to the 
local buffer at this point, and the driver isn't retaining any kind of a 
handle to the request itself anymore. It is just that it has not been 
processed by the hardware yet.

>
>> From my understanding, valid results are expected from the driver
>> only after ->final is called.
>
> That's because you never implemented export/import :)

Yeah, the flush should do the trick now. Kind of a chicken-egg problem 
here. :P How do you see the situation with the above explanation?


-Tero
