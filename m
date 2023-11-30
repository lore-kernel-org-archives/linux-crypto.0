Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC42E3C071
	for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 10:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FGZCAyHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17286C4339A;
	Thu, 30 Nov 2023 10:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701340606;
	bh=RjaFcjIuRnKdKLcTUCaGL4xoFcvpDOQ03stuLQOnP14=;
	h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
	b=FGZCAyHDyUdYCijgPEpxSVnYG+480sL/RcWgg6kgXt/Tyy6oVPC8IpjrL3T4w9Rzv
	 Fc6UcvwVFWcLKDpY8I7CihM+7/XKwbMDD+cYA3/Mt66F3Ke/QSbuFVHqHDtmLH465f
	 PvnMHs2Q/VUiHc8ld5EXPEbProdwAiIm3yFayoFkyNX0mw8QX6SUCZNc3m38Fp9jz8
	 YNjbsZWGbtPgiE1mVaTUNDG8AdvsSVSC09a0nNipqmRMLW1vO3NiPZtL1x9i0m4QWs
	 ZR+kgfNyfzPTaLaogVQ/yCTLncTgyFbnHFuzaxXwwv8CVeg869xIY//0hx8/VrHzou
	 N8F4BWPTKOZXA==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20231129152145.7767-1-n.zhandarovich@fintech.ru>
References: <20231129152145.7767-1-n.zhandarovich@fintech.ru>
Subject: Re: [PATCH] crypto: safexcel - Add error handling for dma_map_sg() calls
From: Antoine Tenart <atenart@kernel.org>
Cc: Nikita Zhandarovich <n.zhandarovich@fintech.ru>, Herbert Xu <herbert@gondor.apana.org.au>, David S. Miller <davem@davemloft.net>, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Date: Thu, 30 Nov 2023 11:36:43 +0100
Message-ID: <170134060353.9758.8481937396435146454@kwain>

Hello Nikita,

Quoting Nikita Zhandarovich (2023-11-29 16:21:45)
>=20
> diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/cry=
pto/inside-secure/safexcel_cipher.c
> index 272c28b5a088..ca660f31c15f 100644
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
> +               if ((sreq->nr_src > 0) &&
> +                   (!dma_map_sg(priv->dev, src, sreq->nr_src, DMA_BIDIRE=
CTIONAL)))
> +                       return -ENOMEM;

You can remove one level of parenthesis. Also I'm not sure -ENOMEM is
the right error to return. Looking around it seems people got creative
about that, IMHO -EIO would be best, but not 100% sure.

Same comments for the other chunks.

Thanks,
Antoine
