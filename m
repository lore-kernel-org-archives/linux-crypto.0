Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC9228A1FA;
	Fri, 20 Jun 2025 11:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750417242; cv=none; b=oUTiWu9NXmo7Aw1T5+fbAO6U5TX7hlytdxCEdcvGW3MVOvdaaDENDezM88HY6OTPSVAV9Ip2buv7tkr/IDiTg23c6+UOU9WZH8VEJ6xFRZK6xMJt/+mswuehktbrHB21QZi6E9Eq7/uCMtTXmHgETqKESQBRi+PypcP3Za+HHCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750417242; c=relaxed/simple;
	bh=yX4wNSrlruhfxucdKAPy6MrhE+DXh4QD91WIrozweT0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BxS78eTxcW++avdmIGN6oPmiYmwqn4yqDBIX+vWvdbCmy0MW3zaGHcDkg8b8ioAZ+vYAQXEimrBo9aA2CxahYJDSudO/CprO6Ih18iOhlAiM9L9FMtYhMmhkg9kGZ/KHZ79w3F4c3FiU5tYBJR22IevKLZK61NCQFO93q3fiUs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ewJpOMl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ewJpOMl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88DEC4CEEF;
	Fri, 20 Jun 2025 11:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750417242;
	bh=yX4wNSrlruhfxucdKAPy6MrhE+DXh4QD91WIrozweT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ewJpOMl80pGMjqYo72SD23kWF3Xg1kGLIqnAemnKGz0ejkAll40zf5lZHS7Ivww+q
	 OhszyT/oxVXnsUek5j3Bemnv6IeFNybdBqJqufPi20SyeF1TOJ/+kFeyLSQEzRjvLY
	 4K0emn2i7ApWr3W9+Wl9s1UZ9Hi0KfciBb0SUDppoAl+Y5X2LqjmGLaP/nytXc7K1q
	 kW5lLScmkWvPsnu6I9qFsG51NJ1w7dHG7Ko0z8YwQBu3xJgmz1mtVUhODFng1drOTR
	 mhPvEKseytc5eNBRcylhYbqNyFodVS+KilvqIc3Tex/uyu6mCouTRc2CQsxpGR5NIJ
	 pJ+Lkqr670lvA==
Date: Fri, 20 Jun 2025 12:00:38 +0100
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: davem@davemloft.net, leon@kernel.org, sgoutham@marvell.com,
	bbhushan2@marvell.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 10/14] octeontx2-pf: ipsec: Handle NPA
 threshold interrupt
Message-ID: <20250620110038.GJ194429@horms.kernel.org>
References: <20250618113020.130888-1-tanmay@marvell.com>
 <20250618113020.130888-11-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618113020.130888-11-tanmay@marvell.com>

On Wed, Jun 18, 2025 at 05:00:04PM +0530, Tanmay Jagdale wrote:
> The NPA Aura pool that is dedicated for 1st pass inline IPsec flows
> raises an interrupt when the buffers of that aura_id drop below a
> threshold value.
> 
> Add the following changes to handle this interrupt
> - Increase the number of MSIX vectors requested for the PF/VF to
>   include NPA vector.
> - Create a workqueue (refill_npa_inline_ipsecq) to allocate and
>   refill buffers to the pool.
> - When the interrupt is raised, schedule the workqueue entry,
>   cn10k_ipsec_npa_refill_inb_ipsecq(), where the current count of
>   consumed buffers is determined via NPA_LF_AURA_OP_CNT and then
>   replenished.
> 
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> ---
> Changes in V2:
> - Fixed sparse warnings
> 
> V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-12-tanmay@marvell.com/
> 
>  .../marvell/octeontx2/nic/cn10k_ipsec.c       | 94 ++++++++++++++++++-
>  .../marvell/octeontx2/nic/cn10k_ipsec.h       |  1 +
>  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  4 +
>  .../ethernet/marvell/octeontx2/nic/otx2_reg.h |  2 +
>  .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  4 +
>  5 files changed, 104 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c

...

>  static int cn10k_inb_cpt_init(struct net_device *netdev)
>  {
>  	struct otx2_nic *pfvf = netdev_priv(netdev);
> -	int ret = 0;
> +	int ret = 0, vec;
> +	char *irq_name;
> +	void *ptr;
> +	u64 val;
>  
>  	ret = cn10k_ipsec_setup_nix_rx_hw_resources(pfvf);
>  	if (ret) {
> @@ -528,6 +587,34 @@ static int cn10k_inb_cpt_init(struct net_device *netdev)
>  		return ret;
>  	}
>  
> +	/* Work entry for refilling the NPA queue for ingress inline IPSec */
> +	INIT_WORK(&pfvf->ipsec.refill_npa_inline_ipsecq,
> +		  cn10k_ipsec_npa_refill_inb_ipsecq);
> +
> +	/* Register NPA interrupt */
> +	vec = pfvf->hw.npa_msixoff;
> +	irq_name = &pfvf->hw.irq_name[vec * NAME_SIZE];
> +	snprintf(irq_name, NAME_SIZE, "%s-npa-qint", pfvf->netdev->name);
> +
> +	ret = request_irq(pci_irq_vector(pfvf->pdev, vec),
> +			  cn10k_ipsec_npa_inb_ipsecq_intr_handler, 0,
> +			  irq_name, pfvf);
> +	if (ret) {
> +		dev_err(pfvf->dev,
> +			"RVUPF%d: IRQ registration failed for NPA QINT\n",
> +			rvu_get_pf(pfvf->pdev, pfvf->pcifunc));
> +		return ret;
> +	}
> +
> +	/* Enable NPA threshold interrupt */
> +	ptr = otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_INT);

Hi Tanmay,

ptr is set but otherwise unused in this function.
Probably it should be removed.

Flagged by clang and gcc with -Wunused-but-set-variable

Also, Sparse warns that the return type of otx2_get_regaddr()
is  void __iomem *, but ptr does not have an __iomem annotation.

> +	val = BIT_ULL(43) | BIT_ULL(17);
> +	otx2_write64(pfvf, NPA_LF_AURA_OP_INT,
> +		     ((u64)pfvf->ipsec.inb_ipsec_pool << 44) | val);
> +
> +	/* Enable interrupt */
> +	otx2_write64(pfvf, NPA_LF_QINTX_ENA_W1S(0), BIT_ULL(0));
> +
>  	return ret;
>  }
>  
