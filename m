Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D5AECAAD8
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Sep 2022 09:09:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiIWJJK (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Sep 2022 05:09:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiIWJJG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Sep 2022 05:09:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF0212DEA6
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 02:09:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4EC1861E00
        for <linux-crypto@vger.kernel.org>; Fri, 23 Sep 2022 09:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6477FC433D6;
        Fri, 23 Sep 2022 09:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663924144;
        bh=5t7i2UtqHk/DuyQu0Msr77BoDZnE+bGRPNlsDkeFoyo=;
        h=In-Reply-To:References:Cc:From:To:Subject:Date:From;
        b=mrE38i+kGZsOIm08KEgSL/lwG4poA1Sh3OMRL6o9Ug9y2u2UfIT72BBL5qh/5bEGo
         a2G9VA8FxitoEdSoIX2WHtOgfaV8LzfV9Y+swFdnE0sqANCNy3lNM97ET8evmtH/zX
         +KkeqPKRndaRP8d+HrnXcbLLQrZSNBZ4kuAHUqx8PQODFYdrsx52fdmXzJ2w0VVoJH
         ociMDVbjMfc1B6th6wtssZovZjia2sp9gCEIV4mrdWBay9PVJW4pcj7jv1W61nxD9J
         krO8ZDTMHWTdfIgmuEAz3Kq0asiBrvgWk03Dkhf6Hb1LMxmP93SpskwLt4hr8r2yLZ
         ZZFeVKQjSYWkQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <131f0d802d4e251dd8f98672260a04c2f649440c.1663660578.git.pliem@maxlinear.com>
References: <cover.1663660578.git.pliem@maxlinear.com> <131f0d802d4e251dd8f98672260a04c2f649440c.1663660578.git.pliem@maxlinear.com>
Cc:     linux-crypto@vger.kernel.org, linux-lgm-soc@maxlinear.com,
        Peter Harliman Liem <pliem@maxlinear.com>
From:   Antoine Tenart <atenart@kernel.org>
To:     Peter Harliman Liem <pliem@maxlinear.com>,
        herbert@gondor.apana.org.au
Subject: Re: [PATCH 1/3] crypto: inside-secure - Expand soc data structure
Message-ID: <166392414185.3511.12102278740497366855@kwain>
Date:   Fri, 23 Sep 2022 11:09:01 +0200
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Peter Harliman Liem (2022-09-20 10:01:37)
> @@ -410,20 +410,25 @@ static int eip197_load_firmwares(struct safexcel_cr=
ypto_priv *priv)
>         int i, j, ret =3D 0, pe;
>         int ipuesz, ifppsz, minifw =3D 0;
> =20
> -       if (priv->version =3D=3D EIP197D_MRVL)
> -               dir =3D "eip197d";
> -       else if (priv->version =3D=3D EIP197B_MRVL ||
> -                priv->version =3D=3D EIP197_DEVBRD)
> +       switch (priv->data->version) {
> +       case EIP197_DEVBRD:
> +       case EIP197B_MRVL:
>                 dir =3D "eip197b";
> -       else
> -               return -ENODEV;
> +               break;
> +       case EIP197D_MRVL:
> +               dir =3D "eip197d";
> +               break;
> +       default:
> +               /* generic case */
> +               dir =3D "";
> +       }

Why "generic case"? We shouldn't end up in this case and the logic
changed after this patch: an error was returned before.

The if vs switch is mostly a question of taste here, I don't have
anything against it but it's also not necessary as we're not supporting
lots of versions. So you could keep it as-is and keep the patch
restricted to its topic.

> +static const struct safexcel_of_data eip97ies_mrvl_data =3D {
> +       .version =3D EIP97IES_MRVL,
> +};
> +
> +static const struct safexcel_of_data eip197b_mrvl_data =3D {
> +       .version =3D EIP197B_MRVL,
> +};
> +
> +static const struct safexcel_of_data eip197d_mrvl_data =3D {
> +       .version =3D EIP197D_MRVL,
> +};
> +
>  static const struct of_device_id safexcel_of_match_table[] =3D {
>         {
>                 .compatible =3D "inside-secure,safexcel-eip97ies",
> -               .data =3D (void *)EIP97IES_MRVL,
> +               .data =3D &eip97ies_mrvl_data,
>         },
>         {
>                 .compatible =3D "inside-secure,safexcel-eip197b",
> -               .data =3D (void *)EIP197B_MRVL,
> +               .data =3D &eip197b_mrvl_data,
>         },
>         {
>                 .compatible =3D "inside-secure,safexcel-eip197d",
> -               .data =3D (void *)EIP197D_MRVL,
> +               .data =3D &eip197d_mrvl_data,
>         },
>         /* For backward compatibility and intended for generic use */
>         {
>                 .compatible =3D "inside-secure,safexcel-eip97",
> -               .data =3D (void *)EIP97IES_MRVL,
> +               .data =3D &eip97ies_mrvl_data,
>         },
>         {
>                 .compatible =3D "inside-secure,safexcel-eip197",
> -               .data =3D (void *)EIP197B_MRVL,
> +               .data =3D &eip197b_mrvl_data,
>         },
>         {},
>  };

The pci_device_id counterpart update is missing.

> +++ b/drivers/crypto/inside-secure/safexcel.h
> @@ -733,6 +733,10 @@ enum safexcel_eip_version {
>         EIP197_DEVBRD
>  };
> =20
> +struct safexcel_of_data {
> +       enum safexcel_eip_version version;
> +};

The driver supports both of and PCI ids, you can rename this to
safexcel_priv_data.

Thanks!
Antoine
