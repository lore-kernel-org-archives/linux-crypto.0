Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53374C432BE
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Aug 2021 11:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B92F61153
	for <linux-crypto@archiver.kernel.org>; Mon, 30 Aug 2021 11:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhH3Luf (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Aug 2021 07:50:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbhH3Luc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Aug 2021 07:50:32 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65CCC061575;
        Mon, 30 Aug 2021 04:49:38 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id f2so25415078ljn.1;
        Mon, 30 Aug 2021 04:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s6//sCmOyXWXB8hu7+TrVIqFvxKd8SH1B+q5uGJLLc8=;
        b=bhS8Yxgyz6NpG4F5GTdY7r+8pbH1Ri7JJAZHKSi52jnfofzEmjVcSpkZ5dYoyljEBK
         AFsU623eS0MyqHPrhcAIdBEY33eYGRKmA8WxRuwsb8ppsIvkeSo0KX1hSTtAU7ebFV7J
         3dPfxQudNlqOU743/GHzkOtPtzJdURGbX2sFwx/V/emJnhEGUydioVG4brkmcj15Q1Id
         IDdN6vW66LaGjrCtp9rp+ahff9LxYVLXEY0AunhobgiPuZeAOf7Cskm5HNnHroMdKHxX
         1TDmo8DrX08rbtNwMWi/UeOkyvD4wiatHyTlhBuoGzurMklzivlw5sjMjz8vZ79LTp/F
         p4qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s6//sCmOyXWXB8hu7+TrVIqFvxKd8SH1B+q5uGJLLc8=;
        b=kpIRAgwo+wfgC0GPbFfTcUacSc+emHTMRffE3FWLBvYPgVT2p71kQan4ZoPQSdlGbw
         tvSGpwVsl+okZVj/SN8Dab19DVpHuj+tpre4Pq+/BVjrd1v4wQ6wouPIemO9DjqjHGup
         /1oOYhKhxPDjyuQHjK6guVRu0N0y9OlhF/fjWfX/C5cjdL//ejE6uPU05+RdMzz/4wT9
         TiHL3doQUBZ06cihRjMtyw9XcLrySttadpwQNjbaySjJI0Bhcxs636pMW3Vwo3t1WMIv
         BltqUw55GOOlS5UV6mD6RL8pSXLebM96SAHOd5I6LGusLFkoBResHt/NSKcQltYCwJw3
         YAqQ==
X-Gm-Message-State: AOAM530sZ7WFW12FOn9OAzcVhni700OxQSi/zO3pSvxQYoY48k+Q9iTW
        UBVs/e8mdiHuJ0/siqe2C6HZ8h8Ahcv1xN9GxLM=
X-Google-Smtp-Source: ABdhPJw/3akcjehWE6r9u8bvWUmPDiTN3wDE+DGRfrqpA0nA3D4HB3N9lIXdT/qdc6hmkWvxXJ49qTiJLCmHTZBJY2o=
X-Received: by 2002:a2e:a788:: with SMTP id c8mr20444652ljf.116.1630324176960;
 Mon, 30 Aug 2021 04:49:36 -0700 (PDT)
MIME-Version: 1.0
References: <YSy/PFrem+a7npBy@gmail.com>
In-Reply-To: <YSy/PFrem+a7npBy@gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 30 Aug 2021 08:49:25 -0300
Message-ID: <CAOMZO5D0m1xCfgFifKz1H+oYQSfxsfuZp4U39rPMACmzv1fvjQ@mail.gmail.com>
Subject: Re: HRNG in CAAM isn't working properly on IMX6 SoloX
To:     Fredrik Yhlen <fredrik.yhlen@endian.se>
Cc:     Horia Geanta Neag <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Heiko Schocher <hs@denx.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Fredrik,

On Mon, Aug 30, 2021 at 8:22 AM Fredrik Yhlen <fredrik.yhlen@endian.se> wrote:
>
> Hi,
>
> We're having problems with hwrng on a board with imx6sx (soloX) running Linux
> 5.10.x. mainline, and I have tracked it down to this commit
> '358ba762d9f1d4ba99ab31ef12bc28014b22f4c9' as being the culprit.
>
> The caam_jr driver spits out lots of messages when attempting to read from /dev/hwrng:
> ```
> [29717.629041] hwrng: no data available
> [29727.859008] caam_jr 2101000.jr: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> ```
>
> ```
> caam_jr 2101000.jr0: 2000025b: CCB: desc idx 2: RNG: Hardware error.
> caam_jr 2101000.jr0: 20003c5b: CCB: desc idx 60: RNG: Hardware error.
> caam_jr 2101000.jr0: 20003c5b: CCB: desc idx 60: RNG: Hardware error.
> caam_jr 2101000.jr0: 20003c5b: CCB: desc idx 60: RNG: Hardware error.
> caam_jr 2101000.jr0: 20003c5b: CCB: desc idx 60: RNG: Hardware error.
> caam_jr 2101000.jr0: 20003c5b: CCB: desc idx 60: RNG: Hardware error.
> ```
>
> This also happens on Boundary's Nitrogen6_soloX board when running the same
> kernel, and likewise with their latest Yocto release that uses 5.4.100 linux-imx kernel.
>
> ```
> root@nitrogen6sx:~# dd if=/dev/hwrng of=/tmp/random bs=256 count=10
> [  113.940735] caam_jr 2101000.jr0: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> dd: /dev/hwrng: Invalid argument
> root@nitrogen6sx:~# rm /tmp/random
> root@nitrogen6sx:~# dd if=/dev/hwrng of=/tmp/random bs=256 count=10
> [  125.300823] caam_jr 2101000.jr0: 20003c5b: CCB: desc idx 60: RNG: Hardware error
> dd: /dev/hwrng: Invalid argument
> root@nitrogen6sx:~# du -hs /tmp/random
> 0       /tmp/random
> root@nitrogen6sx:~# ls -l /tmp/random
> -rw-r--r--    1 root     root             0 Dec 16 17:27 /tmp/random
> root@nitrogen6sx:~#
> ```
>
> And then no data is available from /dev/hwrng.
>
> The problem occurs when adding OP_ALG_PR_ON(prediction resistance) when setting up
> job descriptor for reading new random data in caamrng.c. There are also
> some confusing parts about this commit that I'm not too sure about.
>
> 1. It's adding a conditional variable named 'pr_support', but I guess this only
> indicates if the MC(Management Complex) supports prediction resistance,
> since the following check can be bypassed when 'pr_support' is false.
>
>     /*
>      * If SEC has RNG version >= 4 and RNG state handle has not been
>      * already instantiated, do RNG instantiation
>      * In case of SoCs with Management Complex, RNG is managed by MC f/w.
>      */
>     if (!(ctrlpriv->mc_en && pr_support) && rng_vid >= 4) {
>
>
> This will eventually lead to the following chain call: caam_probe() -> instantiate_rng() ->
> build_instantiation_desc(), where OP_ALG_PR_ON will be used through DECO.
>
> static void build_instantiation_desc(u32 *desc, int handle, int do_sk)
> {
>     u32 *jump_cmd, op_flags;
>
>     init_job_desc(desc, 0);
>
>     op_flags = OP_TYPE_CLASS1_ALG | OP_ALG_ALGSEL_RNG |
>             (handle << OP_ALG_AAI_SHIFT) | OP_ALG_AS_INIT |
>             OP_ALG_PR_ON;
>     ...
>     ...
>     ...
>
> Shouldn't it be named 'mc_pr_support' instead, or something similar?
>
> 2. PR is unconditionally used in caamrng.c(caam_jr module) when
> reading new RNG data. Should this be the case?
>
> Removing OP_ALG_PR_ON in caam_init_desc() from drivers/crypto/caam/caamrng.c
> seems to fix the problem we're experiencing, here's an example:
> ```
> diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
> index 77d048dfe5d0..f085a80b1b3c 100644
> --- a/drivers/crypto/caam/caamrng.c
> +++ b/drivers/crypto/caam/caamrng.c
> @@ -67,8 +67,7 @@ static u32 *caam_init_desc(u32 *desc, dma_addr_t dst_dma)
>  {
>         init_job_desc(desc, 0); /* + 1 cmd_sz */
>         /* Generate random bytes: + 1 cmd_sz */
> -       append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG |
> -                        OP_ALG_PR_ON);
> +       append_operation(desc, OP_ALG_ALGSEL_RNG | OP_TYPE_CLASS1_ALG);
>         /* Store bytes: + 1 cmd_sz + caam_ptr_sz  */
>         append_fifo_store(desc, dst_dma,
>                           CAAM_RNG_MAX_FIFO_STORE_SIZE, FIFOST_TYPE_RNGSTORE);
> ```

We also observe this issue.

Heiko on Cc tried increasing the RTSDCTL_ENT_DLY_MIN value
and this seems to help:

diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index af61f3a2c0d4..53c9fa04a24c 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -513,7 +513,7 @@ struct rng4tst {
  };
 #define RTSDCTL_ENT_DLY_SHIFT 16
 #define RTSDCTL_ENT_DLY_MASK (0xffff << RTSDCTL_ENT_DLY_SHIFT)
-#define RTSDCTL_ENT_DLY_MIN 3200
+#define RTSDCTL_ENT_DLY_MIN 4800
 #define RTSDCTL_ENT_DLY_MAX 12800
  u32 rtsdctl; /* seed control register */
  union {

Does this help in your case?

Thanks,

Fabio Estevam
