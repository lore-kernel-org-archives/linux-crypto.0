Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEC21FFC55;
	Fri, 20 Jun 2025 11:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750417622; cv=none; b=WDx+RseG/u32Z8O4A9dj7VmvzC2kJmEgN/ExSKlKXQrVAI8dee+b2Fe+WVbz8oggZVaOSVu+2IszrICI4atQ+CWaPC7CxLGRvVAGy1WYa7L26A8BWNu0RjVGexBQaH8W/F5HcuXiKddKSSZ7l2PYCi0nxyTTgs+1MEQPHROEVSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750417622; c=relaxed/simple;
	bh=Ai6LeAatdlN5UhFpngXz6QQ59dKt8p/g/rUC4YJy8P4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NidjjDfgxx81ALX5YCNE7DtoS7P4hnKzQrwVNbxW1ruvjSff198B5aK/DM7Z0UXJA5jA8kc0IXzhE0+zlMKRLI2rPv8sns7lS0C+soDaq32DURHTxFWrwsMeVwYeLXJn86W7wrvcuUyV8hT8bMLxDtu3hitjSPj0KhNn47pyWtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L6jThI+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L6jThI+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10E33C4CEE3;
	Fri, 20 Jun 2025 11:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750417621;
	bh=Ai6LeAatdlN5UhFpngXz6QQ59dKt8p/g/rUC4YJy8P4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L6jThI+O5tVSQEnnfIDWs98oZYvCwQhb3MMjzYi9fCkwf3bq+hqRYjavmsNtPkgVK
	 9Y2TLVZcQ8Oz55O9Sc8lpE2d1asIkJ+nNUS76fG551yXRAWKBrYNVIdOyWdRAeXq8k
	 nYKoelFvF53V20TB+7T80ICy6HITDGUF69fWVla2Fsjp6PY5E2hQK4C5UTGZ67/wDR
	 X+cbI+NrilA19Q0tQFJbOOhQhAN5M1E1eBhSVJmoBytCWw+7ah+hkWEnjLppJJA4qW
	 jfCyQyZms5G5tsUmkPZjk/g5bkzhkVEnuHwvMa1Q6peBTEcab2ib+cDsxYh1OwHNtL
	 M9/tWpm4wuVkA==
Date: Fri, 20 Jun 2025 12:06:57 +0100
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: davem@davemloft.net, leon@kernel.org, sgoutham@marvell.com,
	bbhushan2@marvell.com, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 12/14] octeontx2-pf: ipsec: Process CPT
 metapackets
Message-ID: <20250620110657.GK194429@horms.kernel.org>
References: <20250618113020.130888-1-tanmay@marvell.com>
 <20250618113020.130888-13-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250618113020.130888-13-tanmay@marvell.com>

On Wed, Jun 18, 2025 at 05:00:06PM +0530, Tanmay Jagdale wrote:
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
> Changes in V2:
> - Removed unnecessary casts
> - Don't convert complete cpt_parse_hdr from BE to LE and just
>   convert required fields
> - Fixed logic to avoid repeated calculation for start and end in sg
> 
> V1 Link: https://lore.kernel.org/netdev/20250502132005.611698-15-tanmay@marvell.com/
> 
>  .../marvell/octeontx2/nic/cn10k_ipsec.c       | 52 +++++++++++++++++++
>  .../marvell/octeontx2/nic/cn10k_ipsec.h       | 48 +++++++++++++++++
>  .../marvell/octeontx2/nic/otx2_common.h       |  2 +
>  .../marvell/octeontx2/nic/otx2_struct.h       | 16 ++++++
>  .../marvell/octeontx2/nic/otx2_txrx.c         | 29 +++++++++--
>  5 files changed, 144 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> index 5cb6bc835e56..a95878378334 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.c
> @@ -346,6 +346,58 @@ static int cn10k_outb_cpt_init(struct net_device *netdev)
>  	return ret;
>  }
>  
> +struct nix_wqe_rx_s *cn10k_ipsec_process_cpt_metapkt(struct otx2_nic *pfvf,
> +						     struct nix_cqe_rx_s *cqe,
> +						     struct sk_buff *skb,
> +						     int qidx)
> +{
> +	struct nix_rx_sg_s *sg = &cqe->sg;
> +	struct nix_wqe_rx_s *wqe = NULL;
> +	u64 *seg_addr = &sg->seg_addr;
> +	struct cpt_parse_hdr_s *cptp;
> +	struct xfrm_offload *xo;
> +	struct xfrm_state *xs;
> +	struct sec_path *sp;
> +	void *va;
> +
> +	/* CPT_PARSE_HDR_S is present in the beginning of the buffer */
> +	va = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain, *seg_addr));
> +
> +	cptp = (struct cpt_parse_hdr_s *)va;
> +
> +	/* Convert the wqe_ptr from CPT_PARSE_HDR_S to a CPU usable pointer */
> +	wqe = phys_to_virt(otx2_iova_to_phys(pfvf->iommu_domain,
> +					     be64_to_cpu(cptp->wqe_ptr)));

Hi Tanmay,

be64_to_cpu expects a __be64 argument, but the type of cptp->wqe_ptr is u64.
Or, IOW, be64_to_cpu expects to be based a big endian value but
the type of it's argument is host byte order.

> +
> +	/* Get the XFRM state pointer stored in SA context */
> +	xs = pfvf->ipsec.inb_sa->base +
> +	     (be32_to_cpu(cptp->cookie) * pfvf->ipsec.sa_tbl_entry_sz) + 1024;

Likewise with cookie here.

:Flagged by Sparse.

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h b/drivers/net/ethernet/marvell/octeontx2/nic/cn10k_ipsec.h

...

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
