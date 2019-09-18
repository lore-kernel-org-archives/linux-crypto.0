Return-Path: <SRS0=f1VZ=XN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 709A0C4CEC9
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 06:01:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 324D420856
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Sep 2019 06:01:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QmOAFiHF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfIRGBU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Sep 2019 02:01:20 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42797 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726442AbfIRGBT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Sep 2019 02:01:19 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so13337409iod.9;
        Tue, 17 Sep 2019 23:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cbGSMpOHfbKLnIF9z4QnPBZdu4GJFMh8oYMZy4NVoII=;
        b=QmOAFiHF0cOXzwvuqgyEEKm2NNy7lbv+yEFWr5kLY37xDpYSy81rXSkFfi12IYG4TX
         aursQcYpzKfaPSK4l3YSxMfC9Chi0sun4Woh30qXFl8sGPGB4KXt4rUxsMpDcdEmOaZA
         Vm7liW+XhNtLxwO1pK4gbU3Wrpuqydhmk0XvS3OMcUNasm818gDNz2LMWAJLGugEETPd
         Dhu8CuPOmd3IhAcgUcwVQanxOh9sZ7jESN3iM+zjkE4eeGhhxzha5rODKtqsZ/yI9aUV
         gqNLXT6YDWgEUQmgjHL8w9faQlecWu6kiazPYfy0IlsNcTXHePPfDUQOyeDoZdh7Xljc
         YE+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cbGSMpOHfbKLnIF9z4QnPBZdu4GJFMh8oYMZy4NVoII=;
        b=inGJNf9vKqeYZNNogKJbL7qq4GoAYrjv1Y090RSc++T0kdLEMk9IfOqapkXHxPcBuc
         tK+G1M5cSYw7fbU/c9B7Ih6lSBcwYPL7utvy9VaEFIw4Uhp0DSe58orxtQgrV5o7Ykpq
         b/qPlVM7TDd69VbMlUAh3pvvkDTVJcMMcQJAkRGx+IQUgbNY6ZNphLUlcL/4lhNA8GrN
         qLJGnA72wAnWgVReb4pMTHF0HlTYgM/XnbInDV+T9UhPJb4Qg6fNA40iclXa6aU7E7DO
         bruR/f98bgHGBGQykBuByhTGKOEgA7YnejDf4R3UhkeVRyx/5M2XbNGjHp+EWygc0s5W
         qSVw==
X-Gm-Message-State: APjAAAUBx5gNMXR8FIWsfFALaFBaIWfnSIwOAvVlr8R7X/tl1vvv8EYG
        Qi6RqhyQg9T7YVd3QH74Pi0/ACxhU5Q8N1Z3OlI=
X-Google-Smtp-Source: APXvYqxW+NsRhBN107cSv+Z2oGee5zjuh7OHq3oL2KgP0qBYiLIw3E86OwRVO5wwEc/XEtqA8kB7ncde4bUhpvMqA0M=
X-Received: by 2002:a6b:c947:: with SMTP id z68mr3406457iof.132.1568786478019;
 Tue, 17 Sep 2019 23:01:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190904023515.7107-1-andrew.smirnov@gmail.com>
 <20190904023515.7107-12-andrew.smirnov@gmail.com> <VI1PR0402MB34859D108C03F3AB0F64EE6598B10@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34859D108C03F3AB0F64EE6598B10@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 17 Sep 2019 23:01:06 -0700
Message-ID: <CAHQ1cqFyPs1vONwV3Ujv6MwqoP=672pCEXFTuM+j20zNPD86tw@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - use the same jr for rng init/exit
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 11, 2019 at 2:35 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 9/4/2019 5:35 AM, Andrey Smirnov wrote:
> > In order to allow caam_jr_enqueue() to lock underlying JR's
> > device (via device_lock(), see commit that follows) we need to make
> > sure that no code calls caam_jr_enqueue() as a part of caam_jr_probe()
> > to avoid a deadlock. Unfortunately, current implementation of caamrng
> > code does exactly that in caam_init_buf().
> >

I don't think your patch addresses the above, so it can probably be
cut out of the message.

