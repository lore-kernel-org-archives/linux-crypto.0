From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2] dm: switch dm-verity to async hash crypto API
Date: Sun, 19 Feb 2017 14:37:26 +0200
Message-ID: <CAOtvUMeyb000nM6EQZk+Yf+XOw2dUkuQvoyZEEnKzDrtSq+V1Q@mail.gmail.com>
References: <1486389482-26992-1-git-send-email-gilad@benyossef.com>
 <74bc1a00-6fb4-4b2f-b57b-a7fea0969eeb@gmail.com> <CAOtvUMc7s-ymufSiEty-vifcp12_TMnVMq6=mLcuz60T7RgnNQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dm-devel@redhat.com, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-crypto@vger.kernel.org, gilad.benyossef@arm.com,
        Ofir Drang <ofir.drang@arm.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?=
        <omosnacek+linux-crypto@gmail.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-it0-f46.google.com ([209.85.214.46]:35950 "EHLO
        mail-it0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751405AbdBSMh1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 19 Feb 2017 07:37:27 -0500
Received: by mail-it0-f46.google.com with SMTP id h10so52771464ith.1
        for <linux-crypto@vger.kernel.org>; Sun, 19 Feb 2017 04:37:27 -0800 (PST)
In-Reply-To: <CAOtvUMc7s-ymufSiEty-vifcp12_TMnVMq6=mLcuz60T7RgnNQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 17, 2017 at 4:47 PM, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> Hi Milan,
>
> Thank you for the review and testing.
>
> On Fri, Feb 17, 2017 at 3:00 PM, Milan Broz <gmazyland@gmail.com> wrote:
>>
>> On 02/06/2017 02:58 PM, Gilad Ben-Yossef wrote:
>> > Use of the synchronous digest API limits dm-verity to using pure
>> > CPU based algorithm providers and rules out the use of off CPU
>> > algorithm providers which are normally asynchronous by nature,
>> > potentially freeing CPU cycles.
>> >
>> > This can reduce performance per Watt in situations such as during
>> > boot time when a lot of concurrent file accesses are made to the
>> > protected volume.
>> >
>> > Move DM_VERITY to the asynchronous hash API.
>>
>> Did you test that async hash completion path?
>>
> Yes, I did - with the Arm TrustZone CryptoCell hardware accelerator.
> I did not try with cryptd though.
>
>
>>
>> I just tried to force async crypto by replacing "sha256"
>> in mapping table with "cryptd(sha256-generic)" and it kills
>> kernel immediately.
>> https://mbroz.fedorapeople.org/tmp/verity-fail.png
>>
>> (I hope this trick should cause to use cryptd and use async processing.
>> In previous version the parameter is properly rejected, because
>> unsupported
>> by shash api.)
>>
>>
>
> Thanks for this trick. I was not aware you can invoke cryptd it like that.
>
> I will recreate the issue and fix it.

I found out what the problem was and why I haven't seen it  - I
thought crypto_ahash_init() only
sets up internal data structures and such and doesn't talk to the
device and therefore never
goes in the asynchronous completion path, which is true for the
hardware based provider
I was using for testing and probably for other HW based providers as well.

BUT, it isn't true for cryptd, which I guess uses the init function to
spawn kernel threads and does
use the asynchronous code path there.

Thanks for the review and testing. The next revision is coming up in a
jiffie. I'd be delighted if you
can take it out for a spin.

Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
