Return-Path: <SRS0=Eyne=7C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF554C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 03:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D2A2204EF
	for <linux-crypto@archiver.kernel.org>; Wed, 20 May 2020 03:16:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pVrZ/6JY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728415AbgETDQu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 23:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728129AbgETDQu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 23:16:50 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D5EC061A0E;
        Tue, 19 May 2020 20:16:50 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u1so1190769wmn.3;
        Tue, 19 May 2020 20:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2nEgJxLKt7sGcW4byyIraWO1xaiKoTWBDlRHFJajGbA=;
        b=pVrZ/6JYUCpdV2hhkhm7yrMiS01LBziQOrCkZ6n0GgF/zakoeC3l8pUyrUqJQSnpr5
         CJWskLnBBEGyi+WQU6/AKHCItey6jDnYeEC6yEUHqUncP3LgVUErZdFoItEOxfC9O3gD
         OARa/Ia9GOS3xcjEeOOis//2hccJ/63PkdQqXnSphetieu/le6wV3X3ZA9zMM1WqH7KT
         FwnMJKe/v+GNdlPE4T5KcOCGHOU94BUjWa28lktuvIdHSf0tPCD7eAey47N5DvdvSbFB
         2Nxkiqifr7JEgNuIOFkREHViK0S3cxUjcej+1WtMfP9bT4BRUB4LeBRt6gRZx4HOavtn
         zrDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2nEgJxLKt7sGcW4byyIraWO1xaiKoTWBDlRHFJajGbA=;
        b=hD5UVDpjsx6EZpp3tAY7g5RSOskM0LnBzn+cqwRoMrWe257pI6V4dZ5kIMpFOPULIJ
         CFba0Ex8VEr5vR/FBXt6/MoZvSvoWsINKyurIhMdQa3xq99psWdwrwvFQeqhBxXeDbmo
         1CVEe9Xi2WPPWCTvyVCCYcQM3vgEs3bPk2XBsQ5COh+74K6cTD3ceENYq8ZymkJkSPHE
         pTtc38uUgOGAcp7SRX2rGdLXzrTfxo12rmKLIlXlYkosXOdqvS5+xbLTdDWUF7L6oRMj
         uPumfnieARCgtDOx1tX0FAN1VrrQShu/zw7Z7DyDE1kwksPgO1/NCF2dE2YhR1wurKdl
         m0og==
X-Gm-Message-State: AOAM530YKos5Jv8anRLVBsAlMQoTIuDT717aZehuyKzulQpA4dhSnM2u
        SHbJwubFmtI/it4P9+C1+3aMDp9JlMZI9nVKSBo=
X-Google-Smtp-Source: ABdhPJyorx9rIYjwfGWs5c/+/DTWQX+XeyqUNrSLPfIgnzjXlY3Gkag4N7ICwQCMyFJikPmFhna+ncTjCURuT8j3rrU=
X-Received: by 2002:a7b:c413:: with SMTP id k19mr2459883wmi.124.1589944608931;
 Tue, 19 May 2020 20:16:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200516042303.6070-1-andrew.smirnov@gmail.com> <befcc520-6556-b09b-0464-fe0b5f28cf1e@nxp.com>
In-Reply-To: <befcc520-6556-b09b-0464-fe0b5f28cf1e@nxp.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Wed, 20 May 2020 03:16:37 +0000
Message-ID: <CAHQ1cqHWGJgZUf0zpPt9oX7hbokkwXf7gFGwbgtGSPTRpvNvaQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: caam - make soc match data optional
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Healy <cphealy@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Fabio Estevam <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 18, 2020 at 6:59 PM Horia Geant=C4=83 <horia.geanta@nxp.com> wr=
ote:
>
> On 5/16/2020 7:23 AM, Andrey Smirnov wrote:
> > Vyrbrid devices don't have any clock that need to be taken care of, so
> > make clock data optional on i.MX.
> >
> Vybrid Security RM states that IPG clock used by CAAM
> can be gated by CCM_CCGR11[CG176].
>

Cool, looks like I missed this when I was looking through RM.

> Clock driver needs to be updated accordingly,
> and so will CAAM driver and DT node.
>
> I don't have a board at hand, so patch below is not tested.
>

I'll take it from here and test/submit appropriate patches. Thanks!

> Horia
>
> ------ >8 ------
>
> Subject: [PATCH] clk: imx: vf610: add CAAM clock
>
> According to Vybrid Security RM, CCM_CCGR11[CG176] can be used to
> gate CAAM ipg clock.
>
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@nxp.com>
> ---
>  drivers/clk/imx/clk-vf610.c             | 2 ++
>  include/dt-bindings/clock/vf610-clock.h | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/clk/imx/clk-vf610.c b/drivers/clk/imx/clk-vf610.c
> index cd04e7dc1878..4f3066cf1b89 100644
> --- a/drivers/clk/imx/clk-vf610.c
> +++ b/drivers/clk/imx/clk-vf610.c
> @@ -439,6 +439,8 @@ static void __init vf610_clocks_init(struct device_no=
de *ccm_node)
>         clk[VF610_CLK_DAP] =3D imx_clk_gate("dap", "platform_bus", CCM_CC=
SR, 24);
>         clk[VF610_CLK_OCOTP] =3D imx_clk_gate("ocotp", "ipg_bus", CCM_CCG=
R6, CCM_CCGRx_CGn(5));
>
> +       clk[VF610_CLK_CAAM] =3D imx_clk_gate2("caam", "ipg_bus", CCM_CCGR=
11, CCM_CCGRx_CGn(0));
> +
>         imx_check_clocks(clk, ARRAY_SIZE(clk));
>
>         clk_set_parent(clk[VF610_CLK_QSPI0_SEL], clk[VF610_CLK_PLL1_PFD4]=
);
> diff --git a/include/dt-bindings/clock/vf610-clock.h b/include/dt-binding=
s/clock/vf610-clock.h
> index 95394f35a74a..0f2d60e884dc 100644
> --- a/include/dt-bindings/clock/vf610-clock.h
> +++ b/include/dt-bindings/clock/vf610-clock.h
> @@ -195,6 +195,7 @@
>  #define VF610_CLK_WKPU                 186
>  #define VF610_CLK_TCON0                        187
>  #define VF610_CLK_TCON1                        188
> -#define VF610_CLK_END                  189
> +#define VF610_CLK_CAAM                 189
> +#define VF610_CLK_END                  190
>
>  #endif /* __DT_BINDINGS_CLOCK_VF610_H */
> --
> 2.17.1
