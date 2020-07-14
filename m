Return-Path: <SRS0=vKog=AZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03CDEC433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 12:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D46C022453
	for <linux-crypto@archiver.kernel.org>; Tue, 14 Jul 2020 12:48:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDqqD/EA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbgGNMsQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 14 Jul 2020 08:48:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728049AbgGNMsP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 14 Jul 2020 08:48:15 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240FCC061755;
        Tue, 14 Jul 2020 05:48:15 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so22439467ljj.10;
        Tue, 14 Jul 2020 05:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ou2c+Y4ocksj5FtnaDLrroq0j5xVq/IWLcnDWLiQ6Dk=;
        b=EDqqD/EAEzPy6cYw9EYkELqFwbGBKIM0SjzVCXs0AQwKMlgaF15SI+Vg+iZ/nUvo42
         G4p+pzGZL+B9nfhSFgpXvVcp5tJbasB+zUotfokeH0lNJNMmtePeoFMUngSohjcisPgB
         ViZo6K12ikMU/Pmmt3v4CxoEJnFquvJ9qzEg0TmC/Q92t6EVV/2BzQY4rA0tkFPoJH8u
         clckWvHoFtssjZ+h/Pt2UFA81QEB4JfMn2GdOYo/SF5MRm1evYu/7laqbKwPB0wb5XcE
         QplLpvlbmO4jLD2LwH3RN3IBVBupQMVyf8G46zzGE2JRFXbkShz0Pt6rqzyUPWmavzuN
         mazA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ou2c+Y4ocksj5FtnaDLrroq0j5xVq/IWLcnDWLiQ6Dk=;
        b=ExrjRMzDYGv1ViTnAdmTex/xUHgKLtJL4F6egTwXsebGxO7mxGML3v+1j3+WkxrVYq
         2vfpT0hOJpzAT/fkdZl1z2Wvy6q5VriSYuD4eEVWb11gQkbXoqWN3z/rnSHgqaODZmmD
         69i9J0On4TRtFjhe61vziZCy2kQJayXGCBSy52Qp2JzkcOMNqmWa7hrKIKaLdgS2X/5H
         diaDMcff/atgnXe/6IzBrLI2jOQl38QmHkJWIlLvBbOdt4h7ODy59GqxNsDQAIsFYHBc
         pJiCUMSVwssxNDTKMhxay6JH+NUMrOZ9swgpObYZtvXyYSlXZn4M9l3H22GFq4mVEyiK
         ChQQ==
X-Gm-Message-State: AOAM532z6IDt6F2XDacO1RUwszy9gDTkjgjU8BfeNp11YZIPjwNvjlEd
        wKCUvjQmCTmz25+pOcUHj7UpFjziRJpT2WaaHNU=
X-Google-Smtp-Source: ABdhPJwZT2oTeFEXtSJJBhdvrMRetYxl7UuILWW3tQaQRvYRjdvG7E2x8Zgbp/ce+/49J8u6kIYaiLGEtT+34l1zzew=
X-Received: by 2002:a2e:a168:: with SMTP id u8mr2062083ljl.178.1594730893460;
 Tue, 14 Jul 2020 05:48:13 -0700 (PDT)
MIME-Version: 1.0
References: <20200714123920.23711-1-horia.geanta@nxp.com> <20200714123920.23711-6-horia.geanta@nxp.com>
In-Reply-To: <20200714123920.23711-6-horia.geanta@nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Tue, 14 Jul 2020 09:48:02 -0300
Message-ID: <CAOMZO5DSRy7LZS_SZw2dCyxKyAq4XCdVPiS3LiuaR7oWjtG8kw@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] hwrng: imx-rngc: enable driver for i.MX6
To:     =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Martin Kaiser <martin@kaiser.cx>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 14, 2020 at 9:39 AM Horia Geant=C4=83 <horia.geanta@nxp.com> wr=
ote:

>  static const struct of_device_id imx_rngc_dt_ids[] =3D {
>         { .compatible =3D "fsl,imx25-rngb", .data =3D NULL, },
> +       { .compatible =3D "fsl,imx6sl-rngb", .data =3D NULL, },
> +       { .compatible =3D "fsl,imx6sll-rngb", .data =3D NULL, },
> +       { .compatible =3D "fsl,imx6ull-rngb", .data =3D NULL, },

It seems that these new entries are not needed, since they fallback to
"fsl,imx25-rngb".
