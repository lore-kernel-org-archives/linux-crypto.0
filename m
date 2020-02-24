Return-Path: <SRS0=ApwQ=4M=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F845C11D30
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 17:16:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39BA520880
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Feb 2020 17:16:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E2kHgHUH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgBXRQ3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Feb 2020 12:16:29 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42788 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727746AbgBXRQ2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Feb 2020 12:16:28 -0500
Received: by mail-wr1-f66.google.com with SMTP id p18so7678698wre.9;
        Mon, 24 Feb 2020 09:16:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0mUehRl6KMNyxPy2WBMaLDkn8cB+64Jlo40lEAysQVs=;
        b=E2kHgHUHZYFsu4ArMDd4YgaJnRYKXqg8RXElwRek/AS2KEntghEVplQNAcQti8+QYa
         rgxez2p0woWT2m/Ys7GaVR7bLGVp6QvLSdlXWSiC+0aJ2rEkKD3cifLSilvFe/r/iYWO
         rkyGwVoOhKMB7M6toZl/8D9psgbqaADgxzuqYKe9kCN4e3fxXhvaM3iMP1tYr5WmVQ5t
         r0jOy+vG67yYgM8T9v7gh5oLkfl6qZc8Ahthf3WMefV5aKjhyfWxKy5D5SjEnJzaFo9f
         eJ/Q2MmuZOIq+uylv93xouAuCnZEwsR/gg+yM4qfGgh2AOkjFdp4lKQayaRfmgc//bwc
         OwbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0mUehRl6KMNyxPy2WBMaLDkn8cB+64Jlo40lEAysQVs=;
        b=nEq56RScbod6X9PTM44GzVuAtVX93XFfQre72cRXI8fqN2V+0X/iBY8ZpaYyZTKnY+
         cNi3C5KRCBj2H6D/TLZwCmx9KLtNG0iA2YHijHGPRclHEJGyrW4YOSZWipNidnMboZwj
         oy5V17l8CziZg+15tjzRZIOVmLSCRfYai70gOZM4FVHQnTjkoRO5+X+0LDJwd31Ej6dp
         ltSfAgKZGlS39mwj+4c7yZp8gSI+P5k+87LUKRMrAmDc6jWFzWWxuaTwpE8ssxdy81fa
         Y9M3kx/zi59jt3SZBOw3oHzNyyzx/hr+FhIbpGHtsxNi5na+CmeuBXmVudNe27hkSxTj
         pX/g==
X-Gm-Message-State: APjAAAU8Rgv915phJmYm7icEOu7od2I3Qz540R050LQtvBp/l5n9rD+Y
        0pI7pzaA04z5VxFdd4zj2jssBXbhJPYJCv+sOhg=
X-Google-Smtp-Source: APXvYqyYs34kxyM1cQUafvzz2HLWMvmqs3efpVNtCRIY34M1tXu+q5qXU2FMmODfmEHBzQsVh9zoKosyUtXRmIs7/x8=
X-Received: by 2002:adf:fac9:: with SMTP id a9mr3637820wrs.232.1582564585869;
 Mon, 24 Feb 2020 09:16:25 -0800 (PST)
MIME-Version: 1.0
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
 <20200127165646.19806-6-andrew.smirnov@gmail.com> <VI1PR0402MB348549DDA8FE2EEB436D3F09981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB348549DDA8FE2EEB436D3F09981B0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 24 Feb 2020 09:16:14 -0800
