Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43343152500;
	Fri, 31 May 2024 10:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717151094; cv=none; b=fqRhpEKbmf1rB/AW921SAXtOPms84/S8hpgbOMoCTVdZ52tiuPXeA3WMGvP2H5d5xlTxNmRpK1XGxDCmH94x8TC/yMBd6PEveqeYBN8cNkmBqnmiY99ClVyVfyLPABqmklssFEt0dUTASZskJgaI4YNwKOAOVTu7VpWCZMrWu+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717151094; c=relaxed/simple;
	bh=qCATkT+PfyI8DjDa0DWATvfqlsDVKQpPW2KRIZX2umA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CIhzOw9NNM1Zvn+fy14zpMFL2VfiYnRhaUqvYn60MJANmEQRjTbUO2lc6koWFlhb/gvNc1v0qRu1lnamHGaxrq+NrHWRZjePtAjmgSdNdBh4Ms+FyBfNB54bXkGrMyBwk7YoS5xBHZKYcZ4pAAPX1mX+Sxc4ZeCbVXXG8d1qFLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sCzRB-004ApR-1i;
	Fri, 31 May 2024 18:24:42 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 31 May 2024 18:24:43 +0800
Date: Fri, 31 May 2024 18:24:43 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Akhil R <akhilrajeev@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH] crypto: tegra - Remove an incorrect iommu_fwspec_free()
 call in tegra_se_remove()
Message-ID: <ZlmlawnvOIYHoI68@gondor.apana.org.au>
References: <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea775b351a3dbe4cef4056ea89da25084f73df22.1716650050.git.christophe.jaillet@wanadoo.fr>

On Sat, May 25, 2024 at 05:14:35PM +0200, Christophe JAILLET wrote:
> The only iommu function call in this driver is a
> tegra_dev_iommu_get_stream_id() which does not allocate anything and does
> not take any reference.
> 
> More-over, what is freed is "se->dev" which has been devm_kzalloc()'ed in
> the probe.
> 
> So there is no point in calling iommu_fwspec_free() in the remove function.
> 
> Remove this incorrect function call.
> 
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only
> 
> This patch is completely speculative. *Review with care*.
> ---
>  drivers/crypto/tegra/tegra-se-main.c | 1 -
>  1 file changed, 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
