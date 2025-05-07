Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FEF153BED;
	Wed,  7 May 2025 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746635458; cv=none; b=fgw3E9mq3e9jXIa99RMDtfc86QAgYX5EeiU3s5l+01e1+lHIYOgL+iSYnE2jGrXR05q/lDANKsUMSjeM62+PELWurN1UA2RRImGnR4UxxdmRBZ7Wm8O5q4V7vYGkVyRq5jiSAgvLFPiZqzFq96aopVJ/Hbzllitin66ViCA5iPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746635458; c=relaxed/simple;
	bh=6aOpju2M8SqP4rsAuVnCCFQv1NLqmuWeSfVosiG/weU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o4KJytrfU4SsmPpVRnOr1m213AnKzY7CE+xuMFGkvzdMpL2HcWzuhtnoEHl+gC/muuNMWFPn/hjLprs66w8W+FqMu5A0t84pVyS2aux9BTxUuSc15/ZGeAPwFXhHIAAoT+esl8+8pGDag6WCrXOHkplIJ3FLCYDRHroPNebLfcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bpq6P4pP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bpq6P4pP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52CBC4CEE9;
	Wed,  7 May 2025 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746635457;
	bh=6aOpju2M8SqP4rsAuVnCCFQv1NLqmuWeSfVosiG/weU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Bpq6P4pPED5yegGpV1pLtibIsST/l6exbkJs4qZ/fWsUgA6Q7+jz7YsiNowEvonVy
	 GNOHB74zZFfhGLCGG8jbc9giZiYHFphZCDOiWoSvCxgVrQGj4rbbm6VvOMGGvRG0/m
	 7Kbu/vGz9mhof9lz8f1Fo6p52/Su/iPgUaIY2o+z5LGnGAHBBvZqgPl3OI5lajbcEV
	 g8f0V3WwlYk2EySeOHod6s03Iz97X58ROlqaeYICXXm+hg1NsI+TQxUfsL+YVxxDB8
	 f4sDxMexBAj46tbBczV4mE+f3vML5TsPmKjLb4WqTzc+sD7kom+wsyOebwVBDPjIWo
	 krFO5sdbpzEEg==
Date: Wed, 7 May 2025 17:30:50 +0100
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
Subject: Re: [net-next PATCH v1 14/15] octeontx2-pf: ipsec: Process CPT
 metapackets
Message-ID: <20250507163050.GH3339421@horms.kernel.org>
References: <20250502132005.611698-1-tanmay@marvell.com>
 <20250502132005.611698-15-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250502132005.611698-15-tanmay@marvell.com>

On Fri, May 02, 2025 at 06:49:55PM +0530, Tanmay Jagdale wrote:
> CPT hardware forwards decrypted IPsec packets to NIX via the X2P bus
> as metapackets which are of 256 bytes in length. Each metapacket
> contains CPT_PARSE_HDR_S and initial bytes of the decrypted packet
> that helps NIX RX in classifying and submitting to CPU. Additionally,
> CPT also sets BIT(11) of the channel number to indicate that it's a
> 2nd pass packet from CPT.
> 
> Since the metapackets are not complete packets, they don't have to go
> through L3/L4 layer length and checksum verification so these are
> disabled via the NIX_LF_INLINE_RQ_CFG mailbox during IPsec initialization.
> 
> The CPT_PARSE_HDR_S contains a WQE pointer to the complete decrypted
> packet. Add code in the rx NAPI handler to parse the header and extract
> WQE pointer. Later, use this WQE pointer to construct the skb, set the
> XFRM packet mode flags to indicate successful decryption before submitting
> it to the network stack.
> 
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>
> ---
>  .../marvell/octeontx2/nic/cn10k_ipsec.c       | 61 +++++++++++++++++++
>  .../marvell/octeontx2/nic/cn10k_ipsec.h       | 47 ++++++++++++++
>  .../marvell/octeontx2/nic/otx2_struct.h       | 16 +++++
>  .../marvell/octeontx2/nic/otx2_txrx.c         | 25 +++++++-
>  4 files changed, 147 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> index 91c8f13b6e48..bebf5cdedee4 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> @@ -346,6 +346,67 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
>  	return ret;
>  }
>  
> +struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
> +						     struct nix_rx_sg_s *sg,
> +						     struct sk_buff *skb,
> +						     int qidx)
> +{
> +	struct nix_wqe_rx_s *wqe = NULL;
> +	u64 *seg_addr = &sg->seg_addr;
> +	struct cpt_parse_hdr_s *cptp;
> +	struct xfrm_offload *xo;
> +	struct otx2_pool *pool;
> +	struct xfrm_state *xs;
> +	struct sec_path *sp;
> +	u64 *va_ptr;
> +	void *va;
> +	int i;
> +
> +	/* CPT_PARSE_HDR_S is present in the beginning of the buffer */
> +	va = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain, *seg_addr));
> +
> +	/* Convert CPT_PARSE_HDR_S from BE to LE */
> +	va_ptr = (u64 *)va;

phys_to_virt returns a void *. And there is no need to explicitly cast
another pointer type to or from a void *.

So probably this can simply be:

	va_ptr = phys_to_virt(...);


> +	for (i = 0; i < (sizeof(struct cpt_parse_hdr_s) / sizeof(u64)); i++)
> +		va_ptr[i] = be64_to_cpu(va_ptr[i]);

Please don't use the same variable to hold both big endian and
host byte order values. Because tooling can no longer provide
information about endian mismatches.

Flagged by Sparse.

Also, isn't only the long word that exactly comprises the
wqe_ptr field of cpt_parse_hdr_s used? If so, perhaps
only that portion needs to be converted to host byte order?

