Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42F52ECAAD5
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Sep 2022 15:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbiIFPCY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Sep 2022 11:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbiIFPCD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2022 11:02:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23C1F1111
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 07:16:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFBB9B81636
        for <linux-crypto@vger.kernel.org>; Tue,  6 Sep 2022 14:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39336C433D6;
        Tue,  6 Sep 2022 14:00:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662472856;
        bh=0n+iESD+GUNwlyuJIvTXBTASXtzx6TPBXDs0PV/nRls=;
        h=In-Reply-To:References:Cc:From:Subject:To:Date:From;
        b=iz9BYOJTujOFROlVYJNzkJ4OSxmkSOH7VfWYsX0KoK2M34U2xdgzznmvQtWYNlBGf
         MYEvg4N7mBDBBw1sn5WF+lWgYIqtQGJh+QVrChINMiZXrs2AcIi88rruYB0e1zDB/G
         WUTnxEAoUzVQJxwkcWCCWg5HM8vHdeyp3WI3Em+LYYCLQGc8JzyycBlMRUMB36t+t6
         9N4X9IqqbMvEycJnfKQNFvKR9SXyeFqucaK0hqOc+JMhzlBIN+l7iqFT1D/IE9BibV
         EI6nLzaqEtydep704ldVoJaQyeDXlwUHE5adhDYv+jDidxo9k4kwgZAshgdwqzDGSe
         adLfPa1tQCU9w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
References: <de6de430fd9bbc2d38ff2d5a1ce89983421b9dda.1662432407.git.pliem@maxlinear.com>
Cc:     linux-crypto@vger.kernel.org, linux-lgm-soc@maxlinear.com,
        Peter Harliman Liem <pliem@maxlinear.com>
From:   Antoine Tenart <atenart@kernel.org>
Subject: Re: [PATCH v2 1/2] crypto: inside_secure - Avoid dma map if size is zero
To:     Peter Harliman Liem <pliem@maxlinear.com>,
        herbert@gondor.apana.org.au
Message-ID: <166247285388.3585.6290053542530090542@kwain>
Date:   Tue, 06 Sep 2022 16:00:53 +0200
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting Peter Harliman Liem (2022-09-06 04:51:49)
> From commit d03c54419274 ("dma-mapping: disallow .map_sg
> operations from returning zero on error"), dma_map_sg()
> produces warning if size is 0. This results in visible
> warnings if crypto length is zero.
> To avoid that, we avoid calling dma_map_sg if size is zero.
>=20
> Fixes: d03c54419274 ("dma-mapping: disallow .map_sg operations from retur=
ning zero on error")

You can't reference the commit above, it's not introducing the issue but
the warning itself. The actual commit introducing the below logic should
be referenced.

Alternatively since the warning was introduced latter than the logic and
this is not a huge issue, you might resend it w/o the Fixes tag as well.

> Signed-off-by: Peter Harliman Liem <pliem@maxlinear.com>

With the Fixes: tag fixed,

Acked-by: Antoine Tenart <atenart@kernel.org>

Thanks!

> ---
> v2:
>  Add fixes tag
>=20
>  drivers/crypto/inside-secure/safexcel_cipher.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/cry=
pto/inside-secure/safexcel_cipher.c
> index d68ef16650d4..3775497775e0 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -737,14 +737,17 @@ static int safexcel_send_req(struct crypto_async_re=
quest *base, int ring,
>                                 max(totlen_src, totlen_dst));
>                         return -EINVAL;
>                 }
> -               dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRECTIONA=
L);
> +               if (sreq->nr_src > 0)
> +                       dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDI=
RECTIONAL);
>         } else {
>                 if (unlikely(totlen_src && (sreq->nr_src <=3D 0))) {
>                         dev_err(priv->dev, "Source buffer not large enoug=
h (need %d bytes)!",
>                                 totlen_src);
>                         return -EINVAL;
>                 }
> -               dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVICE);
> +
> +               if (sreq->nr_src > 0)
> +                       dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_D=
EVICE);
> =20
>                 if (unlikely(totlen_dst && (sreq->nr_dst <=3D 0))) {
>                         dev_err(priv->dev, "Dest buffer not large enough =
(need %d bytes)!",
> @@ -753,7 +756,9 @@ static int safexcel_send_req(struct crypto_async_requ=
est *base, int ring,
>                                      DMA_TO_DEVICE);
>                         return -EINVAL;
>                 }
> -               dma_map_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DEVICE);
> +
> +               if (sreq->nr_dst > 0)
> +                       dma_map_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM=
_DEVICE);
>         }
> =20
>         memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);
> --=20
> 2.17.1
>=20
