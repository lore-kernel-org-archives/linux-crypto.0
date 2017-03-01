From: Ondrej Mosnacek <omosnace@redhat.com>
Subject: Re: [RFC PATCH v4] IV Generation algorithms for dm-crypt
Date: Wed, 1 Mar 2017 14:21:51 +0100
Message-ID: <CAFqZXNugEK0do+BYC061i4CidMVgg8_BZue8gUVa2g7_RYsAEw@mail.gmail.com>
References: <1486463731-6224-1-git-send-email-binoy.jayan@linaro.org>
 <CAOtvUMcN8s886978vE6T=AE79KkZsLBnXsmhewnb5PB0UyAG3A@mail.gmail.com>
 <CAHv-k_8rgArzV2uQ64h1ZTNRpssX1jMf=RwuPoBmsjQ0FhCsWA@mail.gmail.com>
 <68f70534-a309-46ba-a84d-8acc1e6620e5@gmail.com> <CAOtvUMf3c0fUjABmbfMrbs0W4gyhKVZyc_tZH3rQg65zF18YMg@mail.gmail.com>
 <b563eb97-82ba-69d2-c4c5-66bc716a7507@gmail.com> <CAOtvUMePYT7OJDKL7i0y3y6Jvqsxyx6Je6g9aGKVq6PLZ_-Z8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Milan Broz <gmazyland@gmail.com>,
        Binoy Jayan <binoy.jayan@linaro.org>,
        Oded <oded.golombek@arm.com>, Ofir <Ofir.Drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org,
        Rajendra <rnayak@codeaurora.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34058 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751529AbdCANWZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Mar 2017 08:22:25 -0500
Received: by mail-oi0-f47.google.com with SMTP id m124so22019161oig.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Mar 2017 05:21:52 -0800 (PST)
In-Reply-To: <CAOtvUMePYT7OJDKL7i0y3y6Jvqsxyx6Je6g9aGKVq6PLZ_-Z8w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

2017-03-01 13:42 GMT+01:00 Gilad Ben-Yossef <gilad@benyossef.com>:
> It really is an observation about overhead of context switches between
> dm-crypt and
> whatever/wherever you handle crypto - be it an off CPU hardware engine
> or a bunch
> of parallel kernel threads running on other cores. You really want to
> burst as much as
> possible.

[...]

>> For XTS you need just simple linear IV. No problem with that, implementation
>> in crypto API and hw is trivial.
>>
>> But for compatible IV (that provides compatibility with loopAES and very old TrueCrypt),
>> these should be never ever implemented again anywhere.
>
>>
>> Specifically "tcw" is broken, insecure and provided here just to help people to migrate
>> from old Truecrypt containers. Even Truecrypt followers removed it from the codebase.
>> (It is basically combination of IV and slight modification of CBC mode. All
>> recent version switched to XTS and plain IV.)
>>
>> So building abstraction over something known to be broken and that is now intentionally
>> isolated inside dmcrypt is, in my opinion, really not a good idea.
>>
>
> I don't think anyone is interested in these modes. How do you support
> XTS and essiv in
> a generic way without supporting this broken modes is not something
> I'm clear on though.

Wouldn't adopting a bulk request API (something like what I tried to
do here [1]) that allows users to supply multiple messages, each with
their own IV, fulfill this purpose? That way, we wouldn't need to
introduce any new modes into Crypto API and the drivers/accelerators
would only need to provide bulk implementations of common modes
(xts(aes), cbc(aes), ...) to provide better performance for dm-crypt
(and possibly other users, too).

I'm not sure how exactly these crypto accelerators work, but wouldn't
it help if the drivers simply get more messages (in our case sectors)
in a single call? I wonder, would (efficiently) supporting such a
scheme require changes in the HW itself or could it be achieved just
by modifying driver code (let's say specifically for your CryptoCell
accelerator)?

Thanks,
Ondrej

[1] https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg23007.html

>
> Thanks,
> Gilad
>
>
>
> --
> Gilad Ben-Yossef
> Chief Coffee Drinker
>
> "If you take a class in large-scale robotics, can you end up in a
> situation where the homework eats your dog?"
>  -- Jean-Baptiste Queru
