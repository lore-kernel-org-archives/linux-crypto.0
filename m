From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: crypto_shash_update & CRYPTO_TFM_REQ_MAY_SLEEP
Date: Tue, 09 Feb 2010 10:45:31 +0200
Message-ID: <4B7120AB.8010201@nokia.com>
References: <20100209074146.GA17681@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:27301 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334Ab0BIIqR (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Feb 2010 03:46:17 -0500
In-Reply-To: <20100209074146.GA17681@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Ok...

But normally kernel client code uses sync API as shash.

And I provide async hw driver via async ahash API.
That is simply will not be used at all.

Client must be changed to use async ahash API in order to benefit from
HW crypto.

Right?

Thanks,
Dmitry


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
