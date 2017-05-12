From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hwrng: do not warn when there are no devices
Date: Fri, 12 May 2017 12:22:02 +0530
Message-ID: <CANc+2y6=TtMGFknqgc5oAjY-pHkU6J31+QQaa7=6oAS=Omc0cg@mail.gmail.com>
References: <20170512041734.31945-1-vapier@gentoo.org> <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
 <CAAbOSc=e07W8LL8PAHv5awt_uPk8yNJ6wTTu3Ebe-Mww+inG8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Mike Frysinger <vapier@gentoo.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Mike Frysinger <vapier@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:34382 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753775AbdELGwD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 02:52:03 -0400
Received: by mail-ua0-f195.google.com with SMTP id j17so5046679uag.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 May 2017 23:52:03 -0700 (PDT)
In-Reply-To: <CAAbOSc=e07W8LL8PAHv5awt_uPk8yNJ6wTTu3Ebe-Mww+inG8A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12 May 2017 at 12:11, Mike Frysinger <vapier@chromium.org> wrote:
> On Fri, May 12, 2017 at 2:15 AM, PrasannaKumar Muralidharan wrote:
>> On 12 May 2017 at 09:47, Mike Frysinger <vapier@gentoo.org> wrote:
>> > From: Mike Frysinger <vapier@chromium.org>
>> >
>> > If you build in hwrng & tpm-rng, but boot on a system that doesn't
>> > have a tpm (like via KVM), hwrng will spam the logs every 10 seconds
>> > with the line:
>> >         hwrng: no data available
>> >
>> > This isn't terribly useful, so squelch the error in the ENODEV case.
>> > For all other errors, we still warn, and include the actual error.

If the boot system does not have a tpm I think registering tpm-rng is
not useful. On tpm-rng load instead of registering with hwrng a check
can be made whether the system supports tpm. Is this possible?

>> This patch removes the logging but does not fix the real problem.
>> Better method would be to start the hwrng_fillfn thread when first rng
>> provider registers and stop it when the last rng provider unregisters.
>
> what you describe is already implemented in the hw random code.  the
> kthread only starts up when a registration happens, and will stop it
> when the last rng unregisters itself.
>
> the issue is that tpm-rng has registered itself here, but there aren't
> any tpm devices available.  so it returns ENODEV.

Missed it. Please see if the above comment can be addressed.

Thanks,
PrasannaKumar
