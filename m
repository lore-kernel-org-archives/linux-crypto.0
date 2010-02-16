From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Tue, 16 Feb 2010 08:36:08 +0200
Message-ID: <4B7A3CD8.2000500@nokia.com>
References: <20100209074146.GA17681@gondor.apana.org.au> <4B72A3A4.4050700@nokia.com> <4B799E83.5000700@nokia.com> <20100216004430.GA26021@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:47191 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370Ab0BPGle (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2010 01:41:34 -0500
In-Reply-To: <20100216004430.GA26021@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

we have HW accelerator which can be accessed without DMA.
CPU just sequentially writes data to the port and then reads result.

But before it can read result Interrupt will happen to notify processing
completion.

Instead of looping over "ready" bit the process would just go to sleep:
wait_for_completion().

Can you please shortly tell why crypto_kmap() cannot be also like
GFP_KERNEL or GFP_ATOMIC?

Is it really important to have kmap_atomic()?

Thanks,
Dmitry


ext Herbert Xu wrote:
> On Mon, Feb 15, 2010 at 09:20:35PM +0200, Dmitry Kasatkin wrote:
>   
>> Hi,
>>
>> Alg code and drivers uses req/desc->flags to use GFP_KERNEL or GFP_ATOMIC.
>>
>> crypto_kmap() -> Does not it make a sense to also use kmap/kmap_atomic
>> instead of just kmap_atomic()?
>>     
>
> crypto_kmap is not meant for async drivers.  Why do you need it?
>
> Cheers,
>   
