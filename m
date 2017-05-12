From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hwrng: do not warn when there are no devices
Date: Fri, 12 May 2017 13:49:52 +0530
Message-ID: <CANc+2y40u1vviM9_m8TX896Skr=qCjmvvSq86Y=tkX923Q_3fg@mail.gmail.com>
References: <20170512041734.31945-1-vapier@gentoo.org> <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
 <CAAbOSc=e07W8LL8PAHv5awt_uPk8yNJ6wTTu3Ebe-Mww+inG8A@mail.gmail.com>
 <CANc+2y6=TtMGFknqgc5oAjY-pHkU6J31+QQaa7=6oAS=Omc0cg@mail.gmail.com>
 <CANc+2y5YDcJYcwyCUtdCcvW_07HhjTzSrShyWFkfCjXYTsi0QQ@mail.gmail.com> <CAAbOSck2Uzk7kRHErLwEGRoPkMVV+=3bvdz1nnSOsE6UTQZF0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Mike Frysinger <vapier@gentoo.org>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: Mike Frysinger <vapier@chromium.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ua0-f177.google.com ([209.85.217.177]:32855 "EHLO
        mail-ua0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756237AbdELITx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 04:19:53 -0400
Received: by mail-ua0-f177.google.com with SMTP id e28so42720822uah.0
        for <linux-crypto@vger.kernel.org>; Fri, 12 May 2017 01:19:53 -0700 (PDT)
In-Reply-To: <CAAbOSck2Uzk7kRHErLwEGRoPkMVV+=3bvdz1nnSOsE6UTQZF0A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12 May 2017 at 13:17, Mike Frysinger <vapier@chromium.org> wrote:
>> Completely untested patch below. Will something like this work?
>>
>> --- a/drivers/char/hw_random/tpm-rng.c
>> +++ b/drivers/char/hw_random/tpm-rng.c
>> @@ -35,7 +35,13 @@ static int tpm_rng_read(struct hwrng *rng, void
>> *data, size_t max, bool wait)
>>
>>  static int __init rng_init(void)
>>  {
>> -       return hwrng_register(&tpm_rng);
>> +       struct tpm_chip *tpm_rng_chip = tpm_chip_find_get(TPM_ANY_NUM);
>> +       if (tpm_chip) {
>> +               tpm_put_ops(tpm_rng_chip);
>> +               return hwrng_register(&tpm_rng);
>> +       }
>> +
>> +       return -ENODEV;
>>  }
>>  module_init(rng_init);
>
> keep in mind that TPMs are often on slow buses like I2C, so i suspect
> rng_init runs before those have been initialized.  so this patch would
> break them.
>
> it would also break if the tpm drivers are modules that don't get
> loaded until later, but tpm-rng is built in.  or tpm-rng is loaded
> first.

Hmm. I am not aware of the tpm hardware or driver behavior. Based on
your explanation I see that this patch is not useful. It looks like it
is possible to detect the presence of tpm device and call
hwrng_register once the corresponding driver is loaded.

I leave it to Herbert to decide whether to accept this patch in
current form or not.

Regardless of whether this patch gets accepted or not I can work on a
better fix if you can provide instructions on how to setup and use
tpm. But that will be only after a couple of months.

Regards,
PrasannaKumar
