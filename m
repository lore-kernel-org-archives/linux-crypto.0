Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3C51849EC;
	Wed,  3 Jul 2024 17:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720027288; cv=none; b=G2nrmjNmS/WCGwqNQBejPW2l3QsXLukouKnDROW+LeZ6+jCFMZOmA+iZkYkvDPJU9ag9bUOZWT7uiI1x6QNCrtbP+Omlc+eRSEbW5bwr4fMeNaJTpnrTVpJCzxXlmpu2VtuCiNBOKJRGmpTyPuiHG9MgclL+zWcWZtx00/xcGcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720027288; c=relaxed/simple;
	bh=LJ0zHjH0kD+iXUzyFJ+qPcJA5pU14YxexeZSu9J9/mg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=PfWgMLPhZ7XKl+qiUlzQctyfLHPvSegQuWD4qs4OST9t3AZHAREwmsYENtQBmvGTYWrVUuqf97bGTA4+eoPTLs7f6BkEfQbRLDa+VHgxhI2FRRdrDR29hY8WZ2pM+5qADlqZ6DGc/FV3Ge4LfSbe/QAyB+sG200heFMwTfkoMUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X4rZKLqm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X4rZKLqm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFDEC4AF07;
	Wed,  3 Jul 2024 17:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720027287;
	bh=LJ0zHjH0kD+iXUzyFJ+qPcJA5pU14YxexeZSu9J9/mg=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=X4rZKLqmrjgMVhSI384HWJcceNk3RxtNuevHbl+QCXDvyMllp9WOjv84q2vpyRl6I
	 uVsPWw303oz95YvUjPhX9bUu6VBESRuEGrJhUJhIa4V4SNRjU/IWDYWslOTxNx0NQ2
	 ZD3FEUN/u/or+HpSF0trTgWYgzvd3R2dAhJCpuhoEVZLMpyvAVzRQvw80tEz76pnb1
	 /XT6IP8j9V+PEs9EZC9c0wBknWELB/tjXivuNdahI6qM7P5s2HBgpgmEAKCGnlxGk7
	 YeVQDodzsMQB+3Tcp3rt/oHYnQIiAFB66c/saQ2R20Duxf8i+CGLdts2QqIh4TGThk
	 Ptf/MXCG40GZA==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 03 Jul 2024 20:21:22 +0300
Message-Id: <D2G2S9CL9VNY.3VH73LVAT90SK@kernel.org>
Cc: "Pengutronix Kernel Team" <kernel@pengutronix.de>,
 <linux-crypto@vger.kernel.org>, <imx@lists.linux.dev>,
 <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
 "sigma star Kernel Team" <upstream+dcp@sigma-star.at>, "kernel test robot"
 <lkp@intel.com>, "Dan Carpenter" <dan.carpenter@linaro.org>
Subject: Re: [PATCH] crypto: mxs-dcp: Ensure payload is zero when using key
 slot
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "David Gstir" <david@sigma-star.at>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 "Shawn Guo" <shawnguo@kernel.org>, "Sascha Hauer" <s.hauer@pengutronix.de>,
 "Fabio Estevam" <festevam@gmail.com>, "David Oberhollenzer"
 <david.oberhollenzer@sigma-star.at>, "Richard Weinberger" <richard@nod.at>
X-Mailer: aerc 0.17.0
References: <20240703124958.45898-1-david@sigma-star.at>
In-Reply-To: <20240703124958.45898-1-david@sigma-star.at>

On Wed Jul 3, 2024 at 3:49 PM EEST, David Gstir wrote:
> We could leak stack memory through the payload field when running
> AES with a key from one of the hardware's key slots. Fix this by
> ensuring the payload field is set to 0 in such cases.
>
> This does not affect the common use case when the key is supplied
> from main memory via the descriptor payload.
>
> Signed-off-by: David Gstir <david@sigma-star.at>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Closes: https://lore.kernel.org/r/202405270146.Y9tPoil8-lkp@intel.com/
> Fixes: 3d16af0b4cfa ("crypto: mxs-dcp: Add support for hardware-bound key=
s")
> ---
>  drivers/crypto/mxs-dcp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/mxs-dcp.c b/drivers/crypto/mxs-dcp.c
> index 057d73c370b7..c82775dbb557 100644
> --- a/drivers/crypto/mxs-dcp.c
> +++ b/drivers/crypto/mxs-dcp.c
> @@ -225,7 +225,8 @@ static int mxs_dcp_start_dma(struct dcp_async_ctx *ac=
tx)
>  static int mxs_dcp_run_aes(struct dcp_async_ctx *actx,
>  			   struct skcipher_request *req, int init)
>  {
> -	dma_addr_t key_phys, src_phys, dst_phys;
> +	dma_addr_t key_phys =3D 0;
> +	dma_addr_t src_phys, dst_phys;
>  	struct dcp *sdcp =3D global_sdcp;
>  	struct dcp_dma_desc *desc =3D &sdcp->coh->desc[actx->chan];
>  	struct dcp_aes_req_ctx *rctx =3D skcipher_request_ctx(req);

I'm on holiday up until week 31 so might be that review will take
up to then.

BR, Jarkko
