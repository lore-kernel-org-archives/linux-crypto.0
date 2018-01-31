From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCHv2] tls: Add support for encryption using async offload accelerator
Date: Wed, 31 Jan 2018 19:48:08 +0200
Message-ID: <CAOtvUMfXrk0VJUK9+GEhzNZqxpMLZVvE76sEj2xkTgwHPyf5+A@mail.gmail.com>
References: <20180131160437.6583-1-vakul.garg@nxp.com> <20180131152228.GA24247@davejwatson-mba>
 <HE1PR04MB30827E0097BB30E4E2EE51648BFB0@HE1PR04MB3082.eurprd04.prod.outlook.com>
 <20180131173444.GA41553@davejwatson-mba>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Vakul Garg <vakul.garg@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "ilyal@mellanox.com" <ilyal@mellanox.com>,
        "aviadye@mellanox.com" <aviadye@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
To: Dave Watson <davejwatson@fb.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:40932 "EHLO
        mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752658AbeAaRsJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Jan 2018 12:48:09 -0500
Received: by mail-ua0-f182.google.com with SMTP id t6so9999279ual.7
        for <linux-crypto@vger.kernel.org>; Wed, 31 Jan 2018 09:48:09 -0800 (PST)
In-Reply-To: <20180131173444.GA41553@davejwatson-mba>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 31, 2018 at 7:34 PM, Dave Watson <davejwatson@fb.com> wrote:
> On 01/31/18 05:22 PM, Vakul Garg wrote:
>> > > On second though in stable we should probably just disable async tfm
>> > > allocations.
>> > > It's simpler. But this approach is still good for -next
>> > >
>> > >
>> > > Gilad
>> >
>> > I agree with Gilad, just disable async for now.
>> >
>>
>> How to do it? Can you help with the api name?
>
> *aead = crypto_alloc_aead("gcm(aes)", 0, CRYPTO_ALG_ASYNC);
>
> https://github.com/ktls/net_next_ktls/commit/f3b9b402e755e4b0623fa83f88137173fc249f2d

I said disabling async tfms is the right way to go for -stable since
it's the simplest and less risky way
of plugging this bug.

I don't think this is the way to go for -next (and it seems davem
agrees with me). Vakul's
patch looks good to me for now.

>
>> > If the flag MSG_DONTWAIT is set, we should be returning -EINPROGRESS and
>> > not wait for a response.  I had started working on a patch for that, but it's
>> > pretty tricky to get right.
>>

That would be a great addition, but I don't think we need to wait for
that. It can come later.

Gilad
-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
