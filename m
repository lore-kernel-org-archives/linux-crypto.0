Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B4228A3F5;
	Wed,  7 May 2025 13:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746625588; cv=none; b=ast8aXGZwiZY/Acj9KLZPubohX64w12qB0d/0Ud9iLFvW5H0aALmmIBm1B9uht4t7v2lfuTfJC5sL142zz89TjwKcfNfSqjGN7bFDqKXUq8vQoRZ+MhWAgzXI0VxEBR6sY9v//NELiw4jOOIOET0ysWO5nqxRG2QXzgsKdpO5FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746625588; c=relaxed/simple;
	bh=hEESpH98vETQIZ0+XWffGzM7BGYfcwRdDsaQ4wEquqc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CjPi5nEQF3+SVcIu5fleWSed0Y6y1Fo8cf7I/bgsGfP3DaauTWk79+37KnKubaB+qLx1sl07C4rYt82739ZJOGjIdb2ABWHnboJ8FxGKuek/CdPle3C7a+5ML1npiXGNtIGE80dkdgtdJyEm0If2MyK8KPDsX3uR0v01w4nACns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U23XjGTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U23XjGTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B11C4CEE7;
	Wed,  7 May 2025 13:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746625587;
	bh=hEESpH98vETQIZ0+XWffGzM7BGYfcwRdDsaQ4wEquqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U23XjGTCYK3gILMz2e+THb15dqmeOQYrj8DFI6aRtrdZ/3v0LvTzpK69PdnaYokfJ
	 zKw4hTdJ6W/vVkXZCh45Iuj8yV7QqKa12C3QUJtmLL1gvpXv7qvG5/tstFyJrLFzZZ
	 zpBy/xFgyUplNZ1MCUCw8LDmTfn9H2z9NPHzPMMiWnR6JaJikH3KxrfrWOWZeb3EEU
	 sgOtWpT8UG9trtkVBkV0NmMJEnEerrcTAEbzOPsWh2dGueQMUoYxbMq6DaWJ+vZ78s
	 vXdfAoJ9atJEdatSHVOAtR8ErUMRL8e8mVNsCPTKR/cEABikNuy0+cRUQe12mIzXHf
	 jsi8KfgGfDr5A==
Date: Wed, 7 May 2025 14:46:20 +0100
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
Subject: Re: [net-next PATCH v1 10/15] octeontx2-pf: ipsec: Setup NIX HW
 resources for inbound flows
Message-ID: <20250507134620.GE3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-11-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-11-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:51PM +0530, Tanmay Jagdale wrote:
> A incoming encrypted IPsec packet in the RVU NIX hardware needs
> to be classified for inline fastpath processing and then assinged

nit: assigned

     checkpatch.pl --codespell is your friend

> a RQ and Aura pool before sending to CPT for decryption.
> 
> Create a dedicated RQ, Aura and Pool with the following setup
> specifically for IPsec flows:
>  - Set ipsech_en, ipsecd_drop_en in RQ context to enable hardware
>    fastpath processing for IPsec flows.
>  - Configure the dedicated Aura to raise an interrupt when
>    it's buffer count drops below a threshold value so that the
>    buffers can be replenished from the CPU.
> 
> The RQ, Aura and Pool contexts are initialized only when esp-hw-offload
> feature is enabled via ethtool.
> 
> Also, move some of the RQ context macro definitions to otx2_common.h
> so that they can be used in the IPsec driver as well.
> 
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c

...

> +static int cn10k_ipsec_setup_nix_rx_hw_resources(struct otx2_nic *pfvf)
> +{
> +	struct otx2_hw *hw = &pfvf->hw;
> +	int stack_pages, pool_id;
> +	struct otx2_pool *pool;
> +	int err, ptr, num_ptrs;
> +	dma_addr_t bufptr;
> +
> +	num_ptrs = 256;
> +	pool_id = pfvf->ipsec.inb_ipsec_pool;
> +	stack_pages = (num_ptrs + hw->stack_pg_ptrs - 1) / hw->stack_pg_ptrs;
> +
> +	mutex_lock(&pfvf->mbox.lock);
> +
> +	/* Initialize aura context */
> +	err = cn10k_ipsec_ingress_aura_init(pfvf, pool_id, pool_id, num_ptrs);
> +	if (err)
> +		goto fail;
> +
> +	/* Initialize pool */
> +	err = otx2_pool_init(pfvf, pool_id, stack_pages, num_ptrs, pfvf->rbsize, AURA_NIX_RQ);
> +	if (err)

This appears to leak pool->fc_addr.

> +		goto fail;
> +
> +	/* Flush accumulated messages */
> +	err = otx2_sync_mbox_msg(&pfvf->mbox);
> +	if (err)
> +		goto pool_fail;
> +
> +	/* Allocate pointers and free them to aura/pool */
> +	pool = &pfvf->qset.pool[pool_id];
> +	for (ptr = 0; ptr < num_ptrs; ptr++) {
> +		err = otx2_alloc_rbuf(pfvf, pool, &bufptr, pool_id, ptr);
> +		if (err) {
> +			err = -ENOMEM;
> +			goto pool_fail;
> +		}
> +		pfvf->hw_ops->aura_freeptr(pfvf, pool_id, bufptr + OTX2_HEAD_ROOM);
> +	}
> +
> +	/* Initialize RQ and map buffers from pool_id */
> +	err = cn10k_ipsec_ingress_rq_init(pfvf, pfvf->ipsec.inb_ipsec_rq, pool_id);
> +	if (err)
> +		goto pool_fail;
> +
> +	mutex_unlock(&pfvf->mbox.lock);
> +	return 0;
> +
> +pool_fail:
> +	mutex_unlock(&pfvf->mbox.lock);
> +	qmem_free(pfvf->dev, pool->stack);
> +	qmem_free(pfvf->dev, pool->fc_addr);
> +	page_pool_destroy(pool->page_pool);
> +	devm_kfree(pfvf->dev, pool->xdp);

It is not clear to me why devm_kfree() is being called here.
I didn't look deeply. But I think it is likely that
either pool->xdp should be freed when the device is released.
Or pool->xdp should not be allocated (and freed) using devm functions.

> +	pool->xsk_pool = NULL;

The clean-up of pool->stack, pool->page_pool), pool->xdp, and
pool->xsk_pool, all seem to unwind initialisation performed by
otx2_pool_init(). And appear to be duplicated elsewhere.
I would suggest adding a helper for that.

> +fail:
> +	otx2_mbox_reset(&pfvf->mbox.mbox, 0);
> +	return err;
> +}

...
