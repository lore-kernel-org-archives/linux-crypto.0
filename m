Return-Path: <SRS0=KZld=OW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58082C65BAE
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Dec 2018 09:48:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CB5221104
	for <linux-crypto@archiver.kernel.org>; Thu, 13 Dec 2018 09:48:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="M3/BKtg8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CB5221104
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbeLMJsY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:48:24 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40557 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbeLMJsT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 04:48:19 -0500
Received: by mail-io1-f68.google.com with SMTP id n9so1084382ioh.7
        for <linux-crypto@vger.kernel.org>; Thu, 13 Dec 2018 01:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MA/7VFDGosHgcPekhBDpGbbUmcrDyTLEUNnFmkYTeqo=;
        b=M3/BKtg8jZ20add7U379jPdCGP7xCZ6ZRKXFIQIZgx+ZBGMgQXlEkBbj//1HuwshJX
         ToL4D1B0RRbirrDMrnwdBHqCgjGUnckEp4gnm4My/zZDch8TqTQnJNq++EmvcB+rQCrL
         y/1z7RNzW29bHR0LqbMsx1bOlr3J15P4ShK1o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MA/7VFDGosHgcPekhBDpGbbUmcrDyTLEUNnFmkYTeqo=;
        b=FNVHpWl5HwWUbOtZGOflSCbIL4JGLBpy5Gnzaa62i4sOqAwQFjTSkFDJwp7NrVW+wM
         f3YZu8LEHadka96sbr1d25hmuSnhGiFKqDDS2HCLy02KUsu7CzDsOdE6rA3yB5Q7VPEN
         09SihoXS4mIAC7oMt4JzJ0J4teVYTqhMsdCaiLvUhWfZULIddsiAaP/lA5Y/o/3N0HOE
         lS5sM/nz3xoeT8hvcT3LodmAU7dYfj5FkxMjG16tTpLZ9HaOLIrUSDusm2ZW20cBWxNG
         wDbbE9qocBto+VfdA0r6zsiDZpwh4/dI51BOhgFIqJyt//xGEg9JrVdeZ2Xeu6pqW/rI
         Vs4w==
X-Gm-Message-State: AA+aEWZFZ3dBLidmZb1a2KOo3FWHooLg8AQjq3mXcbxgAo8KWOoex4gO
        l8ioF+LIpLV3u0rPmWs3qoZLVzlMMRAOL0otDkY41w==
X-Google-Smtp-Source: AFSGD/W3qNGNsBBiGQpBel9ajnA1DwW6xJTBKhxvhQJbcGFMGHVnT4EwvUd8SmxTp25+zCCqk1JOlDtb7Pd/A3jCLyI=
X-Received: by 2002:a5d:8415:: with SMTP id i21mr19613588ion.173.1544694498460;
 Thu, 13 Dec 2018 01:48:18 -0800 (PST)
MIME-Version: 1.0
References: <20181213091848.81327-1-louiscollard@chromium.org>
In-Reply-To: <20181213091848.81327-1-louiscollard@chromium.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 13 Dec 2018 10:48:07 +0100
Message-ID:
 <CAKv+Gu9sWw=VHjYivokAkhGP+p1P15bs3ThfRghARNesW5kyOA@mail.gmail.com>
Subject: Re: [PATCH v2] Allow hwrng to initialize crng.
To:     louiscollard@chromium.org
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
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
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181213094807.LgO-yXzBnVAWfgQTdRi5rtYxzVjmQyt926yQPoywPsA@z>

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
