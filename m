Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B321F25551
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 13:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D2tvSGjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBACC433C7;
	Fri,  1 Dec 2023 13:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701437991;
	bh=YkfWSmsAy25wgJ78nihdMN18So6x4EQUS07prH0NBmo=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=D2tvSGjvvHiWzBwIVjNd2X6msgGnq0ut9JPk45HvVYurOI41AtrWarv5+50AP7Xbz
	 nDTX5q7PT9buFzxYdXxba1MwMjMEJjP9ACafbhaUpOBFS+lA06qj2UcMeAt+ztSy8a
	 JPg2i6p9MxJeddTanJ5cwxD/HqVSaCDKghdXDgKgPQcBZ2NH+Xx3BEUWwp+iRI9z6M
	 EG41RmQgtWN/GtEGBAhvZP8NhLH0SccEU3+SQbQi+i3PPn2Zic//a8FIMkZqnT2ivJ
	 IobCIVPy5K59K2SZbyQEe2ZKpxp87jRxyvLrWq2peIEljZ4chLmnBsH2J18nRna5HK
	 Xuv0ygMSp1lnw==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231201124929.12448-1-n.zhandarovich@fintech.ru>
References: <20231201124929.12448-1-n.zhandarovich@fintech.ru>
Subject: Re: [PATCH v2] crypto: safexcel - Add error handling for dma_map_sg() calls
From: Antoine Tenart <atenart@kernel.org>
Cc: Nikita Zhandarovich <n.zhandarovich@fintech.ru>, David S. Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Date: Fri, 01 Dec 2023 14:39:47 +0100
Message-ID: <170143798791.35162.11594364771392098948@kwain>

Quoting Nikita Zhandarovich (2023-12-01 13:49:29)
> Macro dma_map_sg() may return 0 on error. This patch enables
> checks in case of the macro failure and ensures unmapping of
> previously mapped buffers with dma_unmap_sg().
>=20
> Found by Linux Verification Center (linuxtesting.org) with static
> analysis tool SVACE.
>=20
> Fixes: 49186a7d9e46 ("crypto: inside_secure - Avoid dma map if size is ze=
ro")
> Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

Reviewed-by: Antoine Tenart <atenart@kernel.org>

Thanks!
Antoine

> ---
> v2: remove extra level of parentheses and
> change return error code from -ENOMEM to EIO
> per Antoine Tenart's <atenart@kernel.org> suggestion
>=20
>  drivers/crypto/inside-secure/safexcel_cipher.c | 19 +++++++++++--------
>  1 file changed, 11 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/cry=
pto/inside-secure/safexcel_cipher.c
> index 272c28b5a088..b83818634ae4 100644
> --- a/drivers/crypto/inside-secure/safexcel_cipher.c
> +++ b/drivers/crypto/inside-secure/safexcel_cipher.c
> @@ -742,9 +742,9 @@ static int safexcel_send_req(struct crypto_async_requ=
est *base, int ring,
>                                 max(totlen_src, totlen_dst));
>                         return -EINVAL;
>                 }
> -               if (sreq->nr_src > 0)
> -                       dma_map_sg(priv->dev, src, sreq->nr_src,
> -                                  DMA_BIDIRECTIONAL);
> +               if (sreq->nr_src > 0 &&
> +                   !dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIREC=
TIONAL))
> +                       return -EIO;
>         } else {
>                 if (unlikely(totlen_src && (sreq->nr_src <=3D 0))) {
>                         dev_err(priv->dev, "Source buffer not large enoug=
h (need %d bytes)!",
> @@ -752,8 +752,9 @@ static int safexcel_send_req(struct crypto_async_requ=
est *base, int ring,
>                         return -EINVAL;
>                 }
> =20
> -               if (sreq->nr_src > 0)
> -                       dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_D=
EVICE);
> +               if (sreq->nr_src > 0 &&
> +                   !dma_map_sg(priv->dev, src, sreq->nr_src, DMA_TO_DEVI=
CE))
> +                       return -EIO;
> =20
>                 if (unlikely(totlen_dst && (sreq->nr_dst <=3D 0))) {
>                         dev_err(priv->dev, "Dest buffer not large enough =
(need %d bytes)!",
> @@ -762,9 +763,11 @@ static int safexcel_send_req(struct crypto_async_req=
uest *base, int ring,
>                         goto unmap;
>                 }
> =20
> -               if (sreq->nr_dst > 0)
> -                       dma_map_sg(priv->dev, dst, sreq->nr_dst,
> -                                  DMA_FROM_DEVICE);
> +               if (sreq->nr_dst > 0 &&
> +                   !dma_map_sg(priv->dev, dst, sreq->nr_dst, DMA_FROM_DE=
VICE)) {
> +                       ret =3D -EIO;
> +                       goto unmap;
> +               }
>         }
> =20
>         memcpy(ctx->base.ctxr->data, ctx->key, ctx->key_len);
>
