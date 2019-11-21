Return-Path: <SRS0=AlHk=ZN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47DA5C432C3
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 05:12:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 140CD2089D
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Nov 2019 05:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574313170;
	bh=yy8eEgfEToYok9X919w45b2ihXhTxEEJn5CiGGVDfoM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=zJzy4AkWqoVjhXpNJWIw9zRwpWyvI6FU7rW4y5AyAksuIKgfoepTDjochwJ+2QHuG
	 BPQK7wU8RuOOLFTE02GX+E68yXLv/8l1+idbOR0NXUStobcckX32nQAhpvycVy5EZz
	 pcyg0vMgwZtXji82ZT9fSZFqitNoiGtlpiz+4cFY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725904AbfKUFMs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Nov 2019 00:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:34612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfKUFMr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Nov 2019 00:12:47 -0500
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0E462089F;
        Thu, 21 Nov 2019 05:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574313167;
        bh=yy8eEgfEToYok9X919w45b2ihXhTxEEJn5CiGGVDfoM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mKuypisHYvT7ozeokzlA/k7waKynSB7RrigmxtE8TVtEQNZTNSz9J9sVneUFJshXd
         r4dfMa+EsEIKRoqDsamTur0C32gB9oY15SIeKFk93MMW0VKR5IGCde/MMZg+gsE5xA
         XjtoXHIiyEOZWP0oc/oxuXpmpoIwq0oOu0Nq3lx0=
Received: by mail-lf1-f48.google.com with SMTP id v24so1475014lfi.7;
        Wed, 20 Nov 2019 21:12:46 -0800 (PST)
X-Gm-Message-State: APjAAAWiK506L6FrvZZOWY/Fl7/7JivKwOe8gm6+pPl0BwP661Tx9/vD
        mw5hzpRURxCWw8r5/0OZrPK68vvCq/dMeUegeHA=
X-Google-Smtp-Source: APXvYqwe+YxRVk4uB/CYpPNi/J/RM2esWAW289Akjpc5j6wiUwS4+H5KYBHSq/z0sWZPIW3rPbPxnMrC5oOFL0kd1/s=
X-Received: by 2002:a19:7510:: with SMTP id y16mr5757908lfe.24.1574313164896;
 Wed, 20 Nov 2019 21:12:44 -0800 (PST)
MIME-Version: 1.0
References: <CGME20191120135541eucas1p14033edaac4d015cf1d2110d9d08f2f05@eucas1p1.samsung.com>
 <20191120135527.7636-1-k.konieczny@samsung.com>
In-Reply-To: <20191120135527.7636-1-k.konieczny@samsung.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Thu, 21 Nov 2019 13:12:33 +0800
X-Gmail-Original-Message-ID: <CAJKOXPefL_nyNaUExCJv6zKmhPTvgiPaaPT-sRoyyOw59aTZiQ@mail.gmail.com>
Message-ID: <CAJKOXPefL_nyNaUExCJv6zKmhPTvgiPaaPT-sRoyyOw59aTZiQ@mail.gmail.com>
Subject: Re: [RESEND PATCH] MAINTAINERS: update my e-mail address
To:     Kamil Konieczny <k.konieczny@samsung.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org,
        "linux-samsung-soc@vger.kernel.org" 
        <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 20 Nov 2019 at 21:55, Kamil Konieczny <k.konieczny@samsung.com> wrote:
>
> Update my e-mail address to @samsung.com in maintainers.
> Add also map in .mailmap to new e-mail.
>
> Signed-off-by: Kamil Konieczny <k.konieczny@samsung.com>

Hi Kamil,

To whom are you addressing it? All people are on CC so I am not sure
if I am the one to pick it up.

Best regards,
Krzysztof

> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/.mailmap b/.mailmap
> index fd6219293057..3727a0066bb1 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -133,6 +133,7 @@ Juha Yrjola <at solidboot.com>
>  Juha Yrjola <juha.yrjola@nokia.com>
>  Juha Yrjola <juha.yrjola@solidboot.com>
>  Julien Thierry <julien.thierry.kdev@gmail.com> <julien.thierry@arm.com>
> +Kamil Konieczny <k.konieczny@samsung.com> <k.konieczny@partner.samsung.com>
>  Kay Sievers <kay.sievers@vrfy.org>
>  Kenneth W Chen <kenneth.w.chen@intel.com>
>  Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e4f170d8bc29..0caf7560c782 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14294,7 +14294,7 @@ F:      drivers/media/i2c/s5k5baf.c
>  SAMSUNG S5P Security SubSystem (SSS) DRIVER
>  M:     Krzysztof Kozlowski <krzk@kernel.org>
>  M:     Vladimir Zapolskiy <vz@mleia.com>
> -M:     Kamil Konieczny <k.konieczny@partner.samsung.com>
> +M:     Kamil Konieczny <k.konieczny@samsung.com>
>  L:     linux-crypto@vger.kernel.org
>  L:     linux-samsung-soc@vger.kernel.org
>  S:     Maintained
> --
> 2.24.0
>
