From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v1 2/2] hw_random: timeriomem_rng: Allow setting RNG
 quality from platform data
Date: Thu, 18 May 2017 11:13:29 +0530
Message-ID: <CANc+2y4vg1F2+y98ijoR1Ve_2u+zpChN3OXxn+6uLebVLcDp6Q@mail.gmail.com>
References: <20170517222911.9295-1-raltherr@google.com> <20170517222911.9295-2-raltherr@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Matt Mackall <mpm@selenic.com>
To: Rick Altherr <raltherr@google.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:33437 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751348AbdERFna (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 May 2017 01:43:30 -0400
In-Reply-To: <20170517222911.9295-2-raltherr@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Rick,

Minor comment below.

On 18 May 2017 at 03:59, Rick Altherr <raltherr@google.com> wrote:
> When a hw_random device's quality is non-zero, it will automatically be
> used to fill the kernel's entropy pool.  Since timeriomem_rng is used by
> many different devices, the quality needs to be provided by platform
> data or device tree.
>
> Signed-off-by: Rick Altherr <raltherr@google.com>
> ---
>
>  drivers/char/hw_random/timeriomem-rng.c | 7 +++++++
>  include/linux/timeriomem-rng.h          | 3 +++
>  2 files changed, 10 insertions(+)
>
> diff --git a/drivers/char/hw_random/timeriomem-rng.c b/drivers/char/hw_random/timeriomem-rng.c
> index a0faa5f05deb..03ff5483d865 100644
> --- a/drivers/char/hw_random/timeriomem-rng.c
> +++ b/drivers/char/hw_random/timeriomem-rng.c
> @@ -151,8 +151,15 @@ static int timeriomem_rng_probe(struct platform_device *pdev)
>                         dev_err(&pdev->dev, "missing period\n");
>                         return -EINVAL;
>                 }
> +
> +               if (!of_property_read_u32(pdev->dev.of_node,
> +                                               "quality", &i))
> +                       priv->rng_ops.quality = i;
> +               else
> +                       priv->rng_ops.quality = 0;
>         } else {
>                 period = pdata->period;
> +               priv->rng_ops.quality = pdata->quality;
>         }
>
>         priv->period = ns_to_ktime(period * NSEC_PER_USEC);
> diff --git a/include/linux/timeriomem-rng.h b/include/linux/timeriomem-rng.h
> index 46eb27ddbfab..320f743bf06b 100644
> --- a/include/linux/timeriomem-rng.h
> +++ b/include/linux/timeriomem-rng.h
> @@ -13,4 +13,7 @@ struct timeriomem_rng_data {
>
>         /* measures in usecs */
>         unsigned int            period;
> +
> +       /* bits of entropy per 1000 bits read */

Your dt-bindings patch says 'entropy per 1024 bits'. Please be consistent.

> +       unsigned int            quality;
>  };
> --
> 2.13.0.303.g4ebf302169-goog
>

Regards,
PrasannaKumar
