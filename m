From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH v5 REPOST 1/6] hw_random: place mutex around read
 functions and buffers.
Date: Mon, 25 Sep 2017 15:00:45 -0700
Message-ID: <CAKdAkRSF1qJv_03PJh44gkQ7NOJ3ccW2EwPckGvch=iUYY1-Qw@mail.gmail.com>
References: <1418028640-4891-1-git-send-email-akong@redhat.com> <1418028640-4891-2-git-send-email-akong@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-crypto@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rusty Russell <rusty@rustcorp.com.au>, kvm@vger.kernel.org,
        Michael Buesch <m@bues.ch>, Matt Mackall <mpm@selenic.com>,
        amit.shah@redhat.com, lkml <linux-kernel@vger.kernel.org>
To: Amos Kong <akong@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1418028640-4891-2-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

A bit late to a party, but:

On Mon, Dec 8, 2014 at 12:50 AM, Amos Kong <akong@redhat.com> wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
>
> There's currently a big lock around everything, and it means that we
> can't query sysfs (eg /sys/devices/virtual/misc/hw_random/rng_current)
> while the rng is reading.  This is a real problem when the rng is slow,
> or blocked (eg. virtio_rng with qemu's default /dev/random backend)
>
> This doesn't help (it leaves the current lock untouched), just adds a
> lock to protect the read function and the static buffers, in preparation
> for transition.
>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
...
>
> @@ -160,13 +166,14 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
>                         goto out_unlock;
>                 }
>
> +               mutex_lock(&reading_mutex);

I think this breaks O_NONBLOCK: we have hwrng core thread that is
constantly pumps underlying rng for data; the thread takes the mutex
and calls rng_get_data() that blocks until RNG responds. This means
that even user specified O_NONBLOCK here we'll be waiting until
[hwrng] thread releases reading_mutex before we can continue.

>                 if (!data_avail) {
>                         bytes_read = rng_get_data(current_rng, rng_buffer,
>                                 rng_buffer_size(),
>                                 !(filp->f_flags & O_NONBLOCK));
>                         if (bytes_read < 0) {
>                                 err = bytes_read;
> -                               goto out_unlock;
> +                               goto out_unlock_reading;
>                         }
>                         data_avail = bytes_read;
>                 }

Thanks.

-- 
Dmitry
