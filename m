From: Fabio Estevam <festevam@gmail.com>
Subject: Re: Fix dma unmap direction in iMX sahara aes calculation
Date: Tue, 25 Jul 2017 14:51:11 -0300
Message-ID: <CAOMZO5Dc4EG8ipGnBSVbJRp9QTBKMVTmXPbambMSfvHWzYVWJQ@mail.gmail.com>
References: <CACA-NJv69LnyR-xcJC8OU-_WRfg1Mtawq9UapswQczrdAonFDA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org
To: Mogens Lauridsen <mlauridsen171@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34711 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751103AbdGYRvN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 25 Jul 2017 13:51:13 -0400
Received: by mail-vk0-f41.google.com with SMTP id n125so9800657vke.1
        for <linux-crypto@vger.kernel.org>; Tue, 25 Jul 2017 10:51:12 -0700 (PDT)
In-Reply-To: <CACA-NJv69LnyR-xcJC8OU-_WRfg1Mtawq9UapswQczrdAonFDA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Mogens,

On Sun, Jul 16, 2017 at 6:21 PM, Mogens Lauridsen
<mlauridsen171@gmail.com> wrote:
> Hi,
>
> The direction used in dma_unmap_sg in aes calc in sahara.c is wrong.
> This result in the cache not being invalidated correct when aes
> calculation is done and result is dma'ed to memory.
> This is seen as sporadic wrong result from aes calc.
>
> Thanks,
> Mogens
>
> Signed-off-by: Mogens Lauridsen <mlauridsen171@gmail.com>

Your two fixes are good, but the patch format is not correct.

You could try to use git send-email for submitting the two patches.

Subject could be improved. If you run 'git log
drivers/crypto/sahara.c' you will see the common standard, so you
could do:

crypto: sahara - Fix dma unmap direction as the Subject.

Then you need to run './scripts/checkpatch.pl 0001-your.patch' to see
what people and lists to send it to.

Please resend them.
