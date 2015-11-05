From: Harsh Jain <harshjain.prof@gmail.com>
Subject: Re: [PATCH v2] crypto: algif_hash - Only export and import on sockets
 with data
Date: Thu, 5 Nov 2015 13:12:04 +0530
Message-ID: <CAFXBA==77BA3aF6UzjK+s6P+Aw7HRy7-xELn6oiyOFgWjdAKvw@mail.gmail.com>
References: <CAFXBA=mVmRsAk3fuyjf3WA-P+0dHKu0upUdb5Qxr0kwn1rKiDw@mail.gmail.com>
	<2587504.xtsMOV5mei@myon.chronox.de>
	<20151101091119.GA3035@gondor.apana.org.au>
	<1470343.4RyZqhtxup@myon.chronox.de>
	<20151102031204.GA7372@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35273 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161148AbbKEHmG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Nov 2015 02:42:06 -0500
Received: by lfbn126 with SMTP id n126so53847829lfb.2
        for <linux-crypto@vger.kernel.org>; Wed, 04 Nov 2015 23:42:04 -0800 (PST)
In-Reply-To: <20151102031204.GA7372@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi herbert,

Which kernel versions will have this patch?

Regards
Harsh Jain

On Mon, Nov 2, 2015 at 8:42 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Sun, Nov 01, 2015 at 12:07:12PM +0100, Stephan Mueller wrote:
>> Am Sonntag, 1. November 2015, 17:11:19 schrieb Herbert Xu:
>>
>> Hi Herbert,
>>
>> > On Sat, Oct 31, 2015 at 12:45:47AM +0100, Stephan Mueller wrote:
>> > > Testing complete: patch solves the oops and allows to successfully perform
>> > > HMAC even when having subsequent accepts and operating on those subsequent
>> > > accepts.
>> >
>> > Thanks Stephan!
>> >
>> > Unfortunately my patch is incomplete as some other thread could
>> > change ctx->more while we're in the middle of the accept call.
>> >
>> > So here is an updated version.
>>
>> Shouldn't that patch to into stable (and hopefully into 4.3) as well?
>
> Yes it is going into stable.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