I'd explore describing the members of struct cpt_parse_hdr_s as __be64.
And use FIELD_PREP and FIELD_GET to deal with parts of each __be64.
I think that would lead to a simpler implementation.

> +
> +	cptp = (struct cpt_parse_hdr_s *)va;
> +
> +	/* Convert the wqe_ptr from CPT_PARSE_HDR_S to a CPU usable pointer */
> +	wqe = (struct nix_wqe_rx_s *)phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain,
> +								    cptp->wqe_ptr));

There is probably no need to cast from void * here either.

	wqe = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain,
	                   cptp->wqe_ptr));

> +
> +	/* Get the XFRM state pointer stored in SA context */
> +	va_ptr = pfvf->ipsec.inb_sa->base +
> +		(cptp->cookie * pfvf->ipsec.sa_tbl_entry_sz) + 1024;
> +	xs = (struct xfrm_state *)*va_ptr;

Maybe this can be more succinctly written as follows?

	xs = pfvf->ipsec.inb_sa->base +
		(cptp->cookie * pfvf->ipsec.sa_tbl_entry_sz) + 1024;

> +
> +	/* Set XFRM offload status and flags for successful decryption */
> +	sp = secpath_set(skb);
> +	if (!sp) {
> +		netdev_err(pfvf->netdev, "Failed to secpath_set\n");
> +		wqe = NULL;
> +		goto err_out;
> +	}
> +
> +	rcu_read_lock();
> +	xfrm_state_hold(xs);
> +	rcu_read_unlock();
> +
> +	sp->xvec[sp->len++] = xs;
> +	sp->olen++;
> +
> +	xo = xfrm_offload(skb);
> +	xo->flags = CRYPTO_DONE;
> +	xo->status = CRYPTO_SUCCESS;
> +
> +err_out:
> +	/* Free the metapacket memory here since it's not needed anymore */
> +	pool = &pfvf->qset.pool[qidx];
> +	otx2_free_bufs(pfvf, pool, *seg_addr - OTX2_HEAD_ROOM, pfvf->rbsize);
> +	return wqe;
> +}
> +
>  static int cn10k_inb_alloc_mcam_entry(struct otx2_nic *pfvf,
>  				      struct cn10k_inb_sw_ctx_info *inb_ctx_info)
>  {
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
> index aad5ebea64ef..68046e377486 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h
> @@ -8,6 +8,7 @@
>  #define CN10K_IPSEC_H
>  
>  #include <linux/types.h>
> +#include "otx2_struct.h"
>  
>  DECLARE_STATIC_KEY_FALSE(cn10k_ipsec_sa_enabled);
>  
> @@ -302,6 +303,41 @@ struct cpt_sg_s {
>  	u64 rsvd_63_50	: 14;
>  };
>  
> +/* CPT Parse Header Structure for Inbound packets */
> +struct cpt_parse_hdr_s {
> +	/* Word 0 */
> +	u64 cookie      : 32;
> +	u64 match_id    : 16;
> +	u64 err_sum     : 1;
> +	u64 reas_sts    : 4;
> +	u64 reserved_53 : 1;
> +	u64 et_owr      : 1;
> +	u64 pkt_fmt     : 1;
> +	u64 pad_len     : 3;
> +	u64 num_frags   : 3;
> +	u64 pkt_out     : 2;
> +
> +	/* Word 1 */
> +	u64 wqe_ptr;
> +
> +	/* Word 2 */
> +	u64 frag_age    : 16;
> +	u64 res_32_16   : 16;
> +	u64 pf_func     : 16;
> +	u64 il3_off     : 8;
> +	u64 fi_pad      : 3;
> +	u64 fi_offset   : 5;
> +
> +	/* Word 3 */
> +	u64 hw_ccode    : 8;
> +	u64 uc_ccode    : 8;
> +	u64 res3_32_16  : 16;
> +	u64 spi         : 32;
> +
> +	/* Word 4 */
> +	u64 misc;
> +};
> +
>  /* CPT LF_INPROG Register */
>  #define CPT_LF_INPROG_INFLIGHT	GENMASK_ULL(8, 0)
>  #define CPT_LF_INPROG_GRB_CNT	GENMASK_ULL(39, 32)

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c

...

> @@ -355,8 +359,25 @@ static void otx2_rcv_pkt_handler(struct otx2_nic *pfvf,
>  	if (unlikely(!skb))
>  		return;
>  
> -	start = (void *)sg;
> -	end = start + ((cqe->parse.desc_sizem1 + 1) * 16);
> +	if (parse->chan & 0x800) {
> +		orig_pkt_wqe = cn10k_ipsec_process_cpt_metapkt(pfvf, sg, skb, cq->cq_idx);
> +		if (!orig_pkt_wqe) {
> +			netdev_err(pfvf->netdev, "Invalid WQE in CPT metapacket\n");
> +			napi_free_frags(napi);
> +			cq->pool_ptrs++;
> +			return;
> +		}
> +		/* Switch *sg to the orig_pkt_wqe's *sg which has the actual
> +		 * complete decrypted packet by CPT.
> +		 */
> +		sg = &orig_pkt_wqe->sg;
> +		start = (void *)sg;

I don't think this cast is necessary, start is a void *.
Likewise below.

> +		end = start + ((orig_pkt_wqe->parse.desc_sizem1 + 1) * 16);
> +	} else {
> +		start = (void *)sg;
> +		end = start + ((cqe->parse.desc_sizem1 + 1) * 16);
> +	}

The (size + 1) * 16 calculation seems to be repeated.
Perhaps a helper function is appropriate.

> +
>  	while (start < end) {
>  		sg = (struct nix_rx_sg_s *)start;
>  		seg_addr = &sg->seg_addr;
> -- 
> 2.43.0
> 
> 
