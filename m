Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12C3715E97;
	Sat, 16 Aug 2025 09:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755336108; cv=none; b=jcXTRns/KdzNdAiXUkRxcREdL+qmYePhv3Him5rO9WiRKE36pCNiMsI/jD+V+g7peG75oVtwYg1DB8IUYYBs6ya9BbqemPW6Nw9+IMkNyAuSZ1E6khvp9s7VhBCkUNmeezVM+/RNaDFgNvSpGEvdJJ4dB3X66sCyL9rE+0fvNoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755336108; c=relaxed/simple;
	bh=Cv45GYznN8WuPG/wnUO/PpjVJwkJIOj1z/LzTaBY+RA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WPGJJE5VdPGDXX9z1pVaunw8qq6GPApERJHh2eLopxvUcnSK15YePAhmZoMUf92d+JLE8+z/zB5MNCVCmTU+6upT2HKYPy0Uuj+yHJXJP9AEnbBh7uMvwh1Ri49BkmKN7zUu9bRmaNuaxsh1zTPUL50+NOowYoN+73JDrtJGvtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=J5VBNrks; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="J5VBNrks"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y7UkP7MSXPtN++9D8o30qjFY1t8VTBeFKvP+UaQK2MA=; b=J5VBNrksWIHUK1ldKc7drhGcrx
	8a8MbWh8aKc+k/crujey2/jIj6TJ45u7ThTeWQjnnBiiYjiTmB/95F343GyGWizQJfFi+36i8A4X5
	oKw9kLSr2J8hzChwaf3g0F0xoL7ZGrc+C6RlRXAhZutlr2RGL29t0pdYv7XJS2cwkBscZhm4MCQ/m
	kh01a8gBFM0PkHsp59cy+EfcDisAue14e33ClY2D4YVzPP8o+5tJpZVHwQUqgmT6DZ/fQAWLo0U0h
	r0oi29WYN2GQuvy0bXWGGTzF9Kt7JBWlysQl7jla4feHhL7J1Z1KL03OTfwhQtZTFp8mt62E9+oeT
	4gZh2eoA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unCr4-00EmEZ-29;
	Sat, 16 Aug 2025 17:21:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:21:35 +0800
Date: Sat, 16 Aug 2025 17:21:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: zhang.enpei@zte.com.cn
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
	davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, christophe.jaillet@wanadoo.fr
Subject: Re: [PATCH v2] crypto: caam - switch to use devm_kmemdup_array()
Message-ID: <aKBNn7qgBVhJcLhq@gondor.apana.org.au>
References: <20250723105027140oF4Bwli1JuZcQ0V5-7pyK@zte.com.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250723105027140oF4Bwli1JuZcQ0V5-7pyK@zte.com.cn>

On Wed, Jul 23, 2025 at 10:50:27AM +0800, zhang.enpei@zte.com.cn wrote:
> From: Zhang Enpei <zhang.enpei@zte.com.cn>
> 
> Use devm_kmemdup_array() to avoid multiplication or possible overflows.
> 
> Signed-off-by: Zhang Enpei <zhang.enpei@zte.com.cn>
> ---
>  drivers/crypto/caam/ctrl.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
> index ce7b99019537..2250dce9c344 100644
> --- a/drivers/crypto/caam/ctrl.c
> +++ b/drivers/crypto/caam/ctrl.c
> @@ -592,9 +592,9 @@ static int init_clocks(struct device *dev, const struct caam_imx_data *data)
>         int ret;
> 
>         ctrlpriv->num_clks = data->num_clks;
> -       ctrlpriv->clks = devm_kmemdup(dev, data->clks,
> -                                     data->num_clks * sizeof(data->clks[0]),
> -                                     GFP_KERNEL);
> +       ctrlpriv->clks = devm_kmemdup_array(dev, data->clks,
> +                                           data->num_clks, sizeof(*data->clks),
> +                                           GFP_KERNEL);
>         if (!ctrlpriv->clks)
>                 return -ENOMEM;

This patch doesn't apply because it is space-damaged.  Please
resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
