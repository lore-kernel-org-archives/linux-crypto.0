From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: virtio:rng: Virtio RNG devices need to be re-registered after suspend/resume
Date: Fri, 3 Nov 2017 21:06:35 +0530
Message-ID: <CANc+2y6=PDGWzu0s9wEZDnOyJZAfHdB=_YzJiwgVkaSqhzp3nA@mail.gmail.com>
References: <1509703041-6281-1-git-send-email-Jim.Quigley@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>
To: Jim Quigley <Jim.Quigley@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:52458 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754764AbdKCPgg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 11:36:36 -0400
Received: by mail-io0-f194.google.com with SMTP id f20so7092329ioj.9
        for <linux-crypto@vger.kernel.org>; Fri, 03 Nov 2017 08:36:36 -0700 (PDT)
In-Reply-To: <1509703041-6281-1-git-send-email-Jim.Quigley@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jim,

Minor comment below.

On 3 November 2017 at 15:27, Jim Quigley <Jim.Quigley@oracle.com> wrote:
> The patch for
>
> commit: 5c06273401f2eb7b290cadbae18ee00f8f65e893
> Author: Amit Shah <amit.shah@redhat.com>
> Date:   Sun Jul 27 07:34:01 2014 +0930
>
>     virtio: rng: delay hwrng_register() till driver is ready
>
> moved the call to hwrng_register() out of the probe routine into the scan
> routine. We need to call hwrng_register() after a suspend/restore cycle
> to re-register the device, but the scan function is not invoked for the
> restore. Add the call to hwrng_register() to virtio_restore().
>
> Reviewed-by: Liam Merwick <Liam.Merwick@oracle.com>
> Signed-off-by: Jim Quigley <Jim.Quigley@oracle.com>
> ---
>  drivers/char/hw_random/virtio-rng.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
> index 3fa2f8a..b89df66 100644
> --- a/drivers/char/hw_random/virtio-rng.c
> +++ b/drivers/char/hw_random/virtio-rng.c
> @@ -184,7 +184,26 @@ static int virtrng_freeze(struct virtio_device *vdev)
>
>  static int virtrng_restore(struct virtio_device *vdev)
>  {
> -       return probe_common(vdev);
> +       int err;
> +
> +       err = probe_common(vdev);
> +       if (!err) {
> +               struct virtrng_info *vi = vdev->priv;
> +
> +               /*
> +                * Set hwrng_removed to ensure that virtio_read()
> +                * does not block waiting for data before the
> +                * registration is complete.
> +                */
> +               vi->hwrng_removed = true;

Hwrng core does not call read method till hwrng_register has finished.
Is this really required? I think it has no effect.

> +               err = hwrng_register(&vi->hwrng);
> +               if (!err) {
> +                       vi->hwrng_register_done = true;
> +                       vi->hwrng_removed = false;
> +               }
> +       }
> +
> +       return err;
>  }
>  #endif
>
> --
> 1.8.3.1
>

I am fine with this change as is. Reviewed-by: PrasannaKumar
Muralidharan <prasannatsmkumar@gmail.com>

Regards,
PrasannaKumar
