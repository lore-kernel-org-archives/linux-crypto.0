From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH] hwrng: do not warn when there are no devices
Date: Fri, 12 May 2017 11:45:07 +0530
Message-ID: <CANc+2y5si9imDg7NEC-3XsnjPFfoUMu=2T5gxKDqgoo24XHCaA@mail.gmail.com>
References: <20170512041734.31945-1-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Mike Frysinger <vapier@chromium.org>
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f66.google.com ([209.85.213.66]:33784 "EHLO
        mail-vk0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755816AbdELGPJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 May 2017 02:15:09 -0400
Received: by mail-vk0-f66.google.com with SMTP id m78so1534133vkf.0
        for <linux-crypto@vger.kernel.org>; Thu, 11 May 2017 23:15:09 -0700 (PDT)
In-Reply-To: <20170512041734.31945-1-vapier@gentoo.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12 May 2017 at 09:47, Mike Frysinger <vapier@gentoo.org> wrote:
> From: Mike Frysinger <vapier@chromium.org>
>
> If you build in hwrng & tpm-rng, but boot on a system that doesn't
> have a tpm (like via KVM), hwrng will spam the logs every 10 seconds
> with the line:
>         hwrng: no data available
>
> This isn't terribly useful, so squelch the error in the ENODEV case.
> For all other errors, we still warn, and include the actual error.

This patch removes the logging but does not fix the real problem.
Better method would be to start the hwrng_fillfn thread when first rng
provider registers and stop it when the last rng provider unregisters.

> Signed-off-by: Mike Frysinger <vapier@chromium.org>
> ---
>  drivers/char/hw_random/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 503a41dfa193..da24bd5a9902 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -392,7 +392,8 @@ static int hwrng_fillfn(void *unused)
>                 mutex_unlock(&reading_mutex);
>                 put_rng(rng);
>                 if (rc <= 0) {
> -                       pr_warn("hwrng: no data available\n");
> +                       if (rc != -ENODEV)
> +                               pr_warn("hwrng: no data available: %li\n", rc);
>                         msleep_interruptible(10000);
>                         continue;
>                 }
> --
> 2.12.0
>
