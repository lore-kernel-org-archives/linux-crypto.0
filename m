Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0E3CC61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Feb 2023 07:33:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbjBWHdr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Feb 2023 02:33:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbjBWHdq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2023 02:33:46 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4367E28865
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 23:33:43 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id y2so7564469pjg.3
        for <linux-crypto@vger.kernel.org>; Wed, 22 Feb 2023 23:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X1EkZ9fcLGT2rHRy1aoUbWnVVwOkheHTfFY3poRtBPI=;
        b=QOzxSHuS6Dhz66oe1al5nhrBaEuowKDdCLD2Lsfr5OLk/KltW0uB1XzkUmHTpX9nYy
         JOfH/cT8uWe6n9pUunbuTZHY8mrmQ7jgOB3hPePkpDmpbXNWFyng9/XGueZTt9QAxX40
         azpjLygqYdsyP03oyyfuux30lD0awnk/wGLkp8PwYQmTsOqHTs6eeGvco5Onwmlkucnj
         BpFEAXJH5w/eq3mj6do7xeeeq9hUjOacEcETH7pDWfsyyKDtXUc3gnZn6yq5c2/sN07Z
         uSVntz2c64cJVxkuDLutwEuabdRidnOYDaRzLEDgCNZrN/Ti0Q3lUEhRyeqR/uh0NwAZ
         Sw5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X1EkZ9fcLGT2rHRy1aoUbWnVVwOkheHTfFY3poRtBPI=;
        b=mNNbIMug7RaLnoXZ1fYUAoL7OIGz8UqnkJr/lHOePFxT17y39DOFGqJf0bUSgHnySz
         fka3zEoOOqVdWLVvnJ60+k8RxY0aCfXQ41h/SdwqvmC3pb+NNPW0FOQICQ/kktj2sRjE
         EjtigrcxIGCfrn/ILlvaktFMOLVNLQq9Gh3Hq7myXLbI9DPPHr7bap8Ug7cd/arMWI4W
         p6NkYAUYxI/DpVS63et+l03F/ipJxGnCgaINPRRjJoA3T+RXxuh5+LovQUYCfxyI+dEQ
         Cfx8/ipCJPp6E0mn8P3VaZJT4bRLFNjeLcJjT0WY6pVb8oKjTiE7BdJU75Zdpg1cEi59
         sUjA==
X-Gm-Message-State: AO0yUKUztVhLCpShylQrmA3XSbFhA7fu128DH072msHF6M6YuKsKU8Z4
        l4vTxP8JU821zGbygNrTbmftQVxINDyt3gSu5dpJ1Q==
X-Google-Smtp-Source: AK7set/0dy0HVB73IUe4iHT+X+8L44GFKcU+6PdtRi7u+rF2IiOZ0lyMsR8BzW1j445/5vILPyiVZThT62yN7BPqNyk=
X-Received: by 2002:a17:903:3281:b0:199:db3:9bcc with SMTP id
 jh1-20020a170903328100b001990db39bccmr1532223plb.11.1677137622522; Wed, 22
 Feb 2023 23:33:42 -0800 (PST)
MIME-Version: 1.0
References: <20230221013414.86856-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20230221013414.86856-1-yang.lee@linux.alibaba.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 23 Feb 2023 09:33:31 +0200
Message-ID: <CAOtvUMeMe=vwhC39FpGQJ2g=FKT5wKnT1pnT2XCS+c=4cBzyQg@mail.gmail.com>
Subject: Re: [PATCH -next] crypto: Use devm_platform_get_and_ioremap_resource()
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Yang,

Thank you for the patch.

On Tue, Feb 21, 2023 at 3:34 AM Yang Li <yang.lee@linux.alibaba.com> wrote:
>
> Convert platform_get_resource(), devm_ioremap_resource() to a single
> call to devm_platform_get_and_ioremap_resource(), as this is exactly
> what this function does.
>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  drivers/crypto/ccree/cc_driver.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/ccree/cc_driver.c b/drivers/crypto/ccree/cc_d=
river.c
> index d489c6f80892..c57f929805d5 100644
> --- a/drivers/crypto/ccree/cc_driver.c
> +++ b/drivers/crypto/ccree/cc_driver.c
> @@ -350,9 +350,9 @@ static int init_cc_resources(struct platform_device *=
plat_dev)
>
>         /* Get device resources */
>         /* First CC registers space */
> -       req_mem_cc_regs =3D platform_get_resource(plat_dev, IORESOURCE_ME=
M, 0);
>         /* Map registers space */
> -       new_drvdata->cc_base =3D devm_ioremap_resource(dev, req_mem_cc_re=
gs);
> +       new_drvdata->cc_base =3D devm_platform_get_and_ioremap_resource(p=
lat_dev,
> +                                                                     0, =
&req_mem_cc_regs);
>         if (IS_ERR(new_drvdata->cc_base))
>                 return PTR_ERR(new_drvdata->cc_base);
>
>

The patch itself is good but can you please avoid the line break after
plat_dev, it adds nothing to readability.

With this minor nitpick for the next revision -

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Gilad




--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
