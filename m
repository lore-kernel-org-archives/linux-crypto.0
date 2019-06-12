Return-Path: <SRS0=xlya=UL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4EDDC31E44
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 02:01:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FBC520883
	for <linux-crypto@archiver.kernel.org>; Wed, 12 Jun 2019 02:01:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p5WwRCYK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406425AbfFLCB3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 11 Jun 2019 22:01:29 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:52673 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405070AbfFLCB3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 11 Jun 2019 22:01:29 -0400
Received: by mail-it1-f193.google.com with SMTP id l21so8287979ita.2;
        Tue, 11 Jun 2019 19:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iHeTl9h5MAISC73trVD9Z9vYX3/i6GRbRI15G+TC7d4=;
        b=p5WwRCYKXyFPfLjGMHtHkZUxI7g1Wr8ep6fol34IecTcd7Fen5hswE5Nfh3DSlIdet
         hFaBAumqeGhSdfBtn7B0cy6w/YYTwzOQ/4SsRIAUYm2DSBua7fyiwx7PWPmK5zS6bD88
         y+FGWaVEAB0y0rS8lmoPQUByuovlWqVYHFtH6fRVqxxBmdwnrtaEYsaaNyBq4fnvBZhV
         ZrlMhfQXeZTEw9MtP6mp+b+exiU/xlbPG3/RayJA50MSpY1sd7Z+571sZ7yW9J5hOezz
         7RSAq6CfmSwDjZEyXkEK0RJQqbV8/gCQKuUUmUtg9gcCLBaUIi4FZlMhBe1+KZIxfsVa
         23gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iHeTl9h5MAISC73trVD9Z9vYX3/i6GRbRI15G+TC7d4=;
        b=KmTsusZP+1XYL+vFLleVvrNREc5RHTbFldAP4qFXCil+5CNHm83Nn0jY0QHxEuaDsZ
         aiOJk9eU/Mtj7lt8kdU+X4lXX69Tcu/0yPfQe5Mlc+eyqlhh1Q+BZ7xhZ4OljlBgbsHY
         8AfcOgGHnX/jSVIuaZZxchfI7ViouEWEO2m8x9Nqxt9bE6KcmLPKdd2vRj+3v4efnA2w
         sEH4GBFV37MZP0TIZ2owEeXzyqanfraBmhZoULmgSa9eYIUnlhm6NbUxIWjE1+gZniN1
         3JKwrYl57pl6rq5iXi6QYoC3u4Hwjt1HpRs++xQtmmnm6s+b5cJ0iRG6x2+XLlwX8vNA
         AcUg==
X-Gm-Message-State: APjAAAVLUkV53stQa5qntCQtbq13oMuy+FOTXttXmep3FVi0+fxCHNmT
        tptAeVP7OGJWBsWXeF94Wxd/8aGcuEeVFTvDzEk=
X-Google-Smtp-Source: APXvYqydEFgmHWzcLByfz0Xbu9y58yiU4/4j49WJ5O9z2avVjWScConp9krearwOkeSkCy0gZjMRSftCqtqf5M+FICo=
X-Received: by 2002:a02:5b05:: with SMTP id g5mr49218359jab.114.1560304888209;
 Tue, 11 Jun 2019 19:01:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190607200225.21419-1-andrew.smirnov@gmail.com>
 <20190607200225.21419-2-andrew.smirnov@gmail.com> <VI1PR0402MB34855AC8C617A3D7A584A1B798ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB34855AC8C617A3D7A584A1B798ED0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Tue, 11 Jun 2019 19:01:16 -0700
Message-ID: <CAHQ1cqGcDm6MGnmn3=SKBYNkToP_T+-SEHSvOBtq8FGcRoTb6Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] crypto: caam - do not initialise clocks on the i.MX8
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abel Vesa <abel.vesa@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 11, 2019 at 2:56 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 6/7/2019 11:03 PM, Andrey Smirnov wrote:
> > From: Chris Spencer <christopher.spencer@sea.co.uk>
> >
> > There are no clocks that the CAAM driver needs to initialise on the
> > i.MX8.
> >
> RM lists 5 clocks for CAAM module (instance.clock): caam.aclk, caam.ipg_clk,
> caam.ipg_clk_s, caam_exsc.aclk_exsc, caam_mem.clk
>
> Wouldn't it be better to have these clocks in DT, instead of relying that their
> root clocks (ccm_ahb_clk_root, ccm_ipg_clk_root) are critical / always on?
>

Is it even possible to use the SoC in a meaningful way if
ccm_ahb_clk_root or ccm_ipg_clk_root are disabled? It doesn't seem
that dependency on either is expressed in a consistent manner for
other IP blocks in imx8mq.dtsi. OTOH, it should be trivial to add
<&clk IMX8MQ_CLK_IPG_ROOT> and <&clk IMX8MQ_CLK_AHB> as "ipg" and
"aclk" to CAAM node and it would allow me to drop an extra patch from
the series, so I may as well do it.

Thanks,
Andrey Smirnov
