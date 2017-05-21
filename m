From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] crypto: exynoes-rng: Set cra_ctxsize to 0
Date: Sun, 21 May 2017 09:14:12 +0200
Message-ID: <CAJKOXPcyzcM93OXcRRbR-zSs0Fj81ROuBn293PNcqEzp1to0iQ@mail.gmail.com>
References: <20170521060952.19055-1-prasannatsmkumar@gmail.com>
 <CAJKOXPfh21DLOqTUPSZ=mDUyuCE+L8Wn9m=ioM=N1nomT4Vs+g@mail.gmail.com> <CANc+2y4KsFfLqnK4rA8iMEQcvUQD6nvQq43oDoheEwt+T23kxQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:47706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750803AbdEUHOO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 May 2017 03:14:14 -0400
Received: from mail-io0-f177.google.com (mail-io0-f177.google.com [209.85.223.177])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C97F239B0
        for <linux-crypto@vger.kernel.org>; Sun, 21 May 2017 07:14:13 +0000 (UTC)
Received: by mail-io0-f177.google.com with SMTP id k91so66444566ioi.1
        for <linux-crypto@vger.kernel.org>; Sun, 21 May 2017 00:14:13 -0700 (PDT)
In-Reply-To: <CANc+2y4KsFfLqnK4rA8iMEQcvUQD6nvQq43oDoheEwt+T23kxQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, May 21, 2017 at 9:11 AM, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
> Hi Krzysztof
>
> On 21 May 2017 at 11:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
>> On Sun, May 21, 2017 at 8:09 AM, PrasannaKumar Muralidharan
>> <prasannatsmkumar@gmail.com> wrote:
>>> As cra_ctxsize is set but the allocated space is not used, set it 0.
>>
>> Why do you think it is not used? Did you test our change on hardware?
>
> Had a look at the crypto rng code. I think the additional size is used
> to store driver private data. But this driver does not store any
> private data in the crypto_tfm structure so I think the 'cra_ctxsize'
> can be safely set to 0.

Then from where does crypto_tfm_ctx() get its memory?

> I do not have access to the hardware, did not test the change. Sorry I
> forgot to mention that.

That is quite important... By default everything must be tested so if
you are skipping this step then please mark the patch respectively so
others will provide testing.

Best regards,
Krzysztof
