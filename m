Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D271C84D7;
	Wed,  7 May 2025 18:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746642684; cv=none; b=dGVfirq4ZMoHpB+auX14HQSCBiMi/wNFs+2RortcIoqDH2htYZcI/4UU7j1JT+da21gb9IYz7i42BmEPUMSST/3ZloCMGYOJLUL0wMUjxLZacFWQS03cr/lMMbZSuv3DjKl1uvt8olA8Q9VRzfsSFIm6PtXpeMKPhP6X0qb+Uac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746642684; c=relaxed/simple;
	bh=SGMXgAXcsM1NyUQI3wXCgHNlUXq03+m075KqbY4kOcI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mul1Frmuuwfx6+PSKxsDFzyDuN+IbAvc7rO6qT9qTxmON7sKhIeS57MJJ5uGTCaxf1fC+8aNvohZDCZGJDaMwqKtm+JKNacQgGtdT1yZiALg7LOHdFQe+vuTTVbsmKeZMxDq6FOK3Ilx4Q1VRstvh1cKpSlySoJtODf4Qmba1ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+JuVX5/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+JuVX5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD32AC4CEE2;
	Wed,  7 May 2025 18:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746642684;
	bh=SGMXgAXcsM1NyUQI3wXCgHNlUXq03+m075KqbY4kOcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f+JuVX5/GtoB4CH7l2pG0Dr+0ufWnisu3lbDByGcim1yRxks0K5LxFG6OPblV1fIJ
	 dh2Tds03xvmUEdMk6WFLkb6Gp0tOqV289h8y0QRjXMBbMPOL6cqY5uhbwtXfbcRNu0
	 baZ1L5IM8MrFyP9yneaXX3WqP3rajYRoDSWFVx8wcz+ewStsajveVJS5L7tuoYrYdG
	 RxOHemsj9WquZbPkR+70XL5G8sdge+DUS39JKSAKzn7BT9WOsA/LLTHhwZ/jaMEb+7
	 KqBwFlgq8fa9gyMhAHSPeBypuMelhwynm8GEY2lVCmQ0H05KFiwq2g/s8i1Av9p0Jc
	 Mx/pynPRpVlZQ==
Date: Wed, 7 May 2025 19:31:16 +0100
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
Subject: Re: [net-next PATCH v1 15/15] octeontx2-pf: ipsec: Add XFRM state
 and policy hooks for inbound flows
