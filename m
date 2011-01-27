From: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: hash finup() issue
Date: Thu, 27 Jan 2011 08:47:40 +0200
Message-ID: <4D41150C.90806@nokia.com>
References: <4D3ED3CF.4080205@nokia.com> <20110125232917.GA14972@gondor.apana.org.au> <4D3FD18F.2020905@nokia.com> <20110126233217.GA26664@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: ext Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:17707 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab1A0Grq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 27 Jan 2011 01:47:46 -0500
In-Reply-To: <20110126233217.GA26664@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

No.no.. That is not a flag for particular request...
The flag is how total hash will be handled...

FINUP flag means that client will call finup().
So it will be

update()
update()
...
update()
finup()


not
update()
...
update()
final()...

In other words...
update() means that it will be more data coming (like MSG_MORE)
finup() is just final update...

Basically driver on update() will not do extra buffering..

Is it clear now?

How would you solve such issue?

- Dmitry

On 27/01/11 01:32, ext Herbert Xu wrote:
> On Wed, Jan 26, 2011 at 09:47:27AM +0200, Dmitry Kasatkin wrote:
>> I am not talking about user space API at all.
>>
>> I talk about kernel crypto API and kernel clients.
>>
>> Please understand the following: when update() is called driver does not
>> know if it is last update or not...
>> That is essential.
>> If client code would always use update/finup then it is fine..
>> But original API and clients uses update/final...
>> That is why some way (flag) needed to tell if finup() will be used or not...
>>
>> It gave up 20% performance improvement in some case because no extra
>> memcpy has been done...
>>
>> If you think about other solution, please share...
> If the crypto user can set the FINUP flag then it can just call
> finup, simple.
>
> Cheers,
