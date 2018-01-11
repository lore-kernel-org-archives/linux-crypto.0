From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: Getting the ccree driver out of staging
Date: Thu, 11 Jan 2018 08:33:00 +0200
Message-ID: <CAOtvUMcntBo_H5bRJWooV7mrw7u0xfxUN9fe2-pkPU-b6yWdFQ@mail.gmail.com>
References: <CAOtvUMdo_ZJ-M-=apA1a=70KyVBX2J0pEVc+Uc9i=rYWCie6Hw@mail.gmail.com>
 <20180110163926.GA25674@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        devel@driverdev.osuosl.org, driverdev-devel@linuxdriverproject.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Ofir Drang <Ofir.Drang@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:40764 "EHLO
        mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932065AbeAKGdB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jan 2018 01:33:01 -0500
Received: by mail-oi0-f51.google.com with SMTP id u83so981955oie.7
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jan 2018 22:33:01 -0800 (PST)
In-Reply-To: <20180110163926.GA25674@kroah.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 10, 2018 at 6:39 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 10, 2018 at 08:54:55AM +0200, Gilad Ben-Yossef wrote:
>> Hi folks,
>>
>> With the enormous help of people in the to and CCed lists I've gotten
>> the ccree driver to a point I believe it is ready to graduate out of
>> the staging tree:
>>
>> - The code base has been reduced by something by 30% and is *much*
>> more  readable and manageable.
>> - The very few checkpatch warnings are all false positives (one due to
>> dt bindings going through the crypto tree, the others due to harmless
>> macro argument reuse)
>> and the few sparse output are equally benign.
>> - The driver follows the crypto API expected behavior as much as I can tell.
>> - Fixed all the bugs I could fine as a result of tcrypt tests.
>> - It works :-)
>>
>> There are obviously more things todo, but I believe they are out of
>> scope for staging.
>>
>> So, if you see something that still needs work, kindly let me know.
>> Alternatively, will you accept a patch moving it to drivers/crypto/?
>
> It might make more sense to just send a "new" patch adding the driver to
> drivers/crypto/ and if that is accepted, we can drop it from staging.
> That way it's easier for the crypto developers to review it.
>
> But it's up to them, whatever they want is fine with me.

Thanks, Greg.

Herbert, it's up to you - shall I send a new patch set or do you want to just
move what's in the staging tree?

Thanks,
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
