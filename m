Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AA8399340;
	Thu, 16 Apr 2026 09:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776331240; cv=none; b=rmIIPX6BidAS+NW4zkMN686GN5pfNFKUmIffC4CDTi24RZvEpuxTeyoaQmpwPP9TzPYzOB1re3d0TkZ9J3hPhfcCgOnloqpxAeFal80FPiIkCiFg1tiZZVd53RzvYKife4oDw+fmVxY9d5NDHzmOppoRrgmHV7JOgl/dHTI/AJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776331240; c=relaxed/simple;
	bh=dD3UUD0Kr7I0glB/GGKzh7RGXYNoZdsYahQ8K3B82bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbgQ7XMoXOnBiOE6mTqh1dO/hjptmzhNTAO/T7VV2g/TR+8Oh/tg9QtTjWHXDIZrOtq84dsfnQUk2RYVQ8v/zE40574Cy+39yZ+wIZumwHxC+YMspKXqjTKBIhPOqIV13pbFlllAyCqObORR0NUl5bjJ/DRxD0t6i0YErFgF7kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=g0bA2uG9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="g0bA2uG9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=LeD79Ghy94CfpUoAQenbsLexQn/Pp4AFdktVeRQ/V6Y=; 
	b=g0bA2uG9/AKjawQd7lLtACyn8Prgwof0ZFaLd47prRkh0pa2EX8+Kpdhxb6ABzAw6j1+S8GiTTv
	n7l/ChOrBGgHHbswIhrz8viP953E1DpoK/pMGGoGCdpExpKedlr3ffbC4SE+2Z95JKl0p0gFeXP+i
	ILEaYsXV+QnD/jnI1auohxAXm9rEpCNVZD979/rjhybP8/+vh/a6tbiyijI0k4UtRILZ5z+bLEmuk
	eTnzzqRQ4PmOrNo8tC90FTgnukiod0veYJJEGhjG37qrf4WStGVO/wrszWxYAUH98wMf/mbBJ2Llr
	mZrfuTkwCp5C3Qizia2lD+Ow01IcnGkbCT9g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDItV-006VMc-1h;
	Thu, 16 Apr 2026 17:20:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Apr 2026 17:20:17 +0800
Date: Thu, 16 Apr 2026 17:20:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Lukasz Bartosik <lbartosik@marvell.com>,
	Suheil Chandran <schandran@marvell.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: octeontx2: fix IRQ vector leak in
 otx2_cptpf_probe()
Message-ID: <aeCp0Xe5G531vHBj@gondor.apana.org.au>
References: <20260414123857.3162673-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260414123857.3162673-1-lgs201920130244@gmail.com>

On Tue, Apr 14, 2026 at 08:38:57PM +0800, Guangshuo Li wrote:
>
> diff --git a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
> index 346d1345f11c..059f702dbf5c 100644
> --- a/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
> +++ b/drivers/crypto/marvell/octeontx2/otx2_cptpf_main.c
> @@ -783,7 +783,7 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
>  	/* Initialize AF-PF mailbox */
>  	err = cptpf_afpf_mbox_init(cptpf);
>  	if (err)
> -		goto clear_drvdata;
> +		goto free_irq_vectors;
>  	/* Register mailbox interrupt */
>  	err = cptpf_register_afpf_mbox_intr(cptpf);
>  	if (err)
> @@ -826,6 +826,8 @@ static int otx2_cptpf_probe(struct pci_dev *pdev,
>  	cptpf_disable_afpf_mbox_intr(cptpf);
>  destroy_afpf_mbox:
>  	cptpf_afpf_mbox_destroy(cptpf);
> +free_irq_vectors:
> +	pci_free_irq_vectors(pdev);

Good catch.  But what about the remove path, shouldn't the vectors
be freed there as well?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
