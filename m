Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E039678F4A;
	Fri, 20 Jun 2025 11:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750418573; cv=none; b=drQ5VhNb1MKbGCtbNRlpAIZ4PQg8dKQIFhoNBwikPF1ph6Lw8DbDx0/5Zq+Jg2vgllMbkZbpr2t5YeGPNBCqNboZwzsVSdwL+rrtoyBdZfL84YMCjLMmwR6AABUAFcVv2FlSOsvKSIKpZQRh/VSiYjb2NVzVhaNINu+PDIwQsOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750418573; c=relaxed/simple;
	bh=xb7le+JVu5plOl8d+Z+QP0tBuHNw+JzW+sPw/OqJZ50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DSlYm+azt9lu9c7nGdqBhrA/jL9c596QHGEGZIBzKHLjhyTRwAfBxzJMROSgeGeT9nmU1hgAEAvu3lrlEvw313Tw77HqfRbN8LOFlv2DDyiYyoyDYNaHtV/S8hJSK7LJyXxnjtO1D8zNlM5Vv3y0ZzyUGwlje9X/7HW/cw65qlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hBi7dzW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hBi7dzW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DF8C4CEEF;
	Fri, 20 Jun 2025 11:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750418572;
	bh=xb7le+JVu5plOl8d+Z+QP0tBuHNw+JzW+sPw/OqJZ50=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hBi7dzW34kHQtLDne0ZtxxS3mMnKuIZOTTTYO34dIvlhvDsNWKpXwmYf1+6T8XRn2
	 n/OKSmEOIH6dWjcW31YMTl0Hi+8THSaCe71c8MtBU3DkcJDbydqSUIi9o35F54du6O
	 NyfOvOD0OG9gLnxy8iFaLnbDyvPyUslnFU9D8jsr9hCu+9ypXv6y3+NXY1MOziNdxx
	 FEA/Qe0kajW1EZUHT84ngVAfAiOQbyZay9CcPccyzzRtO2jUbLdLPvtwbBvC2TRjml
	 WPjz2YCkB5/PUlQUV0uzwlWqawhc6epHWmXomoTvt3dA9Vzw1gebG237cwWs+LWCJH
	 4ajtIesA8XaEA==
Date: Fri, 20 Jun 2025 12:22:49 +0100
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: davem@davemloft.net, leon@kernel.org, sgoutham@marvell.com,
	bbhushan2@marvell.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 14/14] octeontx2-pf: ipsec: Add XFRM state
 and policy hooks for inbound flows
Message-ID: <20250620112249.GL194429@horms.kernel.org>
References: <20250618113020.130888-1-tanmay@marvell.com>
 <20250618113020.130888-15-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618113020.130888-15-tanmay@marvell.com>

On Wed, Jun 18, 2025 at 05:00:08PM +0530, Tanmay Jagdale wrote:
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

...

> @@ -1141,6 +1154,137 @@ static int cn10k_outb_write_sa(struct otx2_nic *pf, struct qmem *sa_info)
>  	return ret;
>  }
>  
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
> +	cn10k_cpt_inst_flush(pf, &inst, sizeof(struct cpt_inst_s));
> +	dmb(sy);

Hi Tanmay,

As I understand things the above effectively means that this
driver will only compile for ARM64.

I do understand that the driver is only intended to be used on ARM64.
But it is nice to get compile coverage on other 64bit systems,
in particular x86_64.

And moreover, I think the guiding principle should be for drivers
to be as independent of the host system as possible.

Can we look into handling this a different way?

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

...
