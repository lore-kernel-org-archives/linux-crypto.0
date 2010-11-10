From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: crypto ahash error handling
Date: Wed, 10 Nov 2010 16:54:51 +0200
Message-ID: <4CDAB23B.9000704@nokia.com>
References: <20101110122759.GA18577@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:52101 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756129Ab0KJOzW (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 10 Nov 2010 09:55:22 -0500
In-Reply-To: <20101110122759.GA18577@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is not good.

Driver might allocate some resources, which needs to be released.
crypto_ahash_final() should do some kind of "cleanup" task.

- Dmitry

On 10/11/10 14:27, ext Herbert Xu wrote:
> Dmitry Kasatkin <dmitry.kasatkin@nokia.com> wrote:
>   
>> Hello,
>>
>> When using crypto ahash API, is it necessary/mandatory to call
>> crypto_ahash_final() if crypto_ahash_update() returns error...
>>
>> Basically it might happen after several calls while calculating hash if
>> HW error happens.
>> It is not possible to continue hash calculation. it is necessary to
>> reset HW and start whole hash again..
>>
>> Any comments?
>>     
> From the driver's perspective you cannot expect that the user
> will call crypto_ahash_final in this case, or for that matter in
> any other case as the user is always free to leave a hash in
> an unfinalised state.
>
> Cheers,
>   
