Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D72D72E6116;
	Tue, 28 Oct 2025 11:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761649630; cv=none; b=c9cs1ATZ1vLeN39nxRRWHNjd46xF6YYYDTCZEfHJ3LmxDDrtdiZnV532Kt3d8cCDUnNGETxYeNl67DbTndi8rmuXuWmjHNMbs2rFQZqCWj36XOpPh4If9VXlLRgF3Apqs8l06GyoYjAolNsg67rfN+jSmNl5a57+LNhzCo09NDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761649630; c=relaxed/simple;
	bh=XrDeXUAz1gW14qAkxtVwQxgLfa17cc5daLO4wKUsFcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epaJyCrUn8AFpcD/S86MpNKOJiQDAMRPy3stFYblH1tyGlCNeUAi3xByWYGP+/Jm5tOY0hpVLVvqH1pKZimFW0+MZ43FtxjrDlIHbKccaNiuvyPEJzz6Nw/vef9hdbhI3OU+IPxjcdg/7zwr41YdGO8cd/Nr7Ah3xRagf96qbew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eW4CVVVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eW4CVVVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8698C4CEE7;
	Tue, 28 Oct 2025 11:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761649630;
	bh=XrDeXUAz1gW14qAkxtVwQxgLfa17cc5daLO4wKUsFcU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eW4CVVVqEg8ZEbiR09r/lUkDmhBMNvFjRxnItf3KVaRg9jlBinatc5RsvFzi7kMrG
	 fHtMiGummm15fAXrCAhzsWNbah03kExVIzwvr7ITRHDhfOrcvdCQNrhpqwXRvnAKVT
	 jShGFkPBcw6MWFYlWlAwOKfy6Bt2sW8+hqCE4qc5/NqbEEZnLPFpC1/Xmuc/e8Afgm
	 ixXC1HGIANTFWBAsa9n760YrjGv6O+DuPLa8tF8kCgex9gbEjS+/OGk5YMOBHqXvn0
	 S3LEdbk9qxXoETi/kZwxTz/dvc4oVjUahYMSRq4bHS5DIitNI+sIwPPfXgKeifEjTJ
	 QrzO/ofnJXMnQ==
Date: Tue, 28 Oct 2025 11:07:06 +0000
From: Simon Horman <horms@kernel.org>
To: Tanmay Jagdale <tanmay@marvell.com>
Cc: davem@davemloft.net, leon@kernel.org, herbert@gondor.apana.org.au,
	bbhushan2@marvell.com, sgoutham@marvell.com,
	linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
	Rakesh Kudurumalla <rkudurumalla@marvell.com>
Subject: Re: [PATCH net-next v5 05/15] octeontx2-af: Add support for CPT
 second pass
Message-ID: <aQCj2iRMRR8pFhhQ@horms.kernel.org>
References: <20251026150916.352061-1-tanmay@marvell.com>
 <20251026150916.352061-6-tanmay@marvell.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026150916.352061-6-tanmay@marvell.com>

On Sun, Oct 26, 2025 at 08:39:00PM +0530, Tanmay Jagdale wrote:
> From: Rakesh Kudurumalla <rkudurumalla@marvell.com>
> 
> Implemented mailbox to add mechanism to allocate a
> rq_mask and apply to nixlf to toggle RQ context fields
> for CPT second pass packets.
> 
> Signed-off-by: Rakesh Kudurumalla <rkudurumalla@marvell.com>
> Signed-off-by: Tanmay Jagdale <tanmay@marvell.com>

...

> diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> index c3d6f363bf61..95f93a29a00e 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
> @@ -6632,3 +6632,128 @@ void rvu_block_bcast_xon(struct rvu *rvu, int blkaddr)
>  	cfg = rvu_read64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(0));
>  	rvu_write64(rvu, blkaddr, NIX_AF_RX_CHANX_CFG(0), cfg);
>  }
> +
> +static inline void
> +configure_rq_mask(struct rvu *rvu, int blkaddr, int nixlf,
> +		  u8 rq_mask, bool enable)

Hi Rakesh and Tanmay,

Please don't use inline in C files unless there is a demonstrable - usually
performance - reason to do so.  Rather, please let the compiler inline code
as it sees fit.

> +{
> +	u64 cfg, reg;
> +
> +	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf));
> +	reg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_CFG(nixlf));
> +	if (enable) {
> +		cfg |= NIX_AF_LFX_RX_IPSEC_CFG1_RQ_MASK_ENA;
> +		reg &= ~NIX_AF_LFX_CFG_RQ_CPT_MASK_SEL;
> +		reg |= FIELD_PREP(NIX_AF_LFX_CFG_RQ_CPT_MASK_SEL, rq_mask);
> +	} else {
> +		cfg &= ~NIX_AF_LFX_RX_IPSEC_CFG1_RQ_MASK_ENA;
> +		reg &= ~NIX_AF_LFX_CFG_RQ_CPT_MASK_SEL;
> +	}
> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf), cfg);
> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_CFG(nixlf), reg);
> +}
> +
> +static inline void
> +configure_spb_cpt(struct rvu *rvu, int blkaddr, int nixlf,
> +		  struct nix_rq_cpt_field_mask_cfg_req *req, bool enable)

Here too.

> +{
> +	u64 cfg;
> +
> +	cfg = rvu_read64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf));
> +
> +	/* Clear the SPB bit fields */
> +	cfg &= ~NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_ENA;
> +	cfg &= ~NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_SZM1;
> +	cfg &= ~NIX_AF_LFX_RX_IPSEC_CFG1_SPB_AURA;
> +
> +	if (enable) {
> +		cfg |= NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_ENA;
> +		cfg |= FIELD_PREP(NIX_AF_LFX_RX_IPSEC_CFG1_SPB_CPT_SZM1,
> +				  req->ipsec_cfg1.spb_cpt_sizem1);
> +		cfg |= FIELD_PREP(NIX_AF_LFX_RX_IPSEC_CFG1_SPB_AURA,
> +				  req->ipsec_cfg1.spb_cpt_aura);
> +	}
> +
> +	rvu_write64(rvu, blkaddr, NIX_AF_LFX_RX_IPSEC_CFG1(nixlf), cfg);
> +}

...
