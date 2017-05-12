From: Mike Frysinger <vapier@chromium.org>
Subject: Re: [PATCH] hwrng: do not warn when there are no devices
Date: Fri, 12 May 2017 03:47:52 -0400
Message-ID: <CAAbOSck2Uzk7kRHErLwEGRoPkMVV+=3bvdz1nnSOsE6UTQZF0A@mail.gmail.com>
References: <20170512041734.31945-1-vapier@gentoo.org> <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
 <CAAbOSc=e07W8LL8PAHv5awt_uPk8yNJ6wTTu3Ebe-Mww+inG8A@mail.gmail.com>
 <CANc+2y6=TtMGFknqgc5oAjY-pHkU6J31+QQaa7=6oAS=Omc0cg@mail.gmail.com> <CANc+2y5YDcJYcwyCUtdCcvW_07HhjTzSrShyWFkfCjXYTsi0QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Mike Frysinger <vapier@gentoo.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:34150 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756674AbdELHsX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 03:48:23 -0400
Received: by mail-ua0-f173.google.com with SMTP id g49so42328270uaa.1
        for <linux-crypto@vger.kernel.org>; Fri, 12 May 2017 00:48:23 -0700 (PDT)
In-Reply-To: <CANc+2y5YDcJYcwyCUtdCcvW_07HhjTzSrShyWFkfCjXYTsi0QQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, May 12, 2017 at 3:06 AM, PrasannaKumar Muralidharan wrote:
> On 12 May 2017 at 12:22, PrasannaKumar Muralidharan wrote:
> > On 12 May 2017 at 12:11, Mike Frysinger wrote:
> >> On Fri, May 12, 2017 at 2:15 AM, PrasannaKumar Muralidharan wrote:
> >>> On 12 May 2017 at 09:47, Mike Frysinger wrote:
> >>> > From: Mike Frysinger <vapier@chromium.org>
> >>> >
> >>> > If you build in hwrng & tpm-rng, but boot on a system that doesn't
> >>> > have a tpm (like via KVM), hwrng will spam the logs every 10 seconds
> >>> > with the line:
> >>> >         hwrng: no data available
> >>> >
> >>> > This isn't terribly useful, so squelch the error in the ENODEV case.
> >>> > For all other errors, we still warn, and include the actual error.
> >
> > If the boot system does not have a tpm I think registering tpm-rng is
> > not useful. On tpm-rng load instead of registering with hwrng a check
> > can be made whether the system supports tpm. Is this possible?
>
> Completely untested patch below. Will something like this work?
>
> --- a/drivers/char/hw_random/tpm-rng.c
> +++ b/drivers/char/hw_random/tpm-rng.c
> @@ -35,7 +35,13 @@ static int tpm_rng_read(struct hwrng *rng, void
> *data, size_t max, bool wait)
>
>  static int __init rng_init(void)
>  {
> -       return hwrng_register(&tpm_rng);
> +       struct tpm_chip *tpm_rng_chip = tpm_chip_find_get(TPM_ANY_NUM);
> +       if (tpm_chip) {
> +               tpm_put_ops(tpm_rng_chip);
> +               return hwrng_register(&tpm_rng);
> +       }
> +
> +       return -ENODEV;
>  }
>  module_init(rng_init);

keep in mind that TPMs are often on slow buses like I2C, so i suspect
rng_init runs before those have been initialized.  so this patch would
break them.

it would also break if the tpm drivers are modules that don't get
loaded until later, but tpm-rng is built in.  or tpm-rng is loaded
first.
-mike
