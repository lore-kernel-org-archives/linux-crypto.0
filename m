Return-Path: <SRS0=anrJ=M4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 034A8C04EBD
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 16:03:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C10102098A
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Oct 2018 16:03:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZuCaMT9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C10102098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbeJPXyr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Oct 2018 19:54:47 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:38476 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbeJPXyr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Oct 2018 19:54:47 -0400
Received: by mail-oi1-f196.google.com with SMTP id u197-v6so18498261oif.5;
        Tue, 16 Oct 2018 09:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LkD2TcRoekYSperrpHrRxxhCFIumWI4YHTvnizpHONg=;
        b=dZuCaMT92hGP56s6iByfHrELgwB4L8fJiy4TDYHQT5s/AexEvTMnKdG/t4Y9bdMrIn
         nL3L6/wchkxdM6QnucopsJZTDav0ezlxw+SpO0XxW/SxrqOUR2b8h5vS2njpD3tUr1rR
         ZYMg4pdyFL//jvC8dfqflfZW6bg9O0v2Gpb26O8wE6gVeYsm8wWuic88hfi+qaoG92Qx
         UHSHl8WVHKoAld5qE+GLNqJvurB38wsxuqRalEc9aAbFg0S1l6fx8VRIqaL4LsBcRnBh
         uFkL6yx3C+WVw5O1Ffd6V+3lIEJtid0fNHA+2vSGxG7vh6mXmpNd2XtfsW32KNJY/mIc
         A68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LkD2TcRoekYSperrpHrRxxhCFIumWI4YHTvnizpHONg=;
        b=FuiLL3yVvxQZU4pir1y0mqPO0Vk8jvIDlM8NhrLz0fWJCX/pT/s+XJha1chy0WlU7E
         xpe71BikgloR8krVTnkTOzRXQcUohM0xufImoodVIp+TpnzE4XKTeOsl7GLFBGU8tZdu
         JSHW54ZaqlUjTQap24cgWAJLCK4V8MnEmIqc4PTIMKAUlGGiTylLVm2SUoADXboCNauR
         QiXEpwknivb57ACjomp9jlngjPynHn/este30gmcK2k/WSw/7l9wscRj7PLNp0DvsulV
         bj0bvakQ8B+13q6Iwy7gfumwWHlBoUmkyQAys+WULKGUJXqRqyGynk/VdKQ880uAxl0x
         xUZw==
X-Gm-Message-State: ABuFfohrndrTsSqsp4Ok8CQwRBzarhaBhOI9My4Zn8ZVeHOvc4pufQv6
        YMxUPROAIEThqaai6OwNo8qnwrHLx7pNsMwHMHs=
X-Google-Smtp-Source: ACcGV62KcEjPjxoyjR/Kx9w2O/R/rS06MQ/VBpGiG8/G4pFBUpvSAlaBlo+JUTokj6dbmE6DOsStkalfmj962y+Cors=
X-Received: by 2002:aca:3083:: with SMTP id w125-v6mr12439461oiw.67.1539705820559;
 Tue, 16 Oct 2018 09:03:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1539705285.git.leonard.crestez@nxp.com> <dcbcaf888bbd0a35dcf34228df2d9eb4fd762ea7.1539705286.git.leonard.crestez@nxp.com>
In-Reply-To: <dcbcaf888bbd0a35dcf34228df2d9eb4fd762ea7.1539705286.git.leonard.crestez@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 16 Oct 2018 13:03:47 -0300
Message-ID:
 <CAOMZO5Ck846zd_Xo=9sVK0EAxNLsUsWiC59H2Ms6x8xoD8iwWw@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] crypto: mxs-dcp - Add support for dcp clk
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <fabio.estevam@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Marek Vasut <marek.vasut@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta Neag <horia.geanta@nxp.com>,
        Franck LENORMAND <franck.lenormand@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        NXP Linux Team <linux-imx@nxp.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181016160347.uPiV6nNW8zOfgnG0COidWJLcCf5zGHLI1iRt1A0CknQ@z>

Hi Leonard,

On Tue, Oct 16, 2018 at 12:58 PM Leonard Crestez
<leonard.crestez@nxp.com> wrote:

> +       /* DCP clock is optional, only used on some SOCs */
> +       sdcp->dcp_clk = devm_clk_get(dev, "dcp");
> +       if (IS_ERR(sdcp->dcp_clk)) {
> +               if (sdcp->dcp_clk != ERR_PTR(-ENOENT))
> +                       return PTR_ERR(sdcp->dcp_clk);
> +               sdcp->dcp_clk = NULL;

This dcp_clk assignment to NULL does not seem to be necessary.

> +
> +       ret = clk_prepare_enable(sdcp->dcp_clk);
> +       if (ret)
> +               return ret;
>
>         ret = devm_request_irq(dev, dcp_vmi_irq, mxs_dcp_irq, 0,
>                                "dcp-vmi-irq", sdcp);
>         if (ret) {
>                 dev_err(dev, "Failed to claim DCP VMI IRQ!\n");

In case of subsequent errors you should call
clk_disable_unprepare(sdcp->dcp_clk).
