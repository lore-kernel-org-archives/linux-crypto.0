From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hwrng: do not warn when there are no devices
Date: Fri, 12 May 2017 12:36:32 +0530
Message-ID: <CANc+2y5YDcJYcwyCUtdCcvW_07HhjTzSrShyWFkfCjXYTsi0QQ@mail.gmail.com>
References: <20170512041734.31945-1-vapier@gentoo.org> <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
 <CAAbOSc=e07W8LL8PAHv5awt_uPk8yNJ6wTTu3Ebe-Mww+inG8A@mail.gmail.com> <CANc+2y6=TtMGFknqgc5oAjY-pHkU6J31+QQaa7=6oAS=Omc0cg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Mike Frysinger <vapier@gentoo.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Mike Frysinger <vapier@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:34866 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756988AbdELHGe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 03:06:34 -0400
Received: by mail-vk0-f68.google.com with SMTP id x71so1570719vkd.2
        for <linux-crypto@vger.kernel.org>; Fri, 12 May 2017 00:06:33 -0700 (PDT)
In-Reply-To: <CANc+2y6=TtMGFknqgc5oAjY-pHkU6J31+QQaa7=6oAS=Omc0cg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12 May 2017 at 12:22, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
> On 12 May 2017 at 12:11, Mike Frysinger <vapier@chromium.org> wrote:
>> On Fri, May 12, 2017 at 2:15 AM, PrasannaKumar Muralidharan wrote:
>>> On 12 May 2017 at 09:47, Mike Frysinger <vapier@gentoo.org> wrote:
>>> > From: Mike Frysinger <vapier@chromium.org>
>>> >
>>> > If you build in hwrng & tpm-rng, but boot on a system that doesn't
>>> > have a tpm (like via KVM), hwrng will spam the logs every 10 seconds
>>> > with the line:
>>> >         hwrng: no data available
>>> >
>>> > This isn't terribly useful, so squelch the error in the ENODEV case.
>>> > For all other errors, we still warn, and include the actual error.
>
> If the boot system does not have a tpm I think registering tpm-rng is
> not useful. On tpm-rng load instead of registering with hwrng a check
> can be made whether the system supports tpm. Is this possible?

Completely untested patch below. Will something like this work?

diff --git a/drivers/char/hw_random/tpm-rng.c b/drivers/char/hw_random/tpm-rng.c
index d6d4482..f78f8ca 100644
--- a/drivers/char/hw_random/tpm-rng.c
+++ b/drivers/char/hw_random/tpm-rng.c
@@ -35,7 +35,13 @@ static int tpm_rng_read(struct hwrng *rng, void
*data, size_t max, bool wait)

 static int __init rng_init(void)
 {
-       return hwrng_register(&tpm_rng);
+       struct tpm_chip *tpm_rng_chip = tpm_chip_find_get(TPM_ANY_NUM);
+       if (tpm_chip) {
+               tpm_put_ops(tpm_rng_chip);
+               return hwrng_register(&tpm_rng);
+       }
+
+       return -ENODEV;
 }
 module_init(rng_init);

Thanks,
PrasannaKumar