> > Another big problem with original caamrng initialization is a
> > circular reference in the form of:
> >
> >  1. caam_rng_init() aquires JR via caam_jr_alloc(). Freed only by
> >     caam_rng_exit()
> >
> >  2. caam_rng_exit() is only called by unregister_algs() once last JR
> >     is shut down
> >
> >  3. caam_jr_remove() won't call unregister_algs() for last JR
> >     until tfm_count reaches zero, which can only happen via
> >     unregister_algs() -> caam_rng_exit() call chain.
> >
> > To avoid all of that, convert caamrng code to a platform device driver
> > and extend caam_probe() to create corresponding platform device.
> >
> > Additionally, this change also allows us to remove any access to
> > struct caam_drv_private in caamrng.c as well as simplify resource
> > ownership/deallocation via devres.
> >
> I would avoid adding platform devices that don't have
> corresponding DT nodes.
>
> There's some generic advice here:
> https://www.kernel.org/doc/html/latest/driver-api/driver-model/platform.h=
tml#legacy-drivers-device-probing
>
> and there's also previous experience in caam driver:
> 6b175685b4a1 crypto: caam/qi - don't allocate an extra platform device
>

Hmm, I am not sure how that experience relates to the case we have
with hwrng, but OK, I'm going to assume that platform driver approach
is a no-go.

