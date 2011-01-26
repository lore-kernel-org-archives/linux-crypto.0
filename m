From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: hash finup() issue
Date: Wed, 26 Jan 2011 09:47:27 +0200
Message-ID: <4D3FD18F.2020905@nokia.com>
References: <4D3ED3CF.4080205@nokia.com> <20110125232917.GA14972@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:19963 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594Ab1AZHsX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 26 Jan 2011 02:48:23 -0500
In-Reply-To: <20110125232917.GA14972@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I am not talking about user space API at all.

I talk about kernel crypto API and kernel clients.

Please understand the following: when update() is called driver does not
know if it is last update or not...
That is essential.
If client code would always use update/finup then it is fine..
But original API and clients uses update/final...
That is why some way (flag) needed to tell if finup() will be used or not...

It gave up 20% performance improvement in some case because no extra
memcpy has been done...

If you think about other solution, please share...

Have a nice day,

- Dmitry


On 26/01/11 01:29, ext Herbert Xu wrote:
> On Tue, Jan 25, 2011 at 03:44:47PM +0200, Dmitry Kasatkin wrote:
>> What we have done in our system is introduced a new flag which is set to
>> request.
>> flags |= CRYPTO_TFM_REQ_USE_FINUP;
>> ahash_request_set_callback(req, flags,  tcrypt_complete, &tresult);
> We don't need a flag for this, we just need to optimise the
> user-interface code to actually use finup when MSG_MORE is not
> set.
>
> Cheers,
