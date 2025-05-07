Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 253A11C6FFA;
	Wed,  7 May 2025 14:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746627624; cv=none; b=V+X7YAsOu2HDFti7pJc0BduwUYl3lPEFXryZhCRo84K6v9XY/KdKqj0/KExH4Cn85ReJn2zOG3nolSR47M9wwoqPtzb8tq3yZYiMlFBTb1Pf8K2hg614+nj1sPGZ/5j1EkSwGWVsZZWgqGEg4VKRON1aLEmua5YsuBGjnEVayls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746627624; c=relaxed/simple;
	bh=zFJGQcJDh3GTlEHOGdUdTPx+Zwgyp8f5kmfWwBkFe0M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZzjNqr8mOBkWLYTKcBdU2s/I4J3N4+HZL9SbdVoQ/KqMGGW5p6lLBrRYEXE3KiarUeaTd+omz2j25x/+/1jog1jmp4n9FPpzRMhkSCE1D0eWh0S4xot35Rz2+PMm5Q2EUfvN6JS35Y1/nJCQFgPuW0fqNTCzey2tTw7ic+Upt+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=np/Y1rUT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="np/Y1rUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD53C4CEE2;
	Wed,  7 May 2025 14:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746627623;
	bh=zFJGQcJDh3GTlEHOGdUdTPx+Zwgyp8f5kmfWwBkFe0M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=np/Y1rUTunYXY4TMdjSCYcErldhUYX4d2EUfq8UnKWwAom75C5hdAo+uoS8iqo31F
	 DHs314yUPwhH3XAQxgTuhfdxETRWstr8qTH1Y7I2wVZH2o6LO0erpjghJUNxOT0RLz
	 Qs6iKCB5VbVu6LQ6sMbDTRAFyozXr9fXJBKnyqfp79lExOx8DaYNpX7TqY4bUZLD+n
	 au53LrT+sx5pc2yiy2ksNlHEBEiuoAJAvliqczw3yRH5ZqUEtr7SL2A/BF0vcCE0l8
	 59Ry3FmZusxEUHAQQabSDb7RSRQA/6qhkIkzpXMaPqEMH9qsHMgRzvVYbiYOFr+HZT
	 Y6gR+wCz88Dmw==
Date: Wed, 7 May 2025 15:20:16 +0100
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
	jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, bbhushan2@marvell.com, bhelgaas@google.com,
	pstanner@redhat.com, gregkh@linuxfoundation.org,
	peterz@infradead.org, linux@treblig.org,
	krzysztof.kozlowski@linaro.org, giovanni.cabiddu@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, rkannoth@marvell.com, sumang@marvell.com,
	gcherian@marvell.com
Subject: Re: [net-next PATCH v1 11/15] octeontx2-pf: ipsec: Handle NPA
 threshold interrupt
Message-ID: <20250507142016.GF3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-12-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-12-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:52PM +0530, Tanmay Jagdale wrote:
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

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> index b88c1b4c5839..365327ab9079 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> @@ -519,10 +519,77 @@ static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
>  	return err;
>  }
>  
> +static void cn10k_ipsec_npa_refill_inb_ipsecq(struct work_struct *work)
> +{
> +	struct cn10k_ipsec *ipsec = container_of(work, struct cn10k_ipsec,
> +						 refill_npa_inline_ipsecq);
> +	struct otx2_nic *pfvf = container_of(ipsec, struct otx2_nic, ipsec);
> +	struct otx2_pool *pool = NULL;
> +	struct otx2_qset *qset = NULL;
> +	u64 val, *ptr, op_int = 0, count;
> +	int err, pool_id, idx;
> +	dma_addr_t bufptr;
> +
> +	qset = &pfvf->qset;
> +
> +	val = otx2_read64(pfvf, NPA_LF_QINTX_INT(0));
> +	if (!(val & 1))
> +		return;
> +
> +	ptr = otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_INT);

Sparse complains about __iomem annotations around here:

  .../cn10k_ipsec.c:539:13: warning: incorrect type in assignment (different address spaces)
  .../cn10k_ipsec.c:539:13:    expected unsigned long long [usertype] *ptr
  .../cn10k_ipsec.c:539:13:    got void [noderef] __iomem *
  .../cn10k_ipsec.c:549:21: warning: incorrect type in assignment (different address spaces)
  .../cn10k_ipsec.c:549:21:    expected unsigned long long [usertype] *ptr
  .../cn10k_ipsec.c:549:21:    got void [noderef] __iomem *
  .../cn10k_ipsec.c:620:13: warning: incorrect type in assignment (different address spaces)
  .../cn10k_ipsec.c:620:13:    expected void *ptr
  .../cn10k_ipsec.c:620:13:    got void [noderef] __iomem *

> +	val = otx2_atomic64_add(((u64)pfvf->ipsec.inb_ipsec_pool << 44), ptr);
> +
> +	/* Error interrupt bits */
> +	if (val & 0xff)
> +		op_int = (val & 0xff);
> +
> +	/* Refill buffers on a Threshold interrupt */
> +	if (val & (1 << 16)) {
> +		/* Get the current number of buffers consumed */
> +		ptr = otx2_get_regaddr(pfvf, NPA_LF_AURA_OP_CNT);
> +		count = otx2_atomic64_add(((u64)pfvf->ipsec.inb_ipsec_pool << 44), ptr);
> +		count &= GENMASK_ULL(35, 0);
> +
> +		/* Refill */
> +		pool_id = pfvf->ipsec.inb_ipsec_pool;
> +		pool = &pfvf->qset.pool[pool_id];
> +
> +		for (idx = 0; idx < count; idx++) {
> +			err = otx2_alloc_rbuf(pfvf, pool, &bufptr, pool_id, idx);
> +			if (err) {
> +				netdev_err(pfvf->netdev,
> +					   "Insufficient memory for IPsec pool buffers\n");
> +				break;
> +			}
> +			pfvf->hw_ops->aura_freeptr(pfvf, pool_id,
> +						    bufptr + OTX2_HEAD_ROOM);
> +		}
> +
> +		op_int |= (1 << 16);
> +	}
> +
> +	/* Clear/ACK Interrupt */
> +	if (op_int)
> +		otx2_write64(pfvf, NPA_LF_AURA_OP_INT,
> +			     ((u64)pfvf->ipsec.inb_ipsec_pool << 44) | op_int);
> +}

...