> The issue in caamrng is actually that caam/jr driver (jr.c) tries to call
> caam_rng_exit() on the last available jr device.
> Instead, caam_rng_exit() must be called on the same jr device that
> was used during caam_rng_init().
>
> Otherwise, by the time:
>
> void caam_rng_exit(void)
> {
>         if (!init_done)
>                 return;
>
>         caam_jr_free(rng_ctx->jrdev);
>         hwrng_unregister(&caam_rng);
> [...]
>
> is executed, rng_ctx->jrdev might have been removed.
>
> This will cause an oops in caam_jr_free().
> caam_cleanup() - .cleanup hwrng callback that is called when doing
> hwrng_unregister() - also needs to be executed on that jr device.
>
> The problem can be easily reproduced as follows.
>
> If caamrng was initialized on jr0:
> [...]
> caam_jr 2101000.jr0: registering rng-caam
> [...]
>
> then by manually unbinding jr0 first, then jr1 (using i.MX6SX):
> # echo -n "2101000.jr0" > /sys/bus/platform/drivers/caam_jr/
> # echo -n "2102000.jr1" > /sys/bus/platform/drivers/caam_jr/
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000=
040
> pgd =3D 572e14e7
> [00000040] *pgd=3Dbe2e8831
> Internal error: Oops: 17 [#1] SMP ARM
> Modules linked in:
> CPU: 0 PID: 629 Comm: sh Not tainted 5.3.0-rc1-00299-g8e2a2738e5d3-dirty =
#8
> Hardware name: Freescale i.MX6 SoloX (Device Tree)
> PC is at caam_jr_free+0xc/0x24
> LR is at caam_rng_exit+0x20/0x3c
> pc : [<c08aef20>]    lr : [<c08bab1c>]    psr: 200f0013
> sp : e9669e68  ip : 00001488  fp : 00000000
> r10: 00000000  r9 : e9669f80  r8 : e9284010
> r7 : e872d410  r6 : e872d410  r5 : e872d400  r4 : c1aa7cd8
> r3 : 00000000  r2 : 00000040  r1 : 00000000  r0 : e872d010
> Flags: nzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
> Control: 10c5387d  Table: a969004a  DAC: 00000051
> Process sh (pid: 629, stack limit =3D 0xfc1b6e94)
> Stack: (0xe9669e68 to 0xe966a000)
> 9e60:                   e865c940 c08af7dc e872d410 e872d410 c13a9cec c06b=
223c
> 9e80: c06b2218 e872d410 e81a9410 c06b08dc c13806f0 0000000b c13a9cec c06a=
eaf8
> 9ea0: 0000000b 00000000 0000000b e9284000 e91189c0 c0318c3c 00000000 0000=
0000
> 9ec0: e95ddbd0 e8843500 c1308b08 c6614c9f e8843500 00438340 e9668000 0000=
0004
> 9ee0: 00000000 c0285e00 00000001 00000000 00000000 c0288a44 00000000 0000=
0000
> 9f00: c1308b28 00000000 00000001 c130911c 00000001 c13e81d1 c0288a44 0000=
0000
> 9f20: e8ed9800 c019df00 e8ed9a7c c028ac08 00000001 00000000 c0288a44 c661=
4c9f
> 9f40: c1308b08 0000000b 00438340 e9669f80 e8843500 00438340 e9668000 c028=
899c
> 9f60: e95ddbc0 c6614c9f e8843500 e8843500 c1308b08 0000000b 00438340 c028=
8bfc
> 9f80: 00000000 00000000 00000000 c6614c9f 0000000b 00438340 b6ef1da0 0000=
0004
> 9fa0: c01011c4 c0101000 0000000b 00438340 00000001 00438340 0000000b 0000=
0000
> 9fc0: 0000000b 00438340 b6ef1da0 00000004 00438340 0000000b 00000000 0000=
0000
> 9fe0: 0000006c bea7f908 b6e19e58 b6e7325c 600f0010 00000001 00000000 0000=
0000
> [<c08aef20>] (caam_jr_free) from [<c08bab1c>] (caam_rng_exit+0x20/0x3c)
> [<c08bab1c>] (caam_rng_exit) from [<c08af7dc>] (caam_jr_remove+0x38/0xc0)
> [<c08af7dc>] (caam_jr_remove) from [<c06b223c>] (platform_drv_remove+0x24=
/0x3c)
> [<c06b223c>] (platform_drv_remove) from [<c06b08dc>] (device_release_driv=
er_internal+0xdc/0x1a0)
> [<c06b08dc>] (device_release_driver_internal) from [<c06aeaf8>] (unbind_s=
tore+0x5c/0xcc)
> [<c06aeaf8>] (unbind_store) from [<c0318c3c>] (kernfs_fop_write+0xfc/0x1e=
0)
> [<c0318c3c>] (kernfs_fop_write) from [<c0285e00>] (__vfs_write+0x2c/0x1d0=
)
> [<c0285e00>] (__vfs_write) from [<c028899c>] (vfs_write+0xa0/0x180)
> [<c028899c>] (vfs_write) from [<c0288bfc>] (ksys_write+0x5c/0xdc)
> [<c0288bfc>] (ksys_write) from [<c0101000>] (ret_fast_syscall+0x0/0x28)
> Exception stack(0xe9669fa8 to 0xe9669ff0)
> 9fa0:                   0000000b 00438340 00000001 00438340 0000000b 0000=
0000
> 9fc0: 0000000b 00438340 b6ef1da0 00000004 00438340 0000000b 00000000 0000=
0000
> 9fe0: 0000006c bea7f908 b6e19e58 b6e7325c
> Code: eaffff49 e5903040 e2832040 f5d2f000 (e1921f9f)
>
> Thus, I'd say the following fix is needed:
>
> -- >8 --
>
> When caam_rng_exit() executes, the jr device that was used
> during caam_rng_init() must be available.
>
> This means that current scheme - where caam_rng_exit() is called
> when last jr device is removed - is incorrect.
> Instead, caam_rng_exit() has to run when the jr acquired
> during caam_rng_init() is removed.
>
> Fixes: 1b46c90c8e00 ("crypto: caam - convert top level drivers to librari=
es")
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
>
> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.=
c
> index e8baacaabe07..ec40178fa688 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -300,9 +300,9 @@ static struct hwrng caam_rng =3D {
>         .read           =3D caam_read,
>  };
>
> -void caam_rng_exit(void)
> +void caam_rng_exit(struct device *jrdev)
>  {
> -       if (!init_done)
> +       if (!init_done || jrdev !=3D rng_ctx->jrdev)
>                 return;
>
>         caam_jr_free(rng_ctx->jrdev);
> diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
> index 731b06becd9c..4795530203ad 100644
> --- a/drivers/crypto/caam/intern.h
> +++ b/drivers/crypto/caam/intern.h
> @@ -165,7 +165,7 @@ static inline void caam_pkc_exit(void)
>  #ifdef CONFIG_CRYPTO_DEV_FSL_CAAM_RNG_API
>
>  int caam_rng_init(struct device *dev);
> -void caam_rng_exit(void);
> +void caam_rng_exit(struct device *jrdev);
>
>  #else
>
> @@ -174,7 +174,7 @@ static inline int caam_rng_init(struct device *dev)
>         return 0;
>  }
>
> -static inline void caam_rng_exit(void)
> +static inline void caam_rng_exit(struct device *jrdev)
>  {
>  }
>
> diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
> index d11956bc358f..61aea11773a6 100644
> --- a/drivers/crypto/caam/jr.c
> +++ b/drivers/crypto/caam/jr.c
> @@ -53,7 +53,6 @@ static void unregister_algs(void)
>
>         caam_qi_algapi_exit();
>
> -       caam_rng_exit();
>         caam_pkc_exit();
>         caam_algapi_hash_exit();
>         caam_algapi_exit();
> @@ -126,6 +125,8 @@ static int caam_jr_remove(struct platform_device *pde=
v)
>         jrdev =3D &pdev->dev;
>         jrpriv =3D dev_get_drvdata(jrdev);
>
> +       caam_rng_exit(jrdev);
> +
>         /*
>          * Return EBUSY if job ring already allocated.
>          */
