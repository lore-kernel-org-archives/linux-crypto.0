From: Rick Altherr <raltherr@google.com>
Subject: Re: [PATCH] hw_random: timeriomem-rng: Remove 'max < 4' condition check
Date: Tue, 22 Aug 2017 09:53:59 -0700
Message-ID: <CAPLgG==6YgPO9CxRucbqEyfL5hb8m6YWqBfr_DPcBh5v2_=25Q@mail.gmail.com>
References: <20170822162224.26801-1-prasannatsmkumar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:38732 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751705AbdHVQyA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 22 Aug 2017 12:54:00 -0400
Received: by mail-vk0-f43.google.com with SMTP id l132so14978858vke.5
        for <linux-crypto@vger.kernel.org>; Tue, 22 Aug 2017 09:54:00 -0700 (PDT)
In-Reply-To: <20170822162224.26801-1-prasannatsmkumar@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 22, 2017 at 9:22 AM, PrasannaKumar Muralidharan
<prasannatsmkumar@gmail.com> wrote:
>
> In read routiene max is always >= 4. The check whether 'max < 4' is not
> necessary. Remove it.

Missed that in the header.

Acked-By: Rick Altherr <raltherr@google.com>

>
> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
> ---
>  drivers/char/hw_random/timeriomem-rng.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
> index 03ff548..f615684 100644
> --- a/drivers/char/hw_random/timeriomem-rng.c
> +++ b/drivers/char/hw_random/timeriomem-rng.c
> @@ -53,13 +53,6 @@ static int timeriomem_rng_read(struct hwrng *hwrng, void *data,
>         int period_us = ktime_to_us(priv->period);
>
>         /*
> -        * The RNG provides 32-bits per read.  Ensure there is enough space for
> -        * at minimum one read.
> -        */
> -       if (max < sizeof(u32))
> -               return 0;
> -
> -       /*
>          * There may not have been enough time for new data to be generated
>          * since the last request.  If the caller doesn't want to wait, let them
>          * bail out.  Otherwise, wait for the completion.  If the new data has
> --
> 2.10.0
>
