From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCHv3 03/11] crypto: omap-sham: implement context
 export/import APIs
Date: Mon, 5 Sep 2016 15:06:05 +0300
Message-ID: <0e19ed55-f24b-ad98-215b-1eb318193f06@ti.com>
References: <1470306526-27219-1-git-send-email-t-kristo@ti.com>
 <1470306526-27219-4-git-send-email-t-kristo@ti.com>
 <20160809100633.GA6751@gondor.apana.org.au>
 <d828fca9-a97a-7722-c4cb-24e07816cbc4@ti.com>
 <20160901033320.GA650@gondor.apana.org.au>
 <60a5ed40-5552-3ec8-fa21-7e6fb8213fc3@ti.com>
 <20160901061630.GB650@gondor.apana.org.au>
 <70468d4d-9f26-1bad-ace1-4b7c5cf43b52@ti.com>
 <20160901071958.GA2076@gondor.apana.org.au>
 <4c45de7f-002c-48b5-c950-f445354adb09@ti.com>
 <20160901073113.GA2232@gondor.apana.org.au>
 <9af173f7-cc94-a92f-80ee-c746d97ab110@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <lokeshvutla@ti.com>, <davem@davemloft.net>,
        <linux-crypto@vger.kernel.org>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38465 "EHLO
        devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754768AbcIEMGm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2016 08:06:42 -0400
In-Reply-To: <9af173f7-cc94-a92f-80ee-c746d97ab110@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/09/16 10:46, Tero Kristo wrote:
> On 01/09/16 10:31, Herbert Xu wrote:
>> On Thu, Sep 01, 2016 at 10:28:47AM +0300, Tero Kristo wrote:
>>>
>>> Yeah, the flush should do the trick now. Kind of a chicken-egg
>>> problem here. :P How do you see the situation with the above
>>> explanation?
>>
>> The export function is not allowed to sleep so you must not wait
>> for the hardware to complete in it.
>>
>> If you need to wait, then you must use the completion mechanism.
>
> I don't think export is allowed to return -EINPROGRESS either? At least
> currently the kernel pieces using this functionality won't work if I do
> that.
>
> If thats the case, I need to think of something else to handle this...
>
> -Tero
>

Hi Herbert,

Additional request, would it be possible for you to check the rest of 
the series and just ignore patches #2 and #3 for now, the rest don't 
have any dependencies against these and can be applied cleanly without.

I would like to see these move forward while I figure out how to handle 
the buffer / export+import...

-Tero
