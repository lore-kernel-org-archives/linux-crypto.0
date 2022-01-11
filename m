Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E4EBC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 11 Jan 2022 18:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344682AbiAKSVS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jan 2022 13:21:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242284AbiAKSVS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jan 2022 13:21:18 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E700C06173F
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 10:21:17 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id r28so6215473wrc.3
        for <linux-crypto@vger.kernel.org>; Tue, 11 Jan 2022 10:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JHS6dcWKDxkneDfxA3B42kjKmrAF9RySBg5ORe4N9K0=;
        b=GGCQ3prfhAyywUTvw6DskdEMhphsMqE5/MK2wRrYIdg4GyQ0UvAe8rm7g/ZTxI6yim
         P6A8tTtN6NipHCYPPP4MOpxZ94JfXPk3va4JpPEBkGcfz9zzeFeqjV0cGaPNikrVuiMr
         uwMVZTW7lkTC4Z14R7DPmDtkV6+rCt41U9irzEgIL0XhBGMiCqkT8yuzywpuDo7kA6FZ
         W8GR8TQ7uMZ0Y8idKyh10pV7yZcKhIEGDyafZ8YMaB+hJyHY179EEMyY/w9ZYquTkxS2
         E/kIwzLVH3mEoYAhQbgR8zakwcV9eYsPfkI4xwq04Du+03TyttH+uJ58YT/P2OPGlZeW
         9LwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JHS6dcWKDxkneDfxA3B42kjKmrAF9RySBg5ORe4N9K0=;
        b=DJeJL2mNXgy6XIlvycXljHFi7Ju2vWVNO6Mj0ERWrd3Vk+pv5abIqA0slO3DR/Q8Qc
         VKnX339wCJTOrw9EwKaLsJ5+TfF2Sl6PZ7x0X+FW0xeDi2Ed3igC4iU1To3aeFrL9oJL
         9+caFgwJzRQLeg75cBcujVBlIJHDhxz7an97AbKXe+xpMd9AR816UwLYzIJfVZ3durIt
         AEHF8ODQIcvXQpu6hjN9oUCQ7s22KSCHbbmY/Zc0lqV/oWMWsdQVBCL1FMlcrkKpPm14
         tD+relpO7R2k6nPpHBqCOGxKluJUziD+2FyZLdTHvpN+SO++9GpdPpgabAEgvTlQ1SGw
         tCTw==
X-Gm-Message-State: AOAM5301rQ/X8a0VcO1xNYMX4i7u5hd+vM/oipO1KALJsypz2WhY0Axn
        E5vZyDOXccVT/EOUXsicH11gsDEru+oRaDhXdedKh7SQ
X-Google-Smtp-Source: ABdhPJzfI3JJ/NG40J3t0bLKLr9EkE8l4sOxkos9Es46SHuZHSmr+kSEpAuomk/k68IVq7OPzZ6bOgedNwJmR2jmhUU=
X-Received: by 2002:a5d:42c3:: with SMTP id t3mr4974667wrr.301.1641925276105;
 Tue, 11 Jan 2022 10:21:16 -0800 (PST)
MIME-Version: 1.0
References: <20220111124104.2379295-1-festevam@gmail.com>
In-Reply-To: <20220111124104.2379295-1-festevam@gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 11 Jan 2022 10:21:05 -0800
Message-ID: <CAHQ1cqE1YO2A2mL9nDv7mjH=pBvNiOCqQwJYA6VOJpu5kRBUtA@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - enable prediction resistance conditionally
To:     Fabio Estevam <festevam@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        Andrei Botila <andrei.botila@nxp.com>, fredrik.yhlen@endian.se,
        hs@denx.de,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Fabio Estevam <festevam@denx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 11, 2022 at 4:41 AM Fabio Estevam <festevam@gmail.com> wrote:
>
> From: Fabio Estevam <festevam@denx.de>
>
> Since commit 358ba762d9f1 ("crypto: caam - enable prediction resistance
> in HRWNG") the following CAAM errors can be seen on i.MX6:
>
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
> caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> hwrng: no data available
>
> OP_ALG_PR_ON is enabled unconditionally, which may cause the problem
> on i.MX devices.

Is this true for every i.MX device? I haven't worked with the
i.MX6Q/i.MX8 hardware I was enabling this feature for in a while, so
I'm not 100% up to date on all of the problems we've seen with those,
but last time enabling prediction resistance didn't seem to cause any
issues besides a noticeable slowdown of random data generation.

Can this be a Kconfig option or maybe a runtime flag so that it'd
still be possible for some i.MX users to keep PR enabled?

>
> Fix the problem by only enabling OP_ALG_PR_ON on platforms that have
> Management Complex support.
>
> Fixes: 358ba762d9f1 ("crypto: caam - enable prediction resistance in HRWNG")
> Signed-off-by: Fabio Estevam <festevam@denx.de>
> ---
>  drivers/crypto/caam/caamrng.c | 15 +++++++++++----
>  1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> index 77d048dfe5d0..3514fe5de2a5 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -63,12 +63,19 @@ static void caam_rng_done(struct device *jrdev, u32 *desc, u32 err,
>         complete(jctx->done);
>  }
>
> -static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma)
> +static u32 *caam_init_desc(struct device *jrdev, u32 *desc, dma_addr_t dst_dma)
>  {
> +       struct caam_drv_private *priv = dev_get_drvdata(jrdev->parent);
> +
>         init_job_desc(desc, 0); /* + 1 cmd_sz */
>         /* Generate random bytes: + 1 cmd_sz */
> -       append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
> -                        OP_ALG_PR_ON);
> +
> +       if (priv->mc_en)
> +               append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
> +                                 OP_ALG_PR_ON);
> +       else
> +               append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
> +
>         /* Store bytes: + 1 cmd_sz + caam_ptr_sz  */
>         append_fifo_store(desc, dst_dma,
>                           CAAM_RNG_MAX_FIFO_STORE_SIZE, FIFOST_TYPE_RNGSTORE);
> @@ -101,7 +108,7 @@ static int caam_rng_read_one(struct device *jrdev,
>
>         init_completion(done);
>         err = caam_jr_enqueue(jrdev,
> -                             caam_init_desc(desc, dst_dma),
> +                             caam_init_desc(jrdev, desc, dst_dma),
>                               caam_rng_done, &jctx);
>         if (err == -EINPROGRESS) {
>                 wait_for_completion(done);
> --
> 2.25.1
>
