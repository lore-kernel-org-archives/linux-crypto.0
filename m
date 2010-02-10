From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Wed, 10 Feb 2010 14:16:36 +0200
Message-ID: <4B72A3A4.4050700@nokia.com>
References: <20100209074146.GA17681@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56531 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425Ab0BJMRm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Feb 2010 07:17:42 -0500
In-Reply-To: <20100209074146.GA17681@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Anyway, crypto driver is called with CRYPTO_TFM_REQ_MAY_SLEEP flag set.
It basically mean it can sleep.
But it is not because of kmap_atomic()

So no possibility to know if to use GFP_KERNEL or GFP_ATOMIC.

I guess that is not correct way.

If driver cannot sleep then CRYPTO_TFM_REQ_MAY_SLEEP should not be set
when calling it.

Even sync implementation might use HW and sleep a bit while HW is doing
calculation...


- Dmitry

ext Herbert Xu wrote:
> Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
>   
>> One interesting issue
>>
>> Many clients in the kernel set CRYPTO_TFM_REQ_MAY_SLEEP to desc.flags.
>> It is used by crypto_yeld().
>>     
>
> That flag is really only meaningful for synchronous implementations.
>
> For hardware crypto that is asynchronous, you can simply ignore it
> in most cases (exceptions include invoking a syncrhonous backup, for
> example).
>
> Cheers,
>   
