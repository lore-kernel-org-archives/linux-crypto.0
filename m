From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [RFC PATCH] crypto: make the seed() function optional
Date: Sun, 8 Oct 2017 19:41:15 +0530
Message-ID: <CANc+2y4Yzf_kKKEDpeS_ZccC61j3RCEJbFPEz5MrjyB6GcLi2g@mail.gmail.com>
References: <20170913200915.20738-1-malat@debian.org> <20171007033318.GA29712@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Mathieu Malaterre <malat@debian.org>, nhorman@tuxdriver.com,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:56615 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751179AbdJHOLR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 8 Oct 2017 10:11:17 -0400
In-Reply-To: <20171007033318.GA29712@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 7 October 2017 at 09:03, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Mathieu Malaterre <malat@debian.org> wrote:
>> This makes it simplier for driver author to not provide the seed() function
>> in case of a pseudo RNG where the seed operation is a no-op.
>>
>> Document that the seed() function pointer is optional in header.
>>
>> Signed-off-by: Mathieu Malaterre <malat@debian.org>
>> ---
>> The PRNG as found on Ingenic JZ4780 is one such example. This is found on a
>> MIPS Creator CI20 SoC.
>
> So how does it seed itself? This also contradicts with the JZ4780
> driver that's currently in the patch queue as it does contain a
> seed function.

The current version of JZ4780 driver in the patch queue indeed has
seed function. But when Mathieu sent this email based on v2 of the
driver. V2 did not have seed callback. Using v2 resulted in a NULL
pointer in kernel. This patch prevents that NULL pointer access.

Regardless of what JZ4780 driver has this patch makes sense.

Currently crypto framework does not mandate seed callback's presence.
If mandatory, crypto framework should error out if seed is not
implemented while registering the PRNG.

Thanks,
PrasannaKumar
