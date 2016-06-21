From: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] crypto: Jitter RNG - use ktime_get_raw_ns as fallback
Date: Tue, 21 Jun 2016 11:11:42 -0700
Message-ID: <CALAqxLU6-=r8z9dVF5PQCzps-Y4SWcXMd_=QDgZuYj7Dij5whg@mail.gmail.com>
References: <8242305.3NQCWfJAlD@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Arnd Bergmann <arnd@arndb.de>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	y2038 Mailman List <y2038@lists.linaro.org>,
	lkml <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <keescook@chromium.org>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33676 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcFUSLn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 14:11:43 -0400
Received: by mail-ob0-f175.google.com with SMTP id xn17so34474460obc.0
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jun 2016 11:11:43 -0700 (PDT)
In-Reply-To: <8242305.3NQCWfJAlD@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 21, 2016 at 11:05 AM, Stephan Mueller <smueller@chronox.de> wrote:
> As part of the Y2038 development, __getnstimeofday is not supposed to be
> used any more. It is now replaced with ktime_get_raw_ns. Albeit
> ktime_get_raw_ns is monotonic compared to __getnstimeofday, this
> difference is irrelevant as the Jitter RNG uses the time stamp to
> measure the execution time of a given code path and tries to detect
> variations in the execution time. Therefore, the only requirement the
> Jitter RNG has, is a sufficient high resolution to detect these
> variations.
>
> The change was tested on x86 to show an identical behavior as RDTSC. The
> used test code simply measures the execution time of the heart of the
> RNG:
>
>         jent_get_nstime(&time);
>         jent_memaccess(ec, min);
>         jent_fold_time(NULL, time, &folded, min);
>         jent_get_nstime(&time2);
>         return ((time2 - time));
>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> ---
>  crypto/jitterentropy-kcapi.c | 23 ++++++++++++++---------
>  1 file changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/crypto/jitterentropy-kcapi.c b/crypto/jitterentropy-kcapi.c
> index 597cedd..69a2988 100644
> --- a/crypto/jitterentropy-kcapi.c
> +++ b/crypto/jitterentropy-kcapi.c
> @@ -87,24 +87,29 @@ void jent_memcpy(void *dest, const void *src, unsigned int n)
>         memcpy(dest, src, n);
>  }
>
> +/*
> + * Obtain a high-resolution time stamp value. The time stamp is used to measure
> + * the execution time of a given code path and its variations. Hence, the time
> + * stamp must have a sufficiently high resolution. It is valid if the time
> + * runs backwards for short period of time as the RNG code is able handle that.
> + *
> + * Note, if the function returns zero because a given architecture does not
> + * implement a high-resolution time stamp, the RNG code's runtime test
> + * will detect it and will not produce output.
> + */
>  void jent_get_nstime(__u64 *out)
>  {
> -       struct timespec ts;
>         __u64 tmp = 0;
>
>         tmp = random_get_entropy();
>
>         /*
> -        * If random_get_entropy does not return a value (which is possible on,
> -        * for example, MIPS), invoke __getnstimeofday
> +        * If random_get_entropy does not return a value, i.e. it is not
> +        * implemented for a given architecture, invoke ktime_get_raw_ns
>          * hoping that there are timers we can work with.
>          */
> -       if ((0 == tmp) &&
> -          (0 == __getnstimeofday(&ts))) {
> -               tmp = ts.tv_sec;
> -               tmp = tmp << 32;
> -               tmp = tmp | ts.tv_nsec;
> -       }
> +       if (tmp == 0)
> +               tmp = ktime_get_raw_ns();


I don't see in the above an explanation of *why* you're using
ktime_get_raw_ns() instead of ktime_get_ns().

Also the bit about time running backwards being ok is confusing since
you're not using the "fast" accessor where that would be a risk.

thanks
-john
