From: Mike Frysinger <vapier@chromium.org>
Subject: Re: [PATCH] hwrng: do not warn when there are no devices
Date: Fri, 12 May 2017 02:41:53 -0400
Message-ID: <CAAbOSc=e07W8LL8PAHv5awt_uPk8yNJ6wTTu3Ebe-Mww+inG8A@mail.gmail.com>
References: <20170512041734.31945-1-vapier@gentoo.org> <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Mike Frysinger <vapier@gentoo.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:34372 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750796AbdELGmZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 02:42:25 -0400
Received: by mail-ua0-f170.google.com with SMTP id g49so41631069uaa.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 May 2017 23:42:25 -0700 (PDT)
In-Reply-To: <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 12, 2017 at 2:15 AM, PrasannaKumar Muralidharan wrote:
> On 12 May 2017 at 09:47, Mike Frysinger <vapier@gentoo.org> wrote:
> > From: Mike Frysinger <vapier@chromium.org>
> >
> > If you build in hwrng & tpm-rng, but boot on a system that doesn't
> > have a tpm (like via KVM), hwrng will spam the logs every 10 seconds
> > with the line:
> >         hwrng: no data available
> >
> > This isn't terribly useful, so squelch the error in the ENODEV case.
> > For all other errors, we still warn, and include the actual error.
>
> This patch removes the logging but does not fix the real problem.
> Better method would be to start the hwrng_fillfn thread when first rng
> provider registers and stop it when the last rng provider unregisters.

what you describe is already implemented in the hw random code.  the
kthread only starts up when a registration happens, and will stop it
when the last rng unregisters itself.

the issue is that tpm-rng has registered itself here, but there aren't
any tpm devices available.  so it returns ENODEV.
-mike