Message-ID: <CAHQ1cqGYEubQMS2y7nPnTo=Bbs=97ojCu6OjyNkc6dcVO_w_cA@mail.gmail.com>
Subject: Re: [PATCH v7 5/9] crypto: caam - simplify RNG implementation
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 12, 2020 at 5:20 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 1/27/2020 6:57 PM, Andrey Smirnov wrote:
> > Rework CAAM RNG implementation as follows:
> >
> > - Make use of the fact that HWRNG supports partial reads and will
> > handle such cases gracefully by removing recursion in caam_read()
> >
> > - Convert blocking caam_read() codepath to do a single blocking job
> > read directly into requested buffer, bypassing any intermediary
> > buffers
> >
> > - Convert async caam_read() codepath into a simple single
> > reader/single writer FIFO use-case, thus simplifying concurrency
> > handling and delegating buffer read/write position management to KFIFO
> > subsystem.
> >
> > - Leverage the same low level RNG data extraction code for both async
> > and blocking caam_read() scenarios, get rid of the shared job
> > descriptor and make non-shared one as a simple as possible (just
> > HEADER + ALGORITHM OPERATION + FIFO STORE)
> >
> > - Split private context from DMA related memory, so that the former
> > could be allocated without GFP_DMA.
> >
> > NOTE: On its face value this commit decreased throughput numbers
> > reported by
> >
> >   dd if=/dev/hwrng of=/dev/null bs=1 count=100K [iflag=nonblock]
> >
> > by about 15%, however commits that enable prediction resistance and
> Running dd as mentioned above, on a i.MX8MM board I see:
> ~ 20% decrease in non-blocking case (525 kB/s vs. 662 kB/s)
> ~ 75% decrease in blocking case (170 kB/s vs. 657 kB/s)
>
> bs=1 is a bit drastic.
> Using bs=16 the numbers look better in terms of overall speed,
> however the relative degradation is still there:
> ~ 66% decrease in blocking case (3.5 MB/s vs. 10.1 MB/s)
>
> > limit JR total size impact the performance so much and move the
> > bottleneck such as to make this regression irrelevant.
> >
> Yes, performance is greatly impacted by moving from a DRBG configuration
> to a TRNG one.
>
> The speed that I get with this patch set (1.3 kB/s)
> is ~ 20% lower than theoretical output (1.583 kB/s) (see below).
> Seeing this and also the relative decrease in case of DRBG
> makes me wonder whether the SW overhead could be lowered.
>
> Theoretical TRNG output speed in this configuration
> can be computed as:
> Speed = (SZ x CAAM_CLK_FREQ) / (RTSDCTL[ENT_DLY] x RTSDCTL[SAMP_SIZE]) [bps]
>
> SZ is sample taken from the DRBG, b/w two consecutive reseedings.
> As previously discussed, this is limited to 128 bits (16 bytes),
> such that the DRBG behaves as a TRNG.
>
> If:
> -CAAM_CLK_FREQ = 166 MHz (as for i.MXM*)
> -RTSDCTL[ENT_DLY] = 3200 clocks (default / POR value)
> -RTSDCTL[SAMP_SIZE] = 512 (recommended; default / POR value is 2500)
> then theoretical speed is 1.583 kB/s.
>
> > @@ -45,38 +22,34 @@
> >  #include "jr.h"
> >  #include "error.h"
> >
> > +/* length of descriptors */
> This comment is misplaced, length of descriptors (CAAM_RNG_DESC_LEN)
> is further below.
>
> > +#define CAAM_RNG_MAX_FIFO_STORE_SIZE U16_MAX
> > +
> > +#define CAAM_RNG_FIFO_LEN            SZ_32K /* Must be a multiple of 2 */
> > +
> >  /*
> > - * Maximum buffer size: maximum number of random, cache-aligned bytes that
> > - * will be generated and moved to seq out ptr (extlen not allowed)
> > + * See caam_init_desc()
> >   */
> > -#define RN_BUF_SIZE                  (0xffff / L1_CACHE_BYTES * \
> > -                                      L1_CACHE_BYTES)
> > +#define CAAM_RNG_DESC_LEN (CAAM_CMD_SZ +                             \
> > +                        CAAM_CMD_SZ +                                \
> > +                        CAAM_CMD_SZ + CAAM_PTR_SZ_MAX)
>
> > +typedef u8 caam_rng_desc[CAAM_RNG_DESC_LEN];
> Is this really necessary?
>

Will drop in v8.

> > -static int caam_read(struct hwrng *rng, void *data, size_t max, bool wait)
> > +static int caam_rng_read_one(struct device *jrdev,
> > +                          void *dst, int len,
> > +                          void *desc,
> > +                          struct completion *done)
> [...]
> > +     len = min_t(int, len, CAAM_RNG_MAX_FIFO_STORE_SIZE);
> For the blocking case, i.e. caam_read() -> caam_rng_read_one(),
> "len" is at least 32B - cf. include/linux/hw_random.h:
>  * @read:               New API. drivers can fill up to max bytes of data
>  *                      into the buffer. The buffer is aligned for any type
>  *                      and max is a multiple of 4 and >= 32 bytes.
>
> For reducing the SW overhead, it might be worth optimizing this path.
> For example, considering
> min_t(int, len, CAAM_RNG_MAX_FIFO_STORE_SIZE) = CAAM_RNG_MAX_FIFO_STORE_SIZE

This isn't true until next commit. Here CAAM_RNG_MAX_FIFO_STORE_SIZE
is still 32K, so "len" is going to be smaller. I'll update the code to
assume fixed length once CAAM_RNG_MAX_FIFO_STORE_SIZE becomes 16
bytes.

> this means length is fixed, thus also ctx->desc[DESC_SYNC] descriptor is fixed
> and its generation could be moved out of the hot path.

That descriptor also includes DMA address of a buffer we are given, so
the descriptor is never fixed.

Thanks,
Andrey Smirnov
