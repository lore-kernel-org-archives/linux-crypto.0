From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCHv3 03/11] crypto: omap-sham: implement context
 export/import APIs
Date: Thu, 1 Sep 2016 09:56:06 +0300
Message-ID: <70468d4d-9f26-1bad-ace1-4b7c5cf43b52@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-4-git-send-email-t-kristo@ti.com>
 <20160809100633.GA6751@gondor.apana.org.au>
 <d828fca9-a97a-7722-c4cb-24e07816cbc4@ti.com>
 <20160901033320.GA650@gondor.apana.org.au>
 <60a5ed40-5552-3ec8-fa21-7e6fb8213fc3@ti.com>
 <20160901061630.GB650@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <lokeshvutla@ti.com>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:47714 "EHLO comal.ext.ti.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753418AbcIAG4q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2016 02:56:46 -0400
In-Reply-To: <20160901061630.GB650@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/09/16 09:16, Herbert Xu wrote:
> On Thu, Sep 01, 2016 at 09:12:59AM +0300, Tero Kristo wrote:
>>
>> Well, but the driver doesn't flush its buffers automatically, it
>> caches data until it has sufficient amount available. So, assuming
>> you want to do this:
>>
>> sham_init
>>   sham_update 256 bytes
>>   sham_update 256 bytes
>>   wait until two above updates are complete
>>   sham_export
>>
>> ... the execution hangs at the wait phase as the driver is still
>
> Well that's a bug in the driver.  While it's not illegal to wait
> for more data, it's usually unnecessary.  Because we instead try
> to get our users to generate as big a request as possible, e.g.,
> one packet for IPsec.
>
> If you really have to do the hold thing, then you must install a
> timer like sha1-mb does on x86 to do the flush.
>
> In any case, the completion function must not be called until
> you're actually complete.

Hmm, looking at the driver, sham_update returns 0 immediately if it just 
caches data. In a sense, the update is not completed at this point. Are 
you saying this is illegal and can't be done?

 From my understanding, valid results are expected from the driver only 
after ->final is called.

-Tero
