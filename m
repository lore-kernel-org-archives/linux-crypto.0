Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE844D599;
	Wed,  7 May 2025 15:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746633503; cv=none; b=dpH9XxHrZed+qV2nEjzeOiJJnFfXVn/woFpHBixf+hyeYpG4pUfNQu+h6ZWq63ASF+UrrWvZbhKXjyih+/W6Ac5uNK9UyHHsgRvHbcWHEctk+W+/yZT5cEq13Rvx71lswdFjo+8NIQm6iGJCjc6yACtYtiepdGyPYsfDyaL4New=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746633503; c=relaxed/simple;
	bh=9OTKdflDOR50qS6aHZW+uyRKI0CdXdUacM8H5zHJItI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUCAbwnindWehWeKJQ7IbQRvEbjaCmgIe25yQtPDykMkXxZzLV34vJeKQvxxv2lxhQx6VQmgu4MIWbTy/eOucp5nD3JDmxMO4K2TDUd+bwD7UQ4IeH7o1NstNfEcv02BdGuh1o3mVztmDMRKjeLgy9YFZxQ3aBxLhFz5zbIjn4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k/h1ebp0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k/h1ebp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD71C4CEE2;
	Wed,  7 May 2025 15:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746633501;
	bh=9OTKdflDOR50qS6aHZW+uyRKI0CdXdUacM8H5zHJItI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k/h1ebp0eNDJHb8V1zpv2hW1ydgmCNDe6rxjCI6ep4mRjUs6kUSsLfFZ7T5pjf0AE
	 xCq82YI0wQ8f8zzextQGxkj5gg5g/aEc1pQYEbprFIfNS7Ae+Hcc5fIXd1gl/tvnwY
	 eLUpaZkc1Lqwx4O3P5aPAtG8clad+ReDG7LFJplrGLorNcKS53T8S1adKIu+4LY7vh
	 9ZmhvQ37oX9h/vK1Mq+63z4xclfIa8fx3C3FiKIQgQPWifkrhhsBDNpC6xdd2h8w9L
	 rjZkWEmk9sXtZNmz19kDni2aw+tUcmxiWfVY/xrzOBnIySqacmREDu09t43vH+RiSb
	 /htHEMjuOXTOw==
Date: Wed, 7 May 2025 16:58:14 +0100
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
Subject: Re: [net-next PATCH v1 13/15] octeontx2-pf: ipsec: Manage NPC rules
 and SPI-to-SA table entries
Message-ID: <20250507155814.GG3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-14-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-14-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:54PM +0530, Tanmay Jagdale wrote:
> NPC rule for IPsec flows
> ------------------------
> Incoming IPsec packets are first classified for hardware fastpath
> processing in the NPC block. Hence, allocate an MCAM entry in NPC
> using the MCAM_ALLOC_ENTRY mailbox to add a rule for IPsec flow
> classification.
> 
> Then, install an NPC rule at this entry for packet classification
> based on ESP header and SPI value with match action as UCAST_IPSEC.
> Also, these packets need to be directed to the dedicated receive
> queue so provide the RQ index as part of NPC_INSTALL_FLOW mailbox.
> Add a function to delete NPC rule as well.
> 
> SPI-to-SA match table
> ---------------------
> NIX RX maintains a common hash table for matching the SPI value from
> in ESP packet to the SA index associated with it. This table has 2K entries
> with 4 ways. When a packet is received with action as UCAST_IPSEC, NIXRX
> uses the SPI from the packet header to perform lookup in the SPI-to-SA
> hash table. This lookup, if successful, returns an SA index that is used
> by NIXRX to calculate the exact SA context address and programs it in
> the CPT_INST_S before submitting the packet to CPT for decryption.
> 
> Add functions to install the delete an entry from this table via the
> NIX_SPI_TO_SA_ADD and NIX_SPI_TO_SA_DELETE mailbox calls respectively.
> 
> When the RQs are changed at runtime via ethtool, RVU PF driver frees all
> the resources and goes through reinitialization with the new set of receive
> queues. As part of this flow, the UCAST_IPSEC NPC rules that were installed
> by the RVU PF/VF driver have to be reconfigured with the new RQ index.
> 
> So, delete the NPC rules when the interface is stopped via otx2_stop().
> When otx2_open() is called, re-install the NPC flow and re-initialize the
> SPI-to-SA table for every SA context that was previously installed.
> 
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> ---
>  .../marvell/octeontx2/nic/cn10k_ipsec.c       | 201 ++++++++++++++++++
>  .../marvell/octeontx2/nic/cn10k_ipsec.h       |   7 +
>  .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |   9 +
>  3 files changed, 217 insertions(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c

...

> +static int cn10k_inb_install_flow(struct otx2_nic *pfvf, struct xfrm_state *x,
> +				  struct cn10k_inb_sw_ctx_info *inb_ctx_info)
> +{
> +	struct npc_install_flow_req *req;
> +	int err;
> +
> +	mutex_lock(&pfvf->mbox.lock);
> +
> +	req = otx2_mbox_alloc_msg_npc_install_flow(&pfvf->mbox);
> +	if (!req) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	req->entry = inb_ctx_info->npc_mcam_entry;
> +	req->features |= BIT(NPC_IPPROTO_ESP) | BIT(NPC_IPSEC_SPI) | BIT(NPC_DMAC);
> +	req->intf = NIX_INTF_RX;
> +	req->index = pfvf->ipsec.inb_ipsec_rq;
> +	req->match_id = 0xfeed;
> +	req->channel = pfvf->hw.rx_chan_base;
> +	req->op = NIX_RX_ACTIONOP_UCAST_IPSEC;
> +	req->set_cntr = 1;
> +	req->packet.spi = x->id.spi;
> +	req->mask.spi = 0xffffffff;

I realise that the value is isomorphic, but I would use the following
so that the rvalue has an endian annotation that matches the lvalue.

	req->mask.spi = cpu_to_be32(0xffffffff);

Flagged by Sparse.

> +
> +	/* Send message to AF */
> +	err = otx2_sync_mbox_msg(&pfvf->mbox);
> +out:
> +	mutex_unlock(&pfvf->mbox.lock);
> +	return err;
> +}

...

> +static int cn10k_inb_delete_spi_to_sa_match_entry(struct otx2_nic *pfvf,
> +						  struct cn10k_inb_sw_ctx_info *inb_ctx_info)

gcc-14.2.0 (at least) complains that cn10k_inb_delete_spi_to_sa_match_entry
is unused.

Likewise for cn10k_inb_delete_flow and cn10k_inb_delete_spi_to_sa_match_entry.

I'm unsure of the best way to address this but it would be nice
to avoid breaking build bisection for such a trivial reason.

Some ideas:
* Maybe it is possible to squash this and the last patch,
  or bring part of the last patch into this patch, or otherwise
  rearrange things to avoid this problem.
* Add temporary __maybe_unusd annotations.
  (I'd consider this a last resort.)

  ...
