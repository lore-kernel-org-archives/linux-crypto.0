Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19610175567;
	Fri, 21 Jun 2024 11:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718970003; cv=none; b=ZU5NYY1fzqDiODMfBGTAKqd6lOPE6kqQdbPMy028Jj0oCpIsW+91cDenGANT0r9reGCGcSA8jnnBPsz2BUD0Bbo8hw3TA02HdWMOpZJrN9g+23bsQQYTVXicjR/n2SkwN0YFIV9/7S/3YmUi4cW/yjKUKr+6WTvmjH3OVJPPrmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718970003; c=relaxed/simple;
	bh=Zaw4peHq2eFFsp6xCvJUkP6dJUChxox1sr8/V09PfEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i9HHaslHVtZ1lqkxvY52W9zN+a8UqYsagw4Bg9m8/F4cJbA5gNRjL6rhErnV+35zpjgyrdP7Oj4rL36YREHOB8YTbaHIHq8nnBHUOpUXvm1MSOx0D0Tp62RaT0rwakIj2X2IGl4t4RhGy86JE48y5G1XZm50Al/4djMipODdRZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKccD-002dw2-0o;
	Fri, 21 Jun 2024 21:39:38 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 21:39:37 +1000
Date: Fri, 21 Jun 2024 21:39:37 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jia Jie Ho <jiajie.ho@starfivetech.com>
Cc: "David S . Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: starfive - Align rsa input data to 32-bit
Message-ID: <ZnVmechLrqIKKFc0@gondor.apana.org.au>
References: <20240613083942.760182-1-jiajie.ho@starfivetech.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240613083942.760182-1-jiajie.ho@starfivetech.com>

On Thu, Jun 13, 2024 at 04:39:42PM +0800, Jia Jie Ho wrote:
>
> @@ -217,12 +218,11 @@ struct starfive_cryp_request_ctx {
>  	struct scatterlist			*out_sg;
>  	struct ahash_request			ahash_fbk_req;
>  	size_t					total;
> -	size_t					nents;
>  	unsigned int				blksize;
>  	unsigned int				digsize;
>  	unsigned long				in_sg_len;
>  	unsigned char				*adata;
> -	u8 rsa_data[] __aligned(sizeof(u32));
> +	u8 rsa_data[STARFIVE_RSA_MAX_KEYSZ];

I think you should retain the aligned attribute.

> @@ -74,14 +73,13 @@ static int starfive_rsa_montgomery_form(struct starfive_cryp_ctx *ctx,
>  {
>  	struct starfive_cryp_dev *cryp = ctx->cryp;
>  	struct starfive_cryp_request_ctx *rctx = ctx->rctx;
> -	int count = rctx->total / sizeof(u32) - 1;
> +	int count = (ALIGN(rctx->total, sizeof(u32)) >> 2) - 1;

This is a bit confusing.  Perhaps use 4 instead of sizeof(u32), i.e.

	int count = (ALIGN(rctx->total, 4) / 4) - 1;

>  	int loop;
>  	u32 temp;
>  	u8 opsize;
>  
>  	opsize = (bit_len - 1) >> 5;
>  	rctx->csr.pka.v = 0;
> -

Please do not make unrelated changes like this.

> -	rctx->total = sg_copy_to_buffer(rctx->in_sg, rctx->nents,
> -					rctx->rsa_data, rctx->total);
> +	if (!IS_ALIGNED(rctx->total, sizeof(u32))) {
> +		shift = sizeof(u32) - (rctx->total & 0x3);
> +		memset(rctx->rsa_data, 0, shift);
> +	}
> +
> +	rctx->total = sg_copy_to_buffer(rctx->in_sg, sg_nents(rctx->in_sg),
> +					rctx->rsa_data + shift, rctx->total);

The rctx->nents change appears to be unrelated to this patch so
if you want to do it please move it to another patch.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
