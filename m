Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-io1-f68.google.com ([209.85.166.68]:40557 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbeLMJsT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 04:48:19 -0500
Received: by mail-io1-f68.google.com with SMTP id n9so1084382ioh.7
        for <linux-crypto@vger.kernel.org>; Thu, 13 Dec 2018 01:48:18 -0800 (PST)
MIME-Version: 1.0
References: <20181213091848.81327-1-louiscollard@chromium.org>
In-Reply-To: <20181213091848.81327-1-louiscollard@chromium.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 13 Dec 2018 10:48:07 +0100
Message-ID: <CAKv+Gu9sWw=VHjYivokAkhGP+p1P15bs3ThfRghARNesW5kyOA@mail.gmail.com>
Subject: Re: [PATCH v2] Allow hwrng to initialize crng.
To: louiscollard@chromium.org
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        gary.hook@amd.com, m@bues.ch,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        apronin@chromium.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux@mniewoehner.de, david.bild@xaptum.com,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 13 Dec 2018 at 10:18, Louis Collard <louiscollard@chromium.org> wrote:
>
> Some systems, for example embedded systems, do not generate
> enough entropy on boot through interrupts, and boot may be blocked for
> several minutes waiting for a call to getrandom to complete.
>
> Currently, random data is read from a hwrng when it is registered,
> and is loaded into primary_crng. This data is treated in the same
> way as data that is device-specific but otherwise unchanging, and
> so primary_crng cannot become initialized with the data from the
> hwrng.
>
> This change causes the data initially read from the hwrng to be
> treated the same as subsequent data that is read from the hwrng if
> it's quality score is non-zero.
>
> The implications of this are:
>
> The data read from hwrng can cause primary_crng to become
> initialized, therefore avoiding problems of getrandom blocking
> on boot.
>
> Calls to getrandom (with GRND_RANDOM) may be using entropy
> exclusively (or in practise, almost exclusively) from the hwrng.
>
> Regarding the latter point; this behavior is the same as if a
> user specified a quality score of 1 (bit of entropy per 1024 bits)
> so hopefully this is not too scary a change to make.
>
> This change is the result of the discussion here:
> https://patchwork.kernel.org/patch/10453893/
>
> Signed-off-by: Louis Collard <louiscollard@chromium.org>
> Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  drivers/char/hw_random/core.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> index 95be7228f327..7736e1a96321 100644
> --- a/drivers/char/hw_random/core.c
> +++ b/drivers/char/hw_random/core.c
> @@ -24,6 +24,7 @@
>  #include <linux/sched.h>
>  #include <linux/slab.h>
>  #include <linux/uaccess.h>
> +#include <crypto/chacha20.h>
>
>  #define RNG_MODULE_NAME                "hw_random"
>
> @@ -64,13 +65,19 @@ static size_t rng_buffer_size(void)
>  static void add_early_randomness(struct hwrng *rng)
>  {
>         int bytes_read;
> -       size_t size = min_t(size_t, 16, rng_buffer_size());
> +       /* Read enough to initialize crng. */
> +       size_t size = min_t(size_t,
> +                           2*CHACHA20_KEY_SIZE,

This should be as symbolic constant that retains its meaning even if
we move away from ChaCha20 or modify the current implementation

> +                           rng_buffer_size());
>
>         mutex_lock(&reading_mutex);
>         bytes_read = rng_get_data(rng, rng_buffer, size, 1);
>         mutex_unlock(&reading_mutex);
>         if (bytes_read > 0)
> -               add_device_randomness(rng_buffer, bytes_read);
> +               /* Allow crng to become initialized, but do not add
> +                * entropy to the pool.
> +                */
> +               add_hwgenerator_randomness(rng_buffer, bytes_read, 0);
>  }
>
>  static inline void cleanup_rng(struct kref *kref)
> --
> 2.13.5
>
