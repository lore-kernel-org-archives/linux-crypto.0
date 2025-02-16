Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBFB179A3;
	Sun, 16 Feb 2025 05:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739683615; cv=none; b=Mu/52h/s9suT9q7m3JmBvKqvLo5Ogy9y5xUNJYJRImRFevf8l8vlA4d31Vw4UzEv+JX9KAqPvEZvQh8waadpm6eyjN8nFh4VslTp32Ax7n4Rj0/wLLkGLvktF5Fw8MWzf1OeihV98fEImoh+bdrDdbP5Px7XwAT2tJ4zAyEiH/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739683615; c=relaxed/simple;
	bh=E1QDwKstxOFNFyxRj9iTZE4ltiILRIqxwicLYaRDBf8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G0nvLiRR+8TDxhDac4IPtCef1L9TqXtRYjqYHuGLdqd52hnr/jh5u0mrfJCHCjH/HMUz+2YYL+Uiee8mkfuOTqTOZgi1SBC/u6rTL3G2McY/Xy0vpoeKkFN+DJ/+g+GRiMThSIJWT6/8d8d/KdsPQ6gNUuSHEjzD6OReSxMLi3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KPIevHoH; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KPIevHoH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=niZy1ehvvhSrvLi1KpzKomYT9ZZjgF2G9F7AWh8eZLM=; b=KPIevHoHu+L509LweCJTB+eM/f
	hxTc3Fp2VSQw9IJ12oep+g+F6bGkMyLLdTRA+oYtBCUSCLDmVmVoa9ZrMHjO7bnKdQ4xAs/mDUuUa
	tDhXsWpcQxE0Eu7YWywqjSjP04DQLDCip2frUsVy90qrOzvFZ3nnqHwqhDeAQtOQFZtDwgr4JOUAU
	b0nlKNbq5D8U0OjF3P1e2ta18urx14ffaXk1eiNGD9oszBJD9t95kCniJtsMPgknuKcQXJzuSfl+c
	E2xBjjHcTGRI98G93iO3CRkIHvGrzKjSy3B413z6YvbwWNrVgOt10ffaBWJDIPXDT902iR39QdbyW
	ooATZvfw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjWy9-000hLH-0y;
	Sun, 16 Feb 2025 13:26:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 13:26:50 +0800
Date: Sun, 16 Feb 2025 13:26:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
Cc: Tom Lendacky <Thomas.Lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"David S . Miller" <davem@davemloft.net>,
	Mario Limonciello <Mario.Limonciello@amd.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thomas Rijo-john <Rijo-john.Thomas@amd.com>,
	Rajib Mahapatra <Rajib.Mahapatra@amd.com>,
	Nimesh Easow <Nimesh.Easow@amd.com>
Subject: Re: [PATCH] crypto: ccp - Add support for PCI device 0x1134
Message-ID: <Z7F3Gp4Ks3XRqs81@gondor.apana.org.au>
References: <8e2b6da988e7cb922010847bb07b5e9cf84bb563.1738879803.git.Devaraj.Rangasamy@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e2b6da988e7cb922010847bb07b5e9cf84bb563.1738879803.git.Devaraj.Rangasamy@amd.com>

On Fri, Feb 07, 2025 at 03:41:52AM +0530, Devaraj Rangasamy wrote:
> PCI device 0x1134 shares same register features as PCI device 0x17E0.
> Hence reuse same data for the new PCI device ID 0x1134.
> 
> Signed-off-by: Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>
> ---
>  drivers/crypto/ccp/sp-pci.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
> index 248d98fd8c48..5357c4308da0 100644
> --- a/drivers/crypto/ccp/sp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -529,6 +529,7 @@ static const struct pci_device_id sp_pci_table[] = {
>  	{ PCI_VDEVICE(AMD, 0x14CA), (kernel_ulong_t)&dev_vdata[5] },
>  	{ PCI_VDEVICE(AMD, 0x15C7), (kernel_ulong_t)&dev_vdata[6] },
>  	{ PCI_VDEVICE(AMD, 0x1649), (kernel_ulong_t)&dev_vdata[6] },
> +	{ PCI_VDEVICE(AMD, 0x1134), (kernel_ulong_t)&dev_vdata[7] },
>  	{ PCI_VDEVICE(AMD, 0x17E0), (kernel_ulong_t)&dev_vdata[7] },
>  	{ PCI_VDEVICE(AMD, 0x156E), (kernel_ulong_t)&dev_vdata[8] },
>  	/* Last entry must be zero */
> --
> 2.25.1

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
