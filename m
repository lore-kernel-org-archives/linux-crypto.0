Return-Path: <SRS0=MdlN=AN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DAEEC433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:52:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D03320899
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Jul 2020 07:52:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgGBHwI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Jul 2020 03:52:08 -0400
Received: from mout.kundenserver.de ([217.72.192.74]:60685 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgGBHwI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Jul 2020 03:52:08 -0400
Received: from mail-qv1-f50.google.com ([209.85.219.50]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1N2V8T-1ioGAD2WER-013wOK; Thu, 02 Jul 2020 09:52:06 +0200
Received: by mail-qv1-f50.google.com with SMTP id el4so8149078qvb.13;
        Thu, 02 Jul 2020 00:52:06 -0700 (PDT)
X-Gm-Message-State: AOAM530L5cNzli5ifsPhspQq7j4kva1brURfKmbAp0QJO9J01YlCA//U
        x3KOfjW0P1NBN2y4RprjGeGe6BGEuQDzLlrPYuM=
X-Google-Smtp-Source: ABdhPJwiJUPMCqWnBbIV5x5xxsO/4qntI7KoZTnqIAyLRr87ITypaM11g24i6m5gKU/156opHDiB4/9MJjwq3CgPKes=
X-Received: by 2002:a0c:ba0e:: with SMTP id w14mr28987642qvf.222.1593676325385;
 Thu, 02 Jul 2020 00:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200701200950.30314-1-rikard.falkeborn@gmail.com> <20200701200950.30314-3-rikard.falkeborn@gmail.com>
In-Reply-To: <20200701200950.30314-3-rikard.falkeborn@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 2 Jul 2020 09:51:49 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1tQn02j-MkJGhAd7udVuGcKuve0nFAhM57ifn1hTq7pA@mail.gmail.com>
Message-ID: <CAK8P3a1tQn02j-MkJGhAd7udVuGcKuve0nFAhM57ifn1hTq7pA@mail.gmail.com>
Subject: Re: [PATCH 2/5] hwrng: nomadik - Constify nmk_rng_ids[]
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:d1tmNuojY+mL4cI3CvhR2qDsP/HPRJvB0uSJsNMVYwF0zKjETWR
 npcz9L3d9oRU7r1ro6NiUtsBerrsuovpzvIN15Sayu0QGY84xZerQBAphBvKZTHQO4u5o3b
 dcBPd0I4c1PesJT/ymWfV7JNtIHs4cBx/02ds5/n9qPKU1gMn4mruRtK1aQr7lV7imNZmve
 w9c05zN5jmFLHGiQAd7DQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:UsM3UdRzDus=:UqrKfHMQQQywpZ+0i+IklE
 9exShB5ll0IGYGN8kZvefEPCar6RUVOb3DvRL+wdBX+MV4/TdYCj7phri1dr8Re+7Hnt9Uy1W
 HiPEQXnQZMvJFZhLq9jsp9uU4RcV0hwxTyWg7R2o8tybl0WnolCa6DZSuy74W842Ku23CVCzP
 mPeKB7GSxYY2bKSdtlBSAABDUXCSt4Ado+MJQkxM0yxCQJMXun0j5l5AMs0xze4YrWSHvrRTR
 832OKpmwnWhlwd/X1nRS7mT0FtEl0M3gZOZzc83awowaSFUZygyBrBzEkALlY7Ahai+3aZVKF
 Ta5Z/I8Q6UerNcLhHnsrmP2h4dtABqLZ7qkENqBK55UqnT9GXgdlTW1GRxge94rX2wiGjO1So
 iIm/XOhK26/dlRG7CVYIsyiIv+DBH97qxrr8sGdrdGcDT1aQHpVaBxUx2/ib+jlQbJ6avHdyx
 vqycD19ao8zleInIDLKsVmiZlf37xLRogwCMTrX2YIXLdL5xKvVigvEii2OBvI/hEKUoJ9wOz
 tPx9lfv0u01iagcVZZZM6HtgluBtqFh0mFzwuTPbE6K2R0VW6BS/4l8CSI2no/GYtnRzvgafS
 Qm+0ruyil6XVhYhe/oiXZCvSjMY5SqWOJpGTL+o1789MrrpNgyEu293FReAM2xZDn054VYChK
 dOgEdOOCME/9NVkI2TI+z1A/9g5sExqtOliHaaMLvfWXMBzyJr45CTL0ZGSm+c7iEgpC17Uoj
 zuVE2UKk+MDwiANed8N2bZZDN7Z0iQ7RfaXBP4OzEynCsgE9O4zsuEJ3EstLShNA0u4AKD87c
 zOblnxct6sHLGTakJ31dEh8UfcmuN8hDVclg/wXycj9A61lFik=
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jul 1, 2020 at 11:48 PM Rikard Falkeborn
<rikard.falkeborn@gmail.com> wrote:
>
> nmk_rng_ids[] is not modified and can be made const to allow the
> compiler to put it in read-only memory.
>
> Before:
>    text    data     bss     dec     hex filename
>     652     216       4     872     368 drivers/char/hw_random/nomadik-rng.o
>
> After:
>    text    data     bss     dec     hex filename
>     676     192       4     872     368 drivers/char/hw_random/nomadik-rng.o

Moving 24 bytes into the .rodata section is probably not a worth
the change, but the patch is correct and I agree this should be
.rodata anway.

> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>

> ---
>  drivers/char/hw_random/nomadik-rng.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/nomadik-rng.c b/drivers/char/hw_random/nomadik-rng.c
> index 74ed29f42e4f..b0ded41eb865 100644
> --- a/drivers/char/hw_random/nomadik-rng.c
> +++ b/drivers/char/hw_random/nomadik-rng.c
> @@ -76,7 +76,7 @@ static int nmk_rng_remove(struct amba_device *dev)
>         return 0;
>  }
>
> -static struct amba_id nmk_rng_ids[] = {
> +static const struct amba_id nmk_rng_ids[] = {
>         {
>                 .id     = 0x000805e1,
>                 .mask   = 0x000fffff, /* top bits are rev and cfg: accept all */
> --
> 2.27.0
>
