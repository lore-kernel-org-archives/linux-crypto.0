From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: Re: [PATCH] crypto: exynoes-rng: Set cra_ctxsize to 0
Date: Mon, 22 May 2017 07:56:09 +0200
Message-ID: <CAJKOXPcky8qPFNU==iqeV28kwWr=T0Q+YVFm295V=aG4vFbdPg@mail.gmail.com>
References: <20170521060952.19055-1-prasannatsmkumar@gmail.com>
 <CAJKOXPfh21DLOqTUPSZ=mDUyuCE+L8Wn9m=ioM=N1nomT4Vs+g@mail.gmail.com>
 <CANc+2y4KsFfLqnK4rA8iMEQcvUQD6nvQq43oDoheEwt+T23kxQ@mail.gmail.com>
 <CAJKOXPcyzcM93OXcRRbR-zSs0Fj81ROuBn293PNcqEzp1to0iQ@mail.gmail.com> <CANc+2y6WmVJaRyCegxe-MqbEMHGetVvdR=wEs_=Ci4LbQDQ9BQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:49952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751261AbdEVF4L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 May 2017 01:56:11 -0400
Received: from mail-it0-f52.google.com (mail-it0-f52.google.com [209.85.214.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E639B239D5
        for <linux-crypto@vger.kernel.org>; Mon, 22 May 2017 05:56:10 +0000 (UTC)
Received: by mail-it0-f52.google.com with SMTP id g126so73541002ith.0
        for <linux-crypto@vger.kernel.org>; Sun, 21 May 2017 22:56:10 -0700 (PDT)
In-Reply-To: <CANc+2y6WmVJaRyCegxe-MqbEMHGetVvdR=wEs_=Ci4LbQDQ9BQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 22, 2017 at 5:44 AM, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
>>> I do not have access to the hardware, did not test the change. Sorry I
>>> forgot to mention that.
>>
>> That is quite important... By default everything must be tested so if
>> you are skipping this step then please mark the patch respectively so
>> others will provide testing.
>
> Sure. Will keep that in mind. Instead of marking it as a [PATCH]
> should I use something else for this? Will it make things easier?

If sending untested patch is really necessary, then mark it either as
RFT instead of PATCH or add a comment about it after --- separator.

Best regards,
Krzysztof