Message-ID: <20250507183116.GI3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-16-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-16-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:56PM +0530, Tanmay Jagdale wrote:
> Add XFRM state hook for inbound flows and configure the following:
>   - Install an NPC rule to classify the 1st pass IPsec packets and
>     direct them to the dedicated RQ
>   - Allocate a free entry from the SA table and populate it with the
>     SA context details based on xfrm state data.
>   - Create a mapping of the SPI value to the SA table index. This is
>     used by NIXRX to calculate the exact SA context  pointer address
>     based on the SPI in the packet.
>   - Prepare the CPT SA context to decrypt buffer in place and the
>     write it the CPT hardware via LMT operation.
>   - When the XFRM state is deleted, clear this SA in CPT hardware.
> 
> Also add XFRM Policy hooks to allow successful offload of inbound
> PACKET_MODE.
> 
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> ---
>  .../marvell/octeontx2/nic/cn10k_ipsec.c       | 449 ++++++++++++++++--
>  1 file changed, 419 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> index bebf5cdedee4..6441598c7e0f 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> @@ -448,7 +448,7 @@ static int cn10k_inb_alloc_mcam_entry(struct otx2_nic *pfvf,
>  	return err;
>  }
>  
> -static int cn10k_inb_install_flow(struct otx2_nic *pfvf, struct xfrm_state *x,
> +static int cn10k_inb_install_flow(struct otx2_nic *pfvf,
>  				  struct cn10k_inb_sw_ctx_info *inb_ctx_info)
>  {
>  	struct npc_install_flow_req *req;
> @@ -463,14 +463,14 @@ static int cn10k_inb_install_flow(struct otx2_nic *pfvf, struct xfrm_state *x,
>  	}
>  
>  	req->entry = inb_ctx_info->npc_mcam_entry;
> -	req->features |= BIT(NPC_IPPROTO_ESP) | BIT(NPC_IPSEC_SPI) | BIT(NPC_DMAC);
> +	req->features |= BIT(NPC_IPPROTO_ESP) | BIT(NPC_IPSEC_SPI);
>  	req->intf = NIX_INTF_RX;
>  	req->index = pfvf->ipsec.inb_ipsec_rq;
>  	req->match_id = 0xfeed;
>  	req->channel = pfvf->hw.rx_chan_base;
>  	req->op = NIX_RX_ACTIONOP_UCAST_IPSEC;
>  	req->set_cntr = 1;
> -	req->packet.spi = x->id.spi;
> +	req->packet.spi = inb_ctx_info->spi;

I think this should be:

	req->packet.spi = cpu_to_be32(inb_ctx_info->spi);

Flagged by Sparse.

Please also take a look at other Sparse warnings added by this patch (set).

>  	req->mask.spi = 0xffffffff;
>  
>  	/* Send message to AF */

...

> +static int cn10k_inb_write_sa(struct otx2_nic *pf,
> +			      struct xfrm_state *x,
> +			      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
> +{
> +	dma_addr_t res_iova, dptr_iova, sa_iova;
> +	struct cn10k_rx_sa_s *sa_dptr, *sa_cptr;
> +	struct cpt_inst_s inst;
> +	u32 sa_size, off;
> +	struct cpt_res_s *res;
> +	u64 reg_val;
> +	int ret;
> +
> +	res = dma_alloc_coherent(pf->dev, sizeof(struct cpt_res_s),
> +				 &res_iova, GFP_ATOMIC);
> +	if (!res)
> +		return -ENOMEM;
> +
> +	sa_cptr = inb_ctx_info->sa_entry;
> +	sa_iova = inb_ctx_info->sa_iova;
> +	sa_size = sizeof(struct cn10k_rx_sa_s);
> +
> +	sa_dptr = dma_alloc_coherent(pf->dev, sa_size, &dptr_iova, GFP_ATOMIC);
> +	if (!sa_dptr) {
> +		dma_free_coherent(pf->dev, sizeof(struct cpt_res_s), res,
> +				  res_iova);
> +		return -ENOMEM;
> +	}
> +
> +	for (off = 0; off < (sa_size / 8); off++)
> +		*((u64 *)sa_dptr + off) = cpu_to_be64(*((u64 *)sa_cptr + off));
> +
> +	memset(&inst, 0, sizeof(struct cpt_inst_s));
> +
> +	res->compcode = 0;
> +	inst.res_addr = res_iova;
> +	inst.dptr = (u64)dptr_iova;
> +	inst.param2 = sa_size >> 3;
> +	inst.dlen = sa_size;
> +	inst.opcode_major = CN10K_IPSEC_MAJOR_OP_WRITE_SA;
> +	inst.opcode_minor = CN10K_IPSEC_MINOR_OP_WRITE_SA;
> +	inst.cptr = sa_iova;
> +	inst.ctx_val = 1;
> +	inst.egrp = CN10K_DEF_CPT_IPSEC_EGRP;
> +
> +	/* Re-use Outbound CPT LF to install Ingress SAs as well because
> +	 * the driver does not own the ingress CPT LF.
> +	 */
> +	pf->ipsec.io_addr = (__force u64)otx2_get_regaddr(pf, CN10K_CPT_LF_NQX(0));

I suspect this indicates that io_addr should have an __iomem annotation.
And users should be updated accordingly.

> +	cn10k_cpt_inst_flush(pf, &inst, sizeof(struct cpt_inst_s));
> +	dmb(sy);
> +
> +	ret = cn10k_wait_for_cpt_respose(pf, res);
> +	if (ret)
> +		goto out;
> +
> +	/* Trigger CTX flush to write dirty data back to DRAM */
> +	reg_val = FIELD_PREP(GENMASK_ULL(45, 0), sa_iova >> 7);
> +	otx2_write64(pf, CN10K_CPT_LF_CTX_FLUSH, reg_val);
> +
> +out:
> +	dma_free_coherent(pf->dev, sa_size, sa_dptr, dptr_iova);
> +	dma_free_coherent(pf->dev, sizeof(struct cpt_res_s), res, res_iova);
> +	return ret;
> +}
> +
> +static void cn10k_xfrm_inb_prepare_sa(struct otx2_nic *pf, struct xfrm_state *x,
> +				      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
> +{
> +	struct cn10k_rx_sa_s *sa_entry = inb_ctx_info->sa_entry;
> +	int key_len = (x->aead->alg_key_len + 7) / 8;
> +	u8 *key = x->aead->alg_key;
> +	u32 sa_size = sizeof(struct cn10k_rx_sa_s);
> +	u64 *tmp_key;
> +	u32 *tmp_salt;
> +	int idx;
> +
> +	memset(sa_entry, 0, sizeof(struct cn10k_rx_sa_s));
> +
> +	/* Disable ESN for now */
> +	sa_entry->esn_en = 0;
> +
> +	/* HW context offset is word-31 */
> +	sa_entry->hw_ctx_off = 31;
> +	sa_entry->pkind = NPC_RX_CPT_HDR_PKIND;
> +	sa_entry->eth_ovrwr = 1;
> +	sa_entry->pkt_output = 1;
> +	sa_entry->pkt_format = 1;
> +	sa_entry->orig_pkt_free = 0;
> +	/* context push size is up to word 31 */
> +	sa_entry->ctx_push_size = 31 + 1;
> +	/* context size, 128 Byte aligned up */
> +	sa_entry->ctx_size = (sa_size / OTX2_ALIGN)  & 0xF;
> +
> +	sa_entry->cookie = inb_ctx_info->sa_index;
> +
> +	/* 1 word (??) prepanded to context header size */
> +	sa_entry->ctx_hdr_size = 1;
> +	/* Mark SA entry valid */
> +	sa_entry->aop_valid = 1;
> +
> +	sa_entry->sa_dir = 0;			/* Inbound */
> +	sa_entry->ipsec_protocol = 1;		/* ESP */
> +	/* Default to Transport Mode */
> +	if (x->props.mode == XFRM_MODE_TUNNEL)
> +		sa_entry->ipsec_mode = 1;	/* Tunnel Mode */
> +
> +	sa_entry->et_ovrwr_ddr_en = 1;
> +	sa_entry->enc_type = 5;			/* AES-GCM only */
> +	sa_entry->aes_key_len = 1;		/* AES key length 128 */
> +	sa_entry->l2_l3_hdr_on_error = 1;
> +	sa_entry->spi = cpu_to_be32(x->id.spi);
> +
> +	/* Last 4 bytes are salt */
> +	key_len -= 4;
> +	memcpy(sa_entry->cipher_key, key, key_len);
> +	tmp_key = (u64 *)sa_entry->cipher_key;
> +
> +	for (idx = 0; idx < key_len / 8; idx++)
> +		tmp_key[idx] = be64_to_cpu(tmp_key[idx]);
> +
> +	memcpy(&sa_entry->iv_gcm_salt, key + key_len, 4);
> +	tmp_salt = (u32 *)&sa_entry->iv_gcm_salt;
> +	*tmp_salt = be32_to_cpu(*tmp_salt);

Maybe I messed it up, but this seems clearer to me:

	void *key = x->aead->alg_key;

	...

	sa_entry->iv_gcm_salt = be32_to_cpup(key + key_len);


> +
> +	/* Write SA context data to memory before enabling */
> +	wmb();
> +
> +	/* Enable SA */
> +	sa_entry->sa_valid = 1;
> +}
> +
>  static int cn10k_ipsec_get_hw_ctx_offset(void)
>  {
>  	/* Offset on Hardware-context offset in word */

...

> @@ -1316,8 +1450,96 @@ static int cn10k_ipsec_validate_state(struct xfrm_state *x,
>  static int cn10k_ipsec_inb_add_state(struct xfrm_state *x,
>  				     struct netlink_ext_ack *extack)
>  {

...

> +	netdev_dbg(netdev, "inb_ctx_info: sa_index:%d spi:0x%x mcam_entry:%d"
> +		   " hash_index:0x%x way:0x%x\n",

Please don't split strings. It makes searching for them more difficult.
This is an exception to the 80 column line length rule.
Although you may want to consider making the string shorter.

...
